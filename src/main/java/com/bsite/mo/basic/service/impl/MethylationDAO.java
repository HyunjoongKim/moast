package com.bsite.mo.basic.service.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.MethylationRecordVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("MethylationDAO")
public class MethylationDAO extends CHibernateDaoSupport {
	
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, MethylationRecordVO searchVO) {

		if (searchVO.getStd_idx()!=null) {
			query.add(Restrictions.eq("std_idx", searchVO.getStd_idx()));
		}
		
		return query;
	}
	
	public void save(MethylationRecordVO vo) {
		getHibernateTemplate().save(vo);
	}
	
	public List<MethylationRecordVO> selectMethylationRecordList(MethylationRecordVO searchVO) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(MethylationRecordVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query = setSearchCriteria(query, searchVO);
		query.addOrder(Order.desc("cret_date"));
				
		@SuppressWarnings("unchecked")
		List<MethylationRecordVO> list = (List<MethylationRecordVO>) getHibernateTemplate().findByCriteria(query,searchVO.getFirstIndex(),searchVO.getRecordCountPerPage());
		return list;
	}
	
	public int countMethylationRecordList(MethylationRecordVO searchVO) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(MethylationRecordVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query = setSearchCriteria(query, searchVO);
				
		@SuppressWarnings("unchecked")
		List<MethylationRecordVO> list = (List<MethylationRecordVO>) getHibernateTemplate().findByCriteria(query);
		return list.size();
	}
	
	public MethylationRecordVO selectMethylationRecord(int recordIdx) {
		
		DetachedCriteria query  = DetachedCriteria.forClass(MethylationRecordVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		//query = setSearchCriteria(query, searchVO);
		
		query.add(Restrictions.eqOrIsNull("recordIdx", recordIdx));
				
		@SuppressWarnings("unchecked")
		List<MethylationRecordVO> list = (List<MethylationRecordVO>) getHibernateTemplate().findByCriteria(query);
		
		MethylationRecordVO methelationRecord = null;
		if (list.size() > 0)
			methelationRecord = list.get(0);
		return methelationRecord;
	}

}
