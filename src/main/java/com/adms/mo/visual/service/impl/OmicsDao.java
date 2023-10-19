package com.adms.mo.visual.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.CorrelationScatterVO;
import com.bsite.vo.MethylationVO;
import com.bsite.vo.dna_meVO;
import com.bsite.vo.exp_meth_corr_resultVO;
import com.bsite.vo.genesVO;
import com.bsite.vo.mo_epic850kVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_infiniumVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_sc_scatterVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("OmicsDao")
public class OmicsDao extends EgovAbstractMapper {
	
	public void insertMethBatch(List<mo_methVO> list) {
		insert("insertMethBatch", list);
	}
	
	public List<mo_expVO> selectTest(genesVO vo) {
		return selectList("selectTest", vo);
	}
	
	
	public List<String> selectProbeMethList100(OmicsDataVO vo) {
		return selectList("selectProbeMethList100", vo);
	}

	public List<mo_methVO> selectMethList(OmicsDataVO vo) {
		return selectList("selectMethList", vo);
	}
	
	public List<String> selectMethProbeList(OmicsDataVO vo) {
		return selectList("selectMethProbeList", vo);
	}
	
	public List<mo_methVO> selectMethListByGene(OmicsDataVO vo) {
		return selectList("selectMethListByGene", vo);
	}
	
	public List<mo_methVO> selectMethListByGeneSample(OmicsDataVO vo) {
		return selectList("selectMethListByGeneSample", vo);
	}
	
	public List<mo_methVO> selectMethList100(OmicsDataVO vo) {
		return selectList("selectMethList100", vo);
	}
	
	public List<String> selectGeneExpTpmList100(OmicsDataVO vo) {
		return selectList("selectGeneExpTpmList100", vo);
	}
	
	public List<String> selectGeneExpCntList100(OmicsDataVO vo) {
		return selectList("selectGeneExpCntList100", vo);
	}
	
	public List<mo_expVO> selectExpTpmList(OmicsDataVO vo) {
		return selectList("selectExpTpmList", vo);
	}
	public List<mo_expVO> selectExpTpmListByGene(OmicsDataVO vo) {
		return selectList("selectExpTpmListByGene", vo);
	}
	
	public List<mo_expVO> selectExpCntList(OmicsDataVO vo) {
		return selectList("selectExpCntList", vo);
	}
	
	public List<mo_infiniumVO> selectInfiniumList(OmicsDataVO vo) {
		return selectList("selectInfiniumList", vo);
	}
	
	public List<String> selectEpicGeneList() {
		return selectList("selectEpicGeneList");
	}
	
	public List<String> selectScRnaCellIdListByGene(String gene) {
		return selectList("selectScRnaCellIdListByGene", gene);
	}
	
	public List<Integer> selectScRnaValueListByGene(String gene) {
		return selectList("selectScRnaValueListByGene", gene);
	}
	
	public List<mo_sc_scatterVO> selectScRnaScatterListByGene(OmicsDataVO vo) {
		return selectList("selectScRnaScatterListByGene", vo);
	}
	
	
	
	
	
	

	public List<mo_epic850kVO> selectProbeGeneEpicList(OmicsDataVO searchVO) {
		return selectList("selectProbeGeneEpicList", searchVO);
	}
	
	public List<dna_meVO> selectMethylationList(dna_meVO searchVO) {
		return selectList("selectMethylationList", searchVO);
	}
	
	public List<MethylationVO> selectMethylationXY(MethylationVO searchVO) {
		return selectList("selectMethylationXY", searchVO);
	}
	
	public List<exp_meth_corr_resultVO> selectExpMethList() {
		return selectList("selectExpMethList");
	}
	
	public List<String> selectMutSnvGeneList100(OmicsDataVO vo) {
		return selectList("selectMutSnvGeneList100", vo);
	}
	
	public List<String> selectMutGeneListLimit(OmicsDataVO vo) {
		return selectList("selectMutGeneListLimit", vo);
	}
	
	public List<String> selectMutSnvGeneListLimit(OmicsDataVO vo) {
		return selectList("selectMutSnvGeneListLimit", vo);
	}
	
	public List<mo_mutationVO> selectMutSnvList(OmicsDataVO vo) {
		return selectList("selectMutSnvList", vo);
	}
	
	public List<String> selectMutIndelGeneList100(OmicsDataVO vo) {
		return selectList("selectMutIndelGeneList100", vo);
	}
	
	public List<mo_mutationVO> selectMutIndelList(OmicsDataVO vo) {
		return selectList("selectMutIndelList", vo);
	}
	

	// Correlation
	public List<CorrelationScatterVO> selectCorrelationXYBySample(OmicsDataVO vo) {
		return selectList("selectCorrelationXYBySample", vo);
	}

}
