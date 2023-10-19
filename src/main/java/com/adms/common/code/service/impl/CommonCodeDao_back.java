package com.adms.common.code.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

//@Repository("CommonCodeDao")
public class CommonCodeDao_back extends EgovComAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<CommonCodeVO> getMainList(CommonCodeVO searchVO) {
		return (List<CommonCodeVO>) list("CommonCodeDao.getMainList",searchVO);
	}

	public void createAndUpdate(CommonCodeVO searchVO) {
		insert("CommonCodeDao.createAndUpdate",searchVO);
	}

	public int getIdxByUniqKeys(CommonCodeVO searchVO) {
		return (int) select("CommonCodeDao.getIdxByUniqKeys", searchVO);
	}

	public int isChildByMainCode(CommonCodeVO searchVO) {
		return (int) select("CommonCodeDao.isChildByMainCode", searchVO);
	}

	public void deleteNodeByIdx(CommonCodeVO searchVO) {
		delete("CommonCodeDao.deleteNodeByIdx",searchVO);
	}

	public void create(CommonCodeVO searchVO) {
		insert("CommonCodeDao.create",searchVO);
	}

	public void update(CommonCodeVO searchVO) {
		update("CommonCodeDao.update",searchVO);
	}

/*	public void changeOrderOther(CommonCodeVO searchVO) {  현재 미사용 향후 사용할 수도 있음
		update("CommonCodeDao.changeOrderOther",searchVO);		
	}

	public void changeOrderOwn(CommonCodeVO searchVO) {
		update("CommonCodeDao.changeOrderOwn",searchVO);		
	}*/

	public void orderUpdateAction(CommonCodeVO v) {
		update("CommonCodeDao.orderUpdateAction",v);		
	}



}
