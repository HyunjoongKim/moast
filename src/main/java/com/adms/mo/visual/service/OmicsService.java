package com.adms.mo.visual.service;

import java.util.List;

import com.bsite.vo.CorrelationScatterVO;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.mo_epic850kVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_infiniumVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_sc_scatterVO;

public interface OmicsService {

	List<String> selectGeneExpTpmList100(OmicsDataVO vo) throws Exception;

	List<String> selectGeneExpCntList100(OmicsDataVO vo) throws Exception;

	List<mo_expVO> selectExpTpmList(OmicsDataVO vo) throws Exception;
	
	List<mo_expVO> selectExpTpmListByGene(OmicsDataVO vo) throws Exception;

	List<mo_expVO> selectExpCntList(OmicsDataVO vo) throws Exception;

	List<String> selectProbeMethList100(OmicsDataVO vo) throws Exception;

	List<mo_methVO> selectMethList(OmicsDataVO vo) throws Exception;
	
	List<String> selectMethProbeList(OmicsDataVO vo) throws Exception;
	
	List<mo_methVO> selectMethListByGene(OmicsDataVO vo) throws Exception;
	
	List<mo_methVO> selectMethListByGeneSample(OmicsDataVO vo) throws Exception;
	
	List<mo_methVO> selectMethList100(OmicsDataVO vo) throws Exception;
	
	List<mo_methVO> selectMethListForHeatmap(OmicsDataVO vo) throws Exception;
	
	List<String> selectMutSnvGeneList100(OmicsDataVO vo) throws Exception;
	
	List<String> selectMutGeneListLimit(OmicsDataVO vo) throws Exception;
	
	List<String> selectMutSnvGeneListLimit(OmicsDataVO vo) throws Exception;
	
	List<mo_mutationVO> selectMutSnvList(OmicsDataVO vo) throws Exception;
	
	List<String> selectMutIndelGeneList100(OmicsDataVO vo) throws Exception;
	
	List<mo_mutationVO> selectMutIndelList(OmicsDataVO vo) throws Exception;

	// Correlation
	List<CorrelationScatterVO> selectCorrelationXYBySample(OmicsDataVO vo) throws Exception;

	List<mo_epic850kVO> selectProbeGeneEpicList(OmicsDataVO vo) throws Exception;

	List<mo_infiniumVO> selectInfiniumList(OmicsDataVO vo) throws Exception;

	List<String> selectEpicGeneList() throws Exception;

	//List<String> selectScRnaListByGenes(OmicsDataVO vo) throws Exception;

	List<String> selectScRnaCellIdListByGene(String vo) throws Exception;

	List<Integer> selectScRnaValueListByGene(String vo) throws Exception;

	List<mo_sc_scatterVO> selectScRnaScatterListByGene(OmicsDataVO vo) throws Exception;
	

	
	
}
