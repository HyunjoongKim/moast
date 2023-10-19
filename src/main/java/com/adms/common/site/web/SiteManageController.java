package com.adms.common.site.web;

import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.common.code.service.CommonCodeService;
import com.adms.common.site.service.SiteManageService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.AuthVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_siteVO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import net.sf.json.JSONObject;

@Controller
public class SiteManageController {
	private final static Logger logger = LoggerFactory.getLogger("com");
	private String LEFT_MENU_GROUP = "main_site"; //left select menu name
	
	@Resource(name = "LoginService")
    private LoginService loginService;
	
	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;
	
	@Resource(name = "SiteManageService")
    private SiteManageService siteManageService;
	
	
	//사이트관리 리스트
	@RequestMapping(value = "/adms/common/site/list.do", method = RequestMethod.GET)
	public String list(
			@ModelAttribute("searchVO") tbl_siteVO searchVO,
			Model model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();
		searchVO.setSite_code(loginService.getSiteCode());

		try{
			/* 페이징 시작 */
	    	PaginationInfo paginationInfo = new PaginationInfo();

	    	paginationInfo.setCurrentPageNo(searchVO.getPageIndex());		//현재 페이지 번호
	    	paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());	//한 페이지에 게시되는 게시물 건수
	    	paginationInfo.setPageSize(searchVO.getPageSize());				//페이징 리스트의 사이즈

	    	searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
	    	searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
	    	searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

	    	Map<String, Object> map = siteManageService.getList(searchVO);
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

		model.addAttribute("siteCode", loginService.getSiteCode());	
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/common/site/list";
	}
	
	
	
	//등록 화면
	@RequestMapping(value = "/adms/common/site/create.do")
    public String create(
    		@ModelAttribute("searchVO") tbl_siteVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/common/site/create";
	}
	
	
	 //등록 submit
	@RequestMapping(value = "/adms/common/site/create_action.do", method = RequestMethod.POST)
    public String create_action(
    		@ModelAttribute("searchVO") tbl_siteVO searchVO,
    		RedirectAttributes redirectAttributes,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		Map<String, Object> resMap = new HashMap<String, Object>();

		try{
			//searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

			siteManageService.insertDB(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "txt.success");
		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.fail");
    	}


		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/adms/common/site/list.do";
	}
	 
	 
	//수정 화면
	@RequestMapping(value = "/adms/common/site/update.do")
    public String update(
    		@ModelAttribute("searchVO") tbl_siteVO searchVO,
    		@RequestParam(required = true, value = "ts_pkid") int ts_pkid,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();

		try{
			searchVO.setTs_pkid(ts_pkid);
			searchVO.setSite_code(loginService.getSiteCode());

			tbl_siteVO svo = siteManageService.getDetailVO(searchVO);
			model.addAttribute("svo", svo);

		}catch(Exception e){
			System.out.println(e.toString());
    	}

		searchVO.setQustr();
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/common/site/update";
	}
	
	
	//수정
	@RequestMapping(value = "/adms/common/site/update_action.do", method = RequestMethod.POST)
    public String update_action(
    		@ModelAttribute("searchVO") tbl_siteVO searchVO,
    		RedirectAttributes redirectAttributes,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		Map<String, Object> resMap = new HashMap<String, Object>();

		try{
			//searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			siteManageService.updateVO(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "txt.success");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.fail");
    	}

		searchVO.setQustr();
		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/adms/common/site/list.do?"+searchVO.getQustr();
	}
	
	
	// 삭제
	@RequestMapping(value = "/adms/common/site/delete_action.do", method = RequestMethod.POST)
	@ResponseBody
    public String delete_action(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			ObjectMapper mapper = new ObjectMapper();
			tbl_siteVO searchVO = (tbl_siteVO)mapper.readValue(filterJSON,new TypeReference<tbl_siteVO>(){ });

			//searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			siteManageService.deleteVO(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "txt.success.delete");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.fail");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}
	
	
}
