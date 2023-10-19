package com.adms.crc.gsvisual;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;

import com.bsite.vo.MatrixVO;
import com.bsite.vo.MethylationVO;
import com.bsite.vo.dna_meVO;
import com.bsite.vo.dna_me_probe_geneVO;
import com.bsite.vo.exp_meth_corr_resultVO;
import com.bsite.vo.genesVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.rna_seqVO;

public interface MatrixService {
	
	List<String> selectGeneList(genesVO searchVO) throws Exception;

	List<dna_me_probe_geneVO> selectProbeGeneList(dna_me_probe_geneVO searchVO) throws Exception;

	List<dna_meVO> selectMethylationList(dna_meVO searchVO) throws Exception;

	List<dna_meVO> selectMethylationXAxis() throws Exception;

	List<rna_seqVO> selectMethylationYAxis() throws Exception;

	List<MethylationVO> selectMethylationXY(MethylationVO searchVO) throws Exception;

	List<MethylationVO> selectMethylationXYBySample(MethylationVO searchVO) throws Exception;

	List<exp_meth_corr_resultVO> selectExpMethList() throws Exception;

	MatrixVO initMatrix(HttpServletRequest request, ModelMap model) throws Exception;

	List<String> getExpListX(MatrixVO matrixVO) throws Exception;

	List<String> getMethListX(MatrixVO matrixVO) throws Exception;

	Map<String, String> getExpCorrMap(MatrixVO matrixVO) throws Exception;

	Map<String, String> getMethCorrMap(MatrixVO matrixVO) throws Exception;

	

}
