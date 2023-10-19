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
.sprt_t {border-top: 2px solid }
.sprt_b {border-bottom: 2px solid } 
.table thead th {background-color: #f6f6f6;}
</style>

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";

	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
	});

	function share(ps_idx) {
		var target_idx = $('#target_' + ps_idx).val(); 
		
		$.ajax({
            url: "${path}/mo/history/preset/update_share.do?ps_idx=" + ps_idx + "&share_me_idx=" +  target_idx,
            type: "GET",
            //data: $('#submitForm').serialize(),
            error: function() {alert('An error occurred during data reception.');},
            success: function(data) {
            	//console.log(data);
    			if(data.res == "ok") {
    				alert('공유를 변경했습니다.');
            	}
            },
            complete: function(data) {
			}
        });
		
	}
	
</script>




			<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="${path }/mo/history/preset/list.do">
				<!-- title -->
				<c:if test="${searchVO.popYn ne 'Y'}">
					<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
						<div class="row">
							<div class="col-lg-6">
								<h3 class="card-title h3icn">Preset (local saved)</h3>
							</div>
							<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>History (Analysis)<i class="fa fa-chevron-right ml-2 mr-2"></i>저장된 Preset </div>
						</div>
					</div>
				</c:if>
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
										<i class="ion ion-clipboard mr-1"></i>Preset list
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
										<table class="table table-bord ered text-center" style="table-layout:fixed;">
			                            	<colgroup>
												<col width="5%">
												<col width="auto">
												<col width="10%">
												<c:if test="${searchVO.popYn ne 'Y'}">
													<col width="10%">
												</c:if>
												<col width="10%">
											</colgroup> 
			                                <thead class="">
			                                    <tr class="sprt_t">
			                                    	<th scope="col" rowspan="3">No.</th>
			                                        <th scope="col">Title</th>
			                                        <th scope="col">Registered</th>
			                                        <c:if test="${searchVO.popYn ne 'Y'}">
			                                        	<th scope="col">New Preset</th>
			                                        </c:if>
			                                        <th scope="col">Select Preset</th>
			                                    </tr>
			                                    <tr>
			                                        <th scope="col">Desc.</th>
			                                        <th scope="col">Group</th>
			                                        <c:if test="${searchVO.popYn ne 'Y'}">
				                                        <th scope="col">Share with</th>
				                                        <th scope="col">Change share</th>
			                                        </c:if>
			                                        <c:if test="${searchVO.popYn eq 'Y'}">
				                                        <th scope="col"></th>
			                                        </c:if>
			                                    </tr>
			                                    <tr>
			                                        <th scope="col">study</th>
			                                        <th scope="col" colspan="${(searchVO.popYn ne 'Y') ? 3 : 2}"></th>
			                                    </tr>
			                                </thead>
			                                <tbody>
			                                	<c:set var="ii" value="${resultCnt - (searchVO.pageIndex -1) * paginationInfo.recordCountPerPage }" />
												<c:forEach var="result" items="${resultList}" varStatus="status">
													<tr class="sprt_t">
														
														<td rowspan="3"><c:out value="${ii}"/></td>							
														<td style="text-align:left" >[ <c:out value="${result.ps_title}"/> ]</td>
														<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${result.cret_date }"/></td>
														<c:if test="${searchVO.popYn ne 'Y'}">
															<td> 
																<a href="${path}/mo/clinic/list.do?ps_idx=${result.ps_idx}&ud_idx=${result.ud_idx}" target="_self" class="btn btn-success btn-sm">New Preset</a>
															</td>
														</c:if>
														<td><a href="${path}/mo/history/preset/list_study.do?ps_idx=${result.ps_idx}&popYn=${searchVO.popYn}" target="_self" class="btn btn-primary btn-sm">Select Preset</a></td>
													</tr>
													<tr>
														<td style="text-align:left">
															<div class="row">
																<div class="col-3">
																	<c:out value="${result.ud_title}"/>
																</div>
																<div class="col-9">
																	<c:out value="${result.ps_note}"/>
																</div>
															</div>
															
														</td>
														<td><c:out value="${result.cg_title}"/></td>
														<c:if test="${searchVO.popYn ne 'Y'}">
															<td>
																<select id="target_${result.ps_idx}" class="form-control">
																	<option value="0" selected>Not share</option>
																	<c:forEach var="member" items="${memberList}" varStatus="status">
																		<c:if test="${member.me_idx ne loginVO.idx }">
																			<option value="${member.me_idx }" ${member.me_idx eq result.share_me_idx ? 'selected' : ''}>${member.me_name }:${member.me_id} </option>
																		</c:if>
																	</c:forEach>
																	
																</select>
															</td>
														</c:if>
														<td>
															<c:if test="${searchVO.popYn ne 'Y'}">
																<button type="button" class="btn btn-secondary btn-sm" onclick="share('${result.ps_idx}')">Change share</button>
															</c:if>
														</td>
													</tr>
													<tr class="sprt_b">
														<td colspan="${(searchVO.popYn ne 'Y') ? 4 : 3}">
															<div class="row">
																<c:forEach var="study" items="${result.studyList}" varStatus="status">
																	<div class="col-3">
																		<li class="list-group-item"><c:out value="${study.std_title}"/></li>
																	</div>
																</c:forEach>
															</div>
														</td>
													</tr>
													<c:set var="ii" value="${ii - 1}" />
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
							</div>
						</div>
					</section>
				</div>
			</div>
		</form:form>
                        