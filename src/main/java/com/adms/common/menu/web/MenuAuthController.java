package com.adms.common.menu.web;

import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.board.service.BoardManage2Service;
import com.adms.common.code.service.CommonCodeService;
import com.adms.common.menu.service.MenuAuth2Service;
import com.adms.common.menu.service.MenuAuthService;
import com.adms.common.site.service.SiteManageService;
import com.adms.member.service.AuthManage2Service;
import com.bsite.account.service.LoginService;
import com.bsite.vo.AuthVO;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_authcommonVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_pdsVO;
import com.bsite.vo.tbl_siteVO;

import freemarker.template.utility.StringUtil;

@Controller
public class MenuAuthController {
	private final static Logger logger = LoggerFactory.getLogger("com");
	private final String LEFT_MENU_GROUP = "menu_manage"; // left select menu name

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "CommonCodeService")
	private CommonCodeService commonCodeService;

	@Resource(name = "MenuAuthService")
	private MenuAuthService menuauthservice;

	@Resource(name = "MenuAuth2Service")
	private MenuAuth2Service menuauth2service;

	@Resource(name = "AuthManage2Service")
	private AuthManage2Service authManage2Service;

	@Resource(name = "SiteManageService")
	private SiteManageService siteManageService;

	@Resource(name = "BoardManage2Service")
	private BoardManage2Service boardManage2Service;

	// 메뉴관리 트리그리드
	@RequestMapping(value = "/adms/common/menu/list.do", method = RequestMethod.GET)
	public String list(@ModelAttribute("searchVO") tbl_menu_manageVO searchVO, Model model) throws Exception {
		// searchVO.setCode_cate("default"); //코드
		// maxdepth default 4

		if (StringUtils.isEmpty(searchVO.getSite_code()))
			searchVO.setSite_code("site1");
		// 권한 목록
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("site_code", loginService.getSiteCode());
		List<AuthVO> authList = authManage2Service.getAuthListAll(searchMap); // 권한리스트

		List<tbl_siteVO> siteList = siteManageService.getListAll(); // 사이트리스트

		model.addAttribute("siteCode", searchVO.getSite_code());
		model.addAttribute("authList", authList);
		model.addAttribute("siteList", siteList);
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/common/menu/list";
	}

	// 트리 그리드 가져오기
	@RequestMapping(value = "/adms/common/menu/list_ajax.do", method = RequestMethod.GET)
	@ResponseBody
	public String list_ajax(tbl_menu_manageVO searchVO, ModelMap model, HttpServletResponse res) throws Exception {
		JSONObject obj = new JSONObject();
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		try {
			if (StringUtils.isEmpty(searchVO.getSite_code()))
				searchVO.setSite_code("site1");
			searchVO.setSite_code(searchVO.getSite_code()); // 로그인 사이트 코드
			List<tbl_menu_manageVO> gridData = menuauth2service.getMainList(searchVO);
			JSONArray list = JSONArray.fromObject(gridData);
			for (int i = 0; i < list.size(); i++) {
				JSONObject vobj = list.getJSONObject(i);
				if (StringUtils.isEmpty(vobj.get("_parentId").toString())) {
					vobj.remove("_parentId");
				}
				// logger.debug(i+" : "+vobj);
			}
			obj.put("rows", list);
			obj.put("total", gridData.size());

			out.print(obj);
		} catch (Exception e) {
			logger.debug("ajax 부르기 Error");
		}
		return null;

	}

	// 게시판 목록 가져오기
	@RequestMapping(value = "/adms/common/menu/list_board.do", method = RequestMethod.GET)
	@ResponseBody
	public String list_board(tbl_menu_manageVO searchVO, ModelMap model, HttpServletResponse res) throws Exception {
		JSONObject obj = new JSONObject();
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		try {

			List<tbl_authcommonVO> _l = boardManage2Service.getBoardListAll();
			obj.put("res", "ok");
			obj.put("rows", _l);
			obj.put("total", _l.size());

		} catch (Exception e) {
			logger.debug("ajax 부르기 Error");
			obj.put("res", "error");
		}

		out.print(obj);
		return null;
	}

	// 메뉴 순번 변환
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/adms/common/menu/update_order.do", method = RequestMethod.POST)
	@ResponseBody
	public String update_order(@RequestBody String filterJSON, tbl_menu_manageVO searchVO, ModelMap model, HttpServletResponse res) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();
		JSONObject resMap = new JSONObject();
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();

		searchVO.setSite_code(loginService.getSiteCode()); // 로그인 사이트 코드
		searchVO.setCret_id(loginVO.getId()); // 내아이디
		searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
		try {

			org.json.simple.parser.JSONParser jsonParser = new JSONParser();
			ObjectMapper mapper = new ObjectMapper();
			// org.json.simple.JSONObject jsonObject = (org.json.simple.JSONObject)
			// jsonParser.parse(filterJSON);
			/*
			 * org.json.simple.JSONObject mainObj= (org.json.simple.JSONObject)
			 * jsonObject.get("mainData"); QC_PROCS_WD_VO wv =
			 * (QC_PROCS_WD_VO)mapper.readValue( mainObj.toJSONString(),new
			 * TypeReference<QC_PROCS_WD_VO>(){ });
			 * 
			 * org.json.simple.JSONArray colObj= (org.json.simple.JSONArray)
			 * jsonObject.get("colData"); List<String> cols =
			 * (List<String>)mapper.readValue( colObj.toJSONString(),new
			 * TypeReference<List<String>>(){ });
			 */
			// org.json.simple.JSONArray chkObj= (org.json.simple.JSONArray)
			// jsonObject.get("listD");
			org.json.simple.JSONArray jarr = (org.json.simple.JSONArray) jsonParser.parse(filterJSON);
			List<tbl_menu_manageVO> updateArr = (List<tbl_menu_manageVO>) mapper.readValue(jarr.toJSONString(), new TypeReference<List<tbl_menu_manageVO>>() {
			});

			menuauth2service.updateOrder(updateArr, searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "Save complete."); // 저장하였습니다.

		} catch (Exception e) {
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "An error occurred during execution."); // E 실행 도중 오류가 발생하였습니다.
			if (!StringUtils.isEmpty(e.getMessage()))
				resMap.put("msg", e.getMessage());
		}

		out.print(resMap);
		return null;
	}

	@RequestMapping(value = "/adms/common/menu/createAndUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public String createAndUpdate(@RequestBody String filterJSON, ModelMap model, HttpServletResponse res) throws Exception {
		JSONObject resMap = new JSONObject();
		// searchVO.setSite_code(loginService.getSiteCode()); //로그인 사이트 코드
		LoginVO loginVO = loginService.getLoginInfo();
		if (loginVO == null)
			loginVO = new LoginVO();
		if (StringUtils.isEmpty(loginVO.getId()))
			loginVO.setId("NOTLOGIN");
		try {
			int cdidx = 0;
			// -------------------------------------- json parse
			// -------------------------------------------------
			org.json.simple.parser.JSONParser jsonParser = new JSONParser();
			ObjectMapper mapper = new ObjectMapper();
			org.json.simple.JSONObject jsonObject = (org.json.simple.JSONObject) jsonParser.parse(filterJSON);
			tbl_menu_manageVO searchVO = (tbl_menu_manageVO) mapper.readValue(jsonObject.toJSONString(), new TypeReference<tbl_menu_manageVO>() {
			});
			// -------------------------------------- json parse
			// -------------------------------------------------

			if (searchVO.getMenu_idx() == 0) {// INSERT
				searchVO.setCret_id(loginVO.getId());
				searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			} else {// UPDATE
				searchVO.setModi_id(loginVO.getId());
				searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			}

			cdidx = menuauth2service.createAndUpdate(searchVO);
			resMap.put("res", "ok");
			resMap.put("cdidx", cdidx);
			resMap.put("msg", "저장하였습니다.");

		} catch (Exception e) {
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
			if (!StringUtils.isEmpty(e.getMessage()))
				resMap.put("msg", e.getMessage());
		}

		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(resMap);
		return null;

	}

	@RequestMapping(value = "/adms/common/menu/deleteNode.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteNode(tbl_menu_manageVO searchVO, ModelMap model, HttpServletResponse res) throws Exception {
		JSONObject resMap = new JSONObject();
		// searchVO.setSite_code(loginService.getSiteCode()); //로그인 사이트 코드
		LoginVO loginVO = loginService.getLoginInfo();
		if (loginVO == null)
			loginVO = new LoginVO();
		if (StringUtils.isEmpty(loginVO.getId()))
			loginVO.setId("NOTLOGIN");
		try {
			if (searchVO.getMenu_idx() == 0) {
				// ERROR
				resMap.put("res", "error");
				resMap.put("msg", "알수없는 오류가 발생하여 삭제가 실패 하였습니다.");
			} else {// DELETE
				menuauth2service.deleteNode(searchVO);
				resMap.put("res", "ok");
				resMap.put("msg", "삭제하였습니다.");
			}
		} catch (Exception e) {
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
			if (!StringUtils.isEmpty(e.getMessage()))
				resMap.put("msg", e.getMessage());
		}

		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(resMap);
		return null;

	}

}
