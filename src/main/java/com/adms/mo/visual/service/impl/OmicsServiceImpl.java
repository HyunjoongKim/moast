package com.adms.mo.visual.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.adms.mo.visual.service.OmicsService;
import com.bsite.vo.CorrelationScatterVO;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.mo_epic850kVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_infiniumVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_sc_scatterVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("OmicsService")
public class OmicsServiceImpl extends EgovAbstractServiceImpl implements OmicsService {
	@Resource
	private OmicsDao dao;

	@Override
	public List<String> selectGeneExpTpmList100(OmicsDataVO vo) throws Exception {
		return dao.selectGeneExpTpmList100(vo);
	}

	@Override
	public List<String> selectGeneExpCntList100(OmicsDataVO vo) throws Exception {
		return dao.selectGeneExpCntList100(vo);
	}

	@Override
	public List<mo_expVO> selectExpTpmList(OmicsDataVO vo) throws Exception {
		return dao.selectExpTpmList(vo);
	}
	
	@Override
	public List<mo_expVO> selectExpTpmListByGene(OmicsDataVO vo) throws Exception {
		return dao.selectExpTpmListByGene(vo);
	}

	@Override
	public List<mo_expVO> selectExpCntList(OmicsDataVO vo) throws Exception {
		return dao.selectExpCntList(vo);
	}
	
	@Override
	public List<String> selectProbeMethList100(OmicsDataVO vo) throws Exception {
		return dao.selectProbeMethList100(vo);
	}
	
	@Override
	public List<mo_epic850kVO> selectProbeGeneEpicList(OmicsDataVO vo) throws Exception {
		return dao.selectProbeGeneEpicList(vo);
	}

	@Override
	public List<mo_methVO> selectMethList(OmicsDataVO vo) throws Exception {
		return dao.selectMethList(vo);
	}
	
	@Override
	public List<String> selectMethProbeList(OmicsDataVO vo) throws Exception {
		return dao.selectMethProbeList(vo);
	}
	
	@Override
	public List<mo_methVO> selectMethListByGene(OmicsDataVO vo) throws Exception {
		return dao.selectMethListByGene(vo);
	}
	
	@Override
	public List<mo_methVO> selectMethListByGeneSample(OmicsDataVO vo) throws Exception {
		return dao.selectMethListByGeneSample(vo);
	}
	
	@Override
	public List<mo_methVO> selectMethList100(OmicsDataVO vo) throws Exception {
		return dao.selectMethList100(vo);
	}
	
	@Override
	public List<mo_methVO> selectMethListForHeatmap(OmicsDataVO vo) throws Exception {
		List<mo_methVO> list = new ArrayList<mo_methVO>();
		List<String> probeList = vo.getProbeList();
		
		OmicsDataVO searchVO = new OmicsDataVO();
		searchVO.setUd_idx(vo.getUd_idx());
		searchVO.setSampleList(vo.getSampleList());

		List<String> subProbeList;
		int limit = 100;
		int repeat = probeList.size() % limit != 0 ? probeList.size() / limit + 1 : probeList.size() / limit;
		
		for (int id = 0; id < repeat; id++) {
			if (id != (repeat - 1)) {
				subProbeList = new ArrayList<>(probeList.subList(id * limit, (id + 1) * limit));
			} else {
				subProbeList = new ArrayList<>(probeList.subList(id * limit, probeList.size()));
			}

			searchVO.setProbeList(subProbeList);
			List<mo_methVO> subList = dao.selectMethList(searchVO);
			list.addAll(subList);
		}
		
		return list;
	}
	
	@Override
	public List<String> selectMutSnvGeneList100(OmicsDataVO vo) throws Exception {
		return dao.selectMutSnvGeneList100(vo);
	}
	
	@Override
	public List<String> selectMutGeneListLimit(OmicsDataVO vo) throws Exception {
		return dao.selectMutGeneListLimit(vo);
	}
	
	@Override
	public List<String> selectMutSnvGeneListLimit(OmicsDataVO vo) throws Exception {
		return dao.selectMutSnvGeneListLimit(vo);
	}
	
	@Override
	public List<mo_mutationVO> selectMutSnvList(OmicsDataVO vo) throws Exception {
		return dao.selectMutSnvList(vo);
	}
	
	@Override
	public List<String> selectMutIndelGeneList100(OmicsDataVO vo) throws Exception {
		return dao.selectMutIndelGeneList100(vo);
	}
	
	@Override
	public List<mo_mutationVO> selectMutIndelList(OmicsDataVO vo) throws Exception {
		return dao.selectMutIndelList(vo);
	}

	// Correlation
	@Override
	public List<CorrelationScatterVO> selectCorrelationXYBySample(OmicsDataVO vo) throws Exception {
		return dao.selectCorrelationXYBySample(vo);
	}
	
	@Override
	public List<mo_infiniumVO> selectInfiniumList(OmicsDataVO vo) throws Exception {
		return dao.selectInfiniumList(vo);
	}
	
	@Override
	public List<String> selectEpicGeneList() throws Exception {
		return dao.selectEpicGeneList();
	}	
	
	@Override
	public List<String> selectScRnaCellIdListByGene(String gene) throws Exception {
		return dao.selectScRnaCellIdListByGene(gene);
	}
	
	@Override
	public List<Integer> selectScRnaValueListByGene(String gene) throws Exception {
		return dao.selectScRnaValueListByGene(gene);
	}
	
	@Override
	public List<mo_sc_scatterVO> selectScRnaScatterListByGene(OmicsDataVO vo) throws Exception {
		return dao.selectScRnaScatterListByGene(vo);
	}
}
