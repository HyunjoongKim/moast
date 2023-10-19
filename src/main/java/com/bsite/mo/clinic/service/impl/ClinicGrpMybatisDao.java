package com.bsite.mo.clinic.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_clinic_groupVO;
import com.bsite.vo.mo_clinic_group_dtlVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ClinicGrpMybatisDao")
public class ClinicGrpMybatisDao extends EgovAbstractMapper {

	public List<mo_clinic_groupVO> selectClinicGrpList(mo_clinic_groupVO searchVO) {
		return selectList("selectClinicGrpList", searchVO);
	}
	
	public int selectClinicGrpCount(mo_clinic_groupVO searchVO) {
		return selectOne("selectClinicGrpCount", searchVO);
	}

	public List<mo_clinic_group_dtlVO> selectClinicGrpDtlList(mo_clinic_groupVO searchVO) {
		return selectList("selectClinicGrpDtlList", searchVO);
	}

	public List<mo_clinic_groupVO> selectClinicGrpDuplList(mo_clinic_groupVO searchVO) {
		return selectList("selectClinicGrpDuplList", searchVO);
	}
	
}
