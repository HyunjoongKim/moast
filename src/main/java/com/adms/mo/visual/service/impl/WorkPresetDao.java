package com.adms.mo.visual.service.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_work_presetVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("WorkPresetDao")
public class WorkPresetDao extends CHibernateDaoSupport {

	public DetachedCriteria setSearchCriteria(DetachedCriteria query, mo_work_presetVO searchVO) {

		// if(StringUtils.isNotEmpty(searchVO.getSearchMeId()))
		// query.add(Restrictions.like("me_id", "%"+searchVO.getSearchMeId()+"%"));

		return query;
	}
	
	public List<mo_work_presetVO> selectWorkPresetList(mo_work_presetVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_work_presetVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));

		query = setSearchCriteria(query, searchVO);

		@SuppressWarnings("unchecked")
		List<mo_work_presetVO> list = (List<mo_work_presetVO>) getHibernateTemplate().findByCriteria(query, searchVO.getFirstIndex(), searchVO.getRecordCountPerPage());
		return list;
	}
	
	public mo_work_presetVO selectWorkPresetById(int wp_idx) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_work_presetVO.class, "vo")//.add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N")).add(Restrictions.eq("wp_idx", wp_idx));

		@SuppressWarnings("unchecked")
		List<mo_work_presetVO> list = (List<mo_work_presetVO>) getHibernateTemplate().findByCriteria(query);
		mo_work_presetVO vo = new mo_work_presetVO();
		if (list != null && list.size() > 0) vo = list.get(0);

		return vo;
	}
	
	public int selectWorkPresetListCnt(mo_work_presetVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_work_presetVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
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
	
	public void createWorkPreset(mo_work_presetVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}

	public void updateWorkPreset(mo_work_presetVO searchVO) {
		mo_work_presetVO vo = getWorkPresetById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());
		
		vo.setWp_idx(searchVO.getWp_idx());
		vo.setWs_idx(searchVO.getWs_idx());
		vo.setUd_idx(searchVO.getUd_idx());
		vo.setMe_idx(searchVO.getMe_idx());
		
		vo.setGroup1(searchVO.getGroup1());
		vo.setGroup2(searchVO.getGroup2());
		vo.setDegType(searchVO.getDegType());
		vo.setDegLogFC(searchVO.getDegLogFC());
		vo.setDegPValueType(searchVO.getDegPValueType());
		vo.setDegPValue(searchVO.getDegPValue());
		vo.setDegAdjPValue(searchVO.getDegAdjPValue());

		vo.setDmpType(searchVO.getDmpType());
		vo.setDmpLogFC(searchVO.getDmpLogFC());
		vo.setDmpPValueType(searchVO.getDmpPValueType());
		vo.setDmpPValue(searchVO.getDmpPValue());
		vo.setDmpAdjPValue(searchVO.getDmpAdjPValue());
		

		// if(StringUtils.isNotEmpty(searchVO.getUrl())) vo.setUrl(searchVO.getUrl());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public mo_work_presetVO getWorkPresetById(mo_work_presetVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_work_presetVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("id", searchVO.getWs_idx()));

		List<mo_work_presetVO> list = (List<mo_work_presetVO>) getHibernateTemplate().findByCriteria(query);
		mo_work_presetVO vo = new mo_work_presetVO();
		if (list.size() > 0)
			vo = list.get(0);
		return vo;
	}

	public void deleteWorkPreset(mo_work_presetVO searchVO) {
		mo_work_presetVO vo = getWorkPresetById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		vo.setDel_yn("Y"); // 삭제 상태값

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

}
