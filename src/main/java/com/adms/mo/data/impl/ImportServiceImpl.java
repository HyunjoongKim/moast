package com.adms.mo.data.impl;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.adms.mo.data.ImportService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.vo.mo_epic850kVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_file_logVO;
import com.bsite.vo.mo_importFileVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_sc_cell_geneVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ImportService")
public class ImportServiceImpl extends EgovAbstractServiceImpl implements ImportService {
	
	@Resource
	private ImportDao dao;
	
	
	@Override
	public void importFile(long startLine) throws Exception {
		
		
	}
	
	
	@Override
	public void insertMethBatch(List<mo_methVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0)
			dao.insertMethBatchR3(listVO);
	}
	
	@Override
	public void insertMethBatch2(List<mo_methVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0)
			dao.insertMethBatch2(listVO);
	}
	
	@Override
	public void insertMethBatch3(List<mo_methVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0)
			dao.insertMethBatch3(listVO);
	}
	
	@Override
	public void insertEpicBatch(List<mo_epic850kVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0)
			dao.insertEpicBatch(listVO);
	}


	@Override
	public void insertFileLog(mo_file_logVO vo) throws Exception {
		dao.insertFileLog(vo);
		
	}


	@Override
	public void insertExpCntBatch(List<mo_expVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0)
			dao.insertExpCntBatch(listVO);
	}


	@Override
	public void insertExpTpmBatch(List<mo_expVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0)
			dao.insertExpTpmBatch(listVO);
	}
	
	@Override
	public void insertMutationIndelBatch(List<mo_mutationVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0) {
			System.out.println(listVO.size());
			
			List<List<mo_mutationVO>> list = CommonFunctions.splitList(listVO, 1000);
			for(List<mo_mutationVO> iList : list) {
				
				System.out.println(iList.size());
				
				dao.insertMutationIndelBatch(iList);
			}
		}
	}
	
	@Override
	public void insertMutationSnvBatch(List<mo_mutationVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0) {
			System.out.println(listVO.size());
			
			List<List<mo_mutationVO>> list = CommonFunctions.splitList(listVO, 1000);
			for(List<mo_mutationVO> iList : list) {
				
				//System.out.println(iList.size());
				
				dao.insertMutationSnvBatch(iList);
			}
		}
	}
	
	
	@Override
	public void createTsvExpTpm(mo_importFileVO vo) throws Exception {
		
		mo_file_logVO logVO = new mo_file_logVO();
		logVO.setStartTime(System.currentTimeMillis());
		
		String line;
		try (BufferedReader br = new BufferedReader(new FileReader(vo.getSourceFile()))) {
			line = br.readLine();
			String[] sampleIds = StringUtils.split(line, "\t");
			for (int i = 1; i < vo.getStartLine() - 1; i++)
				br.readLine();

			long fileLine = vo.getStartLine() - 1;
			long lineCount = 0;
			long cellCount = 0;
			int udIdx = vo.getUd_idx();
			String geneSymbol = null;
			StringBuilder sb = new StringBuilder();
			String text = null;
			
			long beforeTime1 = System.currentTimeMillis();
			try(FileWriter writer = new FileWriter(vo.getTargetFile(), true)) {
			
				while ((line = br.readLine()) != null && (lineCount++ < vo.getLineLimit())) {
					beforeTime1 = System.currentTimeMillis();

					
					fileLine++;
					String[] values = StringUtils.split(line, "\t");
					if (values != null) {
						geneSymbol = values[0];
						
						for (int i = 1; i < values.length; i++) {
							cellCount++;
							
							sb.append(udIdx);
							sb.append("\t");
							sb.append(geneSymbol);
							sb.append("\t");
							sb.append(sampleIds[i]);
							sb.append("\t");
							sb.append(values[i]);
							sb.append("\r\n");

							if (cellCount % 10000 == 0) {
								logVO.setBeforeTime(beforeTime1);
								logVO.setFileLine(fileLine);
								logVO.setLineCount(lineCount);
								logVO.setCellCount(cellCount);
								logVO.setItemName(geneSymbol);
								this.writeFile(writer, sb, vo.getLogFile(), logVO);
								
								sb.setLength(0);
							}
						}
					}
				}
				
				if (sb.length() > 0) {
					logVO.setBeforeTime(beforeTime1);
					logVO.setFileLine(fileLine);
					logVO.setLineCount(lineCount);
					logVO.setCellCount(cellCount);
					logVO.setItemName(geneSymbol);
					this.writeFile(writer, sb, vo.getLogFile(), logVO);
					
					sb.setLength(0);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		System.out.println(1);
	}
	
	private void writeFile(FileWriter writer, StringBuilder sb, String logFile, mo_file_logVO logVO) throws IOException {
		writer.append(sb);
		long nowTime = System.currentTimeMillis();
		long diffBeforeTime = (nowTime - logVO.getBeforeTime());
		long doffWholeTime = (nowTime - logVO.getStartTime());
		String log = "fileLine: " + logVO.getFileLine() + "  \t lineCount: " + logVO.getLineCount() + "  \t cellCount: " + logVO.getCellCount() + "  \t ms: " + diffBeforeTime + "   \t s: " + (doffWholeTime / 1000) + "  \t item: " + logVO.getItemName() + "\r\n";
		
		System.out.print(log);
		try(FileWriter writer_log = new FileWriter(logFile, true)) {
			writer_log.append(log);
		}
	}
	
	@Override
	public void insertScRnaBatch(List<mo_sc_cell_geneVO> listVO) throws Exception {
		if (listVO != null && listVO.size() > 0)
			dao.insertScRnaBatch(listVO);
	}
	

	
}
