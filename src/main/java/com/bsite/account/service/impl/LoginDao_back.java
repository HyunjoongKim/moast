package com.bsite.account.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("LoginDao")
public class LoginDao_back extends EgovComAbstractDAO{

	public LoginVO actionLogin(LoginVO searchVO) { 
		return (LoginVO)select("LoginDao.actionLogin", searchVO);
	}

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getCodeList(Map<String, Object> searchMap) {
		return (List<CommonCodeVO>) list("LoginDao.getCodeList", searchMap);
	}

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getSidoCodeList(Map<String, Object> searchMap) {
		return (List<CommonCodeVO>) list("LoginDao.getSidoCodeList", searchMap);
	}

	public void updateLastLogin(LoginVO loginVO) {
		update("LoginDao.updateLastLogin", loginVO);
	}

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getSidoCodeMap(Map<String, Object> searchMap) {
		return (List<CommonCodeVO>) list("LoginDao.getSidoCodeMap", searchMap);
	}

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getSidoCodeMapByCode(Map<String, Object> searchMap) {
		return (List<CommonCodeVO>) list("LoginDao.getSidoCodeMapByCode", searchMap);
	}

}
