package com.bsite.mo.visual.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_presetVO;
import com.bsite.vo.mo_preset_shareVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("PresetDao")
public class PresetDao extends EgovAbstractMapper {

	public List<mo_presetVO> selectPresetList(mo_presetVO searchVO) {
		return selectList("selectPresetList", searchVO);
	}

	public int selectPresetCount(mo_presetVO searchVO) {
		return selectOne("selectPresetCount", searchVO);
	}

	public mo_presetVO selectPresetByIdx(int ht_idx) {
		return selectOne("selectPresetByIdx", ht_idx);
	}

	public List<mo_preset_shareVO> selectPresetShareList(mo_preset_shareVO searchVO) {
		return selectList("selectPresetShareList", searchVO);
	}

	public int selectPresetShareCount(mo_preset_shareVO searchVO) {
		return selectOne("selectPresetShareCount", searchVO);
	}
	
	public List<mo_presetVO> selectPresetSharedList(mo_presetVO searchVO) {
		return selectList("selectPresetSharedList", searchVO);
	}

	public int selectPresetSharedCount(mo_presetVO searchVO) {
		return selectOne("selectPresetSharedCount", searchVO);
	}

	public void createPreset(mo_presetVO searchVO) {
		insert("createPreset", searchVO);
	}
	
	public void createPresetStudy(mo_presetVO searchVO) {
		insert("createPresetStudy", searchVO);
	}

	public void updatePreset(mo_presetVO searchVO) {
		update("updatePreset", searchVO);

	}
	
	public void updatePresetShare(mo_presetVO searchVO) {
		update("updatePresetShare", searchVO);
		
	}

	public void deletePreset(mo_presetVO searchVO) {
		update("deletePreset", searchVO);

	}

}
