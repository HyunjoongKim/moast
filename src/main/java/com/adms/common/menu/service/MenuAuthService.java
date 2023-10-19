package com.adms.common.menu.service;

import java.util.List;

import com.bsite.vo.AuthDetailVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_menu_subVO;

public interface MenuAuthService {

	List<tbl_menu_manageVO> getMainList(tbl_menu_manageVO searchVO) throws Exception;

	void createAndUpdate(tbl_menu_manageVO searchVO) throws Exception;

	void deleteNode(tbl_menu_manageVO searchVO)  throws Exception;

	List<tbl_menu_subVO> getRightList(tbl_menu_subVO searchVO)  throws Exception;

	void createRight(List<tbl_menu_subVO> rdataList, LoginVO loginInfo, String menuIdx) throws Exception;

	tbl_menu_subVO getAuthDetailData(LoginVO loginVO)  throws Exception;

	tbl_menu_subVO getRightDetail(LoginVO loginVO)  throws Exception;

}
