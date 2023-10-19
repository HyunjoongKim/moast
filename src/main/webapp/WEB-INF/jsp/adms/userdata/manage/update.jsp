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

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";
	
	$(document).ready(function() {
		
	});
	

	
</script>

<style>
td { height: 50px;}
</style>

<div id="contAreaBox">
	<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/adms/userdata/manage/update_action.do?${qustr}"  enctype="multipart/form-data">
		<input type="hidden" id="ud_idx" name="ud_idx" value="${dataVO.ud_idx }" />
		<div class="panel">
			<div class="panel-body">
				<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> User data Management</h4>
				<div class="alert alert-info">
				  	<spring:message code="txt.guideRequire" text="Required fields." />
				</div>
				<div class="table-responsive">
					<table id="datatable-scroller" class="table table-bordered tbl_Form">
						<caption>
							User data Management
						</caption>
						<colgroup>
							<col width="250px" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th class="active" style="text-align:right"><span class="ftcdanger">*</span>Title</th>
								<td>
								    <input type="text" id="ud_title" name="ud_title" value="${dataVO.ud_title }"  />
								</td>
				            </tr>
				            <tr>
								<th class="active" style="text-align:right">Description</th>
								<td>
								    <input type="text" id="ud_title" name="ud_title" value="${dataVO.ud_note }"  />
								</td>
				            </tr>
				            <tr>
								<th class="active" style="text-align:right">Registered date</th>
								<td>
								    ${dataVO.cret_date }
								</td>
				            </tr>
				            <tr>
								<th class="active" style="text-align:right">Status</th>
								<td>
								    <select name="ud_status" id="ud_status" class="form-control" style="width:110px;"/>
										<c:forEach var="result" items="${statusList}" varStatus="status">
								       		<option value="${result.main_code }" ${result.main_code eq dataVO.ud_status ? 'selected' : ''}>${result.code_name }</option>
										</c:forEach>
									</select>
								</td>
				            </tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		<div class="pull-right">
			<input type="submit" value="<spring:message code="btn.save" text="저장" />"  class="btn btn btn-primary btn-lg" />
			<a href="${path}/adms/userdata/manage/list.do?${qustr}" class="btn btn btn-primary btn-lg"><spring:message code="btn.cancel" text="취소" /></a>
		</div>
	</form>
</div>

