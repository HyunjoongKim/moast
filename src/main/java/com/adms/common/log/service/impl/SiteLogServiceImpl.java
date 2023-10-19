package com.adms.common.log.service.impl;

import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.adms.common.log.service.SiteLogService;
import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_siteLogVO;
import com.bsite.cmm.CommonFunctions;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("SiteLogService")
public class SiteLogServiceImpl extends EgovAbstractServiceImpl implements SiteLogService{
	
	@Resource
	private SiteLogDao dao;

	@Resource
	private SiteLogDaoMbts daoMbts;

	public List<tbl_siteLogVO> getSiteLogList(Map<String, Object> searchMap) throws Exception{
		return dao.getSiteLogList(searchMap);
	}
	
	
	public Integer getlogTotalNum(List<tbl_siteLogVO> siteLogVO){
		
		Integer totalNum = 0;
		
		for(tbl_siteLogVO  result:siteLogVO){			
			totalNum = totalNum +result.getTotal();			
		}		
		return totalNum;		
	}
	
	
	public List<tbl_siteLogVO> getRatioList(List<tbl_siteLogVO> siteLogVO, int totalNum){
		
		try {
			DecimalFormat format = new DecimalFormat("0.00");
			
			for(int i=0; i<siteLogVO.size(); i++){
				double ratio = (double)siteLogVO.get(i).getTotal() / (double)totalNum * (double)100;
				siteLogVO.get(i).setRatio(format.format(ratio));										
			}
		
		}catch(Exception e) {
			System.out.println("crbase getRatioList exception :"+e.toString());
		}
		
		return siteLogVO;
		
	}
	
	
	public void  getInsertSiteLog(HttpServletRequest request, tbl_siteLogVO menuLog) throws Exception {
		try {
			Map<String, Object> map = CommonFunctions.broswserInfo(request);
			menuLog.setCret_ip((String)map.get("ip"));
			menuLog.setOs((String)map.get("os"));
			menuLog.setInfor((String)map.get("header"));
			menuLog.setBrowser((String)map.get("broswser"));	

			dao.getInsertSiteLog(menuLog);
		}catch(Exception e) {
			System.out.println("crbase getInsertSiteLog exception :"+e.toString());
		}
	}


	@Override
	public boolean siteLogInsertPrevCheck(tbl_siteLogVO svo) {
		tbl_siteLogVO  slv= daoMbts.siteLogInsertPrevCheck(svo);
		if(slv==null) return false;
		if(slv.getDifsecond()==0 || (slv.getDifsecond() > slv.getsSecond())) {
			return true;
		}else{
			return false;
		}		
	}


	@Override
	public List<tbl_siteLogVO> browserinfo(tbl_siteLogVO searchVO) {
		return daoMbts.browserinfo(searchVO);
	}


	@Override
	public List<tbl_siteLogVO> osinfo(tbl_siteLogVO searchVO) {
		return daoMbts.osinfo(searchVO);
	}


	@Override
	public List<tbl_siteLogVO> todayinfo(tbl_siteLogVO searchVO) {
		return daoMbts.todayinfo(searchVO);
	}


	@Override
	public List<tbl_siteLogVO> monthinfo(tbl_siteLogVO searchVO) {
		return daoMbts.monthinfo(searchVO);
	}


	@Override
	public List<tbl_siteLogVO> totalCnt(tbl_siteLogVO searchVO) {
		return daoMbts.totalCnt(searchVO);
	}


	@Override
	public List<tbl_siteLogVO> connecttimeinfo(tbl_siteLogVO searchVO) {
		return daoMbts.connecttimeinfo(searchVO);
	}


	@Override
	public List<tbl_menuLogVO> menuTopCount(tbl_menuLogVO searchVO) {
		return daoMbts.menuTopCount(searchVO);
	}


	@Override
	public tbl_menuLogVO getPrtMenuCate(tbl_menuLogVO searchVO) {
		return daoMbts.getPrtMenuCate(searchVO);
	}
	


	
}
