package com.adms.common.log.web;

import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.code.service.CommonCodeService;
import com.adms.common.log.service.MenuLogService;
import com.adms.common.log.service.SiteLogService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_siteLogVO;
import com.bsite.vo.tbl_siteVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class LogHomeController {
	
	private String LEFT_MENU_GROUP = "menulog_home"; //left select menu name
	
	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;
	
	@Resource(name = "MenuLogService")
    private MenuLogService menuLogService;
	
	@Resource(name = "SiteLogService")
    private SiteLogService siteLogService;
	
	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	@Resource(name = "LoginService")
    private LoginService loginService;
	
	@RequestMapping(value = "/adms/common/log/list.do")
	public String list(
			@ModelAttribute("searchVO") tbl_menuLogVO searchVO,
			Model model) throws Exception {			

		
		List<tbl_menuLogVO> _mlist =siteLogService.menuTopCount(searchVO);
		model.addAttribute("_mlist", _mlist);		

		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);		
		return "tiles:adms/common/log/list";
				
	}
	
	
	
	
	
	
	
	
	
	
	
	
	@RequestMapping(value="/cmm/log/browserinfo.do")
	@ResponseBody
	public String  browserinfo(tbl_siteLogVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		
		LoginVO loginVO = loginService.getLoginInfo();
		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
			searchVO.setCret_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드	
			
			List<tbl_siteLogVO> result = siteLogService.browserinfo(searchVO);
			
			JSONArray cJsonArr = new JSONArray();
			JSONObject cJsonObj = new JSONObject();
			for(tbl_siteLogVO vo : result) {
				if(StringUtils.isNotEmpty(vo.getTitle())) {
					cJsonObj.put("name", vo.getTitle());
					cJsonObj.put("y", vo.getCnt());
					cJsonArr.add(cJsonObj);
				}
			}
			out.print(cJsonArr);
			
		
		return null;
	}
	
	@RequestMapping(value="/cmm/log/osinfo.do")
	@ResponseBody
	public String  osinfo(tbl_siteLogVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		
		LoginVO loginVO = loginService.getLoginInfo();
		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
			searchVO.setCret_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드	
			
			List<tbl_siteLogVO> result = siteLogService.osinfo(searchVO);
			
			JSONArray cJsonArr = new JSONArray();
			JSONObject cJsonObj = new JSONObject();
			for(tbl_siteLogVO vo : result) {
				if(StringUtils.isNotEmpty(vo.getTitle())) {
					cJsonObj.put("name", vo.getTitle());
					cJsonObj.put("y", vo.getCnt());
					cJsonArr.add(cJsonObj);
				}
			}
			out.print(cJsonArr);
			
		
		return null;
	}
	
	@RequestMapping(value="/cmm/log/todayinfo.do")
	@ResponseBody
	public String  todayinfo(tbl_siteLogVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		
		LoginVO loginVO = loginService.getLoginInfo();
		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
			searchVO.setCret_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드	
			
			List<tbl_siteLogVO> result = siteLogService.todayinfo(searchVO);
			
			JSONArray cJsonArr = new JSONArray();
			JSONObject cJsonObj = new JSONObject();
			for(tbl_siteLogVO vo : result) {
				if(StringUtils.isNotEmpty(vo.getTitle())) {
					cJsonObj.put("name", vo.getTitle());
					cJsonObj.put("y", vo.getCnt());
					cJsonObj.put("d", vo.getXright());
					cJsonArr.add(cJsonObj);
				}
			}
			out.print(cJsonArr);
			
		
		return null;
	}
	
		
	@RequestMapping(value="/cmm/log/connecttimeinfo.do")
	@ResponseBody
	public String  connecttimeinfo(tbl_siteLogVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		
		LoginVO loginVO = loginService.getLoginInfo();
		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
			searchVO.setCret_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드	
			
			List<tbl_siteLogVO> result = siteLogService.connecttimeinfo(searchVO);
			
			JSONArray cJsonArr = new JSONArray();
			JSONObject cJsonObj = new JSONObject();
			for(tbl_siteLogVO vo : result) {
				
					cJsonObj.put("name", vo.getXright());
					cJsonObj.put("min", vo.getXmin());
					cJsonObj.put("max", vo.getXmax());
					cJsonObj.put("avg", vo.getXavg());
					cJsonArr.add(cJsonObj);
			}
			
			out.print(cJsonArr);
			
		
		return null;
	}
	
	@RequestMapping(value="/cmm/log/monthinfo.do")
	@ResponseBody
	public String  monthinfo(tbl_siteLogVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		
		LoginVO loginVO = loginService.getLoginInfo();
		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
			searchVO.setCret_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드	
			
			List<tbl_siteLogVO> result = siteLogService.monthinfo(searchVO);
			
			JSONArray cJsonArr = new JSONArray();
			JSONObject cJsonObj = new JSONObject();
			for(tbl_siteLogVO vo : result) {
				if(StringUtils.isNotEmpty(vo.getTitle())) {
					cJsonObj.put("name", vo.getTitle());
					cJsonObj.put("y", vo.getCnt());
					cJsonObj.put("d", vo.getXright());
					cJsonArr.add(cJsonObj);
				}
			}
			out.print(cJsonArr);
			
		
		return null;
	}
	
	
	@RequestMapping(value="/cmm/log/totalCnt.do")
	@ResponseBody
	public String  totalCnt(tbl_siteLogVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		
		LoginVO loginVO = loginService.getLoginInfo();
		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
			searchVO.setCret_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드	
			
			List<tbl_siteLogVO> result = siteLogService.totalCnt(searchVO);
			
			JSONArray cJsonArr = new JSONArray();
			JSONObject cJsonObj = new JSONObject();
			for(tbl_siteLogVO vo : result) {
				if(StringUtils.isNotEmpty(vo.getTitle())) {
					cJsonObj.put("name", vo.getTitle());
					cJsonObj.put("y", vo.getCnt());
					cJsonObj.put("cdate", vo.getCdate());
					cJsonArr.add(cJsonObj);
				}
			}
			out.print(cJsonArr);
			
		
		return null;
	}
	
	
	@RequestMapping(value="/cmm/log/getPrtMenuCate.do")
	@ResponseBody
	public String  getPrtMenuCate(String idxs,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		
		LoginVO loginVO = loginService.getLoginInfo();		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
			tbl_menuLogVO searchVO = new tbl_menuLogVO();
			searchVO.setCret_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드	
			String [] idxArr = idxs.split("\\,");
			List<tbl_menuLogVO> result = new ArrayList<tbl_menuLogVO>();
					
			for(String x : idxArr){
				searchVO.setMenu_idx(Integer.parseInt(x)); 
				tbl_menuLogVO	mlvo = siteLogService.getPrtMenuCate(searchVO);
				mlvo.setMenu_idx(Integer.parseInt(x));
				result.add(mlvo);
			}
			JSONArray cJsonArr = new JSONArray();
			JSONObject cJsonObj = new JSONObject();
			for(tbl_menuLogVO vo : result) {
				if(StringUtils.isNotEmpty(vo.getMenu_name())) {
					cJsonObj.put("menu_name", vo.getMenu_name());
					cJsonObj.put("menu_idx", vo.getMenu_idx());
					cJsonArr.add(cJsonObj);
				}
			}
			out.print(cJsonArr);
			
		
		return null;
	}
	
}
