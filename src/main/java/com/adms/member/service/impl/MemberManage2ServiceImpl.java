package com.adms.member.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.adms.member.service.MemberManage2Service;
import com.bsite.vo.AuthVO;
import com.bsite.vo.MemberVO;
import com.bsite.vo.tbl_siteLogVO;

import egovframework.com.cmm.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MemberManage2Service")
public class MemberManage2ServiceImpl extends EgovAbstractServiceImpl implements MemberManage2Service{

	@Resource
	private MemberManage2DAO dao;

	@Override
	public List<AuthVO> getAuthList(Map<String, Object> searchMap) throws Exception {
		return dao.getAuthList(searchMap);
	}

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
	public int getMemberIdCnt(MemberVO searchVO) throws Exception {
		return dao.getMemberIdCnt(searchVO);
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
	public void updateFileMemberVO(MemberVO searchVO) throws Exception {
		dao.updateFileMemberVO(searchVO);
	}
	
	@Override
	public void deleteMemberVO(MemberVO searchVO) throws Exception {
		dao.deleteMemberVO(searchVO);
	}

	//인증키 발급 받은 회원 유무 확인 
	@Override
	public int getMemberCertSerchCnt(MemberVO searchVO) throws Exception {
		return dao.getMemberCertSerchCnt(searchVO);
	}

	//인증 유무 확인 
	@Override
	public MemberVO getCertSerchMember(MemberVO searchVO) throws Exception {
		return dao.getCertSerchMember(searchVO);
	}
	
	//인증 및 로그인 유무 업데이트
	@Override
	public void getCertMemberUpdate(MemberVO searchVO) throws Exception {
		dao.getCertMemberUpdate(searchVO);
	}

	@Override
	public List<MemberVO> getMemberAllList() { 
		return dao.getMemberAllList();
	}
	
	
}
