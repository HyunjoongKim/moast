package com.bsite.mo.visual.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.crc.gsvisual.MatrixService;
import com.adms.mo.visual.service.OmicsDataUtils;
import com.adms.mo.visual.service.OmicsService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.cmm.PythonAPI;
import com.bsite.vo.CorrelationScatterVO;
import com.bsite.vo.MatrixVO;
import com.bsite.vo.MethylationVO;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.dna_meVO;
import com.bsite.vo.dna_me_probe_geneVO;
import com.bsite.vo.exp_meth_corr_resultVO;
import com.bsite.vo.mo_epic850kVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_methVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
public class VisualCorrController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "MatrixService")
	private MatrixService matrixService;

	@Resource(name = "OmicsService")
	private OmicsService omicsService;

	@RequestMapping(value = "/mo/visual/met/list.do")
	public String met_list(@ModelAttribute("searchVO") dna_meVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			MatrixVO matrixVO = matrixService.initMatrix(request, model);

			Map<String, String> expCorrMap = matrixService.getExpCorrMap(matrixVO);
			Map<String, String> metCorrMap = matrixService.getMethCorrMap(matrixVO);

			JSONArray srcArray = new JSONArray();
			for (dna_me_probe_geneVO i : matrixVO.getProbeGeneList()) {
				JSONObject srcObj = new JSONObject();
				srcObj.put("exp_data", expCorrMap.get(i.getGene_symbol()));
				srcObj.put("meth_data", metCorrMap.get(i.getGene_symbol() + "$" + i.getProbe_id()));
				srcArray.add(srcObj);
			}

			String rtnStr = PythonAPI.callCorrList(srcArray);
			JSONArray jsonArray2 = JSONArray.fromObject(JSONSerializer.toJSON(rtnStr));


			List<exp_meth_corr_resultVO> methCorrList = new ArrayList<exp_meth_corr_resultVO>();
			for (Object i : jsonArray2) {
				JSONArray jsonArray = JSONArray.fromObject(JSONSerializer.toJSON(i));

				exp_meth_corr_resultVO vo = new exp_meth_corr_resultVO();
				String id = jsonArray.get(1).toString();
				vo.setGene_symbol(jsonArray.get(0).toString());
				vo.setProbe_id(StringUtils.split(id, "$")[1]);
				vo.setPearson_coeff(String.format("%.9f", new Double(jsonArray.get(2).toString())));
				vo.setPearson_pvale(String.format("%.9f", new Double(jsonArray.get(3).toString())));
				vo.setSpearman_coeff(String.format("%.9f", new Double(jsonArray.get(4).toString())));
				vo.setSpearman_pvale(String.format("%.9f", new Double(jsonArray.get(5).toString())));

				methCorrList.add(vo);
			}

			JSONObject xbody = new JSONObject();
			xbody.put("total", methCorrList.size());
			xbody.put("rows", JSONArray.fromObject(methCorrList));
			model.addAttribute("xbody", xbody);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/visual/meth_corr/list";
	}

	@RequestMapping(value = "/mo/visual/met/read_ajax.do")
	@ResponseBody
	public List<List<Double>> met_read_ajax(@ModelAttribute("searchVO") MethylationVO searchVO, HttpServletRequest request, ModelMap model,
			@RequestParam(required = false, value = "grp1", defaultValue = "") String grp1, @RequestParam(required = false, value = "grp2", defaultValue = "") String grp2)
			throws Exception {

		List<String> sample1List = Arrays.asList(StringUtils.split(grp1, ","));
		List<String> sample2List = Arrays.asList(StringUtils.split(grp2, ","));

		searchVO.setSampleList(sample1List);
		List<MethylationVO> xy1 = matrixService.selectMethylationXYBySample(searchVO);

		searchVO.setSampleList(sample2List);
		List<MethylationVO> xy2 = matrixService.selectMethylationXYBySample(searchVO);

		List<MethylationVO> xy = new ArrayList<MethylationVO>();
		xy.addAll(xy1);
		xy.addAll(xy2);

		List<List<Double>> dataList = new ArrayList<List<Double>>();
		for (MethylationVO i : xy) {
			List<Double> dList = new ArrayList<Double>();
			dList.add(i.getX());
			dList.add(i.getY());
			dataList.add(dList);
		}

		return dataList;

	}

	@RequestMapping(value = "/mo/visual/met2/list.do")
	public String met2_list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			OmicsDataUtils.parseDegResult(searchVO);

			List<String> geneList = searchVO.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList());
			searchVO.setGeneList(geneList);
			List<mo_expVO> expList = omicsService.selectExpTpmList(searchVO);
			searchVO.setExpList(expList);

			OmicsDataUtils.parseDmpResult(searchVO);

			List<String> probeList = searchVO.getDmpList().stream().map(x -> x.getProbe_id()).collect(Collectors.toList());
			searchVO.setProbeList(probeList);

			List<mo_methVO> methList = omicsService.selectMethListForHeatmap(searchVO);

			if (probeList.size() > 0)
				searchVO.setMethList(omicsService.selectMethListForHeatmap(searchVO));
			OmicsDataUtils.makeGeneProbeList(searchVO);

			List<String> geneProbeList = searchVO.getGeneProbeList();

			boolean isFirst = true;

			JSONArray srcArray = new JSONArray();
			String probeId;

			for (String geneProbe : geneProbeList) {
				String geneSymbol = StringUtils.split(geneProbe, "$")[0];
				probeId = StringUtils.split(geneProbe, "$")[1];
				JSONObject srcObj = new JSONObject();
				List<mo_expVO> expFilterdList = expList.stream().filter(x -> StringUtils.equals(x.getGene_symbol(), geneSymbol)).collect(Collectors.toList());
				String expData = geneSymbol + "\t" + expFilterdList.stream().map(x -> String.valueOf(x.getVal())).collect(Collectors.joining("\t"));

				List<mo_methVO> methFilterdList = methList.stream().filter(x -> StringUtils.equals(x.getGene_probe(), geneProbe)).collect(Collectors.toList());
				String methData = geneSymbol + "\t" + probeId + "\t" + geneProbe + "\t"
						+ methFilterdList.stream().map(x -> String.valueOf(x.getBeta_value())).collect(Collectors.joining("\t"));

				if (expFilterdList.size() > 0 && methFilterdList.size() > 0) {
					srcObj.put("exp_data", expData);
					srcObj.put("meth_data", methData);
					srcArray.add(srcObj);

					if (isFirst) {
						searchVO.setSearchGeneSymbol(geneSymbol);
						searchVO.setSearchProbeId(probeId);

						isFirst = false;
					}
				}

			}

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

			JSONObject xbody = new JSONObject();
			xbody.put("total", methCorrList.size());
			xbody.put("rows", JSONArray.fromObject(methCorrList));
			model.addAttribute("xbody", xbody);

		} catch (Exception e) {
			logger.error("", e);
		}

		model.addAttribute("vo", JSONObject.fromObject(searchVO));

		return "tilespopup:bsite/mo/visual/meth_corr/list2";
	}

	@RequestMapping(value = "/mo/visual/met3/list.do")
	public String met3_list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {

			OmicsDataUtils.makeSampleID(searchVO);
			OmicsDataUtils.parseDegResult(searchVO);
			OmicsDataUtils.makeGeneListByDeg(searchVO);

			List<mo_expVO> expList = omicsService.selectExpTpmList(searchVO);
			searchVO.setExpList(expList);
			List<mo_methVO> methList = omicsService.selectMethListByGeneSample(searchVO);
			searchVO.setMethList(methList);

			List<mo_epic850kVO> probeGeneList = omicsService.selectProbeGeneEpicList(searchVO);

			boolean isFirst = true;

			JSONArray srcArray = new JSONArray();
			for (mo_epic850kVO i : probeGeneList) {

				JSONObject srcObj = new JSONObject();
				List<mo_expVO> expFilterdList = expList.stream().filter(x -> StringUtils.equals(x.getGene_symbol(), i.getRef_gene())).collect(Collectors.toList());
				String expData = i.getRef_gene() + "\t" + expFilterdList.stream().map(x -> String.valueOf(x.getVal())).collect(Collectors.joining("\t"));

				List<mo_methVO> methFilterdList = methList.stream().filter(x -> StringUtils.equals(x.getGene_probe(), i.getGene_probe())).collect(Collectors.toList());
				String methData = i.getRef_gene() + "\t" + i.getProbe_id() + "\t" + i.getGene_probe() + "\t"
						+ methFilterdList.stream().map(x -> String.valueOf(x.getBeta_value())).collect(Collectors.joining("\t"));

				if (expFilterdList.size() > 0 && methFilterdList.size() > 0) {
					srcObj.put("exp_data", expData);
					srcObj.put("meth_data", methData);
					srcArray.add(srcObj);

					if (isFirst) {
						searchVO.setSearchGeneSymbol(i.getRef_gene());
						searchVO.setSearchProbeId(i.getProbe_id());

						isFirst = false;
					}
				}

			}

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

			JSONObject xbody = new JSONObject();
			xbody.put("total", methCorrList.size());
			xbody.put("rows", JSONArray.fromObject(methCorrList));
			model.addAttribute("xbody", xbody);

		} catch (Exception e) {
			logger.error("", e);
		}

		model.addAttribute("vo", JSONObject.fromObject(searchVO));

		return "tilespopup:bsite/mo/visual/meth_corr/list2";
	}

	@RequestMapping(value = "/mo/visual/met2/read_ajax.do")
	@ResponseBody
	public List<List<Double>> met2_read_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		OmicsDataUtils.makeSampleID(searchVO);

		searchVO.setSearchSampleList(searchVO.getSample1List());
		List<CorrelationScatterVO> xy1 = omicsService.selectCorrelationXYBySample(searchVO);

		searchVO.setSearchSampleList(searchVO.getSample2List());
		List<CorrelationScatterVO> xy2 = omicsService.selectCorrelationXYBySample(searchVO);

		List<CorrelationScatterVO> xy = new ArrayList<CorrelationScatterVO>();
		xy.addAll(xy1);
		xy.addAll(xy2);

		List<List<Double>> dataList = new ArrayList<List<Double>>();
		for (CorrelationScatterVO i : xy) {
			List<Double> dList = new ArrayList<Double>();
			dList.add(i.getX());
			dList.add(i.getY());
			dataList.add(dList);
		}

		return dataList;

	}
}
