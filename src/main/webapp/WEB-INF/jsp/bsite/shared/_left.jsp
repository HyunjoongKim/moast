<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set var="nowPageUrl" value="${requestScope['javax.servlet.forward.servlet_path']}" />

<%@include file="_navi.jsp"%>
<script type="text/javascript">
	$(function(){
		
		
	});
</script>

	<aside class="main-sidebar sidebar-dark-primary elevation-4">
		<!-- Logo -->
		<a href="${path }/" class="brand-link">
			<img src="${path }/dist/img/logo-new.png" alt=" Logo" class="" style="opacity: .8">
		</a>

		<!-- Sidebar -->
		<div class="sidebar">
			<!-- frofile -->
			<div class="user-panel mt-0 pb-3 pb-0 d-flex">
				<div class="image">
					<img src="${path }/dist/img/profile.png" class="img-circle elevation-2" alt="User Image">
				</div>
				<div class="info">
					<c:if test="${loginVO.authCode eq '1' || loginVO.authCode eq '2'}">
						<a href="${path }/adms/member/memberManage/list.do" class="d-block">Admin</a>
					</c:if>
					<c:if test="${loginVO.authCode ne '1' && loginVO.authCode ne '2'}">
						<a href="#" class="d-block">${loginVO.id}</a>
					</c:if>
					<!--div class="btn-group">
						<button type="button" class="btn btn-default btn-sm btn-block mt-1">정보수정</button>
						<button type="button" class="btn btn-default btn-sm btn-block mt-1">로그아웃</button>
					</div-->
				</div>
			</div>
			<!-- // frofile -->

			<!-- Sidebar Menu -->
			<nav class="mt-0">
				<ul class="nav  nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
					<li class="nav-it	em has-treeview menu-open">
						<ul class="nav nav-treeview">
							<li class="nav-item ${fn:contains(nowPageUrl, '/mo/analysisdata/') 
												|| fn:contains(nowPageUrl, '/mo/clinic/')
												|| fn:contains(nowPageUrl, '/mo/basic/')
												|| fn:contains(nowPageUrl, '/mo/visual/')
												|| fn:contains(nowPageUrl, '/mo/multi/') 
												? 'menu-open' : 'has-treeview'}">
								<a href="#" class="nav-link ${fn:contains(nowPageUrl, '/mo/analysisdata') 
												|| fn:contains(nowPageUrl, '/mo/clinic/')
												|| fn:contains(nowPageUrl, '/mo/basic/')
												|| fn:contains(nowPageUrl, '/mo/visual/')
												|| fn:contains(nowPageUrl, '/mo/multi/') 
												? 'active' : ''}">
									<i class="nav-icon fas fa-edit"></i>
									<p>Analysis</p>
									<i class="fas fa-angle-left right"></i>
								</a>
								<ul class="nav nav-treeview menu-2deth">
									<li class="nav-item">
										<a href="${path}/mo/analysisdata/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/clinic/') ? 'active' : ''}">Data selection</a>
									</li>
									<!-- 
									<li class="nav-item">
										<a href="#" class="nav-link">basic results</a>
									</li>
									<li class="nav-item">
										<a href="#" class="nav-link">geneSet Visualization</a>
									</li>
									<li class="nav-item">
										<a href="#" class="nav-link">Data selection toy sample</a>
									</li>
									 -->
								</ul>
							</li>
							<li class="nav-item ${fn:contains(nowPageUrl, '/mo/history') ? 'menu-open' : 'has-treeview'}">
								<a href="#" class="nav-link ${fn:contains(nowPageUrl, '/mo/history') ? 'active' : ''}">
									<i class="nav-icon fas fa-chart-area"></i>
									<p>History (analysis)</p>
									<i class="fas fa-angle-left right"></i>
								</a>
								<ul class="nav nav-treeview menu-2deth">
									<li class="nav-item">
										<a href="${path}/mo/history/preset/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/history/preset/') ? 'active' : ''}">Preset (local)</a>
									</li>
									<%--  
									<li class="nav-item">
										<a href="${path}/mo/history/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/history/') ? 'active' : ''}">deprecated 히스토리</a>
									</li>
									
									<li class="nav-item">
										<a href="${path}/mo/historyo/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/historyo/') ? 'active' : ''}">SingleOmics 결과</a>
									</li>
									--%>
									<li class="nav-item">
										<a href="${path }/mo/history/presetshared/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/history/presetshared/') ? 'active' : ''}">Preset (shared)</a>
									</li>
								</ul>
							</li>
							<li class="nav-item ${fn:contains(nowPageUrl, '/mo/third') ? 'menu-open' : 'has-treeview'}">
								<a href="#" class="nav-link ${fn:contains(nowPageUrl, '/mo/third/') ? 'active' : ''}">
									<i class="nav-icon fas fa-th-list"></i>
									<p>ThirdPart Tools</p>
									<i class="fas fa-angle-left right"></i>
								</a>
								<ul class="nav nav-treeview menu-2deth">
									<li class="nav-item">
										<a href="${path}/mo/third/sam/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/third/sam/') ? 'active' : ''}">Samtools format conversion</a>
									</li>
									<li class="nav-item">
										<a href="${path}/mo/third/scrna/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/third/scrna/') ? 'active' : ''}">scRNA</a>
									</li>
									<li class="nav-item">
										<a href="${path}/mo/third/scrnaview/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/third/scrna/') ? 'active' : ''}">scRNA viewer</a>
									</li>
									<li class="nav-item">
										<a href="${path}/mo/third/survival/list.do" class="nav-link ${fn:contains(nowPageUrl, '/mo/third/survival/') ? 'active' : ''}">Survival</a>
									</li>
								</ul>
							</li>
							
							<li class="nav-item ${fn:contains(nowPageUrl, '/myPage/info/') ? 'menu-open' : 'has-treeview'}">
								<a href="#" class="nav-link ${fn:contains(nowPageUrl, '/myPage/info/') ? 'active' : ''}">
									<i class="nav-icon fas fa-user"></i>
									<p>My page</p>
									<i class="fas fa-angle-left right"></i>
								</a>
								<ul class="nav nav-treeview menu-2deth">
									<li class="nav-item">
										<a href="${path }/myPage/info/read.do" class="nav-link">Edit</a>
									</li>
									
								</ul>
							</li>
							
							<!-- 
							<li class="nav-item has-treeview">
								<a href="#" class="nav-link">
									<i class="nav-icon fas fa-copy"></i>
									<p>데이터 버전관리</p>
									<i class="fas fa-angle-left right"></i>
								</a>
								<ul class="nav nav-treeview menu-2deth">
									<li class="nav-item">
										<a href="#" class="nav-link">데이터 버전관리</a>
									</li>
								</ul>
							</li>
							 -->
						</ul>
					</li>
				</ul>
			</nav>
			<!-- // Sidebar Menu -->
		</div>
		<!-- // sidebar -->

	</aside>
