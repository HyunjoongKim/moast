package com.bsite.cmm;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;


import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/*

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
*/
/**
 * 엑셀파일을 파싱
 *  *
 */
public class ExcelManagerXlsx {
	
	private static ExcelManagerXlsx excelXlsxMng;
	
	public ExcelManagerXlsx() {
		// TODO Auto-generated constructor stub
	}
	
	public static ExcelManagerXlsx getInstance() {
		if (excelXlsxMng == null)
			excelXlsxMng = new ExcelManagerXlsx();
		return excelXlsxMng;
	}
	
	/**
	 * 엑셀파일 파싱후 HashMap리스트를 반환
	 * 
	 * @param file
	 * @return
	 * @throws Exception
	 */
	 Logger LOG = LoggerFactory.getLogger("com");
	
	
	
	public List<HashMap<String, String>> getListXlsxRead(String excel) throws Exception {
		Map <String,Object>  rMap = new  HashMap<String, Object>();
		List<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		System.out.println("excel : "+excel);
		 File file = new File( excel );
         if( !file.exists() || !file.isFile() || !file.canRead() ) {
             throw new IOException( excel );
         }
         XSSFWorkbook wb = new XSSFWorkbook( new FileInputStream(file) );
         
         
         DecimalFormat df = new DecimalFormat();
         //System.out.println("xlsx Start ----------------------------------- :"+excel);
         try {
             //for( int i=0; i<wb.getNumberOfSheets(); i++ ) { //시트갯수만큼
        	 for( int i=0; i<1; i++ ) {  //0번째 시트 하나만
                 for( Row row : wb.getSheetAt(i) ) {
                	 //System.out.println("wb.getSheetAt(i)----------------------------------- :"+wb.getSheetAt(i));
                	 //int cellPos = 0;
                	 HashMap<String, String> hMap = new HashMap<String, String>();
                	 String valueStr = ""; 
                	 int cellLength = (int) row.getLastCellNum(); // 열의 총 개수
                	 for(int j=0; j<cellLength; j++){
         				Cell cell = row.getCell(j);
                	 
                	 
	         			  if (cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK) { // CELL_TYPE_BLANK로만 체크할 경우 비어있는  셀을 놓칠 수 있다.
	     					//System.out.println(j + "번, 빈값 들어감.");
	     					valueStr = "";
	     				  }else{
	     					switch(cell.getCellType()){
	     						case Cell.CELL_TYPE_STRING :
	     							valueStr = cell.getStringCellValue();
	     							break;
	     						case Cell.CELL_TYPE_NUMERIC : // 날짜 형식이든 숫자 형식이든 다 CELL_TYPE_NUMERIC으로 인식함.
	     							if(DateUtil.isCellDateFormatted(cell)){ // 날짜 유형의 데이터일 경우,
	     								SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
	     								String formattedStr = dateFormat.format(cell.getDateCellValue());
	     								valueStr = formattedStr;
	     								break;
	     							}else{ // 순수하게 숫자 데이터일 경우,
	     								Double numericCellValue = cell.getNumericCellValue();
	     								if(Math.floor(numericCellValue) == numericCellValue){ // 소수점 이하를 버린 값이 원래의 값과 같다면,,
	     									valueStr = numericCellValue.intValue() + ""; // int형으로 소수점 이하 버리고 String으로 데이터 담는다.
	     								}else{
	     									valueStr = numericCellValue + "";
	     								}
	     								break;
	     							}
	     						case Cell.CELL_TYPE_BOOLEAN :
	     							valueStr = cell.getBooleanCellValue() + "";
	     							break;
	     					}
	                	 
	     				  }
                	 
         			 hMap.put("cell_"+j ,valueStr);
                     
                     //System.out.println("cell_"+j + "=> "+valueStr  ); 
                     //cellPos++;
                	 
                	 
                     /*for( Cell cell : row ) {
                    	 String data = null;
                         switch( cell.getCellType() ) {
                             case XSSFCell.CELL_TYPE_STRING:
                            	 data = cell.getRichStringCellValue().getString();
                                 break;
                             case XSSFCell.CELL_TYPE_NUMERIC:
                                 if( HSSFDateUtil.isCellDateFormatted(cell) ) {
                                	 SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                                	 data = formatter.format(cell.getDateCellValue());
                                 }
                                 else {
                                	 double ddata = Double.valueOf( cell.getNumericCellValue() ).intValue();
                                	 data = df.format(ddata);
                                 }
                                 break;
                             case XSSFCell.CELL_TYPE_FORMULA:
                            	 data = cell.getCellFormula();  break;
                             case XSSFCell.CELL_TYPE_BOOLEAN:
                            	boolean bdata = cell.getBooleanCellValue();  
             					data = String.valueOf(bdata);
                            	 break;
                             case XSSFCell.CELL_TYPE_ERROR:
                            	 //data = cell.getErrorCellValue();
                            	 data = "";
                            	 break;
                             case XSSFCell.CELL_TYPE_BLANK: 
                            	 data = "";
                            	 break;
                             default:
                            	 data = cell.toString();
                            	 break;
                         }*/
                         
                         //System.out.println("xlsxData----------------------------------- :"+cellPos+"-----"+data);
                         
                     }
                    list.add(hMap);
                 }
                 
             }
         } catch( Exception ex ) {
             ex.printStackTrace();
         }
         
        
        
		return list;
	}
	
	
	
	
	
	
	
