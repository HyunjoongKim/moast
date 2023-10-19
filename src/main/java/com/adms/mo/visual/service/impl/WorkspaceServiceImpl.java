package com.adms.mo.visual.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.adms.mo.visual.service.OmicsDataUtils;
import com.adms.mo.visual.service.WorkspaceService;
import com.bsite.vo.mo_workspaceVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("WorkspaceService")
public class WorkspaceServiceImpl extends EgovAbstractServiceImpl implements WorkspaceService {

	@Resource
	private WorkspaceDao dao;
	
	@Override
	public Map<String, Object> selectWorkspaceList(mo_workspaceVO searchVO) {
		List<mo_workspaceVO> result = dao.selectWorkspaceList(searchVO);
		int cnt = dao.selectWorkspaceListCnt(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public void createWorkspace(mo_workspaceVO searchVO) {
		dao.createWorkspace(searchVO);

		String path = OmicsDataUtils.WORKSPACE_TEMP + searchVO.getWs_idx();
		File dir = new File(path);
		if (!dir.exists())
			dir.mkdirs();
	}

	@Override
	public void updateWorkspace(mo_workspaceVO searchVO) {
		dao.updateWorkspace(searchVO);
	}

	@Override
	public void deleteWorkspace(mo_workspaceVO searchVO) {
		dao.deleteWorkspace(searchVO);
	}

}
