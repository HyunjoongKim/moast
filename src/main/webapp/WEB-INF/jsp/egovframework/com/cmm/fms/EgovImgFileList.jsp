<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovImgFileList.jsp
  * @Description : 이미지 파일 조회화면
  * @Modification Information
  * @
  * @  수정일      수정자            수정내용
  * @ -------        --------    ---------------------------
  * @ 2009.03.31  이삼섭          최초 생성
  *
  *  @author 공통서비스 개발팀 이삼섭
  *  @since 2009.03.31
  *  @version 1.0
  *  @see
  *
  */
%>

		<c:set var="isCount" value="0" />
      	<c:forEach var="fileVO" items="${fileList}" varStatus="status">
      	<c:set var="extention" value="${fn:toLowerCase(fileVO.fileExtsn)}" />

      	<c:if test="${isCount eq '0' }">
	      	  <c:if test="${extention eq 'jpg' || extention eq 'jpeg' || extention eq 'gif' ||extention eq 'bmp' || extention eq 'png'}" >
	      	  <c:set var="isCount" value="1" />
				<img src='<c:url value='/cmm/fms/getImage.do'/>?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>'  alt="${fileVO.orignlFileNm} 대표 게시물 이미지 입니다."/>
		      </c:if>
	     </c:if>
        </c:forEach>
        
        <c:if test="${isCount eq '0' }">
			<img src="${pageContext.request.contextPath}/img/bbs/img_none.gif" alt="게시된 이미지가 없습니다." width="140px" height="105px;"  />
        </c:if>

      