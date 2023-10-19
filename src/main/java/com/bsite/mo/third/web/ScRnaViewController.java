package com.bsite.mo.third.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.bsite.vo.AjaxResult;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.mo_sc_scatterVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class ScRnaViewController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "OmicsService")
	private OmicsService omicsService;

	@Resource(name = "LoginService")
	private LoginService loginService;

	@RequestMapping(value = "/mo/third/scrnaview/list.do")
	public String list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		List<String> geneList = omicsService.selectEpicGeneList();
		net.sf.json.JSONArray jsonArray = net.sf.json.JSONArray.fromObject(geneList);
		model.addAttribute("jsonArray", jsonArray);

		return "tiles:bsite/mo/third/scrnaview/list";
	}

	@RequestMapping(value = "/mo/third/scrnaview/scatter_action.do")
	@ResponseBody
	public AjaxResult scatter_action(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			OmicsDataUtils.makeUserGeneList(searchVO);
			List<String> geneList = searchVO.getUserGeneList();

			List<String> yCellIdList = new ArrayList<String>();
			List<String> zGeneList = new ArrayList<String>();
			List<Double> zExpressionList = new ArrayList<Double>();
			List<Integer> zExpression2List = new ArrayList<Integer>();
			List<String> zClusterList = new ArrayList<String>();
			List<List<Double>> dataList = new ArrayList<List<Double>>();

			for (String gene : geneList) {
				searchVO.setSearchGene(gene);

				List<mo_sc_scatterVO> scatterList = omicsService.selectScRnaScatterListByGene(searchVO);

				for (mo_sc_scatterVO o : scatterList) {
					yCellIdList.add(gene + "$" + o.getCell_id());
					zGeneList.add(gene);
					zExpressionList.add(o.getLogValue());
					zExpression2List.add(o.getValue());
					zClusterList.add(o.getCell_type());

					List<Double> valueList = new ArrayList<Double>();
					valueList.add(o.getTsne_1());
					valueList.add(o.getTsne_2());
					dataList.add(valueList);
				}
			}

			JSONObject jsonData = new JSONObject();
			jsonData.put("vars", yCellIdList);
			jsonData.put("data", dataList);
			jsonData.put("gene", zGeneList);
			jsonData.put("expression", zExpressionList);
			jsonData.put("expression2", zExpression2List);
			jsonData.put("cluster", zClusterList);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(jsonData);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;

	}

	@RequestMapping(value = "/mo/third/scrnaview/violin_action.do")
	@ResponseBody
	public AjaxResult violin_action(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			OmicsDataUtils.makeUserGeneList(searchVO);
			List<String> geneList = searchVO.getUserGeneList();
			List<String> cellList = omicsService.selectScRnaCellIdListByGene(geneList.get(0));

			JSONObject jsonData = new JSONObject();
			jsonData.put("vars", geneList);
			jsonData.put("smps", cellList);

			JSONArray data = new JSONArray();
			for (String gene : geneList) {
				List<Integer> valueList = omicsService.selectScRnaValueListByGene(gene);
				data.add(valueList);
			}
			jsonData.put("data", data);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(jsonData);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;

	}

}
