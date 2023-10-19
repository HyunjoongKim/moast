package com.bsite.mo.multi.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.adms.mo.visual.service.OmicsService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.cmm.PythonAPI;
import com.bsite.mo.visual.service.StudyService;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.exp_meth_corr_resultVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_studyVO;

import egovframework.com.cmm.service.Globals;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
public class MultiController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "OmicsService")
	private OmicsService omicsService;

	@Resource(name = "StudyService")
	private StudyService studyService;

	private OmicsDataVO restoreOmicsDataByStudy(int std_idx, String omicsType) throws Exception {
		mo_studyVO stdVO = studyService.selectStudyByIdx(std_idx);
		OmicsDataVO omicsVO = OmicsDataUtils.parseSaved(stdVO);
		omicsVO.setSurvOmicsType1(omicsType);
		return omicsVO;
	}

	@RequestMapping(value = "/mo/multi/list.do")
	public String met_list(OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		int idx = Integer.parseInt(searchVO.getSearchStdIdx());
		OmicsDataVO omicsVO = restoreOmicsDataByStudy(idx, "exp");

		try {
			JSONArray srcArray = getTab1Src(omicsVO);
			List<exp_meth_corr_resultVO> methCorrList = getTab1ApiResult(srcArray);

			JSONObject xbody = new JSONObject();
			xbody.put("total", methCorrList.size());
			xbody.put("rows", JSONArray.fromObject(methCorrList));
			model.addAttribute("xbody", xbody);
			model.addAttribute("omicsVO", omicsVO);

		} catch (Exception e) {
			logger.error("", e);
		}

		model.addAttribute("vo", JSONObject.fromObject(omicsVO));
		model.addAttribute("omicsVO", omicsVO);

		return "tiles:bsite/mo/multi/list";
	}

	@RequestMapping(value = "/mo/multi/list2.do")
	public String met_list2(OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		int idx = Integer.parseInt(searchVO.getSearchStdIdx());
		OmicsDataVO omicsVO = restoreOmicsDataByStudy(idx, "exp");

		try {

			OmicsDataUtils.makeSampleID(omicsVO);
			OmicsDataUtils.makeDirectory(omicsVO);

			JSONArray srcArray = getTab1Src(omicsVO);
			if (srcArray != null && srcArray.size() > 0) {
				List<exp_meth_corr_resultVO> methCorrList = getTab1ApiResult(srcArray);

				JSONObject xbody = new JSONObject();
				xbody.put("total", methCorrList.size());
				xbody.put("rows", JSONArray.fromObject(methCorrList));
				model.addAttribute("xbody", xbody);

				tab2(omicsVO);
				model.addAttribute("xbody2", omicsVO.getMultiEmJson());

				tab3(omicsVO);
				model.addAttribute("xbody3", omicsVO.getMultiEmmJson());
			} else {
				Map<String, Object> resMap = new HashMap<String, Object>();
				resMap.put("res", "error");
				resMap.put("msg", "There are no genes matching the Expression and Methylation.");
				model.addAttribute("resMap", resMap);
			}

		} catch (Exception e) {
			logger.error("", e);
		}

		model.addAttribute("vo", JSONObject.fromObject(omicsVO));
		model.addAttribute("omicsVO", omicsVO);

		return "tiles:bsite/mo/multi/list2";
	}

	@RequestMapping(value = "/mo/multi/tab2.do")
	@ResponseBody
	public AjaxResult tab2_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();

		try {
			int idx = Integer.parseInt(searchVO.getSearchStdIdx());
			OmicsDataVO omicsVO = restoreOmicsDataByStudy(idx, "exp");

			tab2(omicsVO);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(omicsVO.getMultiEmCorrList());
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;

	}

	private List<exp_meth_corr_resultVO> getTab1ApiResult(JSONArray srcArray) {
		// call Correlation python API
		String rtnStr = PythonAPI.callCorrList(srcArray);
		JSONArray jsonArray2 = JSONArray.fromObject(JSONSerializer.toJSON(rtnStr));

		List<exp_meth_corr_resultVO> methCorrList = new ArrayList<exp_meth_corr_resultVO>();
		for (Object i : jsonArray2) {
			JSONArray jsonArray = JSONArray.fromObject(JSONSerializer.toJSON(i));

			exp_meth_corr_resultVO vo = new exp_meth_corr_resultVO();
			String id = jsonArray.get(1).toString();
			vo.setGene_symbol(jsonArray.get(0).toString());
			vo.setProbe_id(StringUtils.split(id, "$")[1]);
			vo.setPearson_coeff(String.format("%.9f", CommonFunctions.parseDouble(jsonArray.get(2).toString())));
			vo.setPearson_pvale(String.format("%.9f", CommonFunctions.parseDouble(jsonArray.get(3).toString())));
			vo.setSpearman_coeff(String.format("%.9f", CommonFunctions.parseDouble(jsonArray.get(4).toString())));
			vo.setSpearman_pvale(String.format("%.9f", CommonFunctions.parseDouble(jsonArray.get(5).toString())));

			methCorrList.add(vo);
		}

		return methCorrList;
	}

	private JSONArray getTab1Src(OmicsDataVO omicsVO) throws Exception {
		if ("A".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.parseDegResult(omicsVO);

			// 유전자 리스트 사전 교집합 체크 필요
			omicsVO.setGeneList(omicsVO.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
		} else if ("G".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());

		}
		List<String> geneList = omicsVO.getGeneList();
		List<mo_expVO> expList = omicsService.selectExpTpmList(omicsVO);
		omicsVO.setExpList(expList);

		if ("A".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.parseDmpResult(omicsVO);

			omicsVO.setProbeList(omicsVO.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList()));
			omicsVO.setMethList(omicsService.selectMethListForHeatmap(omicsVO));
		} else if ("G".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMethList(omicsService.selectMethListByGene(omicsVO));
		}
		OmicsDataUtils.makeGeneProbeList(omicsVO);

		List<mo_methVO> methList = omicsVO.getMethList();
		List<String> geneProbeList = omicsVO.getGeneProbeList();

		boolean isFirst = true;
		String probeId;
		JSONArray srcArray = new JSONArray();

		for (String geneProbe : geneProbeList) {

			String[] splited = StringUtils.split(geneProbe, "$");

			if (splited != null) {
				if (splited.length > 1) {

					String geneSymbol = StringUtils.split(geneProbe, "$")[0];
					probeId = StringUtils.split(geneProbe, "$")[1];

					JSONObject srcObj = new JSONObject();
					List<mo_expVO> expFilterdList = expList.stream().filter(x -> StringUtils.equals(x.getGene_symbol(), geneSymbol)).collect(Collectors.toList());
					String expData = geneSymbol + "\t" + expFilterdList.stream().map(x -> String.valueOf(x.getVal())).collect(Collectors.joining("\t"));

					List<mo_methVO> methFilterdList = methList.stream().filter(x -> StringUtils.equals(x.getGene_probe(), geneProbe)).collect(Collectors.toList());
					String methData = geneSymbol + "\t" + probeId + "\t" + geneProbe + "\t"
							+ methFilterdList.stream().map(x -> String.valueOf(x.getBeta_value())).collect(Collectors.joining("\t"));

					// 교집합인 경우만 해당되는지 재 검토 필요
					if (expFilterdList.size() > 0 && methFilterdList.size() > 0) {
						srcObj.put("exp_data", expData);
						srcObj.put("meth_data", methData);
						srcArray.add(srcObj);

						if (isFirst) {
							omicsVO.setSearchGeneSymbol(geneSymbol);
							omicsVO.setSearchProbeId(probeId);

							isFirst = false;
						}
					}

				}
			}
		}

		return srcArray;
	}

	private void tab2(OmicsDataVO omicsVO) throws Exception {
		// exp
		if ("A".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.parseDegResult(omicsVO);
			omicsVO.setGeneList(omicsVO.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
		} else if ("G".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
		}
		List<String> expGeneList = omicsVO.getGeneList();
		omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));
		OmicsDataUtils.makeMultiEmExpInputFile(omicsVO);

		// mut
		// if ("A".equals(omicsVO.getStd_type())) {
		// omicsVO.setGeneList(omicsService.selectMutGeneListLimit(omicsVO));
		// } else if ("G".equals(omicsVO.getStd_type())) {
		// OmicsDataUtils.makeUserGeneList(omicsVO);
		// omicsVO.setGeneList(omicsVO.getUserGeneList());
		// }
		omicsVO.setGeneList(expGeneList);
		omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));
		OmicsDataUtils.makeMultiEmMutInputFile(omicsVO);

		if (!Globals.IS_LOCAL) {
			OmicsDataUtils.excuteMultiEm(omicsVO);
		}

		OmicsDataUtils.parseMultiEmCorr(omicsVO);
		OmicsDataUtils.parseMultiEmVar(omicsVO);

	}

	private void tab3(OmicsDataVO omicsVO) throws Exception {
		// exp gene list
		if ("A".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.parseDegResult(omicsVO);
			omicsVO.setGeneList(omicsVO.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList()));
		} else if ("G".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
		}
		List<String> expGeneList = omicsVO.getGeneList();
		omicsVO.setExpList(omicsService.selectExpTpmList(omicsVO));

		// meth gene probe list
		if ("A".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.parseDmpResult(omicsVO);
			omicsVO.setProbeList(omicsVO.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList()));
			omicsVO.setMethList(omicsService.selectMethListForHeatmap(omicsVO));
		} else if ("G".equals(omicsVO.getStd_type())) {
			OmicsDataUtils.makeUserGeneList(omicsVO);
			omicsVO.setGeneList(omicsVO.getUserGeneList());
			omicsVO.setMethList(omicsService.selectMethListByGene(omicsVO));
		}
		OmicsDataUtils.makeGeneProbeList(omicsVO);
		List<String> geneProbeList = omicsVO.getGeneProbeList();

		// mut gene list
		omicsVO.setGeneList(expGeneList);
		omicsVO.setMutList(omicsService.selectMutSnvList(omicsVO));

		// intersection
		List<String> outGeneList = new ArrayList<String>();
		List<String> outGeneProbeList = new ArrayList<String>();

		for (String geneProbe : geneProbeList) {
			String gene = StringUtils.split(geneProbe, "$")[0];
			if (expGeneList.contains(gene)) {
				outGeneList.add(gene);
				outGeneProbeList.add(geneProbe);
			}
		}

		// exp input file
		List<mo_expVO> expList = omicsVO.getExpList();
		List<mo_expVO> outExpList = new ArrayList<mo_expVO>();
		for (String gene : outGeneList) {
			Optional<mo_expVO> expVO = expList.stream().filter(x -> StringUtils.equals(x.getGene_symbol(), gene)).findAny();
			expVO.ifPresent(exp -> outExpList.add(exp));
		}
		omicsVO.setGeneList(outGeneList);
		OmicsDataUtils.makeMultiEmmExpInputFile(omicsVO);

		// meth input file
		List<mo_methVO> methList = omicsVO.getMethList();
		List<mo_methVO> outMethList = new ArrayList<mo_methVO>();
		for (String geneProbe : outGeneProbeList) {
			mo_methVO methVO = methList.stream().filter(x -> StringUtils.equals(x.getGene_probe(), geneProbe)).findAny().get();
			outMethList.add(methVO);
		}
		omicsVO.setGeneProbeList(outGeneProbeList);
		OmicsDataUtils.makeMultiEmmMethInputFile(omicsVO);

		// mut input file
		List<mo_mutationVO> mutList = omicsVO.getMutList();
		List<mo_mutationVO> outMutList = new ArrayList<mo_mutationVO>();
		for (String gene : outGeneList) {
			for (mo_mutationVO m : mutList) {
				if (StringUtils.equals(m.getHugo_symbol(), gene)) {
					outMutList.add(m);
				}
			}
		}

		omicsVO.setMutList(outMutList);
		omicsVO.setGeneList(outGeneList);
		OmicsDataUtils.makeMultiEmmMutInputFile(omicsVO);

		if (!Globals.IS_LOCAL) {
			OmicsDataUtils.excuteMultiEmm(omicsVO);
		}

		OmicsDataUtils.parseMultiEmmCorr(omicsVO);
		OmicsDataUtils.parseMultiEmmMeth(omicsVO);
		OmicsDataUtils.parseMultiEmmVar(omicsVO);
	}
}
