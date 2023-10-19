package com.bsite.mo.basic.service;

import java.util.List;
import java.util.Map;

import com.bsite.vo.HtPrimerVO;
import com.bsite.vo.MethylationRecordVO;

public interface MethylationService {
	
	public String sendToHtPrimer(HtPrimerVO searchVO);
	
	public void save(MethylationRecordVO searchVO);
	
	List<MethylationRecordVO> selectMethylationRecordList(MethylationRecordVO searchVO);
	
	public int countMethylationRecordList(MethylationRecordVO searchVO);
	
	MethylationRecordVO selectMethylationRecord(int recordIdx);

	
}
