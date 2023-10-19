package com.adms.member.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.MemberVO;

public interface MemberManageService {

	Map<String, Object> getMemberList(MemberVO searchVO) throws Exception;

	void insertMemberVO(MemberVO searchVO) throws Exception;

	MemberVO getMemberVO(MemberVO searchVO) throws Exception;

	void updateMemberVO(MemberVO searchVO) throws Exception;

	void deleteMemberVO(MemberVO searchVO) throws Exception;

	int getMemberIdCnt(MemberVO searchVO) throws Exception;

	List<CommonCodeVO> getAuthList(Map<String, Object> searchMap) throws Exception;

	void updatePassword(MemberVO searchVO) throws Exception;

	//로그인 횟수 초기화 추가 [날짜:2017-10-27 작업자:연순모]
	void loginCntReset(MemberVO searchVO) throws Exception;
}
