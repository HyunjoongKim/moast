package com.bsite.account.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.account.service.MyPageService;
import com.bsite.vo.MemberVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MyPageService")
public class MyPageServiceImpl extends EgovAbstractServiceImpl implements MyPageService{

	@Resource
	private MyPageDAO dao;

	@Override
	public MemberVO getMemberVO(MemberVO searchVO) throws Exception {
		return dao.getMemberVO(searchVO);
	}

	@Override
	public Map<String, Object> getMetaCntByMember(MemberVO searchVO) throws Exception {
		return dao.getMetaCntByMember(searchVO);
	}

}
