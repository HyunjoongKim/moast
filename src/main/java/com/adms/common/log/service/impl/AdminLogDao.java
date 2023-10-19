package com.adms.common.log.service.impl;

import java.util.ArrayList;
import java.util.List;


import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.tbl_adminLogVO;


import egovframework.com.cmm.service.impl.CHibernateDaoSupport;


@Repository("AdminLogDao")
public class AdminLogDao extends CHibernateDaoSupport{

	//검색 where
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, tbl_adminLogVO searchVO) {
		if(StringUtils.isNotEmpty(searchVO.getSearchId())) query.add(Restrictions.like("cret_id", "%"+searchVO.getSearchId()+"%"));
		if(StringUtils.isNotEmpty(searchVO.getSearchIp())) query.add(Restrictions.like("cret_ip", "%"+searchVO.getSearchIp()+"%"));
		if(StringUtils.isNotEmpty(searchVO.getSearchInfor())) query.add(Restrictions.like("infor", "%"+searchVO.getSearchInfor()+"%"));		
		if(StringUtils.isNotEmpty(searchVO.getSearchMenuCode())) query.add(Restrictions.eq("menu_code", searchVO.getSearchMenuCode()));
		if(StringUtils.isNotEmpty(searchVO.getSearchGubun())) query.add(Restrictions.eq("gubun", searchVO.getSearchGubun()));
		if(StringUtils.isNotEmpty(searchVO.getSearchSdate()))  query.add(Restrictions.sqlRestriction("cret_date  >= '"+searchVO.getSearchSdate()+"'"));				
		if(StringUtils.isNotEmpty(searchVO.getSearchEdate())) query.add(Restrictions.sqlRestriction("cret_date  <= '"+searchVO.getSearchEdate()+"' + INTERVAL 1 DAY"));				
		
		
		return query;
	}
	
	
	@SuppressWarnings("unchecked")
	public List<tbl_adminLogVO> getAdminLogList(tbl_adminLogVO searchVO)  {
	
		
		List<tbl_adminLogVO> list = new ArrayList<tbl_adminLogVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_adminLogVO.class , "vo");
		query = setSearchCriteria(query, searchVO);
		query.addOrder(Order.desc("idx"));  //sort

		list = (List<tbl_adminLogVO>) getHibernateTemplate().findByCriteria(query,searchVO.getFirstIndex(),searchVO.getRecordCountPerPage()); 

		return list;
		
	}

	@SuppressWarnings("unchecked")
	public List<tbl_adminLogVO> getAdminLogIpList()  {
		Session session = getSessionFactory().getCurrentSession();		
		Query query = session.createSQLQuery("select A.cret_ip from tbl_admin_log A GROUP BY A.cret_ip");						
		List<tbl_adminLogVO> list = query.list();
		return list;
		
	}
	
	@SuppressWarnings("unchecked")
	public List<tbl_adminLogVO>	getAdminLogExcelList(tbl_adminLogVO searchVO) {
		List<tbl_adminLogVO> list = new ArrayList<tbl_adminLogVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_adminLogVO.class , "vo");	
		query = setSearchCriteria(query, searchVO);
		query.addOrder(Order.desc("idx"));
		list = (List<tbl_adminLogVO>) getHibernateTemplate().findByCriteria(query);		
		return list;
	}
		
	
	public Integer getAdminLogCnt(tbl_adminLogVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_adminLogVO.class , "vo");
		query = setSearchCriteria(query, searchVO);
		query.setProjection(Projections.rowCount());
		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}
	
	

	public void insertAdminLog(tbl_adminLogVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}

	
}
