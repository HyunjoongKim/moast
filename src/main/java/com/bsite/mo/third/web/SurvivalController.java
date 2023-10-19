package com.bsite.mo.third.web;

import java.util.Enumeration;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.crc.clinic2.service.Clinic2Service;
import com.adms.mo.visual.service.OmicsDataUtils;
import com.adms.mo.visual.service.OmicsService;
import com.adms.mo.visual.service.WorkPresetService;
import com.bsite.account.service.LoginService;
import com.bsite.mo.history.service.HistoryService;
import com.bsite.mo.third.service.SurvivalAdditionalRowService;
import com.bsite.mo.visual.service.StudyService;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.OmicsDataVO.OmicsNewType;
import com.bsite.vo.OmicsType;
import com.bsite.vo.mo_clinicalD2VO;
import com.bsite.vo.mo_clinicalVO;
import com.bsite.vo.mo_historyVO;
import com.bsite.vo.mo_studyVO;
import com.bsite.vo.mo_work_presetVO;
import com.bsite.vo.survival.SurvivalAdditionalRow;

import egovframework.com.cmm.service.Globals;

@Controller
public class SurvivalController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "HistoryService")
	private HistoryService historyService;

	@Resource(name = "WorkPresetService")
	private WorkPresetService wpService;

	@Resource(name = "Clinic2Service")
	private Clinic2Service clinic2Service;

	@Resource(name = "OmicsService")
	private OmicsService omicsService;

	@Resource(name = "StudyService")
	private StudyService studyService;

	@Resource(name = "SurvivalAdditionalRowService")
	private SurvivalAdditionalRowService survivalAdditionalRowService;

	@RequestMapping(value = "/mo/third/survival/list.do")
	public String list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		return "tiles:bsite/mo/third/survival/list";
	}

	@RequestMapping(value = "/mo/third/survival/list_omics_action.do")
	@ResponseBody
	public AjaxResult list_omics_action(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			mo_studyVO stdVO = new mo_studyVO();
			stdVO.setMe_idx(loginService.getLoginInfo().getIdx());
			Map<String, Object> map = studyService.selectStudyList(stdVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(map);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;

	}

	private void makeSheetExpByAnalysis(OmicsDataVO omicsVO) throws Exception {
		OmicsDataUtils.parseDegResult(omicsVO);
		List<String> geneList = omicsVO.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList());
		omicsVO.setGeneList(geneList);
		omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));

		OmicsDataUtils.makeSheetExp(omicsVO, omicsVO.getStd_title(), survivalAdditionalRowService.selectByType("exp"));
	}

	private void makeSheetExpByGeneSet(OmicsDataVO omicsVO, String title) throws Exception {
		OmicsDataUtils.makeSampleID(omicsVO);
		OmicsDataUtils.makeUserGeneList(omicsVO);
		omicsVO.setGeneList(omicsVO.getUserGeneList());
		omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));

		OmicsDataUtils.makeSheetExp(omicsVO, title, survivalAdditionalRowService.selectByType("exp"));
	}

	private void makeSheetMethByAnalysis(OmicsDataVO omicsVO) throws Exception {
		OmicsDataUtils.parseDmpResult(omicsVO);
		List<String> probeList = omicsVO.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList());
		omicsVO.setProbeList(probeList);
		omicsVO.setMethList(omicsService.selectMethListForHeatmap(omicsVO));
		OmicsDataUtils.makeGeneProbeList(omicsVO);
		OmicsDataUtils.makeGeneListByGeneProbe(omicsVO);

		OmicsDataUtils.makeSheetMeth(omicsVO, omicsVO.getStd_title(), survivalAdditionalRowService.selectByType("meth"));
	}

	private void makeSheetMethByGeneSet(OmicsDataVO omicsVO, String title) throws Exception {
		omicsVO.setType(OmicsType.Methylation);
		OmicsDataUtils.makeUserGeneList(omicsVO);

		omicsVO.setGeneList(omicsVO.getUserGeneList());

		omicsVO.setMethList(omicsService.selectMethListByGene(omicsVO));
		OmicsDataUtils.makeGeneProbeList(omicsVO);
		OmicsDataUtils.makeGeneListByGeneProbe(omicsVO);

		OmicsDataUtils.makeSheetMeth(omicsVO, title, survivalAdditionalRowService.selectByType("meth"));
	}

	private void makeSheetMutByAnalysis(OmicsDataVO omicsVO) throws Exception {
		omicsVO.setGeneList(omicsService.selectMutGeneListLimit(omicsVO));
		omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));

		OmicsDataUtils.makeSheetMut(omicsVO, omicsVO.getStd_title(), survivalAdditionalRowService.selectByType("mut"));
	}

	private void makeSheetMutByGeneSet(OmicsDataVO omicsVO, String title) throws Exception {
		OmicsDataUtils.makeUserGeneList(omicsVO);
		omicsVO.setGeneList(omicsVO.getUserGeneList());
		omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));

		OmicsDataUtils.makeSheetMut(omicsVO, title, survivalAdditionalRowService.selectByType("mut"));
	}

	@RequestMapping(value = "/mo/third/survival/read_omics_s.do")
	@ResponseBody
	public AjaxResult read_omics_s(@ModelAttribute("searchVO") mo_studyVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			mo_studyVO stdVO = studyService.selectStudyByIdx(searchVO.getStd_idx());
			OmicsDataVO omicsVO = restoreOmicsDataByStudy(searchVO.getStd_idx(), searchVO.getOmicsType());
			stdVO.setOmicsType(searchVO.getOmicsType());

			List<SurvivalAdditionalRow> functions = survivalAdditionalRowService.selectByType(omicsVO.getSurvOmicsType1());
			omicsVO.setFunctions(functions);

			switch (omicsVO.getSurvOmicsType1()) {
			case "exp":
				if ("A".equals(omicsVO.getStd_type())) {
					makeSheetExpByAnalysis(omicsVO);
				} else if ("G".equals(omicsVO.getStd_type())) {
					makeSheetExpByGeneSet(omicsVO, omicsVO.getStd_title());
				}
				break;

			case "meth":
				if ("A".equals(omicsVO.getStd_type())) {
					makeSheetMethByAnalysis(omicsVO);
				} else if ("G".equals(omicsVO.getStd_type())) {
					makeSheetMethByGeneSet(omicsVO, omicsVO.getStd_title());
				}
				break;

			case "mut":
				if ("A".equals(omicsVO.getStd_type())) {
					makeSheetMutByAnalysis(omicsVO);
				} else if ("G".equals(omicsVO.getStd_type())) {
					makeSheetMutByGeneSet(omicsVO, omicsVO.getStd_title());
				}
				break;

			default:
				break;

			}

			Map<String, Object> data = new HashMap<String, Object>();
			data.put("stdVO", stdVO);
			data.put("omicsVO", omicsVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(data);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/third/survival/read_omics_w.do")
	@ResponseBody
	public AjaxResult read_omics_w(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			mo_studyVO stdVO = OmicsDataUtils.toStudyVO(searchVO);
			stdVO.setOmicsType(searchVO.getSurvOmicsType1());
			String survOmicsType = searchVO.getSurvOmicsType1();

			List<SurvivalAdditionalRow> functions = survivalAdditionalRowService.selectByType(survOmicsType);
			searchVO.setFunctions(functions);

			OmicsDataUtils.makeSampleID(searchVO);

			if ("2".equals(searchVO.getSearchTmp())) {
				survOmicsType = searchVO.getSurvOmicsType2();
			}

			switch (survOmicsType) {
			case "exp":
				makeSheetExpByGeneSet(searchVO, OmicsNewType.Expression.name());
				break;

			case "meth":
				makeSheetMethByGeneSet(searchVO, OmicsNewType.Methylation.name());
				break;

			case "mut":
				makeSheetMutByGeneSet(searchVO, OmicsNewType.Mutation.name());
				break;

			default:
				break;

			}

			Map<String, Object> data = new HashMap<String, Object>();
			data.put("stdVO", stdVO);
			data.put("omicsVO", searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(data);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/third/survival/presurv_action.do")
	@ResponseBody
	public AjaxResult presurv_action(@RequestBody List<SurvivalAdditionalRow> vos, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			if (vos != null && vos.size() > 0) {

				Integer std_idx = vos.get(0).getStd_idx();
				Integer group = vos.get(0).getGroup();
				mo_studyVO stdVO = studyService.selectStudyByIdx(std_idx);
				OmicsDataVO omicsVO = OmicsDataUtils.parseSaved(stdVO);
				OmicsDataUtils.makeSurvNewUserInputFile(omicsVO, vos, group);

				resMap.setRes("ok");
				resMap.setMsg("Task completed.");
			}

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/third/survival/presurv_action2.do")
	@ResponseBody
	public AjaxResult presurv_action2(@RequestBody SurvivalAdditionalRow vo, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

	@RequestMapping(value = "/mo/third/survival/popup/surv.do")
	public String pop_surv(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/third/survival/popup/surv";
	}

	@RequestMapping(value = "/mo/third/survival/popup/surv_ajax.do")
	@ResponseBody
	public AjaxResult surv_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {
			printParameter(request);
			OmicsDataUtils.makeDirectory(searchVO);
			OmicsDataVO omicsVO = null;
			if ("S".equals(searchVO.getStd_status())) {
				if ("G".equals(searchVO.getStd_type())) {
					mo_studyVO stdVO = studyService.selectStudyByIdx(searchVO.getStd_idx());
					OmicsDataVO restoreVO = OmicsDataUtils.parseSaved(stdVO);

					if ("1".equals(searchVO.getSurvGroup12())) {
						omicsVO = getSurvKMDataG(restoreVO, searchVO);
					} else if ("2".equals(searchVO.getSurvGroup12())) {
						omicsVO = getSurvKMDataG2(restoreVO, searchVO);
					}
				} else if ("A".equals(searchVO.getStd_type())) {
					if ("1".equals(searchVO.getSurvGroup12())) {
						omicsVO = getSurvKMData(searchVO);
					} else if ("2".equals(searchVO.getSurvGroup12())) {
						omicsVO = getSurvKMData2(searchVO);
					}
				}
			} else if ("W".equals(searchVO.getStd_status())) {
				OmicsDataUtils.makeSampleID(searchVO);
				if ("1".equals(searchVO.getSurvGroup12())) {
					omicsVO = getSurvKMDataG(searchVO, searchVO);
				} else if ("2".equals(searchVO.getSurvGroup12())) {
					omicsVO = getSurvKMDataG2(searchVO, searchVO);
				}
			}

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(omicsVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;
	}

	private void printParameter(HttpServletRequest request) {
		StringBuffer sb1 = new StringBuffer();
		Enumeration<?> enumeration = request.getParameterNames();
		while (enumeration.hasMoreElements()) {
			String parameterName = (String) enumeration.nextElement();
			sb1.append(parameterName + " : " + request.getParameter(parameterName) + "\n");
		}
		logger.error("", sb1.toString());

	}

	private OmicsDataVO restoreOmicsDataByStudy(int std_idx, String omicsType) throws Exception {
		mo_studyVO stdVO = studyService.selectStudyByIdx(std_idx);
		OmicsDataVO omicsVO = OmicsDataUtils.parseSaved(stdVO);
		omicsVO.setSurvOmicsType1(omicsType);
		return omicsVO;
	}

	@SuppressWarnings("unchecked")
	private OmicsDataVO getSurvKMData(OmicsDataVO searchVO) throws Exception {

		OmicsDataVO omicsVO = restoreOmicsDataByStudy(searchVO.getStd_idx(), searchVO.getSurvOmicsType1());

		Object clinicList = null;
		if (searchVO.getUd_idx() == 2) {
			clinicList = clinic2Service.selectClinicD2ListBySample(omicsVO);
			OmicsDataUtils.makeClinicFileD2(omicsVO, (List<mo_clinicalD2VO>) clinicList);
		} else {
			clinicList = clinic2Service.selectClinicListBySample(omicsVO);
			OmicsDataUtils.makeClinicFile(omicsVO, (List<mo_clinicalVO>) clinicList);
		}

		switch (omicsVO.getSurvOmicsType1()) {
		case "exp":
			OmicsDataUtils.parseDegResult(omicsVO);
			omicsVO.setGeneList(omicsVO.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
			omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));
			OmicsDataUtils.makeSurvNewExpInputFile(omicsVO);
			break;

		case "meth":
			OmicsDataUtils.parseDmpResult(omicsVO);
			omicsVO.setProbeList(omicsVO.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList()));
			omicsVO.setMethList(omicsService.selectMethListForHeatmap(omicsVO));
			OmicsDataUtils.makeGeneProbeList(omicsVO);
			OmicsDataUtils.makeSurvNewMethInputFile(omicsVO);

			break;

		case "mut":
			omicsVO.setGeneList(omicsService.selectMutGeneListLimit(omicsVO));
			omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));
			OmicsDataUtils.makeSurvNewMutInputFile(omicsVO);
			break;

		default:
			break;

		}

		searchVO.setWs_idx(omicsVO.getWs_idx());
		searchVO.setWp_idx(omicsVO.getWp_idx());

		if (!Globals.IS_LOCAL) {

			if ("PC".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew01PC(searchVO);

			} else if ("RS".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew02RS(searchVO);

			} else if ("SG".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew03SG(searchVO);

			} else if ("UF".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew05UF(searchVO);

			}
		}

		if ("PC".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew01PCDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 1);

		} else if ("RS".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew02RSDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 2);

		} else if ("SG".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew03SGDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 3);

		} else if ("UF".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew05UFDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 5);
		}

		if (searchVO.getUd_idx() == 2) {
			OmicsDataUtils.makeSurvNewDataD2(omicsVO, (List<mo_clinicalD2VO>) clinicList);
		} else {
			OmicsDataUtils.makeSurvNewData(omicsVO, (List<mo_clinicalVO>) clinicList);

		}

		return omicsVO;
	}

	private OmicsDataVO getSurvKMData2(OmicsDataVO searchVO) throws Exception {

		OmicsDataVO omicsVO1 = restoreOmicsDataByStudy(searchVO.getStd_idx(), searchVO.getSurvOmicsType1());
		OmicsDataVO omicsVO2 = restoreOmicsDataByStudy(searchVO.getStd_idx2(), searchVO.getSurvOmicsType2());

		searchVO.setWs_idx(omicsVO1.getWs_idx());
		searchVO.setWp_idx(omicsVO1.getWp_idx());

		System.out.println("======clinicList======");
		// 공통 clinic file

		Object clinicList = null;
		if (searchVO.getUd_idx() == 2) {
			clinicList = clinic2Service.selectClinicD2ListBySample(omicsVO1);
			OmicsDataUtils.makeClinicFileD2(omicsVO1, (List<mo_clinicalD2VO>) clinicList);
		} else {
			clinicList = clinic2Service.selectClinicListBySample(omicsVO1);
			OmicsDataUtils.makeClinicFile(omicsVO1, (List<mo_clinicalVO>) clinicList);
		}

		switch (omicsVO1.getSurvOmicsType1()) {
		case "exp":
			OmicsDataUtils.parseDegResult(omicsVO1);
			omicsVO1.setGeneList(omicsVO1.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
			omicsVO1.setExpList(omicsService.selectExpTpmList(omicsVO1));
			OmicsDataUtils.makeSurvNewExpInputFile(omicsVO1);
			break;

		case "meth":
			OmicsDataUtils.parseDmpResult(omicsVO1);
			omicsVO1.setProbeList(omicsVO1.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList()));
			omicsVO1.setMethList(omicsService.selectMethListForHeatmap(omicsVO1));
			OmicsDataUtils.makeGeneProbeList(omicsVO1);
			OmicsDataUtils.makeSurvNewMethInputFile(omicsVO1);
			break;

		case "mut":
			omicsVO1.setGeneList(omicsService.selectMutGeneListLimit(omicsVO1));
			omicsVO1.setMutList(omicsService.selectMutSnvList(omicsVO1));
			OmicsDataUtils.makeSurvNewMutInputFile(omicsVO1);
			break;

		default:
			break;

		}

		switch (omicsVO2.getSurvOmicsType1()) {
		case "exp":
			OmicsDataUtils.parseDegResult(omicsVO2);
			omicsVO2.setGeneList(omicsVO2.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
			omicsVO2.setExpList(omicsService.selectExpTpmList(omicsVO2));
			OmicsDataUtils.makeSurvNewExpInputFile(omicsVO2, true);
			break;

		case "meth":
			OmicsDataUtils.parseDmpResult(omicsVO2);
			omicsVO2.setProbeList(omicsVO2.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList()));
			omicsVO2.setMethList(omicsService.selectMethListForHeatmap(omicsVO2));
			OmicsDataUtils.makeGeneProbeList(omicsVO2);
			OmicsDataUtils.makeSurvNewMethInputFile(omicsVO2, true);
			break;

		case "mut":
			omicsVO2.setGeneList(omicsService.selectMutGeneListLimit(omicsVO2));
			omicsVO2.setMutList(omicsService.selectMutSnvList(omicsVO2));
			OmicsDataUtils.makeSurvNewMutInputFile(omicsVO2, true);
			break;

		default:
			break;

		}

		if (!Globals.IS_LOCAL) {
			OmicsDataUtils.excuteSurvNew04TD(searchVO);

		}

		OmicsDataUtils.parseSurvNew04TGDatzFile(omicsVO1);
		OmicsDataUtils.parseSurvNewSTableFile(omicsVO1, 4);
		if (searchVO.getUd_idx() == 2) {
			OmicsDataUtils.makeSurvNewDataD2(omicsVO1, (List<mo_clinicalD2VO>) clinicList);
		} else {
			OmicsDataUtils.makeSurvNewData(omicsVO1, (List<mo_clinicalVO>) clinicList);
		}

		return omicsVO1;
	}

	@SuppressWarnings("unchecked")
	private OmicsDataVO getSurvKMDataG(OmicsDataVO omicsVO, OmicsDataVO searchVO) throws Exception {

		String survOmicsType = searchVO.getSurvOmicsType1();

		switch (survOmicsType) {
		case "exp":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));
			OmicsDataUtils.makeSurvNewExpInputFile(omicsVO);
			break;

		case "meth":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMethList(omicsService.selectMethListByGene(omicsVO));
			OmicsDataUtils.makeGeneProbeList(omicsVO);
			OmicsDataUtils.makeSurvNewMethInputFile(omicsVO);

			break;

		case "mut":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));
			OmicsDataUtils.makeSurvNewMutInputFile(omicsVO);
			break;

		default:
			break;

		}

		omicsVO.setWs_idx(omicsVO.getWs_idx());
		omicsVO.setWp_idx(omicsVO.getWp_idx());

		Object clinicList = null;
		if (searchVO.getUd_idx() == 2) {
			clinicList = clinic2Service.selectClinicD2ListBySample(omicsVO);
			OmicsDataUtils.makeClinicFileD2(omicsVO, (List<mo_clinicalD2VO>) clinicList);
		} else {
			clinicList = clinic2Service.selectClinicListBySample(omicsVO);
			OmicsDataUtils.makeClinicFile(omicsVO, (List<mo_clinicalVO>) clinicList);
		}

		if (!Globals.IS_LOCAL) {

			if ("PC".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew01PC(searchVO);

			} else if ("RS".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew02RS(searchVO);

			} else if ("SG".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew03SG(searchVO);

			} else if ("UF".equals(searchVO.getSurvTool1())) {
				OmicsDataUtils.excuteSurvNew05UF(searchVO);

			}
		}

		if ("PC".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew01PCDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 1);

		} else if ("RS".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew02RSDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 2);

		} else if ("SG".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew03SGDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 3);

		} else if ("UF".equals(searchVO.getSurvTool1())) {
			OmicsDataUtils.parseSurvNew05UFDatzFile(omicsVO);
			OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 5);

		}

		if (searchVO.getUd_idx() == 2) {
			OmicsDataUtils.makeSurvNewDataD2(omicsVO, (List<mo_clinicalD2VO>) clinicList);
		} else {
			OmicsDataUtils.makeSurvNewData(omicsVO, (List<mo_clinicalVO>) clinicList);
		}

		return omicsVO;
	}

	@SuppressWarnings("unchecked")
	private OmicsDataVO getSurvKMDataG2(OmicsDataVO omicsVO, OmicsDataVO searchVO) throws Exception {
		Object clinicList = null;
		if (searchVO.getUd_idx() == 2) {
			clinicList = clinic2Service.selectClinicD2ListBySample(omicsVO);
			OmicsDataUtils.makeClinicFileD2(omicsVO, (List<mo_clinicalD2VO>) clinicList);
		} else {
			clinicList = clinic2Service.selectClinicListBySample(omicsVO);
			OmicsDataUtils.makeClinicFile(omicsVO, (List<mo_clinicalVO>) clinicList);
		}

		switch (searchVO.getSurvOmicsType1()) {
		case "exp":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));
			OmicsDataUtils.makeSurvNewExpInputFile(omicsVO);
			break;

		case "meth":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMethList(omicsService.selectMethListByGene(omicsVO));
			OmicsDataUtils.makeGeneProbeList(omicsVO);
			OmicsDataUtils.makeSurvNewMethInputFile(omicsVO);

			break;

		case "mut":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));
			OmicsDataUtils.makeSurvNewMutInputFile(omicsVO);
			break;

		default:
			break;

		}

		switch (searchVO.getSurvOmicsType2()) {
		case "exp":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));
			OmicsDataUtils.makeSurvNewExpInputFile(omicsVO, true);
			break;

		case "meth":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMethList(omicsService.selectMethListByGene(omicsVO));
			OmicsDataUtils.makeGeneProbeList(omicsVO);
			OmicsDataUtils.makeSurvNewMethInputFile(omicsVO, true);

			break;

		case "mut":
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));

			OmicsDataUtils.makeSurvNewMutInputFile(omicsVO, true);
			break;

		default:
			break;

		}

		if (!Globals.IS_LOCAL) {
			OmicsDataUtils.excuteSurvNew04TD(searchVO);
		}

		OmicsDataUtils.parseSurvNew04TGDatzFile(omicsVO);
		OmicsDataUtils.parseSurvNewSTableFile(omicsVO, 4);
		if (searchVO.getUd_idx() == 2) {
			OmicsDataUtils.makeSurvNewDataD2(omicsVO, (List<mo_clinicalD2VO>) clinicList);
		} else {
			OmicsDataUtils.makeSurvNewData(omicsVO, (List<mo_clinicalVO>) clinicList);
		}

		return omicsVO;
	}

	@RequestMapping(value = "/mo/third/survival/excel_write_function.do")
	@ResponseBody
	public AjaxResult excel_write_function(@RequestBody List<SurvivalAdditionalRow> vos, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			if (vos != null && vos.size() > 0) {
				survivalAdditionalRowService.deleteByType(vos.get(0).getListType());
				for (SurvivalAdditionalRow vo : vos) {
					survivalAdditionalRowService.save(vo);
				}
			}

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;
	}

}
