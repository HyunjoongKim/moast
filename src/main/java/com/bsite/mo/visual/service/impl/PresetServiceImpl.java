package com.bsite.mo.visual.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.bsite.mo.visual.service.PresetService;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.mo_presetVO;
import com.bsite.vo.mo_preset_shareVO;
import com.bsite.vo.mo_studyVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("PresetService")
public class PresetServiceImpl extends EgovAbstractServiceImpl implements PresetService {

	@Resource
	private PresetDao dao;
	
	@Resource
	private StudyDao stdDao;

	@Override
	public Map<String, Object> selectPresetList(mo_presetVO searchVO) throws Exception {
		List<mo_presetVO> resultList = dao.selectPresetList(searchVO);
		for(mo_presetVO i : resultList) {
			List<mo_studyVO> stdList = stdDao.selectStudyListByPreset(i.getPs_idx());
			i.setStudyList(stdList);
			List<OmicsDataVO> omicsList = new ArrayList<OmicsDataVO>();
			for(mo_studyVO stdVO : stdList) {
				OmicsDataVO omicsVO = OmicsDataUtils.parseSaved(stdVO);
				omicsList.add(omicsVO);
			}
			i.setOmicsList(omicsList);
		}
		int cnt = dao.selectPresetCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", resultList);
		map.put("resultCnt", Integer.toString(cnt));

		return map;
	}

	@Override
	public mo_presetVO selectPresetByIdx(mo_presetVO searchVO) throws Exception {
		mo_presetVO vo = dao.selectPresetByIdx(searchVO.getPs_idx());
		
		List<mo_studyVO> stdList = stdDao.selectStudyListByPreset(vo.getPs_idx());
		vo.setStudyList(stdList);
		
		
		String[] std_indices = StringUtils.split(searchVO.getStd_indices(), ",");
		
		List<OmicsDataVO> omicsList = new ArrayList<OmicsDataVO>();
		for(mo_studyVO stdVO : stdList) {
			OmicsDataVO omicsVO = OmicsDataUtils.parseSaved(stdVO);
			
			String std_idx = Integer.toString(stdVO.getStd_idx());
			if (std_indices != null && std_indices.length > 0) {
				if (Arrays.asList(std_indices).contains(std_idx)) {
					omicsList.add(omicsVO);
				}
			} else {
				omicsList.add(omicsVO);
			}
			
		}
		vo.setOmicsList(omicsList);
		
		return vo; 
	}

	@Override
	public void createPreset(mo_presetVO searchVO) throws Exception {
		dao.createPreset(searchVO);
		
		//String[] std_idx_arr = StringUtils.split(searchVO.getStd_idx_str(), ",");
		String[] std_idx_arr = searchVO.getStd_idx_arr();
		
		if (std_idx_arr != null) {
			for(String i : std_idx_arr) {
				mo_presetVO vo = new mo_presetVO();
				vo.setPs_idx(searchVO.getPs_idx());
				
				if ("0".equals(i)) 
					i = "9999";
				vo.setStd_idx(Integer.parseInt(i));
				
				dao.createPresetStudy(vo);
			}
			
		}
	}

	@Override
	public void updatePreset(mo_presetVO searchVO) throws Exception {
		dao.updatePreset(searchVO);
	}
	
	@Override
	public void updatePresetShare(mo_presetVO searchVO) throws Exception {
		dao.updatePresetShare(searchVO);
	}

	@Override
	public void deletePreset(mo_presetVO searchVO) throws Exception {
		dao.deletePreset(searchVO);
	}

	@Override
	public Map<String, Object> selectPresetShareList(mo_preset_shareVO searchVO) throws Exception {
		List<mo_preset_shareVO> result = dao.selectPresetShareList(searchVO);
		int cnt = dao.selectPresetShareCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public Map<String, Object> selectPresetSharedList(mo_presetVO searchVO) throws Exception {
		List<mo_presetVO> resultList = dao.selectPresetSharedList(searchVO);
		for(mo_presetVO i : resultList) {
			List<mo_studyVO> stdList = stdDao.selectStudyListByPreset(i.getPs_idx());
			i.setStudyList(stdList);
			List<OmicsDataVO> omicsList = new ArrayList<OmicsDataVO>();
			for(mo_studyVO stdVO : stdList) {
				OmicsDataVO omicsVO = OmicsDataUtils.parseSaved(stdVO);
				omicsList.add(omicsVO);
			}
			i.setOmicsList(omicsList);
		}
		int cnt = dao.selectPresetSharedCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", resultList);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}

}
