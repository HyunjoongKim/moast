package com.adms.common.menu.service;

import java.util.List;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_menu_subVO;


public interface MenuAuth2Service {

	List<tbl_menu_manageVO> getMainList(tbl_menu_manageVO searchVO) throws Exception;

	int createAndUpdate(tbl_menu_manageVO searchVO) throws Exception;

	void deleteNode(tbl_menu_manageVO searchVO) throws Exception;

	List<tbl_menu_subVO> getRightList(tbl_menu_subVO searchVO) throws Exception;

	void createRight(List<tbl_menu_subVO> rdataList, LoginVO loginVO, String menuIdx) throws Exception;

	tbl_menu_manageVO getAuthDetailData(LoginVO loginVO)  throws Exception;

	tbl_menu_subVO getRightDetail(LoginVO loginVO)  throws Exception;

	void updateOrder(List<tbl_menu_manageVO> updateArr, tbl_menu_manageVO searchVO);



}
