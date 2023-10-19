package com.bsite.mo.third.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bsite.mo.third.service.SurvivalAdditionalRowService;
import com.bsite.vo.survival.SurvivalAdditionalRow;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("SurvivalAdditionalRowService")
public class SurvivalAdditionalRowServiceImpl extends EgovAbstractServiceImpl implements SurvivalAdditionalRowService {
	
	@Resource
	SurvivalAdditionalRowDAO dao;

	@Override
	public void save(SurvivalAdditionalRow vo) {
		dao.save(vo);
	}

	@Override
	public List<SurvivalAdditionalRow> selectByType(String type) {
		return dao.selectByType(type);
	}

	@Override
	public void deleteByType(String type) {
		dao.delete(type);
	}

}
