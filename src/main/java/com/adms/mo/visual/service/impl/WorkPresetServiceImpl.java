package com.adms.mo.visual.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.adms.mo.visual.service.WorkPresetService;
import com.bsite.vo.mo_work_presetVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("WorkPresetService")
public class WorkPresetServiceImpl extends EgovAbstractServiceImpl implements WorkPresetService {

	@Resource
	private WorkPresetDao dao;
	
	@Override
	public Map<String, Object> selectWorkPresetList(mo_work_presetVO searchVO) throws Exception {
		List<mo_work_presetVO> result = dao.selectWorkPresetList(searchVO);
		int cnt = dao.selectWorkPresetListCnt(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public mo_work_presetVO selectWorkPresetById(int wp_idx) throws Exception {
		return dao.selectWorkPresetById(wp_idx);
	}
	
	@Override
	public void createWorkPreset(mo_work_presetVO searchVO) {
		dao.createWorkPreset(searchVO);
		
		String path = OmicsDataUtils.WORKSPACE_TEMP + searchVO.getWs_idx() + "/" + searchVO.getWp_idx();
		File dir = new File(path);
		if (!dir.exists())
			dir.mkdirs();
	}

	@Override
	public void updateWorkPreset(mo_work_presetVO searchVO) throws Exception {
		dao.updateWorkPreset(searchVO);
	}

	@Override
	public void deleteWorkPreset(mo_work_presetVO searchVO) throws Exception {
		dao.deleteWorkPreset(searchVO);
	}

}
