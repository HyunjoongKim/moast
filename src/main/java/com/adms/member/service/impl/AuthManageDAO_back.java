package com.adms.member.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.AuthVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("AuthManageDAO")
public class AuthManageDAO_back extends EgovComAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<AuthVO> getAuthList(AuthVO searchVO) {
		return (List<AuthVO>) list("AuthManageDAO.getAuthList", searchVO);
	}

	@SuppressWarnings("deprecation")
	public int getAuthListCnt(AuthVO searchVO) {
		return (Integer)getSqlMapClientTemplate().queryForObject("AuthManageDAO.getAuthListCnt", searchVO);
	}

	public void insertAuthManage(AuthVO searchVO) {
		insert("AuthManageDAO.insertAuthManage", searchVO);
	}

	public AuthVO getAuthVO(AuthVO searchVO) {
		return (AuthVO)select("AuthManageDAO.getAuthVO", searchVO);
	}

	public void updateAuthManage(AuthVO searchVO) {
		update("AuthManageDAO.updateAuthManage", searchVO);
	}

	public void deleteAuthManage(AuthVO searchVO) {
		update("AuthManageDAO.deleteAuthManage", searchVO);
	}

	@SuppressWarnings("deprecation")
	public int getAuthCodeCnt(AuthVO searchVO) {
		return (Integer)getSqlMapClientTemplate().queryForObject("AuthManageDAO.getAuthCodeCnt", searchVO);
	}

	@SuppressWarnings("unchecked")
	public List<AuthVO> getAuthListAll(Map<String, Object> searchMap) {
		return (List<AuthVO>) list("AuthManageDAO.getAuthListAll", searchMap);
	}

}
