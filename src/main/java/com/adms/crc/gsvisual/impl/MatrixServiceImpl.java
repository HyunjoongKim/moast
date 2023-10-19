package com.adms.crc.gsvisual.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.adms.crc.gsvisual.MatrixService;
import com.bsite.vo.MatrixVO;
import com.bsite.vo.MethylationVO;
import com.bsite.vo.dna_meVO;
import com.bsite.vo.dna_me_probe_geneVO;
import com.bsite.vo.exp_meth_corr_resultVO;
import com.bsite.vo.genesVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.rna_seqVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MatrixService")
public class MatrixServiceImpl extends EgovAbstractServiceImpl implements MatrixService {

	@Resource
	private MatrixMybatisDao dao;
	
	@Override
	public List<String> selectGeneList(genesVO searchVO) throws Exception {
		return dao.selectGeneList(searchVO);
	}
	
	@Override
	public List<dna_me_probe_geneVO> selectProbeGeneList(dna_me_probe_geneVO searchVO) throws Exception {
		return dao.selectProbeGeneList(searchVO);
	}
	
	@Override
	public List<dna_meVO> selectMethylationList(dna_meVO searchVO) throws Exception {
		return dao.selectMethylationList(searchVO);
	}

	@Override
	public List<dna_meVO> selectMethylationXAxis() throws Exception {
		return dao.selectMethylationXAxis();
	}

	@Override
	public List<rna_seqVO> selectMethylationYAxis() throws Exception {
		return dao.selectMethylationYAxis();
	}
	
	@Override
	public List<MethylationVO> selectMethylationXY(MethylationVO searchVO) throws Exception {
		return dao.selectMethylationXY(searchVO);
	}
	
	@Override
	public List<MethylationVO> selectMethylationXYBySample(MethylationVO searchVO) throws Exception {
		return dao.selectMethylationXYBySample(searchVO);
	}

	@Override
	public List<exp_meth_corr_resultVO> selectExpMethList() throws Exception {
		return dao.selectExpMethList();
	}

	@Override
	public MatrixVO initMatrix(HttpServletRequest request, ModelMap model) throws Exception {
		// 샘플 목록
		List<String> sample1List = Arrays.asList(StringUtils.split(request.getParameter("grp1"), ","));
		List<String> sample2List = Arrays.asList(StringUtils.split(request.getParameter("grp2"), ","));
		List<String> sampleIdList = new ArrayList<String>();
		sampleIdList.addAll(sample1List);
		sampleIdList.addAll(sample2List);
		model.addAttribute("sampleIdCount", sampleIdList.size());
		model.addAttribute("sampleIdList", sampleIdList.stream().map(x -> "\"" + x + "\"").collect(Collectors.joining(",")));
		
		//샘플 중복 선택 하면
		//List<String> sampleIdReList = renameDupl(sampleIdList);
		//model.addAttribute("sampleIdList", sampleIdReList.stream().map(x -> "\"" + x + "\"").collect(Collectors.joining(",")));
		
		
		// 그룹 리스트
		List<String> sampleGroupList = new ArrayList<String>();
		sample1List.forEach(x -> sampleGroupList.add("Group 1"));
		sample2List.forEach(x -> sampleGroupList.add("Group 2"));
		model.addAttribute("sampleGroupList", sampleGroupList.stream().map(x -> "\"" + x + "\"").collect(Collectors.joining(",")));

		// 대상 유전자 불러오기
		List<String> geneList = this.selectGeneList(null);
		model.addAttribute("geneCount", geneList.size());
		model.addAttribute("geneList", geneList.stream().map(x -> "\"" + x + "\"").collect(Collectors.joining(",")));

		// exp rna 불러오기 by 대상 유전자, 샘플
		List<rna_seqVO> expAllList = this.selectMethylationYAxis();
		List<rna_seqVO> expSrcList = expAllList.stream().filter(x -> sampleIdList.stream().anyMatch(x.getSample_id()::equals)).collect(Collectors.toList());

		// probe gene match 리스트 불러오기
		List<dna_me_probe_geneVO> probeGeneList = this.selectProbeGeneList(null);
		List<String> methIdList = probeGeneList.stream().map(x -> x.getGene_symbol() + "$" + x.getProbe_id()).collect(Collectors.toList());
		model.addAttribute("methIdCount", methIdList.size());
		model.addAttribute("methIdList", methIdList.stream().map(x -> "\"" + x + "\"").collect(Collectors.joining(",")));

		// 
		List<dna_meVO> metAllList = this.selectMethylationXAxis();
		List<dna_meVO> metSrcList = metAllList.stream().filter(x -> sampleIdList.stream().anyMatch(x.getSample_id()::equals)).collect(Collectors.toList());
		
		MatrixVO matrixVO = new MatrixVO();
		matrixVO.setSample1List(sample1List);
		matrixVO.setSample2List(sample2List);
		matrixVO.setSampleIdList(sampleIdList);
		matrixVO.setGeneList(geneList);
		matrixVO.setProbeGeneList(probeGeneList);
		matrixVO.setExpSrcList(expSrcList);
		matrixVO.setMethIdList(methIdList);
		matrixVO.setMetSrcList(metSrcList);

		return matrixVO;
	}
	
