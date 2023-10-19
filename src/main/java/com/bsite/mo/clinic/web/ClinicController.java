package com.bsite.mo.clinic.web;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

import com.adms.crc.clinic2.service.Clinic2Service;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.PythonAPI;
import com.bsite.cmm.PythonAPI.PathwayType;
import com.bsite.mo.clinic.service.ClinicGrpService;
import com.bsite.mo.visual.service.PresetService;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.LoginVO;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.mo_clinic_groupVO;
import com.bsite.vo.mo_clinic_group_dtlVO;
import com.bsite.vo.mo_clinicalD2VO;
import com.bsite.vo.mo_clinicalVO;
import com.bsite.vo.mo_pathwayVO;
import com.bsite.vo.mo_presetVO;

import net.sf.json.JSONArray;

@Controller
public class ClinicController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "Clinic2Service")
	private Clinic2Service clinic2Service;

	@Resource(name = "ClinicGrpService")
	private ClinicGrpService clinicGrpService;

	@Resource(name = "PresetService")
	private PresetService presetService;

	private void setUdIdxBySession(mo_clinic_groupVO searchVO, HttpServletRequest request) {
		HttpSession session = request.getSession();
		searchVO.setUd_idx((Integer) session.getAttribute("ud_idx"));
	}

	@RequestMapping(value = "/mo/clinic/list.do")
	public String list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {

		if (searchVO.getUd_idx() == null || searchVO.getUd_idx() < 1) {
			return "redirect:/mo/analysisdata/list.do";
		}

		String rtn = "tiles:bsite/mo/clinic/list";

		try {

			Integer ud_idx = searchVO.getUd_idx();
			if (ud_idx == null)
				ud_idx = 1;
			session.setAttribute("ud_idx", ud_idx);

			if (searchVO.getUd_idx() == 2) {
				// tcga 샘플 데이터 구조가 다름
				mo_clinicalD2VO cVO = new mo_clinicalD2VO();
				Map<String, Object> map = clinic2Service.selectClinicD2List(cVO);
				int resultCnt = Integer.parseInt((String) map.get("resultCnt"));

				@SuppressWarnings("unchecked")
				List<mo_clinicalD2VO> resultList = (List<mo_clinicalD2VO>) map.get("resultList");

				JSONArray jsonBody = JSONArray.fromObject(resultList);
				model.addAttribute("jsonBody", jsonBody);
				model.addAttribute("resultCnt", resultCnt);

				mo_presetVO presetVO = new mo_presetVO();
				if (searchVO.getPs_idx() != null && searchVO.getPs_idx() > 0) {
					presetVO.setPs_idx(searchVO.getPs_idx());
					presetVO = presetService.selectPresetByIdx(presetVO);
					searchVO.setCg_idx(presetVO.getCg_idx());
				}
				rtn = "tiles:bsite/mo/clinic/list2";
			} else {
				mo_clinicalVO cVO = new mo_clinicalVO();
				Map<String, Object> map = clinic2Service.selectClinicList(cVO);
				int resultCnt = Integer.parseInt((String) map.get("resultCnt"));

				@SuppressWarnings("unchecked")
				List<mo_clinicalVO> resultList = (List<mo_clinicalVO>) map.get("resultList");

				JSONArray jsonBody = JSONArray.fromObject(resultList);
				model.addAttribute("jsonBody", jsonBody);
				model.addAttribute("resultCnt", resultCnt);

				mo_presetVO presetVO = new mo_presetVO();
				if (searchVO.getPs_idx() != null && searchVO.getPs_idx() > 0) {
					presetVO.setPs_idx(searchVO.getPs_idx());
					presetVO = presetService.selectPresetByIdx(presetVO);
					searchVO.setCg_idx(presetVO.getCg_idx());
				}
			}

		} catch (Exception e) {
			logger.error("", e);
		}

		return rtn;
	}

	@RequestMapping(value = "/mo/clinic/create_group_action.do")
	@ResponseBody
	public AjaxResult create_group_action(@ModelAttribute("searchVO") mo_clinic_groupVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		LoginVO loginVO = loginService.getLoginInfo();

		try {

			setUdIdxBySession(searchVO, request);

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			searchVO.setMe_idx(loginVO.getIdx());

			clinicGrpService.createClinicGrp(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/clinic/delete_group_action.do")
	@ResponseBody
	public AjaxResult delete_group_action(@ModelAttribute("searchVO") mo_clinic_groupVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		LoginVO loginVO = loginService.getLoginInfo();

		try {

			setUdIdxBySession(searchVO, request);

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			searchVO.setMe_idx(loginVO.getIdx());

			clinicGrpService.deleteClinicGrp(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/clinic/list_group_action.do")
	@ResponseBody
	public AjaxResult list_group_action(@ModelAttribute("searchVO") mo_clinic_groupVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			setUdIdxBySession(searchVO, request);

			LoginVO loginVO = loginService.getLoginInfo();
			searchVO.setMe_idx(loginVO.getIdx());

			Map<String, Object> map = clinicGrpService.selectClinicGrpList(searchVO);

			@SuppressWarnings("unchecked")
			List<mo_clinic_groupVO> resultList = (List<mo_clinic_groupVO>) map.get("resultList");

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(map);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/clinic/list_group_action2.do")
	@ResponseBody
	public AjaxResult list_group_action2(@ModelAttribute("searchVO") mo_clinic_groupVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {
			List<mo_pathwayVO> list = PythonAPI.callPathwayGenes(PathwayType.KEGG, searchVO.getSearchSamples1());

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(list);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/clinic/list_group_dtl_action.do")
	@ResponseBody
	public AjaxResult list_group_dtl_action(@ModelAttribute("searchVO") mo_clinic_groupVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			setUdIdxBySession(searchVO, request);

			List<mo_clinic_group_dtlVO> list = clinicGrpService.selectClinicGrpDtlList(searchVO);
			List<String> sampleIdList = list.stream().map(x -> x.getSample_id()).collect(Collectors.toList());

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("dtls", list);
			map.put("samples", sampleIdList);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(map);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/clinic/list_group_exist_action.do")
	@ResponseBody
	public AjaxResult list_group_exist_action(@ModelAttribute("searchVO") mo_clinic_groupVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			LoginVO loginVO = loginService.getLoginInfo();

			setUdIdxBySession(searchVO, request);
			searchVO.setMe_idx(loginVO.getIdx());

			Map<String, Object> map = clinicGrpService.selectClinicGrpList(searchVO);

			@SuppressWarnings("unchecked")
			List<mo_clinic_groupVO> resultList = (List<mo_clinic_groupVO>) map.get("resultList");

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(map);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/clinic/list_group_dupl_action.do")
	@ResponseBody
	public AjaxResult list_group_dupl_action(@ModelAttribute("searchVO") mo_clinic_groupVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			setUdIdxBySession(searchVO, request);

			List<mo_clinic_groupVO> list = clinicGrpService.selectClinicGrpDuplList(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(list);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

}
