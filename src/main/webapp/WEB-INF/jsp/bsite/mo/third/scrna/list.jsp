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
	
	function initControls() {
		$("#barcodeFile").on('change', function() {
			$("#barcodeFileLabel").text(getFileName(this));
		});
		$("#genesFile").on('change', function() {
			$("#genesFileLabel").text(getFileName(this));
		});
		$("#matrixFile").on('change', function() {
			$("#matrixFileLabel").text(getFileName(this));
		});
		
		$('#executeButton').click(function(){
			if (!$("#barcodeFile").val()) {
				alert('barcode file을 첨부해주세요.');
				return false;
				
			} else if (!$("#genesFile").val()) {
				alert('genes file을 첨부해주세요.');
				return false;
				
			} else if (!$("#matrixFile").val()) {
				alert('matrix file을 첨부해주세요.');
				return false;
			}
			
			$('#executeButton').hide();
			$('#executeButtonLoding').show();
			
			$('#submitForm').prop("action", "${path }/mo/third/scrna/upload.do");
			$('#submitForm').submit();
		});
		
	}
	
	function getFileName(e){  // 값이 변경되면
		var filename = '';
		if(window.FileReader){
			filename = $(e)[0].files[0].name;
		} else {
 			filename = $(e).val().split('/').pop().split('\\').pop();
		}
		
		return filename;
	}
		
</script>




<form:form commandName="searchVO" method="post" name="submitForm" id="submitForm" action="${path }/mo/third/scrna/list.do" enctype="multipart/form-data" >
	<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6 ">
							<h3 class="card-title h3icn"> SingleCell RNA analysis</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i> ThirdPart Tools <i class="fa fa-chevron-right ml-2 mr-2"></i> scRNA </div>
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
										<i class="ion ion-clipboard mr-1"></i>INPUT FILE
									</h3>
								</div>

								<div class="card-body">
									<div class="row">
										<div class="col-lg-4 col-md-6">
											<div class="custom-file ">
												<input type="file" class="custom-file-input" id="barcodeFile" name="barcodeFile">
												<label class="custom-file-label" for="barcodeFile" id="barcodeFileLabel">Barcode File</label>
											</div>
										</div>
										<div class="col-lg-8 col-md-6">
											<a href="/downx/barcodes.tsv" class="btn btn-sm btn-primary" download>Download sample barcode file</a>
										</div>
									</div>
									<div class="row mt-3">	
										<div class="col-lg-4 col-md-6">
											<div class="custom-file ">
												<input type="file" class="custom-file-input" id="genesFile" name="genesFile">
												<label class="custom-file-label" for="genesFile" id="genesFileLabel">Genes File</label>
											</div>
										</div>
										<div class="col-lg-8 col-md-6">
											<a href="/downx/genes.tsv" class="btn btn-sm btn-primary" download>Download sample genes file</a>
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-lg-4 col-md-6">
											<div class="custom-file ">
												<input type="file" class="custom-file-input" id="matrixFile" name="matrixFile">
												<label class="custom-file-label" for="matrixFile" id="matrixFileLabel">Matrix File</label>
											</div>
										</div>
										<div class="col-lg-8 col-md-6">
											<a href="/downx/matrix.mtx" class="btn btn-sm btn-primary" download>Download sample matrix file</a>
										</div>
									</div>
									
									<div class="mt-3">
										<div class="float-left">
											<button type="button" class="btn btn-success" id="executeButton"><i class="fas fa-play"></i> Run</button>
											<button id="executeButtonLoding" class="btn btn-primary initHide btn-sm" type="button" disabled="">
												<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
											</button>
										</div>
									</div>
								</div>
							</div>
							
							<c:if test="${fn:length(imageList) > 0}">
								<div class="card">
									<div class="card-header">
										<h3 class="card-title">
											<i class="ion ion-clipboard mr-1"></i>result image
										</h3>
									</div>
	
									<div class="card-body">
										<div class="row">
											<c:forEach var="image" items="${imageList}" varStatus="status">
												<div class="col-6 ">
													<img src='${image}' />
												</div>
											</c:forEach>
										</div>
									</div>
								</div>
							</c:if>
							


							<!-- // contents end -->

						</div>
					</section>
				</div>
				<!-- // 기본정보관리-->

</form:form>
