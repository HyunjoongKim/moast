package com.bsite.account.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.account.service.AccountService;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("AccountService")
public class AccountServiceImpl extends EgovAbstractServiceImpl implements AccountService{

	@Resource
	private AccountDAO dao;

	@Override
	public List<MemberVO> getMemberVOList(MemberVO searchVO) throws Exception {
		return dao.getMemberVOList(searchVO);
	}

	@Override
	public MemberVO getMemberVO(MemberVO searchVO) throws Exception {
		return dao.getMemberVO(searchVO);
	}

	@Override
	public void initPassword(MemberVO memberVO) throws Exception {
		String enpassword = EgovFileScrty.encryptPassword(memberVO.getMe_pwd().trim());
		memberVO.setMe_pwd(enpassword);
		dao.initPassword(memberVO);
	}


}
