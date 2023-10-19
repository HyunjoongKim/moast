package com.adms.crc.clinic2.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.genesVO;
import com.bsite.vo.mo_clinicalD2VO;
import com.bsite.vo.mo_clinicalVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("Clinic2MybatisDao")
public class Clinic2MybatisDao extends EgovAbstractMapper {

	public List<mo_clinicalVO> selectClinicList(mo_clinicalVO searchVO) {
		return selectList("selectClinicList", searchVO);
	}

	public int selectClinicCount(mo_clinicalVO searchVO) {
		return selectOne("selectClinicCount", searchVO);
	}

	public List<mo_clinicalVO> selectClinicListBySample(OmicsDataVO searchVO) {
		return selectList("selectClinicListBySample", searchVO);
	}
	
	public List<mo_clinicalD2VO> selectClinicD2List(mo_clinicalD2VO searchVO) {
		return selectList("selectClinicD2List", searchVO);
	}

	public int selectClinicD2Count(mo_clinicalD2VO searchVO) {
		return selectOne("selectClinicD2Count", searchVO);
	}

	public List<mo_clinicalD2VO> selectClinicD2ListBySample(OmicsDataVO searchVO) {
		return selectList("selectClinicD2ListBySample", searchVO);
	}
	
	

}
