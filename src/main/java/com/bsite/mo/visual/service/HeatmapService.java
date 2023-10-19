package com.bsite.mo.visual.service;

import java.util.Map;

import com.bsite.vo.mo_heatmapVO;

public interface HeatmapService {

	
	Map<String, Object> selectHeatmapListByPreset(mo_heatmapVO searchVO) throws Exception;
	
	mo_heatmapVO selectHeatmapByIdx(mo_heatmapVO searchVO) throws Exception;
	
	void createHeatmap(mo_heatmapVO searchVO) throws Exception;

	void updateHeatmap(mo_heatmapVO searchVO) throws Exception;

	void deleteHeatmap(mo_heatmapVO searchVO) throws Exception;

}


