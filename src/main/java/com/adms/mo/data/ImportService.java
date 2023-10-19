package com.adms.mo.data;

import java.util.List;

import com.bsite.vo.mo_epic850kVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_sc_cell_geneVO;
import com.bsite.vo.mo_file_logVO;
import com.bsite.vo.mo_importFileVO;

public interface ImportService {
	
	void importFile(long startLine) throws Exception;
	
	void insertFileLog(mo_file_logVO vo) throws Exception;
	
	void insertMethBatch(List<mo_methVO> listVO) throws Exception;

	void insertMethBatch2(List<mo_methVO> listVO) throws Exception;
	
	void insertMethBatch3(List<mo_methVO> listVO) throws Exception;
	
	void insertExpCntBatch(List<mo_expVO> listVO) throws Exception;
	
	void insertExpTpmBatch(List<mo_expVO> listVO) throws Exception;
	
	void insertEpicBatch(List<mo_epic850kVO> listVO) throws Exception;

	void createTsvExpTpm(mo_importFileVO importVO) throws Exception;
	
	//mutation
	void insertMutationIndelBatch(List<mo_mutationVO> listVO) throws Exception;
	
	void insertMutationSnvBatch(List<mo_mutationVO> listVO) throws Exception;

	void insertScRnaBatch(List<mo_sc_cell_geneVO> listVO) throws Exception;

}
