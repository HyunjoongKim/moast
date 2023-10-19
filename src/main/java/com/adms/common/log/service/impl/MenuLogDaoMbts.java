package com.adms.common.log.service.impl;

import org.springframework.stereotype.Repository;

import com.bsite.vo.tbl_menuLogVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
@Repository("MenuLogDaoMbts")
public class MenuLogDaoMbts extends EgovAbstractMapper{

	public tbl_menuLogVO menuLogInsertPrevCheck(tbl_menuLogVO mvo) {
		return selectOne("menuLogInsertPrevCheck", mvo);
	}
	
}
