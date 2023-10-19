package com.bsite.account.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.bsite.account.service.LoginService;
import com.bsite.cmm.sso.CookieUtil;
import com.bsite.cmm.sso.JwtUtil;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

import egovframework.com.cmm.EgovFileScrty;
import egovframework.com.cmm.EgovProperties;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import io.jsonwebtoken.Claims;

@Service("LoginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService{

	private static final String jwtTokenCookieName = EgovProperties.getProperty("Globals.JWTCK");  
    private static final String signingKey =  EgovProperties.getProperty("Globals.SIGNKEY");  
    
	@Resource
	private LoginDao dao;
	
	@Resource
	private LoginDao2 dao2;

	@Override
	public LoginVO actionLogin(LoginVO searchVO) throws Exception {
		String enpassword = EgovFileScrty.encryptPassword(searchVO.getPassword());
		searchVO.setPassword(enpassword);

		return dao2.actionLogin(searchVO);
	}

	@Override
	public LoginVO getLoginInfo() throws Exception {
		//LoginVO loginVO = (LoginVO) RequestContextHolder.getRequestAttributes().getAttribute("loginVO", RequestAttributes.SCOPE_SESSION);		
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
		HttpServletRequest req = sra.getRequest();		
		HttpServletResponse res = sra.getResponse();
		HttpSession session = req.getSession();
		
		
		//페이지가 전환될 때마다 항상 쿠키를 체크하여  로그인 세션이 없으면 Json web 토큰의 정보를 파싱하여 세션으로 살려주는 부분. 여기에서 SSO가 유지된다고 볼 수 있음.
		LoginVO loginVO = null;
		loginVO = (LoginVO) RequestContextHolder.getRequestAttributes().getAttribute("loginVO", RequestAttributes.SCOPE_SESSION);
		try{
			Claims claims = JwtUtil.getAll(req, jwtTokenCookieName, signingKey);
			System.out.println("claims :"+claims);
			if(claims!=null){
				if(loginVO == null) {
					//System.out.println("claims id :"+(String) claims.get("id"));
					loginVO = actionLoginById((String) claims.get("id"));
					session.setAttribute("loginVO", loginVO);
				}
				loginVO.setId((String) claims.get("sub"));
				loginVO.setAuthCode((String) claims.get("authCode"));
				loginVO.setName((String) claims.get("name"));
				loginVO.setMe_type((String) claims.get("memberType")); 
				loginVO.setRepoHasRight((String) claims.get("repoHasRight"));
				loginVO.setSite_code(getSiteCode());
			}else{
				session.removeAttribute("loginVO");
		    	//session.invalidate();
		    	loginVO = null;
			}
		}catch(Exception e){
			System.out.println("login mapper error :"+e.toString());
		}
		if(loginVO == null){
			loginVO = new LoginVO();
			loginVO.setId("temp_999999");
			loginVO.setAuthCode("99");
			
			CookieUtil.clear(res, jwtTokenCookieName, getDomain());
		}	
		return loginVO;
	}
	
	
	@Override
	public LoginVO actionLoginById(String id) throws Exception {
		return dao2.actionLoginById(id);
	}

	
	@Override
	public String getSiteCode() throws Exception {
		return EgovProperties.getProperty("Globals.SiteCode");
	}
	
	@Override
	public String getDomain() throws Exception {
		return EgovProperties.getProperty("Globals.CurrentDomain");
	}
	
	
	@Override
	public int getDefaultCodeIdx(String code_cate, String main_code) throws Exception {

		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("code_cate", code_cate);
		searchMap.put("main_code", main_code);
		searchMap.put("site_code", getSiteCode());

		
		return dao2.getCodeIdx(searchMap);
	}	

	@Override
	public List<CommonCodeVO> getDefaultCodeList(String ptrnCode) throws Exception {

		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("code_cate", "default");
		searchMap.put("ptrn_code", ptrnCode);
		searchMap.put("site_code", getSiteCode());


		return dao2.getCodeList(searchMap);
	}
	
	@Override
	public List<CommonCodeVO> getDefaultCodeList(String code_cate, String ptrnCode) throws Exception {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("code_cate", code_cate);
		searchMap.put("ptrn_code", ptrnCode);
		searchMap.put("site_code", getSiteCode());
		
		return dao2.getCodeList(searchMap);
	}


	@Override
	public void updateLastLogin(LoginVO loginVO) throws Exception {
		dao2.updateLastLogin(loginVO);
	}
	
	
	//로그인 실패시 횟수 증가 추가 [날짜:0171025 작업자:연순모]
	@Override
	public void updateLoginFailCnt(LoginVO loginVO) throws Exception {
		dao2.updateLoginFailCnt(loginVO);
	}
	
	//1뎁스를 불러야 할때 에 부르기 (재귀) [2,3뎁스만 현재 맵으로 리턴]
	@Override
	public void getCategory(String codeCate, String ptrnCode, HashMap<String, List<CommonCodeVO>> _map) {
		try {
			List<CommonCodeVO> _l = getDefaultCodeList(codeCate,ptrnCode);
			if(_l.size()>0){	
					//========================= Set =====================================
					for(CommonCodeVO v:_l){
						if(v.getCode_depth() ==2 ){
							_map.put(v.getCode_idx()+"", new ArrayList<CommonCodeVO>());
						}
						
						if(v.getCode_depth() ==3 ){
							_map.get(v.getPtrn_code()).add(v);
						}
					}	
					//========================= Set =====================================
					
					for(CommonCodeVO v:_l){
						getCategory(codeCate,v.getCode_idx()+"",_map);
					}				
			}else{				
			}			
		} catch (Exception e) {
			System.out.println("category make errr : "+e.toString());
		} 		
	}

	@Override
	public String[] getResearchRepoArr(LoginVO loginVO) throws Exception {
		String[] repoArray = null;
		if("1".equals(loginVO.getAuthCode())){ //최고관리자면  수장고 관련 모든 경우수 코드
			List<CommonCodeVO> repoTypeList = getDefaultCodeList("432");		//수장고 관리유형
			repoArray = new String[repoTypeList.size()];
			int k = 0;
			for(CommonCodeVO rv :repoTypeList){
				repoArray[k]=rv.getMain_code();
				k++;
			}			
			
		}else{			
				String [] repTArr = loginVO.getRepoHasRight().split(",");
				repoArray = new String[repTArr.length];
				repoArray = repTArr;			
		}
		
		return repoArray;
	}



}
