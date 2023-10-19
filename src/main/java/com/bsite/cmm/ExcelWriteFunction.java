package com.bsite.cmm;

import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class ExcelWriteFunction {
	
	
	
	
	public String makeXlsFile(String oriFileName ,ArrayList<Map<String,Object>> list) 
			throws Exception {
		
		String returnUrl = null;
		//임의의 VO가 되주는 MAP 객체
		Map<String,Object>map=null;
		ArrayList<String> columnList=new ArrayList<String>();
	
		/* 밖에서 이것까지 매칭해와야 하는 값
		 * for(int i=0;i<10;i++){
		    map=new LinkedHashMap<String,Object>();
		    map.put("제목", i+1);    
		    map.put("타이틀", "제목이다"+i);    	    	    
		    map.put("컨텐트", "내용입니다"+i);
		    list.add(map);
		}*/
		
		try{
			//MAP의 KEY값을 담기위함 
			if(list !=null &&list.size() >0){
			    //LIST의 첫번째 데이터의 KEY값만 알면 되므로 
			    Map<String,Object> m=list.get(0);
			    //MAP의 KEY값을 columnList객체에 ADD 
			    for(String k : m.keySet()){
			    	System.out.println(" k : " +k + "m.keySet() :"+m.keySet() );
			        columnList.add(k);
			    }
			}
			
			
			//1차로 workbook을 생성 
			HSSFWorkbook workbook=new HSSFWorkbook();
			//2차는 sheet생성 
			HSSFSheet sheet=workbook.createSheet("sheet1");
			//workbook.setSheetNmae(0,"한글",HSSFWorkbook.ENCODING_UTF_16);
			//엑셀의 행 
			HSSFRow row=null;
			//엑셀의 셀 
			HSSFCell cell=null;
			
			if(list !=null &&list.size() >0){
			    int i=0;
			    for(Map<String,Object> mapobject : list){
		
			    	if(i==0){
			    		row=sheet.createRow((short)i); 
			    		if(columnList !=null &&columnList.size() >0){
		    	            for(int j=0;j<columnList.size();j++){
		    	                cell=row.createCell(j);
		    	                cell.setCellValue(columnList.get(j));
		    	            }
		    	        }
			    		 i++;
			    	}else{
		    	        row=sheet.createRow((short)i); 	    	       	
		    	        if(columnList !=null &&columnList.size() >0){
		    	            for(int j=0;j<columnList.size();j++){
		    	                cell=row.createCell(j);
		    	                cell.setCellValue(String.valueOf(mapobject.get(columnList.get(j))));
		    	            }
		    	            i++;
		    	        }
		    	        
			    	}
			        
			    }
			}
			
			String downUrl = "/home/wsmes/upload/download/excel";
			String downRFile = oriFileName;
			FileOutputStream fileoutputstream=new FileOutputStream(downUrl+downRFile);
			//파일을 쓴다
			workbook.write(fileoutputstream);
			//필수로 닫아주어야함 
			fileoutputstream.close();
			System.out.println("엑셀파일생성성공 : "+downUrl+"/"+downRFile);
			returnUrl = downUrl+downRFile;
		
		}catch(Exception e){
			System.out.println("Excel xls 만들기 실패 : "+e.toString());
		}
	
		return returnUrl;
    
}
















}//end main function
