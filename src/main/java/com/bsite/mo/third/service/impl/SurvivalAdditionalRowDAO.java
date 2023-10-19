package com.bsite.mo.third.service.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import com.bsite.vo.survival.SurvivalAdditionalRow;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("SurvivalAdditionalRowDAO")
public class SurvivalAdditionalRowDAO extends CHibernateDaoSupport {

	public DetachedCriteria setSearchCriteria(DetachedCriteria query, SurvivalAdditionalRow searchVO) {
		return query;
	}

	public void save(SurvivalAdditionalRow vo) {
		getHibernateTemplate().save(vo);
	}

	public List<SurvivalAdditionalRow> selectByType(String listType) {

		DetachedCriteria query = DetachedCriteria.forClass(SurvivalAdditionalRow.class, "vo");
		// query = setSearchCriteria(query, searchVO);

		query.add(Restrictions.eq("listType", listType));

		@SuppressWarnings("unchecked")
		List<SurvivalAdditionalRow> list = (List<SurvivalAdditionalRow>) getHibernateTemplate().findByCriteria(query);

		return list;
	}
	
	public void delete(String listType) {
		Session session = getSessionFactory().getCurrentSession();

	    Query query = session.createQuery("DELETE FROM SurvivalAdditionalRow where listType = :listType ");
	    query.setParameter("listType", listType);
		
	    query.executeUpdate();
	}
}
