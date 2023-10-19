package com.adms.member.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.adms.member.service.MemberManageService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MemberManageService")
public class MemberManageServiceImpl extends EgovAbstractServiceImpl implements MemberManageService{

	@Resource
	private MemberManageDAO dao;

	@Override
	public Map<String, Object> getMemberList(MemberVO searchVO) throws Exception {
		List<MemberVO> result = dao.getMemberList(searchVO);
		int cnt = dao.getMemberListCnt(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;
	}

	@Override
	public void insertMemberVO(MemberVO searchVO) throws Exception {
		String enpassword = EgovFileScrty.encryptPassword(searchVO.getMe_pwd().trim());
		searchVO.setMe_pwd(enpassword);
		if(StringUtils.isEmpty(searchVO.getMe_email_yn())) searchVO.setMe_email_yn("N");
		dao.insertMemberVO(searchVO);
	}

	@Override
	public MemberVO getMemberVO(MemberVO searchVO) throws Exception {
		return dao.getMemberVO(searchVO);
	}

	@Override
	public void updateMemberVO(MemberVO searchVO) throws Exception {
		if(StringUtils.isNotBlank(searchVO.getMe_pwd().trim())){
			String enpassword = EgovFileScrty.encryptPassword(searchVO.getMe_pwd());
			searchVO.setMe_pwd(enpassword);
		}
		if(StringUtils.isEmpty(searchVO.getMe_email_yn())) searchVO.setMe_email_yn("N");
		dao.updateMemberVO(searchVO);
	}

	@Override
	public void deleteMemberVO(MemberVO searchVO) throws Exception {
		dao.deleteMemberVO(searchVO);
	}

	@Override
	public int getMemberIdCnt(MemberVO searchVO) throws Exception {
		return dao.getMemberIdCnt(searchVO);
	}

	@Override
	public List<CommonCodeVO> getAuthList(Map<String, Object> searchMap) throws Exception {
		return  dao.getAuthList(searchMap);
	}

	@Override
	public void updatePassword(MemberVO searchVO) throws Exception {
		dao.updatePassword(searchVO);
	}

	//로그인 횟수 초기화 추가 [날짜:2017-10-27 작업자:연순모]
	@Override
	public void loginCntReset(MemberVO searchVO) throws Exception {
		dao.loginCntReset(searchVO);
	}
}
