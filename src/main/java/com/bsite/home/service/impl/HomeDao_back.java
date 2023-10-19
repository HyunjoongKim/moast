package com.bsite.home.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.tbl_pdsVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("HomeDao")
public class HomeDao_back extends EgovComAbstractDAO{

	public List<?> getTest() {
		return list("bsite.home.getTest","");
	}

	@SuppressWarnings("unchecked")
	public List<tbl_pdsVO> getBoardList(Map<String, Object> searchMap) {
		return (List<tbl_pdsVO>) list("bsite.home.getBoardList",searchMap);
	}

}
