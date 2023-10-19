package com.adms.common.code.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.CommonCodeVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
/**
 * 
 * MYBATIS
 *
 */
@Repository("CommonCodeDao")
public class CommonCodeDao extends EgovAbstractMapper{

	public List<CommonCodeVO> getMainList(CommonCodeVO searchVO) {
		return selectList("CommonCodeDaogetMainList",searchVO);
	}

	public void createAndUpdate(CommonCodeVO searchVO) {
		insert("CommonCodeDaocreateAndUpdate",searchVO);
	}

	public int getIdxByUniqKeys(CommonCodeVO searchVO) {
		return selectOne("CommonCodeDaogetIdxByUniqKeys", searchVO);
	}

	public int isChildByMainCode(CommonCodeVO searchVO) {
		return selectOne("CommonCodeDaoisChildByMainCode", searchVO);
	}

	public void deleteNodeByIdx(CommonCodeVO searchVO) {
		delete("CommonCodeDaodeleteNodeByIdx",searchVO);
	}

	public void create(CommonCodeVO searchVO) {
		insert("CommonCodeDaocreate",searchVO);
	}

	public void update(CommonCodeVO searchVO) {
		update("CommonCodeDaoupdate",searchVO);
	}

/*	public void changeOrderOther(CommonCodeVO searchVO) {  현재 미사용 향후 사용할 수도 있음
		update("CommonCodeDao.changeOrderOther",searchVO);		
	}

	public void changeOrderOwn(CommonCodeVO searchVO) {
		update("CommonCodeDao.changeOrderOwn",searchVO);		
	}*/

	public void orderUpdateAction(CommonCodeVO v) {
		update("CommonCodeDaoorderUpdateAction",v);		
	}



}
