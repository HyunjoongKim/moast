package com.bsite.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class CorrelationResultVO implements Serializable {

	private static final long serialVersionUID = -7296544323898345957L;
	private String gene_symbol;
	private String probe_id;
	private String pearson_coeff;
	private String pearson_pvale;
	private String spearman_coeff;
	private String spearman_pvale;
	

}
