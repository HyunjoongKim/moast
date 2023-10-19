package com.bsite.mo.analysisdata.service;

import java.util.Map;

import com.bsite.vo.mo_analysisDataVO;

public interface AnalysisDataService {

	void createAnalysisData(mo_analysisDataVO searchVO) throws Exception;
	
	mo_analysisDataVO selectAnalysisDataById(mo_analysisDataVO searchVO) throws Exception;

	Map<String, Object> selectAnalysisDataList(mo_analysisDataVO searchVO) throws Exception;

	void updateAnalysisData(mo_analysisDataVO searchVO) throws Exception;

	void deleteAnalysisData(mo_analysisDataVO searchVO) throws Exception;

	void updateAnalysisDataStatus(mo_analysisDataVO searchVO) throws Exception;

}
