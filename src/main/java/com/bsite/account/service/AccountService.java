package com.bsite.account.service;

import java.util.List;

import com.bsite.vo.MemberVO;

public interface AccountService {

	List<MemberVO> getMemberVOList(MemberVO searchVO) throws Exception;

	MemberVO getMemberVO(MemberVO searchVO) throws Exception;

	void initPassword(MemberVO memberVO) throws Exception;


}
