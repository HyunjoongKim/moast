package com.bsite.account.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.MemberVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("MyPageDAO")
public class MyPageDAO extends EgovAbstractMapper{

	public MemberVO getMemberVO(MemberVO searchVO) {
		return selectOne("MyPageDAOgetMemberVO", searchVO);
	}

	public Map<String, Object> getMetaCntByMember(MemberVO searchVO) {
		return selectOne("MyPageDAOgetMetaCntByMember", searchVO);
	}

}
