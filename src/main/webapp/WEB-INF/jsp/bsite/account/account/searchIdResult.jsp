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
									<h4>회원명 [${userName}]의 아이디 조회 결과입니다.</h4>
									<div class="input-sec">
										<c:forEach var="result" items="${memberVOList}" varStatus="status">
										<p class="g-box pad20a">${fn:substring(result.me_id, 0, 3)}***** </p>
										</c:forEach>
										<c:if test="${fn:length(memberVOList) == 0}">
										<p class="g-box pad20a">조회 결과가 없습니다.</p>
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
	    	<p>회원명 [${userName}]의 ID 조회 결과입니다.</p>
	    	<c:forEach var="result" items="${memberVOList}" varStatus="status">
	    	 <p>${fn:substring(result.me_id, 0, 3)}***** </p>
	    	</c:forEach>
	    	<c:if test="${fn:length(memberVOList) == 0}">
			<p>조회 결과가 없습니다.</p>
		</c:if>
	    </div>
	</div>
</div>
 --%>