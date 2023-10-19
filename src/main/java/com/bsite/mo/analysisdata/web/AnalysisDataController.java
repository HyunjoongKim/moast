package com.bsite.mo.analysisdata.web;

import java.io.File;
import java.net.InetAddress;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.mo.analysisdata.service.AnalysisDataService;
import com.bsite.mo.basic.service.HtPrimerResultService;
import com.bsite.mo.basic.service.MethylationService;
import com.bsite.mo.basic.service.VariantBedFileService;
import com.bsite.mo.basic.service.VariantService;
import com.bsite.vo.HtPrimerResultVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MethylationRecordVO;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.VariantRecordVO;
import com.bsite.vo.mo_analysisDataVO;
import com.bsite.vo.variant.VariantBEDFileVO;

import egovframework.com.cmm.EgovProperties;
import egovframework.com.cmm.EgovWebUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class AnalysisDataController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Resource(name = "AnalysisDataService")
	private AnalysisDataService analysisDataService;

	@Resource(name = "MethylationService")
	private MethylationService methylationService;

	@Resource(name = "HtPrimerResultService")
	private HtPrimerResultService htPrimerResultService;

	@Resource(name = "VariantService")
	private VariantService variantService;

	@Resource(name = "VariantBedFileService")
	private VariantBedFileService variantBedFileService;

	private final String IMAGE_UPLOAD_PATH = Paths.get(EgovProperties.getProperty("Globals.fileStorePath.LINUX"), "image").toString();

	@RequestMapping(value = "/mo/analysisdata/list.do")
	public String list(@ModelAttribute("searchVO") mo_analysisDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		searchVO.setSite_code(loginService.getSiteCode());

		try {
			Map<String, Object> map = analysisDataService.selectAnalysisDataList(searchVO);
			int resultCnt = Integer.parseInt((String) map.get("resultCnt"));

			@SuppressWarnings("unchecked")
			List<mo_analysisDataVO> resultList = (List<mo_analysisDataVO>) map.get("resultList");

			model.addAttribute("resultList", resultList);
			model.addAttribute("resultCnt", resultCnt);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/analysisdata/list";
	}

	@RequestMapping(value = "/mo/analysisdata/methylation/list.do")
	public String methylation_list(@RequestParam(name = "stu_idx", required = false) Integer std_idx, @ModelAttribute("searchVO") MethylationRecordVO searchVO,
			HttpServletRequest request, ModelMap model) throws Exception {

		searchVO.setSite_code(loginService.getSiteCode());

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex()); // 현재 페이지 번호
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit()); // 한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(searchVO.getPageSize()); // 페이징 리스트의 사이즈

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		if (std_idx != null)
			searchVO.setStd_idx(std_idx);

		try {
			List<MethylationRecordVO> resultList = methylationService.selectMethylationRecordList(searchVO);
			int resultCnt = methylationService.countMethylationRecordList(searchVO);

			paginationInfo.setTotalRecordCount(resultCnt);

			model.addAttribute("resultList", resultList);
			model.addAttribute("paginationInfo", paginationInfo);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/analysisdata/methylation/list";
	}

	@RequestMapping(value = "/mo/analysisdata/methylation/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String methylation_update(@RequestBody MethylationRecordVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		LoginVO loginVO = loginService.getLoginInfo();

		try {

			MethylationRecordVO existingMethylationRecord = methylationService.selectMethylationRecord(searchVO.getRecordIdx());

			if (existingMethylationRecord != null) {
				existingMethylationRecord.setComment(searchVO.getComment());

				existingMethylationRecord.setModi_id(loginVO.getId());
				existingMethylationRecord.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			}

			methylationService.save(existingMethylationRecord);

		} catch (Exception e) {
			logger.error("", e);
		}

		return null;
	}

	@RequestMapping(value = "/mo/analysisdata/methylation/read_marker.do")
	public String methylation_read_marker(@RequestParam("meth_idx") Integer methylation_idx, HttpServletRequest request, ModelMap model) throws Exception {

		try {
			MethylationRecordVO methylationRecord = methylationService.selectMethylationRecord(methylation_idx);

			model.addAttribute("result", methylationRecord);
			model.addAttribute("output_body", methylationRecord.getResultHtml());

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tilespopup:bsite/mo/basic/popup/blank_html";
	}

	@RequestMapping(value = "/mo/analysisdata/methylation/read_detail.do")
	public String methylation_read_detail(@RequestParam("meth_idx") Integer methylation_idx, HttpServletRequest request, ModelMap model) throws Exception {

		CommonFunctions cf = new CommonFunctions();

		try {
			MethylationRecordVO methylationRecord = methylationService.selectMethylationRecord(methylation_idx);

			for (HtPrimerResultVO htPrimerResult : methylationRecord.getHtPrimerResults()) {

				if (htPrimerResult.getImageFilename() != null && !htPrimerResult.getImageFilename().isEmpty()) {
					File imageFile = new File(IMAGE_UPLOAD_PATH + File.separator + htPrimerResult.getImageFilename());
					if (imageFile.exists() && imageFile.isFile()) {
						String base64ImageString = new String("data:image/jpg;base64," + cf.fileToBase64Encoding(imageFile.getPath()));
						htPrimerResult.setBase64Image(base64ImageString);
					}
				}
			}

			model.addAttribute("result", methylationRecord);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/analysisdata/methylation/read_detail";
	}

	@RequestMapping(value = "/mo/analysisdata/methylation/htprimer/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String methylation_update_htprimer(@RequestPart(name = "image", required = false) final MultipartFile image, HtPrimerResultVO searchVO, HttpServletRequest request,
			ModelMap model) throws Exception {
		LoginVO loginVO = loginService.getLoginInfo();

		String newFileName = null;
		if (image != null && !image.isEmpty()) {
			try {
				File saveFolder = new File(EgovWebUtil.filePathBlackList(IMAGE_UPLOAD_PATH));

				if (!saveFolder.exists() || saveFolder.isFile()) {
					saveFolder.mkdirs();
				}

				String originName = image.getOriginalFilename();

				int index = originName.lastIndexOf(".");
				String fileExt = originName.substring(index + 1);
				newFileName = UUID.randomUUID().toString() + "." + fileExt;
				String filePath = IMAGE_UPLOAD_PATH + File.separator + newFileName;

				image.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
			} catch (Exception e) {
				logger.error("", e);
			}
		}

		try {

			HtPrimerResultVO existingHtPrinmerResult = htPrimerResultService.selectHtPrimerResult(searchVO.getRecordIdx());

			if (existingHtPrinmerResult != null) {
				if (newFileName != null) {
					existingHtPrinmerResult.setImageFilename(newFileName);
					existingHtPrinmerResult.setImageUploadDate(new Date());
				}
				existingHtPrinmerResult.setOption1(searchVO.getOption1());
				existingHtPrinmerResult.setOption2(searchVO.getOption2());
				existingHtPrinmerResult.setComment(searchVO.getComment());

				existingHtPrinmerResult.setModi_id(loginVO.getId());
				existingHtPrinmerResult.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			}

			htPrimerResultService.save(existingHtPrinmerResult);

		} catch (Exception e) {
			logger.error("", e);
		}

		return null;
	}

	@RequestMapping(value = "/mo/analysisdata/variant/list.do")
	public String variant_list(@RequestParam(name = "stu_idx", required = false) Integer std_idx, @ModelAttribute("searchVO") VariantRecordVO searchVO, HttpServletRequest request,
			ModelMap model) throws Exception {

		searchVO.setSite_code(loginService.getSiteCode());

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex()); // 현재 페이지 번호
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit()); // 한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(searchVO.getPageSize()); // 페이징 리스트의 사이즈

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		if (std_idx != null)
			searchVO.setStd_idx(std_idx);

		try {
			List<VariantRecordVO> resultList = variantService.selectVariantRecordList(searchVO);
			int resultCnt = variantService.countVariantRecordList(searchVO);

			paginationInfo.setTotalRecordCount(resultCnt);

			model.addAttribute("resultList", resultList);
			model.addAttribute("paginationInfo", paginationInfo);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/analysisdata/variant/list";
	}

	@RequestMapping(value = "/mo/analysisdata/variant/read.do")
	@ResponseBody
	public Map<String, Object> variant_read(@RequestParam(name = "var_idx", required = true) Integer var_idx, HttpServletRequest request, HttpServletResponse response,
			ModelMap model) {

		response.setContentType("application/json; charset=UTF-8");
		response.setStatus(HttpStatus.SC_INTERNAL_SERVER_ERROR);
		VariantRecordVO vo = variantService.selectVariantRecord(var_idx);
		Map<String, Object> result = new HashMap<String, Object>();

		if (vo != null) {
			response.setStatus(HttpStatus.SC_OK);
			result.put("data", vo);
			result.put("res", "ok");
		} else {
			result.put("res", "error");
			result.put("msg", "Variant not found.");
		}
		return result;

	}

	@RequestMapping(value = "/mo/analysisdata/variant/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String variant_update(@RequestBody VariantRecordVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		LoginVO loginVO = loginService.getLoginInfo();

		try {

			VariantRecordVO existingVariantRecord = variantService.selectVariantRecord(searchVO.getRecordIdx());

			if (existingVariantRecord != null) {
				existingVariantRecord.setComment(searchVO.getComment());

				existingVariantRecord.setModi_id(loginVO.getId());
				existingVariantRecord.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			}

			variantService.save(existingVariantRecord);

		} catch (Exception e) {
			logger.error("", e);
		}

		return null;
	}

	@RequestMapping(value = "/mo/analysisdata/variant/read_detail.do", method = RequestMethod.GET)
	public String variant_read_detail(@RequestParam(name = "var_idx", required = true) Integer var_idx, HttpServletRequest request, HttpServletResponse response, ModelMap model) {

		try {
			VariantRecordVO variantRecord = variantService.selectVariantRecord(var_idx);

			model.addAttribute("variantRecord", variantRecord);

		} catch (Exception e) {
			logger.error("", e);
		}

		return "tiles:bsite/mo/analysisdata/variant/read_detail";
	}

	@RequestMapping(value = "/mo/analysisdata/variant/bed/read.do", method = RequestMethod.GET)
	@ResponseBody
	public String variant_bed_read(@RequestParam(name = "primerRecordIdx", required = false) Integer primerRecordIdx,
			@RequestParam(name = "blockerRecordIdx", required = false) Integer blockerRecordIdx, @RequestParam(name = "probeRecordIdx", required = false) Integer probeRecordIdx,
			HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		response.setContentType(MediaType.TEXT_PLAIN_VALUE);

		try {
			VariantBEDFileVO bedFile = variantBedFileService.get(primerRecordIdx, blockerRecordIdx, probeRecordIdx);
			if (bedFile != null) {
				return bedFile.getBedContent();
			}
		} catch (Exception e) {
			logger.error("", e);
		}

		return "";
	}
}
