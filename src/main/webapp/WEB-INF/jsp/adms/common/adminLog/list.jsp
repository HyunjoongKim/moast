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
	var path = "${pageContext.request.contextPath }";
	
	
	$(function(){
		$("#sdate").datepicker();
		$("#edate").datepicker();
	});
	
	function fn_go_page(pageNo) {
		$("#pageIndex").val(pageNo);
		$("#listForm").submit();
		return false;
	}
	
	function fn_search(){
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		
		if(sdate > edate){		
			alert(gTxt("adminlog.validate.date"));
			$("#edate").focus();
			return false;			
		} 
		
		$("#pageIndex").val("1");
		$("#listForm").submit();
		return false;
	}
	
		
</script>

<form:form commandName="searchVO" method="get" name="listForm" id="listForm" action="${path}/adms/common/adminlog/list.do">
	<div class="panel">
		<div class="panel-body">
			<div class="form-horizontal">
				<div class="row">
					<div class="col-sm-4">
						<div class="form-group">
							<label class="control-label col-sm-2" for=""><spring:message code="adminlog.id" text="아이디" /></label>
							<div class="col-md-10">   
								<input type="text" name="searchId" id="searchId"  value="${searchVO.searchId}" class="form-control">       
							</div>
						</div>
						
						<div class="form-group">
							<label class="control-label col-sm-2" for=""><spring:message code="adminlog.contents" text="접근컨텐츠" /></label>
							<div class="col-md-10">   
								<select name="searchMenuCode" id="searchMenuCode" class="form-control">    
									<option value="">==SELECT==</option>
									<c:forEach var="result" items="${menuCodeList}" varStatus="status">
										<option value="${result.main_code }" ${result.main_code eq searchVO.searchMenuCode ? 'selected' : ''}>${result.code_name } </option>                    	
					        	    </c:forEach>																		
								</select> 
							</div>
						</div>
					</div>
					
					<div class="col-sm-4">
						<div class="form-group">
							<label class="control-label col-sm-2" for=""><spring:message code="adminlog.type" text="구분" /></label>
							<div class="col-md-10">   
								<select name="searchGubun" id="searchGubun" class="form-control">    
									<option value="">==SELECT==</option>
									<c:forEach var="result" items="${gubunList}" varStatus="status">
										<option value="${result.main_code }" ${result.main_code eq searchVO.searchGubun ? 'selected' : ''}>${result.code_name } </option>                    	
					        	    </c:forEach>																		
								</select> 
							</div>
						</div>
						
						<div class="form-group">
							<label class="control-label col-sm-2" for=""><spring:message code="adminlog.text" text="내용" /></label>
							<div class="col-md-10">   
								<input type="text" name="searchInfor" id="searchInfor"  value="${searchVO.searchInfor}" class="form-control">    
							</div>
						</div>
					</div>
					
					<div class="col-sm-4">
						<div class="form-group">
							<label class="control-label col-sm-2" for="">IP</label>
							<div class="col-md-10">   
								 <select name="searchIp" id="searchIp" class="form-control">>    
									<option value="">==SELECT==</option>
									<c:forEach var="ipList" items="${ipList}" varStatus="status">				
										<option value="${ipList}" ${ipList eq searchVO.searchIp  ? 'selected' : ''} >${ipList}</option>													 
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label class="control-label col-sm-2" for=""><spring:message code="adminlog.period" text="기간" /></label>
							<div class="col-md-10 form-inline">   
								<input type="text" id="sdate" name="searchSdate" readonly="readonly" style="width:40%" value="${searchVO.searchSdate}" class="form-control" /> ~	
								<input type="text" id="edate" name="searchEdate" readonly="readonly" style="width:40%" value="${searchVO.searchEdate}" class="form-control" />
							</div>
						</div>
					</div>
					
					<div class="text-center">
						<a href="#" onclick="fn_search();" class="btn btn-dark btn-lg"><spring:message code="btn.search" text="검색" /></a>
						<%-- <a href="${path}/adms/common/adminlog/excelDown.do?searchMenuCode=${searchVO.searchMenuCode}&searchGubun=${searchVO.searchGubun}&searchInfor=${searchVO.searchInfor}&searchIp=${searchVO.searchIp}&searchSdate=${searchVO.searchSdate}&searchEdate=${searchVO.searchEdate}" class="btn btn-warning btn-lg"><spring:message code="btn.exceldown" text="엑셀다운로드" /></a> --%>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="panel">
		<div class="panel-body">
			<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="adminlog.admin" text="관리자로그기록" /></h4>	
			<div class="table-responsive">
				<table id="datatable-scroller" class="table table-striped table-bordered text-center">
					<caption>목록</caption>
					<colgroup>
						<col width="50px">
						<col width="150px">
						<col width="150px">
						<col width="100px">			
						<col />
						<col width="150px">
						<col width="200px">
					</colgroup>
					<thead>
						<tr>
							<th>No</th>
							<th><spring:message code="adminlog.id" text="아이디" /></th>
							<th><spring:message code="adminlog.contents" text="접근컨텐츠" /></th>
							<th><spring:message code="adminlog.type" text="구분" /></th>			
							<th><spring:message code="adminlog.text" text="내용" /></th>			
							<th>IP</th>			
							<th><spring:message code="adminlog.create" text="등록날짜" /></th>						
						</tr>
					</thead>
					<tbody>
						<c:set var="ii" value="${resultCnt - (searchVO.pageIndex -1) * paginationInfo.recordCountPerPage }" />
						<c:forEach var="result" items="${resultList}" varStatus="status">
						<tr>
							<td><c:out value="${ii}"/></td>
							<td><c:out value="${result.cret_id}"/></td>
							<td>
								<c:choose>
								    <c:when test="${result.menu_code eq  'login'}">로그인</c:when>
								    <c:when test="${result.menu_code eq  'member'}">회원관리</c:when>										    
									<c:otherwise></c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
								    <c:when test="${result.gubun eq  1}">로그인	</c:when>
								    <c:when test="${result.gubun eq  2}">목록</c:when>
								    <c:when test="${result.gubun eq  3}">보기	</c:when>
								    <c:when test="${result.gubun eq  4}">생성폼</c:when>
								    <c:when test="${result.gubun eq  5}">저장</c:when>
								    <c:when test="${result.gubun eq  6}">수정폼</c:when>
								    <c:when test="${result.gubun eq  7}">수정</c:when>
								    <c:when test="${result.gubun eq  8}">삭제</c:when>
									<c:when test="${result.gubun eq  9}">다운로드</c:when>					    
									<c:when test="${result.gubun eq  10}">업로드</c:when>
									<c:otherwise></c:otherwise>
								</c:choose>
			 
							</td>
							<td><c:out value="${result.infor}"/> </td>
							<td><c:out value="${result.cret_ip}"/></td>				
							<td><c:out value="${result.cret_date}"/></td>
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
				<span><spring:message code="list.totalCnt" text="총 게시물  " /> <fmt:formatNumber value="${resultCnt}" type="number" /> / <spring:message code="list.page" text="페이지 " />(<c:out value="${searchVO.pageIndex}"/>/<c:out value="${totalPageCnt}"/>)</span>
			</div>
			<div class="pull-right">
				<form:hidden path="pageIndex" />
				<ol class="pagination" id="pagination">
					<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_go_page" />
				</ol>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
</form:form>