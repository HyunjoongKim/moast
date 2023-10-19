package com.adms.crc.clinic2.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.type.StringType;
import org.springframework.stereotype.Repository;

import com.bsite.vo.clinical_dataVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("Clinic2Dao")
public class Clinic2Dao extends CHibernateDaoSupport {

	public DetachedCriteria setSearchCriteria(DetachedCriteria query, clinical_dataVO searchVO) {

		// if(StringUtils.isNotEmpty(searchVO.getSearchMeId()))
		// query.add(Restrictions.like("me_id", "%"+searchVO.getSearchMeId()+"%"));

		return query;
	}

	public List<clinical_dataVO> getClinicList(clinical_dataVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(clinical_dataVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));

		query = setSearchCriteria(query, searchVO);

		@SuppressWarnings("unchecked")
		List<clinical_dataVO> list = (List<clinical_dataVO>) getHibernateTemplate().findByCriteria(query, searchVO.getFirstIndex(), searchVO.getRecordCountPerPage());
		return list;
	}

	public int getClinicListCnt(clinical_dataVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(clinical_dataVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
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

	public void createClinic(clinical_dataVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}

	public void updateClinic(clinical_dataVO searchVO) {
		clinical_dataVO vo = getClinicById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		// if(StringUtils.isNotEmpty(searchVO.getUrl())) vo.setUrl(searchVO.getUrl());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public clinical_dataVO getClinicById(clinical_dataVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(clinical_dataVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("id", searchVO.getCl2_id()));

		List<clinical_dataVO> list = (List<clinical_dataVO>) getHibernateTemplate().findByCriteria(query);
		clinical_dataVO vo = new clinical_dataVO();
		if (list.size() > 0)
			vo = list.get(0);
		return vo;
	}

	public void deleteClinic(clinical_dataVO searchVO) {
		clinical_dataVO vo = getClinicById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		vo.setDel_yn("Y"); // 삭제 상태값

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

}
