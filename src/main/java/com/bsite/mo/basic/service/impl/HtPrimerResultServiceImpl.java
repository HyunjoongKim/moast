package com.bsite.mo.basic.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.mo.basic.service.HtPrimerResultService;
import com.bsite.vo.HtPrimerResultVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("HtPrimerResultService")
public class HtPrimerResultServiceImpl extends EgovAbstractServiceImpl implements HtPrimerResultService {
	
	@Resource
	private HtPrimerResultDAO dao;
	
	@Override
	public void save(HtPrimerResultVO vo) {
		dao.save(vo);
	}
	
	@Override
	public Map<String, Object> selectHtPrimerResults(HtPrimerResultVO searchVO) throws Exception {
		List<HtPrimerResultVO> result = dao.selectHtPrimerResultList(searchVO);
		int cnt = result.size();

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public HtPrimerResultVO selectHtPrimerResult(int recordIdx) {
		return dao.selectHtPrimerResult(recordIdx);
	}
	
}

	
