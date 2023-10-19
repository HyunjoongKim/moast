package com.bsite.home.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.tbl_pdsVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("HomeDao")
public class HomeDao extends EgovAbstractMapper{

	public List<?> getTest() {
		return selectList("bsitehomegetTest","");
	}

	public List<tbl_pdsVO> getBoardList(Map<String, Object> searchMap) {
		return selectList("bsitehomegetBoardList",searchMap);
	}

}
