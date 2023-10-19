package com.bsite.mo.visual.service.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_studyVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("StudyDao")
public class StudyDao extends EgovAbstractMapper {

	public List<mo_studyVO> selectStudyList(mo_studyVO searchVO) {
		return selectList("selectStudyList", searchVO);
	}
	
	public int selectStudyListCnt(mo_studyVO searchVO) {
		return selectOne("selectStudyListCnt", searchVO);
	}
	
	public List<mo_studyVO> selectStudyListByPreset(int ps_idx) {
		return selectList("selectStudyListByPreset", ps_idx);
	}
	
	public mo_studyVO selectStudyByIdx(int wp_idx) {
		return selectOne("selectStudyByIdx", wp_idx);
	}
	
	public void createStudy(mo_studyVO searchVO) {
		insert("createStudy", searchVO);
	}

	public void updateStudy(mo_studyVO searchVO) {
		update("updateStudy", searchVO);
	}
	
	public void updateStudySave(mo_studyVO searchVO) {
		update("updateStudySave", searchVO);
	}

	public void deleteStudy(mo_studyVO searchVO) {
		update("deleteStudy", searchVO);
	}
	
	public List<mo_studyVO> selectPresetStudyList(mo_studyVO searchVO) {
		return selectList("selectPresetStudyList", searchVO);
	}

	public int selectPresetStudyCount(mo_studyVO searchVO) {
		return selectOne("selectPresetStudyCount", searchVO);
	}

}
