package com.adms.common.menu.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_menu_subVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("MenuAuthDao")
public class MenuAuthDao_back extends EgovComAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<tbl_menu_manageVO> getMainList(tbl_menu_manageVO searchVO) {
		return (List<tbl_menu_manageVO>)list("MenuAuthDao.getMainList",searchVO);
	}

	public void createMenu(tbl_menu_manageVO searchVO) {
		insert("MenuAuthDao.createMenu",searchVO);
	}

	public void updateMenu(tbl_menu_manageVO searchVO) {
		update("MenuAuthDao.updateMenu",searchVO);
	}

	public int getIdxByUniqKeys(tbl_menu_manageVO searchVO) {
		return (int)select("MenuAuthDao.getIdxByUniqKeys",searchVO);
	}

	public int isChildByMainCode(tbl_menu_manageVO searchVO) {
		return (int)select("MenuAuthDao.isChildByMainCode",searchVO);
	}

	public void deleteNodeByIdx(tbl_menu_manageVO searchVO) {
		delete("MenuAuthDao.deleteNodeByIdx",searchVO);
	}

	@SuppressWarnings("unchecked")
	public List<tbl_menu_subVO> getRightList(tbl_menu_subVO searchVO) {
		return (List<tbl_menu_subVO>) list("MenuAuthDao.getRightList",searchVO);
	}

	public int createRight(tbl_menu_subVO v) {
		return (int)insert("MenuAuthDao.createRight",v);
	}

	public void deleteRight(Map<String, Object> map) {
		delete("MenuAuthDao.deleteRight",map);
	}

	public tbl_menu_subVO getAuthDetailData(LoginVO loginVO) {
		return (tbl_menu_subVO)select("MenuAuthDao.getAuthDetailData",loginVO);
	}

	public tbl_menu_subVO getRightDetail(LoginVO loginVO) {
		return (tbl_menu_subVO)select("MenuAuthDao.getRightDetail",loginVO);
	}

	

	
	
}
