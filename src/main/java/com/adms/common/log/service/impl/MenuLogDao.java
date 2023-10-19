package com.adms.common.log.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StringType;
import org.hibernate.type.IntegerType;

import org.springframework.stereotype.Repository;

import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_siteVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;


@Repository("MenuLogDao")
public class MenuLogDao extends CHibernateDaoSupport{

	@SuppressWarnings("unchecked")
	public List<tbl_menuLogVO> getMenuLogList(tbl_menuLogVO searchVO)  {
			
		StringBuffer qe = new StringBuffer();
       
		qe.append(" SELECT (SELECT ts_title FROM tbl_site WHERE site_code=B.site_code ) AS site_name, B.menu_name, B.menu_target, A.url,A.menu_idx, A.total  FROM (  ");
		qe.append(" SELECT idx, url,menu_idx, COUNT(*) AS total FROM tbl_menu_log WHERE site_code=:siteCode and menu_idx > 0 ");
		qe.append(" GROUP BY url ORDER BY total DESC ) A LEFT JOIN  tbl_menu_manage B ON A.url = B.menu_code ORDER BY total DESC ");
		Session session = getSessionFactory().getCurrentSession();		
		SQLQuery query = session.createSQLQuery(qe.toString());		
		query.addScalar("site_name", new StringType());
		query.addScalar("menu_name", new StringType());
		query.addScalar("menu_target", new StringType());
		query.addScalar("url", new StringType());
		query.addScalar("total", new IntegerType());
		query.setParameter("siteCode", searchVO.getSearch_siteCode());
		query.setResultTransformer(Transformers.aliasToBean(tbl_menuLogVO.class));
		List<tbl_menuLogVO> list = query.list();	
		
		return list;
			
	}
	
	//사이트코드 출력
	@SuppressWarnings("unchecked")
	public List<tbl_siteVO>	getSiteList() {
		List<tbl_siteVO> list = new ArrayList<tbl_siteVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_siteVO.class , "vo");
		query.add(Restrictions.eq("del_yn", "N"));		
		//query.add(Restrictions.ne("site_code", "site1"));		
		query.addOrder(Order.desc("ts_pkid"));
		list = (List<tbl_siteVO>) getHibernateTemplate().findByCriteria(query);		
		return list;
	}
	
	
	public Integer getMenuLogListCnt(tbl_menuLogVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menuLogVO.class , "vo");
		query.add(Restrictions.eq("site_code", searchVO.getSearch_siteCode()));
		query.add(Restrictions.gt("menu_idx", 0));
		query.setProjection(Projections.rowCount());
		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));
		return cnt;
	}

	//메뉴 유무 체크
	public Integer getSearchMenu(tbl_menu_manageVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_manageVO.class , "vo");
		query.add(Restrictions.eq("menu_code", searchVO.getMenu_code()));
		query.setProjection(Projections.rowCount());
		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));
		return cnt;
	}

	
	
	public void getInsertMenuLog(tbl_menuLogVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}
	
}
