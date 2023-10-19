package com.adms.common.code.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.adms.common.code.service.CommonCode2Service;
import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;


import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("CommonCode2Service")
public class CommonCode2ServiceImpl extends EgovAbstractServiceImpl implements CommonCode2Service{
	@Resource
	private CommonCode2Dao dao;

	@Resource(name = "LoginService")
    private LoginService loginService;

	@Override
	public List<CommonCodeVO> getMainList(CommonCodeVO searchVO) throws Exception {
		return dao.getMainList(searchVO);
	}

	public int getIdxByUniqKeys(CommonCodeVO searchVO){
		return dao.getIdxByUniqKeys(searchVO);
	}

	@Override
	public int create(CommonCodeVO searchVO) throws Exception {
		if(searchVO.getCode_idx()==0){
			if(getIdxByUniqKeys(searchVO) > 0){ //등록하려는 사이트코드,코드,카테고리 가 있으면
				throw new RuntimeException(searchVO.getMain_code()+ " 코드가 이미 있습니다. 등록할 수없습니다.");
			}
		}
		return dao.create(searchVO);
	}

	@Override
	public void update(CommonCodeVO searchVO) throws Exception {
		dao.update(searchVO);
	}

	@Override
	public void deleteNode(CommonCodeVO searchVO) throws Exception {
		dao.deleteNode(searchVO);
	}

	@Override
	public String getSlideCode(int depth, String code_cate) {
		return dao.getSlideCode(depth,code_cate);
	}

	@Override
	public List<CommonCodeVO> getComboList(CommonCodeVO searchVO) {
		return dao.getComboList(searchVO);
	}

	@Override
	public CommonCodeVO getCodeVO(CommonCodeVO searchVO) throws Exception {
		return dao.getCodeVO(searchVO);
	}

	@Override
	public CommonCodeVO getCodeVOByIdx(int code_idx) throws Exception {
		return dao.getCodeVOByIdx(code_idx);
	}

	@Override
	public void updateOrder(List<CommonCodeVO> updateArr, CommonCodeVO searchVO) {
		try{			
			for(CommonCodeVO v :updateArr){
				v.setModi_id(searchVO.getCret_id());
				v.setModi_ip(searchVO.getCret_ip());

				updateOrderAction(v);				
			}	
		}catch(Exception e){
			String msg = "Failed to change. 1"; // 변경에 실패하였습니다.1
			if(!StringUtils.isEmpty(e.getMessage())) msg=e.getMessage();
			throw new RuntimeException(msg);
		}
	}

	private void updateOrderAction(CommonCodeVO v) {
		dao.updateOrderAction(v);
	}


}
