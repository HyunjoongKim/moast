package com.adms.crc.clinic2.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.clinical_dataVO;
import com.bsite.vo.mo_clinicalD2VO;
import com.bsite.vo.mo_clinicalVO;

public interface Clinic2Service {

	void createClinic(clinical_dataVO searchVO);

	Map<String, Object> getClinicList(clinical_dataVO searchVO);

	void updateClinic(clinical_dataVO searchVO);

	void deleteClinic(clinical_dataVO searchVO);
	
	// data 02
	Map<String, Object> selectClinicList(mo_clinicalVO searchVO);
	
	List<mo_clinicalVO> selectClinicListBySample(OmicsDataVO searchVO);

	Map<String, Object> selectClinicD2List(mo_clinicalD2VO searchVO);

	List<mo_clinicalD2VO> selectClinicD2ListBySample(OmicsDataVO searchVO);

}
