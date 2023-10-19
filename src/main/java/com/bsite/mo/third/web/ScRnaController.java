package com.bsite.mo.third.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.bsite.account.service.LoginService;
import com.bsite.vo.OmicsDataVO;

import egovframework.com.cmm.service.Globals;

@Controller
public class ScRnaController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@Resource(name = "LoginService")
	private LoginService loginService;

	@RequestMapping(value = "/mo/third/scrna/list.do")
	public String list(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {
		
		return "tiles:bsite/mo/third/scrna/list";
	}
	
	@RequestMapping(value = "/mo/third/scrna/list2.do")
	public String list2(@ModelAttribute("searchVO") OmicsDataVO searchVO, HttpServletRequest request, ModelMap model) throws Exception {

		List<String> imageList = OmicsDataUtils.getScRnaBase64ImageList();
		model.addAttribute("imageList", imageList);
		
		return "tiles:bsite/mo/third/scrna/list";
	}

	@RequestMapping(value = "/mo/third/scrna/upload.do", method = RequestMethod.POST)
	public String upload(@ModelAttribute("searchVO") OmicsDataVO searchVO, 
			ModelMap model, HttpSession session, HttpServletRequest request, 
			final MultipartHttpServletRequest multiRequest)
			throws Exception {
		
		try {
			MultipartFile barcodeFile = multiRequest.getFile("barcodeFile");
			OmicsDataUtils.uploadScRna(barcodeFile, "barcodes.tsv");
			
			MultipartFile genesFile = multiRequest.getFile("genesFile");
			OmicsDataUtils.uploadScRna(genesFile, "genes.tsv");
			
			MultipartFile matrixFile = multiRequest.getFile("matrixFile");
			OmicsDataUtils.uploadScRna(matrixFile, "matrix.mtx");

			if (!Globals.IS_LOCAL) {
				if (searchVO.getUd_idx() == 2) {
					searchVO.setStd_idx(336);
				} else {
					searchVO.setStd_idx(0);
				}
				OmicsDataUtils.excuteScRna(searchVO);
			}
			
			List<String> imageList = OmicsDataUtils.getScRnaBase64ImageList();
			model.addAttribute("imageList", imageList);
			
		} catch (Exception e) {
			logger.error("", e);
			throw new RuntimeException();
		}

		
		return "tiles:bsite/mo/third/scrna/list";
	}

	@RequestMapping(value = "/mo/third/scrna/down.do")
	public void down(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		String idx = request.getParameter("idx");

		try {
			String path = "/home/multiomics/scRNA/filtered_gene_bc_matrices/hg19/";
			if ("1".equals(idx)) {
				path += "barcodes.tsv";
			} else if ("2".equals(idx)) {
				path += "genes.tsv";
			} else if ("3".equals(idx)) {
				path += "matrix.mtx";
			}

			File file = new File(path);
			response.setHeader("Content-Disposition", "attachment;filename=" + file.getName());

			try (FileInputStream fileInputStream = new FileInputStream(path)) {
				OutputStream out = response.getOutputStream();

				int read = 0;
				byte[] buffer = new byte[1024];
				while ((read = fileInputStream.read(buffer)) != -1) {
					out.write(buffer, 0, read);
				}
			}

		} catch (Exception e) {
			throw new Exception("download error");
		}

	}

}
