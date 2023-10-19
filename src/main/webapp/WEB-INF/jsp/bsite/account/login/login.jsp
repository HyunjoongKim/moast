<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
$(function(){
	var actionResult = "${actionResult}";
	if(actionResult == "fail") alert("Login attempt has failed."); 
	if(actionResult == "noAuth") alert("관리자 승인 후 로그인 할 수 있습니다."); 
	alertResMsg("${resMap.msg}");
	
	$('#loginform').keypress(function (e) {
		if (e.keyCode == 13) {
			_submit();
		}
	});
});

function _submit() {
	$('#loginform').submit();
}

function frmCheck() {
	if ($("#id").val() == "") {
		alert("아이디를 입력해주세요.");
		$("#id").focus();
		return false;
	}
	if ($("#password").val() == "") {
		alert("비밀번호를 입력해주세요.");
		$("#password").focus();
		return false;
	}
}
</script>


		<div class="login-box">
			<div class="login">

				<form name="loginform" id="loginform" action ="${path}/account/actionLogin.do" method="post" onsubmit="return frmCheck();">
					<div class="login-top">
						<div class="txt">
							<h6>Multi-omics <span>Bioinformatics platform</span></h6>
							<p class="notice">
								<span>This site is only available to verified members.</span>
								<span>You can use it after membership approval.</span>
							</p>
						</div>
					</div>

					<div class="input-wrap">
						<div class="dec">
							<h4 class="title">LOGIN</h4>
							<div class="input-id">
								<label for="mb_uid">ID</label>
								<input type="text" id="id" name="id" tabindex="1" placeholder="Please enter your ID">
							</div>
							<div class="input-pass">
								<label for="mb_pass">Password</label>
								<input type="password" name="password" id="password" tabindex="2" required placeholder="Please enter a password">
							</div>
						</div>

						<div class="form-group clearfix login-menu">Forgot <a href="${path }/account/searchId.do"> ID?</a> or <a href="${path }/account/searchPw.do"> Password?</a></div>

						<div class="login-btn"><a href="javascript:void(0);" onclick="_submit();"><span>LOGIN</span></a></div>
						<div class="login-btn2"><a href="${path }/account/join.do" ><span>JOIN</span></a></div>

					</div>

				</form>
			</div>
		</div>

				
			