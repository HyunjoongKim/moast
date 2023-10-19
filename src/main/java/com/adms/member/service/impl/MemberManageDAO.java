package com.adms.member.service.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.cmm.service.impl.MybatisManageDaoSupport;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("MemberManageDAO")
public class MemberManageDAO  extends EgovAbstractMapper{

	public List<MemberVO> getMemberList(MemberVO searchVO) {
		return selectList("MemberManageDAOgetMemberList", searchVO);		
	}

	public int getMemberListCnt(MemberVO searchVO) {
		return selectOne("MemberManageDAOgetMemberListCnt", searchVO);
	}

	public void insertMemberVO(MemberVO searchVO) {
		insert("MemberManageDAOinsertMemberVO", searchVO);
	}

	public MemberVO getMemberVO(MemberVO searchVO) {
		return selectOne("MemberManageDAOgetMemberVO", searchVO);
	}

	public void updateMemberVO(MemberVO searchVO) {
		update("MemberManageDAOupdateMemberVO", searchVO);
	}

	public void deleteMemberVO(MemberVO searchVO) {
		update("MemberManageDAOdeleteMemberVO", searchVO);
	}

	public int getMemberIdCnt(MemberVO searchVO) {
		return selectOne("MemberManageDAOgetMemberIdCnt", searchVO);
	}

	public List<CommonCodeVO> getAuthList(Map<String, Object> searchMap) {
		return selectList("MemberManageDAOgetAuthList", searchMap);
	}

	public void updatePassword(MemberVO searchVO) {
		update("MemberManageDAOupdatePassword", searchVO);
	}
	
	//로그인 횟수 초기화 추가 [날짜:2017-10-27 작업자:연순모] 
	public void loginCntReset(MemberVO searchVO) {
		update("MemberManageDAOloginCntReset", searchVO);
	}
	
}
