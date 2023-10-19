package com.bsite.mo.visual.web;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.adms.mo.visual.service.OmicsService;
import com.adms.mo.visual.service.WorkspaceService;
import com.bsite.account.service.LoginService;
import com.bsite.mo.history.service.HistoryService;
import com.bsite.mo.visual.service.HeatmapService;
import com.bsite.mo.visual.service.PresetService;
import com.bsite.mo.visual.service.StudyService;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.LoginVO;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.OmicsDataVO.SelectGeneSetType;
import com.bsite.vo.mo_heatmapVO;
import com.bsite.vo.mo_presetVO;
import com.bsite.vo.mo_studyVO;

import egovframework.com.cmm.service.Globals;

@Controller
public class VisualController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "OmicsService")
	private OmicsService omicsService;

	@Resource(name = "WorkspaceService")
	private WorkspaceService wsService;

	@Resource(name = "HistoryService")
	private HistoryService historyService;

	@Resource(name = "PresetService")
	private PresetService presetService;

	@Resource(name = "StudyService")
	private StudyService studyService;

	@Resource(name = "HeatmapService")
	private HeatmapService heatmapService;

	@RequestMapping(value = "/mo/visual/list_old.do")
	public String list_old(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			LoginVO loginVO = loginService.getLoginInfo();
			searchVO.setMe_idx(loginVO.getIdx());

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/visual/list_old";
	}

	@RequestMapping(value = "/mo/visual/list.do")
	public String list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {

		try {

			if (StringUtils.isBlank(searchVO.getGrp1())) {
				searchVO.setGrp1((String) session.getAttribute("grp1"));
				searchVO.setGrp2((String) session.getAttribute("grp2"));
			}

			List<OmicsDataVO> omicsList = null;
			mo_presetVO presetVO = (mo_presetVO) session.getAttribute("presetVO");
			if (searchVO.getGeneSetType() != null && searchVO.getGeneSetType() != SelectGeneSetType.None) {
				if (presetVO != null) {
					omicsList = presetVO.getOmicsList();
					if (omicsList.stream().map(x -> x.getStd_idx()).filter(x -> searchVO.getStd_idx() == x).findAny().isPresent()) {
						if (searchVO.getStd_idx() == 0 && Globals.IS_LOCAL) {
							omicsList.add(searchVO);
							presetVO.setOmicsList(omicsList);
						}
					} else {
						omicsList.add(searchVO);
						presetVO.setOmicsList(omicsList);
					}
				} else {
					presetVO = new mo_presetVO();
					omicsList = new ArrayList<OmicsDataVO>();
					omicsList.add(searchVO);
					presetVO.setOmicsList(omicsList);
				}
			}
			session.setAttribute("presetVO", presetVO);

			model.addAttribute("presetVO", presetVO);
			model.addAttribute("searchVO", searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/visual/list_set";
	}

	@RequestMapping(value = "/mo/visual/list_pre.do")
	public String list_pre(OmicsDataVO searchVO, RedirectAttributes redirectAttributes, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			if (searchVO.getGeneSetType() != null && searchVO.getGeneSetType() != SelectGeneSetType.None) {
				LoginVO loginVO = loginService.getLoginInfo();
				searchVO.setMe_idx(loginVO.getIdx());

				mo_studyVO stdVo = OmicsDataUtils.toStudyVO(searchVO);
				stdVo.setStd_title(stdVo.getGeneSetType().toString());

				stdVo.setMe_idx(loginVO.getIdx());
				stdVo.setModi_id(loginVO.getId());
				stdVo.setModi_ip(InetAddress.getLocalHost().getHostAddress());
				studyService.updateStudy(stdVo);
			}

			redirectAttributes.addFlashAttribute("searchVO", searchVO);
		} catch (Exception e) {
			logger.error("", e);
		}
		return "redirect:/mo/visual/list.do";
	}

	@RequestMapping(value = "/mo/visual/list_saved.do")
	public String list_saved(@ModelAttribute("pVO") mo_presetVO pVO, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {

		try {
			mo_presetVO presetVO = presetService.selectPresetByIdx(pVO);
			session.setAttribute("presetVO", presetVO);

			model.addAttribute("presetVO", presetVO);
			model.addAttribute("searchVO", presetVO.getOmicsList().get(0));

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/visual/list_set";
	}

	@RequestMapping(value = "/mo/visual/create_preset_action.do")
	public String create_preset_action(@ModelAttribute("searchVO") mo_presetVO searchVO, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {
		LoginVO loginVO = loginService.getLoginInfo();

		try {

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			searchVO.setMe_idx(loginVO.getIdx());
			presetService.createPreset(searchVO);

			mo_presetVO presetVO = presetService.selectPresetByIdx(searchVO);
			session.setAttribute("presetVO", presetVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "redirect:/mo/visual/list.do";

	}

	@RequestMapping(value = "/mo/visual/create_study_action.do")
	public String create_study_action(@ModelAttribute("stdVO") mo_studyVO stdVO, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {
		LoginVO loginVO = loginService.getLoginInfo();

		try {

			stdVO.setSite_code(loginService.getSiteCode());
			stdVO.setModi_id(loginVO.getId());
			stdVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			stdVO.setMe_idx(loginVO.getIdx());

			studyService.updateStudySave(stdVO);

			mo_presetVO presetVO = (mo_presetVO) session.getAttribute("presetVO");
			List<OmicsDataVO> omicsList = presetVO.getOmicsList();
			for (OmicsDataVO i : omicsList) {
				if (i.getStd_idx() == stdVO.getStd_idx()) {
					i.setStd_title(stdVO.getStd_title());
					i.setStd_note(stdVO.getStd_note());
					i.setStd_status("S");
					i.setStd_type(stdVO.getStd_type());
					i.setExpYN(stdVO.getExpYN());
					i.setMethYN(stdVO.getMethYN());
					i.setMutYN(stdVO.getMutYN());
				}
			}

			session.setAttribute("presetVO", presetVO);
			
		} catch (Exception e) {
			logger.error("", e);
		}

		return "redirect:/mo/visual/list.do";

	}

	@RequestMapping(value = "/mo/visual/list_dev.do")
	public String list_dev(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			LoginVO loginVO = loginService.getLoginInfo();
			searchVO.setMe_idx(loginVO.getIdx());

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/visual/list_dev";
	}

	@RequestMapping(value = "/mo/visual/list_excel.do")
	public String list_excel(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/visual/list_excel";
	}

	@RequestMapping(value = "/mo/visual/list_json_action.do")
	@ResponseBody
	public AjaxResult list_json_action(@ModelAttribute("searchVO") mo_heatmapVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			LoginVO loginVO = loginService.getLoginInfo();

			searchVO.setMe_idx(loginVO.getIdx());

			Map<String, Object> map = heatmapService.selectHeatmapListByPreset(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(map);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/visual/create_json_action.do")
	@ResponseBody
	public AjaxResult create_json_action(@ModelAttribute("searchVO") mo_heatmapVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		LoginVO loginVO = loginService.getLoginInfo();

		try {

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

			searchVO.setMe_idx(loginVO.getIdx());

			String json3 = StringEscapeUtils.unescapeHtml3(searchVO.getHm_json());
			searchVO.setHm_json(json3);

			heatmapService.createHeatmap(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

}
