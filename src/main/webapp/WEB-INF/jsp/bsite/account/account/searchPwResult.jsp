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
						<h2 class="cont-tit">비밀번호 찾기</h2>
					</div>
					<!-- cont-top //-->

					<div id="cont">	
						<div id="member-find-wrap">
							<!-- find-box -->
							<div class="find-box login_form">
								<div class="find-id loin_box">
									<h4>회원명 [${userName}]의 비밀번호 조회 결과입니다.</h4>
									<div class="input-sec">
										<c:if test="${memberVO == null}">
											<p class="g-box pad20a">조회 결과가 없습니다.</p>
										</c:if>
										<c:if test="${memberVO != null}">
											<p class="g-box pad20a">${memberVO.me_email}로 메일 발송하였습니다.</p>
											<p><a href="${path}/account/login.do">로그인 바로가기</a></p>
										</c:if>
									</div>
								</div>
							</div>
						</div> 
					</div>


<%--
<div class="">
	<div class="login_form" style="margin-bottom:100px">
	    <div class="loin_box">
	    	<c:if test="${memberVO == null}">
				<p class="g-box pad20a">조회 결과가 없습니다.</p>
			</c:if>
			<c:if test="${memberVO != null}">
				<p class="g-box pad20a">${memberVO.me_email}로 메일 발송하였습니다.</p>
				<p><a href="${path}/account/login.do">로그인 바로가기</a></p>
			</c:if>
	    </div>
	</div>
</div> 
--%>