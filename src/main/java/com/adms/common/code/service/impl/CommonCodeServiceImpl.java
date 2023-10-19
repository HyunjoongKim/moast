package com.adms.common.code.service.impl;

import java.net.InetAddress;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.adms.common.code.service.CommonCodeService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("CommonCodeService")
public class CommonCodeServiceImpl extends EgovAbstractServiceImpl implements CommonCodeService{
	@Resource
	private CommonCodeDao dao;
	
	@Resource(name = "LoginService")
    private LoginService loginService;

	@Override
	public List<CommonCodeVO> getMainList(CommonCodeVO searchVO) throws Exception {
		return dao.getMainList(searchVO);
	}

	@Override
	public void createAndUpdate(CommonCodeVO searchVO){
		if(searchVO.getCode_idx()==0){
			if(getIdxByUniqKeys(searchVO) > 0){ //등록하려는 사이트코드,코드,카테고리 가 있으면
				throw new RuntimeException(searchVO.getMain_code()+ " 코드가 이미 있습니다. 등록할 수없습니다.");
			}
		}
		dao.createAndUpdate(searchVO);
	}

	public int getIdxByUniqKeys(CommonCodeVO searchVO){
		return dao.getIdxByUniqKeys(searchVO);
	}
	private int isChildByMainCode(CommonCodeVO searchVO) {
		return dao.isChildByMainCode(searchVO);
	}

	@Override
	public void deleteNode(CommonCodeVO searchVO) {
		//나의 코드로 쓰인 자식이 생겼는지
		if(isChildByMainCode(searchVO) > 0){ //0보다크면 자식이 생겼다고 본다.
			throw new RuntimeException(searchVO.getMain_code()+ " 하위자식이 이미 있습니다. 삭제할 수 없습니다.");
		}

		dao.deleteNodeByIdx(searchVO);
	}

	@Override
	public void create(CommonCodeVO searchVO) throws Exception {
		if(searchVO.getCode_idx()==0){
			if(getIdxByUniqKeys(searchVO) > 0){ //등록하려는 사이트코드,코드,카테고리 가 있으면
				throw new RuntimeException(searchVO.getMain_code()+ " 코드가 이미 있습니다. 등록할 수없습니다.");
			}
		}
		dao.create(searchVO);
	}

	@Override
	public void update(CommonCodeVO searchVO) throws Exception {
		dao.update(searchVO);
	}
	
/*	@Override 현재 미사용 향후 사용할수도 있음
	public void changeOrderOther(CommonCodeVO searchVO) throws Exception {
		dao.changeOrderOther(searchVO);
	}	
	
	@Override
	public void changeOrderOwn(CommonCodeVO searchVO) throws Exception {
		dao.changeOrderOwn(searchVO);
	}*/

	@Override
	public void orderUpdate(List<CommonCodeVO> _list, LoginVO loginVO) {
		
		try{
			for(CommonCodeVO v: _list){
				v.setSite_code(loginService.getSiteCode());
				v.setModi_id(loginVO.getId());
				v.setModi_ip(InetAddress.getLocalHost().getHostAddress());
				
				orderUpdateAction(v);
			}
		}catch(Exception e){
			throw new RuntimeException("순번변경에 실패하였습니다.");
		}
		
	}

	private void orderUpdateAction(CommonCodeVO v) {
		dao.orderUpdateAction(v);
	}	
	
}
