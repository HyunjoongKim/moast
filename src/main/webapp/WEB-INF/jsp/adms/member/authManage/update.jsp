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
	
	function _onSubmit(){
		if($("#auth_title").val() == ""){
			alert(gTxt("auth.validate.name"));
			$("#auth_title").focus();
			return false;
		}
		
		if(!confirm(gTxt("confirm.save"))){
			return false;
		}
	}
	
</script>


<div id="contAreaBox">
	<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/adms/member/authManage/update_action.do?${qustr}" class="form-horizontal">	
	<input type="hidden" id="auth_idx" name="auth_idx" value="${authVO.auth_idx}" />
		<div class="panel">
			<div class="panel-body">
				<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="sysmenu.auth.manage" text="회원권한관리" /></h4>
		 		<div class="alert alert-info" >
				  	<spring:message code="txt.guideRequire" text="표시는 필수 입력 항목 입니다." />
				</div>
				
				<div class="table-responsive">
					<table id="datatable-scroller" class="table table-bordered">
						<caption>회원권한관리</caption>
						<colgroup>
							<col width="250px" />
							<col />
						</colgroup>
				 		<tbody>
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="auth.code" text="권한코드" /></label></th>
								<td>
									<input type="text" id="ts_title" name="ts_title" value="${authVO.auth_code}" disabled class="form-control"/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="auth.name" text="권한명" /></label></th>
								<td>
									<input type="text" id="auth_title" name="auth_title" value="${authVO.auth_title}" class="form-control"/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="auth.ordr" text="순번" /></label></th>
								<td>
									<input type="text" id="auth_order" name="auth_order" value="${authVO.auth_order}" class="form-control"/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="auth.group" text="그룹" /></label></th>
								<td>
									<input type="text" id="auth_group" name="auth_group" value="${authVO.auth_group}" class="form-control"/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="auth.etc" text="비고" /></label></th>
								<td>
									<input type="text" id="auth_etc" name="auth_etc" value="${authVO.auth_etc}" class="form-control"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		<div class="pull-right">
			<input type="submit" value="<spring:message code="btn.save" text="저장" />" class="btn btn btn-primary btn-lg" />
			<a href="${path}/adms/member/authManage/list.do?${qustr}" class="btn btn btn-primary btn-lg"><spring:message code="btn.cancel" text="취소" /></a>
		</div>
	</form>
</div>
