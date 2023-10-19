<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript" src="${pageContext.request.contextPath}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";

	$(function(){
		alertResMsg("${resMap.msg}");
		
	});

</script>

				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Information</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>My Page<i class="fa fa-chevron-right ml-2 mr-2"></i>User information</div>
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
										<i class="ion ion-clipboard mr-1"></i>User information
									</h3>
								</div>

								<div class="card-body">
									<div class="table-responsive">
										<table class="table table-bordered table-block">
			                            	<colgroup>
												<col width="250px">
												<col width="">
											</colgroup> 
			                                <tbody>
									        	<tr>
									                <th>Name</th>
									                <td>
									                    ${memberVO.me_name }
									                </td>
									            </tr>
									            <tr>
									                <th>ID</th>
									                <td>
									                    ${memberVO.me_id }
									                </td>
									            </tr>
									            <tr>
									                <th>E-mail</th>
									                <td>
									                    ${memberVO.me_email }
									                </td>
									            </tr>
									            <tr>
									                <th>Contact</th>
									                <td>
									                    ${memberVO.me_tel }
									                </td>
									            </tr>
												<tr>
									                <th>Institution</th>
									                <td>
									                    ${memberVO.me_agency }
									                </td>
									            </tr>
									            <tr>
									                <th>Department or division</th>
									                <td>
									                    ${memberVO.me_department }
									                </td>
									            </tr>
									        </tbody>
									    </table>
									</div>
									<div class="clearfix"></div>
					
									<div class="row btn-area">
										<div class="col-lg-12 text-right">
											<div>
												<a href="${path}/myPage/info/update_pw.do" class="btn btn-dark"><span>Edit password</span></a>
												<a href="${path}/myPage/info/update.do" class="btn btn-primary"><span>Edit user info.</span></a>
											</div>
										</div>
									</div>
									
								</div>
							</div>
						</div>
					</section>
				</div>
