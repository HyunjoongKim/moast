package com.bsite.mo.basic.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.mo.basic.service.EntrezService;
import com.bsite.vo.mo_entrezVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EntrezService")
public class EntrezServiceImpl extends EgovAbstractServiceImpl implements EntrezService {

	@Resource
	private EntrezDao dao;

	@Override
	public List<mo_entrezVO> selectEntrezListByGenes(mo_entrezVO searchVO) throws Exception {
		return dao.selectEntrezListByGenes(searchVO);
	}

	@Override
	public mo_entrezVO selectEntrezByIdx(int entrez_id) throws Exception {
		return dao.selectEntrezByIdx(entrez_id);
	}
	
	@Override
	public String selectEntrezIdsByGenes(mo_entrezVO searchVO) throws Exception {
		return dao.selectEntrezIdsByGenes(searchVO);
	}

}
