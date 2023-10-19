<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<style>

table.table-font-small td {
	font-size: 9pt;
}

[data-toggle="tooltip"] {
	cursor: pointer;
}

.tooltip-image {
	max-height: 150px;
	max-width: 150px;
}

</style>


<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";

	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
	});
	
	
	$( document ).ready(function() {
		$('a[data-toggle="tooltip"]').tooltip({
		    animated: 'fade',
		    placement: 'bottom',
		    html: true
		});
		
		$(document).on("click", ".btn-openupdate", function () {
		     $("#modal-update .modal-body #recordIdx").val( $(this).data('idx') );
		     $("#modal-update .modal-body #tsId").val( $(this).data('tsid') );
		     $("#modal-update .modal-body #fpSeq").val( $(this).data('fpseq') );
		     $("#modal-update .modal-body #rpSeq").val( $(this).data('rpseq') );
		     $("#modal-update .modal-body #ampId").val( $(this).data('ampid') );
		     $("#modal-update .modal-body #ampBed").val( $(this).data('ampbed') );
		     $("#modal-update .modal-body #hybProbe").val( $(this).data('hybprobe') );
		     $("#modal-update .modal-body #comment").val( $(this).data('comment') );

		     if ($(this).data('option1')!=null && $(this).data('option1')===true) {
		         $("#modal-update .modal-body [name=option1][value=1]").prop( "checked", true );
		         console.log($(this).data('option1'), $(this).data('option1')==true, 0)
		     } else if ($(this).data('option1')!=null && $(this).data('option1')===false) {
		    	 $("#modal-update .modal-body [name=option1][value=0]").prop( "checked", true );
		     }
		});
		
		
		$(document).on("click", "#update-save", function(){
			$.ajax({
				url: "${path}/mo/analysisdata/methylation/htprimer/update.do",
				method: "post",
			  	processData: false,
			  	mimeType: "multipart/form-data",
			  	contentType: false,
				/* data: JSON.stringify({
					recordIdx: $("#modal-update .modal-body #recordIdx").val(),
					tsId: $("#modal-update .modal-body #tsId").val(),
					fpSeq: $("#modal-update .modal-body #fpSeq").val(),
					rpSeq: $("#modal-update .modal-body #rpSeq").val(),
					ampId: $("#modal-update .modal-body #ampId").val(),
					ampBed: $("#modal-update .modal-body #ampBed").val(),
					hybProbe: $("#modal-update .modal-body #hybProbe").val(),
					comment: $("#modal-update .modal-body #comment").val(),
					image: $("#modal-update .modal-body #image").val()
					// IMAGE, IMAGEDATE, OPTION
				}), */
				data: new FormData($("#update-form")[0]),
				success: function(response) {
					window.location.reload()
				}
			})
		});
		
		$('#modal-update').on('hidden.bs.modal', function () {
			$("#update-form")[0].reset()
		})
	});
	
	function openImage (data) {
        var image = new Image();
        image.src = data;

        var w = window.open("", "", 'resize=no');
        w.document.write(image.outerHTML);
    }

	
	
