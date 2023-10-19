package com.adms.common.site.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.tbl_siteVO;

public interface SiteManageService {

	Map<String, Object> getList(tbl_siteVO searchVO);

	void insertDB(tbl_siteVO searchVO);

	tbl_siteVO getDetailVO(tbl_siteVO searchVO);

	void updateVO(tbl_siteVO searchVO);

	void deleteVO(tbl_siteVO searchVO);

	List<tbl_siteVO> getListAll();
	
}
