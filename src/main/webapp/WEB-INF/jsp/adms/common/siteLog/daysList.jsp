<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />


<script type="text/javascript">
	function fn_search(){
		var year = $("#log_year").val();
		var month = $("#log_month").val();
		$("#search_date").val(year+"-"+month);
		console.log($("#search_date").val());
		$("#listForm").submit();
		return false;
	}
</script>	

<form:form commandName="searchVO" method="get" name="listForm" id="listForm" action="${path}/adms/common/sitelog/days/list.do">
<input type="hidden" name="search_date" id="search_date"/>

	<div class="panel">
		<div class="panel-body">
			<div class="form-inline" >
				<div class="form-group">
					<label class="control-label" for=""><spring:message code="log.site" text="사이트" /></label>
					<select name="search_siteCode" id="search_siteCode" class="form-control"  style="width:300px">
						<c:forEach var="result" items="${siteCodeList}" varStatus="status">
				       		<option value="${result.site_code }" ${result.site_code eq searchVO.search_siteCode ? 'selected' : ''}>${result.ts_title }</option>
						</c:forEach>
					</select>	
				</div>
				
				<div class="form-group m-l-10">
					<label class="control-label" for=""><spring:message code="log.year" text="년도" /></label>
					<select name="log_year" id="log_year" class="form-control" >		 
						<c:forEach var="item" varStatus="i"  begin="2016" end="${year}" step="1">
				       		<option value="${item}" ${item eq searchVO.log_year ? 'selected' : ''}>${item}</option>
						</c:forEach>
					</select>	
				</div>
				
				<div class="form-group m-l-10">
					<label class="control-label" for=""><spring:message code="log.month2" text="월" /></label>
					<select name="log_month" id="log_month" class="form-control" >	  
						<c:forEach var="item" varStatus="i"  begin="1" end="12" step="1">
				       		<option value="${item}" ${item eq searchVO.log_month ? 'selected' : ''}>${item}</option>
						</c:forEach>
					</select>	
				</div>
	
				<div class="form-group">
					<a href="#" onclick="fn_search();" class="btn btn-dark" style="height:38px;"><spring:message code="btn.search" text="검색" /></a>
			    	<%-- <a href="${path}/adms/common/sitelog/days/excelDown.do?search_siteCode=${searchVO.search_siteCode}&search_date=${searchVO.search_date}&dateType=days" class="btn btn-warning" style="height:38px;"><spring:message code="btn.exceldown" text="엑셀다운로드" /></a> --%>	
		    	</div>
			</div>
		</div>
	</div>
	
	<div class="panel">
		<div class="panel-body">
			<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="log.stat.day" text="일별통계" /></h4>	
			<div class="table-responsive">
				<table id="datatable-scroller" class="table table-striped table-bordered text-center">
					<caption>권한 목록</caption>
					<colgroup>
						<col  width="80px">
						<col  width="150px">
						<col />
						<col width="100px">
						<col width="100px">
					</colgroup>
					<thead>
						<tr>
							<th>No</th>
							<th><spring:message code="log.day" text="일별" /></th>
							<th><spring:message code="log.menu.graph" text="그래프" /></th>
							<th><spring:message code="log.menu.cnt" text="접속수" /></th>
							<th><spring:message code="log.menu.per" text="비율" /></th>						
						</tr>
					</thead>
					<tbody>
						<c:set var="ii" value="${fn:length(resultList)}" />
						<c:set var="total" value="0" />
						<c:forEach var="result" items="${resultList}" varStatus="status">
						<tr>
							<td><c:out value="${ii}"/></td>
							<td><c:out value="${result.cdate}"/></td>
							<td><div style="width:${result.ratio}%; background-color:#9F81F7; height:10px; margin-bottom:2px">&nbsp;</div></td>
							<td><c:out value="${result.total}"/></td>
							<td><c:out value="${result.ratio}"/></td>				
						</tr>			
						<c:set var="ii" value="${ii - 1}" />
					</c:forEach>				
						<tr>
						<td></td>
						<td colspan="2"><spring:message code="log.total" text="총합계" /></td>
						<td>${resultCnt}</td>
						<td></td>
						</tr>
					<c:if test="${fn:length(resultList) == 0}">
						<tr>
							<td colspan="6"><spring:message code="list.noResult" text="No search results found." /></td>
						</tr>
					</c:if>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form:form>	