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
	if(actionResult == "fail") alert("아이디나 비밀번호가 다릅니다."); 
	alertResMsg("${resMap.msg}");
});

function frmCheck() {
	var mail = $("#userMail").val();
	var regExp2 = /[a-z0-9]{2,}@[a-z0-9-]{2,}\.[a-z0-9]{2,}/i;
	
	if ($("#userId").val() == "") {
		alert("아이디를 입력해주세요.");
		$("#userId").focus();
		return false;
	}
	if (mail == "") {
		alert("이메일을 입력해주세요.");
		$("#userMail").focus();
		return false;
	}
	
	if (!regExp2.test(mail)){
		alert("올바른 이메일 형식이 아닙니다.");
		$("#userMail").focus();
		return false;
		}
}

</script>

					<!-- cont-top -->
					<div class="cont-top">
						<h2 class="cont-tit">비밀번호 찾기</h2>
					</div>
					<!-- cont-top //-->

					<div id="cont">	
						<div id="member-find-wrap">
							<!-- find-box -->
							<div class="find-box login_form">
								<div class="find-id loin_box">
									<form name="loginform" action ="${path}/account/searchPwResult.do" method="post" onsubmit="return frmCheck();">
	    							<input type="hidden" name="requestURL" id="requestURL" value="${requestURL}" />
										<h4>가입시 입력한 아이디와 이메일을 입력해주세요.</h4>
										<div class="input-sec">
											<ul>
												<li><label for="" class="blind">아이디</label><input type="text" name="userId" id="userId" class="inputEm text" maxlength="16" title="아이디를 입력하세요" placeholder="아이디를 입력하세요" /></li>
												<li><label for="" class="blind">이메일</label><input type="text" name="userMail" id="userMail" class="inputEm text" title="이메일를 입력하세요" placeholder="이메일을 입력하세요" /></li>
											</ul>
											<input type="submit" class="btnEmBlue lg-btn" value="비밀번호 찾기" />
										</div>
									</form>
								</div>
							</div>
						</div> 
					</div>




<%-- 
<div class="">
	<div class="login_form" style="margin-bottom:100px">
	    <div class="loin_box">
	    	<form name="loginform" action ="${path}/account/searchPwResult.do" method="post" onsubmit="return frmCheck();">
	    	<input type="hidden" name="requestURL" id="requestURL" value="${requestURL}" />
		        <p>가입시 입력한 아이디와 이메일을 입력해주세요.</p>
		        <input type="text" name="userId" id="userId" class="inputEm text" maxlength="16" title="아이디를 입력하세요" placeholder="아이디를 입력하세요" />
		        <input type="text" name="userMail" id="userMail" class="inputEm text" title="이메일를 입력하세요" placeholder="이메일을 입력하세요" />
		
		        <div class="button"><input type="submit" class="btnEmBlue" value="로그인" /></div>
	        </form>
	    </div>
	</div>
</div> 
--%>