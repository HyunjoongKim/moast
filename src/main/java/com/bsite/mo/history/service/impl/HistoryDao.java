package com.bsite.mo.history.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_historyVO;
import com.bsite.vo.mo_history_shareVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("HistoryDao")
public class HistoryDao extends EgovAbstractMapper {

	public List<mo_historyVO> selectHistoryList(mo_historyVO searchVO) {
		return selectList("selectHistoryList", searchVO);
	}
	
	public int selectHistoryCount(mo_historyVO searchVO) {
		return selectOne("selectHistoryCount", searchVO);
	}
	
	public List<mo_history_shareVO> selectHistorysList(mo_history_shareVO searchVO) {
		return selectList("selectHistorysList", searchVO);
	}
	
	public int selectHistorysCount(mo_history_shareVO searchVO) {
		return selectOne("selectHistorysCount", searchVO);
	}
	
	public List<mo_historyVO> selectHistoryOList(mo_historyVO searchVO) {
		return selectList("selectHistoryOList", searchVO);
	}
	
	public int selectHistoryOCount(mo_historyVO searchVO) {
		return selectOne("selectHistoryOCount", searchVO);
	}

	public void createHistory(mo_historyVO searchVO) {
		insert("createHistory", searchVO);
		
	}

	public void updateHistory(mo_historyVO searchVO) {
		update("updateHistory", searchVO);
		
	}

	public void deleteHistory(mo_historyVO searchVO) {
		update("deleteHistory", searchVO);
		
	}

	public mo_historyVO selectHistoryByIdx(int ht_idx) {
		return selectOne("selectHistoryByIdx", ht_idx);
	}

}
