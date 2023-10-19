package com.bsite.mo.visual.service;

import java.util.Map;

import com.bsite.vo.mo_presetVO;
import com.bsite.vo.mo_preset_shareVO;

public interface PresetService {

	
	Map<String, Object> selectPresetList(mo_presetVO searchVO) throws Exception;
	
	mo_presetVO selectPresetByIdx(mo_presetVO searchVO) throws Exception;
	
	void createPreset(mo_presetVO searchVO) throws Exception;

	void updatePreset(mo_presetVO searchVO) throws Exception;
	
	void updatePresetShare(mo_presetVO searchVO) throws Exception;

	void deletePreset(mo_presetVO searchVO) throws Exception;
	
	Map<String, Object> selectPresetShareList(mo_preset_shareVO searchVO) throws Exception;

	Map<String, Object> selectPresetSharedList(mo_presetVO searchVO) throws Exception;

	

}


