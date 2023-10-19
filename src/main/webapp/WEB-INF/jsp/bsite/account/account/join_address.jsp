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
	
		
	});


	function _onSubmit(){
		if($("#me_id").val() == ""){
			alert("아이디를 입력해주세요.");
			$("#me_id").focus();
			return false;
		}
		
		if($("#idCntRes").val() == ""){
			alert("아이디 중복 체크를 해주세요.");
			$("#idCnt").focus();
			return false;
		}
		
		if($("#idCntRes").val() == "false"){
			alert("중복된 아이디가 있습니다. 다른 아이디를 입력해주세요.");
			$("#me_id").focus();
			return false;
		}
		
		if($("#me_pwd").val() == ""){
			alert("비밀번호를 입력해주세요.");
			$("#me_pwd").focus();
			return false;
		}
		
		if($("#me_pwd_chk").val() == ""){
			alert("비밀번호 확인을 입력해주세요.");
			$("#me_pwd_chk").focus();
			return false;
		}
		
		if($("#me_pwd").val() != $("#me_pwd_chk").val()){
			alert("입력하신 비밀번호와 비밀번호 확인이 서로 다릅니다.");
			$("#me_pwd_chk").focus();
			return false;
		}
		
		if($("#me_name").val() == ""){
			alert("이름을 입력해주세요.");
			$("#me_name").focus();
			return false;
		}
		
		if($("#me_tel").val() == ""){
			alert("연락처를 입력해주세요.");
			$("#me_tel").focus();
			return false;
		}
		
		if($("#me_email").val() == ""){
			alert("이메일을 입력해주세요.");
			$("#me_email").focus();
			return false;
		}
	
		if(!confirm("저장하시겠습니까?")){
			return false;
		}
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

</script>

<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/account/join_action.do" enctype="multipart/form-data" >
<div class="">
    <h2>나의정보</h2>
    <table class="table_tg" width="100%" summary="">
        <caption></caption>
        <colgroup>
            <col width="13%" />
            <col width="37%" />
            <col width="13%" />
            <col />
        </colgroup> 
        <tbody>
            <tr>
                <th class="first">*이름</th>
                <td colspan="3" class="last">
                    <input type="text" id="me_name" name="me_name" style="width:25%" />
                </td>
            </tr>
            <tr>
                <th class="first">*아이디</th>
                <td colspan="3" class="last">
                    <input type="text" id="me_id" name="me_id" style="width:25%"  />
                    
                    <a href="javascript:void(0);" onclick="checkDupId();return false;" class="rbutton white xsmall ml5">중복체크</a>
					<input type="hidden" id="idCntRes" name="idCntRes" value="" />
					<span id="idCntTxt"></span>
                </td>
            </tr>
            <tr>
                <th class="first">*비밀번호</th>
                <td><input type="password" id="me_pwd" name="me_pwd" style="width:60%"  /></td>
                <th>*비밀번호 확인</th>
                <td class="last"><input type="password" id="me_pwd_chk" name="me_pwd_chk" style="width:60%"  /></td>
            </tr>
            <tr>
                <th class="first">*연락처</th>
                <td>
                    <input type="text" id="me_tel" name="me_tel" placeholder="000-000-0000" style="width:60%" />
                </td>
                <th>*이메일</th>
                <td class="last">
                	<input type="text" id="me_email" name="me_email" placeholder="aaa@bbb.ccc" style="width:60%" />
                	<input type="checkbox" id="me_email_yn" name="me_email_yn" value="Y" /><span>뉴스레터수신</span>
                </td>
            </tr>
        </tbody>
    </table>
    <p>* 항목은 필수 입력 사항입니다.</p>
    
    <h2>기관정보 추가입력</h2>
    <table class="table_tg" width="100%" summary="">
        <caption></caption>
        <colgroup>
            <col width="13%" />
            <col width="37%" />
            <col width="13%" />
            <col />
        </colgroup> 
        <tbody>
            <tr>
                <th class="first">기관명</th>
                <td class="last" colspan="3"><input type="text" id="me_org_name" name="me_org_name" style="width:40%" /></td>
            </tr>
            <tr>
                <th class="first">연락처</th>
                <td>
                	<input type="text" id="me_org_tel" name="me_org_tel" placeholder="000-000-0000" style="width:60%" />
                </td>
                <th>사업자등록번호</th>
                <td class="last">
                	<input type="text" id="me_org_num" name="me_org_num" style="width:60%" />
                </td>
            </tr>
            <tr>
                <th class="first">주소</th>
                <td colspan="3" class="last">
                	<input type="text" id="me_org_zip" name="me_org_zip" placeholder="우편번호" readonly="readonly" /> 
					<a href="javascript:void(0);" onclick="popupZipSearch();return false;" class="rbutton xsmall white">우편번호찾기</a>
					<br />
					<input type="text" id="me_org_addr1" name="me_org_addr1" placeholder="주소" style="width:350px" readonly="readonly" />
					<input type="text" id="me_org_addr2" name="me_org_addr2" placeholder="상세주소" style="width:350px" />
                </td>
            </tr>
            <tr>
                <th class="first">체험처 유형</th>
                <td colspan="3" class="last">
                	<select name="me_org_type" id="me_org_type" style="width:25%;">
						<option value=""> </option>
						<c:forEach var="result" items="${orgTypeList}" varStatus="status">
				       		<option value="${result.main_code }">${result.code_name }</option>
						</c:forEach>
					</select>
                </td>
            </tr>
            <tr>
                <th class="first">체험프로그램명</th>
                <td colspan="3" class="last">
                	<input type="text" id="me_org_prgm" name="me_org_prgm" style="width:87%" />
                </td>
            </tr>
            <tr>
                <th class="first">체험내용</th>
                <td colspan="3" class="last">
                	<textarea id="me_org_cont" name="me_org_cont" rows="4" cols="100"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
    
    <div class="buttonRight">
        <input type="submit" class="rbutton blue large" value="회원가입" />
    </div>
</div>      
      
       
</form>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
function popupZipSearch(){
	new daum.Postcode({
        oncomplete: function(data) {
        	// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var fullAddr = ''; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                fullAddr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                fullAddr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
            if(data.userSelectedType === 'R'){
                //법정동명이 있을 경우 추가한다.
                if(data.bname !== ''){
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if(data.buildingName !== ''){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('me_org_zip').value = data.zonecode;
            document.getElementById("me_org_addr1").value = fullAddr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("me_org_addr2").focus();
        }
        
    }).open();
}
    
</script>