package com.bsite.mo.basic.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.VariantRecordVO;
import com.bsite.vo.variant.VariantBEDFileVO;
import com.bsite.vo.variant.VariantBlockerResultVO;
import com.bsite.vo.variant.VariantPrimerResultVO;
import com.bsite.vo.variant.VariantProbeResultVO;
import com.bsite.vo.VarPrimerVO;

public interface VariantService {
	
	public Map<String, String> sendAnnotationForFasta(VarPrimerVO searchVO);
	
	public List<VariantPrimerResultVO> sendForBatchPrimer3(VarPrimerVO searchVO);
	
	public List<VariantBlockerResultVO> sendForBlocker(VarPrimerVO searchVO);
	
	public List<VariantProbeResultVO> sendForProbe(VarPrimerVO searchVO);
	
	public void save(VariantRecordVO searchVO);
	
	List<VariantRecordVO> selectVariantRecordList(VariantRecordVO searchVO);
	
	public int countVariantRecordList(VariantRecordVO searchVO);
	
	VariantRecordVO selectVariantRecord(int recordIdx);
	
	public List<VariantBEDFileVO> generateBedFiles(VariantRecordVO searchVO, int positionPadding);

	
}
