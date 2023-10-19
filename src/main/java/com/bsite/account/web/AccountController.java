package com.bsite.account.web;

import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang.RandomStringUtils;
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
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.adms.member.service.MemberManageService;
import com.bsite.account.service.AccountService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;

@Controller
public class AccountController {
	private final static Logger logger = LoggerFactory.getLogger("com");
	private final String gErrorPage =  "tiles:bsite/common/msg";

	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "AccountService")
    private AccountService accountService;

	@Resource(name = "MemberManageService")
    private MemberManageService memberManageService;

	@Resource(name = "EgovFileMngUtil")
    private EgovFileMngUtil fileUtil;

	@Resource(name = "EgovFileMngService")
    private EgovFileMngService fileMngService;

	CommonFunctions cf = new CommonFunctions();


	//회원가입 화면
	@RequestMapping(value = "/account/join.do")
    public String join(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		RedirectAttributes redirectAttributes,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();
		Map<String, Object> resMap = new HashMap<String, Object>();
		try{
			Map<String, ?> fm = RequestContextUtils.getInputFlashMap(request);
			/*if (fm == null) {
				resMap.put("res", "fail");
				resMap.put("msg", "약관동의 후 가입하실 수 있습니다.");
				redirectAttributes.addFlashAttribute("resMap", resMap);
				return "redirect:/account/agree.do";
			}*/
			
			//직업
			List<CommonCodeVO> agTypeList = loginService.getDefaultCodeList("704"); 
	    	model.addAttribute("agTypeList", agTypeList);


		}catch(Exception e){
			System.out.println(e.toString());
    	}


		return "tiles:bsiteApart/account/account/join";
	}


	//회원가입 실행
	@RequestMapping(value = "/account/join_action.do", method = RequestMethod.POST)
    public String join_action(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		RedirectAttributes redirectAttributes,
    		HttpServletRequest request,
    		final MultipartHttpServletRequest multiRequest,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();


		Map<String, Object> resMap = new HashMap<String, Object>();

		try{
			//searchVO.setMe_tel(request.getParameter("me_tel1")+"-"+request.getParameter("me_tel2")+"-"+request.getParameter("me_tel3"));

			searchVO.setAuth_code("5");
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setCret_id(loginVO.getId());
			searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());

			//id 중복 체크
			int idCnt = memberManageService.getMemberIdCnt(searchVO);

			if(idCnt > 0){
				resMap.put("res", "ok");
				resMap.put("msg", "중복된 아이디가 있습니다.");
				redirectAttributes.addFlashAttribute("resMap", resMap);
				return "redirect:/adms/member/memberManage/list.do";
			}


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

			memberManageService.insertMemberVO(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "가입이 완료되었습니다.");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}


		redirectAttributes.addFlashAttribute("resMap", resMap);
		return "redirect:/account/login.do";
	}

	//회원 id 중복 체크
	@RequestMapping(value = "/account/getIdCnt.do", method = RequestMethod.POST)
	@ResponseBody
    public String create_getIdCnt(
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

			int idCnt = memberManageService.getMemberIdCnt(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "조회하였습니다.");
			resMap.put("idCnt", idCnt);

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}

	//회원 id 중복 체크
	@RequestMapping(value = "/account/loginCntReset.do", method = RequestMethod.POST)
	@ResponseBody
    public String loginCntReset(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			ObjectMapper mapper = new ObjectMapper();
			MemberVO searchVO = (MemberVO)mapper.readValue(filterJSON,new TypeReference<MemberVO>(){ });
			
			//로그인 횟수 초기화 추가 [날짜:2017-10-27 작업자:연순모]
			memberManageService.loginCntReset(searchVO);

			resMap.put("res", "ok");
			resMap.put("msg", "로그인 횟수가 초기화 됬습니다.");			

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}
	
	@RequestMapping(value="/gError.do",method = RequestMethod.GET)
    public String  gError(
    		HttpServletRequest request,
    		//RedirectAttributes redirectAttributes,
    		ModelMap model ) throws Exception {

		//errorMsg
		model.addAttribute("title","메뉴권한관리- 권한부여의 잘못된 접근");
		model.addAttribute("errorMsg","권한이 없습니다.");
		return "tiles:bsite/common/error";
    }

	//약관동의
	@RequestMapping(value = "/account/agree.do")
    public String agree(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		LoginVO loginVO = loginService.getLoginInfo();

		try{


		}catch(Exception e){
			System.out.println(e.toString());
    	}


		return "tiles:bsiteApart/account/account/agree";
	}

	//약관동의 실행
	@RequestMapping(value = "/account/agree_action.do", method = RequestMethod.POST)
    public String agree_action(
    		@ModelAttribute("searchVO") MemberVO searchVO,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);
		fm.put("result", "ok");
		return "redirect:/account/join.do";
	}

	//이용약관
	@RequestMapping(value = "/account/doc1.do")
    public String doc1(
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		return "tiles:bsiteApart/account/account/doc1";
	}

	//개인정보처리방침
	@RequestMapping(value = "/account/doc2.do")
    public String doc2(
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		return "tiles:bsiteApart/account/account/doc2";
	}

	//아이디 찾기
	@RequestMapping(value = "/account/searchId.do")
    public String searchId(
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		return "tiles:bsiteApart/account/account/searchId";
	}

	//아이디 찾기 결과
	@RequestMapping(value = "/account/searchIdResult.do")
    public String searchIdResult(
    		@RequestParam(required = true, value = "userName") String userName,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		try{
			MemberVO searchVO = new MemberVO();
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setMe_name(userName);

			List<MemberVO> memberVOList = accountService.getMemberVOList(searchVO);
			model.addAttribute("memberVOList", memberVOList);
			model.addAttribute("userName", userName);

		}catch(Exception e){
			System.out.println(e.toString());
    	}

		return "tiles:bsiteApart/account/account/searchIdResult";
	}

	//비밀번호 찾기
	@RequestMapping(value = "/account/searchPw.do")
    public String searchPw(
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		return "tiles:bsiteApart/account/account/searchPw";
	}

	//비밀번호 찾기 결과
	@RequestMapping(value = "/account/searchPwResult.do")
    public String searchPwResult(
    		@RequestParam(required = true, value = "userId") String userId,
    		@RequestParam(required = true, value = "userMail") String userMail,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		try{
			MemberVO searchVO = new MemberVO();
			searchVO.setSite_code(loginService.getSiteCode());
			searchVO.setMe_id(userId);
			searchVO.setMe_email(userMail);

			MemberVO memberVO = accountService.getMemberVO(searchVO);
			model.addAttribute("memberVO", memberVO);


			//Random String
			/*System.out.println("Default     [" + RandomStringUtils.random(10) + "]");
	    	System.out.println("CustomChar  [" + RandomStringUtils.random(10, new char[]{'A','B','C'}) + "]");
	    	System.out.println("CustomString[" + RandomStringUtils.random(10, "ABC") + "]");
	    	System.out.println("Alphabetic  [" + RandomStringUtils.randomAlphabetic(10) + "]");
	    	System.out.println("Alphanumeric[" + RandomStringUtils.randomAlphanumeric(10) + "]");
	    	System.out.println("Ascii       [" + RandomStringUtils.randomAscii(10) + "]");
	    	System.out.println("Numeric     [" + RandomStringUtils.randomNumeric(10) + "]");*/

			//비밀번호 초기화 후 메일 발송
			if(memberVO != null){
				String newPwd = RandomStringUtils.randomAlphanumeric(10);
				memberVO.setMe_pwd(newPwd);
				memberVO.setSite_code(loginService.getSiteCode());
				memberVO.setModi_id("initPwd");
				memberVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
				accountService.initPassword(memberVO);

				String mailSubj = "비밀번호가 초기화 되었습니다.";
				String mailBody = "";
				mailBody += "비밀번호가 초기화 되었습니다. <br />";
				mailBody += "비밀번호 : "+newPwd +"<br />";
				mailBody += "로그인 후 비밀번호를 반드시 변경해주세요.<br />";

				cf.sendMail(memberVO.getMe_email(), mailSubj, mailBody);
			}

		}catch(Exception e){
			System.out.println(e.toString());
    	}

		return "tiles:bsiteApart/account/account/searchPwResult";
	}

}
