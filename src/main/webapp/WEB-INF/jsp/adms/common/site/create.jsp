<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

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
		if($("#site_code").val() == ""){
			alert(gTxt("site.validate.code"));
			$("#site_code").focus();
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
	<form name="inputForm" method="post" onsubmit="return _onSubmit();" action="${path}/adms/common/site/create_action.do">
		<div class="panel">
			 <div class="panel-body">
		 		<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="sysmenu.site.manage" text="사이트관리" /></h4>
		 		<div class="alert alert-info mb0" >
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
									<input type="text" id="ts_title" name="ts_title" class="form-control" />
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><span class="ftcdanger">*</span> <spring:message code="site.domain" text="도메인" /></label></th>
								<td>
									<input type="text" id="ts_domain" name="ts_domain"   class="form-control"/>
								</td>
							</tr>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="site.order" text="순번" /></label></th>
								<td>
									<input type="text" id="ts_order" name="ts_order" value=""  class="form-control"/>
								</td>
							</tr>
							
							<div class="form-group">
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="site.code" text="사이트코드" /></label></th>
								<td>
									<input type="text" id="site_code" name="site_code" value=""  class="form-control"/>
								</td>
							</div>
							
							<tr>
								<th class="active" style="text-align:right"><label class="control-label" for=""><spring:message code="site.remarks" text="비고" /></label></th>
								<td>
									<input type="text" id="ts_etc" name="ts_etc" class="form-control"/>
								</td>
							</tr>
						</tbody>
					 </table>
				</div>
			</div>
		</div>
		
		<div class="pull-right">
			<input type="submit" value="<spring:message code='btn.save' text='저장' />" class="btn btn btn-primary btn-lg" />
			<a href="${path}/adms/common/site/list.do" class="btn btn btn-primary btn-lg"><spring:message code="btn.cancel" text="취소" /></a>
		</div>
	</form>
</div>
