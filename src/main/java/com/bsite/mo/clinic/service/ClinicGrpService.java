package com.bsite.mo.clinic.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.mo_clinic_groupVO;
import com.bsite.vo.mo_clinic_group_dtlVO;

public interface ClinicGrpService {

	void createClinicGrp(mo_clinic_groupVO searchVO) throws Exception;

	Map<String, Object> selectClinicGrpList(mo_clinic_groupVO searchVO) throws Exception;

	void updateClinicGrp(mo_clinic_groupVO searchVO) throws Exception;

	void deleteClinicGrp(mo_clinic_groupVO searchVO) throws Exception;
	
	List<mo_clinic_group_dtlVO> selectClinicGrpDtlList(mo_clinic_groupVO searchVO) throws Exception;

	List<mo_clinic_groupVO> selectClinicGrpDuplList(mo_clinic_groupVO searchVO) throws Exception;

	

}