	public Map <String,Object> getListXlsxReadMultiInfo(String excel) throws Exception {
		Map <String,Object>  rMap = new  HashMap<String, Object>();
		List<LinkedHashMap<String, String>> list = new ArrayList<LinkedHashMap<String,String>>();
		 File file = new File( excel );
         if( !file.exists() || !file.isFile() || !file.canRead() ) {
             throw new IOException( excel );
         }
         XSSFWorkbook wb = new XSSFWorkbook( new FileInputStream(file) );
         
         int rCell = 0;
         int RmaxRow = 0;
         DecimalFormat df = new DecimalFormat();
         //System.out.println("xlsx Start ----------------------------------- :"+excel);
         try {
             //for( int i=0; i<wb.getNumberOfSheets(); i++ ) { //시트갯수만큼
        	 for( int i=0; i<1; i++ ) {  //0번째 시트 하나만
        		 int maxRow = wb.getSheetAt(i).getLastRowNum();
        		 RmaxRow = maxRow;
        		 if(maxRow > 10) maxRow=10; 
        		 for(int xx=0; xx<maxRow;xx++){ //10개만 맛뵈기로 부르기위하여
                 //for( Row row : wb.getSheetAt(i) ) {        			 
        			 Row row = wb.getSheetAt(i).getRow(xx);
                	 //System.out.println("wb.getSheetAt(i)----------------------------------- :"+wb.getSheetAt(i));
                	 //int cellPos = 0;
                	 LinkedHashMap<String, String> hMap = new LinkedHashMap<String, String>();
                	 String valueStr = ""; 
                	 int cellLength = (int) row.getLastCellNum(); // 열의 총 개수
                	 if(rCell < cellLength) rCell = cellLength;
                	 for(int j=0; j<cellLength; j++){
         				Cell cell = row.getCell(j);
                	 
                	 
	         			  if (cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK) { // CELL_TYPE_BLANK로만 체크할 경우 비어있는  셀을 놓칠 수 있다.
	     					//System.out.println(j + "번, 빈값 들어감.");
	     					valueStr = "";
	     				  }else{
	     					switch(cell.getCellType()){
	     						case Cell.CELL_TYPE_STRING :
	     							valueStr = cell.getStringCellValue();
	     							break;
	     						case XSSFCell.CELL_TYPE_FORMULA:
	     							valueStr = cell.getCellFormula();  
	     							break;
	     						case Cell.CELL_TYPE_NUMERIC : // 날짜 형식이든 숫자 형식이든 다 CELL_TYPE_NUMERIC으로 인식함.
	     							if(HSSFDateUtil.isCellDateFormatted(cell)){ // 날짜 유형의 데이터일 경우,
	     								SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
	     								String formattedStr = dateFormat.format(cell.getDateCellValue());
	     								valueStr = formattedStr;
	     								break;
	     							}else{ // 순수하게 숫자 데이터일 경우,
	     								Double numericCellValue = cell.getNumericCellValue();
	     								if(Math.floor(numericCellValue) == numericCellValue){ // 소수점 이하를 버린 값이 원래의 값과 같다면,,
	     									valueStr = numericCellValue.intValue() + ""; // int형으로 소수점 이하 버리고 String으로 데이터 담는다.
	     								}else{
	     									valueStr = numericCellValue + "";
	     								}
	     								break;
	     							}
	     						case Cell.CELL_TYPE_BOOLEAN :
	     							valueStr = cell.getBooleanCellValue() + "";
	     							break;
	     					}
	                	 
	     				  }
                	 
         			 hMap.put("cell_"+j ,valueStr);
                     
                     //System.out.println("cell_"+j + "=> "+valueStr  ); 
                     //cellPos++;
                	 
                	 
                     /*for( Cell cell : row ) {
                    	 String data = null;
                         switch( cell.getCellType() ) {
                             case XSSFCell.CELL_TYPE_STRING:
                            	 data = cell.getRichStringCellValue().getString();
                                 break;
                             case XSSFCell.CELL_TYPE_NUMERIC:
                                 if( HSSFDateUtil.isCellDateFormatted(cell) ) {
                                	 SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                                	 data = formatter.format(cell.getDateCellValue());
                                 }
                                 else {
                                	 double ddata = Double.valueOf( cell.getNumericCellValue() ).intValue();
                                	 data = df.format(ddata);
                                 }
                                 break;
                             case XSSFCell.CELL_TYPE_FORMULA:
                            	 data = cell.getCellFormula();  break;
                             case XSSFCell.CELL_TYPE_BOOLEAN:
                            	boolean bdata = cell.getBooleanCellValue();  
             					data = String.valueOf(bdata);
                            	 break;
                             case XSSFCell.CELL_TYPE_ERROR:
                            	 //data = cell.getErrorCellValue();
                            	 data = "";
                            	 break;
                             case XSSFCell.CELL_TYPE_BLANK: 
                            	 data = "";
                            	 break;
                             default:
                            	 data = cell.toString();
                            	 break;
                         }*/
                         
                         //System.out.println("xlsxData----------------------------------- :"+cellPos+"-----"+data);
                         
                     }
                    list.add(hMap);
                 }
                 
             }
         } catch( Exception ex ) {
             ex.printStackTrace();
         }
         
        rMap.put("list", list);
        rMap.put("cellSize", rCell);
        rMap.put("rowSize", RmaxRow);
		return rMap;
	}
	
	
	
	
	
