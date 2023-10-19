<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";

	$(function(){
	});
	
	function _submit() {
		if (_onSubmit()) {
			$('#inputForm').submit();
		}
	}


	function _onSubmit(){
		if($("#me_name").val() == ""){
			alert("Please enter your name.");
			$("#me_name").focus();
			return false;
		}
		
		if($("#me_id").val() == ""){
			alert("Please enter your ID.");
			$("#me_id").focus();
			return false;
		}
		
		if($("#idCntRes").val() == ""){
			alert("Please perform a username availability check.");
			$("#idCnt").focus();
			return false;
		}
		
		if($("#idCntRes").val() == "false"){
			alert("The ID is already taken. Please enter a different ID.");
			$("#me_id").focus();
			return false;
		}
		
		if($("#me_pwd").val() == ""){
			alert("Please enter your password.");
			$("#me_pwd").focus();
			return false;
		}
		
		if($("#me_pwd_chk").val() == ""){
			alert("Please enter the password confirmation.");
			$("#me_pwd_chk").focus();
			return false;
		}
		
		if(!validatePass()){
			$("#me_pwd").focus();
			return false;
		}
		
		if($("#me_pwd").val() != $("#me_pwd_chk").val()){
			alert("The password and password confirmation do not match.");
			$("#me_pwd_chk").focus();
			return false;
		}
		
		if($("#me_email").val() == ""){
			alert("이메일을 입력해주세요.");
			$("#me_email").focus();
			return false;
		}
		
		if (!validateEmail($("#me_email").val())) {
			$("#mail_id").focus();
			alert("The email format is incorrect.");
			return false;
		}
	
		if(confirm("Would you like to join?")){
			return true;
		}
		return false;
	}
	
	function validatePass() {
	    var pw = $("#me_pwd").val();
	    var num = pw.search(/[0-9]/g);
	    var eng = pw.search(/[a-z]/ig);
	    var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);

	    if (pw.length < 8 || pw.length > 20) {
	        alert("Please enter a password between 8 and 20 characters.");
	        return false;
	    } else if (pw.search(/\s/) != -1) {
	        alert("Please enter the password without any spaces.");
	        return false;
	    } else if ((num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0)) {
	        alert("Please enter a password using a combination of at least two of the following: letters, numbers, and special characters.");
	        return false;
	    } else {
	        return true;
	    }
	}
	
	function validateEmail(email) {
		var regExp = /^[-\w+']+(\.[-\w+']+)*@\w+([-.]\w+)*\.[A-Za-z]{2,}$/i;

		return regExp.test(email);
	}
	
	function checkDupId(){
		if($("#me_id").val() == ""){
			alert("아이디를 입력해주세요.");
			$("#me_id").focus();
			return false;
		}
		
		var meId = $("#me_id").val();
		
		var submitObj = new Object();
		submitObj.me_id= meId;
		
		$.ajax({ 
	      	  url: path+"/account/getIdCnt.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(submitObj),
	      	  dataType : "json",
	      	  async: false
	      	 }) 
	      	 .done(function(resMap) {
	      		if(resMap.res == "ok"){
	      			if(resMap.idCnt == 0 && meId != "temp_999999"){
	      				$("#idCntRes").val("true");
	      				$("#idCntTxt").text("사용 가능 합니다.");
	      				$("#me_id").attr("readonly","readonly");
	      			}else{
	      				$("#idCntRes").val("false");
	      				$("#idCntTxt").text("사용 불가능 합니다.");
	      			}
	      		}
	      	 }) 
	      	 .fail(function(e) {  
	      		 alert("등록 시도에 실패하였습니다."+e);
	      	 }) 
	      	 .always(function() { 
	      		 pass =  false;
	      	 }); 
		
	}
	
	function daumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('me_postno').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('me_address1').value = fullRoadAddr;	                
                document.getElementById('me_address2').focus();
             
            }
        }).open();
    }
	
	function setEmailDomain(domain){
		$("#me_email_domain").val(domain);
	}

</script>

<div class="container-fluid p-0">
	<div class="row justify-content-center">
		<div class="col-12">
			<div class="dashboard_header mb_50">
				<div class="row">
					<div class="col-lg-6">
						<div class="dashboard_header_title">
							<h3>Welcome</h3>
						</div>
					</div>
					<div class="col-lg-6">
						<div class="dashboard_breadcam text-right">
							<p>
								<i class="fas fa-caret-right"></i> Resister
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-12">
			<div class="white_box mb_30">
				<div class="row justify-content-center">

					<div class="col-lg-6">
						<!-- sign_in  -->
						<div class="modal-content cs_modal">
							<div class="modal-header justify-content-center theme_bg_1">
								<h5 class="modal-title text_white">Resister</h5>
							</div>
							<div class="modal-body">
							
								<form name="inputForm" id="inputForm" method="post" action="${path}/account/join_action.do" enctype="multipart/form-data" >
					
									<div class="form-group">
										<input type="text" id="me_name" name="me_name" class="form-control" placeholder="Name" maxlength="20"/>
									</div>
									<div class="form-inline">
										<div class="form-group">
											<input type="text" id="me_id" name="me_id" style="width:40%" class="form-control" placeholder="ID" maxlength="20"/>
						                    <a href="javascript:void(0);" onclick="checkDupId();return false;" class="form-control" style="margin: 0 20px 20px 20px;"><span>Check duplicate</span></a>
											<input type="hidden" id="idCntRes" name="idCntRes" value="" />
											<span id="idCntTxt" style="margin-bottom: 20px;"></span>
										</div>
									</div>
									<div class="form-group">
										<input type="password" id="me_pwd" name="me_pwd" class="form-control" placeholder="Password" maxlength="20"/>
									</div>
									<div class="form-group">
										<input type="password" id="me_pwd_chk" name="me_pwd_chk" class="form-control" placeholder="Confirm Password" maxlength="20"/>
									</div>
									<div class="form-group">
										<input type="text" name="me_email" id="me_email" class="form-control" placeholder="E-mail" maxlength="50" />
									</div>
									<div class="form-group">
										<input type="text" name="me_tel" id="me_tel" class="form-control" placeholder="Tel" maxlength="30"/> 
									</div>
									<div class="form-group">
										<input type="text" name="me_agency" id="me_agency" class="form-control" title="Institution" placeholder="Institution" maxlength="50">
									</div>
									<div class="form-group">
										<input type="text" name="me_department" id="me_department" class="form-control" placeholder="Department" maxlength="50">
									</div>
									<a href="javascript:_submit();" class="btn_1 full_width text-center">Sign Up</a>
								</form>
							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>
