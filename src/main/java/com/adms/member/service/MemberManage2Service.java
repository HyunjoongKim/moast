package com.adms.member.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.AuthVO;
import com.bsite.vo.MemberVO;
import com.bsite.vo.tbl_siteLogVO;


public interface MemberManage2Service {

	List<AuthVO> getAuthList(Map<String, Object> searchMap) throws Exception;

	Map<String, Object> getMemberList(MemberVO searchVO) throws Exception;

	int getMemberIdCnt(MemberVO searchVO) throws Exception;

	void insertMemberVO(MemberVO searchVO) throws Exception;

	MemberVO getMemberVO(MemberVO searchVO) throws Exception;

	void updateMemberVO(MemberVO searchVO) throws Exception;

	void updateFileMemberVO(MemberVO searchVO) throws Exception;
	
	void deleteMemberVO(MemberVO searchVO) throws Exception;
	
	//인증키 유무 확인 
	int getMemberCertSerchCnt(MemberVO searchVO) throws Exception;

	//인증 유무 확인 	
	MemberVO getCertSerchMember(MemberVO searchVO) throws Exception;
	
	//인증 및 로그인 유무 업데이트
	void getCertMemberUpdate(MemberVO searchVO) throws Exception;

	List<MemberVO> getMemberAllList();
		
}
