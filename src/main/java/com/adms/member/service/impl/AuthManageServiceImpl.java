package com.adms.member.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.adms.member.service.AuthManageService;
import com.bsite.vo.AuthVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("AuthManageService")
public class AuthManageServiceImpl extends EgovAbstractServiceImpl implements AuthManageService{

	@Resource
	private AuthManageDAO dao;

	@Override
	public Map<String, Object> getAuthList(AuthVO searchVO) throws Exception {
		List<AuthVO> result = dao.getAuthList(searchVO);
		int cnt = dao.getAuthListCnt(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;
	}

	@Override
	public void insertAuthManage(AuthVO searchVO) throws Exception {
		dao.insertAuthManage(searchVO);
	}

	@Override
	public AuthVO getAuthVO(AuthVO searchVO) throws Exception {
		return dao.getAuthVO(searchVO);
	}

	@Override
	public void updateAuthManage(AuthVO searchVO) throws Exception {
		dao.updateAuthManage(searchVO);
	}

	@Override
	public void deleteAuthManage(AuthVO searchVO) throws Exception {
		dao.deleteAuthManage(searchVO);
	}

	@Override
	public int getAuthCodeCnt(AuthVO searchVO) throws Exception {
		return dao.getAuthCodeCnt(searchVO);
	}

	@Override
	public List<AuthVO> getAuthListAll(Map<String, Object> searchMap) throws Exception {
		return dao.getAuthListAll(searchMap);
	}

}
