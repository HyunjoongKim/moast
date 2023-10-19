package com.bsite.account.service;

import java.util.HashMap;
import java.util.List;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

public interface LoginService {

	LoginVO actionLogin(LoginVO searchVO) throws Exception;

	LoginVO getLoginInfo() throws Exception;

	String getSiteCode() throws Exception;
	
	String getDomain() throws Exception;

	List<CommonCodeVO> getDefaultCodeList(String ptrnCode) throws Exception;
	
	List<CommonCodeVO> getDefaultCodeList(String code_cate ,String ptrnCode) throws Exception;

	//id 유무체크[날짜:0171025 작업자:연순모]
	LoginVO actionLoginById(String id)  throws Exception;
	
	//로그인 실패시 횟수 증가 추가 [날짜:0171025 작업자:연순모]
	void updateLoginFailCnt(LoginVO loginVO) throws Exception;
	
	void updateLastLogin(LoginVO loginVO) throws Exception;

	void getCategory(String string, String string2, HashMap<String, List<CommonCodeVO>> _map);

	String[] getResearchRepoArr(LoginVO loginVO) throws Exception;

	int getDefaultCodeIdx(String code_cate, String main_code) throws Exception;

}
