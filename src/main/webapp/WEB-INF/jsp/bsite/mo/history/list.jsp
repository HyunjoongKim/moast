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
	});

	
	
</script>




			<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="${path }/mo/history/list.do">
				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Preset</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>마이페이지<i class="fa fa-chevron-right ml-2 mr-2"></i>Preset </div>
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
										<table class="table table-bordered table-striped text-center" style="table-layout:fixed;">
			                            	<colgroup>
												<col width="10%">
												<col width="30%">
												<col width="30%">
												<col width="20%">
												<col width="10%"> 
											</colgroup> 
			                                <thead>
			                                    <tr>
			                                    	<th scope="col">순번</th>
			                                        <th scope="col">제목</th>
			                                        <th scope="col">설명</th>
			                                        <th scope="col">등록일</th>
			                                        <th scope="col">상태</th>
			                                    </tr>
			                                </thead>
			                                <tbody>
			                                	<c:set var="ii" value="${resultCnt - (searchVO.pageIndex -1) * paginationInfo.recordCountPerPage }" />
												<c:forEach var="result" items="${resultList}" varStatus="status">
													<tr>
														<td><c:out value="${ii}"/></td>							
														<td style="text-align:left"><c:out value="${result.ht_title}"/></td>
														<td style="text-align:left"><c:out value="${result.ht_note}"/></td>
														<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${result.cret_date }"/></td>
														<td>
															<a href="${path}/mo/history/read.do?wp_idx=${result.wp_idx}" target="_self" class="btn btn-success btn-sm">선택</a>
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
                        