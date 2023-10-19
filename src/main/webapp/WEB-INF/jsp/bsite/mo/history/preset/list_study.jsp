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
		$('#nextButton').click(function(){
			$('#submitForm').submit();
		});
			
	}
	
</script>




			<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="${path }/mo/visual/list_saved.do">
				<input type="hidden" name="ps_idx" id="ps_idx" value="${searchVO.ps_idx }" />
				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Preset (local saved)</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>History (Analysis)<i class="fa fa-chevron-right ml-2 mr-2"></i>저장된 Preset </div>
					</div>
				</div>
				<!-- //title -->

				<!-- 컨텐츠 영역 -->
				<div class="row">
				
				<!-- 컨텐츠 영역 -->
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!-- contents start -->
							<div class="card">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i>Study list
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
									 
									 <h2>${presetVO.ps_title }</h2>

									<div class="table-responsive">
										<table class="table text-center" style="table-layout:fixed;">
			                            	<colgroup>
												<col width="10%">
												<col width="25%">
												<col width="65%">
											</colgroup> 
			                                <thead>
			                                    <tr>
			                                    	<th scope="col" rowspan="3">
			                                    		<c:if test="${searchVO.popYn ne 'Y'}">select</c:if>
			                                    	</th>
			                                        <th scope="col" class="table-info">Study Title</th>
			                                        <th scope="col">Expression</th>
			                                    </tr>
			                                    <tr>
			                                        <th scope="col">Study Comment</th>
			                                        <th scope="col">Methylation</th>
			                                    </tr>
			                                    <tr>
			                                    	<th scope="col">Gene Set</th>
			                                        <th scope="col">Variation</th>
			                                    </tr>
			                                </thead>
			                                <tbody>
			                                	<c:set var="ii" value="${resultCnt - (searchVO.pageIndex -1) * paginationInfo.recordCountPerPage }" />
												<c:forEach var="result" items="${resultList}" varStatus="status">
													<c:set var="row_bg" value="" />
													<c:if test="${status.index % 2 == 0}">
														<c:set var="row_bg" value="table-info" />
													</c:if>
													<tr class="">
														<td rowspan="3" class="">
															<c:if test="${searchVO.popYn ne 'Y'}">
																<input type="checkbox" checked="checked" name="std_indices" value="${result.std_idx}" class="form-control"/>
															</c:if>
														</td>							
														<td style="text-align:left" class="table-info">[ <c:out value="${result.std_title}"/> ]</td>
														<td style="text-align:left" class=""> 
															<div class="row">
																<div class="col-2"><input type="radio" <c:if test='${result.expYN eq "Y" }'>checked="checked"</c:if> /> exp </div>
																<c:if test='${result.std_type eq "A" }'>
																	<c:if test="${searchVO.popYn ne 'Y'}">
																		<div class="col-2"></div>
																	</c:if>
																	<div class="col-2"><c:out value="${result.degType}"/></div>
																	<div class="col-3">| log2FC(Fold Change) | >= ${result.degLogFC}</div>
																	<div class="col-3">
																		<c:if test='${result.degPValueType eq "P" }'>
																			P_value &lt ${result.degPValue}
																		</c:if>
																		<c:if test='${result.degPValueType eq "A" }'>
																			adj.P value (FDR) &lt ${result.degAdjPValue}
																		</c:if>
																	</div>
																</c:if>
																<c:if test='${result.std_type eq "G" }'><div class="col-4 offset-2"></div></c:if>
															</div>
														</td>
													</tr>
													<tr class="">
														<td style="text-align:left"><c:out value="${result.std_note}"/></td>
														<td style="text-align:left"> 
															<div class="row">
																<div class="col-2"><input type="radio" <c:if test='${result.methYN eq "Y" }'>checked="checked"</c:if> /> met </div>
																<c:if test="${searchVO.popYn ne 'Y'}">
																	<div class="col-2"><a class="btn btn-sm btn-primary" href="${path}/mo/analysisdata/methylation/list.do?std_idx=${result.std_idx}">Primer </a></div>
																</c:if>
																<c:if test='${result.std_type eq "A" }'>
																	<div class="col-2"><c:out value="${result.dmpType}"/></div>
																	<div class="col-3">delta beta >= ${result.dmpLogFC}</div>
																	<div class="col-3">
																		<c:if test='${result.dmpPValueType eq "P" }'>
																			P_value &lt ${result.dmpPValue}
																		</c:if>
																		<c:if test='${result.dmpPValueType eq "A" }'>
																			adj.P value (FDR) &lt ${result.dmpAdjPValue}
																		</c:if>
																	</div>
																</c:if>
																<c:if test='${result.std_type eq "G" }'><div class="col-4"></div></c:if>
															</div>
														</td>
													</tr>
													<tr class="">
														<td style="text-align:left">${result.geneSetType}</td>
														<td style="text-align:left">
															<div class="row">
																<div class="col-2"><input type="radio" <c:if test='${result.mutYN eq "Y" }'>checked="checked"</c:if> /> var</div>
																<c:if test="${searchVO.popYn ne 'Y'}">
																	<div class="col-2"><a class="btn btn-sm btn-primary" href="${path}/mo/analysisdata/variant/list.do?std_idx=${result.std_idx}">Primer </a></div>
																</c:if>
																<div class="col-1"></div>
																<c:if test='${result.std_type eq "A" }'><div class="col-3"> - </div></c:if>
																<c:if test='${result.std_type eq "G" }'><div class="col-3"></div></c:if>
															</div>
														</td>
													</tr>
													<c:set var="ii" value="${ii - 1}" />
												</c:forEach>
												<c:if test="${fn:length(resultList) == 0}">
													<tr>
														<td colspan="3"><spring:message code="list.noResult" text="No search results found." /></td>
													</tr>
												</c:if>
			                                </tbody>
			                            </table>
									</div>
									
									<div class="row btn-area">
										<div class="col-12 text-right">
											<button type="button" class="btn btn-dark mr-2" onclick="history.back()" >Back</button>
											<c:if test="${searchVO.popYn ne 'Y'}">
												<button type="button" class="btn btn-success" id="nextButton">Next <i class="fas fa-chevron-right"></i></button>
											</c:if>
										</div>
									</div>
								</div>
							</div>
						</div>
					</section>
				</div>
			</div>
		</form:form>
                        