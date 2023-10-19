package com.adms.common.site.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.adms.common.site.service.SiteManageService;
import com.bsite.vo.AuthVO;
import com.bsite.vo.tbl_siteVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("SiteManageService")
public class SiteManageServiceImpl extends EgovAbstractServiceImpl implements SiteManageService{
	@Resource
	private SiteManageDao dao;

	@Override
	public Map<String, Object> getList(tbl_siteVO searchVO) {
		List<tbl_siteVO> result = dao.getList(searchVO);
		int cnt = dao.getListCnt(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;
	}

	@Override
	public void insertDB(tbl_siteVO searchVO) {
		dao.insertDB(searchVO);
	}

	@Override
	public tbl_siteVO getDetailVO(tbl_siteVO searchVO) {
		return dao.getDetailVO(searchVO);
	}

	@Override
	public void updateVO(tbl_siteVO searchVO) {
		dao.updateVO(searchVO);
	}

	@Override
	public void deleteVO(tbl_siteVO searchVO) {
		dao.deleteVO(searchVO);
	}

	@Override
	public List<tbl_siteVO> getListAll() {
		return dao.getListAll();
	}
}
