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

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";
	
	$(function(){
		
	});
	
	function _onSubmit(){
		if($("#ts_title").val() == ""){
			alert(gTxt("site.validate.title"));
			$("#ts_title").focus();
			return false;
		}
		
		if($("#ts_domain").val() == ""){
			alert(gTxt("site.validate.domain"));
			$("#ts_domain").focus();
			return false;
		}
		
		if($("#ts_order").val() == ""){
			$("#ts_order").val(1);
		}
		
		if(!confirm(gTxt("confirm.save"))){
			return false;
		}
	}
	
</script>


<div id="contAreaBox">
	<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/adms/common/site/update_action.do?${qustr}">	
	<input type="hidden" id="ts_pkid" name="ts_pkid" value="${svo.ts_pkid}" />
		<div class="panel">
			 <div class="panel-body">
		 		<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="sysmenu.site.manage" text="사이트관리" /></h4>
		 		<div class="alert alert-info" >
				  	<spring:message code="txt.guideRequire" text="표시는 필수 입력 항목 입니다." />
				</div>
				
				<div class="table-responsive">
					<table id="datatable-scroller" class="table table-bordered">
						<caption>사이트관리</caption>
						<colgroup>
							<col width="250px" />
							<col />
						</colgroup>
				 		<tbody>
				 			<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="site.name" text="사이트명" /></label></th>
								<td>
									<input type="text" id="ts_title" name="ts_title" value="${svo.ts_title}"  class="form-control"/>
								</td>
							</div>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="site.domain" text="도메인" /></label></th>
								<td>
									<input type="text" id="ts_domain" name="ts_domain" value="${svo.ts_domain}"  class="form-control"/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="site.order" text="순번" /></label></th>
								<td>
									<input type="text" id="ts_order" name="ts_order" value="${svo.ts_order}" class="form-control"/>
								</td>
							</div>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="site.code" text="사이트코드" /></label></th>
								<td>
									<input type="text" id="" name="" value="${svo.site_code}" disabled class="form-control" />
								</div>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="site.remarks" text="비고" /></label></th>
								<td>
									<input type="text" id="ts_etc" name="ts_etc" value="${svo.ts_etc}" class="form-control" />
								</td>
							</tr>
				 		</tbody>
					 </table>
				</div>
			</div>
		</div>

		<div class="pull-right">
			<input type="submit" value="<spring:message code='btn.save' text='저장' />" class="btn btn btn-primary btn-lg" />
			<a href="${path}/adms/common/site/list.do?${qustr}" class="btn btn btn-primary btn-lg"><spring:message code="btn.cancel" text="취소" /></a>
		</div>
	</form>
</div>
