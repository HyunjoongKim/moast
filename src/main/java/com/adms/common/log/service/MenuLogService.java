package com.adms.common.log.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_siteLogVO;
import com.bsite.vo.tbl_siteVO;

public interface MenuLogService {

	List<tbl_menuLogVO> getMenuLogList(tbl_menuLogVO searchVO) throws Exception;
	
	Integer getMenuLogListCnt(tbl_menuLogVO searchVO) throws Exception;
	
	List<tbl_siteVO> getSiteList() throws Exception;
		
	Integer getSearchMenu(tbl_menu_manageVO searchVO) throws Exception;
	
    void  getInsertMenuLog(HttpServletRequest request, tbl_menuLogVO mvo) throws Exception;

	boolean menuInsertPrevCheck(tbl_menuLogVO mvo);
	
    
}
