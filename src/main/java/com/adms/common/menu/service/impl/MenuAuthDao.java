package com.adms.common.menu.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_menu_subVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("MenuAuthDao")
public class MenuAuthDao extends EgovAbstractMapper{


	public List<tbl_menu_manageVO> getMainList(tbl_menu_manageVO searchVO) {
		return selectList("MenuAuthDaogetMainList",searchVO);
	}

	public void createMenu(tbl_menu_manageVO searchVO) {
		insert("MenuAuthDaocreateMenu",searchVO);
	}

	public void updateMenu(tbl_menu_manageVO searchVO) {
		update("MenuAuthDaoupdateMenu",searchVO);
	}

	public int getIdxByUniqKeys(tbl_menu_manageVO searchVO) {
		return selectOne("MenuAuthDaogetIdxByUniqKeys",searchVO);
	}

	public int isChildByMainCode(tbl_menu_manageVO searchVO) {
		return selectOne("MenuAuthDaoisChildByMainCode",searchVO);
	}

	public void deleteNodeByIdx(tbl_menu_manageVO searchVO) {
		delete("MenuAuthDaodeleteNodeByIdx",searchVO);
	}

	public List<tbl_menu_subVO> getRightList(tbl_menu_subVO searchVO) {
		return selectList("MenuAuthDaogetRightList",searchVO);
	}

	public int createRight(tbl_menu_subVO v) {
		return insert("MenuAuthDaocreateRight",v);
	}

	public void deleteRight(Map<String, Object> map) {
		delete("MenuAuthDaodeleteRight",map);
	}

	public tbl_menu_subVO getAuthDetailData(LoginVO loginVO) {
		return selectOne("MenuAuthDaogetAuthDetailData",loginVO);
	}

	public tbl_menu_subVO getRightDetail(LoginVO loginVO) {
		return selectOne("MenuAuthDaogetRightDetail",loginVO);
	}

}
