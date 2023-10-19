package org.springframework.security.intercept.web;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.util.CookieGenerator;

import com.adms.board.service.BoardManage2Service;
import com.adms.common.log.service.MenuLogService;
import com.adms.common.log.service.SiteLogService;
import com.adms.common.menu.service.MenuAuth2Service;
import com.adms.common.menu.service.MenuAuthService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.cmm.sso.CookieUtil;
import com.bsite.cmm.sso.JwtUtil;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;
import com.bsite.vo.tbl_authcommonVO;
import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_menu_subVO;
import com.bsite.vo.tbl_pdsVO;
import com.bsite.vo.tbl_siteLogVO;

import egovframework.com.cmm.EgovProperties;
public class AuthenticUrlInterceptor extends HandlerInterceptorAdapter{

	private final static Logger logger = LoggerFactory.getLogger("com");
	
	private static final String jwtTokenCookieName = EgovProperties.getProperty("Globals.JWTCK");  
    private static final String signingKey =  EgovProperties.getProperty("Globals.SIGNKEY");  
    private String gCookieName = EgovProperties.getProperty(" Globals.GuestCookie");  
   
    
	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "MenuAuth2Service")
    private MenuAuth2Service menuauthservice;

	@Resource(name = "MenuLogService")
    private MenuLogService menuLogService;

	@Resource(name = "SiteLogService")
    private SiteLogService siteLogService;
	
	
	
	CommonFunctions cf = new CommonFunctions();

	private Set<String> permittedURL;	
	boolean isboardadms = false; //---------- 게시판 관리자 여부 (게시판만 해당) 2019-01-03
			
	private final Map<String,String> rightList = getRights();
	public void setPermittedURL(Set<String> permittedURL) {
		this.permittedURL = permittedURL;
	}

	//권한 정의
	public static Map<String,String> getRights(){
		Map<String,String> l = new  LinkedHashMap<String, String>();

		l.put("CREATE_R","등록");   //등록 권한
		l.put("READ_R","읽기");     //일기 권한
		l.put("UPDATE_R","수정");   //수정 권한
		l.put("DELETE_R","삭제");   //삭제 권한
		l.put("LIST_R","리스트");    //리스트 권한
		l.put("PRINT_R","다운로드");   //다운로드권한
		l.put("EXCEL_R","엑셀");    //엑셀 권한
		l.put("REPLY_R","답글");    //리스트 댓글권한
		l.put("CMT_R","코멘트");     //코멘트 권한

		return l;
	}

	@Override
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {
		boolean isPermittedURL = false;
		boolean passUrl = true; //초기설정
		boolean isBoardType= false;
		LoginVO loginVO = loginService.getLoginInfo();
		loginVO.setSite_code(loginService.getSiteCode());
		String contextPath = request.getContextPath();
		String requestURI = cf.stripContextPath(request.getRequestURI(),contextPath); //요청 URI
		String mkUrl = cf.makeForlderUrl(requestURI,contextPath); //메뉴 폴더 url 뽑기
		String oRiUrl= cf.makeForlderUrl(requestURI,contextPath); //변경 되지않을 메뉴 폴더 Url (비교위해)
		String zMenuCode = "none";
		tbl_menu_manageVO menuVO = new tbl_menu_manageVO();       		   //메뉴 VO
		
		
		
		logger.debug("//-------------- interCeptor PreHandle -----------------//");
		HashMap<String, Object> checkMyInfo = new HashMap<String, Object>(); //최종 담아갈 맵변수
		HashMap<String, Object> checkMyInfoOri = new HashMap<String, Object>(); //최종 담아갈 맵변수(회손안될 원본 (코멘트에 사용될 예정))
		HashMap<String, Object> right = new HashMap<String, Object>(); //최종 담아갈 맵변수
		
		logger.debug("mkUrl : "+mkUrl);
		try{
			loginVO.setMkUrl(mkUrl);  //set
			menuVO = menuauthservice.getAuthDetailData(loginVO);  //현재 메뉴코드에 대한 CRUD.. 의 Y/N 이 정해져서옴
		}catch(Exception e){
			logger.debug("URL INTERCEPTOR 내메뉴 가져오기 예외 :"+e.toString());

		}

		
		menuLogInsertProc(request,mkUrl,menuVO); 
		
		if(menuVO!=null){
			 try{
					
					loginVO.setMenu_idx(menuVO.getMenu_idx());
					tbl_menu_subVO rightVO = menuauthservice.getRightDetail(loginVO);
					
					if(rightVO==null){
						request.getRequestDispatcher("/gError.do").forward(request, response);
						return false;
					}

					//
					if(isBoardType){
						checkMyInfoOri = checkMyInfo(rightVO,requestURI, cf.makeForlderUrl(requestURI,contextPath) ,loginVO);
					}else{
						checkMyInfoOri = checkMyInfo(rightVO,requestURI, mkUrl ,loginVO);
					}
					
					if(isBoardType){//게시판같은 url이 애매한 타입
						if(isboardadms){//게시판 관리자면 전체 통과 
							checkMyInfo = rightAllPass(right);
						}else{//게시판 관리자 아닌 나머지
							checkMyInfo = checkMyInfo(rightVO,requestURI, cf.makeForlderUrl(requestURI,contextPath) ,loginVO);
						}
					}else{//나머지 일반
						checkMyInfo = checkMyInfo(rightVO,requestURI, mkUrl ,loginVO);
					}
					//======================== 각종 권한 및 옵션 추가변형용 ===================================================


					if((boolean) checkMyInfo.get("chkPass")){
						passUrl = (boolean) checkMyInfo.get("chkPass");//권한있으면 true
					}else{
						passUrl = false;
					}

					//비회원 게시판 사용 시 비밀번호가 맞을 경우 수정/삭제 권한이 없어도 권한 부여
					String pwdResult = "";
					Map<String, ?> fm = RequestContextUtils.getInputFlashMap(request);
					if (fm != null) {
						pwdResult = (String) fm.get("pwdResult");
						if("successe".equals(pwdResult)) passUrl = true;
					}
					//비회원 게시판 수정화면에서 update.do 전송 시 session 사용
					if("successe".equals(request.getSession().getAttribute("pwdResult"))) passUrl = true;
					request.getSession().removeAttribute("pwdResult");


			}catch(Exception e){
				passUrl = false;
				logger.debug("권한 생성예외  :"+e.toString());
				
			}




		}else{	// end if mVO != null
			checkMyInfo = rightAllUnPass(checkMyInfo);  //모두 막음
			checkMyInfoOri = rightAllUnPass(checkMyInfo);  //모두 막음
		}




		
		checkMyInfo.put("JSP_SELF",contextPath+mkUrl); //컨텍스트패스+메뉴폴더까지  /TEST/gnb09/lnb02/snb01/
		checkMyInfo.put("mkUrl",mkUrl); //컨텍스트패스+메뉴폴더까지  /TEST/gnb09/lnb02/snb01/
		checkMyInfo.put("zMenuCode",zMenuCode);
		try{
		//
		}catch(Exception e){checkMyInfo.put("naviGName", "잘못된접근입니다.");}
		request.setAttribute("RINFO", checkMyInfo);
		request.setAttribute("RINFO_ORI", checkMyInfoOri); //회손안된 원본 (코멘트에 사용될 예정)
		request.setAttribute("RIGHTLIST", rightList);  //권한 단순 맵리스트

		logger.debug("최종 패스권한 : " + passUrl );

		if(!passUrl){//메뉴권한에 걸리고			
			if(("temp_999999".equals(loginVO.getId()) || "99".equals(loginVO.getAuthCode())) && menuVO!=null ){  //비회원이면

				if(!Pattern.matches("\\A/account/login.do.*", requestURI)){
					String qustr = "";
					if(!StringUtils.isEmpty(request.getQueryString())) qustr = "?"+request.getQueryString();
					request.setAttribute("requestURL", requestURI+qustr);
				}
				request.getRequestDispatcher("/account/login.do").forward(request, response);
				return false;
			}

			request.getRequestDispatcher("/gError.do").forward(request, response);
			return false;
		}
		
		return true;
	}

	
	
	
	
	@SuppressWarnings("unused")
	private tbl_menu_subVO authAllPass(tbl_menu_subVO mVO){
		mVO.setCREATE_R("Y");		
		mVO.setLIST_R("Y");	
		mVO.setPRINT_R("Y");	
		mVO.setEXCEL_R("Y");	
		mVO.setREPLY_R("Y");	
		mVO.setCMT_R("Y");	
		mVO.setREAD_R("Y");
		mVO.setUPDATE_R("Y");
		mVO.setDELETE_R("Y");
		return mVO;	
	}


	//R,U,D Y로 변환
	private tbl_menu_subVO authRUDPASS(tbl_menu_subVO mVO) {
		mVO.setREAD_R("Y");
		mVO.setUPDATE_R("Y");
		mVO.setDELETE_R("Y");
		return mVO;
	}
	@SuppressWarnings("unused")
	private tbl_menu_subVO authUNPASS(tbl_menu_subVO mVO) {
		mVO.setLIST_R("N");
		mVO.setCREATE_R("N");
		mVO.setREAD_R("N");
		mVO.setUPDATE_R("N");
		mVO.setDELETE_R("N");
		return mVO;
	}
	
	//R,U,D Y로 변환
	private tbl_menu_subVO authPrintPASS(tbl_menu_subVO mVO) {
		mVO.setPRINT_R("Y");  //파일 다운로드랑 같이 씀..
		return mVO;
	}



	




	private HashMap<String, Object> checkMyInfo(tbl_menu_subVO mVO ,String requestURI ,String mkUrl , LoginVO loginvo){

		logger.debug("requestURI : "+requestURI +" , mkUrl : "+mkUrl);
		HashMap<String, Object> map =new HashMap<String, Object>();
		try{
			if(Pattern.matches("\\A"+mkUrl + "create.*", requestURI)){
				map.put("chkPass", checkMyTf(mVO.getCREATE_R()));
				map.put("thisPage", "C");
			}
			if(Pattern.matches("\\A"+mkUrl + "read.*", requestURI)){
				map.put("chkPass", checkMyTf(mVO.getREAD_R()));
				map.put("thisPage", "R");
			}
			if(Pattern.matches("\\A"+mkUrl + "update.*", requestURI)){
				map.put("chkPass", checkMyTf(mVO.getUPDATE_R()));
				map.put("thisPage", "U");
			}
			if(Pattern.matches("\\A"+mkUrl + "delete.*", requestURI)){
				map.put("chkPass", checkMyTf(mVO.getDELETE_R()));
				map.put("thisPage", "D");
			}
			if(Pattern.matches("\\A"+mkUrl + "list.*", requestURI)){
				//logger.debug("-- "+mkUrl+" : list -- ");
				map.put("chkPass", checkMyTf(mVO.getLIST_R()));
				map.put("thisPage", "L");
			}
			if(Pattern.matches("\\A"+mkUrl + "print.*", requestURI)){
				map.put("chkPass", checkMyTf(mVO.getPRINT_R()));
				map.put("thisPage", "PR");
			}

			if(Pattern.matches("\\A"+mkUrl + "excel.*", requestURI)){
				//logger.debug("-- "+mkUrl+" :  print -- ");
				map.put("chkPass", checkMyTf(mVO.getEXCEL_R()));
				map.put("thisPage", "EX");
			}
			if(Pattern.matches("\\A"+mkUrl + "reply.*", requestURI)){
				//logger.debug("-- "+mkUrl+" :  print -- ");
				map.put("chkPass", checkMyTf(mVO.getREPLY_R()));
				map.put("thisPage", "RP");
			}
			if(Pattern.matches("\\A"+mkUrl + "comment.*", requestURI)){
				//logger.debug("-- "+mkUrl+" :  print -- ");
				map.put("chkPass", checkMyTf(mVO.getCMT_R()));
				map.put("thisPage", "CMT");
			}
			//========================== 메인 통과 권한 =====================================



			//버튼권한 만들어오기 (기본값 false 생성)
			//========================== 부가 권한및 옵션 =====================================
			map.put("C",checkMyTf(mVO.getCREATE_R()));
			map.put("R",checkMyTf(mVO.getREAD_R()));
			map.put("U",checkMyTf(mVO.getUPDATE_R()));
			map.put("D",checkMyTf(mVO.getDELETE_R()));
			map.put("L",checkMyTf(mVO.getLIST_R()));
			map.put("PR",checkMyTf(mVO.getPRINT_R()));
			/*map.put("LB",checkMyTf(mVO.getLABEL_R()));*/
			map.put("EX",checkMyTf(mVO.getEXCEL_R()));
			map.put("RP",checkMyTf(mVO.getREPLY_R()));
			map.put("CMT",checkMyTf(mVO.getCMT_R()));




			//========================== 부가 권한및 옵션  =====================================
		}catch(Exception e){
			map.put("chkPass", false);// 최종권한판단 false;
			logger.debug("checkMyInfo function ex : "+e.toString());
		}

		return map;
	}



	@SuppressWarnings("unused")
	private HashMap<String, Object> rightAllPass(HashMap<String, Object> map){

			map.put("chkPass",true);
			map.put("C",true);
			map.put("R",true);
			map.put("U",true);
			map.put("D",true);
			map.put("L",true);
			map.put("PR",true);
			/*map.put("LB",true);*/
			map.put("EX",true);
			map.put("RP",true);
			map.put("CMT",true);

			return map;
	}


	private HashMap<String, Object> rightAllUnPass(HashMap<String, Object> map){
			logger.debug("메뉴가 등록되있지않거나 권한이 없어 모든 권한 false");
			map.put("chkPass",false);
			map.put("C",false);
			map.put("R",false);
			map.put("U",false);
			map.put("D",false);
			map.put("L",false);
			map.put("PR",false);
			/*map.put("LB",false);*/
			map.put("EX",false);
			map.put("RP",false);
			map.put("CMT",false);

			return map;
	}



	private boolean checkMyTf(String YN){//내레벨 비교
			boolean retVal = false;
			try{
				if(YN.equals("Y")){
					retVal = true;
				}else{
					retVal = false;
				}
			}catch(Exception e){
				System.out.print("YN 부여 예외 :"+e.toString());
				retVal = false;
			}
			return retVal;
	}
	
	
	
	//메뉴 로그 등록
    public void menuLogInsertProc(HttpServletRequest request,String mkUrl , tbl_menu_manageVO menuVO) throws Exception {
		String loggerTerm =CookieUtil.getValue(request, gCookieName);
		if(StringUtils.isEmpty(loggerTerm)) loggerTerm="initCookie";
		System.out.println("loggerTerm2 : "+loggerTerm);		
		
		if(!StringUtils.isEmpty(loggerTerm) && !StringUtils.isEmpty(mkUrl) ){ //밀리초 쿠키 사용자 가림용	
			
			//if(menuVO!=null){
				//사이트코드 , 사이트 키 , 로거텀  의 max시간 게시물과 현재 시간비교하여 insert
				//------------------ set -------------------
				tbl_menuLogVO mvo = new tbl_menuLogVO();
				mvo.setSite_code(loginService.getSiteCode());
				if(menuVO !=null) mvo.setMenu_idx(menuVO.getMenu_idx());
				mvo.setCookie_user(loggerTerm);
				mvo.setUrl(mkUrl);
				//------------------------------------------
				//boolean tf = menuInsertPrevCheck(mvo);  //느릴수있어 추후 개선예정 2019-08-07
				
				if(true) menuLogService.getInsertMenuLog(request,mvo); //메뉴 접속 로그 
			//}
			
		}
	}
	

	public boolean menuInsertPrevCheck(tbl_menuLogVO mvo){
		boolean ret = false;		
		ret = menuLogService.menuInsertPrevCheck(mvo);		
		return ret;
	}


}
