package egovframework.com.cmm.web;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bsite.account.service.LoginService;
import com.bsite.vo.LoginVO;

import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.FileVO;

/**
 * 파일 조회, 삭제, 다운로드 처리를 위한 컨트롤러 클래스
 * @author 공통서비스개발팀 이삼섭
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.3.25  이삼섭          최초 생성
 *
 * </pre>
 */
@Controller
public class EgovFileMngController {


	@Resource(name = "LoginService")
	private LoginService loginService;

    @Resource(name = "EgovFileMngService")
    private EgovFileMngService fileService;

    private static final Logger LOG = LoggerFactory.getLogger("com");

    /**
     * 첨부파일에 대한 목록을 조회한다.
     *
     * @param fileVO
     * @param atchFileId
     * @param sessionVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/cmm/fms/selectFileInfs.do")
    public String selectFileInfs(@ModelAttribute("searchVO") FileVO fileVO, HttpServletRequest request, Map<String, Object> commandMap, ModelMap model) throws Exception {
	//String atchFileId = (String)commandMap.get("param_atchFileId");
	String atchFileId = request.getParameter("param_atchFileId");
	fileVO.setAtchFileId(atchFileId);
	List<FileVO> result = fileService.selectFileInfs(fileVO);

	model.addAttribute("fileList", result);
	model.addAttribute("updateFlag", "N");
	model.addAttribute("fileListCnt", result.size());
	model.addAttribute("atchFileId", atchFileId);

	return "/egovframework/com/cmm/fms/EgovFileList";
    }

    @RequestMapping("/cmm/fms/getImagePrint.do")  //게시판 이미지 만큰 본문에 표현 시키기
    public String getImagePrint(@ModelAttribute("searchVO") FileVO fileVO,HttpServletRequest req ,Map<String, Object> commandMap, ModelMap model) throws Exception {
	//String atchFileId = (String)commandMap.get("param_atchFileId");
	String atchFileId =req.getParameter("param_atchFileId"); 
	
		fileVO.setAtchFileId(atchFileId);
		List<FileVO> result = fileService.selectFileInfs(fileVO);

		model.addAttribute("fileList", result);
		model.addAttribute("atchFileId", atchFileId);
	return "/egovframework/com/cmm/fms/getImagePrint";
    }


    @RequestMapping("/cmm/fms/getImagePrintFlush.do")  //게시판 이미지 만큰 본문에 표현 시키기
    public void getImagePrintFlush(@ModelAttribute("searchVO") FileVO fileVO,
    								Map<String, Object> commandMap,
    								HttpServletRequest request,
    								HttpServletResponse response,
    								ModelMap model) throws Exception {
    	LoginVO loginVO = loginService.getLoginInfo();

    	String atchFileId = request.getParameter("param_atchFileId");
    	String fileSn     = request.getParameter("fileSn");



    	File file = null;
		FileInputStream fis = null;

		BufferedInputStream in = null;
		ByteArrayOutputStream bStream = null;

   		try{
   			fileVO.setSite_code(loginVO.getSite_code());
   			fileVO.setAtchFileId(atchFileId);
   			fileVO.setFileSn(fileSn);
   			FileVO fileDetail = fileService.selectFileInf(fileVO);

   			String url = fileDetail.getFileStreCours()+"/"+fileDetail.getStreFileNm();
   			String thumUrl = "";
   			file = new File(thumUrl);
   			//System.out.println("thumUrl"+ thumUrl);

   			if(!file.exists()){
   				file =null;
   				file = new File(url);
   			}




   			fis = new FileInputStream(file);
   			in = new BufferedInputStream(fis);
		    bStream = new ByteArrayOutputStream();

		    int imgByte;
		    while ((imgByte = in.read()) != -1) {
		    	bStream.write(imgByte);
		    }


		    String type = "";

			if (fileDetail.getFileExtsn() != null && !"".equals(fileDetail.getFileExtsn())) {
			    if ("jpg".equals(fileDetail.getFileExtsn().toLowerCase())) {
				type = "image/jpeg";
			    } else {
				type = "image/" + fileDetail.getFileExtsn().toLowerCase();
			    }
			    type = "image/" + fileDetail.getFileExtsn().toLowerCase();

			} else {
			    LOG.debug("Image fileType is null.");
			}

			response.setHeader("Content-Type", type);
			response.setContentLength(bStream.size());

			bStream.writeTo(response.getOutputStream());

			response.getOutputStream().flush();
			response.getOutputStream().close();

   		}catch(Exception e){
   			System.out.println("Exception :"+ e.getCause());
   		}finally{
   			if (bStream != null) {
				try {
					bStream.close();
				} catch (Exception ignore) {
					//System.out.println("IGNORE: " + ignore);
					LOG.debug("IGNORE: " + ignore.getMessage());
				}
			}
			if (in != null) {
				try {
					in.close();
				} catch (Exception ignore) {
					//System.out.println("IGNORE: " + ignore);
					LOG.debug("IGNORE: " + ignore.getMessage());
				}
			}
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					//System.out.println("IGNORE: " + ignore);
					LOG.debug("IGNORE: " + ignore.getMessage());
				}
			}
   		}//end try finally
    }//end getImage








    @RequestMapping("/cmm/fms/selectFileInfsByFileName.do")
    public String selectFileInfsByFileName(@ModelAttribute("searchVO") FileVO fileVO, Map<String, Object> commandMap, ModelMap model) throws Exception {

    String atchFileId = (String)commandMap.get("param_atchFileId");
    String streFileName = (String)commandMap.get("param_fileName");

    fileVO.setAtchFileId(atchFileId);
	fileVO.setStreFileNm(streFileName);
	List<FileVO> result = fileService.selectFileInfsByFileName(fileVO);

	model.addAttribute("fileList", result);
	model.addAttribute("updateFlag", "N");
	model.addAttribute("fileListCnt", result.size());
	model.addAttribute("atchFileId", atchFileId);

	return "/egovframework/com/cmm/fms/EgovFileListByFileName";
    }

    /**
     * 첨부파일 변경을 위한 수정페이지로 이동한다.
     *
     * @param fileVO
     * @param atchFileId
     * @param sessionVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/cmm/fms/selectFileInfsForUpdate.do")
    public String selectFileInfsForUpdate(@ModelAttribute("searchVO") FileVO fileVO, Map<String, Object> commandMap,
    		HttpServletRequest request,
	    //SessionVO sessionVO,
	    ModelMap model) throws Exception {

	//String atchFileId = (String)commandMap.get("param_atchFileId");
	String atchFileId = request.getParameter("param_atchFileId");

	fileVO.setAtchFileId(atchFileId);

	List<FileVO> result = fileService.selectFileInfs(fileVO);

	model.addAttribute("fileList", result);
	model.addAttribute("updateFlag", "Y");
	model.addAttribute("fileListCnt", result.size());
	model.addAttribute("atchFileId", atchFileId);

	return "/egovframework/com/cmm/fms/EgovFileList";
    }

    @RequestMapping("/cmm/fms/selectFileInfsForUpdateByFileName.do")
    public String selectFileInfsForUpdateByFileName(@ModelAttribute("searchVO") FileVO fileVO, Map<String, Object> commandMap,
	    //SessionVO sessionVO,
	    ModelMap model) throws Exception {

	String atchFileId = (String)commandMap.get("param_atchFileId");
	String streFileName = (String)commandMap.get("param_fileName");
	String returnUrl = (String)commandMap.get("returnUrl");

	fileVO.setAtchFileId(atchFileId);
	fileVO.setStreFileNm(streFileName);

	List<FileVO> result = fileService.selectFileInfsByFileName(fileVO);

	model.addAttribute("fileList", result);
	model.addAttribute("updateFlag", "Y");
	model.addAttribute("fileListCnt", result.size());
	model.addAttribute("atchFileId", atchFileId);
	model.addAttribute("returnUrl", returnUrl);

	return "/egovframework/com/cmm/fms/EgovFileListByFileName";
    }

    /**
     * 첨부파일에 대한 삭제를 처리한다.
     *
     * @param fileVO
     * @param returnUrl
     * @param sessionVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/cmm/fms/deleteFileInfs.do")
    public String deleteFileInf(@ModelAttribute("searchVO") FileVO fileVO, @RequestParam("returnUrl") String returnUrl,
	    //SessionVO sessionVO,
	    HttpServletRequest request,
	    ModelMap model) throws Exception {

	//Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

	//if (isAuthenticated) {
		if(!StringUtils.isEmpty(fileVO.getAtchFileId())){
		    fileService.deleteFileInf(fileVO);

		}
	//}

	//--------------------------------------------
	// contextRoot가 있는 경우 제외 시켜야 함
	//--------------------------------------------
	////return "forward:/cmm/fms/selectFileInfs.do";
	//return "forward:" + returnUrl;

	if ("".equals(request.getContextPath()) || "/".equals(request.getContextPath())) {
	    return "forward:" + returnUrl;
	}

	if (returnUrl.startsWith(request.getContextPath())) {
	    return "forward:" + returnUrl.substring(returnUrl.indexOf("/", 1));
	} else {
	    return "forward:" + returnUrl;
	}
	////------------------------------------------
    }

    /**
     * 이미지 첨부파일에 대한 목록을 조회한다.
     *
     * @param fileVO
     * @param atchFileId
     * @param sessionVO
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/cmm/fms/selectImageFileInfs.do")
    public String selectImageFileInfs(@ModelAttribute("searchVO") FileVO fileVO, Map<String, Object> commandMap,
    		HttpServletRequest request,
	    //SessionVO sessionVO,
	    ModelMap model) throws Exception {

	//String atchFileId = (String)commandMap.get("atchFileId");
	String atchFileId = request.getParameter("atchFileId");

	fileVO.setAtchFileId(atchFileId);
	List<FileVO> result = fileService.selectImageFileList(fileVO);

	model.addAttribute("fileList", result);

	return "/egovframework/com/cmm/fms/EgovImgFileList";
    }
}
