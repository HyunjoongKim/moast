package egovframework.com.cmm.web;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bsite.account.service.LoginService;

import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.FileVO;


/**
 * @Class Name : EgovImageProcessController.java
 * @Description :
 * @Modification Information
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *    2009. 4. 2.     이삼섭
 *
 * @author 공통 서비스 개발팀 이삼섭
 * @since 2009. 4. 2.
 * @version
 * @see
 *
 */
@SuppressWarnings("serial")
@Controller
public class EgovImageProcessController extends HttpServlet {

    @Resource(name = "EgovFileMngService")
    private EgovFileMngService fileService;

    @Resource(name = "LoginService")
    private LoginService loginService;

    private static final Logger LOG = LoggerFactory.getLogger("com");

    /**
     * 첨부된 이미지에 대한 미리보기 기능을 제공한다.
     *
     * @param atchFileId
     * @param fileSn
     * @param sessionVO
     * @param model
     * @param response
     * @throws Exception
     */
    @RequestMapping("/cmm/fms/getImage.do")
    public void getImageInf(ModelMap model, Map<String, Object> commandMap, HttpServletResponse response,HttpServletRequest request) throws Exception {

		//@RequestParam("atchFileId") String atchFileId,
		//@RequestParam("fileSn") String fileSn,
		//String atchFileId = (String)commandMap.get("atchFileId");
		//String fileSn = (String)commandMap.get("fileSn");
		String atchFileId = request.getParameter("atchFileId");
		String fileSn = request.getParameter("fileSn");

		FileVO vo = new FileVO();

		vo.setAtchFileId(atchFileId);
		vo.setFileSn(fileSn);
		vo.setSite_code(loginService.getSiteCode());

		FileVO fvo = fileService.selectFileInf(vo);

		//String fileLoaction = fvo.getFileStreCours() + fvo.getStreFileNm();

		// 2011.10.10 보안점검 후속조치
		File file = null;
		FileInputStream fis = null;

		BufferedInputStream in = null;
		ByteArrayOutputStream bStream = null;






		try {

		    //file = new File(fvo.getFileStreCours(), fvo.getStreFileNm());

		    String url = fvo.getFileStreCours()+"/"+ fvo.getStreFileNm();
   			String thumUrl = fvo.getFileStreCours()+"/Thum_"+ fvo.getStreFileNm();
   			file = new File(thumUrl);
   			//System.out.println("thumUrl"+ thumUrl);

   			/*if(!file.exists()){
   				file =null;
   				file = new File(url);
   			}*/

   			if(file.exists()){
			    fis = new FileInputStream(file);
	
			    in = new BufferedInputStream(fis);
			    bStream = new ByteArrayOutputStream();
	
			    int imgByte;
			    while ((imgByte = in.read()) != -1) {
				bStream.write(imgByte);
			    }
	
				String type = "";
	
				if (fvo.getFileExtsn() != null && !"".equals(fvo.getFileExtsn())) {
				    if ("jpg".equals(fvo.getFileExtsn().toLowerCase())) {
					type = "image/jpeg";
				    } else {
					type = "image/" + fvo.getFileExtsn().toLowerCase();
				    }
				    type = "image/" + fvo.getFileExtsn().toLowerCase();
	
				} else {
				    LOG.debug("Image fileType is null.");
				}
	
				response.setHeader("Content-Type", type);
				response.setContentLength(bStream.size());
	
				bStream.writeTo(response.getOutputStream());
	
				response.getOutputStream().flush();
				response.getOutputStream().close();
   			}
			// 2011.10.10 보안점검 후속조치 끝
		} finally {
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
		}
    }
}
