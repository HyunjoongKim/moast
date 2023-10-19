package com.bsite.mo.visual.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.mo.visual.service.HeatmapService;
import com.bsite.vo.mo_heatmapVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("HeatmapService")
public class HeatmapServiceImpl extends EgovAbstractServiceImpl implements HeatmapService {

	@Resource
	private HeatmapDao dao;
	
	@Resource
	private StudyDao stdDao;

	@Override
	public Map<String, Object> selectHeatmapListByPreset(mo_heatmapVO searchVO) throws Exception {
		List<mo_heatmapVO> resultList = dao.selectHeatmapListByPreset(searchVO);
		int cnt = dao.selectHeatmapCountByPreset(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", resultList);
		map.put("resultCnt", Integer.toString(cnt));

		return map;
	}

	@Override
	public mo_heatmapVO selectHeatmapByIdx(mo_heatmapVO searchVO) throws Exception {
		return dao.selectHeatmapByIdx(searchVO.getHm_idx()); 
	}

	@Override
	public void createHeatmap(mo_heatmapVO searchVO) throws Exception {
		dao.createHeatmap(searchVO);
	}

	@Override
	public void updateHeatmap(mo_heatmapVO searchVO) throws Exception {
		dao.updateHeatmap(searchVO);
	}

	@Override
	public void deleteHeatmap(mo_heatmapVO searchVO) throws Exception {
		dao.deleteHeatmap(searchVO);
	}

}