	private List<String> renameDupl(List<String> list) {
		Set<String> set = new HashSet<String>();
		List<String> rtnList = new ArrayList<String>();
		for (String i : list) {
			rtnList.add(set.contains(i) ? i + "_" : i);
			set.add(i);
		}

		return rtnList;
	}
	
	@Override
	public List<String> getExpListX(MatrixVO matrixVO) throws Exception {
		List<String> sampleIdList = matrixVO.getSampleIdList();
		List<String> geneList = matrixVO.getGeneList();
		List<rna_seqVO> expList = matrixVO.getExpSrcList();
		
		Map<String, Map<String, Double>> expMap = new HashMap<String, Map<String, Double>>();
		for (String i : sampleIdList) {
			Map<String, Double> map = new HashMap<String, Double>();
			expMap.put(i, map);
		}
		for (rna_seqVO i : expList) {
			expMap.get(i.getSample_id()).put(i.getGene_symbol(), i.getRead_count());
		}

		List<String> dataList = new ArrayList<String>();
		for (String sampleId : sampleIdList) {
			List<String> readCountList = new ArrayList<String>();
			for (String gene : geneList) {
				readCountList.add(Double.toString(expMap.get(sampleId).get(gene)));
			}
			dataList.add(String.join(",", readCountList));
		}

		return dataList;
	}
	
	@Override
	public List<String> getMethListX(MatrixVO matrixVO) throws Exception {
		List<String> sampleIdList = matrixVO.getSampleIdList();
		List<String> methIdList = matrixVO.getMethIdList();
		List<dna_meVO> methList = matrixVO.getMetSrcList();
		
		Map<String, Map<String, Double>> metMap = new HashMap<String, Map<String, Double>>();
		for (String i : sampleIdList) {
			Map<String, Double> map = new HashMap<String, Double>();
			metMap.put(i, map);
		}
		for (dna_meVO i : methList) {
			metMap.get(i.getSample_id()).put(i.getGene_probe(), i.getBeta_value());
		}

		List<String> dataList = new ArrayList<String>();
		for (String probeGene : sampleIdList) {
			List<String> betaValueList = new ArrayList<String>();
			for (String sample : methIdList) {
				betaValueList.add(Double.toString(metMap.get(probeGene).get(sample)));
			}
			dataList.add(String.join(",", betaValueList));
		}

		return dataList;
	}
	
	@Override
	public Map<String, String> getExpCorrMap(MatrixVO matrixVO) throws Exception {
		List<String> sampleIdList = matrixVO.getSampleIdList();
		List<String> geneList = matrixVO.getGeneList();
		List<rna_seqVO> expList = matrixVO.getExpSrcList();

		Map<String, Map<String, Double>> expMap = new HashMap<String, Map<String, Double>>();
		for (String i : geneList) {
			Map<String, Double> map = new HashMap<String, Double>();
			expMap.put(i, map);
		}
		for (rna_seqVO i : expList) {
			expMap.get(i.getGene_symbol()).put(i.getSample_id(), i.getRead_count());
		}

		Map<String, String> dataMap = new HashMap<String, String>();
		for (String gene : geneList) {
			List<String> readCountList = new ArrayList<String>();

			readCountList.add(gene);
			for (String sample : sampleIdList) {
				readCountList.add(Double.toString(expMap.get(gene).get(sample)));
			}
			dataMap.put(gene, String.join("\t", readCountList));
		}

		return dataMap;
	}
	
	@Override
	public Map<String, String> getMethCorrMap(MatrixVO matrixVO) throws Exception {
		List<String> sampleIdList = matrixVO.getSampleIdList();
		List<String> methIdList = matrixVO.getMethIdList();
		List<dna_meVO> methList = matrixVO.getMetSrcList();
		Map<String, Map<String, Double>> metMap = new HashMap<String, Map<String, Double>>();
		for (String i : methIdList) {
			Map<String, Double> map = new HashMap<String, Double>();
			metMap.put(i, map);
		}
		for (dna_meVO i : methList) {
			metMap.get(i.getGene_probe()).put(i.getSample_id(), i.getBeta_value());
		}

		Map<String, String> dataMap = new HashMap<String, String>();
		for (String probeGene : methIdList) {
			List<String> betaValueList = new ArrayList<String>();

			String[] sp = StringUtils.split(probeGene, "$");
			betaValueList.add(sp[0]);
			betaValueList.add(sp[1]);
			betaValueList.add(probeGene);

			for (String sample : sampleIdList) {
				betaValueList.add(Double.toString(metMap.get(probeGene).get(sample)));
			}
			dataMap.put(probeGene, String.join("\t", betaValueList));
		}

		return dataMap;
	}

	
}
