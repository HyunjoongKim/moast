package com.adms.common.log.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_siteLogVO;

public interface SiteLogService {

	List<tbl_siteLogVO> getSiteLogList(Map<String, Object> searchMap) throws Exception;
		
	Integer getlogTotalNum(List<tbl_siteLogVO> siteLogVO)  throws Exception;		
	
    void  getInsertSiteLog(HttpServletRequest request, tbl_siteLogVO svo) throws Exception;	
    
    List<tbl_siteLogVO> getRatioList(List<tbl_siteLogVO> siteLogVO, int totalNum)  throws Exception;

	boolean siteLogInsertPrevCheck(tbl_siteLogVO svo);

	List<tbl_siteLogVO> browserinfo(tbl_siteLogVO searchVO);

	List<tbl_siteLogVO> osinfo(tbl_siteLogVO searchVO);

	List<tbl_siteLogVO> todayinfo(tbl_siteLogVO searchVO);

	List<tbl_siteLogVO> monthinfo(tbl_siteLogVO searchVO);

	List<tbl_siteLogVO> totalCnt(tbl_siteLogVO searchVO);

	List<tbl_siteLogVO> connecttimeinfo(tbl_siteLogVO searchVO);

	List<tbl_menuLogVO> menuTopCount(tbl_menuLogVO searchVO);

	tbl_menuLogVO getPrtMenuCate(tbl_menuLogVO searchVO);
}
