package com.bsite.mo.basic.web;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.crc.clinic2.service.Clinic2Service;
import com.adms.mo.visual.service.OmicsDataUtils;
import com.adms.mo.visual.service.OmicsService;
import com.adms.mo.visual.service.WorkPresetService;
import com.adms.mo.visual.service.WorkspaceService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.mo.basic.service.EntrezService;
import com.bsite.mo.basic.service.MethylationService;
import com.bsite.mo.basic.service.VariantBedFileService;
import com.bsite.mo.basic.service.VariantService;
import com.bsite.mo.visual.service.StudyService;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.DegResultVO;
import com.bsite.vo.HtPrimerVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.OmicsType;
import com.bsite.vo.VarPrimerVO;
import com.bsite.vo.VariantRecordVO;
import com.bsite.vo.VolcanoPlotVO;
import com.bsite.vo.mo_clinicalD2VO;
import com.bsite.vo.mo_clinicalVO;
import com.bsite.vo.mo_entrezVO;
import com.bsite.vo.mo_studyVO;
import com.bsite.vo.mo_work_presetVO;
import com.bsite.vo.variant.VariantBEDFileVO;
import com.bsite.vo.variant.VariantBlockerResultVO;
import com.bsite.vo.variant.VariantPrimerResultVO;
import com.bsite.vo.variant.VariantProbeResultVO;

