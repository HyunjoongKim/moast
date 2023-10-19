<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<style>
	.LeftPositionI {position:absolute;top:14px;left:20px;} 
</style>

			<!-- Left -->
			<div class="left side-menu">
                <div class="sidebar-inner slimscrollleft">
					<div class="user-details">
                        <!-- 사용자 정보 -->
						<div class="text-center">
                            <img src="${pageContext.request.contextPath}/bootstrap-dist/images/register_noimg.png" alt="" class="img-circle" alt="사용자 사진">
						</div>
						<div class="user-info">
							<div class="dropdown">
								<a href="javascript:void(0);" class="dropdown-toggle" >${loginVO.name}</a>
								<%-- 
								<c:if test="${locale eq 'ko' || locale eq 'ko_KR'}">
									<a href="${path}/?lang=en">ENG</a>
								</c:if>
								<c:if test="${locale eq 'en' }">
									<a href="${path}/?lang=ko">KOR</a>
								</c:if> 
								--%>
								
							</div>
							<ul class="navbar-user">
								<c:if test="${loginVO.authCode ne '99'}"> 
								<li>
									<a href="${pageContext.request.contextPath}/account/logout.do" data-toggle="tooltip" class="waves-effect waves-light notification-icon-box" title="Logout"><i class="fa fa-unlock"></i></a>
								</li>
								</c:if>
							</ul>
						</div>
						<!-- //사용자 정보 -->
					</div>

					<!-- snb -->
					<div id="sidebar-menu">
						<c:if test="${loginVO.authCode eq '1'}"> 
							<ul>
								<%-- <li>
									<a href="${pageContext.request.contextPath}" class="waves-effect">
										<i class="fa fa-home"></i><span>Home</span>
									</a>
								</li> --%>
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-pencil-square-o"></i><span><spring:message code="sysmenu.code" text="코드관리" /></span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav common_code_default"><a href="${pageContext.request.contextPath}/adms/common/code/list.do?code_cate=default"><span class="sub-menu-text"><spring:message code="sysmenu.code.common" text="공통코드" /></span></a></li>
										
									</ul>
								</li>
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-share-alt-square"></i><span><spring:message code="sysmenu.site" text="사이트/권한/메뉴" /></span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav main_site"><a href="${pageContext.request.contextPath}/adms/common/site/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.site.manage" text="사이트관리" /></span></a></li>
										<li class="smenunav member_auth"><a href="${pageContext.request.contextPath}/adms/member/authManage/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.auth.manage" text="회원권한관리" /></span></a></li>
										<li class="smenunav menu_manage"><a href="${pageContext.request.contextPath}/adms/common/menu/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.menu.manage" text="메뉴권한관리" /></span></a></li>
									</ul>
								</li>
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-address-book-o"></i><span><spring:message code="sysmenu.member.manage" text="회원관리" /></span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav member_list"><a href="${pageContext.request.contextPath}/adms/member/memberManage/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.member.manage" text="회원관리" /></span></a></li>
									</ul>
								</li>
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-list-alt"></i><span>User data Management</span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav userdata_list"><a href="${pageContext.request.contextPath}/adms/userdata/manage/list.do"><span class="sub-menu-text">User data Management</span></a></li>
									</ul>
								</li>
								
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-list-alt" style="font-size:16px"></i><span><spring:message code="sysmenu.board.manage" text="게시판관리" /></span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav board_list"><a href="${pageContext.request.contextPath}/adms/board/boardManage/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.board.manage" text="게시판관리" /></span></a></li>
									</ul>
								</li>
								
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-clipboard" style="font-size:16px"></i><span><spring:message code="sysmenu.contents" text="컨텐츠관리" /></span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav popup_manager"><a href="${pageContext.request.contextPath}/adms/contents/popup/list.do"><span class="sub-menu-text">팝업관리</span></a></li>
										<li class="smenunav banner_manager"><a href="${pageContext.request.contextPath}/adms/contents/banner/list.do"><span class="sub-menu-text">배너관리</span></a></li>
										<li class="smenunav contents_manager"><a href="${pageContext.request.contextPath}/zboard/list.do?lmCode=content1&isAdms=Y"><span class="sub-menu-text"><spring:message code="sysmenu.contents" text="컨텐츠관리" /></span></a></li>
										<li class="smenunav calendar_manager"><a href="${pageContext.request.contextPath}/zcal/act/list.do"><span class="sub-menu-text">일정관리</span></a></li>
									</ul>
								</li>
								
								<li class="has-sub-sub">
									<a href="javascript:;" class="waves-effect">
										<i class="fa fa-bars"></i><span><spring:message code="sysmenu.log" text="로그관리" /></span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav menulog_home"><a href="${pageContext.request.contextPath}/adms/common/log/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.manage.dashboard" text="통합관리메인" /></span></a></li>
										<li class="smenunav menulog_list"><a href="${pageContext.request.contextPath}/adms/common/menulog/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.log.menu" text="메뉴로그기록" /></span></a></li>
										<li class="smenunav sitelog_month"><a href="${pageContext.request.contextPath}/adms/common/sitelog/month/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.log.month" text="월별통계" /></span></a></li>
										<li class="smenunav sitelog_days"><a href="${pageContext.request.contextPath}/adms/common/sitelog/days/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.log.days" text="일별통계" /></span></a></li>
										<li class="smenunav sitelog_time"><a href="${pageContext.request.contextPath}/adms/common/sitelog/time/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.log.time" text="시간별통계" /></span></a></li>
										<li class="smenunav adminlog_list"><a href="${pageContext.request.contextPath}/adms/common/adminlog/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.log.admin" text="관리자로그기록" /></span></a></li>					
									</ul>
								</li>
								<!-- 설문조사 추가 [2020-08-08] -->
								<li class="has-sub-sub">
									<a href="javascript:;" class="waves-effect">
										<i class="fa fa-pencil-square-o"></i><span>설문관리</span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav survey_list"><a href="${pageContext.request.contextPath}/adms/survey/main/list.do"><span class="sub-menu-text">설문관리</span></a></li>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${loginVO.authCode eq '2'}">
							<ul>
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-address-book-o"></i><span><spring:message code="sysmenu.member.manage" text="회원관리" /></span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav member_list"><a href="${pageContext.request.contextPath}/adms/member/memberManage/list.do"><span class="sub-menu-text"><spring:message code="sysmenu.member.manage" text="회원관리" /></span></a></li>
									</ul>
								</li>
							</ul>
							<ul>
								<li class="has-sub-sub">
									<a href="javascript:void(0);" class="waves-effect">
										<i class="fa fa-list-alt"></i><span>User data Management</span>
										<span class="pull-right"><i class="fa fa-angle-right" style="vertical-align:middle; line-height:1"></i></span>
									</a>
									<ul class="list-unstyled sub-sub">
										<li class="smenunav userdata_list"><a href="${pageContext.request.contextPath}/adms/userdata/manage/list.do"><span class="sub-menu-text">User data Management</span></a></li>
									</ul>
								</li>
							</ul>
						</c:if>
					</div>
					<!-- //snb -->
					<div class="clearfix"></div>
				</div>
            </div>
			<!-- //Left -->
