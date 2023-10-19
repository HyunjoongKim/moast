package com.adms.common.log.service.impl;


import java.util.List;
import java.util.Map;

import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.hibernate.type.LongType;
import org.hibernate.type.StringType;
import org.hibernate.type.DateType;
import org.hibernate.type.IntegerType;

import org.springframework.stereotype.Repository;

import com.bsite.vo.tbl_siteLogVO;


import egovframework.com.cmm.service.impl.CHibernateDaoSupport;


@Repository("SiteLogDao")
public class SiteLogDao extends CHibernateDaoSupport{

	@SuppressWarnings("unchecked")
	public List<tbl_siteLogVO> getSiteLogList(Map<String, Object> searchMap)  {
			
		StringBuffer qe = new StringBuffer();
		
		qe.append(" SELECT (SELECT ts_title FROM tbl_site WHERE site_code=A.site_code ) AS site_name, cret_date as cdate, COUNT(*) AS total  FROM ( ");
		qe.append(" SELECT SUBSTR(cret_date, 1, :size ) AS cret_date, site_code FROM tbl_site_log ");
		qe.append(" ) A WHERE  A.cret_date LIKE :cdate AND A.site_code = :site_code ");
		qe.append(" GROUP BY A.cret_date ORDER BY A.cret_date DESC ");
		Session session = getSessionFactory().getCurrentSession();		
		SQLQuery query = session.createSQLQuery(qe.toString());
		query.addScalar("site_name", new StringType());		
		query.addScalar("cdate", new StringType());		
		query.addScalar("total", new IntegerType());
		query.setParameter("size", searchMap.get("size"));
		query.setParameter("cdate", searchMap.get("cret_date")+"%");
		query.setParameter("site_code", searchMap.get("site_code"));
		query.setResultTransformer(Transformers.aliasToBean(tbl_siteLogVO.class));
		List<tbl_siteLogVO> list = query.list();	
		
		return list;
			
	}
	
	
	
	public void getInsertSiteLog(tbl_siteLogVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}
	
}
