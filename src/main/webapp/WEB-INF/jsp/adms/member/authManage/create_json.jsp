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
	var qustr = "${searchVO.qustr}";
	
	$(function(){
		
	});
	
	function _onSubmit(){
		if($("#auth_title").val() == ""){
			alert("권한명을 입력해주세요.");
			$("#auth_title").focus();
			return false;
		}
		
		if(!confirm("저장하시겠습니까?")){
			return false;
		}
		
		var submitObj = new Object();
		submitObj.auth_title= $("#auth_title").val();
		submitObj.auth_order= $("#auth_order").val();
		submitObj.auth_group= $("#auth_group").val();
		submitObj.auth_etc= $("#auth_etc").val();
		
		$.ajax({ 
	      	  url: path+"/adms/member/authManage/create_actionJson.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(submitObj),
	      	  dataType : "json"
	      	 }) 
	      	 .done(function(resMap) {
	      		alert(resMap.msg);
	      		if(resMap.res == "ok") location.replace(path+"/adms/member/authManage/list.do");
	      	 }) 
	      	 .fail(function(e) {  
	      		 alert("등록 시도에 실패하였습니다."+e);
	      	 }) 
	      	 .always(function() { 
	      		 pass =  false;
	      	 }); 
		
	}
	
</script>


<div id="contAreaBox">
	<form name="inputForm" method="post" >
		<div class="panel">
			<div class="panel-body">
				<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> 권한관리</h4>
		 		<div class="alert alert-info" >
				  	<spring:message code="txt.guideRequire" text="표시는 필수 입력 항목 입니다." />
				</div>
				
				<div class="table-responsive">
					<table id="datatable-scroller" class="table table-bordered">
						<caption>권한관리</caption>
						<colgroup>
							<col width="250px" />
							<col />
						</colgroup>
				 		<tbody>
							<tr>
								<th class="active" style="text-align:right"><label class="control-label col-sm-1" for=""><span class="ftcdanger">*</span> 권한명</label>
								<td class="form-inline"><input type="text" id="auth_title" name="auth_title" class="form-control "/> <input type="text" id="auth_code" name="auth_code"  class="form-control "/></td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label col-sm-1" for="">순번</label>
								<td><input type="text" id="auth_order" name="auth_order" value="1" class="form-control "/></td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label col-sm-1" for="">권한그룹</label>
								<td><input type="text" id="auth_group" name="auth_group" class="form-control "/></td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label col-sm-1" for="">비고</label>
								<td><input type="text" id="auth_etc" name="auth_etc" class="form-control "/></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		<div class="pull-right">
			<a href="javascript:void(0);" onclick="_onSubmit();return false;" class="btn btn btn-primary btn-lg" />저장</a>
			<a href="${path}/adms/member/authManage/list.do"class="btn btn btn-primary btn-lg" />취소</a>
		</div>
	</form>
</div>
