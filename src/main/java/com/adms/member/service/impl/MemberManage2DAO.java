package com.adms.member.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.AuthVO;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("MemberManage2DAO")
public class MemberManage2DAO  extends CHibernateDaoSupport{

	//검색 where
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, MemberVO searchVO){
		
		if(StringUtils.isNotEmpty(searchVO.getSearchMeId())) query.add(Restrictions.like("me_id", "%"+searchVO.getSearchMeId()+"%"));
		if(StringUtils.isNotEmpty(searchVO.getSearchMeName())) query.add(Restrictions.like("me_name", "%"+searchVO.getSearchMeName()+"%"));
		if(StringUtils.isNotEmpty(searchVO.getSearchAuthCode())) query.add(Restrictions.eq("auth_code", searchVO.getSearchAuthCode()));
		if(StringUtils.isNotEmpty(searchVO.getSearchMeType())) query.add(Restrictions.eq("me_type", searchVO.getSearchMeType()));
		
		return query;
	}
	
	
	
	
	@SuppressWarnings("unchecked")
	public List<AuthVO> getAuthList(Map<String, Object> searchMap) {
		List<AuthVO> list = new ArrayList<AuthVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(AuthVO.class , "vo").add(Restrictions.eq("del_yn", "N")); /*.add(Restrictions.eq("site_code", searchMap.get("site_code")))*/
		query.addOrder(Order.asc("auth_order"));  
		list = (List<AuthVO>) getHibernateTemplate().findByCriteria(query);

		return list;
	}
	
	public boolean checkSearch(MemberVO searchVO){
		boolean search = true;
		boolean pop = false;		
		if("Y".equals(searchVO.getIsPopup()) || !"Nor".equals(searchVO.getPopType())){
			pop =true;
			search =false;
		}
		if(pop){
			if("site1".equals(searchVO.getSite_code())){
				System.out.println("sitecode: "+searchVO.getSite_code());
				search = true;
			}else{
				if(StringUtils.isNotEmpty(searchVO.getSearchMeId())||StringUtils.isNotEmpty(searchVO.getSearchMeName())){
					search = true;
				}
			}
		}
		
		return search;
	}
	
	@SuppressWarnings("unchecked")
	public List<MemberVO> getMemberAllList() {
		List<MemberVO> list = new ArrayList<MemberVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N")); /*.add(Restrictions.eq("site_code", searchVO.getSite_code()))*/
		query.addOrder(Order.asc("me_name"));  

		list = (List<MemberVO>) getHibernateTemplate().findByCriteria(query); 
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<MemberVO> getMemberList(MemberVO searchVO) {
		boolean search = checkSearch(searchVO);
		
		
		List<MemberVO> list = new ArrayList<MemberVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N")); /*.add(Restrictions.eq("site_code", searchVO.getSite_code()))*/
		query = setSearchCriteria(query, searchVO);		
		query.addOrder(Order.desc("me_idx"));  

		if(search) list = (List<MemberVO>) getHibernateTemplate().findByCriteria(query,searchVO.getFirstIndex(),searchVO.getRecordCountPerPage());  //3번부터 3row
		return list;
	}

	public int getMemberListCnt(MemberVO searchVO) {
		boolean search = checkSearch(searchVO);
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N")); /*.add(Restrictions.eq("site_code", searchVO.getSite_code()))*/
		query.setProjection(Projections.rowCount());
		query = setSearchCriteria(query, searchVO);

		List<?> list = getHibernateTemplate().findByCriteria(query);
		if(search) cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}

	public int getMemberIdCnt(MemberVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N"));  /*.add(Restrictions.eq("site_code", searchVO.getSite_code()))*/
		query.add(Restrictions.eq("me_id", searchVO.getMe_id()));
		query.setProjection(Projections.rowCount());


		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}

	public void insertMemberVO(MemberVO searchVO) {	
		getHibernateTemplate().save(searchVO);
	}

	@SuppressWarnings("unchecked")
	public MemberVO getMemberVO(MemberVO searchVO) {
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N"));  /*.add(Restrictions.eq("site_code", searchVO.getSite_code()))*/
		query.add(Restrictions.eq("me_idx", searchVO.getMe_idx()));


		List<MemberVO> list = (List<MemberVO>) getHibernateTemplate().findByCriteria(query);
		MemberVO vo = list.get(0);

		return vo;
	}

	public void updateMemberVO(MemberVO searchVO) {
		MemberVO vo = getMemberVO(searchVO);
		vo.setMe_name(searchVO.getMe_name());
		vo.setMe_email(searchVO.getMe_email());
		vo.setMe_tel(searchVO.getMe_tel());
		vo.setMe_email_yn(searchVO.getMe_email_yn());
		
		vo.setMe_type(searchVO.getMe_type());
		if(StringUtils.isNotEmpty(searchVO.getMe_pwd())) vo.setMe_pwd(searchVO.getMe_pwd());
		if(StringUtils.isNotEmpty(searchVO.getAuth_code())) vo.setAuth_code(searchVO.getAuth_code());
		if(StringUtils.isNotEmpty(searchVO.getAtch_file_id())) vo.setAtch_file_id(searchVO.getAtch_file_id());
		vo.setMe_phone(searchVO.getMe_phone());
		vo.setMe_postno(searchVO.getMe_postno());
		vo.setMe_departcode(searchVO.getMe_departcode());
		vo.setMe_address1(searchVO.getMe_address1());
		vo.setMe_address2(searchVO.getMe_address2());
		vo.setMe_repo_code(searchVO.getMe_repo_code());
		vo.setMe_department(searchVO.getMe_department());
		vo.setMe_is_cert(searchVO.getMe_is_cert());
		vo.setMe_is_login(searchVO.getMe_is_login());
		vo.setMe_department(searchVO.getMe_department());
		
		vo.setTmp_me_bth(searchVO.getTmp_me_bth());
		vo.setMe_agency_type(searchVO.getMe_agency_type());
		vo.setMe_agency(searchVO.getMe_agency());
		vo.setMe_position(searchVO.getMe_position());
		
		
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());
		
		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public void updateFileMemberVO(MemberVO searchVO) {
		MemberVO vo = getMemberVO(searchVO);
		vo.setAtch_file_id(searchVO.getAtch_file_id());
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());
		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}
	
	public void deleteMemberVO(MemberVO searchVO) {
		MemberVO vo = getMemberVO(searchVO);
		vo.setDel_yn("Y");
		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}


	public int getMemberCertSerchCnt(MemberVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N"));  /*.add(Restrictions.eq("site_code", searchVO.getSite_code()))*/
		query.add(Restrictions.eq("me_cert_key", searchVO.getMe_cert_key()));
		query.setProjection(Projections.rowCount());

		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}

	
	@SuppressWarnings("unchecked")
	public MemberVO getCertSerchMember(MemberVO searchVO) {
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N"));  
		query.add(Restrictions.eq("me_cert_key", searchVO.getMe_cert_key()));

		List<MemberVO> list = (List<MemberVO>) getHibernateTemplate().findByCriteria(query);
		MemberVO vo = list.get(0);

		return vo;
	}
	

	public void getCertMemberUpdate(MemberVO searchVO) {

		MemberVO vo = getMemberVO(searchVO);
		
		vo.setMe_idx(searchVO.getMe_idx());
		vo.setMe_cert_key(searchVO.getMe_cert_key());
		vo.setMe_is_cert(searchVO.getMe_is_cert());
		vo.setMe_is_login(searchVO.getMe_is_login());		
		vo.setMe_fail_cnt(searchVO.getMe_fail_cnt());
		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	
	
	
}
