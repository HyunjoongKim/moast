package com.adms.member.web;

import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.member.service.AuthManage2Service;
import com.adms.member.service.AuthManageService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.AuthVO;
import com.bsite.vo.LoginVO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


@Controller
public class AuthManageController {

	private final static Logger logger = LoggerFactory.getLogger("com");
	private final String LEFT_MENU_GROUP = "member_auth"; //left select menu name

	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "AuthManageService")
    private AuthManageService authManageService;

	@Resource(name = "AuthManage2Service")
    private AuthManage2Service authManage2Service;


	//권한 목록
	@RequestMapping(value = "/adms/member/authManage/list.do")
    public String list(
    		@ModelAttribute("searchVO") AuthVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

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

	    	Map<String, Object> map = authManage2Service.getAuthList(searchVO);
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
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/member/authManage/list";
	}

	//권한 등록 화면
	@RequestMapping(value = "/adms/member/authManage/create.do")
    public String create(
    		@ModelAttribute("searchVO") AuthVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/member/authManage/create";
	}

	//권한 등록 submit
	@RequestMapping(value = "/adms/member/authManage/create_action.do", method = RequestMethod.POST)
    public String create_action(
    		@ModelAttribute("searchVO") AuthVO searchVO,
    		RedirectAttributes redirectAttributes,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		Map<String, Object> resMap = new HashMap<String, Object>();

		try{
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

			//코드 중복 체크
			int cnt = authManage2Service.getAuthCodeCnt(searchVO);

			if(cnt == 0){
				authManage2Service.insertAuthManage(searchVO);

				resMap.put("res", "ok");
				resMap.put("msg", "txt.success");
			}else{
				resMap.put("res", "ok");
				resMap.put("msg", "txt.fail.dup");
			}


		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.error");
    	}


		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/adms/member/authManage/list.do";
	}

	//권한 등록 json
	@RequestMapping(value = "/adms/member/authManage/create_actionJson.do", method = RequestMethod.POST)
	@ResponseBody
    public String create_action_json(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			ObjectMapper mapper = new ObjectMapper();
			AuthVO searchVO = (AuthVO)mapper.readValue(filterJSON,new TypeReference<AuthVO>(){ });

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

			authManageService.insertAuthManage(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "txt.success");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.error");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}

	//권한 수정 화면
	@RequestMapping(value = "/adms/member/authManage/update.do")
    public String update(
    		@ModelAttribute("searchVO") AuthVO searchVO,
    		@RequestParam(required = true, value = "authIdx") int authIdx,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();

		try{
			searchVO.setAuth_idx(authIdx);
			searchVO.setSite_code(loginService.getSiteCode());

			AuthVO authVO = authManage2Service.getAuthVO(searchVO);
			model.addAttribute("authVO", authVO);

		}catch(Exception e){
			System.out.println(e.toString());
    	}

		searchVO.setQustr();
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/member/authManage/update";
	}

	//권한 수정
	@RequestMapping(value = "/adms/member/authManage/update_action.do", method = RequestMethod.POST)
    public String update_action(
    		@ModelAttribute("searchVO") AuthVO searchVO,
    		RedirectAttributes redirectAttributes,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		Map<String, Object> resMap = new HashMap<String, Object>();

		try{
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			authManage2Service.updateAuthManage(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "txt.success.update");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.error");
    	}

		searchVO.setQustr();
		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/adms/member/authManage/list.do?"+searchVO.getQustr();
	}

	//권한 삭제
	@RequestMapping(value = "/adms/member/authManage/delete_action.do", method = RequestMethod.POST)
	@ResponseBody
    public String delete_action(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			ObjectMapper mapper = new ObjectMapper();
			AuthVO searchVO = (AuthVO)mapper.readValue(filterJSON,new TypeReference<AuthVO>(){ });

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			if(!"1".equals(searchVO.getAuth_code()) && !"99".equals(searchVO.getAuth_code())) {  //1,99 권한은 필수 
				authManage2Service.deleteAuthManage(searchVO);				
				resMap.put("res", "ok");
				resMap.put("msg", "txt.success.delete");			
			}else{				
				resMap.put("res", "error");
				resMap.put("msg", "txt.error");
			}

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.error");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}

	//권한 코드 체크
	@RequestMapping(value = "/adms/member/authManage/create_getCodeCnt.do", method = RequestMethod.POST)
	@ResponseBody
    public String create_getCodeCnt(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			ObjectMapper mapper = new ObjectMapper();
			AuthVO searchVO = (AuthVO)mapper.readValue(filterJSON,new TypeReference<AuthVO>(){ });

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			int cnt = authManage2Service.getAuthCodeCnt(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "조회하였습니다.");
			resMap.put("cnt", cnt);

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}





}
