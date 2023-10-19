package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class mo_mutationVO implements Serializable {
	private static final long serialVersionUID = 32798782607306373L;

	private int mi_idx;

	private int ud_id;
	private String m_type;
	private String sample_id;

	private String hugo_symbol;
	private String entrez_gene_id;
	private String ncbi_build;
	private String chromosome;
	private String start_position;
	private String end_position;
	private String strand;
	private String variant_classification;
	private String variant_type;
	private String reference_allele;
	private String tumor_seq_allele1;
	private String tumor_seq_allele2;
	private String dbsnp_rs;
	private String tumor_sample_barcode;
	private String matched_norm_sample_barcode;
	private String hgvsc;
	private String transcript_id;

	public String getDisplayString() {
		if (m_type!=null && m_type.equals("SNV")) {
			return variant_classification + ";" + chromosome + "_" + start_position + ":" + end_position + ";" + reference_allele + ">" + tumor_seq_allele2;
		} else {
			return variant_type + ";" + chromosome + "_" + start_position + ":" + end_position + ";" + reference_allele + ">" + strand;
		}
	}
}
