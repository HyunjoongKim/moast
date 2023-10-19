package com.bsite.account.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("LoginDao")
public class LoginDao extends EgovAbstractMapper{

	public LoginVO actionLogin(LoginVO searchVO) { 
		return selectOne("LoginDaoactionLogin", searchVO);
	}

	public List<CommonCodeVO> getCodeList(Map<String, Object> searchMap) {
		return selectList("LoginDaogetCodeList", searchMap);
	}

	public List<CommonCodeVO> getSidoCodeList(Map<String, Object> searchMap) {
		return selectList("LoginDaogetSidoCodeList", searchMap);
	}

	public void updateLastLogin(LoginVO loginVO) {
		update("LoginDaoupdateLastLogin", loginVO);
	}

	public List<CommonCodeVO> getSidoCodeMap(Map<String, Object> searchMap) {
		return selectList("LoginDaogetSidoCodeMap", searchMap);
	}

	public List<CommonCodeVO> getSidoCodeMapByCode(Map<String, Object> searchMap) {
		return selectList("LoginDaogetSidoCodeMapByCode", searchMap);
	}

	public LoginVO actionLoginById(String id) {
		return selectOne("LoginDaoactionLoginById", id);
	}

}
