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
		
		if($("#me_name").val() == ""){
			alert("이름를 입력해주세요.");
			$("#me_name").focus();
			return false;
		}

		if($("#tmp_me_bth").val() == ""){
			alert("생년월일을 입력해주세요.");
			$("#tmp_me_bth").focus();
			return false;
		}
		
		if($("#me_postno").val() == ""){
			alert("주소를 입력해주세요.");
			$("#me_postno").focus();
			return false;
		}
		
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
		
	
		if(!confirm("저장하시겠습니까?")){
			return false;
		}
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



<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/myPage/info/update_action.do" enctype="multipart/form-data" >
	<input type="hidden" id="me_idx" name="me_idx" value="${memberVO.me_idx }" />


				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Modify user information</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>My Page<i class="fa fa-chevron-right ml-2 mr-2"></i>User information</div></div>
					</div>
				</div>
				<!-- //title -->
				
				<!-- 컨텐츠 영역 -->
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!-- contents start -->
							<div class="card">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i>Modify user information
									</h3>
								</div>

								<div class="card-body">
									<div class="table-write">
										<table class="table table-bordered table-block">
									        <tbody>
									            <tr>
									                <th>아이디</th>
									                <td>
									                    ${memberVO.me_id}
									                </td>
									            </tr>
									            <tr>
									                <th>Name<span class="nec"></span></th>
									                <td>
									                    <input type="text" id="me_name" name="me_name" value="${memberVO.me_name }" class="text w33p" placeholder="Name" />
									                </td>
									            </tr>
												<tr>
													<th scope="row">E-mail<span class="nec"></span></th>
													<td>
														<input type="hidden" name="me_email" id="me_email" /> 
														<input type="text" id="me_email_id" name="me_email_id" class="text w20p" value="" title="E-mail ID" placeholder="E-mail ID" maxlength="18"> @ 
														<input type="text" id="me_email_domain" name="me_email_domain" class="text w25p" value="" title="E-mail Domain" placeholder="E-mail Domain" maxlength="18"> 
														<select class="select" title="이메일 도메인 주소 선택" onclick="setEmailDomain(this.value);return false;">
																<option value="">-select-</option>
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
									                <th>Contact<span class="nec"></span></th>
									                <td>
									                	<input type="hidden" name="me_tel" id="me_tel" /> 
									                    <input type="text" id="me_tel1" name="me_tel1" class="text w33p" style="width:50px" onKeyPress="return isNumberKey(event);"  onblur="hanReplaceValueOnBlur(this);" /> - 
									                    <input type="text" id="me_tel2" name="me_tel2" class="text w33p" style="width:50px" onKeyPress="return isNumberKey(event);"  onblur="hanReplaceValueOnBlur(this);" /> -
									                    <input type="text" id="me_tel3" name="me_tel3" class="text w33p" style="width:50px" onKeyPress="return isNumberKey(event);"  onblur="hanReplaceValueOnBlur(this);" />
									                </td>
									            </tr>
												<tr>
													<th scope="row"><label for="">Institution</label></th>
													<td><input type="text" name="me_agency" id="me_agency" value="${memberVO.me_agency }" class="text w33p" title="Institution" placeholder="Institution"></td>
												</tr>
												<tr>
													<th scope="row"><label for="">Department or division</label></th>
													<td><input type="text" name="me_department" id="me_department" value="${memberVO.me_department }" class="text w33p" title="Department or division" placeholder="Department or division"></td>
												</tr>
									        </tbody>
									    </table>
									</div>
									
									<div class="clearfix"></div>
					
									<div class="row btn-area">
										<div class="col-lg-12 text-right">
											<div>
												<input type="submit" class="btn btn-primary" value="Save">
												<a href="${path}/myPage/info/read.do" class="btn btn-dark"><span>Cancel</span></a>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</section>
				</div>
			</form>

