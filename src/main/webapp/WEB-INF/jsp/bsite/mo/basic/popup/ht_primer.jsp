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
		$('textarea').keyup(function() {
			 $(this).css("overflow", "hidden");
			 $(this).css("height", "0");
			 $(this).css("height", 8 + $(this).prop("scrollHeight") + "px");
		});
		
		$("#submitForm").submit(function(e){
			var win = window.open("", "PopHtPrimerOutput", "width=1600,height=820");
			/* var url = "${path}/mo/basic/popup/htPrimer_output.do";
			
			$('#submitForm').prop("action", url);
			$('#submitForm').prop("target", "PopHtPrimerOutput");
			$('#submitForm').prop("method", "post");
	        $('#submitForm').submit() ; */

		})
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
<form id="submitForm" action="${path}/mo/basic/popup/htPrimer_output.do" method="post" target="PopHtPrimerOutput">
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx}">
	<div class="card">
		<div class="card-header">
			<h3 class="card-title">
				<i class="ion ion-clipboard mr-1"></i>HT Primer
			</h3>
		</div>
	
		<div class="card-body">
			<div class="row">
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>genome</label>
						<input type="text" class="form-control" name="genome" id="genome" placeholder="genome" value="Human">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>genome_assembly</label>
						<input type="text" class="form-control" name="genome_assembly" id="genome_assembly" placeholder="genome_assembly" value="hg38">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>dbsnp_build</label>
						<input type="text" class="form-control" name="dbsnp_build" id="dbsnp_build" placeholder="dbsnp_build" value="snp146">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>primer_type</label>
						<input type="text" class="form-control" name="primer_type" id="primer_type" placeholder="primer_type" value="bsp">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>restriction_enzyme</label>
						<input type="text" class="form-control" name="restriction_enzyme" id="restriction_enzyme" placeholder="restriction_enzyme" value="">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>max_primer_to_return</label>
						<input type="text" class="form-control" name="max_primer_to_return" id="max_primer_to_return" placeholder="max_primer_to_return" value="10">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>target_regions</label>
						<input type="text" class="form-control" name="target_regions" id="target_regions" placeholder="target_regions" value="200,10">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>included_regions</label>
						<input type="text" class="form-control" name="included_regions" id="included_regions" placeholder="included_regions" value="">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>min_product_size</label>
						<input type="text" class="form-control" name="min_product_size" id="min_product_size" placeholder="min_product_size" value="150">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>opt_product_size</label>
						<input type="text" class="form-control" name="opt_product_size" id="opt_product_size" placeholder="opt_product_size" value="250">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>max_product_size</label>
						<input type="text" class="form-control" name="max_product_size" id="max_product_size" placeholder="max_product_size" value="320">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>min_primer_tm</label>
						<input type="text" class="form-control" name="min_primer_tm" id="min_primer_tm" placeholder="min_primer_tm" value="52">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>opt_primer_tm</label>
						<input type="text" class="form-control" name="opt_primer_tm" id="opt_primer_tm" placeholder="opt_primer_tm" value="60">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>max_primer_tm</label>
						<input type="text" class="form-control" name="max_primer_tm" id="max_primer_tm" placeholder="max_primer_tm" value="65">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>min_primer_size</label>
						<input type="text" class="form-control" name="min_primer_size" id="min_primer_size" placeholder="min_primer_size" value="22">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>opt_primer_size</label>
						<input type="text" class="form-control" name="opt_primer_size" id="opt_primer_size" placeholder="opt_primer_size" value="28">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>max_primer_size</label>
						<input type="text" class="form-control" name="max_primer_size" id="max_primer_size" placeholder="max_primer_size" value="36">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>cpg_product</label>
						<input type="text" class="form-control" name="cpg_product" id="cpg_product" placeholder="cpg_product" value="">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>cpg_in_primer</label>
						<input type="text" class="form-control" name="cpg_in_primer" id="cpg_in_primer" placeholder="cpg_in_primer" value="">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>primer_non_cpg_c</label>
						<input type="text" class="form-control" name="primer_non_cpg_c" id="primer_non_cpg_c" placeholder="primer_non_cpg_c" value="4">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>primer_polyt</label>
						<input type="text" class="form-control" name="primer_polyt" id="primer_polyt" placeholder="primer_polyt" value="8">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>primer_polyx</label>
						<input type="text" class="form-control" name="primer_polyx" id="primer_polyx" placeholder="primer_polyx" value="5">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>min_hyb_size</label>
						<input type="text" class="form-control" name="min_hyb_size" id="min_hyb_size" placeholder="min_hyb_size" value="18">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>opt_hyb_size</label>
						<input type="text" class="form-control" name="opt_hyb_size" id="opt_hyb_size" placeholder="opt_hyb_size" value="20">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>max_hyb_size</label>
						<input type="text" class="form-control" name="max_hyb_size" id="max_hyb_size" placeholder="max_hyb_size" value="27">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>min_hyb_tm</label>
						<input type="text" class="form-control" name="min_hyb_tm" id="min_hyb_tm" placeholder="min_hyb_tm" value="52">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>opt_hyb_tm</label>
						<input type="text" class="form-control" name="opt_hyb_tm" id="opt_hyb_tm" placeholder="opt_hyb_tm" value="60">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>max_hyb_tm</label>
						<input type="text" class="form-control" name="max_hyb_tm" id="max_hyb_tm" placeholder="max_hyb_tm" value="65">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>min_hyb_gc</label>
						<input type="text" class="form-control" name="min_hyb_gc" id="min_hyb_gc" placeholder="min_hyb_gc" value="20">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>opt_hyb_gc</label>
						<input type="text" class="form-control" name="opt_hyb_gc" id="opt_hyb_gc" placeholder="opt_hyb_gc" value="50">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>max_hyb_gc</label>
						<input type="text" class="form-control" name="max_hyb_gc" id="max_hyb_gc" placeholder="max_hyb_gc" value="80">
					</div>
				</div>
				<div class="col-lg-2 col-md-2 col-sm-2 col-xs-3">
					<div class="form-group">
						<label>submit</label>
						<input type="text" class="form-control" name="submit" id="submit" placeholder="submit" value="submit">
					</div>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-lg-12">
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">target_file</label>
						<textarea class="col-sm-4 form-control" rows="1" id="target_file_string" name="target_file_string">
