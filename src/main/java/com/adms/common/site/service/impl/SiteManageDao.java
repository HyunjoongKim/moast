package com.adms.common.site.service.impl;

import java.util.ArrayList;
import java.util.List;


import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.AuthVO;
import com.bsite.vo.tbl_siteVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;


@Repository("SiteManageDao")
public class SiteManageDao extends CHibernateDaoSupport{

	@SuppressWarnings("unchecked")
	public List<tbl_siteVO> getList(tbl_siteVO searchVO) {
		List<tbl_siteVO> list = new ArrayList<tbl_siteVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_siteVO.class , "vo");
		query.add(Restrictions.eq("del_yn", "N"));
		query.addOrder(Order.asc("ts_order"));  //sort
		list = (List<tbl_siteVO>) getHibernateTemplate().findByCriteria(query,searchVO.getFirstIndex(),searchVO.getRecordCountPerPage());  
		return list;
	}

	public int getListCnt(tbl_siteVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_siteVO.class , "vo");
		query.add(Restrictions.eq("del_yn", "N"));
		query.setProjection(Projections.rowCount());


		List<?> list = getHibernateTemplate().findByCriteria(query);
		if(list.size() > 0 ) cnt = Integer.parseInt(String.valueOf(list.get(0)));
		

		return cnt;
	}

	public void insertDB(tbl_siteVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}

	@SuppressWarnings("unchecked")
	public tbl_siteVO getDetailVO(tbl_siteVO searchVO) {
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_siteVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("ts_pkid", searchVO.getTs_pkid()));


		List<tbl_siteVO> list = (List<tbl_siteVO>) getHibernateTemplate().findByCriteria(query);
		tbl_siteVO vo = list.get(0);

		return vo;
	}

	public void updateVO(tbl_siteVO searchVO) {
		tbl_siteVO vo = getDetailVO(searchVO);
		vo.setTs_title(searchVO.getTs_title());
		vo.setTs_order(searchVO.getTs_order());
		vo.setTs_domain(searchVO.getTs_domain());
		vo.setTs_etc(searchVO.getTs_etc());
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public void deleteVO(tbl_siteVO searchVO) {
		tbl_siteVO vo = getDetailVO(searchVO);
		vo.setDel_yn("Y");
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	@SuppressWarnings("unchecked")
	public List<tbl_siteVO> getListAll() {
		List<tbl_siteVO> list = new ArrayList<tbl_siteVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_siteVO.class , "vo");
		query.add(Restrictions.eq("del_yn", "N"));
		query.addOrder(Order.asc("ts_order"));  //sort
		list = (List<tbl_siteVO>) getHibernateTemplate().findByCriteria(query);  
		return list;
	}
	
}
