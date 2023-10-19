package com.bsite.cmm;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelManagerXmlToExcel {
	

	@SuppressWarnings("unused")
	public Map<String, XSSFCellStyle> createStyles(XSSFWorkbook workbook){
		Map<String, XSSFCellStyle> styles = new HashMap<String, XSSFCellStyle>();
		XSSFFont font = workbook.createFont();
		XSSFDataFormat format = workbook.createDataFormat();
    	
    	XSSFCellStyle style = workbook.createCellStyle();
    	style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
    	style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
    	style.setBorderRight(HSSFCellStyle.BORDER_THIN);
    	style.setBorderTop(HSSFCellStyle.BORDER_THIN);
    	font.setFontName("Arial");
    	font.setFontHeightInPoints((short)10);
    	style.setFont(font);
    	styles.put("normal", style);
    	
    	XSSFCellStyle styleFloatDot3 = workbook.createCellStyle();
    	styleFloatDot3.setBorderBottom(HSSFCellStyle.BORDER_THIN);
    	styleFloatDot3.setBorderLeft(HSSFCellStyle.BORDER_THIN);
    	styleFloatDot3.setBorderRight(HSSFCellStyle.BORDER_THIN);
    	styleFloatDot3.setBorderTop(HSSFCellStyle.BORDER_THIN);
    	font.setFontName("Arial");
    	font.setFontHeightInPoints((short)10);
    	styleFloatDot3.setFont(font);
    	styleFloatDot3.setDataFormat(format.getFormat("###0.000"));
    	styles.put("floatdot3", styleFloatDot3);
    	
    	XSSFCellStyle styleFloatDot5 = workbook.createCellStyle();
    	styleFloatDot5.setBorderBottom(HSSFCellStyle.BORDER_THIN);
    	styleFloatDot5.setBorderLeft(HSSFCellStyle.BORDER_THIN);
    	styleFloatDot5.setBorderRight(HSSFCellStyle.BORDER_THIN);
    	styleFloatDot5.setBorderTop(HSSFCellStyle.BORDER_THIN);
    	font.setFontName("Arial");
    	font.setFontHeightInPoints((short)10);
    	styleFloatDot5.setFont(font);
    	styleFloatDot5.setDataFormat(format.getFormat("###0.00000"));
    	styles.put("floatdot5", styleFloatDot5);
    	
    	return styles;
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	public void substitute(File zipfile, Map sheetMap, OutputStream out) throws IOException {	
		ZipFile zip = new ZipFile(zipfile);

		ZipOutputStream zos = new ZipOutputStream(out);
		@SuppressWarnings("unchecked")
		Enumeration<ZipEntry> en = (Enumeration<ZipEntry>) zip.entries();
		while (en.hasMoreElements()) {
			ZipEntry ze = en.nextElement();
			if (!sheetMap.containsKey(ze.getName())) {
				zos.putNextEntry(new ZipEntry(ze.getName()));
				InputStream is = zip.getInputStream(ze);
				copyStream(is, zos);
				is.close();
			}
		}

		Iterator it = sheetMap.keySet().iterator();
		while (it.hasNext()) {
			String entry = (String) it.next();
			zos.putNextEntry(new ZipEntry(entry));
			InputStream is = new FileInputStream((File) sheetMap.get(entry));
			copyStream(is, zos);
			is.close();
		}
		zos.close();
	}
	
	public void copyStream(InputStream in, OutputStream out) throws IOException {
	   byte[] chunk = new byte[1024];
       int count;
       while ((count = in.read(chunk)) >=0 ) {
         out.write(chunk,0,count);
       }
    }

}
