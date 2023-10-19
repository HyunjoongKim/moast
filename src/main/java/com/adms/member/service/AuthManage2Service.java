package com.adms.member.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.AuthVO;


public interface AuthManage2Service {

	Map<String, Object> getAuthList(AuthVO searchVO) throws Exception;

	void insertAuthManage(AuthVO searchVO) throws Exception;

	int getAuthCodeCnt(AuthVO searchVO) throws Exception;

	AuthVO getAuthVO(AuthVO searchVO) throws Exception;

	void updateAuthManage(AuthVO searchVO) throws Exception;

	void deleteAuthManage(AuthVO searchVO) throws Exception;

	List<AuthVO> getAuthListAll(Map<String, Object> searchMap) throws Exception;


}
