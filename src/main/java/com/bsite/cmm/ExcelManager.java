package com.bsite.cmm;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * 엑셀파일을 파싱
 *  *
 */
public class ExcelManager {
	
	private static ExcelManager excelMng;
	
	public ExcelManager() {
		// TODO Auto-generated constructor stub
	}
	
	public static ExcelManager getInstance() {
		if (excelMng == null)
			excelMng = new ExcelManager();
		return excelMng;
	}
	
	/**
	 * 엑셀파일 파싱후 HashMap리스트를 반환
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	Logger LOG = LoggerFactory.getLogger("com");
	HSSFWorkbook workbook;
	/*********************************************  xls *************************************************/
	/*********************************************  xls *************************************************/
	/*********************************************  xls *************************************************/
	
	public List<HashMap<String, String>> getListExcelRead(String file) throws Exception {
		List<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		workbook = new HSSFWorkbook(new FileInputStream(file));
		//엑셀파일의 시트 존재 유무 확인
		if (workbook.getNumberOfSheets() < 1) return null;
		
		//첫번째 시트를 읽음
		HSSFSheet sheet = workbook.getSheetAt(0);
		for (int i = 0; i <= sheet.getLastRowNum(); i++) {
			if(readCellData(sheet.getRow(i)) != null){
				list.add(readCellData(sheet.getRow(i)));
			}
		}
		return list;
	}
	
	
	
	/*
	public List<HashMap<String, String>> getListExcel(File file) throws Exception {
		List<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(file));
		//엑셀파일의 시트 존재 유무 확인
		if (workbook.getNumberOfSheets() < 1) return null;
		
		//첫번째 시트를 읽음
		HSSFSheet sheet = workbook.getSheetAt(0);
		for (int i = 0; i <= sheet.getLastRowNum(); i++) {
			if(readCellData(sheet.getRow(i)) != null){
				list.add(readCellData(sheet.getRow(i)));
			}
		}
		return list;
	}
	*/
	private HashMap<String, String> readCellData(HSSFRow row) {
		HashMap<String, String> hMap = new HashMap<String, String>();
		System.out.println("==============ROW"+row.getRowNum()+"==============");
		for(int k=row.getFirstCellNum(); k<=row.getLastCellNum(); k++){
			//System.out.println("row.getCell()----------------"+getStringCellData(row.getCell(k)));
			//if(getStringCellData(row.getCell(k)) !=null){
			String x= getStringCellData(row.getCell(k));
			if(!StringUtils.isEmpty(x)){
				hMap.put("cell_"+k,x);
			}
			//}
		}
		
		return hMap;
	}	

	
	@SuppressWarnings("unused")
	private CellValue formulaEvaluation(HSSFCell cell) {
	    FormulaEvaluator formulaEval = workbook.getCreationHelper().createFormulaEvaluator();
	    return formulaEval.evaluate(cell);
	}
	
	@SuppressWarnings("unused")
	private String cellTypeNumeric(HSSFCell cell){
		//DecimalFormat df = new DecimalFormat();
		String data="";
		if (HSSFDateUtil.isCellDateFormatted(cell)) {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			data = formatter.format(cell.getDateCellValue());
		} else {
			double ddata = cell.getNumericCellValue();
			data = AuthButtonTag.floorZero(ddata);
			//data = Double.toString(ddata);
		}
		return data;
	}
	
	public String getStringCellData (HSSFCell cell) {
		
		FormulaEvaluator evaluator = new HSSFWorkbook().getCreationHelper().createFormulaEvaluator();
		
		if (cell != null) {
			String data = null;
			switch (cell.getCellType()) {
				case HSSFCell.CELL_TYPE_BOOLEAN:
					boolean bdata = cell.getBooleanCellValue();
					data = String.valueOf(bdata);
					//System.out.println("data  CELL_TYPE_BOOLEAN : "+data);
					break;
				case HSSFCell.CELL_TYPE_NUMERIC:
					data = cellTypeNumeric(cell);
					//System.out.println("data  CELL_TYPE_NUMERIC : "+data);
					break;
				case HSSFCell.CELL_TYPE_STRING:
					data = cell.toString();
					//System.out.println("data  CELL_TYPE_STRING : "+data);
					break;
				case HSSFCell.CELL_TYPE_BLANK:
					data ="";
					//System.out.println("data  CELL_TYPE_BLANK : "+data);
					break;
				case HSSFCell.CELL_TYPE_ERROR:
					data ="";
					//System.out.println("data  CELL_TYPE_ERROR : "+data);
					break;
				case HSSFCell.CELL_TYPE_FORMULA:					
					CellValue objCellValue = formulaEvaluation(cell);
					if (objCellValue.getCellType() == Cell.CELL_TYPE_NUMERIC) {
						data = cellTypeNumeric(cell);
		            }else if(objCellValue.getCellType() == Cell.CELL_TYPE_STRING){
		            	data = cell.toString();
		            }else if(objCellValue.getCellType() == Cell.CELL_TYPE_BOOLEAN){
		            	//boolean bdata = ;
						data = String.valueOf(cell.getBooleanCellValue());
		            }else{
		            	data = cell.toString();
		            }
					System.out.println("data  CELL_TYPE_FORMULA : "+data);
		            break;
				default:
					data = cell.toString();
			}
			System.out.println("data  default : "+data);
			return data; 
		} else {
			return null;
		}
	}
	
	/*********************************************  xls END *************************************************/
	/*********************************************  xls END *************************************************/
	/*********************************************  xls END *************************************************/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
