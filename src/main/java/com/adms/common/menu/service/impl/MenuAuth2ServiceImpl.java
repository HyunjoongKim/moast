package com.adms.common.menu.service.impl;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.adms.common.menu.service.MenuAuth2Service;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_menu_subVO;


import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MenuAuth2Service")
public class MenuAuth2ServiceImpl extends EgovAbstractServiceImpl implements MenuAuth2Service{
	@Resource
	private MenuAuth2Dao dao;

	@Override
	public List<tbl_menu_manageVO> getMainList(tbl_menu_manageVO searchVO) throws Exception {
		return dao.getMainList(searchVO);
	}

	@Override
	public int createAndUpdate(tbl_menu_manageVO searchVO) throws Exception {
		if(searchVO.getMenu_idx()==0){
			if(getIdxByUniqKeys(searchVO) > 0){ //등록하려는 사이트코드,코드,카테고리 가 있으면
				throw new RuntimeException(searchVO.getMenu_code()+ " 코드가 이미 있습니다. 등록할 수없습니다.");
			}
			return createMenu(searchVO);  //등록
		}else{
			 updateMenu(searchVO);  //업데이트
			 return searchVO.getMenu_idx();
		}
	}

	private void updateMenu(tbl_menu_manageVO searchVO) {
		dao.updateMenu(searchVO);
	}

	private int createMenu(tbl_menu_manageVO searchVO) {
		return dao.createMenu(searchVO);
	}

	private int getIdxByUniqKeys(tbl_menu_manageVO searchVO) {
		return dao.getIdxByUniqKeys(searchVO);
	}

	@Override
	public void deleteNode(tbl_menu_manageVO searchVO) throws Exception {
		if(isChildByMainCode(searchVO) > 0){ //0보다크면 자식이 생겼다고 본다.
			//추후 여기에 하위 메뉴 권한 추가에도 사용되었는지 검사 필요
			throw new RuntimeException(searchVO.getMenu_code()+ " 하위자식이 이미 있습니다. 삭제할 수 없습니다.");
		}

		dao.deleteNodeByIdx(searchVO);
	}

	private int isChildByMainCode(tbl_menu_manageVO searchVO) {
		return dao.isChildByMainCode(searchVO);
	}

	@Override
	public List<tbl_menu_subVO> getRightList(tbl_menu_subVO searchVO) throws Exception {
		return dao.getRightList(searchVO);
	}

	@Override
	public void createRight(List<tbl_menu_subVO> rdataList, LoginVO loginVO, String menu_idx) throws Exception {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("site_code", loginVO.getSite_code());
		map.put("menu_idx", menu_idx);



		deleteRight(map);


		for(tbl_menu_subVO v :rdataList){
			v.setSite_code(loginVO.getSite_code());
			v.setCret_id(loginVO.getId());
			v.setCret_ip(InetAddress.getLocalHost().getHostAddress());

			int r = createRight(v);
			if(r <=0){
				throw new RuntimeException("등록 실패"); //롤백
			}
		}
	}

	private void deleteRight(Map<String, Object> map) {
		dao.deleteRight(map);
	}

	private int createRight(tbl_menu_subVO v) {
		return dao.createRight(v);
	}

	@Override
	public tbl_menu_manageVO getAuthDetailData(LoginVO loginVO) throws Exception {
		return dao.getAuthDetailData(loginVO);
	}

	@Override
	public tbl_menu_subVO getRightDetail(LoginVO loginVO) throws Exception {
		return dao.getRightDetail(loginVO);
	}

	@Override
	public void updateOrder(List<tbl_menu_manageVO> updateArr, tbl_menu_manageVO searchVO) {
		try{			
			for(tbl_menu_manageVO v :updateArr){
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

	private void updateOrderAction(tbl_menu_manageVO v) {
		dao.updateOrderAction(v);
	}

	







}
