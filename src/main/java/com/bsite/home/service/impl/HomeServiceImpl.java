package com.bsite.home.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.home.service.HomeService;
import com.bsite.vo.tbl_equipVO;
import com.bsite.vo.tbl_pdsVO;

@Service("HomeService")
public class HomeServiceImpl implements HomeService{

	@Resource
	private HomeDao dao;
	
	@Resource
	private HomeDaoHB daoHB;

	@Override
	public List<?> getTest() throws Exception {
		return dao.getTest();
	}

	@Override
	public List<tbl_pdsVO> getBoardList(Map<String, Object> searchMap) throws Exception {
		return dao.getBoardList(searchMap);
	}

	

	@Override
	public List<tbl_equipVO> getTeList(Map<String, Object> searchMap) {
		return daoHB.getTeList(searchMap);
	}

}
