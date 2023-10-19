package com.bsite.mo.analysisdata.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.mo.analysisdata.service.AnalysisDataService;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.mo_analysisDataVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("AnalysisDataService")
public class AnalysisDataServiceImpl extends EgovAbstractServiceImpl implements AnalysisDataService {

	@Resource
	private AnalysisDataDao dao;

	@Override
	public void createAnalysisData(mo_analysisDataVO searchVO) {
		dao.createAnalysisData(searchVO);
	}

	@Override
	public Map<String, Object> selectAnalysisDataList(mo_analysisDataVO searchVO) throws Exception {
		List<mo_analysisDataVO> result = dao.selectAnalysisDataList(searchVO);
		int cnt = dao.selectAnalysisDataCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public mo_analysisDataVO selectAnalysisDataById(mo_analysisDataVO searchVO) throws Exception {
		return dao.selectAnalysisDataById(searchVO);
	}

	@Override
	public void updateAnalysisData(mo_analysisDataVO searchVO) throws Exception {
		dao.updateAnalysisData(searchVO);
	}
	
	@Override
	public void updateAnalysisDataStatus(mo_analysisDataVO searchVO) throws Exception {
		dao.updateAnalysisDataStatus(searchVO);
	}

	@Override
	public void deleteAnalysisData(mo_analysisDataVO searchVO) throws Exception {
		dao.deleteAnalysisData(searchVO);
	}

	

}
