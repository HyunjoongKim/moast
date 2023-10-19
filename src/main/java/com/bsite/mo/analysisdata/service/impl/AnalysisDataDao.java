package com.bsite.mo.analysisdata.service.impl;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_analysisDataVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("AnalysisDataDao")
public class AnalysisDataDao extends CHibernateDaoSupport {
	
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, mo_analysisDataVO searchVO) {

		if(StringUtils.isNotEmpty(searchVO.getSearchUdTitle()))
			query.add(Restrictions.like("ud_title", "%" + searchVO.getSearchUdTitle() + "%"));
		
		if(StringUtils.isNotEmpty(searchVO.getSearchUdStatus()))
			query.add(Restrictions.eq("ud_status", searchVO.getSearchUdStatus()));

		return query;
	}

	public List<mo_analysisDataVO> selectAnalysisDataList(mo_analysisDataVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_analysisDataVO.class, "vo")//.add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));

		query = setSearchCriteria(query, searchVO);

		@SuppressWarnings("unchecked")
		List<mo_analysisDataVO> list = (List<mo_analysisDataVO>) getHibernateTemplate().findByCriteria(query/*, searchVO.getFirstIndex(), searchVO.getRecordCountPerPage()*/);
		return list;
	}
	
	public int selectAnalysisDataCount(mo_analysisDataVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_analysisDataVO.class, "vo")//.add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));

		query = setSearchCriteria(query, searchVO);
		query.setProjection(Projections.rowCount());

		List<?> list = getHibernateTemplate().findByCriteria(query);

		if (list != null && list.size() > 0) {
			return Integer.parseInt(String.valueOf(list.get(0)));
		} else {
			return 0;
		}
	}
	
	public mo_analysisDataVO selectAnalysisDataById(mo_analysisDataVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_analysisDataVO.class, "vo")//.add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("ud_idx", searchVO.getUd_idx()));

		List<mo_analysisDataVO> list = (List<mo_analysisDataVO>) getHibernateTemplate().findByCriteria(query);
		mo_analysisDataVO vo = new mo_analysisDataVO();
		if (list.size() > 0)
			vo = list.get(0);
		return vo;
	}
	
	public void createAnalysisData(mo_analysisDataVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}

	public void updateAnalysisData(mo_analysisDataVO searchVO) {
		mo_analysisDataVO vo = selectAnalysisDataById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		// if(StringUtils.isNotEmpty(searchVO.getUrl())) vo.setUrl(searchVO.getUrl());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public void deleteAnalysisData(mo_analysisDataVO searchVO) {
		mo_analysisDataVO vo = selectAnalysisDataById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		vo.setDel_yn("Y"); // 삭제 상태값

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public void updateAnalysisDataStatus(mo_analysisDataVO searchVO) {
		mo_analysisDataVO vo = selectAnalysisDataById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		vo.setUd_status(searchVO.getUd_status());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
		
	}
	
	

}
