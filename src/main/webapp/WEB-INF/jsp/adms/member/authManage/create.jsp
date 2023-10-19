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
		if($("#auth_code").val() == ""){
			alert(gTxt("auth.validate.code"));
			$("#auth_code").focus();
			return false;
		}
		
		if($("#codeCntRes").val() == ""){
			alert(gTxt("auth.validate.dup"));
			$("#codeCntRes").focus();
			return false;
		}
		
		if($("#codeCntRes").val() == "false"){
			alert(gTxt("auth.validate.re"));
			$("#auth_code").focus();
			return false;
		}
		
		if($("#auth_title").val() == ""){
			alert(gTxt("auth.validate.name"));
			$("#auth_title").focus();
			return false;
		}
		
		if(!confirm(gTxt("confirm.save"))){
			return false;
		}
	}
	
	function checkDupCode(){
		if($("#auth_code").val() == ""){
			alert(gTxt("auth.validate.code"));
			$("#auth_code").focus();
			return false;
		}
		
		var authCode = $("#auth_code").val();
		
		var submitObj = new Object();
		submitObj.auth_code= authCode;
		
		$.ajax({ 
	      	  url: path+"/adms/member/authManage/create_getCodeCnt.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(submitObj),
	      	  dataType : "json",
	      	  async: false
	      	 }) 
	      	 .done(function(resMap) {
	      		if(resMap.res == "ok"){
	      			if(resMap.cnt == 0){
	      				$("#codeCntRes").val("true");
	      				$("#codeCntTxt").text(gTxt("txt.available"));
	      				$("#auth_code").attr("readonly","readonly");
	      			}else{
	      				$("#codeCntRes").val("false");
	      				$("#codeCntTxt").text(gTxt("txt.unavailable"));
	      			}
	      		}
	      	 }) 
	      	 .fail(function(e) {  
	      		 alert("FAIL - "+e);
	      	 }) 
	      	 .always(function() { 
	      		 pass =  false;
	      	 }); 
		
	}
	
</script>


<div id="contAreaBox">
	<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/adms/member/authManage/create_action.do" class="form-horizontal">	
		<div class="panel">
			<div class="panel-body">
				<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="sysmenu.auth.manage" text="회원권한관리" /></h4>
		 		<div class="alert alert-info" >
				  	<spring:message code="txt.guideRequire" text="표시는 필수 입력 항목 입니다." />
				</div>
				
				<div class="table-responsive">
					<table id="datatable-scroller" class="table table-bordered">
						<caption> 게시판관리</caption>
						<colgroup>
							<col width="250px" />
							<col />
						</colgroup>
				 		<tbody>
					 		<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="auth.code" text="권한코드" /></label></th>
								<td class="form-inline">
									<input type="text" id="auth_code" name="auth_code"  class="form-control" style="width:300px" />
									<a href="javascript:void(0);" onclick="checkDupCode();return false;"  class="btn btn-dark" style="height:36px"><spring:message code="btn.checkDup" text="중복체크" /></a>
									<input type="hidden" id="codeCntRes" name="codeCntRes" value="" /> 
									<span id="codeCntTxt"></span>
								</td>
							</tr>
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="auth.name" text="권한명" /></label></th>
								<td>
									<input type="text" id="auth_title" name="auth_title"  class="form-control "/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="auth.ordr" text="순번" /></label></th>
								<td>
									<input type="text" id="auth_order" name="auth_order" value="1"  class="form-control "/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="auth.group" text="그룹" /></label></th>
								<td>
									<input type="text" id="auth_group" name="auth_group" class="form-control "/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="auth.etc" text="비고" /></label></th>
								<td>
									<input type="text" id="auth_etc" name="auth_etc"  class="form-control "/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		<div class="pull-right">
			<input type="submit" value="<spring:message code="btn.save" text="저장" />"  class="btn btn btn-primary btn-lg" />
			<a href="${path}/adms/member/authManage/list.do" class="btn btn btn-primary btn-lg"><spring:message code="btn.cancel" text="취소" /></a>
		</div>
	</form>
</div>
