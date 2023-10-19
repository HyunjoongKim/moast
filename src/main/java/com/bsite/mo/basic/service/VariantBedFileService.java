package com.bsite.mo.basic.service;

import com.bsite.vo.variant.VariantBEDFileVO;

public interface VariantBedFileService {
	
	public void save(VariantBEDFileVO vo);
	
	public VariantBEDFileVO get(int recordIdx);
	
	public VariantBEDFileVO get(Integer primerRecordIdx, Integer blockerRecordIdx, Integer probeRecordIdx);

}
