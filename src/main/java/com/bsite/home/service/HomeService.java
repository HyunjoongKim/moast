package com.bsite.home.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.tbl_equipVO;
import com.bsite.vo.tbl_pdsVO;

public interface HomeService {

	List<?> getTest() throws Exception;

	List<tbl_pdsVO> getBoardList(Map<String, Object> searchMap) throws Exception;

	

	List<tbl_equipVO> getTeList(Map<String, Object> searchMap);

}
