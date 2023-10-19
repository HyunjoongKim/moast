package com.bsite.account.service;

import java.util.Map;

import com.bsite.vo.MemberVO;

public interface MyPageService {

	MemberVO getMemberVO(MemberVO searchVO) throws Exception;

	Map<String, Object> getMetaCntByMember(MemberVO searchVO) throws Exception;



}
