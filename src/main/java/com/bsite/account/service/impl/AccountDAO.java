package com.bsite.account.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.MemberVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("AccountDAO")
public class AccountDAO extends EgovAbstractMapper{

	public List<MemberVO> getMemberVOList(MemberVO searchVO) {
		return selectList("AccountDAOgetMemberVOList", searchVO);
	}

	public MemberVO getMemberVO(MemberVO searchVO) {
		return selectOne("AccountDAOgetMemberVO", searchVO);
	}

	public void initPassword(MemberVO memberVO) {
		update("AccountDAOinitPassword", memberVO);
	}

}
