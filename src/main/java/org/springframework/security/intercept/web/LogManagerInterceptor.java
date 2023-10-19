package org.springframework.security.intercept.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.adms.common.log.service.MenuLogService;
import com.adms.common.log.service.SiteLogService;
import com.adms.common.menu.service.MenuAuth2Service;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.cmm.sso.CookieUtil;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_siteLogVO;


import egovframework.com.cmm.EgovProperties;

public class LogManagerInterceptor extends HandlerInterceptorAdapter{
	private String gCookieName = EgovProperties.getProperty(" Globals.GuestCookie");  
	CommonFunctions cf = new CommonFunctions();
	
	@Resource(name = "LoginService")
    private LoginService loginService;
	
	@Resource(name = "MenuAuth2Service")
    private MenuAuth2Service menuauthservice;
	
	@Resource(name = "MenuLogService")
    private MenuLogService menuLogService;
	
	@Resource(name = "SiteLogService")
    private SiteLogService siteLogService;
	
	
	@Override
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {
		//-----------------------  접속 로그용 쿠키 ------------------------
		String loggerTerm =CookieUtil.getValue(request, gCookieName);
		if(StringUtils.isEmpty(loggerTerm)) {
	    	System.out.println("gCookieName : 없으면 다시생성");
	    	CookieUtil.create(response, gCookieName, String.valueOf(System.currentTimeMillis()), false,30,loginService.getDomain()); 
	    }
		//-----------------------  접속 로그용 쿠키 ------------------------
		
		
		
		
		
		
		
		
		return true;
	}
	
	
	
	@Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		String loggerTerm =CookieUtil.getValue(request, gCookieName);
		if(StringUtils.isEmpty(loggerTerm)) loggerTerm="initCookie";
		System.out.println("loggerTerm1 : "+loggerTerm);		
		System.out.println("request.getRequestURI() : "+request.getRequestURI());	
		
		if(!StringUtils.isEmpty(loggerTerm)){ //밀리초 쿠키 사용자 가림용
			//사이트코드 , 로거텀의 max시간 게시물과 현재  시간비교하여 insert
			//------------------ set -------------------
			tbl_siteLogVO svo = new tbl_siteLogVO();
			svo.setSite_code(loginService.getSiteCode());
			svo.setCookie_user(loggerTerm);
			//------------------------------------------
			//boolean tf = siteLogInsertPrevCheck(svo);  //느릴수 있어 추후 개선예정 2019-08-07
			if(true) siteLogService.getInsertSiteLog(request, svo);	  //사이트 접속 로그			
		}
        super.afterCompletion(request, response, handler, ex);
	}
	
	
	private boolean siteLogInsertPrevCheck(tbl_siteLogVO svo) {
		boolean ret = false;		
		ret = siteLogService.siteLogInsertPrevCheck(svo);		
		return ret;
	}
}
