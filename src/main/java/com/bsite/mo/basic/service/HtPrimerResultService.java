package com.bsite.mo.basic.service;

import java.util.Map;

import com.bsite.vo.HtPrimerResultVO;

public interface HtPrimerResultService {
	
	public void save(HtPrimerResultVO searchVO);
	
	Map<String, Object> selectHtPrimerResults(HtPrimerResultVO searchVO) throws Exception;
	
	HtPrimerResultVO selectHtPrimerResult(int recordIdx);

	
}
