package com.adms.crc.gsvisual.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.MethylationVO;
import com.bsite.vo.dna_meVO;
import com.bsite.vo.dna_me_probe_geneVO;
import com.bsite.vo.exp_meth_corr_resultVO;
import com.bsite.vo.genesVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.rna_seqVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("MatrixMybatisDao")
public class MatrixMybatisDao extends EgovAbstractMapper {
	
	public void insertMethBatch(List<mo_methVO> list) {
		insert("insertMethBatch", list);
	}

	public List<String> selectGeneList(genesVO searchVO) {
		return selectList("selectGeneList", searchVO);
	}
	
	public List<dna_me_probe_geneVO> selectProbeGeneList(dna_me_probe_geneVO searchVO) {
		return selectList("selectProbeGeneList", searchVO);
	}
	
	public List<dna_meVO> selectMethylationList(dna_meVO searchVO) {
		return selectList("selectMethylationList", searchVO);
	}
	
	public List<dna_meVO> selectMethylationXAxis() {
		return selectList("selectMethylationXAxis");
	}
	
	public List<rna_seqVO> selectMethylationYAxis() {
		return selectList("selectMethylationYAxis");
	}
	
	public List<MethylationVO> selectMethylationXY(MethylationVO searchVO) {
		return selectList("selectMethylationXY", searchVO);
	}
	
	public List<MethylationVO> selectMethylationXYBySample(MethylationVO searchVO) {
		return selectList("selectMethylationXYBySample", searchVO);
	}
	
	public List<exp_meth_corr_resultVO> selectExpMethList() {
		return selectList("selectExpMethList");
	}




}
