package com.adms.mo.visual.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.type.StringType;
import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_workspaceVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("WorkspaceDao")
public class WorkspaceDao extends CHibernateDaoSupport {

	public DetachedCriteria setSearchCriteria(DetachedCriteria query, mo_workspaceVO searchVO) {

		// if(StringUtils.isNotEmpty(searchVO.getSearchMeId()))
		// query.add(Restrictions.like("me_id", "%"+searchVO.getSearchMeId()+"%"));

		return query;
	}
	
	public List<mo_workspaceVO> selectWorkspaceList(mo_workspaceVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_workspaceVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));

		query = setSearchCriteria(query, searchVO);

		@SuppressWarnings("unchecked")
		List<mo_workspaceVO> list = (List<mo_workspaceVO>) getHibernateTemplate().findByCriteria(query, searchVO.getFirstIndex(), searchVO.getRecordCountPerPage());
		return list;
	}
	
	public int selectWorkspaceListCnt(mo_workspaceVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_workspaceVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
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
	
	public void createWorkspace(mo_workspaceVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}

	public void updateWorkspace(mo_workspaceVO searchVO) {
		mo_workspaceVO vo = getWorkspaceById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		// if(StringUtils.isNotEmpty(searchVO.getUrl())) vo.setUrl(searchVO.getUrl());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public mo_workspaceVO getWorkspaceById(mo_workspaceVO searchVO) {
		DetachedCriteria query = DetachedCriteria.forClass(mo_workspaceVO.class, "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()))
				.add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("id", searchVO.getWs_idx()));

		List<mo_workspaceVO> list = (List<mo_workspaceVO>) getHibernateTemplate().findByCriteria(query);
		mo_workspaceVO vo = new mo_workspaceVO();
		if (list.size() > 0)
			vo = list.get(0);
		return vo;
	}

	public void deleteWorkspace(mo_workspaceVO searchVO) {
		mo_workspaceVO vo = getWorkspaceById(searchVO);
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		vo.setDel_yn("Y"); // 삭제 상태값

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

}
