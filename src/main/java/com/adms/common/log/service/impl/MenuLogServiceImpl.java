package com.adms.common.log.service.impl;


import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.adms.common.log.service.MenuLogService;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_siteLogVO;
import com.bsite.vo.tbl_siteVO;
import com.bsite.vo.tbl_menuLogVO;
import com.bsite.cmm.CommonFunctions;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("MenuLogService")
public class MenuLogServiceImpl extends EgovAbstractServiceImpl implements MenuLogService{
	
	@Resource
	private MenuLogDao dao;
	
	@Resource
	private MenuLogDaoMbts daoMbts;


	public List<tbl_menuLogVO> getMenuLogList(tbl_menuLogVO searchVO) throws Exception{
		return dao.getMenuLogList(searchVO);
	}
	
	public Integer getMenuLogListCnt(tbl_menuLogVO searchVO)  throws Exception {
		return dao.getMenuLogListCnt(searchVO);
	}

	public List<tbl_siteVO> getSiteList()   throws Exception {
		return dao.getSiteList();
	}

	
	public Integer getSearchMenu(tbl_menu_manageVO searchVO)  throws Exception {
		return dao.getSearchMenu(searchVO);
	}
	
	public void  getInsertMenuLog(HttpServletRequest request,tbl_menuLogVO menuLog) throws Exception {
	
		Map<String, Object> map = CommonFunctions.broswserInfo(request);
				
		menuLog.setCret_ip((String)map.get("ip"));
		menuLog.setOs((String)map.get("os"));
		menuLog.setInfor((String)map.get("header"));
		menuLog.setBrowser((String)map.get("broswser"));		
		dao.getInsertMenuLog(menuLog);
	}


	@Override
	public boolean menuInsertPrevCheck(tbl_menuLogVO mvo) {
		tbl_menuLogVO  slv= daoMbts.menuLogInsertPrevCheck(mvo);
		if(slv==null) return false;
		if(slv.getDifsecond()==0 || (slv.getDifsecond() > slv.getsSecond())) {
			return true;
		}else{
			return false;
		}		
	}

	
	

	
}
