package com.adms.common.log.service.impl;


import java.util.List;

import javax.annotation.Resource;


import org.springframework.stereotype.Service;

import com.adms.common.log.service.AdminLogService;
import com.bsite.vo.tbl_adminLogVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("AdminLogService")
public class AdminLogServiceImpl extends EgovAbstractServiceImpl implements AdminLogService{
	
	@Resource
	private AdminLogDao dao;


	public List<tbl_adminLogVO> getAdminLogList(tbl_adminLogVO searchVO) throws Exception {
		return dao.getAdminLogList(searchVO);
	}

	public List<tbl_adminLogVO> getAdminLogIpList() throws Exception {
		return dao.getAdminLogIpList();
	}
	
	public Integer getAdminLogCnt(tbl_adminLogVO searchVO) throws Exception {
		return dao.getAdminLogCnt(searchVO);
	}
		
	public List<tbl_adminLogVO>	getAdminLogExcelList(tbl_adminLogVO searchVO) throws Exception {
		return dao.getAdminLogExcelList(searchVO);
	}
	
	public void insertAdminLog(tbl_adminLogVO searchVO) throws Exception{

		dao.insertAdminLog(searchVO);		

	}


}
