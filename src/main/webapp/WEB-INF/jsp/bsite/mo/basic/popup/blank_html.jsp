<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.common.min.css"/>
<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.default.min.css"/>
<script src="https://kendo.cdn.telerik.com/2023.1.314/js/kendo.all.min.js"></script>


<script type="text/javascript">
	var path = "${path }";
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();

	});
	
	function initControls() {
		
	}
	
	
	
	
	
</script>
<form id="submitForm" action="${path}/mo/basic/popup/degAnnotation.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
	
	<input type="hidden" name="degType" id="degType" value="${param.degType }"/>
	<input type="hidden" name="searchLogFC" id="searchLogFC" value="${param.searchLogFC }"/>
	<input type="hidden" name="searchPValue" id="searchPValue" value="${param.searchPValue }"/>
	<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${param.searchAdjPValue }"/>
</form>
<div class="card">
	<div class="card-header">
		<h3 class="card-title">
			<i class="ion ion-clipboard mr-1"></i>Result
		</h3>
	</div>

	<div class="card-body">
		<div class="row">
			<div class="col-lg-12">
				${output_body }
			</div>
		</div>
	</div>
		
</div>

<script>




</script>
