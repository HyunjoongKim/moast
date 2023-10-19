package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class mo_methVO implements Serializable {
	private static final long serialVersionUID = -9141467632865778788L;
	
	private int ud_id;
	private String probe_id;
	private String sample_id;
	private Double beta_value;
	
	

	private String gene_probe;
	private Double x;
	private Double y;
	private String gene_symbol;
	
	private String corr_esti;
	private String corr_pvalue;
	
	private String search_probe_id = "cg14817997";
	private String search_gene_symbol = "APC";

}
