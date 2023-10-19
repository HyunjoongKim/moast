package com.adms.crc.clinic2.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.adms.crc.clinic2.service.Clinic2Service;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.clinical_dataVO;
import com.bsite.vo.mo_clinicalD2VO;
import com.bsite.vo.mo_clinicalVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("Clinic2Service")
public class Clinic2ServiceImpl extends EgovAbstractServiceImpl implements Clinic2Service {

	@Resource
	private Clinic2Dao dao;
	
	@Resource
	private Clinic2MybatisDao dao2;

	@Override
	public void createClinic(clinical_dataVO searchVO) {
		dao.createClinic(searchVO);
	}

	@Override
	public Map<String, Object> getClinicList(clinical_dataVO searchVO) {
		List<clinical_dataVO> result = dao.getClinicList(searchVO);
		int cnt = 10;//dao.getClinicListCnt(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public Map<String, Object> selectClinicList(mo_clinicalVO searchVO) {
		List<mo_clinicalVO> result = dao2.selectClinicList(searchVO);
		int cnt = dao2.selectClinicCount(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}

	@Override
	public void updateClinic(clinical_dataVO searchVO) {
		dao.updateClinic(searchVO);
	}

	@Override
	public void deleteClinic(clinical_dataVO searchVO) {
		dao.deleteClinic(searchVO);
	}

	@Override
	public List<mo_clinicalVO> selectClinicListBySample(OmicsDataVO searchVO) {
		return dao2.selectClinicListBySample(searchVO);
	}
	
	@Override
	public Map<String, Object> selectClinicD2List(mo_clinicalD2VO searchVO) {
		List<mo_clinicalD2VO> result = dao2.selectClinicD2List(searchVO);
		int cnt = dao2.selectClinicD2Count(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;

	}
	
	@Override
	public List<mo_clinicalD2VO> selectClinicD2ListBySample(OmicsDataVO searchVO) {
		return dao2.selectClinicD2ListBySample(searchVO);
	}

}
