package com.adms.mo.visual.service;

import java.util.Map;

import com.bsite.vo.mo_work_presetVO;

public interface WorkPresetService {

	Map<String, Object> selectWorkPresetList(mo_work_presetVO searchVO) throws Exception;

	void createWorkPreset(mo_work_presetVO searchVO) throws Exception;

	void updateWorkPreset(mo_work_presetVO searchVO) throws Exception;

	void deleteWorkPreset(mo_work_presetVO searchVO) throws Exception;

	mo_work_presetVO selectWorkPresetById(int wp_idx) throws Exception;

}
