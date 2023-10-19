package com.adms.member.web;

import java.io.File;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.log.service.AdminLogService;
import com.adms.member.service.MemberManage2Service;
import com.adms.member.service.MemberManageService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.vo.AuthVO;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;
import com.bsite.vo.tbl_adminLogVO;



import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class MemberManageController {

	private final static Logger logger = LoggerFactory.getLogger("com");
	private final String LEFT_MENU_GROUP = "member_list"; //left select menu name
	private final String gErrorPage =  "tiles:bsite/common/msg";
	
	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "MemberManageService")
    private MemberManageService memberManageService;

	@Resource(name = "MemberManage2Service")
    private MemberManage2Service memberManage2Service;
	
	@Resource(name = "EgovFileMngUtil")
    private EgovFileMngUtil fileUtil;
	
	@Resource(name = "EgovFileMngService")
    private EgovFileMngService fileMngService;

	
	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	@Resource(name = "AdminLogService")
    private AdminLogService adminLogService;
	
	
	//회원 목록
	@RequestMapping(value ="/adms/member/memberManage/list.do")
    public String list(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();
		searchVO.setSite_code(loginService.getSiteCode());

		try{
			//권한 목록
			Map<String, Object> searchMap = new HashMap<String, Object>();
			searchMap.put("site_code", loginService.getSiteCode());

			List<AuthVO> authList = memberManage2Service.getAuthList(searchMap);
			model.addAttribute("authList", authList);
			
			List<CommonCodeVO> memTypeList = loginService.getDefaultCodeList("414");		//회원구분
	    	model.addAttribute("memTypeList", memTypeList);

			/* 페이징 시작 */
	    	PaginationInfo paginationInfo = new PaginationInfo();

	    	paginationInfo.setCurrentPageNo(searchVO.getPageIndex());		//현재 페이지 번호
	    	paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());	//한 페이지에 게시되는 게시물 건수
	    	paginationInfo.setPageSize(searchVO.getPageSize());				//페이징 리스트의 사이즈

	    	searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
	    	searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
	    	searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

	    	Map<String, Object> map = memberManage2Service.getMemberList(searchVO);
	    	int totCnt = Integer.parseInt((String)map.get("resultCnt"));

	    	paginationInfo.setTotalRecordCount(totCnt);

	    	model.addAttribute("resultList", map.get("resultList"));
	    	model.addAttribute("resultCnt", map.get("resultCnt"));
	    	model.addAttribute("totalPageCnt", (int)Math.ceil(totCnt / (double)searchVO.getPageUnit()));
	    	model.addAttribute("paginationInfo", paginationInfo);
	    	/* 페이징 끝 */
	    	
	    	
			//관리자 로그기록 관리
	    	tbl_adminLogVO adminLog =  new tbl_adminLogVO(); 
	    		 
	    	adminLog.setUser_idx(loginVO.getIdx());
	    	adminLog.setMenu_code("member");
	    	adminLog.setGubun("2");	 
	    	adminLog.setInfor("회원관리 목록");
	    	adminLog.setSite_code(loginService.getSiteCode());
	    	adminLog.setCret_id(loginVO.getId());	    	
	    	adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
	    	adminLogService.insertAdminLog(adminLog);
	    	

		}catch(Exception e){
			System.out.println(e.toString());
    	}

		searchVO.setQustr();
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/member/memberManage/list";
	}

	//회원 등록 화면
	@RequestMapping(value = "/adms/member/memberManage/create.do")
    public String create(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		try{		
			
			List<CommonCodeVO> memTypeList = loginService.getDefaultCodeList("414");		//회원구분
	    	model.addAttribute("memTypeList", memTypeList);

			//권한 목록
			Map<String, Object> searchMap = new HashMap<String, Object>();
			searchMap.put("site_code", loginService.getSiteCode());
			List<AuthVO> authList = memberManage2Service.getAuthList(searchMap);
			model.addAttribute("authList", authList);
			
			//직업
			List<CommonCodeVO> agTypeList = loginService.getDefaultCodeList("704"); 
	    	model.addAttribute("agTypeList", agTypeList);
			
			//관리자 로그기록 관리
	    	tbl_adminLogVO adminLog =  new tbl_adminLogVO(); 
   		 
	    	adminLog.setUser_idx(loginVO.getIdx());
	    	adminLog.setMenu_code("member");
	    	adminLog.setGubun("4");	 
	    	adminLog.setInfor("회원관리 생성 폼");
	    	adminLog.setSite_code(loginService.getSiteCode());
	    	adminLog.setCret_id(loginVO.getId());	    	
	    	adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
	    	adminLogService.insertAdminLog(adminLog);

		}catch(Exception e){
			System.out.println(e.toString());
    	}

		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/member/memberManage/create";
	}

	//회원 등록
	@RequestMapping(value = "/adms/member/memberManage/create_action.do", method = RequestMethod.POST)
    public String create_action(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		RedirectAttributes redirectAttributes,
    		HttpServletRequest request,
    		final MultipartHttpServletRequest multiRequest,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();


		Map<String, Object> resMap = new HashMap<String, Object>();

		try{

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

			//id 중복 체크
			int idCnt = memberManage2Service.getMemberIdCnt(searchVO);

			if(idCnt == 0){
				
				
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

				memberManage2Service.insertMemberVO(searchVO);

				resMap.put("res", "ok");
				resMap.put("msg", "txt.success");
				
				//관리자 로그기록 관리
		    	tbl_adminLogVO adminLog =  new tbl_adminLogVO(); 		   		 
		    	adminLog.setUser_idx(loginVO.getIdx());
		    	adminLog.setMenu_code("member");
		    	adminLog.setGubun("5");	 
		    	adminLog.setInfor("["+searchVO.getMe_id()+"]["+searchVO.getMe_name()+"] 회원 저장");
		    	adminLog.setSite_code(loginService.getSiteCode());
		    	adminLog.setCret_id(loginVO.getId());	    	
		    	adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
		    	adminLogService.insertAdminLog(adminLog);
				
			}else{
				resMap.put("res", "ok");
				resMap.put("msg", "mb.validate.re");
			}

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.fail");
    	}


		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/adms/member/memberManage/list.do";
	}

	//회원 수정 화면
	@RequestMapping(value = "/adms/member/memberManage/update.do")
    public String update(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		@RequestParam(required = true, value = "meIdx") int meIdx,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();

		try{
			//권한 목록
			Map<String, Object> searchMap = new HashMap<String, Object>();
			searchMap.put("site_code", loginService.getSiteCode());
			List<AuthVO> authList = memberManage2Service.getAuthList(searchMap);
			model.addAttribute("authList", authList);

			//직업
			List<CommonCodeVO> agTypeList = loginService.getDefaultCodeList("704"); 
	    	model.addAttribute("agTypeList", agTypeList);

			searchVO.setMe_idx(meIdx);
			searchVO.setSite_code(loginService.getSiteCode());

			MemberVO memberVO = memberManage2Service.getMemberVO(searchVO);
			model.addAttribute("memberVO", memberVO);

			
			FileVO fileVO = new FileVO();
	    	FileVO imageFile = new FileVO();	    	
    		fileVO.setAtchFileId(memberVO.getAtch_file_id());
    		List<FileVO> fileList = fileMngService.selectFileInfs(fileVO);
    		
    		for(int i=0; i < fileList.size(); i++){    			
    			
				imageFile = fileList.get(i);    	
				if(imageFile != null){
		    		//이미지 불러와base64 변환후 다시 셋팅
		    		CommonFunctions cf = new CommonFunctions();			    	
						String extention = imageFile.getFileExtsn().toLowerCase();	//여기랑 위에 함수처리좀 하자
				    	if(extention.equals("jpeg") || extention.equals("jpg") || extention.equals("bmp") ||
				    			extention.equals("png") || extention.equals("gif") ){
				    		imageFile.setBase64Img("data:image/gif;base64,"+cf.fileToBase64Encoding(imageFile.getFileStreCours()+"/"+imageFile.getStreFileNm()));
				    	}
		    			
		    	}
    			    			
    			
    		}
    		
    		model.addAttribute("imageFile", imageFile);

    		
			//관리자 로그기록 관리
	    	tbl_adminLogVO adminLog =  new tbl_adminLogVO(); 		   		 
	    	adminLog.setUser_idx(loginVO.getIdx());
	    	adminLog.setMenu_code("member");
	    	adminLog.setGubun("6");	 
	    	adminLog.setInfor("["+memberVO.getMe_idx()+"]["+memberVO.getMe_id()+"]["+memberVO.getMe_name()+"] 회원 수정폼");
	    	adminLog.setSite_code(loginService.getSiteCode());
	    	adminLog.setCret_id(loginVO.getId());	    	
	    	try{ // unknown host exception 의심 부분 처리
	    		adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
	    	}catch(Exception e) {
	    		System.out.println("InetAddress Exception : "+e.toString());
	    	}
	    	adminLogService.insertAdminLog(adminLog);
    		
		}catch(Exception e){
			System.out.println(e.toString());
    	}

		searchVO.setQustr();
		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		return "tiles:adms/member/memberManage/update";
	}

	//회원 수정
	@RequestMapping(value = "/adms/member/memberManage/update_action.do", method = RequestMethod.POST)
    public String update_action(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		RedirectAttributes redirectAttributes,
    		final MultipartHttpServletRequest multiRequest,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		Map<String, Object> resMap = new HashMap<String, Object>();

		try{

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			
	 		String atchFileId = searchVO.getAtch_file_id();
	 		
	 		int fileCheck = fileUtil.fileNullCheck(multiRequest);
	 						    
						
			if(fileCheck > 0){
				
				List<FileVO> result = null;
				final Map<String, MultipartFile> files = multiRequest.getFileMap();
				
				if(atchFileId == null || atchFileId.equals("")){
					atchFileId = fileMngService.getAtchNextFileId(); //따로 구함 전자정부 idgen 방식 은 안씀 COMTCOPSEQ 테이블은 없어도 됨			
				}
															                																						
				result = fileUtil.parseFileInf(files, "MEMBER_", 0, atchFileId, "member/"+searchVO.getSite_code() ,searchVO.getSite_code());
					
				searchVO.setAtch_file_id(atchFileId);
								
				fileMngService.insertFileInfs(result);
				
			}
			
			memberManage2Service.updateMemberVO(searchVO);

			//관리자 로그기록 관리
	    	tbl_adminLogVO adminLog =  new tbl_adminLogVO(); 		   		 
	    	adminLog.setUser_idx(loginVO.getIdx());
	    	adminLog.setMenu_code("member");
	    	adminLog.setGubun("7");	 
	    	adminLog.setInfor("["+searchVO.getMe_idx()+"]["+searchVO.getMe_id()+"]["+searchVO.getMe_name()+"] 회원 수정");
	    	adminLog.setSite_code(loginService.getSiteCode());
	    	adminLog.setCret_id(loginVO.getId());	   
	    	try{ // unknown host exception 의심 부분 처리
	    		adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
	    	}catch(Exception e) {
	    		System.out.println("InetAddress Exception : "+e.toString());
	    	}
	    	
	    	adminLogService.insertAdminLog(adminLog);
			
			resMap.put("res", "ok");
			resMap.put("msg", "txt.success.update");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.fail");
    	}

		searchVO.setQustr();
		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/adms/member/memberManage/list.do?"+searchVO.getQustr();
	}

	//회원 삭제
	@RequestMapping(value = "/adms/member/memberManage/delete_action.do", method = RequestMethod.POST)
	@ResponseBody
    public String delete_action(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			

			
			ObjectMapper mapper = new ObjectMapper();
			MemberVO searchVO = (MemberVO)mapper.readValue(filterJSON,new TypeReference<MemberVO>(){ });

			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			
			MemberVO memberVO  = new MemberVO();
			memberVO.setMe_idx(searchVO.getMe_idx());
			memberVO.setSite_code(loginService.getSiteCode());

			memberVO = memberManage2Service.getMemberVO(searchVO);
						
			memberManage2Service.deleteMemberVO(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "txt.success.delete");

			//관리자 로그기록 관리
	    	tbl_adminLogVO adminLog =  new tbl_adminLogVO(); 		   		 
	    	adminLog.setUser_idx(loginVO.getIdx());
	    	adminLog.setMenu_code("member");
	    	adminLog.setGubun("8");	 
	    	adminLog.setInfor("["+memberVO.getMe_idx()+"]["+memberVO.getMe_id()+"]["+memberVO.getMe_name()+"] 회원 삭제");
	    	adminLog.setSite_code(loginService.getSiteCode());
	    	adminLog.setCret_id(loginVO.getId());	 
	    	try{ // unknown host exception 의심 부분 처리
	    		adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
	    	}catch(Exception e) {
	    		System.out.println("InetAddress Exception : "+e.toString());
	    	}
	    	adminLogService.insertAdminLog(adminLog);
			
		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "txt.error");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}

	//파일 삭제
		@RequestMapping(value = "/adms/member/memberManage/update_del_file.do")
	    public String update_del_file(
	    		@ModelAttribute("searchVO")  MemberVO searchVO,
	    		RedirectAttributes redirectAttributes,
	    		HttpServletRequest request,
	    		ModelMap model) throws Exception {

			LoginVO loginVO = loginService.getLoginInfo();			
			String me_Idx = request.getParameter("me_Idx");
		    String atchFileId = request.getParameter("atchFileId");
		    String fileSn = request.getParameter("fileSn");
		    String url = "/adms/member/memberManage/update.do?meIdx="+me_Idx;
		      	try{
				    if(StringUtils.isEmpty(atchFileId)){
						model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 1");
						model.addAttribute("goUrl", url);
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
			        	model.addAttribute("goUrl", url);
			        	return gErrorPage;
			        }
			        denyFile = CommonFunctions.denyfileExtention(fvo.getFileExtsn());

			        if(denyFile==true){
						model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 3");
						model.addAttribute("goUrl", url);
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
			            		searchVO.setMe_idx(Integer.parseInt(me_Idx));
			            		searchVO.setAtch_file_id("");
			        			searchVO.setSite_code(loginService.getSiteCode());
			        			searchVO.setModi_id(loginVO.getId());
			        			try{ // unknown host exception 의심 부분 처리
			        				searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
			        	    	}catch(Exception e) {
			        	    		System.out.println("InetAddress Exception : "+e.toString());
			        	    	}
			        			

			            		memberManage2Service.updateFileMemberVO(searchVO);
			            		
			            	/*************************  삭제성공 DB 삭제 준비   ************************************/
			            	f = null;
			            }else{
			            	f = null;
			            	model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. 4");
			            	model.addAttribute("goUrl", url);
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
			        	model.addAttribute("goUrl", url);
			        	return gErrorPage;
			        }


		      	}catch(Exception e){
		      		model.addAttribute("errorMsg", "잘못된접근입니다. 파일을 삭제하지 못하였습니다. Exception : "+e.toString());
		      		model.addAttribute("goUrl", url);
		      		return gErrorPage;
		      	}



		        model.addAttribute("errorMsg", "해당파일을 삭제하였습니다.");
		        model.addAttribute("goUrl",url);
		        return gErrorPage;
		}


}
