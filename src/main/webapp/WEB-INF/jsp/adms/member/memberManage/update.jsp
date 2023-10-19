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

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";
	
	$(document).ready(function() {
		$("#tmp_me_bth").datepicker();
		
		var meEmail = "${memberVO.me_email}";
		var emailArr = meEmail.split("@");
		$("#me_email_id").val(emailArr[0]);
		$("#me_email_domain").val(emailArr[1]);
		
		var meTel = "${memberVO.me_tel}";
		var telArr = meTel.split("-");
		$("#me_tel1").val(telArr[0]);
		$("#me_tel2").val(telArr[1]);
		$("#me_tel3").val(telArr[2]);
	});
	

	function _onSubmit(){
		if($("#me_id").val() == ""){
			alert(gTxt("mb.validate.id"));
			$("#me_id").focus();
			return false;
		}
		
		if($("#me_pwd").val() != ""){
			if($("#me_pwd_chk").val() == ""){
				alert(gTxt("mb.validate.pwd2"));
				$("#me_pwd_chk").focus();
				return false;
			}
			
			if($("#me_pwd").val() != $("#me_pwd_chk").val()){
				alert(gTxt("mb.validate.pwd3"));
				$("#me_pwd_chk").focus();
				return false;
			}
		}
		
		if($("#me_name").val() == ""){
			alert(gTxt("mb.validate.name"));
			$("#me_name").focus();
			return false;
		}
		
		if($("#auth_code").val() == ""){
			alert(gTxt("mb.validate.auth"));
			$("#auth_code").focus();
			return false;
		}
		/*
		if($("#me_email_id").val() == ""){
			alert("이메일 아이디를 입력해주세요.");
			$("#me_email_id").focus();
			return false;
		}
		
		if($("#me_email_domain").val() == ""){
			alert("이메일 도메인을 입력해주세요.");
			$("#me_email_domain").focus();
			return false;
		}
		var emailId = $("#me_email_id").val();
		var emailDomain = $("#me_email_domain").val();
		$("#me_email").val(emailId + "@" + emailDomain);
		
		if( $("#me_tel1").val() == "" || $("#me_tel2").val() == "" || $("#me_tel3").val() == "" ){
			alert("전화번호를 입력해주세요.");
			return false;
		}
		$("#me_tel").val($("#me_tel1").val() + "-" + $("#me_tel2").val() + "-" + $("#me_tel3").val());
		*/
		if(!confirm(gTxt("confirm.save"))){
			return false;
		}
	}
	
	function getThumbnailPrivew(html) {
		console.log("TEst");
	    if (html.files && html.files[0]) {
	        var reader = new FileReader();
	        reader.onload = function (e) {
	            $('#cma_image').css('display', '');	           
	            $('#cma_image').html('<img src="' + e.target.result + '" border="0" style="width:180px; height:185px;" alt="" />');
	        }
	        reader.readAsDataURL(html.files[0]);
	    }
	}
	
	
	function loginReset(html) {
		var meIdx = $("#me_idx").val();
		
		var submitObj = new Object();
		submitObj.me_idx= meIdx;
		
		$.ajax({ 
	      	  url: path+"/account/loginCntReset.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(submitObj),
	      	  dataType : "json",
	      	  async: false
	      	 }) 
	      	 .done(function(resMap) {
	      		if(resMap.res == "ok"){
	      			alert("로그인 횟수가 초기화 됬습니다.")
	      		}
	      	 }) 
	      	 .fail(function(e) {  
	      		 alert("FAIL - "+e);
	      	 }) 
	      	 .always(function() { 
	      		 
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
		if(domain != "") $("#me_email_domain").val(domain);
	}
</script>
<style>
.label {
    display: inline-block;
    padding: .5em .75em;
    color: #999;
    font-size: inherit;
    line-height: normal;
    vertical-align: middle;
    background-color: #fdfdfd;
    cursor: pointer;
    border: 1px solid #ebebeb;
    border-bottom-color: #e2e2e2;
    border-radius: .25em;
    width:100%;
    max-width:100%;
}
 
#cma_file {  /* 파일 필드 숨기기 */
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip:rect(0,0,0,0);
    border: 0;
}
</style>

<div id="contAreaBox">
<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/adms/member/memberManage/update_action.do?${qustr}"  enctype="multipart/form-data">
<input type="hidden" id="me_idx" name="me_idx" value="${memberVO.me_idx }" />
<input type="hidden" id="atch_file_id" name="atch_file_id" value="${memberVO.atch_file_id }" />
	<div class="panel">
		<div class="panel-body">
			<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="sysmenu.member.manage" text="회원관리" /></h4>
			<div class="alert alert-info">
			  	<spring:message code="txt.guideRequire" text="표시는 필수 입력 항목 입니다." />
			</div>
			<div class="table-responsive">
				<table id="datatable-scroller" class="table table-bordered tbl_Form">
					<caption>
						권한 등록
					</caption>
					<colgroup>
						<col width="250px" />
						<col />
					</colgroup>
					<tbody>

						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.id" text="아이디" /></label></th>
							<td>
								<input type="text" id="" name="" value="${memberVO.me_id}" disabled class="form-control" />
							</td>
						</tr>
						
						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.pwd" text="비밀번호" /></label></th>
							<td class="form-inline">
								<input type="password" id="me_pwd" name="me_pwd"  style="width:300px" class="form-control"/>
								<span>[Enter only when changing]</span>
							</td>
						</tr>
						
						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.pwd2" text="비밀번호 재입력" /></label></th>
							<td class="form-inline">
								<input type="password" id="me_pwd_chk" name="me_pwd_chk"  style="width:300px" class="form-control"/>
								<span>[Enter only when changing]</span>
							</td>
						</tr>
						
						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.name" text="이름" /></label></th>
							<td>
								<input type="text" id="me_name" name="me_name" value="${memberVO.me_name}" class="form-control"/>
							</td>
						</tr>
						
						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.auth" text="권한" /></label></th>
							<td>
								<select name="auth_code" id="auth_code" onchange="AuthFunc.changeAuthCode(this)" class="form-control" style="width:500px"/>
									<option value="">--Select-- </option>
									<c:forEach var="result" items="${authList}" varStatus="status">
							       		<option value="${result.auth_code }" ${result.auth_code eq memberVO.auth_code ? 'selected' : ''}>${result.auth_title }</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.cert" text="회원인증처리" /></label></th>
							<td>
								<div class="radio radio-inline "> 
			                   		<input type="radio" name="me_is_cert" value="Y"  ${'Y' eq memberVO.me_is_cert ? 'checked' : ''}/><label><spring:message code="mb.cert.y" text="인증" /> </label>
			               		</div>
								<div class="radio radio-inline ">               		
			              		    <input type="radio" name="me_is_cert" value="N"  ${'N' eq memberVO.me_is_cert ? 'checked' : ''}/><label><spring:message code="mb.cert.n" text="미인증" /> </label>
			               		</div>
							</td>
						</tr>
						
						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.login" text="로그인가능처리" /></label></th>
							<td>
								<div class="radio radio-inline "> 
			                   		<input type="radio" name="me_is_login" value="Y"  ${'Y' eq memberVO.me_is_login ? 'checked' : ''}/><label><spring:message code="mb.login.y" text="가능" /> </label>
			               		</div>
								<div class="radio radio-inline ">               		
			              		    <input type="radio" name="me_is_login" value="N"  ${'N' eq memberVO.me_is_login ? 'checked' : ''}/><label><spring:message code="mb.login.n" text="불가능" /></label>
			               		</div>
							</td>
						</tr>
						
						<tr>
							<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="mb.login.init" text="로그인 초기화" /></label></th>
							<td>
								 <input type="button" onclick="loginReset()" class="btn btn-info" role="button" value="<spring:message code='mb.login.init' text='로그인 초기화' />">               		
							</td>
						</tr>
						
						<tr>
				                <th class="active" style="text-align:right">Birth date<span class="nec"></span></th>
				                <td>
				                    <input type="text" id="tmp_me_bth" name="tmp_me_bth" value="${memberVO.tmp_me_bth }"  />
				                </td>
				            </tr>
				            <tr>
								<th class="active" style="text-align:right">Address<span class="nec"></span></th>
								<td>
									<input type="text" name="me_postno" id="me_postno" class="text w90" value="${memberVO.me_postno }" />
									<a href="javascript:void(0);" onclick="daumPostcode();return false;" class="btn btn-dark"><span>zip code</span></a>
									<br /><input type="text" id="me_address1" name="me_address1" style="width:500px" value="${memberVO.me_address1 }" />
									<br /><input type="text" id="me_address2" name="me_address2" style="width:500px" value="${memberVO.me_address2 }" />
								</td>
							</tr>
							<tr>
								<th class="active" style="text-align:right">E-mail<span class="nec"></span></th>
								<td>
									<input type="hidden" name="me_email" id="me_email" /> 
									<input type="text" id="me_email_id" name="me_email_id" class="text w20p" value="" title="E-mail ID" placeholder="E-mail ID" maxlength="18"> @ 
									<input type="text" id="me_email_domain" name="me_email_domain" class="text w25p" value="" title="E-mail domain" placeholder="E-mail domain" maxlength="18"> 
									<select class="select" title="E-mail domain" onclick="setEmailDomain(this.value);return false;">
											<option value="">-Select-</option>
											<option value="naver.com">naver.com</option>
											<option value="gmail.com">gmail.com</option>
											<option value="hanmail.net">hanmail.net</option>
											<option value="hotmail.com">hotmail.com</option>
											<option value="korea.com">korea.com</option>
											<option value="nate.com">nate.com</option>
											<option value="yahoo.com">yahoo.com</option>
									</select>
								</td>
							</tr>
							<tr>
				                <th class="active" style="text-align:right">Tel<span class="nec"></span></th>
				                <td>
				                	<input type="hidden" name="me_tel" id="me_tel" /> 
				                    <input type="text" id="me_tel1" name="me_tel1" class="text w33p" style="width:50px" onKeyPress="return isNumberKey(event);"  onblur="hanReplaceValueOnBlur(this);" /> - 
				                    <input type="text" id="me_tel2" name="me_tel2" class="text w33p" style="width:50px" onKeyPress="return isNumberKey(event);"  onblur="hanReplaceValueOnBlur(this);" /> -
				                    <input type="text" id="me_tel3" name="me_tel3" class="text w33p" style="width:50px" onKeyPress="return isNumberKey(event);"  onblur="hanReplaceValueOnBlur(this);" />
				                </td>
				            </tr>
				            <tr>
								<th class="active" style="text-align:right">Job</th>
								<td>
									<select name="me_agency_type" id="me_agency_type" class="select w100" title="직업 입력" placeholder="직업">
										<option value="">-select-</option>
										<c:forEach var="result" items="${agTypeList}" varStatus="status">
								       		<option value="${result.main_code }" ${result.main_code eq memberVO.me_agency_type ? 'selected' : ''}>${result.code_name }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th class="active" style="text-align:right"><label for="">Institution</label></th>
								<td><input type="text" name="me_agency" id="me_agency" value="${memberVO.me_agency }" style="width:500px" title="Institution" ></td>
							</tr>
							<tr>
								<th class="active" style="text-align:right"><label for="">Department</label></th>
								<td><input type="text" name="me_department" id="me_department" value="${memberVO.me_department }" style="width:500px" title="Department" ></td>
							</tr>
							<tr>
								<th class="active" style="text-align:right"><label for="">Position</label></th>
								<td><input type="text" name="me_position" id="me_position" value="${memberVO.me_position }" style="width:500px" title="Position" ></td>
							</tr>
						
					</tbody>
				</table>
			</div>
		</div>
	</div>
	
		<div class="pull-right">
			<input type="submit" value="<spring:message code="btn.save" text="저장" />"  class="btn btn btn-primary btn-lg" />
			<a href="${path}/adms/member/memberManage/list.do?${qustr}" class="btn btn btn-primary btn-lg"><spring:message code="btn.cancel" text="취소" /></a>
		</div>
	</form>
</div>

