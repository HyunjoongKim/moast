package com.bsite.mo.clinic.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.bsite.cmm.CommonFunctions;
import com.bsite.mo.clinic.service.ClinicGrpService;
import com.bsite.vo.mo_clinic_groupVO;
import com.bsite.vo.mo_clinic_group_dtlVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ClinicGrpService")
public class ClinicGrpServiceImpl extends EgovAbstractServiceImpl implements ClinicGrpService {

	@Resource
	private ClinicGrpDao dao;

	@Resource
	private ClinicGrpMybatisDao dao2;
	
	
	@Override
	public void createClinicGrp(mo_clinic_groupVO searchVO) throws Exception {
		String[] dtls = StringUtils.split(searchVO.getDtls(), ",");
		String[] cgNos = StringUtils.split(searchVO.getCgNos(), ",");
		if (dtls != null) {
			List<mo_clinic_group_dtlVO> dtlList = new ArrayList<mo_clinic_group_dtlVO>();
			for (int i = 0; i < dtls.length; i++) {
				mo_clinic_group_dtlVO vo = new mo_clinic_group_dtlVO();
				//vo.setCg_idx(searchVO.getCg_idx());
				vo.setSample_id(dtls[i]);
				vo.setCg_no(CommonFunctions.parseInt(cgNos[i]));
				
				vo.setSite_code(searchVO.getSite_code());
				vo.setCret_id(searchVO.getCret_id());
				vo.setCret_ip(searchVO.getCret_ip());
				
				dtlList.add(vo);
				
			}
			searchVO.setDtlList(dtlList);
		}
		
		
		dao.createClinicGrp(searchVO);
	}

	@Override
	public Map<String, Object> selectClinicGrpList(mo_clinic_groupVO searchVO) throws Exception {
		List<mo_clinic_groupVO> result = dao2.selectClinicGrpList(searchVO);
		int cnt = dao2.selectClinicGrpCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public List<mo_clinic_groupVO> selectClinicGrpDuplList(mo_clinic_groupVO searchVO) throws Exception {
		String[] dtls = StringUtils.split(searchVO.getDtls(), ",");
		String[] cgNos = StringUtils.split(searchVO.getCgNos(), ",");
		
		List<mo_clinic_group_dtlVO> dtlList = new ArrayList<mo_clinic_group_dtlVO>();
		if (dtls != null) {
			for (int i = 0; i < dtls.length; i++) {
				mo_clinic_group_dtlVO vo = new mo_clinic_group_dtlVO();
				vo.setSample_id(dtls[i]);
				vo.setCg_no(CommonFunctions.parseInt(cgNos[i]));
				
				dtlList.add(vo);
				
			}
		}
		searchVO.setSearchSamples1(dtlList.stream()
				.filter(x -> x.getCg_no() == 1)
				.map(mo_clinic_group_dtlVO::getSample_id)
				.sorted().collect(Collectors.joining(",")));
		
		searchVO.setSearchSamples2(dtlList.stream()
				.filter(x -> x.getCg_no() == 2)
				.map(mo_clinic_group_dtlVO::getSample_id)
				.sorted().collect(Collectors.joining(",")));
		
		List<mo_clinic_groupVO> result = dao2.selectClinicGrpDuplList(searchVO);

		return result;

	}
	
	@Override
	public void updateClinicGrp(mo_clinic_groupVO searchVO) throws Exception {
		dao.updateClinicGrp(searchVO);
	}

	@Override
	public void deleteClinicGrp(mo_clinic_groupVO searchVO) throws Exception {
		dao.deleteClinicGrp(searchVO);
	}

	@Override
	public List<mo_clinic_group_dtlVO> selectClinicGrpDtlList(mo_clinic_groupVO searchVO) throws Exception {
		return dao2.selectClinicGrpDtlList(searchVO);
	}

}
