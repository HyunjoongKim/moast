package com.bsite.mo.clinic.service.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_clinic_groupVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("ClinicGrpDao")
public class ClinicGrpDao extends CHibernateDaoSupport {
	
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, mo_clinic_groupVO searchVO) {

		// if(StringUtils.isNotEmpty(searchVO.getSearchMeId()))
		// query.add(Restrictions.like("me_id", "%"+searchVO.getSearchMeId()+"%"));

		return query;
	}

	public List<mo_clinic_groupVO> selectClinicGrpList(mo_clinic_groupVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_clinic_groupVO.class, "vo")//.add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));

		query = setSearchCriteria(query, searchVO);

		@SuppressWarnings("unchecked")
		List<mo_clinic_groupVO> list = (List<mo_clinic_groupVO>) getHibernateTemplate().findByCriteria(query/*, searchVO.getFirstIndex(), searchVO.getRecordCountPerPage()*/);
		return list;
	}
	
	public int selectClinicGrpCount(mo_clinic_groupVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_clinic_groupVO.class, "vo")//.add(Restrictions.eq("site_code", searchVO.getSite_code()))
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
	
	public mo_clinic_groupVO selectClinicGrpById(mo_clinic_groupVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_clinic_groupVO.class, "vo")//.add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("cg_idx", searchVO.getCg_idx()));

		List<mo_clinic_groupVO> list = (List<mo_clinic_groupVO>) getHibernateTemplate().findByCriteria(query);
		mo_clinic_groupVO vo = new mo_clinic_groupVO();
		if (list.size() > 0)
			vo = list.get(0);
		return vo;
	}
	
	public void createClinicGrp(mo_clinic_groupVO searchVO) {
		getHibernateTemplate().save(searchVO);
		getHibernateTemplate().flush();
	}

	public void updateClinicGrp(mo_clinic_groupVO searchVO) {
		mo_clinic_groupVO vo = selectClinicGrpById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		// if(StringUtils.isNotEmpty(searchVO.getUrl())) vo.setUrl(searchVO.getUrl());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public void deleteClinicGrp(mo_clinic_groupVO searchVO) {
		mo_clinic_groupVO vo = selectClinicGrpById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		vo.setDel_yn("Y"); // 삭제 상태값

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}
	
	

}
