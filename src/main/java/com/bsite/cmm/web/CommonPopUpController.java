package com.bsite.cmm.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.code.service.CommonCodeService;
import com.adms.member.service.MemberManage2Service;
import com.bsite.account.service.LoginService;
import com.bsite.vo.AuthVO;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/**
 * @Class Name : CommonPopUpController.java
 * @Description : 공통으로 사용해야할 팝업 컨트롤러 1
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일                      수정자               수정내용
 *  -------      --------    ---------------------------
 *   2017.07.17.   박종화              최초 생성
 *
 * </pre>
 */


@Controller
public class CommonPopUpController {
	//  /cmm/ 의 주소로 시작 
	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;

	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	@Resource(name = "MemberManage2Service")
    private MemberManage2Service memberManage2Service;
	

	
	
	
	
	//회원관리- 회원 리스트팝업
	@RequestMapping(value="/cmm/member/memberManage/list.do")
	public String member_list(
		@ModelAttribute("searchVO") MemberVO searchVO,
									HttpServletRequest request,
											ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();
		searchVO.setSite_code(loginService.getSiteCode());
		String returnUrl = "tilespopupadms:adms/member/memberManage/list_popup";
		returnUrl=popUpreturnUrl(searchVO.getPopType());
		
		String callType = request.getParameter("callType");
		if(StringUtils.isEmpty(callType)){
			callType ="sys";   //res, sys
		}
		model.addAttribute("callType", callType);
		
		
		try{
			//권한 목록
			Map<String, Object> searchMap = new HashMap<String, Object>();
			searchMap.put("site_code", loginService.getSiteCode());
	
			List<AuthVO> authList = memberManage2Service.getAuthList(searchMap);
			model.addAttribute("authList", authList);
			
			List<CommonCodeVO> memTypeList = loginService.getDefaultCodeList("414");		//회원구분
	    	model.addAttribute("memTypeList", memTypeList);
	
			/* 페이징 시작 */
	    	PaginationInfo paginationInfo = new PaginationInfo();
	
	    	paginationInfo.setCurrentPageNo(searchVO.getPageIndex());		//현재 페이지 번호
	    	paginationInfo.setRecordCountPerPage(10);						//한 페이지에 게시되는 게시물 건수
	    	paginationInfo.setPageSize(searchVO.getPageSize());				//페이징 리스트의 사이즈
	
	    	searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
	    	searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
	    	searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
	
	    	Map<String, Object> map = memberManage2Service.getMemberList(searchVO);
	    	int totCnt = Integer.parseInt((String)map.get("resultCnt"));
	
	    	paginationInfo.setTotalRecordCount(totCnt);
	
	    	model.addAttribute("resultList", map.get("resultList"));
	    	model.addAttribute("resultCnt", map.get("resultCnt"));
	    	model.addAttribute("totalPageCnt", (int)Math.ceil(totCnt / (double)searchVO.getPageUnit()));
	    	model.addAttribute("paginationInfo", paginationInfo);
	    	/* 페이징 끝 */
	
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		searchVO.setQustr();
		return returnUrl;
	}
	
	String popUpreturnUrl(String pType){ 
		String r = "tilespopupadms:adms/member/memberManage/list_popup";
			if("CHK".equals(pType)){
				 r = "tilespopupadms:adms/member/memberManage/list_popup_dcheck";
			}
		return r;
	}
	
	
	

	
}
