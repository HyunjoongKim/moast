package com.bsite.mo.visual.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_heatmapVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("HeatmapDao")
public class HeatmapDao extends EgovAbstractMapper {

	public List<mo_heatmapVO> selectHeatmapListByPreset(mo_heatmapVO searchVO) {
		return selectList("selectHeatmapListByPreset", searchVO);
	}

	public int selectHeatmapCountByPreset(mo_heatmapVO searchVO) {
		return selectOne("selectHeatmapCountByPreset", searchVO);
	}

	public mo_heatmapVO selectHeatmapByIdx(int ht_idx) {
		return selectOne("selectHeatmapByIdx", ht_idx);
	}

	public void createHeatmap(mo_heatmapVO searchVO) {
		insert("createHeatmap", searchVO);
	}
	
	public void updateHeatmap(mo_heatmapVO searchVO) {
		update("updateHeatmap", searchVO);

	}

	public void deleteHeatmap(mo_heatmapVO searchVO) {
		update("deleteHeatmap", searchVO);

	}

}