</script>




			<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="">
				<!-- title -->
				<!-- <div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Methylation - Primer Design History</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>Analysis<i class="fa fa-chevron-right ml-2 mr-2"></i>Data selection </div>
					</div>
				</div> -->
				<!-- //title -->
				
				<!-- 컨텐츠 영역 -->
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!-- contents start -->
							<div class="card">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i>Methylation Result
									</h3>
								</div>

								<div class="card-body">
									<!-- 									
									<div class="mb-2">
										<div class="row form-inline">
											<label class="hidden">등록일순</label>
											<select class="form-control">
											<option>등록일순</option>
											<option>등록일순</option>
											</select>

											<label class="mt-1 mb-1 ml-2">총 게시판 <span class="text-danger">7</span>&nbsp; / &nbsp;페이지( <span class="text-danger">1</span>/ 20 )</label>
										</div>
									</div>
									 -->
									<div class="row">
										<div class="col-lg-12 table-responsive">
											<table class="table table-hover text-center table-font-small">
										       <tbody>
										        <tr>
										         <th>Ts_Id</th>
										         <th>Fp_Seq</th>
										         <th>Rp_Seq</th>
										         <th>Amp_Id</th>
										         <th>Amp_Bed</th>
										         <th>Hyb_Probe</th>
										         <th>UCSC Genome_Browser</th>
										         <th>UCSC Insilico_Primer</th>
										         <th>PCR 실험 이상유무</th>
										         <th>사진</th>
										         <th>사진 등록일시</th>
										         <th>코멘트</th>
										         <th></th>
										        </tr>
										        
										        
												<c:if test="${result != null}">
												<c:forEach var="result" items="${result.htPrimerResults}" varStatus="status">
													<tr>
												         <td>${result.tsId}</td>
												         <td>${result.fpSeq}</td>
												         <td>${result.rpSeq}</td>
												         <td>${result.ampId}</td>
												         <td>${result.ampBed}</td>
												         <td>${result.hybProbe}</td>
												         <td>
												         	<a class="text-primary" href="${result.ucscGenomeBrowserViewLink}" target="feature">View</a>
												         	&nbsp;|&nbsp;
												         	<a class="text-primary"href="${result.ucscGenomeBrowserDownloadLink}">Download</a> 
											         	</td>
												         <td>
												         	<a class="text-primary"href="${result.ucscInsilicoPrimerViewLink}" target="feature">View</a>
											         	</td>
												        <td>
												        	<div class="form-group">
																<div class="form-check">
																	<input class="form-check-input" type="radio" id="row-${result.recordIdx}-option1" name="row-${result.recordIdx}-option1" value="1" onclick="return false;" <c:if test="${result.option1!=null and result.option1==true}">checked="checked"</c:if>>
																	<label class="form-check-label" for="row-${result.recordIdx}-option1">True</label>
																</div>
																<div class="form-check">
																	<input class="form-check-input" type="radio" id="row-${result.recordIdx}-option2" name="row-${result.recordIdx}-option1" value="0" onclick="return false;" <c:if test="${result.option1!=null and result.option1==false}">checked="checked"</c:if>>
																	<label class="form-check-label" for="row-${result.recordIdx}-option2">False</label>
																</div>
															
															</div>
												        </td>
												        <td>
												        	<c:if test="${result.base64Image!=null and result.base64Image!=''}">
												        	<a data-toggle="tooltip" title="<img class='tooltip-image' src='${result.base64Image}' />" onclick="openImage('${result.base64Image}')" >
												        		<i class="far fa-image"></i>
												        	</a>
												        	</c:if>
												        	
												        	<c:if test="${result.base64Image==null or result.base64Image==''}">
												        	<a data-toggle="tooltip" title="<i>No Image</i>">
													        	<i class="far fa-image"></i>
												        	</a>
												        	</c:if>
											        	</td>
												        <td>${result.imageUploadDate}</td>
												        <td>${result.comment}</td>
												        <td>
												        	<button type="button" class="btn btn-sm btn-success btn-openupdate" data-toggle="modal" data-target="#modal-update" 
												        		data-idx="${result.recordIdx}" data-tsid="${result.tsId}" data-fpseq="${result.fpSeq}" data-rpseq="${result.rpSeq}" data-ampid="${result.ampId}"
												        		data-ampbed="${result.ampBed}" data-hybprobe="${result.hybProbe}" data-option1="${result.option1}" data-option2="${result.option2}" data-comment="${result.comment}"
												        		data-option1="${result.option1}" data-option2="${result.option2}" >
												        		수정
												        	</button>
														</td>
													</tr>
													<c:set var="ii" value="${ii - 1}" />
												</c:forEach>
												</c:if>
												<c:if test="${result == null or fn:length(result.htPrimerResults) == 0}">
													<tr>
														<td colspan="5"><spring:message code="list.noResult" text="No search results found." /></td>
													</tr>
												</c:if>
										       </tbody>
										    </table>
									    </div>
									</div>

									<div class="row">
										<div class="col-lg-10 offset-lg-1">
											<iframe align="left" class="style16" name="feature" frameborder="0" scrolling="auto" scroll="no" width="100%" height="900" style="overflow-x: false" id="feature" src=""></iframe>
										</div>
									</div>
								</div>
							</div>
						</div>
					</section>
				</div>
		</form:form>


		<div class="modal fade" id="modal-update" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-lg">
				<form id="update-form">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title">데이터 수정</h4>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">×</span>
							</button>
						</div>
						<div class="modal-body">
							<input type="hidden" class="form-control" id="recordIdx" name="recordIdx" readonly="readonly">
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Ts_Id</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="tsId" name="tsId" readonly="readonly">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Fp_Seq</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="fpSeq" name="fpSeq" readonly="readonly">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Rp_Seq</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="rpSeq" name="rpSeq" readonly="readonly">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Amp_Id</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="ampId" name="ampId" readonly="readonly">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Amp_Bed</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="ampBed" name="ampBed" readonly="readonly">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Hyb_Probe</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="hybProbe" name="hybProbe" readonly="readonly">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">PCR 실험 이상유무</label>
								<div class="col-sm-10">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" id="option1-true" name="option1" value="1">
										<label class="form-check-label" for="option1-true">True</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" id="option1-false" name="option1" value="0">
										<label class="form-check-label" for="option1-false">False</label>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">사진</label>
								<div class="col-sm-10">
									<!-- <input type="hidden" id="imagePath" name="imagePath" readonly="readonly"> -->
									<input type="file" class="form-control" id="image" name="image">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">코멘트</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="comment" name="comment">
								</div>
							</div>
						</div>
						
						<div class="modal-footer justify-content-between">
							<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-primary" id="update-save">저장</button>
						</div>
					</div>
				</form>
		
			</div>
		
		</div>

