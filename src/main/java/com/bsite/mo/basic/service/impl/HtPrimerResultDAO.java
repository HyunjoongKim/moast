package com.bsite.mo.basic.service.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.HtPrimerResultVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("HtPrimerResultDAO")
public class HtPrimerResultDAO extends CHibernateDaoSupport {
	
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, HtPrimerResultVO searchVO) {

		return query;
	}
	
	public void save(HtPrimerResultVO vo) {
		getHibernateTemplate().save(vo);
	}
	
	public List<HtPrimerResultVO> selectHtPrimerResultList(HtPrimerResultVO searchVO) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(HtPrimerResultVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query = setSearchCriteria(query, searchVO);
				
		@SuppressWarnings("unchecked")
		List<HtPrimerResultVO> list = (List<HtPrimerResultVO>) getHibernateTemplate().findByCriteria(query);
		return list;
	}
	
	public HtPrimerResultVO selectHtPrimerResult(int recordIdx) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(HtPrimerResultVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		//query = setSearchCriteria(query, searchVO);
		
		query.add(Restrictions.eqOrIsNull("recordIdx", recordIdx));
				
		@SuppressWarnings("unchecked")
		List<HtPrimerResultVO> list = (List<HtPrimerResultVO>) getHibernateTemplate().findByCriteria(query);
		
		HtPrimerResultVO methelationRecord = null;
		if (list.size() > 0)
			methelationRecord = list.get(0);
		return methelationRecord;
	}
	
}
