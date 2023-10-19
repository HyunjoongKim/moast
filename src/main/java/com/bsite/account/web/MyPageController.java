package com.bsite.account.web;

import java.io.File;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.member.service.MemberManageService;
import com.bsite.account.service.AccountService;
import com.bsite.account.service.LoginService;
import com.bsite.account.service.MyPageService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.EgovFileScrty;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;


@Controller
public class MyPageController {

	private final static Logger logger = LoggerFactory.getLogger("com");
	private final String gErrorPage =  "tiles:bsite/common/msg";

	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "MyPageService")
    private MyPageService myPageService;

	@Resource(name = "AccountService")
    private AccountService accountService;

	@Resource(name = "MemberManageService")
    private MemberManageService memberManageService;

	@Resource(name = "EgovFileMngUtil")
    private EgovFileMngUtil fileUtil;

	@Resource(name = "EgovFileMngService")
    private EgovFileMngService fileMngService;


	//회원정보 조회
	@RequestMapping(value = "/myPage/info/read.do")
    public String read(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();

		searchVO.setMe_id(loginVO.getId());
		searchVO.setSite_code(loginService.getSiteCode());

		try{
			MemberVO memberVO = myPageService.getMemberVO(searchVO);
			model.addAttribute("memberVO", memberVO);

			//============================== 파일                 ================================
	    	FileVO fileVO = new FileVO();
    		fileVO.setAtchFileId(memberVO.getAtch_file_id());
    		List<FileVO> fileList = fileMngService.selectFileInfs(fileVO);

    		//이미지 불러와base64 변환후 다시 셋팅
    		CommonFunctions cf = new CommonFunctions();
    		if(fileList.size() > 0){
    			for(int i=0; i < fileList.size(); i++){

    				String extention = fileList.get(i).getFileExtsn().toLowerCase();	//여기랑 위에 함수처리좀 하자
			    	if(extention.equals("jpeg") || extention.equals("jpg") || extention.equals("bmp") ||
			    			extention.equals("png") || extention.equals("gif") ){
			    		fileList.get(i).setBase64Img("data:image/gif;base64,"+cf.fileToBase64Encoding(fileList.get(i).getFileStreCours()+"/"+fileList.get(i).getStreFileNm()));
			    	}
    			}
    		}
    		model.addAttribute("fileList", fileList);
	    	//============================== 파일                 ================================
    		
    		//직업
			List<CommonCodeVO> agTypeList = loginService.getDefaultCodeList("704"); 
	    	model.addAttribute("agTypeList", agTypeList);

		}catch(Exception e){
			System.out.println(e.toString());
    	}


		return "tiles:bsite/account/myPage/read";
	}

	//회원정보 수정
	@RequestMapping(value = "/myPage/info/update.do")
    public String update(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();

		searchVO.setMe_id(loginVO.getId());
		searchVO.setSite_code(loginService.getSiteCode());


		List<CommonCodeVO> orgTypeList = loginService.getDefaultCodeList("261");			//체험처 유형
		model.addAttribute("orgTypeList", orgTypeList);


		try{
			MemberVO memberVO = myPageService.getMemberVO(searchVO);
			model.addAttribute("memberVO", memberVO);

			//============================== 파일                 ================================
	    	/*************************************************************************
	    	 ***************전역 공지 파일 처리는 아직 하지 않음   *********************************
	    	 *************************************************************************/
	    	FileVO fileVO = new FileVO();
    		fileVO.setAtchFileId(memberVO.getAtch_file_id());
    		List<FileVO> fileList = fileMngService.selectFileInfs(fileVO);

    		//이미지 불러와base64 변환후 다시 셋팅
    		CommonFunctions cf = new CommonFunctions();
    		if(fileList.size() > 0){
    			for(int i=0; i < fileList.size(); i++){

    				String extention = fileList.get(i).getFileExtsn().toLowerCase();	//여기랑 위에 함수처리좀 하자
			    	if(extention.equals("jpeg") || extention.equals("jpg") || extention.equals("bmp") ||
			    			extention.equals("png") || extention.equals("gif") ){
			    		fileList.get(i).setBase64Img("data:image/gif;base64,"+cf.fileToBase64Encoding(fileList.get(i).getFileStreCours()+"/"+fileList.get(i).getStreFileNm()));
			    	}
    			}
    		}
    		model.addAttribute("fileList", fileList);
	    	//============================== 파일                 ================================


    		//직업
			List<CommonCodeVO> agTypeList = loginService.getDefaultCodeList("704"); 
	    	model.addAttribute("agTypeList", agTypeList);

		}catch(Exception e){
			System.out.println(e.toString());
    	}


		return "tiles:bsite/account/myPage/update";
	}

	//회원정보 수정
	@RequestMapping(value = "/myPage/info/update_action.do", method = RequestMethod.POST)
    public String update_action(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		RedirectAttributes redirectAttributes,
    		final MultipartHttpServletRequest multiRequest,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();


		Map<String, Object> resMap = new HashMap<String, Object>();

		try{
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			//---------------- 파일 처리  ----------------------
			 List<FileVO> result = null;

			 String atchFileId = "";
			 final Map<String, MultipartFile> files = multiRequest.getFileMap();
			 if (!files.isEmpty()) { //이놈이 파일있나없나는 구분해주지 못한다.
				 atchFileId = fileMngService.getAtchNextFileId(); //따로 구함 전자정부 idgen 방식 은 안씀 COMTCOPSEQ 테이블은 없어도 됨
				 //System.out.println("atchFileId : "+atchFileId);
				 result = fileUtil.parseFileInf(files, "MEMBER_", 0,atchFileId, "member/"+searchVO.getSite_code() ,searchVO.getSite_code());

				//확장자 검사
				boolean denyFile = false;
				for(FileVO file : result ){
					if(CommonFunctions.denyfileExtention(file.getFileExtsn())== true) denyFile=true; break;
				}
				if(denyFile==true){
					model.addAttribute("errorMsg", "허용되지 않는 확장자가 있습니다. 보안을위해 메인페이지로 이동합니다.");
					return gErrorPage;
				}
				fileMngService.insertFileInfs(result);

			 }//End if files.isEmpty
			 //System.out.println("result.size() : "+result.size());
	    	if(result != null && result.size()>0) searchVO.setAtch_file_id(atchFileId); //파일이 있으면 셋팅


			memberManageService.updateMemberVO(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "수정하였습니다.");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}


		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/myPage/info/read.do";
	}

	//비밀번호 변경
	@RequestMapping(value = "/myPage/info/update_pw.do")
    public String update_pw(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();


		return "tiles:bsite/account/myPage/update_pw";
	}

	//비밀번호 변경 실행
	@RequestMapping(value = "/myPage/info/update_pw_action.do", method = RequestMethod.POST)
    public String update_pw_action(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		RedirectAttributes redirectAttributes,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();


		Map<String, Object> resMap = new HashMap<String, Object>();

		try{
			String nowPassword = request.getParameter("nowPassword");
			String newPassword = request.getParameter("newPassword");



			searchVO.setMe_id(loginVO.getId());
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			MemberVO memberVO = myPageService.getMemberVO(searchVO);

			if(!EgovFileScrty.encryptPassword(nowPassword).equals(memberVO.getMe_pwd())){
				resMap.put("res", "ok");
				resMap.put("msg", "기존 비밀번호가 다릅니다. 다시 시도해주세요.");
			}else{
				searchVO.setMe_pwd(EgovFileScrty.encryptPassword(newPassword));
				memberManageService.updatePassword(searchVO);

				resMap.put("res", "ok");
				resMap.put("msg", "수정하였습니다.");
			}

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}


		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/myPage/info/read.do";
	}

	//파일 삭제
	@RequestMapping(value = "/myPage/info/update_del_file.do")
    public String update_del_file(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		RedirectAttributes redirectAttributes,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO user = loginService.getLoginInfo();
	    String atchFileId = request.getParameter("atchFileId");
	    String fileSn = request.getParameter("fileSn");

	      	try{
			    if(StringUtils.isEmpty(atchFileId)){
					model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 1");
					return gErrorPage;
				}

		    	Boolean denyFile;
		        FileVO fileVO = new FileVO();
		        fileVO.setAtchFileId(atchFileId);
		        fileVO.setFileSn(fileSn);
		        fileVO.setSite_code(loginService.getSiteCode());

		        FileVO fvo = fileMngService.selectFileInf(fileVO);

		        if(fvo == null){
		        	model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 2");
		        	return gErrorPage;
		        }
		        denyFile = CommonFunctions.denyfileExtention(fvo.getFileExtsn());

		        if(denyFile==true){
					model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 3");
					return gErrorPage;
				}


		        //이제 할거.
		        //실제파일 삭제하고 삭제 여부에따라 DB삭제. 마지막놈 지워지면 파일 메인테이블 ROW 도 삭제
		        String rUrl = fvo.getFileStreCours()+"/"+fvo.getStreFileNm();
		        File f = new File(rUrl);
		        if(f.exists() == true){
		            if (f.delete()) {
		            //if(true){//임시
		            	/*************************  삭제성공 DB 삭제 준비   ************************************/
		            		//지금 지우려는 파일 카운트가 1이면 메인테이블도 삭제
		            		//아니면 서브테이블만 삭제
		            		int remainCnt = fileMngService.getSubFileTableRow(atchFileId);
		            		fileMngService.deleteFileTableRow(remainCnt,fvo);

		            	/*************************  삭제성공 DB 삭제 준비   ************************************/
		            	f = null;
		            }else{
		            	f = null;
		            	model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 4");
		            	return gErrorPage;
		            }

		            //----------------썸네일 실제 파일 삭제 ------------------------------
			        String trUrl = fvo.getFileStreCours()+"/Thum_"+fvo.getStreFileNm();
			        File tf = new File(trUrl);
			        if(tf.exists() == true) tf.delete();
			        tf = null;
			        //----------------썸네일 실제 파일 삭제 ------------------------------
		        }else{
		        	f = null;
		        	model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 5");
		        	return gErrorPage;
		        }


	      	}catch(Exception e){
	      		model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. Exception : "+e.toString());
	      		return gErrorPage;
	      	}



	        model.addAttribute("errorMsg", "해당파일을 삭제하였습니다.");
	        model.addAttribute("goUrl", "/myPage/info/update.do");
	        return gErrorPage;
	}


}
