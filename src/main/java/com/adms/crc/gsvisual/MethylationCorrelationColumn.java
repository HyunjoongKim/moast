package com.adms.crc.gsvisual;

import java.util.stream.Stream;

import lombok.Getter;

/* RealGrid Column */

@Getter

public enum MethylationCorrelationColumn {
	
	gene_symbol (true, 0, "field:'gene_symbol', title:'Exp', rowspan:2, width:90, sortable:true"), 
	probe_id (true, 0, "field:'probe_id', title:'Methyl', rowspan:2, width:100, sortable:true"),
	meth_id (false, 0, "field:'meth_id', title:'meth_id', width:100, sortable:true"),
	pearson (true, 0, "title:'Pearson Correlation', colspan:2"),
	spearman (true, 0, "title:'Spearman Correlation', colspan:2"),
	pearson_pvale (true, 1, "field:'pearson_pvale', title:'coefficient', width:110, sortable:true"),
	pearson_coeff (true, 1, "field:'pearson_coeff', title:'p_vale', width:110, sortable:true"),
	spearman_coeff (true, 1, "field:'spearman_coeff', title:'coefficient', width:110, sortable:true"),
	spearman_pvale (true, 1, "field:'spearman_pvale', title:'p_vale', width:110, sortable:true");

	
	private boolean display;
	private int row;
	private String column;
	
	MethylationCorrelationColumn(boolean display, int row, String column) {
		this.display = display;
		this.row = row;
		this.column = column;
		
	}
	
	public static Stream<MethylationCorrelationColumn> stream() {
        return Stream.of(MethylationCorrelationColumn.values()); 
    }
	
}