<c:forEach var="record" items="${searchVO.target_file_string}">${record}
</c:forEach></textarea>
						<div class="col-sm-2 custom-file">
							<label class="btn btn-default">
							    Browse <input type="file" name="target_file" id="target_file" hidden="hidden">
							</label>
						</div>
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">pcr_primer3_param_file</label>
						<textarea class="col-sm-4 form-control" rows="1" id="pcr_primer3_param_file_string" name="pcr_primer3_param_file_string">${searchVO.pcr_primer3_param_file}</textarea>
						<div class="col-sm-2 custom-file">
							<label class="btn btn-default">
							    Browse <input type="file" name="pcr_primer3_param_file" id="pcr_primer3_param_file" hidden="hidden">
							</label>
						</div>
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">restriction_enzyme_file</label>
						<textarea class="col-sm-4 form-control" rows="1" id="restriction_enzyme_file_string" name="restriction_enzyme_file_string">${searchVO.restriction_enzyme_file}</textarea>
						<div class="col-sm-2 custom-file">
							<label class="btn btn-default">
							    Browse <input type="file" name="restriction_enzyme_file" id="restriction_enzyme_file" hidden="hidden">
							</label>
						</div>
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">quality_matrix_file</label>
						<textarea class="col-sm-4 form-control" rows="1" id="quality_matrix_file_string" name="quality_matrix_file_string">${searchVO.quality_matrix_file}</textarea>
						<div class="col-sm-2 custom-file">
							<label class="btn btn-default">
							    Browse <input type="file" name="quality_matrix_file" id="quality_matrix_file" hidden="hidden">
							</label>
						</div>
					</div>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-lg-2">
					<button type="submit" class="btn btn-primary">Submit</button>
				</div>
			</div>
		</div>
			
	</div>
</form>

<script>




</script>
