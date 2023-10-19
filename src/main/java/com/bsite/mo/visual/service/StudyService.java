package com.bsite.mo.visual.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.mo_studyVO;

public interface StudyService {

	Map<String, Object> selectStudyList(mo_studyVO searchVO) throws Exception;

	void createStudy(mo_studyVO searchVO) throws Exception;

	void updateStudy(mo_studyVO searchVO) throws Exception;
	
	void updateStudySave(mo_studyVO searchVO) throws Exception;

	void deleteStudy(mo_studyVO searchVO) throws Exception;

	mo_studyVO selectStudyByIdx(int wp_idx) throws Exception;

	List<mo_studyVO> selectStudyListByPreset(int ps_idx) throws Exception;

	

}
