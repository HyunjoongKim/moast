package com.bsite.home.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.tbl_equipVO;
import egovframework.com.cmm.service.impl.CHibernateDaoSupport;


@Repository("HomeDaoHB")
public class HomeDaoHB extends CHibernateDaoSupport{
	
	
	
	@SuppressWarnings("unchecked")
	public List<tbl_equipVO> getTeList(Map<String, Object> searchMap) {
		List<tbl_equipVO> list = new ArrayList<tbl_equipVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_equipVO.class , "vo").add(Restrictions.eq("del_yn", "N"));		
		query.add(Restrictions.or(Restrictions.like("eq_name", (String) searchMap.get("searchWord"),MatchMode.ANYWHERE), 
								  Restrictions.like("eq_name_en",(String) searchMap.get("searchWord"),MatchMode.ANYWHERE),
								  Restrictions.like("eq_maker",(String) searchMap.get("searchWord"),MatchMode.ANYWHERE),
								  Restrictions.like("eq_model",(String)  searchMap.get("searchWord"),MatchMode.ANYWHERE),
								  Restrictions.like("eq_org",(String)  searchMap.get("searchWord"),MatchMode.ANYWHERE),
								  Restrictions.like("eq_org_addr1",(String)  searchMap.get("searchWord"),MatchMode.ANYWHERE),
								  Restrictions.like("eq_org_addr2",(String)  searchMap.get("searchWord"),MatchMode.ANYWHERE),
								  Restrictions.like("eq_tel",(String)  searchMap.get("searchWord"),MatchMode.ANYWHERE),
								  Restrictions.like("eq_explan",(String)  searchMap.get("searchWord"),MatchMode.ANYWHERE)
						));		
		list = (List<tbl_equipVO>) getHibernateTemplate().findByCriteria(query,0,Integer.parseInt(searchMap.get("limitCnt").toString()));
		return list;
	}
	
}
