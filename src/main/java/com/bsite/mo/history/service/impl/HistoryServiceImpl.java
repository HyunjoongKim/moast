package com.bsite.mo.history.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.bsite.mo.history.service.HistoryService;
import com.bsite.vo.mo_historyVO;
import com.bsite.vo.mo_history_shareVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("HistoryService")
public class HistoryServiceImpl extends EgovAbstractServiceImpl implements HistoryService {

	@Resource
	private HistoryDao dao;

	
	@Override
	public void createHistory(mo_historyVO searchVO) throws Exception {
		dao.createHistory(searchVO);
	}
	
	@Override
	public mo_historyVO selectHistoryByIdx(int ht_idx) throws Exception {
		
		return dao.selectHistoryByIdx(ht_idx);
	}

	@Override
	public Map<String, Object> selectHistoryList(mo_historyVO searchVO) throws Exception {
		List<mo_historyVO> result = dao.selectHistoryList(searchVO);
		int cnt = dao.selectHistoryCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public Map<String, Object> selectHistorysList(mo_history_shareVO searchVO) throws Exception {
		List<mo_history_shareVO> result = dao.selectHistorysList(searchVO);
		int cnt = dao.selectHistorysCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public Map<String, Object> selectHistoryOList(mo_historyVO searchVO) throws Exception {
		List<mo_historyVO> result = dao.selectHistoryOList(searchVO);
		int cnt = dao.selectHistoryOCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public void updateHistory(mo_historyVO searchVO) throws Exception {
		dao.updateHistory(searchVO);
	}

	@Override
	public void deleteHistory(mo_historyVO searchVO) throws Exception {
		dao.deleteHistory(searchVO);
	}

	


}
