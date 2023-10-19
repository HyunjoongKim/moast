package com.bsite.cmm;

import java.io.IOException;
import java.io.Writer;
import java.util.Calendar;

import org.apache.poi.hssf.util.CellReference;
import org.apache.poi.ss.usermodel.DateUtil;

public class SpreadSheetWriter {
	private final Writer _out;
	private int _rownum;
	
	private String _merge = null;

	public SpreadSheetWriter(Writer out) {

		_out = out;
	}

	public void beginSheet() throws IOException {
		_out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
				+ "<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
		_out.write("<sheetData>\n");
	}

	public void endSheet() throws IOException {
		_out.write("</sheetData>");
		if(_merge != null)
			_out.write(_merge);
		_out.write("</worksheet>");
	}

	/**
	 * Insert a new row
	 * 
	 * @param rownum
	 *            0-based row number
	 */
	public void insertRow(int rownum) throws IOException {
		_out.write("<row r=\"" + (rownum + 1) + "\">\n");
		this._rownum = rownum;
	}

	/**
	 * Insert row end marker
	 */
	public void endRow() throws IOException {
		_out.write("</row>\n");
	}

	public void createCell(int columnIndex, String value, int styleIndex)
			throws IOException {
		String ref = new CellReference(_rownum, columnIndex).formatAsString();
		ref = ref.replaceAll("\\$", "");
		if(value == null)
			value = "";
		_out.write("<c r=\"" + ref + "\" t=\"inlineStr\"");
		if (styleIndex != -1)
			_out.write(" s=\"" + styleIndex + "\"");
		_out.write(">");
		_out.write("<is><t><![CDATA[" + value + "]]></t></is>");
		_out.write("</c>");

	}

	public void createCell(int columnIndex, String value) throws IOException {
		createCell(columnIndex, value, -1);
	}

	public void createCell(int columnIndex, double value, int styleIndex)
			throws IOException {
		String ref = new CellReference(_rownum, columnIndex).formatAsString();
		ref = ref.replaceAll("\\$", "");
		_out.write("<c r=\"" + ref + "\" t=\"n\"");
		if (styleIndex != -1)
			_out.write(" s=\"" + styleIndex + "\"");
		_out.write(">");
		_out.write("<v><![CDATA[" + value + "]]></v>");
		_out.write("</c>");

	}

	public void createCell(int columnIndex, double value) throws IOException {
		createCell(columnIndex, value, -1);
	}

	public void createCell(int columnIndex, Calendar value, int styleIndex)
			throws IOException {
		createCell(columnIndex, DateUtil.getExcelDate(value, false), styleIndex);
	}
}
