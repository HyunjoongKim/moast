package com.adms.common.log.service;

import java.util.List;

import com.bsite.vo.tbl_adminLogVO;

public interface AdminLogService {

	List<tbl_adminLogVO> getAdminLogList(tbl_adminLogVO searchVO) throws Exception;	
	
	List<tbl_adminLogVO> getAdminLogIpList()  throws Exception;
	
	List<tbl_adminLogVO> getAdminLogExcelList(tbl_adminLogVO searchVO) throws Exception;
	
	Integer getAdminLogCnt(tbl_adminLogVO searchVO) throws Exception;	
	
	void insertAdminLog(tbl_adminLogVO searchVO)  throws Exception;
	

}
