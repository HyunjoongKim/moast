<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript" src="${pageContext.request.contextPath}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";

	$(function(){
	
		
	});


	function _onSubmit(){
		
		if($("#nowPassword").val() == ""){
			alert("기존 비밀번호를 입력해주세요.");
			$("#nowPassword").focus();
			return false;
		}
		if($("#newPassword").val() == ""){
			alert("변경 비밀번호를 입력해주세요.");
			$("#newPassword").focus();
			return false;
		}
		if($("#newPassword_chk").val() == ""){
			alert("변경 비밀번호 확인을 입력해주세요.");
			$("#newPassword_chk").focus();
			return false;
		}
		if($("#newPassword").val() != $("#newPassword_chk").val()){
			alert("입력하신 비밀번호와 비밀번호 확인이 서로 다릅니다.");
			$("#newPassword_chk").focus();
			return false;
		}
		
		if(!confirm("비밀번호를 변경하시겠습니까?")){
			return false;
		}
	}
</script>


<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/myPage/info/update_pw_action.do" >

	<!-- title -->
	<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
		<div class="row">
			<div class="col-lg-6">
				<h3 class="card-title h3icn">비밀번호변경</h3>
			</div>
			<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>My Page<i class="fa fa-chevron-right ml-2 mr-2"></i>Change password</div>
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
							<i class="ion ion-clipboard mr-1"></i>비밀번호변경
						</h3>
					</div>

					<div class="card-body">
						<div class="table-write">
							<table class="table table-bordered table-block">
				            <colgroup>
				                <col width="20%" />
				                <col />
				            </colgroup> 
				            <tbody>
				            	<tr>
				            		<th class="first">기존 비밀번호</th>
				                    <td class="last">
				                    	<input type="password" id="nowPassword" name="nowPassword" />
				                    </td>
				            	</tr>
				            	<tr>
				            		<th class="first">변경 비밀번호</th>
				                    <td class="last">
				                    	<input type="password" id="newPassword" name="newPassword" />
				                    </td>
				            	</tr>
				            	<tr>
				            		<th class="first">변경 비밀번호 확인</th>
				                    <td class="last">
				                    	<input type="password" id="newPassword_chk" name="newPassword_chk" />
				                    </td>
				            	</tr>
				            </tbody>
				        </table>
				    </div>
				    
				    <div class="clearfix"></div>
		
					<div class="row btn-area">
						<div class="col-lg-12 text-right">
							<div>
								<input type="submit" class="btn btn-primary" value="확인">
								<a href="${path}/myPage/info/read.do" class="btn btn-dark"><span>취소</span></a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
	</div>
</form>
