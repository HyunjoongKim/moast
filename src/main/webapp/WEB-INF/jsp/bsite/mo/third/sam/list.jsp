<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";

	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();
		
		
		
	});
	
	function samFileFilter(val) {
		$("input:radio[name=inputSamFormat]").prop("checked", false);
		$("input:radio[name=inputSamFormat]").prop("disabled", true);
		$("input:radio[name=inputSamFormat][value=" + val + "]").prop("checked", true);
		$("input:radio[name=inputSamFormat][value=" + val + "]").prop("disabled", false);
	}
	
	function samFormatFilter(val) {
		$("input:radio[name=outputSamFormat]").prop("checked", false);
		$("input:radio[name=outputSamFormat]").prop("disabled", true);
		
		if (val == 'BAM') {
			$("input:radio[name=outputSamFormat][value=SAM]").prop("disabled", false);
			$("input:radio[name=outputSamFormat][value=FASTA]").prop("disabled", false);
			$("input:radio[name=outputSamFormat][value=FASTQ]").prop("disabled", false);
		} else if (val == 'SAM') {
			$("input:radio[name=outputSamFormat][value=BAM]").prop("checked", true);
			$("input:radio[name=outputSamFormat][value=BAM]").prop("disabled", false);
		}
	}
	
	function bedFileFilter(val) {
		$("input:radio[name=inputBedFormat]").prop("checked", false);
		$("input:radio[name=inputBedFormat]").prop("disabled", true);
		$("input:radio[name=inputBedFormat][value=" + val + "]").prop("checked", true);
		$("input:radio[name=inputBedFormat][value=" + val + "]").prop("disabled", false);
	}
	
	function bedFormatFilter(val) {
		if (val == "BED") {
			$('#bedSelect').show();
		} else {
			$('#bedSelect').hide();;
		}
		
		$("input:radio[name=outputBedFormat]").prop("checked", false);
		$("input:radio[name=outputBedFormat]").prop("disabled", true);
		
		if (val == 'BED') {
			$("input:radio[name=outputBedFormat][value=BAM]").prop("checked", true);
			$("input:radio[name=outputBedFormat][value=BAM]").prop("disabled", false);
		} else if (val == 'BAM') {
			$("input:radio[name=outputBedFormat][value=BED]").prop("checked", true);
			$("input:radio[name=outputBedFormat][value=BED]").prop("disabled", false);
		}
	}
	
	function initControls() {
		
		// Extract
		$('#executeButton').click(function(){
			executeExtract();
		});
		
		$('#inputFile').on('change',function(e){
            //var fileName = $(this).val();
            var fileName = e.target.files[0].name;
            $(this).next('.custom-file-label').html(fileName);
        })
		
		// SAM
		$('#executeSamButton').click(function(){
			executeSam();
		});

		$(document).on("click", "input:radio[name=inputSamFile]", function() {
			var format = $(this).data("extension");
				
			samFileFilter(format);
			samFormatFilter(format);
		});
		
		$("input:radio[name=inputSamFormat]").click(function() {
			var val = $(this).val();
			samFormatFilter(val);
		});
		
		// BED
		$('#executeBedButton').click(function(){
			executeBed();
		});

		$(document).on("click", "input:radio[name=inputBedFile]", function() {
			var format = $(this).data("extension");
			
			bedFileFilter(format);
			bedFormatFilter(format);
		});
		
		$("input:radio[name=inputBedFormat]").click(function() {
			var val = $(this).val();
			
			bedFormatFilter(val);
		});
		
		// VCF
		$('#executeVcfButton').click(function(){
			executeVcf();
		});
        
        $('#inputVcfFile').on('change',function(e){
            //var fileName = $(this).val();
            var fileName = e.target.files[0].name;
            $(this).next('.custom-file-label').html(fileName);
        })
	}
	
	function executeExtract() {
		const inputFile = $("#inputFile")[0];
		
		if(inputFile.files.length === 0){
			alert('input file을 첨부해주세요.');
			return;
		}
		
		var form = $('#extractForm')[0];
		var formData = new FormData(form);
		
		
		$('#executeButton').hide();
		$('#executeButtonLoding').show();
		
		$.ajax({
			type:"POST",
			url: "${path}/mo/third/sam/extract_action.do",
			processData: false,
			contentType: false,
			data: formData,
			success: function(data){
				//console.log(data);

				if (data.res == "ok") {
					alert(data.msg);
					parseResult(data.data);
				
					$('#samTab').removeClass('disabled');
					$('#bedTab').removeClass('disabled');
					$('#samTab').tab('show');
				}
				
			},
			error: function() {alert('오류가 발생했습니다.');},
	        complete: function(data) {
	        	$('#executeButton').show();
				$('#executeButtonLoding').hide();
			}
			
		})
	}
	
	function validateSam() {
		if ($("input:radio[name=inputSamFile]:checked").length == 0) {
			alert('SAM tools [1. Input File]을 선택해주세요.');
			return false;
		}
		if ($("input:radio[name=inputSamFormat]:checked").length == 0) {
			alert('SAM tools [2. Input format]을 선택해주세요.');
			return false;
		}
		if ($("input:radio[name=outputSamFormat]:checked").length == 0) {
			alert('SAM tools [3. Output format]을 선택해주세요.');
			return false;
		}
		
		return true;
	}
	
	function executeSam() {
		if (validateSam()) {
			var form = $('#samForm')[0];
			var formData = new FormData(form);
			
			
			$('#executeSamButton').hide();
			$('#executeSamButtonLoding').show();
			
			$.ajax({
				type:"POST",
				url: "${path}/mo/third/sam/sam_action.do",
				processData: false,
				contentType: false,
				data: formData,
				success: function(data){
					//console.log(data);
					if (data.res == "ok") {
						alert(data.msg);
						parseResult(data.data);
					}
					
				},
				error: function() {alert('오류가 발생했습니다.');},
		        complete: function(data) {
		        	$('#executeSamButton').show();
					$('#executeSamButtonLoding').hide();
				}
				
			})
		}
	}
	
	function validateBed() {
		if ($("input:radio[name=inputBedFile]:checked").length == 0) {
			alert('BED tools [1. Input File]을 선택해주세요.');
			return false;
		}
		if ($("input:radio[name=inputBedFormat]:checked").length == 0) {
			alert('BED tools [2. Input format]을 선택해주세요.');
			return false;
		}
		if ($("input:radio[name=outputBedFormat]:checked").length == 0) {
			alert('BED tools [3. Output format]을 선택해주세요.');
			return false;
		}
		
		return true;
	}
	
	function executeBed() {
		if (validateBed()) {
			var form = $('#bedForm')[0];
			var formData = new FormData(form);
			
			
			$('#executeBedButton').hide();
			$('#executeBedButtonLoding').show();
			
			$.ajax({
				type:"POST",
				url: "${path}/mo/third/sam/bed_action.do",
				processData: false,
				contentType: false,
				data: formData,
				success: function(data){
					//console.log(data);
					if (data.res == "ok") {
						alert(data.msg);
						parseResult(data.data);
					}
					
				},
				error: function() {alert('오류가 발생했습니다.');},
		        complete: function(data) {
		        	$('#executeBedButton').show();
					$('#executeBedButtonLoding').hide();
				}
				
			})
		}
	}
	
	function validateVcf() {
		const inputFile = $("#inputVcfFile")[0];
		
		if(inputFile.files.length === 0){
			alert('input file을 첨부해주세요.');
			return false;
		}
		
		return true;
	}
	
	function executeVcf() {
		if (validateVcf()) {
			var form = $('#vcfForm')[0];
			var formData = new FormData(form);
			
			$('#executeVcfButton').hide();
			$('#executeVcfButtonLoding').show();
			
			$.ajax({
				type:"POST",
				url: "${path}/mo/third/sam/vcf_action.do",
				processData: false,
				contentType: false,
				data: formData,
				success: function(data){
					//console.log(data);
					if (data.res == "ok") {
						alert(data.msg);
						parseResult(data.data);
					}
					
				},
				error: function() {alert('오류가 발생했습니다.');},
		        complete: function(data) {
		        	$('#executeVcfButton').show();
					$('#executeVcfButtonLoding').hide();
				}
				
			})
		}
	}
	
	function parseResult(r) {
		var dummy = $('#dummyOutputFile').html();
		var outputHtml = dummy.replace(/###/gi, r.fileName);
		$('#outputFileList').append(outputHtml);
		
		// samtools
		if (r.fileFormat == "BAM" || r.fileFormat == "SAM") {
			var samCnt = $('#inputSamFileList').children().length;
			var samHtml = '<li class="custom-control custom-radio">' 
				+ '<input type="radio" name="inputSamFile" id="inputSamFile' + samCnt + '" value="' + r.fileName + '" data-extension="' + r.fileFormat + '">'
				+ '<label for="inputSamFile' + samCnt + '" class="ml-1">' + r.fileName + '</label>'
				+ '</li>';
			
			$('#inputSamFileList').append(samHtml);
		}
		
		// bedtools
		if (r.fileFormat == "BED" || r.fileFormat == "BAM") {
			var bedCnt = $('#inputBedFileList').children().length;
			var bedHtml = '<li class="custom-control custom-radio">' 
				+ '<input type="radio" name="inputBedFile" id="inputBedFile' + bedCnt + '" value="' + r.fileName + '" data-extension="' + r.fileFormat + '">'
				+ '<label for="inputBedFile' + bedCnt + '" class="ml-1">' + r.fileName + '</label>'
				+ '</li>';
			
			$('#inputBedFileList').append(bedHtml);
		}
	}
	
	function downloadFile(src) {
		var url = "${path}/mo/third/sam/download.do";
		$('#toolsOutputFile').val(src);
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "_blank");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
		 
	}
	
