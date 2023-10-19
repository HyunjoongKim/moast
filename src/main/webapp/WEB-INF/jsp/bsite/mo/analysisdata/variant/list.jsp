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
	.cell-comment .comment-edit{
		visibility: hidden;
	}
	
	.cell-comment:hover .comment-edit{
		visibility: visible;
	}
</style>

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";

	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		$(document).on("click", ".comment-edit", function(){
			var selector = $(this);
			var recordIdx = $(this).data("recordidx")
			var comment = $(this).data("comment");
			
			console.log(recordIdx, comment)
			
			var newComment = prompt("코멘트 수정", comment);
			if (newComment != null && newComment != undefined) {
				$.ajax({
					url: "${path}/mo/analysisdata/variant/update.do",
					method: "post",
					contentType: "application/json",
					data: JSON.stringify({
						recordIdx: recordIdx,
						comment: newComment
					}),
					success: function(response) {
						$(selector).parent().find(".comment-text").text(newComment)
						$(selector).data("comment", newComment)
					}
				})
			}
		})
	});
	
	function ViewData(var_idx) {
		$('#modal-view-data').modal('show');
		$.ajax({
			url: "${path}/mo/analysisdata/variant/read.do?var_idx=" + var_idx,
			method: "get",
			success: function(response) {
				if (response.res=='ok' && response.data!=null) {
					$("#variant-id").text(response.data.variantID)
					$("#annotation").text(response.data.annotation)
					$("#fasta1").text(response.data.fasta1)
					$("#fasta2").text(response.data.fasta2)
					$("#fasta3").text(response.data.fasta3)
					$('#modal-view-data').modal('show');
				}
			}
		})
	}

	function fn_go_page(pageNo) {
		$("#pageIndex").val(pageNo);
		$("#listForm").submit();
		return false;
	}
	

	
	
</script>




			<form:form commandName="searchVO" method="get" name="listForm" id="listForm" action="">
				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Variant - Primer Design History</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i>
							<i class="fa fa-chevron-right ml-2 mr-2"></i>History (Analysis)
							<i class="fa fa-chevron-right ml-2 mr-2"></i>Preset (local)
							<i class="fa fa-chevron-right ml-2 mr-2"></i>History (Variant)
						</div>
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
										<i class="ion ion-clipboard mr-1"></i>Primer Design History
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

									<div class="table-responsive">
										<table class="table table-sm table-bordered table-striped text-center" style="table-layout:fixed;">
			                            	<colgroup>
												<col width="10%">
												<col width="30%">
												<col width="30%">
												<col width="30%"> 
											</colgroup> 
			                                <thead>
			                                    <tr>
			                                    	<th scope="col">No.</th>
			                                        <th scope="col">VariantID</th>
			                                        <th scope="col">Contents</th>
			                                        <th scope="col">Comments</th>
			                                    </tr>
			                                </thead>
			                                <tbody>
			                                	<c:set var="ii" value="${1 + (searchVO.pageIndex -1) * paginationInfo.recordCountPerPage }" />
												<c:forEach var="result" items="${resultList}" varStatus="status">
													<tr>
														<td><c:out value="${ii}"/></td>							
														<td style="text-align:left"><c:out value="${result.variantID}"/></td>
														<td style="text-align:left">
															<button type="button" class="btn btn-sm btn-success" onclick="ViewData(${result.recordIdx})">View sequence</button>
															<a class="btn btn-sm btn-success" href="${path}/mo/analysisdata/variant/read_detail.do?var_idx=${result.recordIdx}">View detail</a>
														</td>
														<%-- <td style="text-align:left"><a class="btn btn-sm btn-success" href="#" onclick="openPopup(${result.recordIdx})" target="variant_View">View Marker</a></td> --%>
														<%-- <td>${result.cret_date}</td> --%>
														<td class="cell-comment">
															<span class="comment-text"><c:out value="${result.comment}"/></span>
															<a href="#" class="comment-edit" data-recordidx="${result.recordIdx}" data-comment="${result.comment}"><i class="fas fa-pencil-alt"></i></a>
														</td>
													</tr>
													<c:set var="ii" value="${ii + 1}" />
												</c:forEach>
												<c:if test="${fn:length(resultList) == 0}">
													<tr>
														<td colspan="5"><spring:message code="list.noResult" text="No search results found." /></td>
													</tr>
												</c:if>
			                                </tbody>
			                            </table>
									</div>
								</div>
								<div class="card-footer">
									<div class="float-left mt10">
										<span><spring:message code="list.totalCnt" text="total  " /> <fmt:formatNumber value="${paginationInfo.totalRecordCount}" type="number" /> / <spring:message code="list.page" text="페이지 " />(<c:out value="${searchVO.pageIndex}"/>/<c:out value="${paginationInfo.totalPageCount}"/>)</span>
									</div>
									<div class="float-right">
										<input type="hidden" name="pageIndex" id="pageIndex"/>
										<ul class="pagination m-0 float-right">
											<li class="page-item <c:if test="${paginationInfo.firstPageNoOnPageList == 1}"> disabled </c:if>"><a class="page-link" href="#" onclick="fn_go_page(${paginationInfo.firstPageNoOnPageList - 1})">«</a></li>
											<c:forEach begin="${paginationInfo.firstPageNoOnPageList}" end="${paginationInfo.lastPageNoOnPageList}" varStatus="loop">
											    <li class="page-item <c:if test="${paginationInfo.currentPageNo == loop.index}"> active </c:if>"><a class="page-link" href="#" onclick="fn_go_page(${loop.index})">${loop.index}</a></li>
											</c:forEach>
											<li class="page-item <c:if test="${paginationInfo.lastPageNoOnPageList == paginationInfo.totalPageCount}"> disabled </c:if>"><a class="page-link" href="#" onclick="fn_go_page(${paginationInfo.lastPageNoOnPageList + 1})">»</a></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</section>
				</div>
		</form:form>
		
		<div class="modal fade" id="modal-view-data" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title" id="variant-id"></h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">×</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group row">
									<label>Input Annotation</label>
									<textarea class="form-control" id="annotation" readonly="readonly" rows="5"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group row">
									<label>Fasta 1</label>
									<textarea class="form-control" id="fasta1" readonly="readonly" rows="9"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group row">
									<label>Fasta 2</label>
									<textarea class="form-control" id="fasta2" readonly="readonly" rows="9"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group row">
									<label>Fasta 3</label>
									<textarea class="form-control" id="fasta3" readonly="readonly" rows="3"></textarea>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
                        