	public List<HashMap<String, String>> getListXlsxRead2(String excel) throws Exception {
		 
		
		
		
		List<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		HashMap<String, String> hMap = new HashMap<String, String>();
		DecimalFormat df = new DecimalFormat();
		 System.out.println("-----------------------1111111111111-----------------------");
		 try{
		XSSFWorkbook work = new XSSFWorkbook(new FileInputStream(new File(excel)));
		int sheetNum = work.getNumberOfSheets();
		if(sheetNum < 1) return null;
		 System.out.println("-----------------------2222222222222-----------------------");
		
		for( int loop = 0; loop < sheetNum; loop++){
			  XSSFSheet sheet = work.getSheetAt(loop);
			  int rows = sheet.getPhysicalNumberOfRows();
			  //log.error("\n# sheet rows num : " + rows);
			  
			  for( int rownum = 0; rownum < rows; rownum++){
				    XSSFRow row = sheet.getRow(rownum);
				    if(row != null){
				    	int cells = row.getPhysicalNumberOfCells();
				    	//log.error("\n# row = " + row.getRowNum() + " / cells = " + cells);
				    	 for(int cellnum =0; cellnum < cells; cellnum++){
				    		 
				    		 XSSFCell cell = row.getCell(cellnum);
				    	       
				    	        if(cell != null){
				    	         String data = null;
				    	         
				    	         
				    	          switch (cell.getCellType()) {
				    	         
				    	          case XSSFCell.CELL_TYPE_STRING:
		                            	 data = cell.getRichStringCellValue().getString();
		                                 break;
		                             case XSSFCell.CELL_TYPE_NUMERIC:
		                                 if( HSSFDateUtil.isCellDateFormatted(cell) ) {
		                                	 SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		                                	 data = formatter.format(cell.getDateCellValue());
		                                 }
		                                 else {
		                                	 double ddata = Double.valueOf( cell.getNumericCellValue() ).intValue();
		                                	 data = df.format(ddata);
		                                 }
		                                 break;
		                             case XSSFCell.CELL_TYPE_FORMULA:
		                            	 data = cell.getCellFormula();  break;
		                             case XSSFCell.CELL_TYPE_BOOLEAN:
		                            	boolean bdata = cell.getBooleanCellValue();  
		             					data = String.valueOf(bdata);
		                            	 break;
		                             case XSSFCell.CELL_TYPE_ERROR:
		                            	 //data = cell.getErrorCellValue();  
		                            	 break;
		                             case XSSFCell.CELL_TYPE_BLANK: break;
		                             default: break;
				    	          }
				    		 
				    	     hMap.put("cell_"+cellnum , data);
				    	 
				    	 }
				    }
			  }
			  
		}
		}
		
		
	 }catch(Exception e){
		 System.out.println("xlsx Exception------------------:"+e);
	 }
		 
		 
		 
		 
		if(hMap != null){
			list.add(hMap);
		}
		return list;
	}
	

	
	
}