</script>




<form id="submitForm" name="submitForm" action="${path }mo/third/sam/download.do" method="post">
	<input type="hidden" name="toolsOutputFile" id="toolsOutputFile" value="" />
</form>


	<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6 ">
							<h3 class="card-title h3icn"> Samtools format conversion</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i> ThirdPart Tools <i class="fa fa-chevron-right ml-2 mr-2"></i> Samtools </div>
					</div>
				</div>
				<!-- //title -->

				<!-- 컨텐츠 영역 -->
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!-- contents start -->

							<div class="card">
<!-- 								
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i>BAM extraction

									</h3>
								</div>
 -->
								<div class="card-body">
									<ul class="nav nav-tabs" id="toolsTab" role="tablist">
										<li class="nav-item" role="presentation">
											<a class="nav-link active" id="extractTab" data-toggle="tab" href="#extractTabPanel" role="tab">BAM Extract</a>
										</li>
										<li class="nav-item" role="presentation">
											<a class="nav-link disabled" id="samTab" data-toggle="tab" href="#samTabPanel" role="tab">SAM tools</a>
										</li>
										<li class="nav-item" role="presentation">
											<a class="nav-link disabled" id="bedTab" data-toggle="tab" href="#bedTabPanel" role="tab">BED tools</a>
										</li>
										<li class="nav-item" role="presentation">
											<a class="nav-link " id="vcfTab" data-toggle="tab" href="#vcfTabPanel" role="tab">VCF tools</a>
										</li>
									</ul>
									
									<div class="row">
										<div class="col-lg-9 col-sm-12">
											<div class="tab-content" id="tabContent">
									
												<!-- Extract -->
												<div class="tab-pane active show" id="extractTabPanel" role="tabpanel">
													<form id="extractForm" name="extractForm" action="${path }/mo/third/sam/extract_action.do" method="post">
														<div class="card card-outline card-info  mt-3">
															<div class="card-header">
																<h3 class="card-title"><i class="ion ion-clipboard mr-1"></i>source files</h3>
															</div>
					
															<div class="card-body">
																<div class="row">
																	<div class="col-9">
																		<div class="custom-file ">
																			<input type="file" class="custom-file-input" id="inputFile" name="inputFile">
																			<label class="custom-file-label" for="inputFile" id="inputFileLabel">file</label>
																		</div>
																		<ul class="mb-0" id="fileUl">
																			<!-- <li id="fileLi1">file.xls (000Kbyte) <button class="btn btn-sm"><i class="fa fa-window-close"></i></button></li> -->
																		</ul>
																	</div>
																</div>
																	
																<div class="row mt-3">
																	<div class="col-3">
																		<div class="input-group input-group-sm mb-3">
																			<div class="input-group-prepend">
																				<span class="input-group-text" id="be-addon1">Chr_name</span>
																			</div>
																			<input type="text" class="form-control" name="be_Chr_name" aria-describedby="basic-addon1">
																		</div>
																	</div>
																	<div class="col-3">
																		<div class="input-group input-group-sm mb-3">
																			<div class="input-group-prepend">
																				<span class="input-group-text" id="be-addon2">start</span>
																			</div>
																			<input type="text" class="form-control" name="be_start" aria-describedby="basic-addon2">
																		</div>
																	</div>
																	<div class="col-3">
																		<div class="input-group input-group-sm mb-3">
																			<div class="input-group-prepend">
																				<span class="input-group-text" id="be-addon3">end</span>
																			</div>
																			<input type="text" class="form-control" name="be_end" aria-describedby="basic-addon3">
																		</div>
																	</div>
																</div>
																<div class="row mt-3">
																	<div class="col-2 offset-7">
																		<button type="button" id="executeButton" class="btn btn-primary btn-block"><i class="fas fa-play"></i> Run</button>
																		<button id="executeButtonLoding" class="btn btn-primary initHide btn-sm" type="button" disabled="">
																			<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
																		</button>
																	</div>
																</div>	
															</div>
														</div>
													</form>
												</div>
												
												<!-- SAM -->
												<div class="tab-pane" id="samTabPanel" role="tabpanel">
													<form id="samForm" name="samForm" action="${path }mo/third/sam/sam_action.do" method="post">
														<div class="row mt-3">
															<div class="col-lg-4 col-sm-6">
																<div class="card card-outline card-primary">
																	<div class="card-header">
																		<h3 class="card-title">1. select Input File</h3>
																	</div>
							
																	<div class="card-body">
																		<ul id="inputSamFileList">
																			<!-- 
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputSamFile" id="inputSamFile0" value="input2.sam" data-extension="SAM">
																				<label for="inputSamFile0" class="ml-1">input2.sam file</label>
																			</li>
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputSamFile" id="inputSamFile1" value="input.bam" data-extension="BAM">
																				<label for="inputSamFile1" class="ml-1">input.bam file</label>
																			</li>
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputSamFile" id="inputSamFile2" value="input.sam" data-extension="SAM">
																				<label for="inputSamFile2" class="ml-1">input.sam file</label>
																			</li>
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputSamFile" id="inputSamFile3" value="input2.bam" data-extension="BAM">
																				<label for="inputSamFile3" class="ml-1">input2.bam file</label>
																			</li>
																			 -->
																		</ul>
																	</div>
																</div>
															</div>
															
															<div class="col-lg-3 col-sm-6">
																<div class="card card-outline card-info">
																	<div class="card-header">
																		<h3 class="card-title">2. Input format</h3>
																	</div>
							
																	<div class="card-body">
																		<div class="form-group" id="inputSamFormatList">
																			<div class="custom-control custom-radio">
																				<input type="radio" name="inputSamFormat" id="inputSamBam" value="BAM">
																				<label for="inputSamBam">BAM</label>
																			</div>
																			<div class="custom-control custom-radio">
																				<input type="radio" name="inputSamFormat" id="inputSamSam" value="SAM">
																				<label for="inputSamSam">SAM</label>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
							
															<div class="col-lg-2 col-sm-6 text-center convert">
																<div class=" arrow">
																	Convert
																	<i class="icn"></i>
																</div>
															</div>
															
															<div class="col-lg-3 col-sm-6">
																<div class="card card-outline card-success  ">
																	<div class="card-header">
																		<h3 class="card-title">3. Output format</h3>
																	</div>
							
																	<div class="card-body">
																		<div class="form-group">
																			
																		<div class="custom-control custom-radio">
																				<input type="radio" name="outputSamFormat" id="outputSamBam" value="BAM"/> 
																				<label for="outputSamBam">BAM</label>
																			</div>
																			<div class="custom-control custom-radio">
																				<input type="radio" name="outputSamFormat" id="outputSamSam" value="SAM"/>
																				<label for="outputSamSam">SAM</label>
																			</div>
																			<div class="custom-control custom-radio">
																				<input type="radio" name="outputSamFormat" id="outputSamFasta" value="FASTA"/>
																				<label for="outputSamFasta">FASTA</label>
																			</div>
																			<div class="custom-control custom-radio">
																				<input type="radio" name="outputSamFormat" id="outputSamFastq" value="FASTQ"/>
																				<label for="outputSamFastq">FASTQ</label>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
														<div class="row ">
															<div class="offset-lg-9 col-lg-2 col-sm-12">
																<button type="button" id="executeSamButton" class="btn btn-primary btn-block"><i class="fas fa-play"></i> Run</button>
																<button id="executeSamButtonLoding" class="btn btn-primary initHide btn-sm" type="button" disabled="">
																	<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
																</button>
															</div>
														</div>
													</form>	
												</div>
												
												<!-- BED -->
												<div class="tab-pane" id="bedTabPanel" role="tabpanel">
													<form id="bedForm" name="bedForm" action="${path }mo/third/sam/bed_action.do" method="post">
														<div class="row mt-3">
															<div class="col-lg-4 col-sm-6">
																<div class="card card-outline card-primary">
																	<div class="card-header">
																		<h3 class="card-title">1. select Input File</h3>
																	</div>
							
																	<div class="card-body">
																		<ul id="inputBedFileList">
																			<!-- 
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputBedFile" id="inputBedFile0" value="input2.bed" data-extension="BED">
																				<label for="inputBedFile0" class="ml-1">input2.bed file</label>
																			</li>
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputBedFile" id="inputBedFile1" value="input.bam" data-extension="BAM">
																				<label for="inputBedFile1" class="ml-1">input.bam file</label>
																			</li>
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputBedFile" id="inputBedFile2" value="input2.bam" data-extension="BAM">
																				<label for="inputBedFile2" class="ml-1">input2.bam file</label>
																			</li>
																			<li class="custom-control custom-radio">
																				<input type="radio" name="inputBedFile" id="inputBedFile3" value="input.bed" data-extension="BED">
																				<label for="inputBedFile3" class="ml-1">input.bed file</label>
																			</li>
																			 -->
																		</ul>
																	</div>
																</div>
															</div>
															
															<div class="col-lg-3 col-sm-6">
																<div class="card card-outline card-info">
																	<div class="card-header">
																		<h3 class="card-title">2. Input format</h3>
																	</div>
							
																	<div class="card-body">
																		<div class="form-group" id="inputBedFormatList">
																			<div class="custom-control custom-radio">
																				<input type="radio" name="inputBedFormat" id="inputBedBed" value="BED">
																				<label for="inputBedBed">BED</label>
																			</div>
																			<div class="custom-control custom-radio">
																				<input type="radio" name="inputBedFormat" id="inputBedBam" value="BAM">
																				<label for="inputBedBam">BAM</label>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
							
															<div class="col-lg-2 col-sm-6 text-center convert">
																<div class=" arrow">
																	Convert
																	<i class="icn"></i>
																</div>
															</div>
															
															<div class="col-lg-3 col-sm-6">
																<div class="card card-outline card-success  ">
																	<div class="card-header">
																		<h3 class="card-title">3. Output format</h3>
																	</div>
							
																	<div class="card-body">
																		<div class="form-group">
																			<div class="custom-control custom-radio">
																				<input type="radio" name="outputBedFormat" id="outputBedBam" value="BAM"/> 
																				<label for="outputBedBam">BAM</label>
																			</div>
																			<div class="custom-control custom-radio">
																				<input type="radio" name="outputBedFormat" id="outputBedBed" value="BED"/> 
																				<label for="outputBedBed">BED</label>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
														<div class="row mt-3" id="bedSelect" style="display: no ne">
															<div class="col-7">
																<div class="card card-outline ">
																	<!-- 
																	<div class="card-header">
																		<h3 class="card-title">1. select Input File</h3>
																	</div>
																	 -->
																	<div class="card-body">
																		<div class="row mt-3">
																			<div class="col-6">
																				<label for="genomeFormat">Genome Format</label>
																				<select class="form-control" id="genomeFormat" name="genomeFormat">
																					<option value="UCSC">UCSC</option>
																					<option value="Ensemble">Ensemble</option>
																				</select>
																			</div>
																			<div class="col-6">
																				<label for="genomeVersion">Genome Version</label>
																				<select class="form-control" id="genomeVersion" name="genomeVersion">
																					<option value="hg19">hg19</option>
																					<option value="hg38">hg38</option>
																				</select>
																			</div>
																		</div>
																		
																	</div>
																</div>

															</div>
															
														</div>
														<div class="row">
															<div class="offset-lg-9 col-lg-2 col-sm-12">
																<button type="button" id="executeBedButton" class="btn btn-primary btn-block"><i class="fas fa-play"></i> Run</button>
																<button id="executeBedButtonLoding" class="btn btn-primary initHide btn-sm" type="button" disabled="">
																	<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
																</button>
															</div>
														</div>
													</form>
												</div>
												
												<!-- VCF -->
												<div class="tab-pane" id="vcfTabPanel" role="tabpanel">
													<form id="vcfForm" name="vcfForm" action="${path }mo/third/sam/vcf_action.do" method="post">
														<div class="row mt-3">
															<div class="col-lg-4 col-sm-6">
																<div class="card card-outline card-primary">
																	<div class="card-header">
																		<h3 class="card-title">1. select Input File</h3>
																	</div>
							
																	<div class="card-body">
																		<div class="custom-file ">
																			<input type="file" class="custom-file-input" id="inputVcfFile" name="inputFile">
																			<label class="custom-file-label" for="inputVcfFile" id="inputVcfFileLabel">File</label>
																		</div>
																	</div>
																</div>
															</div>
															
															<div class="col-lg-3 col-sm-6">
																<div class="card card-outline card-info">
																	<div class="card-header">
																		<h3 class="card-title">2. Input format</h3>
																	</div>
							
																	<div class="card-body">
																		<div class="form-group" id="inputfVcfFormatList">
																			<div class="custom-control custom-radio">
																				<input type="radio" name="inputVcfFormat" id="inputVcfVcf" value="VCF" checked="checked">
																				<label for="inputVcfVcf">VCF</label>
																			</div>
																			
																		</div>
																	</div>
																</div>
															</div>
							
															<div class="col-lg-2 col-sm-6 text-center convert">
																<div class=" arrow">
																	Convert
																	<i class="icn"></i>
																</div>
															</div>
															
															<div class="col-lg-3 col-sm-6">
																<div class="card card-outline card-success  ">
																	<div class="card-header">
																		<h3 class="card-title">3. Output format</h3>
																	</div>
							
																	<div class="card-body">
																		<div class="form-group">
																		<!-- 
																			<div class="custom-control custom-radio">
																				<input type="radio" name="outputVcfFormat" id="outputVcfBam" value="BAM"/> 
																				<label for="outputVcfBam">BAM</label>
																			</div>
																			 -->
																			<div class="custom-control custom-radio">
																				<input type="radio" name="outputVcfFormat" id="outputVcfBed" value="BED"/> 
																				<label for="outputVcfBed">BED</label>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
														<div>
															<div class="offset-lg-9 col-lg-2 col-sm-12">
																<button type="button" id="executeVcfButton" class="btn btn-primary btn-block"><i class="fas fa-play"></i> Run</button>
																<button id="executeVcfButtonLoding" class="btn btn-primary initHide btn-sm" type="button" disabled="">
																	<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
																</button>
															</div>
														</div>
													</form>
												</div>
											</div>
										</div>
										<div class="col-lg-3 col-sm-12">
											<div class="card card-outline card-primary mt-3">
												<div class="card-header">
													<h3 class="card-title">download output files</h3>
												</div>
		
												<div class="card-body">
													<ul id="outputFileList">
														<!-- 
														<li><button type="button" class="btn btn-sm btn-primary mb-1" onclick="downloadFile('output.bed')">output.bed file</button></li>
														<li><button type="button" class="btn btn-sm btn-primary mb-1" onclick="downloadFile('output.sam')">output.sam file</button></li>
														<li><button type="button" class="btn btn-sm btn-primary mb-1" onclick="downloadFile('output.fasta')">output.fasta file</button></li>
														<li><button type="button" class="btn btn-sm btn-primary mb-1" onclick="downloadFile('output.fastq')">output.fastq file</button></li>
														 -->
													</ul>
												</div>
											</div>
										</div>
									</div>
									
									
								</div>


							<!-- // contents end -->

						</div>
					</section>
				</div>


<div id="dummy" style="display: none;">
	<div id="dummyInputSamFile">
		
	</div>
	<div id="dummyOutputFile">
		<li><button type="button" class="btn btn-sm btn-primary mb-1" onclick="downloadFile('###')">### file</button></li>	
	</div>
	
</div>
