package com.bsite.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class CorrelationScatterVO extends SampleBaseVO implements Serializable {

	private static final long serialVersionUID = 215830991627307305L;

	private String probe_id;
	private Double beta_value;
	private String sample_id;
	

	private String gene_probe;
	private Double x;
	private Double y;
	private String gene_symbol;
	
	private String corr_esti;
	private String corr_pvalue;
	
	// search
	private String search_probe_id = "cg14817997";
	private String search_gene_symbol = "APC";

}