import egovframework.com.cmm.service.Globals;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class BasicController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	private static SimpleDateFormat fileNameFormat = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "OmicsService")
	private OmicsService omicsService;

	@Resource(name = "WorkspaceService")
	private WorkspaceService wsService;

	@Resource(name = "WorkPresetService")
	private WorkPresetService wpService;

	@Resource(name = "StudyService")
	private StudyService studyService;

	@Resource(name = "Clinic2Service")
	private Clinic2Service clinic2Service;

	@Resource(name = "MethylationService")
	private MethylationService methylationService;

	@Resource(name = "VariantService")
	private VariantService variantService;

	@Resource(name = "VariantBedFileService")
	private VariantBedFileService variantBedFileService;

	@Resource(name = "EntrezService")
	private EntrezService entrezService;

	@RequestMapping(value = "/mo/basic/list3.do")
	public String list3(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		CommonFunctions.printParameter(request);
		return "tiles:bsite/mo/clinic/list";
	}

	@RequestMapping(value = "/mo/basic/save_preset.do")
	public String save_preset(OmicsDataVO searchVO, RedirectAttributes redirectAttributes, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			LoginVO loginVO = loginService.getLoginInfo();
			searchVO.setMe_idx(loginVO.getIdx());

			mo_work_presetVO vo = OmicsDataUtils.toPreset_old(searchVO);
			vo.setMe_idx(loginVO.getIdx());
			vo.setModi_id(loginVO.getId());
			vo.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			wpService.updateWorkPreset(vo);

			redirectAttributes.addFlashAttribute("searchVO", searchVO);
		} catch (Exception e) {
			logger.error("", e);
		}
		return "redirect:/mo/visual/list.do";
	}

	@RequestMapping(value = "/mo/basic/create_study.do")
	@ResponseBody
	public AjaxResult create_study(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		LoginVO loginVO = loginService.getLoginInfo();

		try {
			session.setAttribute("grp1", searchVO.getGrp1());
			session.setAttribute("grp2", searchVO.getGrp2());

			mo_studyVO studyVO = new mo_studyVO();
			studyVO.setUd_idx(searchVO.getUd_idx());
			studyVO.setMe_idx(loginVO.getIdx());
			studyVO.setSite_code(loginService.getSiteCode());
			studyVO.setCret_id(loginVO.getId());
			studyVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			studyService.createStudy(studyVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(studyVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/list.do")
	public String list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {
			OmicsDataUtils.makeSampleID(searchVO);

			if (Globals.IS_LOCAL) {
				if (searchVO.getUd_idx() == 2) {
					searchVO.setStd_idx(336);
				} else {
					searchVO.setStd_idx(0);
				}

			}

			OmicsDataUtils.makeSampleID(searchVO);

			// expression tpm grid
			OmicsDataVO expGridTpmVO = new OmicsDataVO();
			expGridTpmVO.setUd_idx(searchVO.getUd_idx());
			expGridTpmVO.setType(OmicsType.Expression);
			OmicsDataUtils.makeSampleID(expGridTpmVO, searchVO);
			expGridTpmVO.setGeneList(omicsService.selectGeneExpTpmList100(expGridTpmVO));
			expGridTpmVO.setExpList(omicsService.selectExpTpmList(expGridTpmVO));
			OmicsDataUtils.makeGridProperties(expGridTpmVO);
			model.addAttribute("expGridTpmVO", expGridTpmVO);

			// expression count grid
			OmicsDataVO expGridCntVO = new OmicsDataVO();
			expGridCntVO.setUd_idx(searchVO.getUd_idx());
			expGridCntVO.setType(OmicsType.Expression);
			OmicsDataUtils.makeSampleID(expGridCntVO, searchVO);
			expGridCntVO.setGeneList(omicsService.selectGeneExpCntList100(expGridCntVO));
			expGridCntVO.setExpList(omicsService.selectExpCntList(expGridCntVO));
			OmicsDataUtils.makeGridProperties(expGridCntVO);
			model.addAttribute("expGridCntVO", expGridCntVO);

			// methylation
			OmicsDataVO methGridVO = new OmicsDataVO();
			methGridVO.setUd_idx(searchVO.getUd_idx());
			methGridVO.setType(OmicsType.Methylation);
			OmicsDataUtils.makeSampleID(methGridVO, searchVO);
			methGridVO.setMethList(omicsService.selectMethList100(methGridVO));
			OmicsDataUtils.makeGeneProbeList(methGridVO);
			OmicsDataUtils.makeGridProperties(methGridVO);
			model.addAttribute("methGridVO", methGridVO);

			// variant SNV
			OmicsDataVO mutSnvGridVO = new OmicsDataVO();
			mutSnvGridVO.setUd_idx(searchVO.getUd_idx());
			mutSnvGridVO.setType(OmicsType.MutationSnv);
			OmicsDataUtils.makeSampleID(mutSnvGridVO, searchVO);
			mutSnvGridVO.setGeneList(omicsService.selectMutSnvGeneList100(mutSnvGridVO));
			mutSnvGridVO.setMutList(omicsService.selectMutSnvList(mutSnvGridVO));
			OmicsDataUtils.makeGridProperties(mutSnvGridVO);
			model.addAttribute("mutSnvGridVO", mutSnvGridVO);

			// variant INDEL
			OmicsDataVO mutIndelGridVO = new OmicsDataVO();
			mutIndelGridVO.setUd_idx(searchVO.getUd_idx());
			mutIndelGridVO.setType(OmicsType.MutationIndel);
			OmicsDataUtils.makeSampleID(mutIndelGridVO, searchVO);
			mutIndelGridVO.setGeneList(omicsService.selectMutIndelGeneList100(mutIndelGridVO));
			mutIndelGridVO.setMutList(omicsService.selectMutIndelList(mutIndelGridVO));
			OmicsDataUtils.makeGridProperties(mutIndelGridVO);
			model.addAttribute("mutIndelGridVO", mutIndelGridVO);

			model.addAttribute("degAdjPValue", OmicsDataUtils.DEG_ADJ_PVALUE);
			model.addAttribute("degPValue", OmicsDataUtils.DEG_PVALUE);
			model.addAttribute("degLog2FC", OmicsDataUtils.DEG_LOG2FC);
			model.addAttribute("dmpAdjPValue", OmicsDataUtils.DMP_ADJ_PVALUE);
			model.addAttribute("dmpPValue", OmicsDataUtils.DMP_PVALUE);
			model.addAttribute("dmpLog2FC", OmicsDataUtils.DMP_LOG2FC);
			model.addAttribute("isLocal", Globals.IS_LOCAL);
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/basic/list";
	}

	private void composeExpHeatmapData(OmicsDataVO vo) throws Exception {
		List<String> geneList = vo.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList());
		List<String> sampleList = vo.getSampleList();

		vo.setSampleList(sampleList);
		vo.setGeneList(geneList);
		vo.setExpList(omicsService.selectExpTpmList(vo));

		if (!Globals.IS_LOCAL) {
			if (!OmicsDataUtils.isExistsZscore(vo)) {
				OmicsDataUtils.makeZscoreInputFile(vo);
				OmicsDataUtils.excuteZscore(vo);
			}
		}
		OmicsDataUtils.parseZscore(vo);

		vo.setHeatmapDataList(OmicsDataUtils.createHeatmapData(vo));
	}

	private void composeExpHeatmapDataByGenes(OmicsDataVO vo) throws Exception {
		vo.setGeneList(vo.getUserGeneList());

		vo.setExpList(omicsService.selectExpTpmList(vo));

		if (!Globals.IS_LOCAL) {
			if (!OmicsDataUtils.isExistsZscore(vo)) {
				OmicsDataUtils.makeZscoreInputFile(vo);
				OmicsDataUtils.excuteZscore(vo);
			}
		}
		OmicsDataUtils.parseZscore(vo);

		vo.setHeatmapDataList(OmicsDataUtils.createHeatmapData(vo));
	}

	private void composeMethHeatmapData(OmicsDataVO vo) throws Exception {
		List<String> probeList = vo.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList());
		List<String> sampleList = vo.getSampleList();

		vo.setSampleList(sampleList);
		vo.setProbeList(probeList);

		if (probeList.size() > 0)
			vo.setMethList(omicsService.selectMethListForHeatmap(vo));
		OmicsDataUtils.makeGeneProbeList(vo);
		OmicsDataUtils.makeGeneListByGeneProbe(vo);

		vo.setHeatmapDataList(OmicsDataUtils.createHeatmapData(vo));
	}

	private void composeMethHeatmapDataByGenes(OmicsDataVO vo) throws Exception {
		vo.setGeneList(vo.getUserGeneList());
		vo.setMethList(omicsService.selectMethListByGene(vo));
		OmicsDataUtils.makeGeneProbeList(vo);

		vo.setHeatmapDataList(OmicsDataUtils.createHeatmapData(vo));
	}

	@RequestMapping(value = "/mo/basic/dmp_start.do")
	@ResponseBody
	public AjaxResult dmp_start_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				switch (searchVO.getDmpType()) {
				case ChAMP:
					OmicsDataUtils.mergeDmp(searchVO);
					OmicsDataUtils.excuteDmp(searchVO);
					break;
				case DmpFinder:
					OmicsDataUtils.mergeDmpFinder(searchVO);
					OmicsDataUtils.excuteDmpFinder(searchVO);
					break;
				}
			}
			switch (searchVO.getDmpType()) {
			case ChAMP:
				OmicsDataUtils.parseDmpResultAll(searchVO);
				OmicsDataUtils.countDmpResult(searchVO);
				break;
			case DmpFinder:
				OmicsDataUtils.parseDmpFinderResultAll(searchVO);
				OmicsDataUtils.countDmpFinderResult(searchVO);
				break;
			}

			searchVO.setDmpList(null);
			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/dmp_filter.do")
	@ResponseBody
	public AjaxResult dmp_filter_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			searchVO.setType(OmicsType.Methylation);
			OmicsDataUtils.makeSampleID(searchVO);

			switch (searchVO.getGeneSetType()) {
			case Single_Omics_Analysis:
				switch (searchVO.getDmpType()) {
				case ChAMP:
					OmicsDataUtils.parseDmpResult(searchVO);
					composeMethHeatmapData(searchVO);
					break;

				case DmpFinder:
					OmicsDataUtils.parseDmpFinderResult(searchVO);
					composeMethHeatmapData(searchVO);
					break;
				}
				break;

			case Add_Gene_Set:
				OmicsDataUtils.makeUserGeneList(searchVO);
				composeMethHeatmapDataByGenes(searchVO);
				break;

			case None:
				break;

			default:
				break;
			}

			resMap.setRes("ok");
			resMap.setMsg("데이터를 수신하였습니다.");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/deg_start.do")
	@ResponseBody
	public AjaxResult deg_start_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				switch (searchVO.getDegType()) {
				case EdgeR:
					OmicsDataUtils.mergeExpCnt(searchVO);
					OmicsDataUtils.excuteDeg(searchVO);
					break;
				case DESeq2:
					OmicsDataUtils.mergeExpCntDeSeq2(searchVO);
					OmicsDataUtils.excuteDeSeq2(searchVO);
					break;
				}
			}

			switch (searchVO.getDegType()) {
			case EdgeR:
				OmicsDataUtils.parseDegResultAll(searchVO);
				OmicsDataUtils.countDegResult(searchVO);
				break;
			case DESeq2:
				OmicsDataUtils.parseDeSeq2ResultAll(searchVO);
				OmicsDataUtils.countDeSeq2Result(searchVO);
				break;
			}

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/deg_filter.do")
	@ResponseBody
	public AjaxResult deg_filter_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);

			System.out.println("deg_filter_ajax");
			System.out.println("getGeneSetType()" + searchVO.getGeneSetType());

			switch (searchVO.getGeneSetType()) {
			case Single_Omics_Analysis:
				switch (searchVO.getDegType()) {
				case EdgeR:
					OmicsDataUtils.parseDegResult(searchVO);
					composeExpHeatmapData(searchVO);
					break;
				case DESeq2:
					OmicsDataUtils.parseDeSeq2Result(searchVO);
					composeExpHeatmapData(searchVO);
					break;
				}
				break;
			case Add_Gene_Set:
				OmicsDataUtils.makeUserGeneList(searchVO);
				composeExpHeatmapDataByGenes(searchVO);
				break;
			}

			resMap.setRes("ok");
			resMap.setMsg("데이터를 수신하였습니다.");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/mut_exc.do")
	@ResponseBody
	public AjaxResult mut_exc(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);

			switch (searchVO.getGeneSetType()) {
			case Single_Omics_Analysis:
				searchVO.setGeneList(omicsService.selectMutGeneListLimit(searchVO));
				break;
			case Add_Gene_Set:
				OmicsDataUtils.makeUserGeneList(searchVO);
				searchVO.setGeneList(searchVO.getUserGeneList());
				break;
			}
			
			searchVO.setExpList(omicsService.selectExpTpmList(searchVO));
			searchVO.setMutList(omicsService.selectMutSnvList(searchVO));

			searchVO.setHeatmapDataList(OmicsDataUtils.createHeatmapData(searchVO));

			searchVO.setType(OmicsType.MutationSnv);
			List<List<String>> oncoprintMUT = OmicsDataUtils.createHeatmapData4(searchVO);
			searchVO.setHeatmapData4List(oncoprintMUT);

			searchVO.setMutList(omicsService.selectMutIndelList(searchVO));
			searchVO.setType(OmicsType.MutationIndel);
			List<List<String>> oncoprintCNA = OmicsDataUtils.createHeatmapData4(searchVO);
			searchVO.setHeatmapData3List(oncoprintCNA);

			resMap.setRes("ok");
			resMap.setMsg("received data");
			resMap.setData(searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/pca_start.do")
	@ResponseBody
	public AjaxResult pca_start_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				OmicsDataUtils.mergeExpTpmForPca(searchVO);
				OmicsDataUtils.excutePca(searchVO);
			}

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/popup/pca.do")
	public String pop_pca(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			OmicsDataUtils.parsePcaResult(searchVO);
			searchVO.setGeneList(searchVO.getPcaList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
			OmicsDataUtils.makePcaPlotData(searchVO);

			model.addAttribute("vo", JSONObject.fromObject(searchVO));
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/pca";
	}

	@RequestMapping(value = "/mo/basic/popup/pca_sample.do")
	public String pop_pca_sample(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		return "tilespopup:bsite/mo/basic/popup/pca_sample";
	}

	@RequestMapping(value = "/mo/basic/pca_meth_start.do")
	@ResponseBody
	public AjaxResult pca_meth_start_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);

			if (!Globals.IS_LOCAL) {
				OmicsDataUtils.mergePcaMeth(searchVO);
				OmicsDataUtils.excutePcaMeth(searchVO);
			}

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/popup/pca_meth.do")
	public String pop_pca_meth(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			OmicsDataUtils.parsePcaMethResult(searchVO);
			searchVO.setGeneList(searchVO.getPcaList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
			OmicsDataUtils.makePcaPlotData(searchVO);

			model.addAttribute("vo", JSONObject.fromObject(searchVO));
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/pca_meth";
	}

	@RequestMapping(value = "/mo/basic/dmp_heat_sample.do")
	@ResponseBody
	public OmicsDataVO dmp_heat_sample_ajax(HttpServletRequest request, ModelMap model) throws Exception {

		OmicsDataVO expHeatmapTpmVO = new OmicsDataVO();
		try {

			// expression tpm heatmap
			String[] degArray = { "CALCB", "APOA4", "DAZ2", "DAZ4", "LIN28B", "SPINK6", "LCT", "ZNF679", "BPIFB2", "5_8S_rRNA", "RNA5-8SN1", "RNA5-8SN2", "RNA5-8SN3", "CSAG2",
					"PIK3C2G", "DAZ1", "LINC02735", "CCDC190", "SPINK13", "BPIFB1", "SLC10A2", "LINC02404", "MAGEC2", "ZIC1", "FAM9C", "A2ML1", "NNAT", "AC012085.2", "SLC26A9",
					"AC079313.2", "MARCOL", "KCNC2", "APOA1", "AHSG", "MORN5", "STRIT1", "CLDN6", "XAGE2", "IGFL1", "GJB6", "ANXA10", "APOA2", "ITIH2", "CCK", "PAGE1", "CYP7A1",
					"MAGEA9", "SLC6A10P", "MAEL", "TMEM213", "DGKB", "OBP2B", "KLK5", "MSMB", "GNAT3", "BEX1", "S100A2", "EPHA8", "IGKV2-29", "KRT13", "TRHDE-AS1", "TEX19",
					"ITLN2", "MIA", "DEFA5", "AC136628.4", "ALB", "UGT2B17", "ASB5", "TEX15", "ANKRD30BP1", "UPK1B" };
			List<String> degGeneList = Arrays.asList(degArray);

			String[] degSampleArray = { "PM-AA-0055-T", "PM-AA-0057-T", "PM-AA-0062-T", "PM-AA-0063-T", "PM-AA-0065-T", "PM-AU-0005-T", "PM-AU-0045-T", "PM-AU-0052-T",
					"PM-AU-0059-T", "PM-AU-0060-T", "PM-PB-1059-T", "PM-PB-1060-T", "PM-PB-1061-T", "PM-PB-1063-T", "PM-PB-1065-T", "PM-PB-1066-T", "PM-PB-1068-T", "PM-PB-1069-T",
					"PM-PB-1072-T", "PM-PB-1084-T", "PM-PB-1086-T", "PM-PB-1088-T", "PM-PB-1093-T", "PM-PB-1100-T", "PM-PB-1109-T", "PM-PB-1115-T", "PM-PB-1116-T", "PM-PB-1117-T",
					"PM-PB-1120-T", "PM-PB-1121-T", "PM-PB-1123-T", "PM-PB-1126-T", "PM-PB-1132-T", "PM-PB-1142-T", "PM-PB-1143-T", "PM-PB-1146-T", "PM-PB-1149-T", "PM-PB-1152-T",
					"PM-PB-1153-T", "PM-PB-1157-T", "PM-PB-1158-T", "PM-PB-1159-T", "PM-PM-1052-T", "PM-PM-1056-T", "PM-PM-1061-T", "PM-PM-1067-T", "PM-PM-1068-T", "PM-PM-1069-T",
					"PM-PM-1070-T", "PM-PM-1073-T", "PM-PS-0001-T", "PM-PS-0005-T", "PM-PS-0009-T", "PM-PS-0010-T", "PM-PS-0015-T", "PM-PS-0018-T", "PM-PS-0028-T", "PM-PS-0029-T",
					"PM-PS-0032-T", "PM-PS-0039-T", "PM-PS-0042-T", "PM-PS-0043-T", "PM-PS-0050-T", "PM-PS-0071-T", "PM-PS-0083-T", "PM-PS-0105-T", "PM-PS-0108-T", "PM-PS-0112-T",
					"PM-PS-0119-T", "PM-PS-0125-T", "PM-PS-0126-T", "PM-PS-0136-T", "PM-PS-0145-T", "PM-PS-0164-T", "PM-PS-0179-T", "PM-PS-0215-T", "PM-PU-1010-T", "PM-PU-1012-T",
					"PM-PU-1013-T", "PM-PU-1123-T", "PM-PU-1152-T", "PM-PU-1171-T", "PM-PU-1174-T", "PM-PU-1175-T", "PM-PU-1176-T", "PM-PU-1181-T", "PM-PU-1196-T", "PM-PU-1199-T",
					"PM-PU-1200-T", "PM-PU-1203-T", "PM-PU-1208-T", "PM-PA-1006-T", "PM-PA-1008-T", "PM-PA-1023-T", "PM-PA-1025-T", "PM-PA-1029-T", "PM-PA-1033-T", "PM-PA-1034-T",
					"PM-PA-1040-T", "PM-PB-1010-T", "PM-PB-1011-T", "PM-PB-1012-T", "PM-PB-1014-T", "PM-PB-1015-T", "PM-PB-1024-T", "PM-PB-1025-T", "PM-PB-1027-T", "PM-PB-1031-T",
					"PM-PB-1033-T", "PM-PB-1042-T", "PM-PM-1041-T", "PM-PM-1042-T", "PM-PM-1044-T", "PM-PU-1019-T", "PM-PU-1021-T", "PM-PU-1022-T", "PM-PU-1023-T", "PM-PU-1024-T",
					"PM-PU-1031-T", "PM-PU-1032-T", "PM-PU-1034-T", "PM-PU-1038-T", "PM-PU-1046-T", "PM-PU-1052-T", "PM-PU-1054-T", "PM-PU-1060-T", "PM-PU-1066-T", "PM-PU-1068-T",
					"PM-PU-1070-T", "PM-PU-1075-T", "PM-PU-1076-T", "PM-PU-1080-T", "PM-PU-1084-T", "PM-PU-1090-T", "PM-PU-1105-T", "PM-PU-1107-T", "PM-AA-0051-T", "PM-AA-0052-T",
					"PM-AA-0053-T", "PM-AA-0056-T", "PM-AA-0058-T", "PM-AA-0059-T", "PM-AA-0060-T", "PM-AA-0061-T", "PM-AA-0066-T", "PM-AS-0001-T", "PM-AS-0002-T", "PM-AS-0003-T",
					"PM-AS-0004-T", "PM-AS-0005-T", "PM-AS-0006-T", "PM-AS-0007-T", "PM-AS-0008-T", "PM-AS-0009-T", "PM-AS-0010-T", "PM-AS-0011-T", "PM-AS-0012-T", "PM-AS-0013-T",
					"PM-AS-0014-T", "PM-AS-0015-T", "PM-AS-0016-T", "PM-AS-0017-T", "PM-AS-0018-T", "PM-AS-0019-T", "PM-AS-0020-T", "PM-AS-0021-T", "PM-AS-0022-T", "PM-AS-0023-T",
					"PM-AS-0024-T", "PM-AS-0025-T", "PM-AS-0026-T", "PM-AS-0027-T", "PM-AS-0028-T", "PM-AS-0029-T", "PM-AS-0030-T", "PM-AS-0031-T", "PM-AS-0032-T", "PM-AS-0033-T",
					"PM-AS-0034-T", "PM-AS-0035-T", "PM-AS-0036-T", "PM-AS-0037-T", "PM-AS-0038-T", "PM-AS-0039-T", "PM-AS-0040-T", "PM-AS-0041-T", "PM-AS-0042-T", "PM-AS-0043-T",
					"PM-AS-0044-T", "PM-AS-0045-T", "PM-AS-0046-T", "PM-AS-0047-T", "PM-AS-0048-T", "PM-AS-0049-T", "PM-AS-0050-T", "PM-AU-0001-T", "PM-AU-0002-T", "PM-AU-0003-T",
					"PM-AU-0006-T", "PM-AU-0007-T", "PM-AU-0008-T", "PM-AU-0009-T", "PM-AU-0010-T", "PM-AU-0014-T", "PM-AU-0015-T", "PM-AU-0016-T", "PM-AU-0017-T", "PM-AU-0018-T",
					"PM-AU-0019-T", "PM-AU-0020-T", "PM-AU-0021-T", "PM-AU-0022-T", "PM-AU-0023-T", "PM-AU-0024-T", "PM-AU-0025-T", "PM-AU-0026-T", "PM-AU-0027-T", "PM-AU-0029-T",
					"PM-AU-0030-T", "PM-AU-0031-T", "PM-AU-0034-T", "PM-AU-0035-T", "PM-AU-0036-T", "PM-AU-0037-T", "PM-AU-0038-T", "PM-AU-0039-T", "PM-AU-0040-T", "PM-AU-0041-T",
					"PM-AU-0042-T", "PM-AU-0043-T", "PM-AU-0044-T", "PM-AU-0047-T", "PM-AU-0048-T", "PM-AU-0049-T", "PM-AU-0050-T", "PM-AU-0053-T", "PM-AU-0054-T", "PM-AU-0055-T",
					"PM-AU-0056-T", "PM-AU-0057-T", "PM-AU-0058-T", "PM-AU-0061-T", "PM-AU-0062-T", "PM-AU-0063-T", "PM-AU-0064-T", "PM-AU-0066-T", "PM-AU-0067-T", "PM-AU-0068-T",
					"PM-AU-0069-T", "PM-AU-0070-T", "PM-AU-0072-T", "PM-AU-0074-T", "PM-AU-0075-T", "PM-AU-0076-T", "PM-AU-0077-T", "PM-AU-0078-T", "PM-AU-0080-T", "PM-AU-0081-T",
					"PM-AU-0082-T", "PM-AU-0083-T", "PM-AU-0084-T", "PM-AU-0085-T", "PM-AU-0087-T", "PM-AU-0088-T", "PM-AU-0089-T", "PM-AU-0090-T", "PM-AU-0091-T", "PM-PB-1058-T",
					"PM-PB-1064-T", "PM-PB-1067-T", "PM-PB-1070-T", "PM-PB-1071-T", "PM-PB-1074-T", "PM-PB-1075-T", "PM-PB-1076-T", "PM-PB-1078-T", "PM-PB-1081-T", "PM-PB-1082-T",
					"PM-PB-1083-T", "PM-PB-1087-T", "PM-PB-1090-T", "PM-PB-1091-T", "PM-PB-1092-T", "PM-PB-1098-T", "PM-PB-1102-T", "PM-PB-1105-T", "PM-PB-1106-T", "PM-PB-1107-T",
					"PM-PB-1108-T", "PM-PB-1110-T", "PM-PB-1111-T", "PM-PB-1112-T", "PM-PB-1114-T", "PM-PB-1118-T", "PM-PB-1119-T", "PM-PB-1122-T", "PM-PB-1124-T", "PM-PB-1125-T",
					"PM-PB-1127-T", "PM-PB-1128-T", "PM-PB-1139-T", "PM-PB-1140-T", "PM-PB-1141-T", "PM-PB-1144-T", "PM-PB-1145-T", "PM-PB-1147-T", "PM-PB-1148-T", "PM-PB-1150-T",
					"PM-PB-1151-T", "PM-PB-1154-T", "PM-PB-1160-T", "PM-PM-1053-T", "PM-PM-1057-T", "PM-PM-1059-T", "PM-PM-1060-T", "PM-PM-1062-T", "PM-PM-1065-T", "PM-PM-1066-T",
					"PM-PM-1072-T", "PM-PM-1074-T", "PM-PS-0002-T", "PM-PS-0003-T", "PM-PS-0004-T", "PM-PS-0006-T", "PM-PS-0008-T", "PM-PS-0011-T", "PM-PS-0012-T", "PM-PS-0014-T",
					"PM-PS-0016-T", "PM-PS-0017-T", "PM-PS-0019-T", "PM-PS-0020-T", "PM-PS-0022-T", "PM-PS-0023-T", "PM-PS-0027-T", "PM-PS-0030-T", "PM-PS-0033-T", "PM-PS-0035-T",
					"PM-PS-0036-T", "PM-PS-0040-T", "PM-PS-0041-T", "PM-PS-0044-T", "PM-PS-0047-T", "PM-PS-0048-T", "PM-PS-0057-T", "PM-PS-0060-T", "PM-PS-0063-T", "PM-PS-0101-T",
					"PM-PS-0174-T", "PM-PS-0180-T", "PM-PS-0197-T", "PM-PS-0200-T", "PM-PS-0216-T", "PM-PS-0217-T", "PM-PS-0234-T", "PM-PU-1001-T", "PM-PU-1007-T", "PM-PU-1008-T",
					"PM-PU-1009-T", "PM-PU-1014-T", "PM-PU-1016-T", "PM-PU-1147-T", "PM-PU-1155-T", "PM-PU-1157-T", "PM-PU-1159-T", "PM-PU-1168-T", "PM-PU-1177-T", "PM-PU-1180-T",
					"PM-PU-1182-T", "PM-PU-1185-T", "PM-PU-1187-T", "PM-PU-1189-T", "PM-PU-1190-T", "PM-PU-1191-T", "PM-PU-1193-T", "PM-PU-1197-T", "PM-PU-1204-T", "PM-PU-1206-T",
					"PM-PU-1207-T", "PM-PU-1209-T", "PM-PA-1003-T", "PM-PA-1004-T", "PM-PA-1007-T", "PM-PA-1009-T", "PM-PA-1018-T", "PM-PA-1022-T", "PM-PA-1026-T", "PM-PA-1036-T",
					"PM-PA-1043-T", "PM-PA-1052-T", "PM-PA-1053-T", "PM-PB-1016-T", "PM-PB-1023-T", "PM-PB-1028-T", "PM-PB-1035-T", "PM-PB-1036-T", "PM-PB-1037-T", "PM-PB-1040-T",
					"PM-PM-1043-T", "PM-PU-1017-T", "PM-PU-1020-T", "PM-PU-1026-T", "PM-PU-1029-T", "PM-PU-1030-T", "PM-PU-1033-T", "PM-PU-1035-T", "PM-PU-1036-T", "PM-PU-1039-T",
					"PM-PU-1040-T", "PM-PU-1043-T", "PM-PU-1045-T", "PM-PU-1051-T", "PM-PU-1055-T", "PM-PU-1056-T", "PM-PU-1061-T", "PM-PU-1063-T", "PM-PU-1069-T", "PM-PU-1072-T",
					"PM-PU-1073-T", "PM-PU-1077-T", "PM-PU-1079-T", "PM-PU-1081-T", "PM-PU-1083-T", "PM-PU-1086-T", "PM-PU-1089-T", "PM-PU-1098-T" };
			
			List<String> degSampleList = Arrays.asList(degSampleArray);

			expHeatmapTpmVO.setSampleList(degSampleList);
			expHeatmapTpmVO.setGeneList(degGeneList);
			expHeatmapTpmVO.setExpList(omicsService.selectExpTpmList(expHeatmapTpmVO));

			List<String> groupList = new ArrayList<String>();
			for (int i = 0; i < degSampleList.size(); i++) {
				if (i < degSampleList.size() / 2) {
					groupList.add("Group1");
				} else {
					groupList.add("Group2");
				}
			}
			expHeatmapTpmVO.setSampleGroupList(groupList);

			expHeatmapTpmVO.setHeatmapDataList(OmicsDataUtils.createHeatmapData(expHeatmapTpmVO));

		} catch (Exception e) {
			logger.error("", e);
		}

		return expHeatmapTpmVO;

	}

	@RequestMapping(value = "/mo/basic/deg_heat_sample.do")
	@ResponseBody
	public OmicsDataVO deg_heat_sample_ajax(HttpServletRequest request, ModelMap model) throws Exception {

		OmicsDataVO expHeatmapTpmVO = new OmicsDataVO();
		try {

			// expression tpm heatmap
			String[] degArray = { "CALCB", "APOA4", "DAZ2", "DAZ4", "LIN28B", "SPINK6", "LCT", "ZNF679", "BPIFB2", "5_8S_rRNA", "RNA5-8SN1", "RNA5-8SN2", "RNA5-8SN3", "CSAG2",
					"PIK3C2G", "DAZ1", "LINC02735", "CCDC190", "SPINK13", "BPIFB1", "SLC10A2", "LINC02404", "MAGEC2", "ZIC1", "FAM9C", "A2ML1", "NNAT", "AC012085.2", "SLC26A9",
					"AC079313.2", "MARCOL", "KCNC2", "APOA1", "AHSG", "MORN5", "STRIT1", "CLDN6", "XAGE2", "IGFL1", "GJB6", "ANXA10", "APOA2", "ITIH2", "CCK", "PAGE1", "CYP7A1",
					"MAGEA9", "SLC6A10P", "MAEL", "TMEM213", "DGKB", "OBP2B", "KLK5", "MSMB", "GNAT3", "BEX1", "S100A2", "EPHA8", "IGKV2-29", "KRT13", "TRHDE-AS1", "TEX19",
					"ITLN2", "MIA", "DEFA5", "AC136628.4", "ALB", "UGT2B17", "ASB5", "TEX15", "ANKRD30BP1", "UPK1B" };
			List<String> degGeneList = Arrays.asList(degArray);

			String[] degSampleArray = { "PM-AA-0055-T", "PM-AA-0057-T", "PM-AA-0062-T", "PM-AA-0063-T", "PM-AA-0065-T", "PM-AU-0005-T", "PM-AU-0045-T", "PM-AU-0052-T",
					"PM-AU-0059-T", "PM-AU-0060-T", "PM-PB-1059-T", "PM-PB-1060-T", "PM-PB-1061-T", "PM-PB-1063-T", "PM-PB-1065-T", "PM-PB-1066-T", "PM-PB-1068-T", "PM-PB-1069-T",
					"PM-PB-1072-T", "PM-PB-1084-T", "PM-PB-1086-T", "PM-PB-1088-T", "PM-PB-1093-T", "PM-PB-1100-T", "PM-PB-1109-T", "PM-PB-1115-T", "PM-PB-1116-T", "PM-PB-1117-T",
					"PM-PB-1120-T", "PM-PB-1121-T", "PM-PB-1123-T", "PM-PB-1126-T", "PM-PB-1132-T", "PM-PB-1142-T", "PM-PB-1143-T", "PM-PB-1146-T", "PM-PB-1149-T", "PM-PB-1152-T",
					"PM-PB-1153-T", "PM-PB-1157-T", "PM-PB-1158-T", "PM-PB-1159-T", "PM-PM-1052-T", "PM-PM-1056-T", "PM-PM-1061-T", "PM-PM-1067-T", "PM-PM-1068-T", "PM-PM-1069-T",
					"PM-PM-1070-T", "PM-PM-1073-T", "PM-PS-0001-T", "PM-PS-0005-T", "PM-PS-0009-T", "PM-PS-0010-T", "PM-PS-0015-T", "PM-PS-0018-T", "PM-PS-0028-T", "PM-PS-0029-T",
					"PM-PS-0032-T", "PM-PS-0039-T", "PM-PS-0042-T", "PM-PS-0043-T", "PM-PS-0050-T", "PM-PS-0071-T", "PM-PS-0083-T", "PM-PS-0105-T", "PM-PS-0108-T", "PM-PS-0112-T",
					"PM-PS-0119-T", "PM-PS-0125-T", "PM-PS-0126-T", "PM-PS-0136-T", "PM-PS-0145-T", "PM-PS-0164-T", "PM-PS-0179-T", "PM-PS-0215-T", "PM-PU-1010-T", "PM-PU-1012-T",
					"PM-PU-1013-T", "PM-PU-1123-T", "PM-PU-1152-T", "PM-PU-1171-T", "PM-PU-1174-T", "PM-PU-1175-T", "PM-PU-1176-T", "PM-PU-1181-T", "PM-PU-1196-T", "PM-PU-1199-T",
					"PM-PU-1200-T", "PM-PU-1203-T", "PM-PU-1208-T", "PM-PA-1006-T", "PM-PA-1008-T", "PM-PA-1023-T", "PM-PA-1025-T", "PM-PA-1029-T", "PM-PA-1033-T", "PM-PA-1034-T",
					"PM-PA-1040-T", "PM-PB-1010-T", "PM-PB-1011-T", "PM-PB-1012-T", "PM-PB-1014-T", "PM-PB-1015-T", "PM-PB-1024-T", "PM-PB-1025-T", "PM-PB-1027-T", "PM-PB-1031-T",
					"PM-PB-1033-T", "PM-PB-1042-T", "PM-PM-1041-T", "PM-PM-1042-T", "PM-PM-1044-T", "PM-PU-1019-T", "PM-PU-1021-T", "PM-PU-1022-T", "PM-PU-1023-T", "PM-PU-1024-T",
					"PM-PU-1031-T", "PM-PU-1032-T", "PM-PU-1034-T", "PM-PU-1038-T", "PM-PU-1046-T", "PM-PU-1052-T", "PM-PU-1054-T", "PM-PU-1060-T", "PM-PU-1066-T", "PM-PU-1068-T",
					"PM-PU-1070-T", "PM-PU-1075-T", "PM-PU-1076-T", "PM-PU-1080-T", "PM-PU-1084-T", "PM-PU-1090-T", "PM-PU-1105-T", "PM-PU-1107-T", "PM-AA-0051-T", "PM-AA-0052-T",
					"PM-AA-0053-T", "PM-AA-0056-T", "PM-AA-0058-T", "PM-AA-0059-T", "PM-AA-0060-T", "PM-AA-0061-T", "PM-AA-0066-T", "PM-AS-0001-T", "PM-AS-0002-T", "PM-AS-0003-T",
					"PM-AS-0004-T", "PM-AS-0005-T", "PM-AS-0006-T", "PM-AS-0007-T", "PM-AS-0008-T", "PM-AS-0009-T", "PM-AS-0010-T", "PM-AS-0011-T", "PM-AS-0012-T", "PM-AS-0013-T",
					"PM-AS-0014-T", "PM-AS-0015-T", "PM-AS-0016-T", "PM-AS-0017-T", "PM-AS-0018-T", "PM-AS-0019-T", "PM-AS-0020-T", "PM-AS-0021-T", "PM-AS-0022-T", "PM-AS-0023-T",
					"PM-AS-0024-T", "PM-AS-0025-T", "PM-AS-0026-T", "PM-AS-0027-T", "PM-AS-0028-T", "PM-AS-0029-T", "PM-AS-0030-T", "PM-AS-0031-T", "PM-AS-0032-T", "PM-AS-0033-T",
					"PM-AS-0034-T", "PM-AS-0035-T", "PM-AS-0036-T", "PM-AS-0037-T", "PM-AS-0038-T", "PM-AS-0039-T", "PM-AS-0040-T", "PM-AS-0041-T", "PM-AS-0042-T", "PM-AS-0043-T",
					"PM-AS-0044-T", "PM-AS-0045-T", "PM-AS-0046-T", "PM-AS-0047-T", "PM-AS-0048-T", "PM-AS-0049-T", "PM-AS-0050-T", "PM-AU-0001-T", "PM-AU-0002-T", "PM-AU-0003-T",
					"PM-AU-0006-T", "PM-AU-0007-T", "PM-AU-0008-T", "PM-AU-0009-T", "PM-AU-0010-T", "PM-AU-0014-T", "PM-AU-0015-T", "PM-AU-0016-T", "PM-AU-0017-T", "PM-AU-0018-T",
					"PM-AU-0019-T", "PM-AU-0020-T", "PM-AU-0021-T", "PM-AU-0022-T", "PM-AU-0023-T", "PM-AU-0024-T", "PM-AU-0025-T", "PM-AU-0026-T", "PM-AU-0027-T", "PM-AU-0029-T",
					"PM-AU-0030-T", "PM-AU-0031-T", "PM-AU-0034-T", "PM-AU-0035-T", "PM-AU-0036-T", "PM-AU-0037-T", "PM-AU-0038-T", "PM-AU-0039-T", "PM-AU-0040-T", "PM-AU-0041-T",
					"PM-AU-0042-T", "PM-AU-0043-T", "PM-AU-0044-T", "PM-AU-0047-T", "PM-AU-0048-T", "PM-AU-0049-T", "PM-AU-0050-T", "PM-AU-0053-T", "PM-AU-0054-T", "PM-AU-0055-T",
					"PM-AU-0056-T", "PM-AU-0057-T", "PM-AU-0058-T", "PM-AU-0061-T", "PM-AU-0062-T", "PM-AU-0063-T", "PM-AU-0064-T", "PM-AU-0066-T", "PM-AU-0067-T", "PM-AU-0068-T",
					"PM-AU-0069-T", "PM-AU-0070-T", "PM-AU-0072-T", "PM-AU-0074-T", "PM-AU-0075-T", "PM-AU-0076-T", "PM-AU-0077-T", "PM-AU-0078-T", "PM-AU-0080-T", "PM-AU-0081-T",
					"PM-AU-0082-T", "PM-AU-0083-T", "PM-AU-0084-T", "PM-AU-0085-T", "PM-AU-0087-T", "PM-AU-0088-T", "PM-AU-0089-T", "PM-AU-0090-T", "PM-AU-0091-T", "PM-PB-1058-T",
					"PM-PB-1064-T", "PM-PB-1067-T", "PM-PB-1070-T", "PM-PB-1071-T", "PM-PB-1074-T", "PM-PB-1075-T", "PM-PB-1076-T", "PM-PB-1078-T", "PM-PB-1081-T", "PM-PB-1082-T",
					"PM-PB-1083-T", "PM-PB-1087-T", "PM-PB-1090-T", "PM-PB-1091-T", "PM-PB-1092-T", "PM-PB-1098-T", "PM-PB-1102-T", "PM-PB-1105-T", "PM-PB-1106-T", "PM-PB-1107-T",
					"PM-PB-1108-T", "PM-PB-1110-T", "PM-PB-1111-T", "PM-PB-1112-T", "PM-PB-1114-T", "PM-PB-1118-T", "PM-PB-1119-T", "PM-PB-1122-T", "PM-PB-1124-T", "PM-PB-1125-T",
					"PM-PB-1127-T", "PM-PB-1128-T", "PM-PB-1139-T", "PM-PB-1140-T", "PM-PB-1141-T", "PM-PB-1144-T", "PM-PB-1145-T", "PM-PB-1147-T", "PM-PB-1148-T", "PM-PB-1150-T",
					"PM-PB-1151-T", "PM-PB-1154-T", "PM-PB-1160-T", "PM-PM-1053-T", "PM-PM-1057-T", "PM-PM-1059-T", "PM-PM-1060-T", "PM-PM-1062-T", "PM-PM-1065-T", "PM-PM-1066-T",
					"PM-PM-1072-T", "PM-PM-1074-T", "PM-PS-0002-T", "PM-PS-0003-T", "PM-PS-0004-T", "PM-PS-0006-T", "PM-PS-0008-T", "PM-PS-0011-T", "PM-PS-0012-T", "PM-PS-0014-T",
					"PM-PS-0016-T", "PM-PS-0017-T", "PM-PS-0019-T", "PM-PS-0020-T", "PM-PS-0022-T", "PM-PS-0023-T", "PM-PS-0027-T", "PM-PS-0030-T", "PM-PS-0033-T", "PM-PS-0035-T",
					"PM-PS-0036-T", "PM-PS-0040-T", "PM-PS-0041-T", "PM-PS-0044-T", "PM-PS-0047-T", "PM-PS-0048-T", "PM-PS-0057-T", "PM-PS-0060-T", "PM-PS-0063-T", "PM-PS-0101-T",
					"PM-PS-0174-T", "PM-PS-0180-T", "PM-PS-0197-T", "PM-PS-0200-T", "PM-PS-0216-T", "PM-PS-0217-T", "PM-PS-0234-T", "PM-PU-1001-T", "PM-PU-1007-T", "PM-PU-1008-T",
					"PM-PU-1009-T", "PM-PU-1014-T", "PM-PU-1016-T", "PM-PU-1147-T", "PM-PU-1155-T", "PM-PU-1157-T", "PM-PU-1159-T", "PM-PU-1168-T", "PM-PU-1177-T", "PM-PU-1180-T",
					"PM-PU-1182-T", "PM-PU-1185-T", "PM-PU-1187-T", "PM-PU-1189-T", "PM-PU-1190-T", "PM-PU-1191-T", "PM-PU-1193-T", "PM-PU-1197-T", "PM-PU-1204-T", "PM-PU-1206-T",
					"PM-PU-1207-T", "PM-PU-1209-T", "PM-PA-1003-T", "PM-PA-1004-T", "PM-PA-1007-T", "PM-PA-1009-T", "PM-PA-1018-T", "PM-PA-1022-T", "PM-PA-1026-T", "PM-PA-1036-T",
					"PM-PA-1043-T", "PM-PA-1052-T", "PM-PA-1053-T", "PM-PB-1016-T", "PM-PB-1023-T", "PM-PB-1028-T", "PM-PB-1035-T", "PM-PB-1036-T", "PM-PB-1037-T", "PM-PB-1040-T",
					"PM-PM-1043-T", "PM-PU-1017-T", "PM-PU-1020-T", "PM-PU-1026-T", "PM-PU-1029-T", "PM-PU-1030-T", "PM-PU-1033-T", "PM-PU-1035-T", "PM-PU-1036-T", "PM-PU-1039-T",
					"PM-PU-1040-T", "PM-PU-1043-T", "PM-PU-1045-T", "PM-PU-1051-T", "PM-PU-1055-T", "PM-PU-1056-T", "PM-PU-1061-T", "PM-PU-1063-T", "PM-PU-1069-T", "PM-PU-1072-T",
					"PM-PU-1073-T", "PM-PU-1077-T", "PM-PU-1079-T", "PM-PU-1081-T", "PM-PU-1083-T", "PM-PU-1086-T", "PM-PU-1089-T", "PM-PU-1098-T" };
			
			List<String> degSampleList = Arrays.asList(degSampleArray);

			expHeatmapTpmVO.setSampleList(degSampleList);
			expHeatmapTpmVO.setGeneList(degGeneList);
			expHeatmapTpmVO.setExpList(omicsService.selectExpTpmList(expHeatmapTpmVO));

			List<String> groupList = new ArrayList<String>();
			for (int i = 0; i < degSampleList.size(); i++) {
				if (i < degSampleList.size() / 2) {
					groupList.add("Group1");
				} else {
					groupList.add("Group2");
				}
			}
			
			expHeatmapTpmVO.setSampleGroupList(groupList);
			expHeatmapTpmVO.setHeatmapDataList(OmicsDataUtils.createHeatmapData(expHeatmapTpmVO));


		} catch (Exception e) {
			logger.error("", e);
		}

		return expHeatmapTpmVO;

	}

	@RequestMapping(value = "/mo/basic/popup/volcano.do")
	public String pop_volcano(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			List<DegResultVO> degList = OmicsDataUtils.parseDegResultVolcano(searchVO);
			VolcanoPlotVO vo = new VolcanoPlotVO(degList);

			model.addAttribute("vo", JSONObject.fromObject(vo));
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/volcano";
	}

	@RequestMapping(value = "/mo/basic/popup/volcano_sample.do")
	public String pop_volcano_sample(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		return "tilespopup:bsite/mo/basic/popup/volcano_sample";
	}

	@RequestMapping(value = "/mo/basic/popup/surv_clinic_sample.do")
	public String pop_surv_clinic_sample(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		return "tilespopup:bsite/mo/basic/popup/surv_clinic_sample";
	}

	@RequestMapping(value = "/mo/basic/popup/surv_clinic.do")
	public String pop_surv_clinic(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		try {

			OmicsDataUtils.makeSampleID(searchVO);

			if (searchVO.getUd_idx() == 2) {
				List<mo_clinicalD2VO> list = clinic2Service.selectClinicD2ListBySample(searchVO);
				OmicsDataUtils.makeSurvClinicDataD2(searchVO, list);
			} else {
				List<mo_clinicalVO> list = clinic2Service.selectClinicListBySample(searchVO);
				OmicsDataUtils.makeSurvClinicData(searchVO, list);
			}

			model.addAttribute("vo", JSONObject.fromObject(searchVO));

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/surv_clinic";
	}

	@RequestMapping(value = "/mo/basic/popup/surv_deg.do")
	public String pop_surv_deg(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				OmicsDataUtils.mergeExpTpmSurvDeg(searchVO);
				OmicsDataUtils.excuteSurvDegNormalize(searchVO);
				OmicsDataUtils.parseDegResult(searchVO);
				OmicsDataUtils.makeSurvGeneFile(searchVO);
				List<mo_clinicalVO> list = clinic2Service.selectClinicListBySample(searchVO);
				OmicsDataUtils.makeClinicFile(searchVO, list);
				OmicsDataUtils.excuteRMakeData(searchVO);
			}
			
			OmicsDataUtils.makeSurvDegData(searchVO);

			model.addAttribute("vo", JSONObject.fromObject(searchVO));
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/surv_deg";
	}

	@RequestMapping(value = "/mo/basic/popup/surv.do")
	public String pop_surv(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				OmicsDataUtils.mergeExpTpmSurvDeg(searchVO);
				OmicsDataUtils.excuteSurvDegNormalize(searchVO);
			}
			if (!Globals.IS_LOCAL) {
				List<mo_clinicalVO> list = clinic2Service.selectClinicListBySample(searchVO);
				OmicsDataUtils.makeClinicFile(searchVO, list);
			}

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/surv";
	}

	@RequestMapping(value = "/mo/basic/popup/surv_ajax.do")
	@ResponseBody
	public AjaxResult surv_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			OmicsDataUtils.parseDegResult(searchVO);
			OmicsDataUtils.makeGeneListByDeg(searchVO);
			if (!Globals.IS_LOCAL) {
				OmicsDataUtils.makeSurvGeneFile(searchVO);
				OmicsDataUtils.excuteRMakeData(searchVO);
			}

			OmicsDataUtils.makeSurvDegData(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(searchVO);
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;
	}

	@RequestMapping(value = "/mo/basic/popup/surv_user_ajax.do")
	@ResponseBody
	public AjaxResult surv_user_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			OmicsDataUtils.parseDegResult(searchVO);
			OmicsDataUtils.splitUserGenes(searchVO);
			if (!Globals.IS_LOCAL) {
				OmicsDataUtils.makeSurvGeneFile(searchVO);
				OmicsDataUtils.excuteRMakeData(searchVO);
			}

			OmicsDataUtils.makeSurvDegData(searchVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(searchVO);
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	@RequestMapping(value = "/mo/basic/popup/surv_deg_sample.do")
	public String pop_surv_deg_sample(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		return "tilespopup:bsite/mo/basic/popup/surv_deg_sample";
	}

	@RequestMapping(value = { "/mo/basic/expCountDown.do" })
	public void expCountFileDownload(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				String filePath = OmicsDataUtils.mergeExpCnt(searchVO);

				Date date = new Date();
				String fileName = "exp_cnt_" + fileNameFormat.format(date) + ".tsv";
				OmicsDataUtils.downloadFile(request, response, session, filePath, fileName);
			}
		} catch (Exception e) {
			logger.error("", e);
		}
	}

	@RequestMapping(value = { "/mo/basic/expTpmDown.do" })
	public void expTpmFileDownload(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				String filePath = OmicsDataUtils.mergeExpTpmForPca(searchVO);

				Date date = new Date();
				String fileName = "exp_tpm_" + fileNameFormat.format(date) + ".tsv";
				OmicsDataUtils.downloadFile(request, response, session, filePath, fileName);
			}
		} catch (Exception e) {
			logger.error("", e);
		}
	}

	@RequestMapping(value = { "/mo/basic/metBetaDown.do" })
	public void metBetaFileDownload(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			if (!Globals.IS_LOCAL) {
				String filePath = OmicsDataUtils.mergeDmp(searchVO);

				Date date = new Date();
				String fileName = "met_beta_" + fileNameFormat.format(date) + ".tsv";
				OmicsDataUtils.downloadFile(request, response, session, filePath, fileName);
			}
		} catch (Exception e) {
			logger.error("", e);
		}
	}

	@RequestMapping(value = "/mo/basic/popup/density.do")
	public String pop_density(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		return "tilespopup:bsite/mo/basic/popup/density";
	}

	@RequestMapping(value = "/mo/basic/popup/degAnnotation.do")
	public String pop_degAnnotation(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);

			switch (searchVO.getDegType()) {
			case EdgeR:
				OmicsDataUtils.parseDegResult(searchVO);
				composeExpHeatmapData(searchVO);
				JSONArray jsonBody1 = OmicsDataUtils.getDegEdgeRJson(searchVO);
				model.addAttribute("jsonBody", jsonBody1);
				break;
			case DESeq2:
				OmicsDataUtils.parseDeSeq2Result(searchVO);
				composeExpHeatmapData(searchVO);
				JSONArray jsonBody2 = OmicsDataUtils.getDegSeq2Json(searchVO);
				model.addAttribute("jsonBody", jsonBody2);
				break;
			}

			mo_entrezVO entrezVO = new mo_entrezVO();
			entrezVO.setGeneList(searchVO.getGeneList());
			String ids = entrezService.selectEntrezIdsByGenes(entrezVO);
			model.addAttribute("ids", ids);

			JSONObject sampleFields = OmicsDataUtils.createGridFieldsBySample(searchVO);
			model.addAttribute("sampleFields", sampleFields);

			JSONArray sampleColumns = OmicsDataUtils.createGridColumnsBySample(searchVO);
			model.addAttribute("sampleColumns", sampleColumns);
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/degAnnotation";
	}

	@RequestMapping(value = "/mo/basic/popup/dmpAnnotation.do")
	public String pop_dmpAnnotation(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			searchVO.setType(OmicsType.Methylation);
			OmicsDataUtils.makeSampleID(searchVO);

			OmicsDataUtils.parseDmpResult(searchVO);
			composeMethHeatmapData(searchVO);

			searchVO.setInfiniumList(omicsService.selectInfiniumList(searchVO));
			JSONArray jsonBody = OmicsDataUtils.getDmpChAMPJson(searchVO);
			model.addAttribute("jsonBody", jsonBody);

			mo_entrezVO entrezVO = new mo_entrezVO();
			entrezVO.setGeneList(searchVO.getGeneList());
			String ids = entrezService.selectEntrezIdsByGenes(entrezVO);
			model.addAttribute("ids", ids);
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/dmpAnnotation";
	}

	@RequestMapping(value = "/mo/basic/popup/htPrimer.do", method = RequestMethod.POST)
	public String pop_htPrimer(HtPrimerVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		searchVO.setSite_code(loginService.getSiteCode());
		searchVO.setCret_id(loginVO.getId());
		searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

		try {

			model.addAttribute("searchVO", searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/ht_primer";
	}

	@RequestMapping(value = "/mo/basic/popup/htPrimer_output.do", method = RequestMethod.POST)
	public String pop_htPrimerOutput(HtPrimerVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		searchVO.setSite_code(loginService.getSiteCode());
		searchVO.setCret_id(loginVO.getId());
		searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

		try {

			String htPrimerResponse = methylationService.sendToHtPrimer(searchVO);
			model.addAttribute("output_body", htPrimerResponse);
		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/blank_html";
	}

	@RequestMapping(value = "/mo/basic/popup/varAnnotation.do")
	public String pop_mutAnnotation(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);

			if (searchVO.getType() == OmicsType.MutationSnv) {
				searchVO.setGeneList(omicsService.selectMutGeneListLimit(searchVO));
				searchVO.setMutList(omicsService.selectMutSnvList(searchVO));
			} else {
				searchVO.setGeneList(omicsService.selectMutGeneListLimit(searchVO));
				searchVO.setMutList(omicsService.selectMutIndelList(searchVO));
			}
			OmicsDataUtils.makeGridPropertiesDetail(searchVO);
			model.addAttribute("variantGrid", searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/varAnnotation";
	}

	@RequestMapping(value = "/mo/basic/popup/varPrimer.do", method = RequestMethod.POST)
	public String pop_varPrimer(VarPrimerVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		searchVO.setSite_code(loginService.getSiteCode());
		searchVO.setCret_id(loginVO.getId());
		searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

		try {

			model.addAttribute("searchVO", searchVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/var_primer";
	}

	@RequestMapping(value = "/mo/basic/popup/varPrimer_output.do", method = RequestMethod.POST)
	public String pop_varPrimerOutput(VarPrimerVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		searchVO.setSite_code(loginService.getSiteCode());
		searchVO.setCret_id(loginVO.getId());
		searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

		try {

			Map<String, String> fasta = variantService.sendAnnotationForFasta(searchVO);

			String fasta1 = fasta.get("FASTA_1");
			String fasta2 = fasta.get("FASTA_2");
			String fasta3 = fasta.get("FASTA_3");

			String fasta3Elements[] = fasta3.split(";");

			searchVO.getPrimerVO().setSEQUENCE(fasta1);

			searchVO.getBlockerVO().setSEQUENCE(fasta2);
			searchVO.getBlockerVO().setPRIMER_LEFT_INPUT(fasta3Elements[fasta3Elements.length - 1].trim().substring(1).trim());
			
			searchVO.getProbeVO().setSEQUENCE_TEMPLATE(fasta1);


			List<VariantPrimerResultVO> primerResults = variantService.sendForBatchPrimer3(searchVO);
			List<VariantBlockerResultVO> blockerResults = variantService.sendForBlocker(searchVO);
			List<VariantProbeResultVO> probeResults = variantService.sendForProbe(searchVO);

			int maxPosition = 0;
			if (primerResults != null) {
				for (VariantPrimerResultVO primerResult : primerResults) {
					maxPosition = maxPosition < (primerResult.getFlankingStart() + primerResult.getFlankingLen())
							? (primerResult.getFlankingStart() + primerResult.getFlankingLen())
							: maxPosition;
					maxPosition = maxPosition < (primerResult.getSpecificStart() + primerResult.getSpecificLen())
							? (primerResult.getSpecificStart() + primerResult.getSpecificLen())
							: maxPosition;
				}
			}
			if (blockerResults != null) {
				for (VariantBlockerResultVO blockerResult : blockerResults) {
					maxPosition = maxPosition < (blockerResult.getStart1() + blockerResult.getLen1()) ? (blockerResult.getStart1() + blockerResult.getLen1()) : maxPosition;
					maxPosition = maxPosition < (blockerResult.getStart2() + blockerResult.getLen2()) ? (blockerResult.getStart2() + blockerResult.getLen2()) : maxPosition;
				}
			}
			if (primerResults != null) {
				for (VariantProbeResultVO probeResult : probeResults) {
					maxPosition = maxPosition < (probeResult.getStart() + probeResult.getLen()) ? (probeResult.getStart() + probeResult.getLen()) : maxPosition;
				}
			}

			VariantRecordVO variantRecord = new VariantRecordVO();
			variantRecord.setSite_code(loginService.getSiteCode());
			variantRecord.setCret_id(loginVO.getId());
			variantRecord.setCret_ip(InetAddress.getLocalHost().getHostAddress());
			variantRecord.setStd_idx(searchVO.getStd_idx());
			variantRecord.setVariantID(StringEscapeUtils.unescapeHtml(searchVO.getVariantID()));
			variantRecord.setAnnotation(searchVO.getInput_file_string());
			variantRecord.setFasta1(fasta1);
			variantRecord.setFasta2(fasta2);
			variantRecord.setFasta3(fasta3);
			variantRecord.setVariantPrimerResults(primerResults);
			variantRecord.setVariantBlockerResults(blockerResults);
			variantRecord.setVariantProbeResults(probeResults);
			variantRecord.setMaxPosition(variantRecord.getEndPosition() + maxPosition);

			variantService.save(variantRecord);

			model.addAttribute("variantRecord", variantRecord);

			List<VariantBEDFileVO> bedFiles = variantService.generateBedFiles(variantRecord, 100);

			for (VariantBEDFileVO bedFile : bedFiles) {
				variantBedFileService.save(bedFile);
			}

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/analysisdata/variant/pop_result";
	}

}
