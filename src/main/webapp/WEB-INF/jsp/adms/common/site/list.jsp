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
	
	function fn_delete(ts_pkid){
		if(!confirm(gTxt("confirm.delete"))) return false;
		
		var submitObj = new Object();
		submitObj.ts_pkid= ts_pkid;
		
		$.ajax({ 
	      	  url: path+"/adms/common/site/delete_action.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(submitObj),
	      	  dataType : "json"
	      	 }) 
	      	 .done(function(resMap) {
	      		 alert(resMap.msg);
	      		alert(gTxt(resMap.msg));
	      		location.reload();
	      	 }) 
	      	 .fail(function(e) {  
	      		alert(gTxt("ra.fail.res.detail"));
	      	 }) 
	      	 .always(function() { 
	      		 pass =  false;
	      	 }); 
		
	}

	
</script>

<form:form commandName="searchVO" method="get" name="listForm" id="listForm" action="${path}/adms/common/site/list.do">
	<div class="panel">
		<div class="panel-body">
			<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i><spring:message code="sysmenu.site.manage" text="사이트관리" /></h4>
			<div class="table-responsive">
				<table id="datatable-scroller" class="table table-striped table-bordered text-center">
				<caption>목록</caption>
					<colgroup>
						<col>
						<col>
						<col>
						<col>
						<col> 
						<col width="10%">
					</colgroup>
				<thead>
					<tr>
						<th>No</th>
						<th><spring:message code="site.name" text="사이트명" /></th>
						<th><spring:message code="site.domain" text="도메인" /></th>
						<!-- <th>사용여부</th> -->
						<th><spring:message code="site.code" text="사이트코드" /></th>
						<th><spring:message code="site.remarks" text="비고" /></th>
						<th><spring:message code="site.manage" text="관리" /></th> 
					</tr>
				</thead>
				<tbody>
					<c:set var="ii" value="${resultCnt - (searchVO.pageIndex -1) * paginationInfo.recordCountPerPage }" />
					<c:forEach var="result" items="${resultList}" varStatus="status">
						<tr>
							<td><c:out value="${ii}"/></td>
							<td><c:out value="${result.ts_title}"/></td>
							<td><c:out value="${result.ts_domain}"/></td>
							<%-- <td><c:out value="${result.ts_stat_yn}"/></td> --%>
							<td><c:out value="${result.site_code}"/></td>
							<td><c:out value="${result.ts_etc}"/></td>
							<td>
								<a href="${path}/adms/common/site/update.do?ts_pkid=${result.ts_pkid}&${qustr}" class="btn btn-success btn-sm"><spring:message code="btn.modify" text="수정" /></a>
								<a href="javascript:void(0);" onclick="fn_delete('${result.ts_pkid}');return false;"  class="btn btn-danger btn-sm"><spring:message code="btn.delete" text="삭제" /></a>
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
			</div>
			<div class="pull-left mt10">
				<span><spring:message code="list.totalCnt" text="총 게시물 " /> <fmt:formatNumber value="${resultCnt}" type="number" /> / <spring:message code="list.page" text="페이지 " />(<c:out value="${searchVO.pageIndex}"/>/<c:out value="${totalPageCnt}"/>)</span>
			</div>
			<div class="pull-right">
				<ol class="pagination pagination-sm" id="pagination">
					<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_go_page" />
				</ol>
			</div>
			<div class="clearfix"></div>
		</div>
	</div><!--  end panel -->
	
	<div class="pull-right">
		<div class="btn-group dropup">
			<a href="${path}/adms/common/site/create.do" class="btn btn btn-primary btn-lg"><spring:message code="btn.create" text="등록" /></a>
		</div>
	</div>
	<div class="clearfix"></div>
</form:form>