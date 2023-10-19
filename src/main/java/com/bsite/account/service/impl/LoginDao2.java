package com.bsite.account.service.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.MemberVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

/**
 * 
 * MYBATIS
 *
 */
@Repository("LoginDao2")
public class LoginDao2 extends CHibernateDaoSupport{

	@SuppressWarnings("unchecked")
	public LoginVO actionLogin(LoginVO searchVO) {
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("me_id", searchVO.getId()));
		query.add(Restrictions.eq("me_pwd", searchVO.getPassword()));
		query.add(Restrictions.eq("me_is_cert", "Y"));
		query.add(Restrictions.eq("me_is_login", "Y"));

		LoginVO loginVO = null;
		List<MemberVO> list = (List<MemberVO>) getHibernateTemplate().findByCriteria(query);
		
		if(list.size()>0){
			MemberVO vo = list.get(0);
			loginVO = new LoginVO();
			loginVO.setIdx(vo.getMe_idx()); 	//회원관리 고유값 확인하기 위해 idx 추가 2017.09.12[연순모]
			loginVO.setName(vo.getMe_name());
			loginVO.setId(vo.getMe_id());
			loginVO.setAuthCode(vo.getAuth_code());
			loginVO.setLatestLogin(vo.getMe_latest_login());
			loginVO.setMe_type(vo.getMe_type());
			loginVO.setRepoHasRight(vo.getMe_repo_code());
			loginVO.setMeIsCert(vo.getMe_is_cert());
			loginVO.setMeFailCnt(vo.getMe_fail_cnt());
			loginVO.setMeIsLogin(vo.getMe_is_login());
		}
		return loginVO;
	}


	@SuppressWarnings("unchecked")
	public LoginVO actionLoginById(String id) throws Exception{
		DetachedCriteria query  = DetachedCriteria.forClass(MemberVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("me_id", id));


		List<MemberVO> list = (List<MemberVO>) getHibernateTemplate().findByCriteria(query);
		LoginVO loginVO = new LoginVO();
		if(list.size() > 0) {
			MemberVO vo = list.get(0);
					
			loginVO.setIdx(vo.getMe_idx());
			loginVO.setName(vo.getMe_name());
			loginVO.setId(vo.getMe_id());
			loginVO.setAuthCode(vo.getAuth_code());
			loginVO.setLatestLogin(vo.getMe_latest_login());
			loginVO.setMe_type(vo.getMe_type());
			//로그인 실패 횟수 추가 [날짜:0171025 작업자:연순모]
			loginVO.setEmail(vo.getMe_email());
			loginVO.setMeFailCnt(vo.getMe_fail_cnt());
		}
		return loginVO;
	}
	
	@SuppressWarnings("unchecked")
	public int getCodeIdx(Map<String, Object> searchMap) {
		int codeIdx = 0;
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("code_cate", searchMap.get("code_cate")));
		query.add(Restrictions.eq("main_code", searchMap.get("main_code")));

		List<CommonCodeVO> list = (List<CommonCodeVO>) getHibernateTemplate().findByCriteria(query);
		if(list.size()>0) codeIdx = list.get(0).getCode_idx();
		return codeIdx;		
	}	
	
	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getCodeList(Map<String, Object> searchMap) {
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("code_cate", searchMap.get("code_cate")));
		query.add(Restrictions.eq("ptrn_code", searchMap.get("ptrn_code")));
		
		query.addOrder(Order.asc("code_order"));
		query.addOrder(Order.asc("cret_date"));


		List<CommonCodeVO> list = (List<CommonCodeVO>) getHibernateTemplate().findByCriteria(query);


		return list;
	}

	public void updateLastLogin(LoginVO loginVO) {
		try{
			Session session = getSessionFactory().getCurrentSession();

		    Query query = session.createQuery("UPDATE MemberVO SET me_latest_login = SYSDATE() WHERE me_id = :id");
			query.setParameter("id", loginVO.getId());
			query.executeUpdate();

		}catch(Exception e){
			System.out.println(e);
		}
	}
	
	
	//로그인 실패시 횟수 증가 추가 [날짜:0171025 작업자:연순모]
	public void updateLoginFailCnt(LoginVO loginVO) {
		try{
			Session session = getSessionFactory().getCurrentSession();

		    Query query = session.createQuery("UPDATE MemberVO SET me_fail_cnt = :failCnt WHERE me_id = :id");
			query.setParameter("id", loginVO.getId());
			query.setParameter("failCnt", loginVO.getMeFailCnt());
			query.executeUpdate();

		}catch(Exception e){
			System.out.println(e);
		}
	}






}
