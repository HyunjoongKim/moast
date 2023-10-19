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

public class rna_seqVO implements Serializable {

	private static final long serialVersionUID = -7448765770570673727L;
	private String gene_symbol;
	private Double read_count;
	private String sample_id;

	public rna_seqVO(String gene_symbol, Double read_count, String sample_id) {
		this.gene_symbol = gene_symbol;
		this.read_count = read_count;
		this.sample_id = sample_id;
	}
	
}
