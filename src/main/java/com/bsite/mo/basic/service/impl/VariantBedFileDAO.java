package com.bsite.mo.basic.service.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.bsite.vo.variant.VariantBEDFileVO;

import egovframework.com.cmm.service.impl.CHibernateDaoSupport;

@Repository("VariantBedFileDAO")
public class VariantBedFileDAO extends CHibernateDaoSupport {
	
	public DetachedCriteria setSearchCriteria(DetachedCriteria query, VariantBEDFileVO searchVO) {
		return query;
	}

	public void save(VariantBEDFileVO vo) {
		getHibernateTemplate().save(vo);
	}
	
	public VariantBEDFileVO getByIdx(int recordIdx) {
		DetachedCriteria query  = DetachedCriteria.forClass(VariantBEDFileVO.class , "vo");
		query.add(Restrictions.eqOrIsNull("recordIdx", recordIdx));
		
		@SuppressWarnings("unchecked")
		List<VariantBEDFileVO> list = (List<VariantBEDFileVO>) getHibernateTemplate().findByCriteria(query);
		
		VariantBEDFileVO variantBedFile = null;
		if (list.size() > 0)
			variantBedFile = list.get(0);
		return variantBedFile;
	}
	
	public VariantBEDFileVO getByParentIdx(Integer primerRecordIdx, Integer blockerRecordIdx, Integer probeRecordIdx) {
		DetachedCriteria query  = DetachedCriteria.forClass(VariantBEDFileVO.class , "vo");
		query.add(Restrictions.eqOrIsNull("variantPrimerResult.recordIdx", primerRecordIdx));
		query.add(Restrictions.eqOrIsNull("variantBlockerResult.recordIdx", blockerRecordIdx));
		query.add(Restrictions.eqOrIsNull("variantProbeResult.recordIdx", probeRecordIdx));
		
		@SuppressWarnings("unchecked")
		List<VariantBEDFileVO> list = (List<VariantBEDFileVO>) getHibernateTemplate().findByCriteria(query);
		
		VariantBEDFileVO variantBedFile = null;
		if (list.size() > 0)
			variantBedFile = list.get(0);
		return variantBedFile;
	}
}
