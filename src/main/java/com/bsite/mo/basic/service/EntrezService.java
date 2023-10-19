package com.bsite.mo.basic.service;

import java.util.List;

import com.bsite.vo.mo_entrezVO;

public interface EntrezService {

	List<mo_entrezVO> selectEntrezListByGenes(mo_entrezVO searchVO) throws Exception;

	mo_entrezVO selectEntrezByIdx(int entrez_id) throws Exception;

	String selectEntrezIdsByGenes(mo_entrezVO searchVO) throws Exception;

}
