package com.bsite.mo.addgeneset.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.mo.visual.service.OmicsService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.PythonAPI;
import com.bsite.cmm.PythonAPI.PathwayType;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.mo_pathwayVO;

@Controller
public class AddGeneSetController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "OmicsService")
	private OmicsService omicsService;

	@RequestMapping(value = "/mo/addgeneset/list.do")
	public String list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		try {
			List<String> geneList = omicsService.selectEpicGeneList();
			net.sf.json.JSONArray jsonArray = net.sf.json.JSONArray.fromObject(geneList);
			model.addAttribute("jsonArray", jsonArray);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/addgeneset/list";
	}

	@RequestMapping(value = "/mo/addgeneset/list_go_ajax.do")
	@ResponseBody
	public AjaxResult list_go_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			int page = 1;
			String query = searchVO.getPublicInput();

			String encodedQuery = URLEncoder.encode(query, "UTF-8");

			List<String> geneList = new ArrayList<String>();
			JSONObject json = null;

			do {
				json = getGoApi(encodedQuery, page);
				List<String> list = getGeneSymbols(json);
				geneList.addAll(list);
				page++;
			} while (morePage(json));

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(geneList);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;

	}

	@RequestMapping(value = "/mo/addgeneset/list_kegg_ajax.do")
	@ResponseBody
	public AjaxResult list_kegg_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			String query = searchVO.getPublicInput();
			String encodedQuery = URLEncoder.encode(query, "UTF-8");

			List<mo_pathwayVO> list = PythonAPI.callPathwayGenes(PathwayType.KEGG, encodedQuery);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(list);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;

	}

	@RequestMapping(value = "/mo/addgeneset/list_msigdb_ajax.do")
	@ResponseBody
	public AjaxResult list_msigdb_ajax(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		AjaxResult resMap = new AjaxResult();
		try {

			String query = searchVO.getPublicInput();
			String encodedQuery = URLEncoder.encode(query, "UTF-8");

			List<mo_pathwayVO> list = PythonAPI.callPathwayGenes(PathwayType.MsigDB, encodedQuery);

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(list);

		} catch (Exception e) {
			logger.error("", e);
		}
		return resMap;

	}

	private List<String> getGeneSymbols(JSONObject json) {
		List<String> list = new ArrayList<String>();

		JSONArray results = (JSONArray) json.get("results");
		for (Object o : results) {
			JSONObject item = (JSONObject) o;
			String symbol = (String) item.get("symbol");
			list.add(symbol);
		}

		return list;
	}

	private boolean morePage(JSONObject json) {
		JSONObject pageInfo = (JSONObject) json.get("pageInfo");
		Long current = (Long) pageInfo.get("current");
		Long total = (Long) pageInfo.get("total");

		return current < total;
	}

	private JSONObject getGoApi(String query, int page) throws Exception {

		String requestURL = "https://www.ebi.ac.uk/QuickGO/services/geneproduct/search?taxonId=9606&type=protein&dbSubset=Swiss-Prot&limit=50&page=" + page + "&query=" + query;
		URL url = new URL(requestURL);

		URLConnection connection = url.openConnection();
		HttpURLConnection httpConnection = (HttpURLConnection) connection;

		httpConnection.setRequestProperty("Accept", "application/json");

		InputStream response = connection.getInputStream();
		int responseCode = httpConnection.getResponseCode();

		if (responseCode != 200) {
			throw new RuntimeException("Response code was not 200. Detected response was " + responseCode);
		}

		String output;
		Reader reader = null;
		try {
			reader = new BufferedReader(new InputStreamReader(response, "UTF-8"));
			StringBuilder builder = new StringBuilder();
			char[] buffer = new char[8192];
			int read;
			while ((read = reader.read(buffer, 0, buffer.length)) > 0) {
				builder.append(buffer, 0, read);
			}
			output = builder.toString();
		} finally {
			if (reader != null)
				try {
					reader.close();
				} catch (IOException logOrIgnore) {
					logOrIgnore.printStackTrace();
				}
		}

		JSONParser parser = new JSONParser();
		Object obj = parser.parse(output);

		return (JSONObject) obj;
	}

}
