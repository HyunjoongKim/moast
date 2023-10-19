<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";

	$(function(){
		alertResMsg("${resMap.msg}");
		
	});
	
	// 회원가입시 개인정보 수집 동의 여부 검사
	function _onSubmit(){
		var agree_1 = $("input:checkbox[name='agree_1']:checked").val();
		var agree_2 = $("input:checkbox[name='agree_2']:checked").val();
		var agree_3 = $("input:checkbox[name='agree_3']:checked").val();
		var agree_4 = $("input:checkbox[name='agree_4']:checked").val();
		var agree_5 = $("input:checkbox[name='agree_5']:checked").val();
		var agree_6 = $("input:checkbox[name='agree_6']:checked").val();
		
		if(agree_1 != "Y" || agree_2 == "Y" || agree_3 != "Y" || agree_4 == "Y" || agree_5 != "Y" || agree_6 == "Y"){
			alert("약관에 동의하지 않을 경우 가입할 수 없습니다.");
			return false;
		}
	}
	// 전체동의 체크시 동의만 체크, 해제시 전체 해제
	function allcheck(){
		var agree_all = $("input:checkbox[name='agree_all']:checked").val();
		
		if(agree_all == "Y"){
			$("input:checkbox[name='agree_1']").prop("checked",true);
			$("input:checkbox[name='agree_3']").prop("checked",true);
			$("input:checkbox[name='agree_5']").prop("checked",true);
			$("input:checkbox[name='agree_2']").prop("checked",false);
			$("input:checkbox[name='agree_4']").prop("checked",false);
			$("input:checkbox[name='agree_6']").prop("checked",false);	
		}else{
			$("input:checkbox[name='agree_1']").prop("checked",false);
			$("input:checkbox[name='agree_3']").prop("checked",false);
			$("input:checkbox[name='agree_5']").prop("checked",false);
			$("input:checkbox[name='agree_2']").prop("checked",false);
			$("input:checkbox[name='agree_4']").prop("checked",false);
			$("input:checkbox[name='agree_6']").prop("checked",false);
		}
	}
</script>


<!-- cont-top -->
<div class="cont-top">
	<h2 class="cont-tit">개인정보 수집 및 이용·제공 동의서</h2>
</div>
<!-- cont-top //-->

<div id="cont">
	<!-- 회원가입 약관 -->      
	<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/account/agree_action.do" >
		<div class="join-agree">
			<!-- agree-cont  -->	
			<div class="agree-cont">
				<!-- 내용 출력 -->            
				<div class="agree-box">
					<div class="agree-txt" tabindex="0">
						<h4 class="c-tit02">개인정보의 수집 및 이용 목적</h4>
						<p>개인정보는 개인정보보호법 제15조 및 제17조에서 정하는 바에 따라 수당지급, 세금납부, 온라인신문 뉴스레터 정기구독 등을 위한 기초 자료로 활용되며, 이외에 변경 시에는 사전 동의를 구할 것입니다.</p>

						<h4 class="c-tit02 mg30t">수집하는 개인정보의 수집 및 이용 항목(개인정보보호법 제15조) <span class="corg">[필수]</span></h4>
						<p>성명, 주민등록번호, 직장(소속/직위), 연락처, 주소(자택/이메일), 은행명, 계좌번호</p>
					</div>
				</div>
				<!-- 내용 출력 //-->    
				
				<div class="chk-wrap right">
					<input type="checkbox" name="agree_1" id="multiCheck" class="vcen1" value="Y" /> <label for="agree_1" class="f17 b">동의함</label>&nbsp;&nbsp;
					<input type="checkbox" name="agree_2" id="multiCheck" class="vcen2" value="Y" /> <label for="agree_2" class="f17 b">동의안함</label>
				</div>
				
				<div class="gap"></div>
				
				<!-- 내용 출력 -->
				<div class="agree-box">
					<div class="agree-txt" tabindex="0">
						<h4 class="c-tit02">개인정보 보유기간</h4>
						<p>수집된 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체없이 파기합니다.</p>

						<h4 class="c-tit02 mg30t">고유식별정보 수집・이용 동의(개인정보보호법 제24조) <span class="corg">[필수]</span></h4>
						<p>본인의 고유식별정보(주민등록번호)를 수집・이용하는 것에 동의하십니까?</p>
					</div>
				</div> 
				<!-- 내용 출력 //-->    
				
				<div class="chk-wrap">
					<div class="chk-wrap right">
					<input type="checkbox" name="agree_3" id="multiCheck" class="vcen3" value="Y" /> <label for="agree_3" class="f17 b">동의함</label>&nbsp;&nbsp;
					<input type="checkbox" name="agree_4" id="multiCheck" class="vcen4" value="Y" /> <label for="agree_4" class="f17 b">동의안함</label>
				</div>
				
				<div class="gap"></div>

				<!-- 내용 출력 -->
				<div class="agree-box">
					<div class="agree-txt" tabindex="0">
						<h4 class="c-tit02">제3자 제공 동의 (개인정보보호법 제17조)</h4>
						<h5 class="mg20t">▶ 제공받는 자/기관 : 국세청 <span class="corg">[필수]</span></h5>
						<p class="mg10t">1. 정보의 제공범위 : 성명, 주민등록번호, 주소  </p>    						
						<p>2. 정보의 제공목적 : 세금납부  </p> 
						<p>3. 제공받으려는 자의 정보의 보유 및 이용기간 : 이용목적 달성완료시까지</p>
					</div>
				</div> 
				<!-- 내용 출력 //-->  
				
				<div class="chk-wrap">
					<div class="chk-wrap right">
					<input type="checkbox" name="agree_5" id="multiCheck" class="vcen5" value="Y" /> <label for="agree_5" class="f17 b">동의함</label>&nbsp;&nbsp;
					<input type="checkbox" name="agree_6" id="multiCheck" class="vcen6" value="Y" /> <label for="agree_6" class="f17 b">동의안함</label>
				</div>

				<div class="achk-wrap">
					<input type="checkbox" name="agree_all" id="agree_all" class="vcen7" onclick="allcheck()" value="Y" style="width:20px; height:20px" /> <label for="allcheck()" class="f20 b">전체 동의 (모든 약관을 확인하고 전체 동의합니다)</label>
				</div>

				
				<div class="info-box mg50t">
					<p class="info-tit corg">동의를 거부할 권리 및 동의를 거부할 경우의 불이익</p>
					<p class="txt">개인정보의 수집·이용에 대한 동의를 거부할 수 있으며, 동의 후에도 언제든지 철회가 가능합니다. 다만 필수항목에 대해서 동의하지 않을 경우 수집・이용 목적과 관련된 강사수당 지급, 세금납부 등을 처리할 수 없으며, 선택 항목에 대해 동의하지 않을 경우에도 불이익 없습니다.</p>
					<p class="txt">본인은 본 동의서의 내용과 개인정보 수집·이용·제공에 관한 권리와 불이익 안내를 이해하고 「개인정보보호법」등 관련 법규에 의거하여 본인은 위와 같이 개인정보 수집 및 활용에 동의합니다.</p>
				</div>
				
			</div>	
			<!-- agree-cont //-->

			<div class="mbtn-wrap">
				<input type="submit" class="lg-btn" value="확인"/>
				<a href="${path }/" class="lw-btn"><span>취소</span></a>
			</div>
		</div>
	</form>  
	<!-- 회원가입 약관 //--> 


</div>
