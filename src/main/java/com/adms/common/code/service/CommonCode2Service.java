package com.adms.common.code.service;

import java.util.List;

import com.bsite.vo.CommonCodeVO;


public interface CommonCode2Service {

	List<CommonCodeVO> getMainList(CommonCodeVO searchVO) throws Exception;

	int create(CommonCodeVO searchVO) throws Exception;

	void update(CommonCodeVO searchVO) throws Exception;

	void deleteNode(CommonCodeVO searchVO) throws Exception;

	String getSlideCode(int i, String code_cate);

	List<CommonCodeVO> getComboList(CommonCodeVO searchVO);

	CommonCodeVO getCodeVO(CommonCodeVO searchVO) throws Exception;
	
	CommonCodeVO getCodeVOByIdx(int code_idx) throws Exception;

	void updateOrder(List<CommonCodeVO> updateArr, CommonCodeVO searchVO); 

}
