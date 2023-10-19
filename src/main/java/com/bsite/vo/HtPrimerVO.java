package com.bsite.vo;

import java.io.Serializable;
import java.util.List;

import org.springframework.core.io.ByteArrayResource;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HtPrimerVO extends PageSearchVO implements Serializable {

	private String genome;
	private String genome_assembly;
	private String dbsnp_build;
	private String primer_type;
	private String restriction_enzyme;
	private String max_primer_to_return;
	private String target_regions;
	private String included_regions;
	private String min_product_size;
	private String opt_product_size;
	private String max_product_size;
	private String min_primer_tm;
	private String opt_primer_tm;
	private String max_primer_tm;
	private String min_primer_size;
	private String opt_primer_size;
	private String max_primer_size;
	private String cpg_product;
	private String cpg_in_primer;
	private String primer_non_cpg_c;
	private String primer_polyt;
	private String primer_polyx;
	private String min_hyb_size;
	private String opt_hyb_size;
	private String max_hyb_size;
	private String min_hyb_tm;
	private String opt_hyb_tm;
	private String max_hyb_tm;
	private String min_hyb_gc;
	private String opt_hyb_gc;
	private String max_hyb_gc;
	private String submit;
	
	private String target_file_string;
	private String pcr_primer3_param_file_string;
	private String restriction_enzyme_file_string;
	private String quality_matrix_file_string;
	
	private Object target_file;
	private Object pcr_primer3_param_file;// = new ByteArrayResource("".getBytes());
	private Object restriction_enzyme_file;// = new ByteArrayResource("".getBytes());
	private Object quality_matrix_file;// = new ByteArrayResource("".getBytes());
	private int std_idx;

}
