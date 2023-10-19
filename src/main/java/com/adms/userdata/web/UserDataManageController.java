package com.adms.userdata.web;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.common.log.service.AdminLogService;
import com.bsite.account.service.LoginService;
import com.bsite.mo.analysisdata.service.AnalysisDataService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;
import com.bsite.vo.mo_analysisDataVO;
import com.bsite.vo.tbl_adminLogVO;

import egovframework.com.cmm.service.FileVO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class UserDataManageController {

	private final static Logger logger = LoggerFactory.getLogger("com");
	private final String LEFT_MENU_GROUP = "userdata_list"; // left select menu name
	private final String gErrorPage = "tiles:bsite/common/msg";

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "AnalysisDataService")
	private AnalysisDataService dataService;

	@Resource(name = "AdminLogService")
	private AdminLogService adminLogService;

	// 회원 목록
	@RequestMapping(value = "/adms/userdata/manage/list.do")
	public String list(@ModelAttribute("searchVO") mo_analysisDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();
		searchVO.setSite_code(loginService.getSiteCode());
		
		try {
			List<CommonCodeVO> statusList = loginService.getDefaultCodeList("814");		//회원구분
	    	model.addAttribute("statusList", statusList);

			/* 페이징 시작 */
			PaginationInfo paginationInfo = new PaginationInfo();

			paginationInfo.setCurrentPageNo(searchVO.getPageIndex()); // 현재 페이지 번호
			paginationInfo.setRecordCountPerPage(searchVO.getPageUnit()); // 한 페이지에 게시되는 게시물 건수
			paginationInfo.setPageSize(searchVO.getPageSize()); // 페이징 리스트의 사이즈

			searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
			searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
			searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

			Map<String, Object> map = dataService.selectAnalysisDataList(searchVO);
			int totCnt = Integer.parseInt((String) map.get("resultCnt"));

			paginationInfo.setTotalRecordCount(totCnt);

			model.addAttribute("resultList", map.get("resultList"));
			model.addAttribute("resultCnt", map.get("resultCnt"));
			model.addAttribute("totalPageCnt", (int) Math.ceil(totCnt / (double) searchVO.getPageUnit()));
			model.addAttribute("paginationInfo", paginationInfo);
			/* 페이징 끝 */

			// 관리자 로그기록 관리
			tbl_adminLogVO adminLog = new tbl_adminLogVO();

			adminLog.setUser_idx(loginVO.getIdx());
			adminLog.setMenu_code("userdata");
			adminLog.setGubun("2");
			adminLog.setInfor("사용자데이터 목록");
			adminLog.setSite_code(loginService.getSiteCode());
			adminLog.setCret_id(loginVO.getId());
			adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			adminLogService.insertAdminLog(adminLog);

		} catch (Exception e) {
			logger.error("", e);
		}

		searchVO.setQustr();
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/userdata/manage/list";
	}

	// 회원 수정 화면
	@RequestMapping(value = "/adms/userdata/manage/update.do")
	public String update(@ModelAttribute("searchVO") mo_analysisDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		try {

			searchVO.setMe_idx(loginVO.getIdx());
			searchVO.setSite_code(loginService.getSiteCode());
			
			List<CommonCodeVO> statusList = loginService.getDefaultCodeList("814");		//회원구분
	    	model.addAttribute("statusList", statusList);

			mo_analysisDataVO dataVO = dataService.selectAnalysisDataById(searchVO);
			model.addAttribute("dataVO", dataVO);

			// 관리자 로그기록 관리
			tbl_adminLogVO adminLog = new tbl_adminLogVO();
			adminLog.setUser_idx(loginVO.getIdx());
			adminLog.setMenu_code("userdata");
			adminLog.setGubun("6");
			adminLog.setInfor("[" + dataVO.getUd_idx() + "] 수정폼");
			adminLog.setSite_code(loginService.getSiteCode());
			adminLog.setCret_id(loginVO.getId());
			adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			adminLogService.insertAdminLog(adminLog);

		} catch (Exception e) {
			logger.error("", e);
		}

		searchVO.setQustr();
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/userdata/manage/update";
	}
	
	@RequestMapping(value = "/adms/userdata/manage/update_action.do", method = RequestMethod.POST)
    public String update_action(
    		@ModelAttribute("searchVO") mo_analysisDataVO searchVO,
    		RedirectAttributes redirectAttributes,
    		final MultipartHttpServletRequest multiRequest,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		Map<String, Object> resMap = new HashMap<String, Object>();

		try{

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			
			dataService.updateAnalysisDataStatus(searchVO);

			// 관리자 로그기록 관리
			tbl_adminLogVO adminLog = new tbl_adminLogVO();
			adminLog.setUser_idx(loginVO.getIdx());
			adminLog.setMenu_code("userdata");
			adminLog.setGubun("7");
			adminLog.setInfor("[" + searchVO.getUd_idx() + "] 수정");
			adminLog.setSite_code(loginService.getSiteCode());
			adminLog.setCret_id(loginVO.getId());
			adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			adminLogService.insertAdminLog(adminLog);
			
			resMap.put("res", "ok");
			resMap.put("msg", "txt.success.update");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.fail");
    	}

		searchVO.setQustr();
		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/adms/userdata/manage/list.do?"+searchVO.getQustr();
	}

}
