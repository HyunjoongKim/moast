package com.adms.common.log.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_siteLogVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
@Repository("SiteLogDaoMbts")
public class SiteLogDaoMbts extends EgovAbstractMapper{

	public tbl_siteLogVO siteLogInsertPrevCheck(tbl_siteLogVO svo) {
		return selectOne("siteLogInsertPrevCheck", svo);
	}

	public List<tbl_siteLogVO> browserinfo(tbl_siteLogVO searchVO) {
		return selectList("siteLogBrowserinfo", searchVO);
	}

	public List<tbl_siteLogVO> osinfo(tbl_siteLogVO searchVO) {
		return selectList("siteLogOsinfo", searchVO);
	}

	public List<tbl_siteLogVO> todayinfo(tbl_siteLogVO searchVO) {
		return selectList("siteLogTodayinfo", searchVO);
	}

	public List<tbl_siteLogVO> monthinfo(tbl_siteLogVO searchVO) {
		return selectList("siteLogMonthinfo", searchVO);
	}

	public List<tbl_siteLogVO> totalCnt(tbl_siteLogVO searchVO) {
		return selectList("siteLogTotalCnt", searchVO);
	}

	public List<tbl_siteLogVO> connecttimeinfo(tbl_siteLogVO searchVO) {
		return selectList("siteLogConnecttimeinfo", searchVO);
	}

	public List<tbl_menuLogVO> menuTopCount(tbl_menuLogVO searchVO) {
		return selectList("siteLogMenuTopCount", searchVO);
	}

	public tbl_menuLogVO getPrtMenuCate(tbl_menuLogVO searchVO) {
		return selectOne("siteLogGetPrtMenuCate", searchVO);
	}
	
}
