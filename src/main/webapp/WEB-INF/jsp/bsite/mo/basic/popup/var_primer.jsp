<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
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
		$('textarea').keyup(function() {
			$(this).css("overflow", "hidden");
			$(this).css("height", "0");
			$(this).css("height", 8 + $(this).prop("scrollHeight") + "px");
		});

		$("#submitForm").submit(
			function(e) {
				var win = window.open("", "PopVarPrimerOutput",
						"width=1600,height=820");
				var url = "${path}/mo/basic/popup/varPrimer_output.do";
				
				$('#submitForm').prop("action", url);
				$('#submitForm').prop("target", "PopVarPrimerOutput");
				$('#submitForm').prop("method", "post");
				$('#submitForm').submit() ;
	
			}
		)
		
		/* $("#sampleData-btn").on("click", function(){
			$("#input_file_string").text("Gene_name	CHR	POS	REF	ALT	VARIANT_RATE	PM-AA-0061-T	PM-AA-0066-T	PM-AA-0066-T	PM-AS-0001-T	PM-AS-0007-T	PM-AS-0008-T	PM-AS-0009-T	PM-AS-0010-T	PM-AS-0011-T	PM-AS-0012-T	PM-AS-0013-T	PM-AS-0014-T	PM-AS-0015-T	PM-AS-0016-T	PM-AS-0017-T	PM-AS-0018-T \nFSIP2	chr2	185801307	T	G	0.06														Missense_Mutation;chr2_185801307:185801307;T>G")
		}) */
	}
</script>
<%-- <form id="submitForm" action="${path}/mo/basic/popup/degAnnotation.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
	
	<input type="hidden" name="degType" id="degType" value="${param.degType }"/>
	<input type="hidden" name="searchLogFC" id="searchLogFC" value="${param.searchLogFC }"/>
	<input type="hidden" name="searchPValue" id="searchPValue" value="${param.searchPValue }"/>
	<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${param.searchAdjPValue }"/>
