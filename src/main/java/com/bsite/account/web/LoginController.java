package com.bsite.account.web;


import java.net.InetAddress;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.adms.common.log.service.AdminLogService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.sso.CookieUtil;
import com.bsite.cmm.sso.JwtUtil;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_adminLogVO;

import egovframework.com.cmm.EgovProperties;



@Controller
public class LoginController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	private static final String jwtTokenCookieName = EgovProperties.getProperty("Globals.JWTCK");
    private static final String signingKey =  EgovProperties.getProperty("Globals.SIGNKEY");

	@Resource(name = "LoginService")
    private LoginService loginService;
	
	// [start] 로그기록 관리 추가 작업을 위한 AdminLogService 추가 - 작업자 : 연순모(2017.09.13)
	@Resource(name = "AdminLogService")
    private AdminLogService adminLogService;
	// [end] 로그기록 관리 추가 작업을 위한 AdminLogService 추가 - 작업자 : 연순모(2017.09.13)
	
	
	//로그인 화면
	@RequestMapping(value = "/account/login.do")
    public String login(
    		@ModelAttribute("searchVO") LoginVO searchVO,
    		RedirectAttributes redirectAttributes,
    		HttpServletRequest request,
    		ModelMap model) throws Exception {


		/*LoginVO loginVO = loginService.getLoginInfo();
		if(!loginVO.getId().equals("temp_999999")) return "redirect:/";*/

		model.addAttribute("requestURL", request.getAttribute("requestURL"));
		return "tiles:bsiteApart/account/login/login";
		//return "admstiles:bsite/account/login/login";
	}

	//로그인 실행
	@RequestMapping(value = "/account/actionLogin.do", method = RequestMethod.POST)
    public String actionLogin(
    		@ModelAttribute("searchVO") LoginVO searchVO,
    		HttpServletRequest request,
    		HttpSession session,
    		RedirectAttributes redirectAttributes,
    		HttpServletResponse httpServletResponse,
    		ModelMap model) throws Exception {

		searchVO.setSite_code(loginService.getSiteCode());

		//로그인 정보 조회
		LoginVO loginVO = loginService.actionLogin(searchVO);

		//로그인 실패 시
		if(loginVO == null){
			redirectAttributes.addFlashAttribute("actionResult", "fail");
			return "redirect:/account/login.do";
		}

		if(loginVO.getAuthCode().equals("4")){
			redirectAttributes.addFlashAttribute("actionResult", "noAuth");
			return "redirect:/account/login.do";
		}


		String getDomain = loginService.getDomain();
		//로그인 성공 시
		session.setAttribute("loginVO", loginVO);
		System.out.println("getDomain : "+getDomain);
		//=========================== jwt sso =============================
		String token = JwtUtil.generateToken(signingKey, loginVO);
		CookieUtil.create(httpServletResponse, jwtTokenCookieName, token, false, -1,getDomain);		
		//=========================== jwt sso =============================

		//최종 로그인 시간 업데이트
		loginVO.setSite_code(loginService.getSiteCode());
		loginService.updateLastLogin(loginVO);

		
		// [start] 로그기록 관리 추가 작업 - 작업자 : 연순모(2017.09.13)
    	
		tbl_adminLogVO adminLog =  new tbl_adminLogVO(); 
    		 
    	adminLog.setUser_idx(loginVO.getIdx());
    	adminLog.setMenu_code("login");
    	adminLog.setGubun("1");	 
    	adminLog.setInfor("["+loginVO.getId()+"] 로그인");
    	adminLog.setSite_code(loginService.getSiteCode());
    	adminLog.setCret_id(loginVO.getId());	    
    	try{ // unknown host exception 의심 부분 처리
    		adminLog.setCret_ip(InetAddress.getLocalHost().getHostAddress());
    	}catch(Exception e) {
    		System.out.println("InetAddress Exception : "+e.toString());
    	}
    	adminLogService.insertAdminLog(adminLog);

    	// [end] 로그기록 관리 추가 작업 - 작업자 : 연순모(2017.09.13)
		
		String requestURL = "/";
		if(StringUtils.isNotBlank(searchVO.getRequestURL())) requestURL = searchVO.getRequestURL();

		return "redirect:"+requestURL;
	}

	//로그아웃
	@RequestMapping(value="/account/logout.do")
    public String logout(
    		HttpServletRequest request,
    		SessionStatus status,
    		HttpSession session,
    		HttpServletResponse httpServletResponse,
    		ModelMap model)  throws Exception {

		//로그인 정보 조회


		status.setComplete();
    	session.removeAttribute("loginVO");
    	session.invalidate();

    	CookieUtil.clear(httpServletResponse, jwtTokenCookieName, loginService.getDomain());
    	
    	return  "redirect:/";
    	
    }

}
