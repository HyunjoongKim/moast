<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

	<script src="${pageContext.request.contextPath}/js/highChart/highcharts.js"></script>
	<script src="${pageContext.request.contextPath}/js/highChart/highcharts-more.js"></script>
	<script src="${pageContext.request.contextPath}/js/highChart/modules/exporting.js"></script>

    <link href="${pageContext.request.contextPath}/js/noty/css/main.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/js/noty/css/table.css" rel="stylesheet">

 
	<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/lineandbars.js"></script>  	 --%>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/dash-charts.js"></script>
	
	 
	<!-- NOTY JAVASCRIPT -->
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/noty/jquery.noty.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/noty/layouts/top.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/noty/layouts/topLeft.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/noty/layouts/topRight.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/noty/layouts/topCenter.js"></script>
	
	<!-- You can add more layouts if you want -->
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/noty/js/noty/themes/default.js"></script>     
    <script src="${pageContext.request.contextPath}/js/clock/clock.js"></script>		
    

	<script type="text/javascript">
	var path="${path}";
	 
	$(function(){
		printClock();
		
		
		$("p.menuTitleP a").hover(function() { 
		   $(this).css("color", "red");
		   $("span.menuTitle").html($(this).attr("title")); 
		}, function(){
		    $(this).css("color", ""); 
		    $("span.menuTitle").html(""); 
		}); 
		
		getTotalCounts(); 
		
		
		
		var idxArr = "";
		$("table#menu_table tr").each(function(){
			var menu_idx=$(this).find("input[name='menu_idx']").val();
			if(menu_idx > 0) idxArr+=menu_idx +",";
		});  
		getPrtMenuCate(idxArr); 
		
		
		
	});
	
	
	function getPrtMenuCate(idxArr){
		var result= null;
		var data = "idxs="+idxArr; 
		
		$.ajax({ 
			  url: path+"/cmm/log/getPrtMenuCate.do", 
			  type: "POST", 
			  async: false,
			  data : data
		 }).done(function(resMap) { 
			 if(resMap != ''){ 
				 result =JSON.parse(resMap); 
			 } 
		 }).fail(function(e) {}).always(function() {}); 
		
		for(var k in result){
			var obj = result[k];
			//prtCate
			var xid = "tr_"+obj.menu_idx;
			$("tr#"+xid).find("td.prtCate").html(obj.menu_name); 
		}
	}
		
	
	</script>
   

	  <!-- FIRST ROW OF BLOCKS -->     
      <div class="row">

      <!-- USER PROFILE BLOCK -->
        <%-- <div class="col-sm-3 col-lg-3">
      		<div class="dash-unit">
	      		<dtitle>User Profile</dtitle>
	      		<hr>
				<div class="thumbnail">
					<img src="${pageContext.request.contextPath}/img/main/icon_login.png" alt="Marcel Newman" class="img-circle">
				</div><!-- /thumbnail -->
				<h1>${loginVO.id}</h1>
				<h3>${loginVO.name}</h3>
				<br>
					<div class="info-user">
						<!-- <i class="fa fa-spinner fa-spin fa-fw"></i>  -->
						<a href="${pageContext.request.contextPath}/adms/common/code/list.do?code_cate=default" title="코드관리-공통코드"><i class="fa fa-pencil-square-o"></i></a>
						<a href="${pageContext.request.contextPath}/adms/common/menu/list.do" title="사이트/권한/메뉴-메뉴및권한부여"><i class="fa fa-share-alt-square"></i></a>		
						<a href="${pageContext.request.contextPath}/adms/member/memberManage/list.do" title="회원관리-회원관리"><i class="fa fa-address-book-o"></i></a>
						<a href="${pageContext.request.contextPath}/adms/board/boardManage/list.do" title="게시판관리-게시판관리"><i class="fa fa-list-alt"></i></a>
						<a href="${pageContext.request.contextPath}/zboard/list.do?lmCode=content1&isAdms=Y" title="컨텐츠관리-컨텐츠관리"><i class="fa fa-clipboard"></i></a>
						<a href="${pageContext.request.contextPath}/adms/common/menulog/list.do" title="로그관리-메뉴로그기록"><i  class="fa fa-align-justify"></i></a>
					</div>
				</div>
        </div> --%>
         
        
        <div class="col-sm-3 col-lg-3">
				<!-- LOCAL TIME BLOCK -->
	      		<div class="half-unit" >
		      		<dtitle>사용자 프로필</dtitle>
		      		<hr>
			      	<div class="thumbnail">
						<img src="${pageContext.request.contextPath}/img/main/icon_login.png" alt="Marcel Newman" class="img-circle">
						<p>${loginVO.id} <span style="color:#9FF781">(${loginVO.name})</span></p>
					</div><!-- /thumbnail -->
					
				</div>
	
	     	    <!-- count  -->
				<div class="half-unit">
		      		<dtitle>바로가기</dtitle>
		      		<hr>
		      		<div class="info-user">
						<!-- <i class="fa fa-spinner fa-spin fa-fw"></i>  -->
						<p class="menuTitleP">
							<a href="${pageContext.request.contextPath}/adms/common/code/list.do?code_cate=default" title="코드관리-공통코드"><i class="fa fa-pencil-square-o"></i></a>
							<a href="${pageContext.request.contextPath}/adms/common/menu/list.do" title="사이트/권한/메뉴-메뉴및권한부여"><i class="fa fa-share-alt-square"></i></a>		
							<a href="${pageContext.request.contextPath}/adms/member/memberManage/list.do" title="회원관리-회원관리"><i class="fa fa-address-book-o"></i></a>
							<a href="${pageContext.request.contextPath}/adms/board/boardManage/list.do" title="게시판관리-게시판관리"><i class="fa fa-list-alt"></i></a>
							<a href="${pageContext.request.contextPath}/zboard/list.do?lmCode=content1&isAdms=Y" title="컨텐츠관리-컨텐츠관리"><i class="fa fa-clipboard"></i></a>
							<a href="${pageContext.request.contextPath}/adms/common/menulog/list.do" title="로그관리-메뉴로그기록"><i  class="fa fa-align-justify"></i></a>
						</p>
						<p> <span class="menuTitle" style="font-size:13px;color:white;">&nbsp;</span></p>
					</div> 
				</div>
		</div> 

     	<div class="col-sm-3 col-lg-3">
      		<div class="dash-unit">
		  		<dtitle>일주일 방문자 추이</dtitle>
		  		<hr>
	        	<div id="xtoday" style="width:100%;height:250px;padding:5px;"></div> 
	        	<!-- <h2>45%</h2> -->
			</div>
        </div>

      
        <div class="col-sm-3 col-lg-3">
      		<div class="dash-unit">
		  		<dtitle>최근 6개월 방문자 추이</dtitle>
		  		<hr>
	        	<div id="xmonth" style="width:100%;height:250px;padding:5px;"></div>
	        	<!-- <h2>65%</h2> -->
			</div>
        </div>
        
        
        <div class="col-sm-3 col-lg-3">
				<!-- LOCAL TIME BLOCK -->
	      		<div class="half-unit" >
		      		<dtitle>Local Time</dtitle>
		      		<hr>
			      	<div style="width:100%;padding-top:15px; color:#F2EFFB;font-size:30px;font-weight:bold;text-align:center;" id="clock"></div> 
				</div>
	
	     	    <!-- count  -->
				<div class="half-unit">
		      		<dtitle>방문자 수</dtitle>
		      		<hr>
		      		<div class="cont">
						<p><span class="todayTitle" style="color:#2E9AFE">오늘</span> : <span class="todayCnt" style="color:#FA5858">-</span></p>
						<p><span class="yesterTitle" style="color:#2E9AFE">어제 </span> : <span class="yesterCnt" style="color:#F2F5A9">-</span></p>
					</div>
				</div>
			</div>
      </div><!-- /row -->
      
      

      <div class="row">
      	
        <div class="col-sm-3 col-lg-3"> 
        	<div class="dash-unit">
		  		<dtitle>접속시간 분포도(최근 30일)</dtitle>
		  		<hr>
	        	<div id="xconnect" style="width:100%;height:250px;padding:5px;"></div> 
	        	<!-- <h2>45%</h2> -->
			</div>
        </div>
      	<div class="col-sm-3 col-lg-3"> 
      		<div class="dash-unit">
		  		<dtitle>브라우져 사용비율 (최근 1년)</dtitle>
		  		<hr>
	        	<div id="xbrowser" style="width:100%;height:250px;padding:5px;"></div> 
	        	<!-- <h2>45%</h2> -->
			</div>
        </div>
        
        <div class="col-sm-3 col-lg-3"> 
      		<div class="dash-unit"> 
		  		<dtitle>os 사용비율 (최근 1년)</dtitle>
		  		<hr>
	        	<div id="xos" style="width:100%;height:250px;padding:5px;"></div> 
	        	<!-- <h2>45%</h2> -->
			</div>
        </div>
        
		
		
		<div id="brsMainDummy" style="display:none;"><span class="brsMainSpan"><span class="brsTitle" style="color:#2E9AFE">-</span> : <span class="brsCnt" style="color:#F2F5A9">-</span></span></div>
		<div id="osMainDummy" style="display:none;"><span class="osMainSpan"><span class="osTitle" style="color:#2E9AFE">-</span> : <span class="osCnt" style="color:#F2F5A9">-</span></span></div>	 
		<div class="col-sm-3 col-lg-3">
				<!-- LOCAL TIME BLOCK -->
	      		<div class="half-unit" >
		      		<dtitle>사용자 브라우저 정보 접속량 Top4</dtitle>
		      		<hr>
			      	<div style="width:100%;padding-left:12px; color:#F2EFFB;">
						<p class="brsMainP">
										
						</p>
					</div>
				</div>
	
	     	    <!-- count  -->
				<div class="half-unit">
		      		<dtitle>사용자 OS 정보 접속량 Top4</dtitle>
		      		<hr>
		      		<div style="width:100%;padding-left:12px; color:#F2EFFB;">
						<p class="osMainP">
										
						</p>
					</div>
				</div>
		</div>
      </div> <!-- end row -->
      
      
      
       <div class="row">
		<div class="col-sm-12 col-lg-12">
			<h4><strong>최근 3개월 메뉴별 방문 횟수 순위</strong></h4>
			  <table class="display" id="menu_table">
	          <thead>
	            <tr>
	              <th>번호</th>
	           	  <th>부모명</th>
	              <th>메뉴명</th>
	              <th>페이지코드</th>
	              <th>방문횟수</th>
	              
	            </tr>
	          </thead>
	          <tbody>
	          	<c:set var="ii" value="1" />
	          	<c:forEach var="result" items="${_mlist}" varStatus="status">	  
	          	<c:if test="${not empty result.menu_name }">   	        	
	            <tr class="odd" id="tr_${result.menu_idx}">
	            <input type="hidden" name="menu_idx" value="${result.menu_idx}" />
	              <td>${ii}</td>
	              <td class="prtCate"><i class="fa fa-spinner fa-spin fa-fw"></i></td>
	              <td>${result.menu_name}</td>
	              <td>${result.url}</td>
	              <td class="center">${result.cnt}</td>             
	            </tr>
	            <c:set var="ii" value="${ii+1}" />
	            </c:if>
	            </c:forEach>
	          </tbody>
	         </table><!--/END First Table -->
			 <br>
			 <!--SECOND Table -->
      	</div>
      </div> <!-- end row -->

	