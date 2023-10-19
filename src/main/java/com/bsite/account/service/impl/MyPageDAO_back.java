package com.bsite.account.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.MemberVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("MyPageDAO")
public class MyPageDAO_back extends EgovComAbstractDAO{

	public MemberVO getMemberVO(MemberVO searchVO) {
		return (MemberVO)select("MyPageDAO.getMemberVO", searchVO);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getMetaCntByMember(MemberVO searchVO) {
		return (Map<String, Object>) select("MyPageDAO.getMetaCntByMember", searchVO);
	}

}