</form> --%>
<form id="submitForm" action="${path}/mo/basic/popup/varPrimer_output.do"
	method="post" target="PopHtPrimerOutput">
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx}">
	<input type="hidden" name="variantID" id="variantID" value="${searchVO.variantID}">
	<div class="card">
		<div class="card-header">
			<h3 class="card-title">
				<i class="ion ion-clipboard mr-1"></i>Variant Primer
			</h3>
		</div>

		<div class="card-body">
			<div class="card card-info card-outline">
              <div class="card-header">
				<h3 class="card-title">Input Data</h3>
              </div>
              <div class="card-body">
				<div class="row">
                 	<textarea class="form-control" rows="3" name="input_file_string" id="input_file_string" placeholder="">${searchVO.input_file_string}</textarea>
                </div>
              </div>
            </div>
			
			<div class="card card-info card-outline collapsed-card">
              <div class="card-header">
				<h3 class="card-title">Batch Primer 3 Parameters</h3>
                <div class="card-tools">
                  <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                    <i class="fas fa-plus"></i>
                  </button>
                </div>
              </div>
              <div class="card-body">
              
				<div class="row">
                 	<!-- <div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE</label> <input type='text' class='form-control' name='PrimerVO.SEQUENCE' id='SEQUENCE' placeholder='SEQUENCE' value='' />
						</div>
					</div> -->
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCEFILE</label> <input type='text' class='form-control' name='PrimerVO.SEQUENCEFILE' id='SEQUENCEFILE' placeholder='SEQUENCEFILE' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_TYPE</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_TYPE' id='PRIMER_TYPE' placeholder='PRIMER_TYPE' value='7' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>Pick_Primers</label> <input type='text' class='form-control' name='PrimerVO.Pick_Primers' id='Pick_Primers' placeholder='Pick_Primers' value='Pick Primers' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PICK_LEFT</label> <input type='text' class='form-control' name='PrimerVO.MUST_XLATE_PICK_LEFT' id='MUST_XLATE_PICK_LEFT' placeholder='MUST_XLATE_PICK_LEFT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_LEFT_INPUT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_LEFT_INPUT' id='PRIMER_LEFT_INPUT' placeholder='PRIMER_LEFT_INPUT' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PICK_RIGHT</label> <input type='text' class='form-control' name='PrimerVO.MUST_XLATE_PICK_RIGHT' id='MUST_XLATE_PICK_RIGHT' placeholder='MUST_XLATE_PICK_RIGHT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_RIGHT_INPUT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_RIGHT_INPUT' id='PRIMER_RIGHT_INPUT' placeholder='PRIMER_RIGHT_INPUT' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MISPRIMING_LIBRARY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MISPRIMING_LIBRARY' id='PRIMER_MISPRIMING_LIBRARY' placeholder='PRIMER_MISPRIMING_LIBRARY' value='NONE' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SECOND_MISMATCH_POS</label> <input type='text' class='form-control' name='PrimerVO.SECOND_MISMATCH_POS' id='SECOND_MISMATCH_POS' placeholder='SECOND_MISMATCH_POS' value='-3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_MIN_SIZE</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_MIN_SIZE' id='SNP_PRIMER_MIN_SIZE' placeholder='SNP_PRIMER_MIN_SIZE' value='15' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_OPT_SIZE</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_OPT_SIZE' id='SNP_PRIMER_OPT_SIZE' placeholder='SNP_PRIMER_OPT_SIZE' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_MAX_SIZE</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_MAX_SIZE' id='SNP_PRIMER_MAX_SIZE' placeholder='SNP_PRIMER_MAX_SIZE' value='30' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_MIN_TM</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_MIN_TM' id='SNP_PRIMER_MIN_TM' placeholder='SNP_PRIMER_MIN_TM' value='57' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_OPT_TM</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_OPT_TM' id='SNP_PRIMER_OPT_TM' placeholder='SNP_PRIMER_OPT_TM' value='60' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_MAX_TM</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_MAX_TM' id='SNP_PRIMER_MAX_TM' placeholder='SNP_PRIMER_MAX_TM' value='63' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_MIN_GC</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_MIN_GC' id='SNP_PRIMER_MIN_GC' placeholder='SNP_PRIMER_MIN_GC' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_MAX_GC</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_MAX_GC' id='SNP_PRIMER_MAX_GC' placeholder='SNP_PRIMER_MAX_GC' value='80' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_MAX_N</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_MAX_N' id='SNP_PRIMER_MAX_N' placeholder='SNP_PRIMER_MAX_N' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_SALT_CONC</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_SALT_CONC' id='SNP_PRIMER_SALT_CONC' placeholder='SNP_PRIMER_SALT_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_PRIMER_DNA_CONC</label> <input type='text' class='form-control' name='PrimerVO.SNP_PRIMER_DNA_CONC' id='SNP_PRIMER_DNA_CONC' placeholder='SNP_PRIMER_DNA_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_MAX_SELF_COMPLEMENTARITY</label> <input type='text' class='form-control' name='PrimerVO.SNP_MAX_SELF_COMPLEMENTARITY' id='SNP_MAX_SELF_COMPLEMENTARITY' placeholder='SNP_MAX_SELF_COMPLEMENTARITY' value='8' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SNP_MAX_3_SELF_COMPLEMENTARITY</label> <input type='text' class='form-control' name='PrimerVO.SNP_MAX_3_SELF_COMPLEMENTARITY' id='SNP_MAX_3_SELF_COMPLEMENTARITY' placeholder='SNP_MAX_3_SELF_COMPLEMENTARITY' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRODUCT_MIN_SIZE</label> <input type='text' class='form-control' name='PrimerVO.MUST_XLATE_PRODUCT_MIN_SIZE' id='MUST_XLATE_PRODUCT_MIN_SIZE' placeholder='MUST_XLATE_PRODUCT_MIN_SIZE' value='500' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_OPT_SIZE</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PRODUCT_OPT_SIZE' id='PRIMER_PRODUCT_OPT_SIZE' placeholder='PRIMER_PRODUCT_OPT_SIZE' value='700' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRODUCT_MAX_SIZE</label> <input type='text' class='form-control' name='PrimerVO.MUST_XLATE_PRODUCT_MAX_SIZE' id='MUST_XLATE_PRODUCT_MAX_SIZE' placeholder='MUST_XLATE_PRODUCT_MAX_SIZE' value='1000' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_NUM_RETURN</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_NUM_RETURN' id='PRIMER_NUM_RETURN' placeholder='PRIMER_NUM_RETURN' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_END_STABILITY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MAX_END_STABILITY' id='PRIMER_MAX_END_STABILITY' placeholder='PRIMER_MAX_END_STABILITY' value='9.0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_MISPRIMING</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MAX_MISPRIMING' id='PRIMER_MAX_MISPRIMING' placeholder='PRIMER_MAX_MISPRIMING' value='12.00' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_MISPRIMING</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_MAX_MISPRIMING' id='PRIMER_PAIR_MAX_MISPRIMING' placeholder='PRIMER_PAIR_MAX_MISPRIMING' value='24.00' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_SIZE</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MIN_SIZE' id='PRIMER_MIN_SIZE' placeholder='PRIMER_MIN_SIZE' value='18' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_SIZE</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_OPT_SIZE' id='PRIMER_OPT_SIZE' placeholder='PRIMER_OPT_SIZE' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_SIZE</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MAX_SIZE' id='PRIMER_MAX_SIZE' placeholder='PRIMER_MAX_SIZE' value='27' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MIN_TM' id='PRIMER_MIN_TM' placeholder='PRIMER_MIN_TM' value='57.0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_OPT_TM' id='PRIMER_OPT_TM' placeholder='PRIMER_OPT_TM' value='60.0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MAX_TM' id='PRIMER_MAX_TM' placeholder='PRIMER_MAX_TM' value='63.0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_DIFF_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MAX_DIFF_TM' id='PRIMER_MAX_DIFF_TM' placeholder='PRIMER_MAX_DIFF_TM' value='10.0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_MIN_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PRODUCT_MIN_TM' id='PRIMER_PRODUCT_MIN_TM' placeholder='PRIMER_PRODUCT_MIN_TM' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_OPT_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PRODUCT_OPT_TM' id='PRIMER_PRODUCT_OPT_TM' placeholder='PRIMER_PRODUCT_OPT_TM' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_MAX_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PRODUCT_MAX_TM' id='PRIMER_PRODUCT_MAX_TM' placeholder='PRIMER_PRODUCT_MAX_TM' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_GC</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MIN_GC' id='PRIMER_MIN_GC' placeholder='PRIMER_MIN_GC' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_GC_PERCENT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_OPT_GC_PERCENT' id='PRIMER_OPT_GC_PERCENT' placeholder='PRIMER_OPT_GC_PERCENT' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_GC</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MAX_GC' id='PRIMER_MAX_GC' placeholder='PRIMER_MAX_GC' value='80' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SELF_ANY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_SELF_ANY' id='PRIMER_SELF_ANY' placeholder='PRIMER_SELF_ANY' value='8' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SELF_END</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_SELF_END' id='PRIMER_SELF_END' placeholder='PRIMER_SELF_END' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_NUM_NS_ACCEPTED</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_NUM_NS_ACCEPTED' id='PRIMER_NUM_NS_ACCEPTED' placeholder='PRIMER_NUM_NS_ACCEPTED' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_POLY_X</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_MAX_POLY_X' id='PRIMER_MAX_POLY_X' placeholder='PRIMER_MAX_POLY_X' value='5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INSIDE_PENALTY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_INSIDE_PENALTY' id='PRIMER_INSIDE_PENALTY' placeholder='PRIMER_INSIDE_PENALTY' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OUTSIDE_PENALTY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_OUTSIDE_PENALTY' id='PRIMER_OUTSIDE_PENALTY' placeholder='PRIMER_OUTSIDE_PENALTY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_GC_CLAMP</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_GC_CLAMP' id='PRIMER_GC_CLAMP' placeholder='PRIMER_GC_CLAMP' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SALT_CONC</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_SALT_CONC' id='PRIMER_SALT_CONC' placeholder='PRIMER_SALT_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_DNA_CONC</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_DNA_CONC' id='PRIMER_DNA_CONC' placeholder='PRIMER_DNA_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TM_LT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_TM_LT' id='PRIMER_WT_TM_LT' placeholder='PRIMER_WT_TM_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TM_GT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_TM_GT' id='PRIMER_WT_TM_GT' placeholder='PRIMER_WT_TM_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SIZE_LT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_SIZE_LT' id='PRIMER_WT_SIZE_LT' placeholder='PRIMER_WT_SIZE_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SIZE_GT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_SIZE_GT' id='PRIMER_WT_SIZE_GT' placeholder='PRIMER_WT_SIZE_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_GC_PERCENT_LT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_GC_PERCENT_LT' id='PRIMER_WT_GC_PERCENT_LT' placeholder='PRIMER_WT_GC_PERCENT_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_GC_PERCENT_GT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_GC_PERCENT_GT' id='PRIMER_WT_GC_PERCENT_GT' placeholder='PRIMER_WT_GC_PERCENT_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_COMPL_ANY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_COMPL_ANY' id='PRIMER_WT_COMPL_ANY' placeholder='PRIMER_WT_COMPL_ANY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_COMPL_END</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_COMPL_END' id='PRIMER_WT_COMPL_END' placeholder='PRIMER_WT_COMPL_END' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_NUM_NS</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_NUM_NS' id='PRIMER_WT_NUM_NS' placeholder='PRIMER_WT_NUM_NS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_REP_SIM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_REP_SIM' id='PRIMER_WT_REP_SIM' placeholder='PRIMER_WT_REP_SIM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SEQ_QUAL</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_SEQ_QUAL' id='PRIMER_WT_SEQ_QUAL' placeholder='PRIMER_WT_SEQ_QUAL' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_END_QUAL</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_END_QUAL' id='PRIMER_WT_END_QUAL' placeholder='PRIMER_WT_END_QUAL' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_POS_PENALTY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_POS_PENALTY' id='PRIMER_WT_POS_PENALTY' placeholder='PRIMER_WT_POS_PENALTY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_END_STABILITY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_WT_END_STABILITY' id='PRIMER_WT_END_STABILITY' placeholder='PRIMER_WT_END_STABILITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_SIZE_LT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_PRODUCT_SIZE_LT' id='PRIMER_PAIR_WT_PRODUCT_SIZE_LT' placeholder='PRIMER_PAIR_WT_PRODUCT_SIZE_LT' value='0.05' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_SIZE_GT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_PRODUCT_SIZE_GT' id='PRIMER_PAIR_WT_PRODUCT_SIZE_GT' placeholder='PRIMER_PAIR_WT_PRODUCT_SIZE_GT' value='0.05' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_TM_LT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_PRODUCT_TM_LT' id='PRIMER_PAIR_WT_PRODUCT_TM_LT' placeholder='PRIMER_PAIR_WT_PRODUCT_TM_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_TM_GT</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_PRODUCT_TM_GT' id='PRIMER_PAIR_WT_PRODUCT_TM_GT' placeholder='PRIMER_PAIR_WT_PRODUCT_TM_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_DIFF_TM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_DIFF_TM' id='PRIMER_PAIR_WT_DIFF_TM' placeholder='PRIMER_PAIR_WT_DIFF_TM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_ANY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_COMPL_ANY' id='PRIMER_PAIR_WT_COMPL_ANY' placeholder='PRIMER_PAIR_WT_COMPL_ANY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_END</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_COMPL_END' id='PRIMER_PAIR_WT_COMPL_END' placeholder='PRIMER_PAIR_WT_COMPL_END' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_REP_SIM</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_REP_SIM' id='PRIMER_PAIR_WT_REP_SIM' placeholder='PRIMER_PAIR_WT_REP_SIM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PR_PENALTY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_PR_PENALTY' id='PRIMER_PAIR_WT_PR_PENALTY' placeholder='PRIMER_PAIR_WT_PR_PENALTY' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_IO_PENALTY</label> <input type='text' class='form-control' name='PrimerVO.PRIMER_PAIR_WT_IO_PENALTY' id='PRIMER_PAIR_WT_IO_PENALTY' placeholder='PRIMER_PAIR_WT_IO_PENALTY' value='0' />
						</div>
					</div>
                </div>
                
              </div>
            </div>
            
            <div class="card card-info card-outline collapsed-card">
              <div class="card-header">
				<h3 class="card-title">Blocker Parameters</h3>
                <div class="card-tools">
                  <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                    <i class="fas fa-plus"></i>
                  </button>
                </div>
              </div>
              <div class="card-body">
				<div class="row">
                 	<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MISPRIMING_LIBRARY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MISPRIMING_LIBRARY' id='PRIMER_MISPRIMING_LIBRARY' placeholder='PRIMER_MISPRIMING_LIBRARY' value='NONE' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PICK_LEFT</label> <input type='text' class='form-control' name='BlockerVO.MUST_XLATE_PICK_LEFT' id='MUST_XLATE_PICK_LEFT' placeholder='MUST_XLATE_PICK_LEFT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PICK_RIGHT</label> <input type='text' class='form-control' name='BlockerVO.MUST_XLATE_PICK_RIGHT' id='MUST_XLATE_PICK_RIGHT' placeholder='MUST_XLATE_PICK_RIGHT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_LEFT_INPUT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_LEFT_INPUT' id='PRIMER_LEFT_INPUT' placeholder='PRIMER_LEFT_INPUT' value='TGCTCTATGACATCTCAATAA' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_INPUT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_INPUT' id='PRIMER_INTERNAL_OLIGO_INPUT' placeholder='PRIMER_INTERNAL_OLIGO_INPUT' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_RIGHT_INPUT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_RIGHT_INPUT' id='PRIMER_RIGHT_INPUT' placeholder='PRIMER_RIGHT_INPUT' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>Pick_Primers</label> <input type='text' class='form-control' name='BlockerVO.Pick_Primers' id='Pick_Primers' placeholder='Pick_Primers' value='Pick Primers' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SEQUENCE_ID</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_SEQUENCE_ID' id='PRIMER_SEQUENCE_ID' placeholder='PRIMER_SEQUENCE_ID' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>TARGET</label> <input type='text' class='form-control' name='BlockerVO.TARGET' id='TARGET' placeholder='TARGET' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>EXCLUDED_REGION</label> <input type='text' class='form-control' name='BlockerVO.EXCLUDED_REGION' id='EXCLUDED_REGION' placeholder='EXCLUDED_REGION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_SIZE_RANGE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PRODUCT_SIZE_RANGE' id='PRIMER_PRODUCT_SIZE_RANGE' placeholder='PRIMER_PRODUCT_SIZE_RANGE' value='150-250 100-300 301-400 401-500 501-600 601-700 701-850 851-1000' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_NUM_RETURN</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_NUM_RETURN' id='PRIMER_NUM_RETURN' placeholder='PRIMER_NUM_RETURN' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_END_STABILITY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_END_STABILITY' id='PRIMER_MAX_END_STABILITY' placeholder='PRIMER_MAX_END_STABILITY' value='9' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_MISPRIMING</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_MISPRIMING' id='PRIMER_MAX_MISPRIMING' placeholder='PRIMER_MAX_MISPRIMING' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_MISPRIMING</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_MAX_MISPRIMING' id='PRIMER_PAIR_MAX_MISPRIMING' placeholder='PRIMER_PAIR_MAX_MISPRIMING' value='24' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_TEMPLATE_MISPRIMING' id='PRIMER_MAX_TEMPLATE_MISPRIMING' placeholder='PRIMER_MAX_TEMPLATE_MISPRIMING' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING' id='PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING' placeholder='PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING' value='24' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_SIZE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MIN_SIZE' id='PRIMER_MIN_SIZE' placeholder='PRIMER_MIN_SIZE' value='18' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_SIZE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_OPT_SIZE' id='PRIMER_OPT_SIZE' placeholder='PRIMER_OPT_SIZE' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_SIZE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_SIZE' id='PRIMER_MAX_SIZE' placeholder='PRIMER_MAX_SIZE' value='27' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MIN_TM' id='PRIMER_MIN_TM' placeholder='PRIMER_MIN_TM' value='57' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_OPT_TM' id='PRIMER_OPT_TM' placeholder='PRIMER_OPT_TM' value='60' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_TM' id='PRIMER_MAX_TM' placeholder='PRIMER_MAX_TM' value='63' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_DIFF_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_DIFF_TM' id='PRIMER_MAX_DIFF_TM' placeholder='PRIMER_MAX_DIFF_TM' value='100' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_TM_SANTALUCIA</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_TM_SANTALUCIA' id='PRIMER_TM_SANTALUCIA' placeholder='PRIMER_TM_SANTALUCIA' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_MIN_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PRODUCT_MIN_TM' id='PRIMER_PRODUCT_MIN_TM' placeholder='PRIMER_PRODUCT_MIN_TM' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_OPT_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PRODUCT_OPT_TM' id='PRIMER_PRODUCT_OPT_TM' placeholder='PRIMER_PRODUCT_OPT_TM' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_MAX_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PRODUCT_MAX_TM' id='PRIMER_PRODUCT_MAX_TM' placeholder='PRIMER_PRODUCT_MAX_TM' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_GC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MIN_GC' id='PRIMER_MIN_GC' placeholder='PRIMER_MIN_GC' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_GC_PERCENT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_OPT_GC_PERCENT' id='PRIMER_OPT_GC_PERCENT' placeholder='PRIMER_OPT_GC_PERCENT' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_GC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_GC' id='PRIMER_MAX_GC' placeholder='PRIMER_MAX_GC' value='80' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SELF_ANY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_SELF_ANY' id='PRIMER_SELF_ANY' placeholder='PRIMER_SELF_ANY' value='8' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SELF_END</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_SELF_END' id='PRIMER_SELF_END' placeholder='PRIMER_SELF_END' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_NUM_NS_ACCEPTED</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_NUM_NS_ACCEPTED' id='PRIMER_NUM_NS_ACCEPTED' placeholder='PRIMER_NUM_NS_ACCEPTED' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_POLY_X</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MAX_POLY_X' id='PRIMER_MAX_POLY_X' placeholder='PRIMER_MAX_POLY_X' value='5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INSIDE_PENALTY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INSIDE_PENALTY' id='PRIMER_INSIDE_PENALTY' placeholder='PRIMER_INSIDE_PENALTY' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OUTSIDE_PENALTY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_OUTSIDE_PENALTY' id='PRIMER_OUTSIDE_PENALTY' placeholder='PRIMER_OUTSIDE_PENALTY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_FIRST_BASE_INDEX</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_FIRST_BASE_INDEX' id='PRIMER_FIRST_BASE_INDEX' placeholder='PRIMER_FIRST_BASE_INDEX' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_GC_CLAMP</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_GC_CLAMP' id='PRIMER_GC_CLAMP' placeholder='PRIMER_GC_CLAMP' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SALT_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_SALT_CONC' id='PRIMER_SALT_CONC' placeholder='PRIMER_SALT_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SALT_CORRECTIONS</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_SALT_CORRECTIONS' id='PRIMER_SALT_CORRECTIONS' placeholder='PRIMER_SALT_CORRECTIONS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_DIVALENT_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_DIVALENT_CONC' id='PRIMER_DIVALENT_CONC' placeholder='PRIMER_DIVALENT_CONC' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_DNTP_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_DNTP_CONC' id='PRIMER_DNTP_CONC' placeholder='PRIMER_DNTP_CONC' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_DNA_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_DNA_CONC' id='PRIMER_DNA_CONC' placeholder='PRIMER_DNA_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_LIBERAL_BASE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_LIBERAL_BASE' id='PRIMER_LIBERAL_BASE' placeholder='PRIMER_LIBERAL_BASE' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS' id='PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS' placeholder='PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>INCLUDED_REGION</label> <input type='text' class='form-control' name='BlockerVO.INCLUDED_REGION' id='INCLUDED_REGION' placeholder='INCLUDED_REGION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_START_CODON_POSITION</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_START_CODON_POSITION' id='PRIMER_START_CODON_POSITION' placeholder='PRIMER_START_CODON_POSITION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SEQUENCE_QUALITY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_SEQUENCE_QUALITY' id='PRIMER_SEQUENCE_QUALITY' placeholder='PRIMER_SEQUENCE_QUALITY' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_QUALITY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MIN_QUALITY' id='PRIMER_MIN_QUALITY' placeholder='PRIMER_MIN_QUALITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_END_QUALITY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_MIN_END_QUALITY' id='PRIMER_MIN_END_QUALITY' placeholder='PRIMER_MIN_END_QUALITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_QUALITY_RANGE_MIN</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_QUALITY_RANGE_MIN' id='PRIMER_QUALITY_RANGE_MIN' placeholder='PRIMER_QUALITY_RANGE_MIN' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_QUALITY_RANGE_MAX</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_QUALITY_RANGE_MAX' id='PRIMER_QUALITY_RANGE_MAX' placeholder='PRIMER_QUALITY_RANGE_MAX' value='100' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TM_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_TM_LT' id='PRIMER_WT_TM_LT' placeholder='PRIMER_WT_TM_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TM_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_TM_GT' id='PRIMER_WT_TM_GT' placeholder='PRIMER_WT_TM_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SIZE_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_SIZE_LT' id='PRIMER_WT_SIZE_LT' placeholder='PRIMER_WT_SIZE_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SIZE_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_SIZE_GT' id='PRIMER_WT_SIZE_GT' placeholder='PRIMER_WT_SIZE_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_GC_PERCENT_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_GC_PERCENT_LT' id='PRIMER_WT_GC_PERCENT_LT' placeholder='PRIMER_WT_GC_PERCENT_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_GC_PERCENT_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_GC_PERCENT_GT' id='PRIMER_WT_GC_PERCENT_GT' placeholder='PRIMER_WT_GC_PERCENT_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_COMPL_ANY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_COMPL_ANY' id='PRIMER_WT_COMPL_ANY' placeholder='PRIMER_WT_COMPL_ANY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_COMPL_END</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_COMPL_END' id='PRIMER_WT_COMPL_END' placeholder='PRIMER_WT_COMPL_END' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_NUM_NS</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_NUM_NS' id='PRIMER_WT_NUM_NS' placeholder='PRIMER_WT_NUM_NS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_REP_SIM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_REP_SIM' id='PRIMER_WT_REP_SIM' placeholder='PRIMER_WT_REP_SIM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SEQ_QUAL</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_SEQ_QUAL' id='PRIMER_WT_SEQ_QUAL' placeholder='PRIMER_WT_SEQ_QUAL' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_END_QUAL</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_END_QUAL' id='PRIMER_WT_END_QUAL' placeholder='PRIMER_WT_END_QUAL' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_POS_PENALTY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_POS_PENALTY' id='PRIMER_WT_POS_PENALTY' placeholder='PRIMER_WT_POS_PENALTY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_END_STABILITY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_END_STABILITY' id='PRIMER_WT_END_STABILITY' placeholder='PRIMER_WT_END_STABILITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_WT_TEMPLATE_MISPRIMING' id='PRIMER_WT_TEMPLATE_MISPRIMING' placeholder='PRIMER_WT_TEMPLATE_MISPRIMING' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_SIZE_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_PRODUCT_SIZE_LT' id='PRIMER_PAIR_WT_PRODUCT_SIZE_LT' placeholder='PRIMER_PAIR_WT_PRODUCT_SIZE_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_SIZE_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_PRODUCT_SIZE_GT' id='PRIMER_PAIR_WT_PRODUCT_SIZE_GT' placeholder='PRIMER_PAIR_WT_PRODUCT_SIZE_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_TM_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_PRODUCT_TM_LT' id='PRIMER_PAIR_WT_PRODUCT_TM_LT' placeholder='PRIMER_PAIR_WT_PRODUCT_TM_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_TM_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_PRODUCT_TM_GT' id='PRIMER_PAIR_WT_PRODUCT_TM_GT' placeholder='PRIMER_PAIR_WT_PRODUCT_TM_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_DIFF_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_DIFF_TM' id='PRIMER_PAIR_WT_DIFF_TM' placeholder='PRIMER_PAIR_WT_DIFF_TM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_ANY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_COMPL_ANY' id='PRIMER_PAIR_WT_COMPL_ANY' placeholder='PRIMER_PAIR_WT_COMPL_ANY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_END</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_COMPL_END' id='PRIMER_PAIR_WT_COMPL_END' placeholder='PRIMER_PAIR_WT_COMPL_END' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_REP_SIM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_REP_SIM' id='PRIMER_PAIR_WT_REP_SIM' placeholder='PRIMER_PAIR_WT_REP_SIM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PR_PENALTY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_PR_PENALTY' id='PRIMER_PAIR_WT_PR_PENALTY' placeholder='PRIMER_PAIR_WT_PR_PENALTY' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_IO_PENALTY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_IO_PENALTY' id='PRIMER_PAIR_WT_IO_PENALTY' placeholder='PRIMER_PAIR_WT_IO_PENALTY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_PAIR_WT_TEMPLATE_MISPRIMING' id='PRIMER_PAIR_WT_TEMPLATE_MISPRIMING' placeholder='PRIMER_PAIR_WT_TEMPLATE_MISPRIMING' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_EXCLUDED_REGION</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_EXCLUDED_REGION' id='PRIMER_INTERNAL_OLIGO_EXCLUDED_REGION' placeholder='PRIMER_INTERNAL_OLIGO_EXCLUDED_REGION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MIN_SIZE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MIN_SIZE' id='PRIMER_INTERNAL_OLIGO_MIN_SIZE' placeholder='PRIMER_INTERNAL_OLIGO_MIN_SIZE' value='18' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_OPT_SIZE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_OPT_SIZE' id='PRIMER_INTERNAL_OLIGO_OPT_SIZE' placeholder='PRIMER_INTERNAL_OLIGO_OPT_SIZE' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MAX_SIZE</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MAX_SIZE' id='PRIMER_INTERNAL_OLIGO_MAX_SIZE' placeholder='PRIMER_INTERNAL_OLIGO_MAX_SIZE' value='27' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MIN_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MIN_TM' id='PRIMER_INTERNAL_OLIGO_MIN_TM' placeholder='PRIMER_INTERNAL_OLIGO_MIN_TM' value='57' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_OPT_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_OPT_TM' id='PRIMER_INTERNAL_OLIGO_OPT_TM' placeholder='PRIMER_INTERNAL_OLIGO_OPT_TM' value='60' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MAX_TM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MAX_TM' id='PRIMER_INTERNAL_OLIGO_MAX_TM' placeholder='PRIMER_INTERNAL_OLIGO_MAX_TM' value='63' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MIN_GC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MIN_GC' id='PRIMER_INTERNAL_OLIGO_MIN_GC' placeholder='PRIMER_INTERNAL_OLIGO_MIN_GC' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_OPT_GC_PERCENT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_OPT_GC_PERCENT' id='PRIMER_INTERNAL_OLIGO_OPT_GC_PERCENT' placeholder='PRIMER_INTERNAL_OLIGO_OPT_GC_PERCENT' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MAX_GC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MAX_GC' id='PRIMER_INTERNAL_OLIGO_MAX_GC' placeholder='PRIMER_INTERNAL_OLIGO_MAX_GC' value='80' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_SELF_ANY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_SELF_ANY' id='PRIMER_INTERNAL_OLIGO_SELF_ANY' placeholder='PRIMER_INTERNAL_OLIGO_SELF_ANY' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_SELF_END</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_SELF_END' id='PRIMER_INTERNAL_OLIGO_SELF_END' placeholder='PRIMER_INTERNAL_OLIGO_SELF_END' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_NUM_NS</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_NUM_NS' id='PRIMER_INTERNAL_OLIGO_NUM_NS' placeholder='PRIMER_INTERNAL_OLIGO_NUM_NS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MAX_POLY_X</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MAX_POLY_X' id='PRIMER_INTERNAL_OLIGO_MAX_POLY_X' placeholder='PRIMER_INTERNAL_OLIGO_MAX_POLY_X' value='5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MISHYB_LIBRARY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MISHYB_LIBRARY' id='PRIMER_INTERNAL_OLIGO_MISHYB_LIBRARY' placeholder='PRIMER_INTERNAL_OLIGO_MISHYB_LIBRARY' value='NONE' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MAX_MISHYB</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MAX_MISHYB' id='PRIMER_INTERNAL_OLIGO_MAX_MISHYB' placeholder='PRIMER_INTERNAL_OLIGO_MAX_MISHYB' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_MIN_QUALITY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_MIN_QUALITY' id='PRIMER_INTERNAL_OLIGO_MIN_QUALITY' placeholder='PRIMER_INTERNAL_OLIGO_MIN_QUALITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_SALT_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_SALT_CONC' id='PRIMER_INTERNAL_OLIGO_SALT_CONC' placeholder='PRIMER_INTERNAL_OLIGO_SALT_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_DNA_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_DNA_CONC' id='PRIMER_INTERNAL_OLIGO_DNA_CONC' placeholder='PRIMER_INTERNAL_OLIGO_DNA_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_DIVALENT_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_DIVALENT_CONC' id='PRIMER_INTERNAL_OLIGO_DIVALENT_CONC' placeholder='PRIMER_INTERNAL_OLIGO_DIVALENT_CONC' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_DNTP_CONC</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_INTERNAL_OLIGO_DNTP_CONC' id='PRIMER_INTERNAL_OLIGO_DNTP_CONC' placeholder='PRIMER_INTERNAL_OLIGO_DNTP_CONC' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_TM_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_TM_LT' id='PRIMER_IO_WT_TM_LT' placeholder='PRIMER_IO_WT_TM_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_TM_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_TM_GT' id='PRIMER_IO_WT_TM_GT' placeholder='PRIMER_IO_WT_TM_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_SIZE_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_SIZE_LT' id='PRIMER_IO_WT_SIZE_LT' placeholder='PRIMER_IO_WT_SIZE_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_SIZE_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_SIZE_GT' id='PRIMER_IO_WT_SIZE_GT' placeholder='PRIMER_IO_WT_SIZE_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_GC_PERCENT_LT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_GC_PERCENT_LT' id='PRIMER_IO_WT_GC_PERCENT_LT' placeholder='PRIMER_IO_WT_GC_PERCENT_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_GC_PERCENT_GT</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_GC_PERCENT_GT' id='PRIMER_IO_WT_GC_PERCENT_GT' placeholder='PRIMER_IO_WT_GC_PERCENT_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_COMPL_ANY</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_COMPL_ANY' id='PRIMER_IO_WT_COMPL_ANY' placeholder='PRIMER_IO_WT_COMPL_ANY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_NUM_NS</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_NUM_NS' id='PRIMER_IO_WT_NUM_NS' placeholder='PRIMER_IO_WT_NUM_NS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_REP_SIM</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_REP_SIM' id='PRIMER_IO_WT_REP_SIM' placeholder='PRIMER_IO_WT_REP_SIM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_IO_WT_SEQ_QUAL</label> <input type='text' class='form-control' name='BlockerVO.PRIMER_IO_WT_SEQ_QUAL' id='PRIMER_IO_WT_SEQ_QUAL' placeholder='PRIMER_IO_WT_SEQ_QUAL' value='0' />
						</div>
					</div>
                </div>
              </div>
			</div>
			
			
			
			<div class="card card-info card-outline collapsed-card">
              <div class="card-header">
				<h3 class="card-title">Taqman Probe Parameters</h3>
                <div class="card-tools">
                  <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                    <i class="fas fa-plus"></i>
                  </button>
                </div>
              </div>
              <div class="card-body">
				<div class="row">
            		<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>Upload</label> <input type='text' class='form-control' name='ProbeVO.Upload' id='Upload' placeholder='Upload' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MISPRIMING_LIBRARY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MISPRIMING_LIBRARY' id='PRIMER_MISPRIMING_LIBRARY' placeholder='PRIMER_MISPRIMING_LIBRARY' value='NONE' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>Design</label> <input type='text' class='form-control' name='ProbeVO.Design' id='Design' placeholder='Design' value='Design' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRIMER_PICK_LEFT_PRIMER</label> <input type='text' class='form-control' name='ProbeVO.MUST_XLATE_PRIMER_PICK_LEFT_PRIMER' id='MUST_XLATE_PRIMER_PICK_LEFT_PRIMER' placeholder='MUST_XLATE_PRIMER_PICK_LEFT_PRIMER' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_PRIMER</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_PRIMER' id='SEQUENCE_PRIMER' placeholder='SEQUENCE_PRIMER' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRIMER_PICK_RIGHT_PRIMER</label> <input type='text' class='form-control' name='ProbeVO.MUST_XLATE_PRIMER_PICK_RIGHT_PRIMER' id='MUST_XLATE_PRIMER_PICK_RIGHT_PRIMER' placeholder='MUST_XLATE_PRIMER_PICK_RIGHT_PRIMER' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_PRIMER_REVCOMP</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_PRIMER_REVCOMP' id='SEQUENCE_PRIMER_REVCOMP' placeholder='SEQUENCE_PRIMER_REVCOMP' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRIMER_PICK_INTERNAL_OLIGO</label> <input type='text' class='form-control' name='ProbeVO.MUST_XLATE_PRIMER_PICK_INTERNAL_OLIGO' id='MUST_XLATE_PRIMER_PICK_INTERNAL_OLIGO' placeholder='MUST_XLATE_PRIMER_PICK_INTERNAL_OLIGO' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OLIGO_DIRECTION</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_OLIGO_DIRECTION' id='PRIMER_INTERNAL_OLIGO_DIRECTION' placeholder='PRIMER_INTERNAL_OLIGO_DIRECTION' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRIMER_INTERNAL_MODIFY_OLIGO</label> <input type='text' class='form-control' name='ProbeVO.MUST_XLATE_PRIMER_INTERNAL_MODIFY_OLIGO' id='MUST_XLATE_PRIMER_INTERNAL_MODIFY_OLIGO' placeholder='MUST_XLATE_PRIMER_INTERNAL_MODIFY_OLIGO' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_INTERNAL_OLIGO</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_INTERNAL_OLIGO' id='SEQUENCE_INTERNAL_OLIGO' placeholder='SEQUENCE_INTERNAL_OLIGO' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_NUM_RETURN</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_NUM_RETURN' id='PRIMER_NUM_RETURN' placeholder='PRIMER_NUM_RETURN' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_ID</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_ID' id='SEQUENCE_ID' placeholder='SEQUENCE_ID' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_TARGET</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_TARGET' id='SEQUENCE_TARGET' placeholder='SEQUENCE_TARGET' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_OVERLAP_JUNCTION_LIST</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_OVERLAP_JUNCTION_LIST' id='SEQUENCE_OVERLAP_JUNCTION_LIST' placeholder='SEQUENCE_OVERLAP_JUNCTION_LIST' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_EXCLUDED_REGION</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_EXCLUDED_REGION' id='SEQUENCE_EXCLUDED_REGION' placeholder='SEQUENCE_EXCLUDED_REGION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_PRIMER_PAIR_OK_REGION_LIST</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_PRIMER_PAIR_OK_REGION_LIST' id='SEQUENCE_PRIMER_PAIR_OK_REGION_LIST' placeholder='SEQUENCE_PRIMER_PAIR_OK_REGION_LIST' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_INCLUDED_REGION</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_INCLUDED_REGION' id='SEQUENCE_INCLUDED_REGION' placeholder='SEQUENCE_INCLUDED_REGION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_INTERNAL_EXCLUDED_REGION</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_INTERNAL_EXCLUDED_REGION' id='SEQUENCE_INTERNAL_EXCLUDED_REGION' placeholder='SEQUENCE_INTERNAL_EXCLUDED_REGION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_FORCE_LEFT_START</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_FORCE_LEFT_START' id='SEQUENCE_FORCE_LEFT_START' placeholder='SEQUENCE_FORCE_LEFT_START' value='-1000000' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_FORCE_LEFT_END</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_FORCE_LEFT_END' id='SEQUENCE_FORCE_LEFT_END' placeholder='SEQUENCE_FORCE_LEFT_END' value='-1000000' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_FORCE_RIGHT_END</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_FORCE_RIGHT_END' id='SEQUENCE_FORCE_RIGHT_END' placeholder='SEQUENCE_FORCE_RIGHT_END' value='-1000000' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_FORCE_RIGHT_START</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_FORCE_RIGHT_START' id='SEQUENCE_FORCE_RIGHT_START' placeholder='SEQUENCE_FORCE_RIGHT_START' value='-1000000' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_SIZE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_SIZE' id='PRIMER_MIN_SIZE' placeholder='PRIMER_MIN_SIZE' value='17' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_SIZE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_OPT_SIZE' id='PRIMER_OPT_SIZE' placeholder='PRIMER_OPT_SIZE' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_SIZE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_SIZE' id='PRIMER_MAX_SIZE' placeholder='PRIMER_MAX_SIZE' value='30' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_TM' id='PRIMER_MIN_TM' placeholder='PRIMER_MIN_TM' value='57' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_OPT_TM' id='PRIMER_OPT_TM' placeholder='PRIMER_OPT_TM' value='60' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_TM' id='PRIMER_MAX_TM' placeholder='PRIMER_MAX_TM' value='63' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_DIFF_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_DIFF_TM' id='PRIMER_PAIR_MAX_DIFF_TM' placeholder='PRIMER_PAIR_MAX_DIFF_TM' value='5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_MIN_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PRODUCT_MIN_TM' id='PRIMER_PRODUCT_MIN_TM' placeholder='PRIMER_PRODUCT_MIN_TM' value='-1000000.0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_OPT_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PRODUCT_OPT_TM' id='PRIMER_PRODUCT_OPT_TM' placeholder='PRIMER_PRODUCT_OPT_TM' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_MAX_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PRODUCT_MAX_TM' id='PRIMER_PRODUCT_MAX_TM' placeholder='PRIMER_PRODUCT_MAX_TM' value='1000000.0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_GC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_GC' id='PRIMER_MIN_GC' placeholder='PRIMER_MIN_GC' value='30' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OPT_GC_PERCENT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_OPT_GC_PERCENT' id='PRIMER_OPT_GC_PERCENT' placeholder='PRIMER_OPT_GC_PERCENT' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_GC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_GC' id='PRIMER_MAX_GC' placeholder='PRIMER_MAX_GC' value='70' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PRODUCT_SIZE_RANGE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PRODUCT_SIZE_RANGE' id='PRIMER_PRODUCT_SIZE_RANGE' placeholder='PRIMER_PRODUCT_SIZE_RANGE' value='100-150 151-200 201-300 301-400 401-500 501-600 601-700 701-850 851-1000' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_END_STABILITY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_END_STABILITY' id='PRIMER_MAX_END_STABILITY' placeholder='PRIMER_MAX_END_STABILITY' value='9' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_LIBRARY_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_LIBRARY_MISPRIMING' id='PRIMER_MAX_LIBRARY_MISPRIMING' placeholder='PRIMER_MAX_LIBRARY_MISPRIMING' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_LIBRARY_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_LIBRARY_MISPRIMING' id='PRIMER_PAIR_MAX_LIBRARY_MISPRIMING' placeholder='PRIMER_PAIR_MAX_LIBRARY_MISPRIMING' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_TEMPLATE_MISPRIMING_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_TEMPLATE_MISPRIMING_TH' id='PRIMER_MAX_TEMPLATE_MISPRIMING_TH' placeholder='PRIMER_MAX_TEMPLATE_MISPRIMING_TH' value='40' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH' id='PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH' placeholder='PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH' value='70' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_SELF_ANY_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_SELF_ANY_TH' id='PRIMER_MAX_SELF_ANY_TH' placeholder='PRIMER_MAX_SELF_ANY_TH' value='45' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_SELF_END_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_SELF_END_TH' id='PRIMER_MAX_SELF_END_TH' placeholder='PRIMER_MAX_SELF_END_TH' value='35' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_COMPL_ANY_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_COMPL_ANY_TH' id='PRIMER_PAIR_MAX_COMPL_ANY_TH' placeholder='PRIMER_PAIR_MAX_COMPL_ANY_TH' value='45' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_COMPL_END_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_COMPL_END_TH' id='PRIMER_PAIR_MAX_COMPL_END_TH' placeholder='PRIMER_PAIR_MAX_COMPL_END_TH' value='35' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_TEMPLATE_MISPRIMING' id='PRIMER_MAX_TEMPLATE_MISPRIMING' placeholder='PRIMER_MAX_TEMPLATE_MISPRIMING' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING' id='PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING' placeholder='PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING' value='24' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_SELF_ANY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_SELF_ANY' id='PRIMER_MAX_SELF_ANY' placeholder='PRIMER_MAX_SELF_ANY' value='8' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_SELF_END</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_SELF_END' id='PRIMER_MAX_SELF_END' placeholder='PRIMER_MAX_SELF_END' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_COMPL_ANY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_COMPL_ANY' id='PRIMER_PAIR_MAX_COMPL_ANY' placeholder='PRIMER_PAIR_MAX_COMPL_ANY' value='8' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_MAX_COMPL_END</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_MAX_COMPL_END' id='PRIMER_PAIR_MAX_COMPL_END' placeholder='PRIMER_PAIR_MAX_COMPL_END' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_HAIRPIN_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_HAIRPIN_TH' id='PRIMER_MAX_HAIRPIN_TH' placeholder='PRIMER_MAX_HAIRPIN_TH' value='24' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_NS_ACCEPTED</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_NS_ACCEPTED' id='PRIMER_MAX_NS_ACCEPTED' placeholder='PRIMER_MAX_NS_ACCEPTED' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_POLY_X</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_POLY_X' id='PRIMER_MAX_POLY_X' placeholder='PRIMER_MAX_POLY_X' value='4' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INSIDE_PENALTY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INSIDE_PENALTY' id='PRIMER_INSIDE_PENALTY' placeholder='PRIMER_INSIDE_PENALTY' value='-1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_OUTSIDE_PENALTY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_OUTSIDE_PENALTY' id='PRIMER_OUTSIDE_PENALTY' placeholder='PRIMER_OUTSIDE_PENALTY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_FIRST_BASE_INDEX</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_FIRST_BASE_INDEX' id='PRIMER_FIRST_BASE_INDEX' placeholder='PRIMER_FIRST_BASE_INDEX' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_GC_CLAMP</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_GC_CLAMP' id='PRIMER_GC_CLAMP' placeholder='PRIMER_GC_CLAMP' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MAX_END_GC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MAX_END_GC' id='PRIMER_MAX_END_GC' placeholder='PRIMER_MAX_END_GC' value='5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE' id='PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE' placeholder='PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE' value='-1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE' id='PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE' placeholder='PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE' value='-1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION' id='PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION' placeholder='PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION' value='7' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION' id='PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION' placeholder='PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION' value='4' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_DNA_CONC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_DNA_CONC' id='PRIMER_DNA_CONC' placeholder='PRIMER_DNA_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_5_PRIME_TERMINAL_EXCLUDED_MOD</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_5_PRIME_TERMINAL_EXCLUDED_MOD' id='PRIMER_5_PRIME_TERMINAL_EXCLUDED_MOD' placeholder='PRIMER_5_PRIME_TERMINAL_EXCLUDED_MOD' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_3_PRIME_TERMINAL_EXCLUDED_MOD</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_3_PRIME_TERMINAL_EXCLUDED_MOD' id='PRIMER_3_PRIME_TERMINAL_EXCLUDED_MOD' placeholder='PRIMER_3_PRIME_TERMINAL_EXCLUDED_MOD' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MIN_SIZE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MIN_SIZE' id='PRIMER_INTERNAL_MIN_SIZE' placeholder='PRIMER_INTERNAL_MIN_SIZE' value='10' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OPT_SIZE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_OPT_SIZE' id='PRIMER_INTERNAL_OPT_SIZE' placeholder='PRIMER_INTERNAL_OPT_SIZE' value='15' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_SIZE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_SIZE' id='PRIMER_INTERNAL_MAX_SIZE' placeholder='PRIMER_INTERNAL_MAX_SIZE' value='25' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MIN_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MIN_TM' id='PRIMER_INTERNAL_MIN_TM' placeholder='PRIMER_INTERNAL_MIN_TM' value='55' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OPT_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_OPT_TM' id='PRIMER_INTERNAL_OPT_TM' placeholder='PRIMER_INTERNAL_OPT_TM' value='60' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_TM' id='PRIMER_INTERNAL_MAX_TM' placeholder='PRIMER_INTERNAL_MAX_TM' value='67' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MIN_GC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MIN_GC' id='PRIMER_INTERNAL_MIN_GC' placeholder='PRIMER_INTERNAL_MIN_GC' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_OPT_GC_PERCENT </label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_OPT_GC_PERCENT' id='PRIMER_INTERNAL_OPT_GC_PERCENT' placeholder='PRIMER_INTERNAL_OPT_GC_PERCENT' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_GC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_GC' id='PRIMER_INTERNAL_MAX_GC' placeholder='PRIMER_INTERNAL_MAX_GC' value='80' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MIN_TM_VAR</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MIN_TM_VAR' id='PRIMER_INTERNAL_MIN_TM_VAR' placeholder='PRIMER_INTERNAL_MIN_TM_VAR' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_TERMINAL_EXCLUDED_VAR</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_TERMINAL_EXCLUDED_VAR' id='PRIMER_INTERNAL_TERMINAL_EXCLUDED_VAR' placeholder='PRIMER_INTERNAL_TERMINAL_EXCLUDED_VAR' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MOD_NEAR_VAR</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MOD_NEAR_VAR' id='PRIMER_INTERNAL_MOD_NEAR_VAR' placeholder='PRIMER_INTERNAL_MOD_NEAR_VAR' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MOD_VAR_DISTANCE</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MOD_VAR_DISTANCE' id='PRIMER_INTERNAL_MOD_VAR_DISTANCE' placeholder='PRIMER_INTERNAL_MOD_VAR_DISTANCE' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_LIBRARY_MISHYB</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_LIBRARY_MISHYB' id='PRIMER_INTERNAL_MAX_LIBRARY_MISHYB' placeholder='PRIMER_INTERNAL_MAX_LIBRARY_MISHYB' value='12' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB_TH' id='PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB_TH' placeholder='PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB_TH' value='30' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_SELF_ANY_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_SELF_ANY_TH' id='PRIMER_INTERNAL_MAX_SELF_ANY_TH' placeholder='PRIMER_INTERNAL_MAX_SELF_ANY_TH' value='24' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_SELF_END_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_SELF_END_TH' id='PRIMER_INTERNAL_MAX_SELF_END_TH' placeholder='PRIMER_INTERNAL_MAX_SELF_END_TH' value='24' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB' id='PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB' placeholder='PRIMER_INTERNAL_MAX_TEMPLATE_MISHYB' value='9' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_SELF_ANY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_SELF_ANY' id='PRIMER_INTERNAL_MAX_SELF_ANY' placeholder='PRIMER_INTERNAL_MAX_SELF_ANY' value='8' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_SELF_END</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_SELF_END' id='PRIMER_INTERNAL_MAX_SELF_END' placeholder='PRIMER_INTERNAL_MAX_SELF_END' value='8' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_HAIRPIN_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_HAIRPIN_TH' id='PRIMER_INTERNAL_MAX_HAIRPIN_TH' placeholder='PRIMER_INTERNAL_MAX_HAIRPIN_TH' value='24' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_NS_ACCEPTED</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_NS_ACCEPTED' id='PRIMER_INTERNAL_MAX_NS_ACCEPTED' placeholder='PRIMER_INTERNAL_MAX_NS_ACCEPTED' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MAX_POLY_X</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MAX_POLY_X' id='PRIMER_INTERNAL_MAX_POLY_X' placeholder='PRIMER_INTERNAL_MAX_POLY_X' value='5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_DNA_CONC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_DNA_CONC' id='PRIMER_INTERNAL_DNA_CONC' placeholder='PRIMER_INTERNAL_DNA_CONC' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_5_PRIME_TERMINAL_EXCLUDED_MOD</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_5_PRIME_TERMINAL_EXCLUDED_MOD' id='PRIMER_INTERNAL_5_PRIME_TERMINAL_EXCLUDED_MOD' placeholder='PRIMER_INTERNAL_5_PRIME_TERMINAL_EXCLUDED_MOD' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_3_PRIME_TERMINAL_EXCLUDED_MOD</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_3_PRIME_TERMINAL_EXCLUDED_MOD' id='PRIMER_INTERNAL_3_PRIME_TERMINAL_EXCLUDED_MOD' placeholder='PRIMER_INTERNAL_3_PRIME_TERMINAL_EXCLUDED_MOD' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_TM_FORMULA</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_TM_FORMULA' id='PRIMER_TM_FORMULA' placeholder='PRIMER_TM_FORMULA' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SALT_CORRECTIONS</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_SALT_CORRECTIONS' id='PRIMER_SALT_CORRECTIONS' placeholder='PRIMER_SALT_CORRECTIONS' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SALT_MONOVALENT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_SALT_MONOVALENT' id='PRIMER_SALT_MONOVALENT' placeholder='PRIMER_SALT_MONOVALENT' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SALT_DIVALENT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_SALT_DIVALENT' id='PRIMER_SALT_DIVALENT' placeholder='PRIMER_SALT_DIVALENT' value='1.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_DNTP_CONC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_DNTP_CONC' id='PRIMER_DNTP_CONC' placeholder='PRIMER_DNTP_CONC' value='0.6' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRIMER_LIBERAL_BASE</label> <input type='text' class='form-control' name='ProbeVO.MUST_XLATE_PRIMER_LIBERAL_BASE' id='MUST_XLATE_PRIMER_LIBERAL_BASE' placeholder='MUST_XLATE_PRIMER_LIBERAL_BASE' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRIMER_PICK_ANYWAY</label> <input type='text' class='form-control' name='ProbeVO.MUST_XLATE_PRIMER_PICK_ANYWAY' id='MUST_XLATE_PRIMER_PICK_ANYWAY' placeholder='MUST_XLATE_PRIMER_PICK_ANYWAY' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>MUST_XLATE_PRIMER_EXPLAIN_FLAG</label> <input type='text' class='form-control' name='ProbeVO.MUST_XLATE_PRIMER_EXPLAIN_FLAG' id='MUST_XLATE_PRIMER_EXPLAIN_FLAG' placeholder='MUST_XLATE_PRIMER_EXPLAIN_FLAG' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SIZE_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_SIZE_LT' id='PRIMER_WT_SIZE_LT' placeholder='PRIMER_WT_SIZE_LT' value='0.2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SIZE_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_SIZE_GT' id='PRIMER_WT_SIZE_GT' placeholder='PRIMER_WT_SIZE_GT' value='0.2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TM_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_TM_LT' id='PRIMER_WT_TM_LT' placeholder='PRIMER_WT_TM_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TM_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_TM_GT' id='PRIMER_WT_TM_GT' placeholder='PRIMER_WT_TM_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_GC_PERCENT_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_GC_PERCENT_LT' id='PRIMER_WT_GC_PERCENT_LT' placeholder='PRIMER_WT_GC_PERCENT_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_GC_PERCENT_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_GC_PERCENT_GT' id='PRIMER_WT_GC_PERCENT_GT' placeholder='PRIMER_WT_GC_PERCENT_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SELF_ANY_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_SELF_ANY_TH' id='PRIMER_WT_SELF_ANY_TH' placeholder='PRIMER_WT_SELF_ANY_TH' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SELF_END_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_SELF_END_TH' id='PRIMER_WT_SELF_END_TH' placeholder='PRIMER_WT_SELF_END_TH' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TEMPLATE_MISPRIMING_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_TEMPLATE_MISPRIMING_TH' id='PRIMER_WT_TEMPLATE_MISPRIMING_TH' placeholder='PRIMER_WT_TEMPLATE_MISPRIMING_TH' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SELF_ANY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_SELF_ANY' id='PRIMER_WT_SELF_ANY' placeholder='PRIMER_WT_SELF_ANY' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_SELF_END</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_SELF_END' id='PRIMER_WT_SELF_END' placeholder='PRIMER_WT_SELF_END' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_TEMPLATE_MISPRIMING' id='PRIMER_WT_TEMPLATE_MISPRIMING' placeholder='PRIMER_WT_TEMPLATE_MISPRIMING' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_HAIRPIN_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_HAIRPIN_TH' id='PRIMER_WT_HAIRPIN_TH' placeholder='PRIMER_WT_HAIRPIN_TH' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_NUM_NS</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_NUM_NS' id='PRIMER_WT_NUM_NS' placeholder='PRIMER_WT_NUM_NS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_LIBRARY_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_LIBRARY_MISPRIMING' id='PRIMER_WT_LIBRARY_MISPRIMING' placeholder='PRIMER_WT_LIBRARY_MISPRIMING' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_POS_PENALTY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_POS_PENALTY' id='PRIMER_WT_POS_PENALTY' placeholder='PRIMER_WT_POS_PENALTY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_WT_END_STABILITY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_WT_END_STABILITY' id='PRIMER_WT_END_STABILITY' placeholder='PRIMER_WT_END_STABILITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_SIZE_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_PRODUCT_SIZE_LT' id='PRIMER_PAIR_WT_PRODUCT_SIZE_LT' placeholder='PRIMER_PAIR_WT_PRODUCT_SIZE_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_SIZE_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_PRODUCT_SIZE_GT' id='PRIMER_PAIR_WT_PRODUCT_SIZE_GT' placeholder='PRIMER_PAIR_WT_PRODUCT_SIZE_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_TM_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_PRODUCT_TM_LT' id='PRIMER_PAIR_WT_PRODUCT_TM_LT' placeholder='PRIMER_PAIR_WT_PRODUCT_TM_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PRODUCT_TM_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_PRODUCT_TM_GT' id='PRIMER_PAIR_WT_PRODUCT_TM_GT' placeholder='PRIMER_PAIR_WT_PRODUCT_TM_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_ANY_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_COMPL_ANY_TH' id='PRIMER_PAIR_WT_COMPL_ANY_TH' placeholder='PRIMER_PAIR_WT_COMPL_ANY_TH' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_END_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_COMPL_END_TH' id='PRIMER_PAIR_WT_COMPL_END_TH' placeholder='PRIMER_PAIR_WT_COMPL_END_TH' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH' id='PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH' placeholder='PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_ANY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_COMPL_ANY' id='PRIMER_PAIR_WT_COMPL_ANY' placeholder='PRIMER_PAIR_WT_COMPL_ANY' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_COMPL_END</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_COMPL_END' id='PRIMER_PAIR_WT_COMPL_END' placeholder='PRIMER_PAIR_WT_COMPL_END' value='2' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_TEMPLATE_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_TEMPLATE_MISPRIMING' id='PRIMER_PAIR_WT_TEMPLATE_MISPRIMING' placeholder='PRIMER_PAIR_WT_TEMPLATE_MISPRIMING' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_DIFF_TM</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_DIFF_TM' id='PRIMER_PAIR_WT_DIFF_TM' placeholder='PRIMER_PAIR_WT_DIFF_TM' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_LIBRARY_MISPRIMING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_LIBRARY_MISPRIMING' id='PRIMER_PAIR_WT_LIBRARY_MISPRIMING' placeholder='PRIMER_PAIR_WT_LIBRARY_MISPRIMING' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_PR_PENALTY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_PR_PENALTY' id='PRIMER_PAIR_WT_PR_PENALTY' placeholder='PRIMER_PAIR_WT_PR_PENALTY' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_PAIR_WT_IO_PENALTY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_PAIR_WT_IO_PENALTY' id='PRIMER_PAIR_WT_IO_PENALTY' placeholder='PRIMER_PAIR_WT_IO_PENALTY' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_SIZE_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_SIZE_LT' id='PRIMER_INTERNAL_WT_SIZE_LT' placeholder='PRIMER_INTERNAL_WT_SIZE_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_SIZE_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_SIZE_GT' id='PRIMER_INTERNAL_WT_SIZE_GT' placeholder='PRIMER_INTERNAL_WT_SIZE_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_TM_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_TM_LT' id='PRIMER_INTERNAL_WT_TM_LT' placeholder='PRIMER_INTERNAL_WT_TM_LT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_TM_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_TM_GT' id='PRIMER_INTERNAL_WT_TM_GT' placeholder='PRIMER_INTERNAL_WT_TM_GT' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_GC_PERCENT_LT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_GC_PERCENT_LT' id='PRIMER_INTERNAL_WT_GC_PERCENT_LT' placeholder='PRIMER_INTERNAL_WT_GC_PERCENT_LT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_GC_PERCENT_GT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_GC_PERCENT_GT' id='PRIMER_INTERNAL_WT_GC_PERCENT_GT' placeholder='PRIMER_INTERNAL_WT_GC_PERCENT_GT' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_DIFF_TM_VAR</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_DIFF_TM_VAR' id='PRIMER_INTERNAL_WT_DIFF_TM_VAR' placeholder='PRIMER_INTERNAL_WT_DIFF_TM_VAR' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_SELF_ANY_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_SELF_ANY_TH' id='PRIMER_INTERNAL_WT_SELF_ANY_TH' placeholder='PRIMER_INTERNAL_WT_SELF_ANY_TH' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_SELF_END_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_SELF_END_TH' id='PRIMER_INTERNAL_WT_SELF_END_TH' placeholder='PRIMER_INTERNAL_WT_SELF_END_TH' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_TEMPLATE_MISHYB_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_TEMPLATE_MISHYB_TH' id='PRIMER_INTERNAL_WT_TEMPLATE_MISHYB_TH' placeholder='PRIMER_INTERNAL_WT_TEMPLATE_MISHYB_TH' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_SELF_ANY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_SELF_ANY' id='PRIMER_INTERNAL_WT_SELF_ANY' placeholder='PRIMER_INTERNAL_WT_SELF_ANY' value='1' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_SELF_END</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_SELF_END' id='PRIMER_INTERNAL_WT_SELF_END' placeholder='PRIMER_INTERNAL_WT_SELF_END' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_TEMPLATE_MISHYB</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_TEMPLATE_MISHYB' id='PRIMER_INTERNAL_WT_TEMPLATE_MISHYB' placeholder='PRIMER_INTERNAL_WT_TEMPLATE_MISHYB' value='0.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_HAIRPIN_TH</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_HAIRPIN_TH' id='PRIMER_INTERNAL_WT_HAIRPIN_TH' placeholder='PRIMER_INTERNAL_WT_HAIRPIN_TH' value='3' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_NUM_NS</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_NUM_NS' id='PRIMER_INTERNAL_WT_NUM_NS' placeholder='PRIMER_INTERNAL_WT_NUM_NS' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_LIBRARY_MISHYB</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_LIBRARY_MISHYB' id='PRIMER_INTERNAL_WT_LIBRARY_MISHYB' placeholder='PRIMER_INTERNAL_WT_LIBRARY_MISHYB' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_WT_MOD_POS</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_WT_MOD_POS' id='PRIMER_INTERNAL_WT_MOD_POS' placeholder='PRIMER_INTERNAL_WT_MOD_POS' value='1.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_START_CODON_POSITION</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_START_CODON_POSITION' id='SEQUENCE_START_CODON_POSITION' placeholder='SEQUENCE_START_CODON_POSITION' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>SEQUENCE_QUALITY</label> <input type='text' class='form-control' name='ProbeVO.SEQUENCE_QUALITY' id='SEQUENCE_QUALITY' placeholder='SEQUENCE_QUALITY' value='' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_QUALITY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_QUALITY' id='PRIMER_MIN_QUALITY' placeholder='PRIMER_MIN_QUALITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_MIN_END_QUALITY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_MIN_END_QUALITY' id='PRIMER_MIN_END_QUALITY' placeholder='PRIMER_MIN_END_QUALITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_QUALITY_RANGE_MIN</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_QUALITY_RANGE_MIN' id='PRIMER_QUALITY_RANGE_MIN' placeholder='PRIMER_QUALITY_RANGE_MIN' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_QUALITY_RANGE_MAX</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_QUALITY_RANGE_MAX' id='PRIMER_QUALITY_RANGE_MAX' placeholder='PRIMER_QUALITY_RANGE_MAX' value='100' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SEQUENCING_SPACING</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_SEQUENCING_SPACING' id='PRIMER_SEQUENCING_SPACING' placeholder='PRIMER_SEQUENCING_SPACING' value='500' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SEQUENCING_INTERVAL</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_SEQUENCING_INTERVAL' id='PRIMER_SEQUENCING_INTERVAL' placeholder='PRIMER_SEQUENCING_INTERVAL' value='250' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SEQUENCING_LEAD</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_SEQUENCING_LEAD' id='PRIMER_SEQUENCING_LEAD' placeholder='PRIMER_SEQUENCING_LEAD' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_SEQUENCING_ACCURACY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_SEQUENCING_ACCURACY' id='PRIMER_SEQUENCING_ACCURACY' placeholder='PRIMER_SEQUENCING_ACCURACY' value='20' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MIN_QUALITY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MIN_QUALITY' id='PRIMER_INTERNAL_MIN_QUALITY' placeholder='PRIMER_INTERNAL_MIN_QUALITY' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_MISHYB_LIBRARY</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_MISHYB_LIBRARY' id='PRIMER_INTERNAL_MISHYB_LIBRARY' placeholder='PRIMER_INTERNAL_MISHYB_LIBRARY' value='NONE' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_SALT_MONOVALENT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_SALT_MONOVALENT' id='PRIMER_INTERNAL_SALT_MONOVALENT' placeholder='PRIMER_INTERNAL_SALT_MONOVALENT' value='50' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_SALT_DIVALENT</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_SALT_DIVALENT' id='PRIMER_INTERNAL_SALT_DIVALENT' placeholder='PRIMER_INTERNAL_SALT_DIVALENT' value='1.5' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_INTERNAL_DNTP_CONC</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_INTERNAL_DNTP_CONC' id='PRIMER_INTERNAL_DNTP_CONC' placeholder='PRIMER_INTERNAL_DNTP_CONC' value='0' />
						</div>
					</div>
					<div class='col-lg-2 col-md-2 col-sm-2 col-xs-3'>
						<div class='form-group'>
							<label>PRIMER_TASK</label> <input type='text' class='form-control' name='ProbeVO.PRIMER_TASK' id='PRIMER_TASK' placeholder='PRIMER_TASK' value='generic' />
						</div>
					</div>
                </div>
              </div>
            </div>
			
			
			
		</div>
		<div class="card-footer">
			<button type="submit" id="submit-button" class="btn btn-info">Submit</button>
		</div>

	</div>
</form>

<script>
	
</script>
