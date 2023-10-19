package com.adms.common.menu.service.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_menu_subVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("MenuAuth2Dao")
public class MenuAuth2Dao extends CHibernateDaoSupport{

	@SuppressWarnings("unchecked")
	public List<tbl_menu_manageVO> getMainList(tbl_menu_manageVO searchVO) {
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_manageVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));

		ProjectionList projectionList = Projections.projectionList();
		/*projectionList.add(Projections.property("menu_idx").as("id"));
		projectionList.add(Projections.property("menu_name").as("name"));
		projectionList.add(Projections.property("ptrn_code").as("_parentId"));

		projectionList.add(Projections.property("menu_idx").as("menu_idx"));

		ClassMetadata metadata = getSessionFactory().getClassMetadata(tbl_menu_manageVO.class);
		for (String prop : metadata.getPropertyNames()) {
            	projectionList.add(Property.forName(prop).as(prop));
        }
		 */

		//query.setProjection(projectionList);

		query.addOrder(Order.asc("vo.menu_ordr"));

		//List<tbl_menu_manageVO> list = query.getExecutableCriteria(getSessionFactory().getCurrentSession()).list();
		List<tbl_menu_manageVO> list = (List<tbl_menu_manageVO>) getHibernateTemplate().findByCriteria(query);

		for(tbl_menu_manageVO vo : list){
			vo.setId(String.valueOf(vo.getMenu_idx()));
			vo.setName(vo.getMenu_name());
			vo.set_parentId(vo.getPtrn_code());
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public tbl_menu_manageVO getMenuManageVO(tbl_menu_manageVO searchVO) {

		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_manageVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("menu_idx", searchVO.getMenu_idx()));


		List<tbl_menu_manageVO> list = (List<tbl_menu_manageVO>) getHibernateTemplate().findByCriteria(query);
		tbl_menu_manageVO vo = list.get(0);

		return vo;

	}

	public void updateMenu(tbl_menu_manageVO searchVO) {
		tbl_menu_manageVO vo = getMenuManageVO(searchVO);


		vo.setMenu_head(searchVO.getMenu_head());
		vo.setMenu_code(searchVO.getMenu_code());
		vo.setMenu_name(searchVO.getMenu_name());
		vo.setMenu_url(searchVO.getMenu_url());
		vo.setMenu_url_patn(searchVO.getMenu_url_patn());
		vo.setMenu_depth(searchVO.getMenu_depth());
		vo.setMenu_ordr(searchVO.getMenu_ordr());
		vo.setMenu_view(searchVO.getMenu_view());
		vo.setMenu_target(searchVO.getMenu_target());
		vo.setIs_board(searchVO.getIs_board());

		vo.setModi_id(searchVO.getModi_id());
		vo.setModi_ip(searchVO.getModi_ip());

		getHibernateTemplate().clear();
		getHibernateTemplate().update(vo);
	}

	public int createMenu(tbl_menu_manageVO searchVO) {
		return (int) getHibernateTemplate().save(searchVO);
	}

	public int getIdxByUniqKeys(tbl_menu_manageVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_manageVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("menu_code", searchVO.getMenu_code()));
		query.setProjection(Projections.rowCount());


		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}

	public void deleteNodeByIdx(tbl_menu_manageVO searchVO) {
		getHibernateTemplate().delete(searchVO);
	}

	public int isChildByMainCode(tbl_menu_manageVO searchVO) {
		int cnt=0;
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_manageVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("ptrn_code", String.valueOf(searchVO.getMenu_idx())));
		query.setProjection(Projections.rowCount());


		List<?> list = getHibernateTemplate().findByCriteria(query);
		cnt = Integer.parseInt(String.valueOf(list.get(0)));

		return cnt;
	}

	@SuppressWarnings("unchecked")
	public List<tbl_menu_subVO> getRightList(tbl_menu_subVO searchVO) {
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_subVO.class , "vo").add(Restrictions.eq("site_code", searchVO.getSite_code())).add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("menu_idx", searchVO.getMenu_idx()));

		List<tbl_menu_subVO> list = (List<tbl_menu_subVO>) getHibernateTemplate().findByCriteria(query);

		return list;
	}

	public void deleteRight(Map<String, Object> map) {
		tbl_menu_subVO searchVO = new tbl_menu_subVO();
		searchVO.setSite_code(String.valueOf(map.get("site_code")));
		searchVO.setMenu_idx(Integer.parseInt((String) map.get("menu_idx")));

		//getHibernateTemplate().delete(searchVO);

		try{
			Session session = getSessionFactory().getCurrentSession();

		    Query query = session.createQuery("delete from tbl_menu_subVO where menu_idx = :menu_idx");
			query.setParameter("menu_idx", Integer.parseInt((String) map.get("menu_idx")));
			query.executeUpdate();



		}catch(Exception e){
			System.out.println(e);
		}




	}

	public int createRight(tbl_menu_subVO v) {
		int result = (Integer) getHibernateTemplate().save(v);


		/*Session session = getSessionFactory().openSession();
	    Transaction txn = session.beginTransaction();

	    int result =  (int) session.createSQLQuery("SELECT LAST_INSERT_ID()").uniqueResult();

	    txn.commit();
	    session.close();*/

	    return result;

	}

	@SuppressWarnings("unchecked")
	public tbl_menu_manageVO getAuthDetailData(LoginVO loginVO) {
		// select * from tbl_menu_manage <include refid="BaseWhere"/> and menu_code=#{mkUrl} and ( menu_depth=4 or menu_depth=5 )
		
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_manageVO.class , "vo");
		query.add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("site_code", loginVO.getSite_code()));
		query.add(Restrictions.eq("menu_code", loginVO.getMkUrl()));
		query.add(Restrictions.or(Restrictions.eq("menu_depth","4") ,Restrictions.eq("menu_depth","5")));
		
		List<tbl_menu_manageVO> list = (List<tbl_menu_manageVO>) getHibernateTemplate().findByCriteria(query);
		tbl_menu_manageVO vo = null;
		if(list.size()>0){
			vo = new tbl_menu_manageVO();
			vo = list.get(0);
		}

		return vo;
	}

	@SuppressWarnings("unchecked")
	public tbl_menu_subVO getRightDetail(LoginVO loginVO) {
		// select * from tbl_menu_sub <include refid="BaseWhere"/> and menu_idx=#{menu_idx} and auth_code=#{authCode} 
		DetachedCriteria query  = DetachedCriteria.forClass(tbl_menu_subVO.class , "vo");
		query.add(Restrictions.eq("del_yn", "N"));
		query.add(Restrictions.eq("site_code", loginVO.getSite_code()));
		query.add(Restrictions.eq("menu_idx", loginVO.getMenu_idx()));
		query.add(Restrictions.eq("auth_code", loginVO.getAuthCode()));
		
		List<tbl_menu_subVO> list = (List<tbl_menu_subVO>) getHibernateTemplate().findByCriteria(query);
		tbl_menu_subVO vo =null;
		if(list.size()>0){
			vo = new tbl_menu_subVO();
			vo = list.get(0);
		}
		getHibernateTemplate().clear();
		return vo;
	}

	public void updateOrderAction(tbl_menu_manageVO v) {
		Session session = getSessionFactory().getCurrentSession();

	    Query query = session.createQuery("update tbl_menu_manageVO set "
	    		+ "  menu_ordr =:menu_ordr "
	    		+ ", modi_date = sysdate()"
	    		+ ", modi_ip = :modi_ip"
	    		+ ", modi_id = :modi_id"
	    		+ " where menu_idx = :menu_idx"
	    		);
	    
	    query.setInteger("menu_ordr", v.getMenu_ordr());
	    query.setParameter("modi_ip", v.getModi_ip());
	    query.setParameter("modi_id", v.getModi_id());
	    query.setInteger("menu_idx", v.getMenu_idx());
		query.executeUpdate();
		
	}


	
}
