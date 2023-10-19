package com.adms.member.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.AuthVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("AuthManage2DAO")
public class AuthManage2DAO extends CHibernateDaoSupport{

	@SuppressWarnings("unchecked")
	public List<AuthVO> getAuthList(AuthVO searchVO) {
		List<AuthVO> list = new ArrayList<AuthVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(AuthVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));

		query.addOrder(Order.asc("auth_order"));  //sort

		list = (List<AuthVO>) getHibernateTemplate().findByCriteria(query,searchVO.getFirstIndex(),searchVO.getRecordCountPerPage());  //3번부터 3row

		return list;
	}

	public int getAuthListCnt(AuthVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(AuthVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.setProjection(Projections.rowCount());


		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}

	public void insertAuthManage(AuthVO searchVO) {
		getHibernateTemplate().save(searchVO);
	}

	public int getAuthCodeCnt(AuthVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(AuthVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code()));
		query.add(Restrictions.eq("auth_code", searchVO.getAuth_code()));
		query.setProjection(Projections.rowCount());


		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}


	@SuppressWarnings("unchecked")
	public AuthVO getAuthVO(AuthVO searchVO) {

		DetachedCriteria query  = DetachedCriteria.forClass(AuthVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("auth_idx", searchVO.getAuth_idx()));


		List<AuthVO> list = (List<AuthVO>) getHibernateTemplate().findByCriteria(query);
		AuthVO vo = list.get(0);

		return vo;

	}

	public void updateAuthManage(AuthVO searchVO) {

		AuthVO vo = getAuthVO(searchVO);
		vo.setAuth_title(searchVO.getAuth_title());
		vo.setAuth_order(searchVO.getAuth_order());
		vo.setAuth_group(searchVO.getAuth_group());
		vo.setAuth_etc(searchVO.getAuth_etc());
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public void deleteAuthManage(AuthVO searchVO) {
		AuthVO vo = getAuthVO(searchVO);
		vo.setDel_yn("Y");
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	@SuppressWarnings("unchecked")
	public List<AuthVO> getAuthListAll(Map<String, Object> searchMap) {
		System.out.println("searchVO.getSite_code() " +searchMap.get("site_code"));
		DetachedCriteria query  = DetachedCriteria.forClass(AuthVO.class , "vo").add(Restrictions.eq("site_code", searchMap.get("site_code"))).add(Restrictions.eq("del_yn", "N"));
		query.addOrder(Order.desc("auth_order"));


		List<AuthVO> list = (List<AuthVO>) getHibernateTemplate().findByCriteria(query);
		for(AuthVO v: list ){
			System.out.println("v :" +v.getSite_code());
		}
		return list;
	}



}
