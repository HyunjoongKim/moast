package com.adms.mo.visual.service;

import java.util.Map;

import com.bsite.vo.mo_workspaceVO;

public interface WorkspaceService {

	Map<String, Object> selectWorkspaceList(mo_workspaceVO searchVO);

	void createWorkspace(mo_workspaceVO searchVO);

	void updateWorkspace(mo_workspaceVO searchVO);

	void deleteWorkspace(mo_workspaceVO searchVO);

}
