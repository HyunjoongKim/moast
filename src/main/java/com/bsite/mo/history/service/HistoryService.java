package com.bsite.mo.history.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.mo_historyVO;
import com.bsite.vo.mo_history_shareVO;

public interface HistoryService {

	void createHistory(mo_historyVO searchVO) throws Exception;
	
	mo_historyVO selectHistoryByIdx(int ht_idx) throws Exception;

	Map<String, Object> selectHistoryList(mo_historyVO searchVO) throws Exception;
	
	Map<String, Object> selectHistorysList(mo_history_shareVO searchVO) throws Exception;
	
	Map<String, Object> selectHistoryOList(mo_historyVO searchVO) throws Exception;

	void updateHistory(mo_historyVO searchVO) throws Exception;

	void deleteHistory(mo_historyVO searchVO) throws Exception;

	

}
