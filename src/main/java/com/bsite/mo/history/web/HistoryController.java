package com.bsite.mo.history.web;

import java.net.InetAddress;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.member.service.MemberManage2Service;
import com.adms.mo.visual.service.WorkPresetService;
import com.bsite.account.service.LoginService;
import com.bsite.mo.history.service.HistoryService;
import com.bsite.mo.visual.service.PresetService;
import com.bsite.mo.visual.service.StudyService;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;
import com.bsite.vo.mo_historyVO;
import com.bsite.vo.mo_presetVO;

@Controller
public class HistoryController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "HistoryService")
	private HistoryService historyService;

	@Resource(name = "WorkPresetService")
	private WorkPresetService wpService;

	@Resource(name = "PresetService")
	private PresetService presetService;

	@Resource(name = "StudyService")
	private StudyService studyService;

	@Resource(name = "MemberManage2Service")
	private MemberManage2Service memberManage2Service;

	@RequestMapping(value = "/mo/history/preset/list.do")
	public String preset_list(@ModelAttribute("searchVO") mo_presetVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			searchVO.setMe_idx(loginService.getLoginInfo().getIdx());
			Map<String, Object> map = presetService.selectPresetList(searchVO);
			int resultCnt = Integer.parseInt((String) map.get("resultCnt"));

			@SuppressWarnings("unchecked")
			List<mo_historyVO> resultList = (List<mo_historyVO>) map.get("resultList");

			model.addAttribute("resultList", resultList);
			model.addAttribute("resultCnt", resultCnt);

			MemberVO memberVO = new MemberVO();
			memberVO.setFirstIndex(0);
			memberVO.setRecordCountPerPage(1000);
			memberVO.setSite_code(loginService.getSiteCode());

			Map<String, Object> memberMap = memberManage2Service.getMemberList(memberVO);
			model.addAttribute("memberList", memberMap.get("resultList"));

		} catch (Exception e) {
			logger.error("", e);
		}

		if ("Y".equals(searchVO.getPopYn())) {
			return "tilespopup:bsite/mo/history/preset/list";
		}
		return "tiles:bsite/mo/history/preset/list";

	}

	@RequestMapping(value = "/mo/history/preset/update_share.do")
	@ResponseBody
	public AjaxResult update_share(@ModelAttribute("searchVO") mo_presetVO searchVO, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		LoginVO loginVO = loginService.getLoginInfo();

		try {
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			searchVO.setMe_idx(loginVO.getIdx());

			presetService.updatePresetShare(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/history/preset/list_study.do")
	public String preset_study_list(@ModelAttribute("searchVO") mo_presetVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {
			searchVO.setMe_idx(loginService.getLoginInfo().getIdx());
			mo_presetVO presetVO = presetService.selectPresetByIdx(searchVO);

			model.addAttribute("presetVO", presetVO);
			model.addAttribute("resultList", presetVO.getStudyList());
		} catch (Exception e) {
			logger.error("", e);
		}

		if ("Y".equals(searchVO.getPopYn())) {
			return "tilespopup:bsite/mo/history/preset/list_study";
		}

		return "tiles:bsite/mo/history/preset/list_study";
	}

	@RequestMapping(value = "/mo/history/presetshared/list.do")
	public String presetshared_list(@ModelAttribute("searchVO") mo_presetVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {
			searchVO.setShare_me_idx(loginService.getLoginInfo().getIdx());
			Map<String, Object> map = presetService.selectPresetSharedList(searchVO);
			int resultCnt = Integer.parseInt((String) map.get("resultCnt"));

			@SuppressWarnings("unchecked")
			List<mo_historyVO> resultList = (List<mo_historyVO>) map.get("resultList");

			model.addAttribute("resultList", resultList);
			model.addAttribute("resultCnt", resultCnt);
		} catch (Exception e) {
			logger.error("", e);
		}

		if ("Y".equals(searchVO.getPopYn())) {
			return "tilespopup:bsite/mo/history/presetshared/list";
		}
		return "tiles:bsite/mo/history/presetshared/list";

	}

	@RequestMapping(value = "/mo/history/presetshared/list_study.do")
	public String presetshared_study_list(@ModelAttribute("searchVO") mo_presetVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {
			searchVO.setMe_idx(loginService.getLoginInfo().getIdx());
			mo_presetVO presetVO = presetService.selectPresetByIdx(searchVO);

			model.addAttribute("presetVO", presetVO);
			model.addAttribute("resultList", presetVO.getStudyList());
		} catch (Exception e) {
			logger.error("", e);
		}

		if ("Y".equals(searchVO.getPopYn())) {
			return "tilespopup:bsite/mo/history/presetshared/list_study";
		}

		return "tiles:bsite/mo/history/presetshared/list_study";
	}

}
