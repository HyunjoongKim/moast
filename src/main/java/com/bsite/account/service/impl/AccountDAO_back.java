package com.bsite.account.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.MemberVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("AccountDAO")
public class AccountDAO_back extends EgovComAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<MemberVO> getMemberVOList(MemberVO searchVO) {
		return (List<MemberVO>) list("AccountDAO.getMemberVOList", searchVO);
	}

	public MemberVO getMemberVO(MemberVO searchVO) {
		return (MemberVO)select("AccountDAO.getMemberVO", searchVO);
	}

	public void initPassword(MemberVO memberVO) {
		update("AccountDAO.initPassword", memberVO);
	}

}
