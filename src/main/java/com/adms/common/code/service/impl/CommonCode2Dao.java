package com.adms.common.code.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.tbl_pdsVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;
/**
 *
 * MYBATIS
 *
 */
@Repository("CommonCode2Dao")
public class CommonCode2Dao extends CHibernateDaoSupport{

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getMainList(CommonCodeVO searchVO) {
		List<CommonCodeVO> list = new ArrayList<CommonCodeVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.or(Restrictions.eq("code_cate",searchVO.getCode_cate()), Restrictions.eq("code_cate", "root")));

		query.addOrder(Order.asc("code_depth"));
		query.addOrder(Order.asc("code_order"));

		list = (List<CommonCodeVO>) getHibernateTemplate().findByCriteria(query);

		return list;
	}

	public int create(CommonCodeVO searchVO) {
		return (int) getHibernateTemplate().save(searchVO);
	}

	public int getIdxByUniqKeys(CommonCodeVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("code_cate", searchVO.getCode_cate()));
		query.add(Restrictions.eq("main_code", searchVO.getMain_code()));
		query.add(Restrictions.eq("ptrn_code", searchVO.getPtrn_code()));

		query.setProjection(Projections.rowCount());

		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}

	@SuppressWarnings("unchecked")
	public CommonCodeVO getCodeVO(CommonCodeVO searchVO) {
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("code_idx", searchVO.getCode_idx()));


		List<CommonCodeVO> list = (List<CommonCodeVO>) getHibernateTemplate().findByCriteria(query);
		CommonCodeVO vo = list.get(0);

		return vo;
	}
	
	@SuppressWarnings("unchecked")
	public CommonCodeVO getCodeVOByIdx(int code_idx) {
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo")
				.add(Restrictions.eq("code_idx", code_idx))
				.add(Restrictions.eq("del_yn", "N"));

		List<CommonCodeVO> list = (List<CommonCodeVO>) getHibernateTemplate().findByCriteria(query);
		CommonCodeVO vo = new CommonCodeVO();
		if (list != null && list.size() > 0) vo = list.get(0);

		return vo;
	}

	public void update(CommonCodeVO searchVO) {
		CommonCodeVO vo = getCodeVO(searchVO);
		vo.setCode_cate(searchVO.getCode_cate());
		vo.setCode_name(searchVO.getCode_name());
		vo.setPtrn_code(searchVO.getPtrn_code());
		vo.setGran_code(searchVO.getGran_code());
		vo.setCode_depth(searchVO.getCode_depth());
		vo.setCode_order(searchVO.getCode_order());
		vo.setCode_use(searchVO.getCode_use());
		vo.setCode_etc(searchVO.getCode_etc());

		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public void deleteNode(CommonCodeVO searchVO) {
		getHibernateTemplate().delete(searchVO);
	}

	public String getSlideCode(int depth, String code_cate) {
		String result="";
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo");
		query.add(Restrictions.eq("code_cate", code_cate));
		query.add(Restrictions.eq("code_depth", depth));
		query.addOrder(Order.asc("code_order"));

		ProjectionList projectionList = Projections.projectionList();
	    //projectionList.add(Projections.property("ptrn_code"));
		
	    projectionList.add(Projections.groupProperty("ptrn_code"));

	    query.setProjection(projectionList);



		List<?> list = getHibernateTemplate().findByCriteria(query);
		if(list.size() >0) result = String.valueOf(list.get(0));

		return result;
	}

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getComboList(CommonCodeVO searchVO) {
		List<CommonCodeVO> list = new ArrayList<CommonCodeVO>();
		DetachedCriteria query  = DetachedCriteria.forClass(CommonCodeVO.class , "vo").add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("code_cate",searchVO.getCode_cate()));
		query.add(Restrictions.eq("code_depth",searchVO.getCode_depth()));
		
		query.addOrder(Order.asc("code_order"));
		list = (List<CommonCodeVO>) getHibernateTemplate().findByCriteria(query);
		return list;
	}

	public void updateOrderAction(CommonCodeVO v) {
		
			Session session = getSessionFactory().getCurrentSession();

		    Query query = session.createQuery("update CommonCodeVO set "
		    		+ "  code_order =:code_order "
		    		+ ", modi_date = sysdate()"
		    		+ ", modi_ip = :modi_ip"
		    		+ ", modi_id = :modi_id"
		    		+ " where code_idx = :code_idx"
		    		);
		    
		    query.setInteger("code_order", v.getCode_order());
		    query.setParameter("modi_ip", v.getModi_ip());
		    query.setParameter("modi_id", v.getModi_id());
		    query.setInteger("code_idx", v.getCode_idx());
			query.executeUpdate();
	}




}
