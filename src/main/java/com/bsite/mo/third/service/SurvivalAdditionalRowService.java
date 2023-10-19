package com.bsite.mo.third.service;

import java.util.List;

import com.bsite.vo.survival.SurvivalAdditionalRow;

public interface SurvivalAdditionalRowService {
	
	public void save(SurvivalAdditionalRow vo);
	
	public List<SurvivalAdditionalRow> selectByType(String type);
	
	public void deleteByType(String type);

}
