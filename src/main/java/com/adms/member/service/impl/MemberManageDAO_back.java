package com.adms.member.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("MemberManageDAO")
public class MemberManageDAO_back  extends EgovComAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<MemberVO> getMemberList(MemberVO searchVO) {
		return (List<MemberVO>) list("MemberManageDAO.getMemberList", searchVO);
	}

	@SuppressWarnings("deprecation")
	public int getMemberListCnt(MemberVO searchVO) {
		return (Integer)getSqlMapClientTemplate().queryForObject("MemberManageDAO.getMemberListCnt", searchVO);
	}

	public void insertMemberVO(MemberVO searchVO) {
		insert("MemberManageDAO.insertMemberVO", searchVO);
	}

	public MemberVO getMemberVO(MemberVO searchVO) {
		return (MemberVO)select("MemberManageDAO.getMemberVO", searchVO);
	}

	public void updateMemberVO(MemberVO searchVO) {
		update("MemberManageDAO.updateMemberVO", searchVO);
	}

	public void deleteMemberVO(MemberVO searchVO) {
		update("MemberManageDAO.deleteMemberVO", searchVO);
	}

	@SuppressWarnings("deprecation")
	public int getMemberIdCnt(MemberVO searchVO) {
		return (Integer)getSqlMapClientTemplate().queryForObject("MemberManageDAO.getMemberIdCnt", searchVO);
	}

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getAuthList(Map<String, Object> searchMap) {
		return (List<CommonCodeVO>) list("MemberManageDAO.getAuthList", searchMap);
	}

	public void updatePassword(MemberVO searchVO) {
		update("MemberManageDAO.updatePassword", searchVO);
	}

}
