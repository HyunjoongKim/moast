package com.bsite.mo.visual.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.bsite.mo.visual.service.StudyService;
import com.bsite.vo.mo_studyVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("StudyService")
public class StudyServiceImpl extends EgovAbstractServiceImpl implements StudyService {

	@Resource
	private StudyDao dao;
	
	@Override
	public Map<String, Object> selectStudyList(mo_studyVO searchVO) throws Exception {
		List<mo_studyVO> result = dao.selectStudyList(searchVO);
		int cnt = dao.selectStudyListCnt(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	private void mkdir(mo_studyVO searchVO) {
		String path = OmicsDataUtils.getWorkspacePath(searchVO.getUd_idx()) + "s" + searchVO.getStd_idx();
		File dir = new File(path);
		if (!dir.exists())
			dir.mkdirs();
	}
	
	
	@Override
	public mo_studyVO selectStudyByIdx(int std_idx) throws Exception {
		return dao.selectStudyByIdx(std_idx);
	}
	
	@Override
	public void createStudy(mo_studyVO searchVO) {
		dao.createStudy(searchVO);
		
		mkdir(searchVO);
	}

	@Override
	public void updateStudy(mo_studyVO searchVO) throws Exception {
		dao.updateStudy(searchVO);
		
		mkdir(searchVO);
	}
	
	@Override
	public void updateStudySave(mo_studyVO searchVO) throws Exception {
		dao.updateStudySave(searchVO);
		
		mkdir(searchVO);
	}

	@Override
	public void deleteStudy(mo_studyVO searchVO) throws Exception {
		dao.deleteStudy(searchVO);
	}

	@Override
	public List<mo_studyVO> selectStudyListByPreset(int ps_idx) throws Exception {
		return dao.selectStudyListByPreset(ps_idx);
	}

}
