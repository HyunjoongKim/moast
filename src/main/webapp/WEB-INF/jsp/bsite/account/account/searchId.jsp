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
	if ($("#userName").val() == "") {
		alert("이름을 입력해주세요.");
		$("#userName").focus();
		return false;
	}
}
</script>

					<!-- cont-top -->
					<div class="cont-top">
						<h2 class="cont-tit">아이디 찾기</h2>
					</div>
					<!-- cont-top //-->

					<div id="cont">	
						<div id="member-find-wrap">
							<!-- find-box -->
							<div class="find-box login_form">
								<div class="find-id loin_box">
									<form name="loginform" action ="${path}/account/searchIdResult.do" method="post" onsubmit="return frmCheck();">
	    							<input type="hidden" name="requestURL" id="requestURL" value="${requestURL}" />
										<h4>가입 시 입력한 이름을 입력해주세요.</h4>
										<div class="input-sec">
											<ul>
												<li><label for="" class="blind">이름</label><input type="text" name="userName" id="userName" class="inputEm text" maxlength="16" title="이름를 입력하세요" placeholder="이름을 입력하세요" /></li>
											</ul>
											<input type="submit" class="btnEmBlue lg-btn" value="아이디 찾기" />
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
	    	<form name="loginform" action ="${path}/account/searchIdResult.do" method="post" onsubmit="return frmCheck();">
	    	<input type="hidden" name="requestURL" id="requestURL" value="${requestURL}" />
		        <p>가입 시 입력한 이름을 입력해주세요.</p>
		        
				<input type="text" name="userName" id="userName" class="inputEm" maxlength="16" title="이름를 입력하세요" placeholder="이름을 입력하세요" />
		        <div class="button"><input type="submit" class="btnEmBlue" value="찾기" /></div>
	        </form>
	    </div>
	</div>
</div> 
 --%>
