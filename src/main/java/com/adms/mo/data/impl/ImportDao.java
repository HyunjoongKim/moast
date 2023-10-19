package com.adms.mo.data.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.bsite.vo.mo_epic850kVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_sc_cell_geneVO;
import com.bsite.vo.mo_file_logVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ImportDao")
public class ImportDao extends EgovAbstractMapper {
	
	public void insertMethBatch(List<mo_methVO> listVO) {
		insert("insertMethBatch", listVO);
	}
	
	public void insertMethBatchR3(List<mo_methVO> listVO) {
		insert("insertMethBatchR3", listVO);
	}
	
	public void insertMethBatch2(List<mo_methVO> listVO) {
		insert("insertMethBatch2", listVO);
	}
	
	public void insertMethBatch3(List<mo_methVO> listVO) {
		insert("insertMethBatch3", listVO);
	}
	
	public void insertEpicBatch(List<mo_epic850kVO> listVO) {
		insert("insertEpicBatch", listVO);
	}
	
	public void insertFileLog(mo_file_logVO vo) {
		insert("insertFileLog", vo);
	}

	public void insertExpCntBatch(List<mo_expVO> listVO) {
		insert("insertExpCntBatch", listVO);
	}
	
	public void insertExpTpmBatch(List<mo_expVO> listVO) {
		insert("insertExpTpmBatch", listVO);
	}

	public void insertMutationIndelBatch(List<mo_mutationVO> listVO) {
		insert("insertMutationIndelBatch", listVO);
	}
	
	public void insertMutationSnvBatch(List<mo_mutationVO> listVO) {
		insert("insertMutationSnvBatch", listVO);
	}
	
	public void insertScRnaBatch(List<mo_sc_cell_geneVO> listVO) {
		insert("insertScRnaBatch", listVO);
	}
	
	
	

}
