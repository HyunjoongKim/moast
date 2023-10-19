package com.bsite.mo.basic.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_entrezVO;
import com.bsite.vo.mo_heatmapVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("EntrezDao")
public class EntrezDao extends EgovAbstractMapper {

	public List<mo_entrezVO> selectEntrezListByGenes(mo_entrezVO searchVO) {
		return selectList("selectEntrezListByGenes", searchVO);
	}

	public mo_entrezVO selectEntrezByIdx(int entrez_id) {
		return selectOne("selectEntrezByIdx", entrez_id);
	}
	
	public String selectEntrezIdsByGenes(mo_entrezVO searchVO) {
		return selectOne("selectEntrezIdsByGenes", searchVO);
	}


}
