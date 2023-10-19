package com.adms.member.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.AuthVO;


import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("AuthManageDAO")
public class AuthManageDAO extends EgovAbstractMapper{

	public List<AuthVO> getAuthList(AuthVO searchVO) {
		return selectList("AuthManageDAOgetAuthList", searchVO);
	}

	public int getAuthListCnt(AuthVO searchVO) {
		return selectOne("AuthManageDAOgetAuthListCnt", searchVO);
	}

	public void insertAuthManage(AuthVO searchVO) {
		insert("AuthManageDAOinsertAuthManage", searchVO);
	}

	public AuthVO getAuthVO(AuthVO searchVO) {
		return selectOne("AuthManageDAOgetAuthVO", searchVO);
	}

	public void updateAuthManage(AuthVO searchVO) {
		update("AuthManageDAOupdateAuthManage", searchVO);
	}

	public void deleteAuthManage(AuthVO searchVO) {
		update("AuthManageDAOdeleteAuthManage", searchVO);
	}

	public int getAuthCodeCnt(AuthVO searchVO) {
		return selectOne("AuthManageDAOgetAuthCodeCnt", searchVO);
	}

	public List<AuthVO> getAuthListAll(Map<String, Object> searchMap) {
		return selectList("AuthManageDAOgetAuthListAll", searchMap);
	}

}
