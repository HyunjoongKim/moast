package com.bsite.mo.third.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.bsite.account.service.LoginService;
import com.bsite.vo.AjaxResult;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.ToolsResultVO;

import egovframework.com.cmm.service.Globals;

@Controller
public class SamController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@RequestMapping(value = "/mo/third/sam/list.do")
	public String samlist(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String toolsDir = (String) session.getAttribute("toolsDir");

		if (StringUtils.isEmpty(toolsDir)) {
			toolsDir = new SimpleDateFormat("yyyyMMdd_HHmmssSSS").format(Calendar.getInstance().getTime());
			session.setAttribute("toolsDir", toolsDir);
		}

		return "tiles:bsite/mo/third/sam/list";
	}

	@RequestMapping(value = "/mo/third/vcf/list.do")
	public String vcflist(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		
		return "tiles:bsite/mo/third/vcf/list";
	}

	@RequestMapping(value = "/mo/third/bed/list.do")
	public String bedlist(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		
		return "tiles:bsite/mo/third/bed/list";
	}

	@RequestMapping(value = "/mo/third/sam/extract_action.do", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResult extract_action(@ModelAttribute("searchVO") OmicsDataVO searchVO, @RequestParam("inputFile") MultipartFile inputFile, HttpServletRequest request) {
		AjaxResult resMap = new AjaxResult();

		try {
			HttpSession session = request.getSession();
			String toolsDir = (String) session.getAttribute("toolsDir");
			searchVO.setToolsDir(toolsDir);
			searchVO.setToolsExtractFile("chr" + searchVO.getBe_Chr_name() + "." + searchVO.getBe_start() + "_" + searchVO.getBe_end() + ".bam");

			OmicsDataUtils.uploadToolsFile(inputFile, searchVO);

			if (!Globals.IS_LOCAL) {
				OmicsDataUtils.excuteExtractBam(searchVO);
			}

			ToolsResultVO vo = new ToolsResultVO();
			vo.setFileFormat("BAM");
			vo.setFileName(searchVO.getToolsExtractFile());

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(vo);
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;
	}

	@RequestMapping(value = "/mo/third/sam/sam_action.do", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResult sam_action(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request) {
		AjaxResult resMap = new AjaxResult();

		try {
			HttpSession session = request.getSession();
			String toolsDir = (String) session.getAttribute("toolsDir");
			searchVO.setToolsDir(toolsDir);
			searchVO.setOutputSamFile(searchVO.getInputSamFile() + "." + searchVO.getOutputSamFormat().toLowerCase());

			if (Globals.IS_LOCAL) {
				searchVO.setToolsDir("20230101_010101001");
			} else {
				OmicsDataUtils.excuteSamTools(searchVO);
			}

			ToolsResultVO vo = new ToolsResultVO();
			vo.setFileFormat(searchVO.getOutputSamFormat());
			vo.setFileName(searchVO.getOutputSamFile());

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(vo);
		} catch (Exception e) {
			logger.error("", e);
			resMap.setRes("error");
			resMap.setMsg("작업중 오류가 발생하였습니다.");
		}

		return resMap;
	}

	@RequestMapping(value = "/mo/third/sam/bed_action.do", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResult bed_action(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request) {
		AjaxResult resMap = new AjaxResult();

		try {
			HttpSession session = request.getSession();
			String toolsDir = (String) session.getAttribute("toolsDir");
			searchVO.setToolsDir(toolsDir);
			searchVO.setOutputBedFile(searchVO.getInputBedFile() + "." + searchVO.getOutputBedFormat().toLowerCase());

			if (Globals.IS_LOCAL) {
				searchVO.setToolsDir("20230101_010101001");
			} else {
				OmicsDataUtils.excuteBedTools(searchVO);
			}

			ToolsResultVO vo = new ToolsResultVO();
			vo.setFileFormat(searchVO.getOutputBedFormat());
			vo.setFileName(searchVO.getOutputBedFile());

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(vo);
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;
	}

	@RequestMapping(value = "/mo/third/sam/vcf_action.do", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResult vcf_action(@ModelAttribute("searchVO") OmicsDataVO searchVO, @RequestParam("inputFile") MultipartFile inputVcfFile, HttpServletRequest request) {
		AjaxResult resMap = new AjaxResult();

		try {
			HttpSession session = request.getSession();
			String toolsDir = (String) session.getAttribute("toolsDir");
			searchVO.setToolsDir(toolsDir);

			String inputFile = OmicsDataUtils.uploadToolsFile(inputVcfFile, searchVO);
			searchVO.setInputVcfFile(inputFile);
			searchVO.setOutputVcfFile(inputFile + "." + searchVO.getOutputVcfFormat().toLowerCase());

			if (Globals.IS_LOCAL) {
				searchVO.setToolsDir("20230101_010101001");
			} else {
				OmicsDataUtils.excuteVcfTools(searchVO);
			}

			ToolsResultVO vo = new ToolsResultVO();
			vo.setFileFormat(searchVO.getOutputVcfFormat());
			vo.setFileName(searchVO.getOutputVcfFile());

			resMap.setRes("ok");
			resMap.setMsg("Task completed.");
			resMap.setData(vo);
		} catch (Exception e) {
			logger.error("", e);
		}

		return resMap;
	}

	@RequestMapping(value = { "/mo/third/sam/download.do" })
	public void downloadOutput(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		try {

			String toolsDir = (String) session.getAttribute("toolsDir");
			searchVO.setToolsDir(toolsDir);

			if (Globals.IS_LOCAL) {
				searchVO.setToolsDir("20230101_010101001");
				String file = searchVO.getToolsOutputFile();
				searchVO.setToolsOutputFile("output." + FilenameUtils.getExtension(file));
			}
			OmicsDataUtils.downToolsFile(request, response, session, searchVO.getToolsDir(), searchVO.getToolsOutputFile());
		} catch (Exception e) {
			logger.error("", e);
		}
	}

}
