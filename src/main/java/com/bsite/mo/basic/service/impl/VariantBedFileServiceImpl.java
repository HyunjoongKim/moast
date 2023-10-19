package com.bsite.mo.basic.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.mo.basic.service.VariantBedFileService;
import com.bsite.vo.variant.VariantBEDFileVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("VariantBedFileService")
public class VariantBedFileServiceImpl extends EgovAbstractServiceImpl implements VariantBedFileService {
	@Resource
	private VariantBedFileDAO dao;

	@Override
	public void save(VariantBEDFileVO vo) {
		dao.save(vo);
	}

	@Override
	public VariantBEDFileVO get(int recordIdx) {
		return dao.getByIdx(recordIdx);
	}

	@Override
	public VariantBEDFileVO get(Integer primerRecordIdx, Integer blockerRecordIdx, Integer probeRecordIdx) {
		return dao.getByParentIdx(primerRecordIdx, blockerRecordIdx, probeRecordIdx);
	}

}
