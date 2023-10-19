package com.bsite.mo.basic.service.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.VariantRecordVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("VariantDAO")
public class VariantDAO extends CHibernateDaoSupport {
	
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, VariantRecordVO searchVO) {

		if (searchVO.getStd_idx()!=null) {
			query.add(Restrictions.eq("std_idx", searchVO.getStd_idx()));
		}
		
		return query;
	}
	
	public void save(VariantRecordVO vo) {
		getHibernateTemplate().save(vo);
	}
	
	public List<VariantRecordVO> selectVariantRecordList(VariantRecordVO searchVO) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(VariantRecordVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query = setSearchCriteria(query, searchVO);
		query.addOrder(Order.desc("cret_date"));
				
		@SuppressWarnings("unchecked")
		List<VariantRecordVO> list = (List<VariantRecordVO>) getHibernateTemplate().findByCriteria(query,searchVO.getFirstIndex(),searchVO.getRecordCountPerPage());
		return list;
	}
	
	public int countVariantRecordList(VariantRecordVO searchVO) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(VariantRecordVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query = setSearchCriteria(query, searchVO);
				
		@SuppressWarnings("unchecked")
		List<VariantRecordVO> list = (List<VariantRecordVO>) getHibernateTemplate().findByCriteria(query);
		return list.size();
	}
	
	public VariantRecordVO selectVariantRecord(int recordIdx) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(VariantRecordVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		//query = setSearchCriteria(query, searchVO);
		
		query.add(Restrictions.eqOrIsNull("recordIdx", recordIdx));
				
		@SuppressWarnings("unchecked")
		List<VariantRecordVO> list = (List<VariantRecordVO>) getHibernateTemplate().findByCriteria(query);
		
		VariantRecordVO variantRecord = null;
		if (list.size() > 0)
			variantRecord = list.get(0);
		return variantRecord;
	}

}
