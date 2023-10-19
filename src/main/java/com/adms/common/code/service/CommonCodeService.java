package com.adms.common.code.service;

import java.util.List;

import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

public interface CommonCodeService {

	List<CommonCodeVO> getMainList(CommonCodeVO searchVO) throws Exception;

	void createAndUpdate(CommonCodeVO searchVO);

	void deleteNode(CommonCodeVO searchVO);

	void create(CommonCodeVO searchVO) throws Exception;

	void update(CommonCodeVO searchVO) throws Exception;

/*	void changeOrderOther(CommonCodeVO searchVO) throws Exception; 현재 미사용 향후 사용할수도 있음

	void changeOrderOwn(CommonCodeVO searchVO) throws Exception;*/

	void orderUpdate(List<CommonCodeVO> _list, LoginVO loginVO);

}
