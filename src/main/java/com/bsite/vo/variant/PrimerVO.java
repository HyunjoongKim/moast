package com.bsite.vo.variant;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PrimerVO implements Serializable {
//	http://mutation-marker-example-5000.themoagen.com/cgi-bin/batchprimer3/batchprimer3_results.cgi/
	@JsonProperty("SEQUENCE")
	private String SEQUENCE;
	@JsonProperty("SEQUENCEFILE")
	private String SEQUENCEFILE;
	@JsonProperty("PRIMER_TYPE")
	private String PRIMER_TYPE;
	@JsonProperty("Pick Primers")
	private String Pick_Primers;
	@JsonProperty("MUST_XLATE_PICK_LEFT")
	private String MUST_XLATE_PICK_LEFT;
	@JsonProperty("PRIMER_LEFT_INPUT")
	private String PRIMER_LEFT_INPUT;
	@JsonProperty("MUST_XLATE_PICK_RIGHT")
	private String MUST_XLATE_PICK_RIGHT;
	@JsonProperty("PRIMER_RIGHT_INPUT")
	private String PRIMER_RIGHT_INPUT;
	@JsonProperty("PRIMER_MISPRIMING_LIBRARY")
	private String PRIMER_MISPRIMING_LIBRARY;
	@JsonProperty("SECOND_MISMATCH_POS")
	private String SECOND_MISMATCH_POS;
	@JsonProperty("SNP_PRIMER_MIN_SIZE")
	private String SNP_PRIMER_MIN_SIZE;
	@JsonProperty("SNP_PRIMER_OPT_SIZE")
	private String SNP_PRIMER_OPT_SIZE;
	@JsonProperty("SNP_PRIMER_MAX_SIZE")
	private String SNP_PRIMER_MAX_SIZE;
	@JsonProperty("SNP_PRIMER_MIN_TM")
	private String SNP_PRIMER_MIN_TM;
	@JsonProperty("SNP_PRIMER_OPT_TM")
	private String SNP_PRIMER_OPT_TM;
	@JsonProperty("SNP_PRIMER_MAX_TM")
	private String SNP_PRIMER_MAX_TM;
	@JsonProperty("SNP_PRIMER_MIN_GC")
	private String SNP_PRIMER_MIN_GC;
	@JsonProperty("SNP_PRIMER_MAX_GC")
	private String SNP_PRIMER_MAX_GC;
	@JsonProperty("SNP_PRIMER_MAX_N")
	private String SNP_PRIMER_MAX_N;
	@JsonProperty("SNP_PRIMER_SALT_CONC")
	private String SNP_PRIMER_SALT_CONC;
	@JsonProperty("SNP_PRIMER_DNA_CONC")
	private String SNP_PRIMER_DNA_CONC;
	@JsonProperty("SNP_MAX_SELF_COMPLEMENTARITY")
	private String SNP_MAX_SELF_COMPLEMENTARITY;
	@JsonProperty("SNP_MAX_3_SELF_COMPLEMENTARITY")
	private String SNP_MAX_3_SELF_COMPLEMENTARITY;
	@JsonProperty("MUST_XLATE_PRODUCT_MIN_SIZE")
	private String MUST_XLATE_PRODUCT_MIN_SIZE;
	@JsonProperty("PRIMER_PRODUCT_OPT_SIZE")
	private String PRIMER_PRODUCT_OPT_SIZE;
	@JsonProperty("MUST_XLATE_PRODUCT_MAX_SIZE")
	private String MUST_XLATE_PRODUCT_MAX_SIZE;
	@JsonProperty("PRIMER_NUM_RETURN")
	private String PRIMER_NUM_RETURN;
	@JsonProperty("PRIMER_MAX_END_STABILITY")
	private String PRIMER_MAX_END_STABILITY;
	@JsonProperty("PRIMER_MAX_MISPRIMING")
	private String PRIMER_MAX_MISPRIMING;
	@JsonProperty("PRIMER_PAIR_MAX_MISPRIMING")
	private String PRIMER_PAIR_MAX_MISPRIMING;
	@JsonProperty("PRIMER_MIN_SIZE")
	private String PRIMER_MIN_SIZE;
	@JsonProperty("PRIMER_OPT_SIZE")
	private String PRIMER_OPT_SIZE;
	@JsonProperty("PRIMER_MAX_SIZE")
	private String PRIMER_MAX_SIZE;
	@JsonProperty("PRIMER_MIN_TM")
	private String PRIMER_MIN_TM;
	@JsonProperty("PRIMER_OPT_TM")
	private String PRIMER_OPT_TM;
	@JsonProperty("PRIMER_MAX_TM")
	private String PRIMER_MAX_TM;
	@JsonProperty("PRIMER_MAX_DIFF_TM")
	private String PRIMER_MAX_DIFF_TM;
	@JsonProperty("PRIMER_PRODUCT_MIN_TM")
	private String PRIMER_PRODUCT_MIN_TM;
	@JsonProperty("PRIMER_PRODUCT_OPT_TM")
	private String PRIMER_PRODUCT_OPT_TM;
	@JsonProperty("PRIMER_PRODUCT_MAX_TM")
	private String PRIMER_PRODUCT_MAX_TM;
	@JsonProperty("PRIMER_MIN_GC")
	private String PRIMER_MIN_GC;
	@JsonProperty("PRIMER_OPT_GC_PERCENT")
	private String PRIMER_OPT_GC_PERCENT;
	@JsonProperty("PRIMER_MAX_GC")
	private String PRIMER_MAX_GC;
	@JsonProperty("PRIMER_SELF_ANY")
	private String PRIMER_SELF_ANY;
	@JsonProperty("PRIMER_SELF_END")
	private String PRIMER_SELF_END;
	@JsonProperty("PRIMER_NUM_NS_ACCEPTED")
	private String PRIMER_NUM_NS_ACCEPTED;
	@JsonProperty("PRIMER_MAX_POLY_X")
	private String PRIMER_MAX_POLY_X;
	@JsonProperty("PRIMER_INSIDE_PENALTY")
	private String PRIMER_INSIDE_PENALTY;
	@JsonProperty("PRIMER_OUTSIDE_PENALTY")
	private String PRIMER_OUTSIDE_PENALTY;
	@JsonProperty("PRIMER_GC_CLAMP")
	private String PRIMER_GC_CLAMP;
	@JsonProperty("PRIMER_SALT_CONC")
	private String PRIMER_SALT_CONC;
	@JsonProperty("PRIMER_DNA_CONC")
	private String PRIMER_DNA_CONC;
	@JsonProperty("PRIMER_WT_TM_LT")
	private String PRIMER_WT_TM_LT;
	@JsonProperty("PRIMER_WT_TM_GT")
	private String PRIMER_WT_TM_GT;
	@JsonProperty("PRIMER_WT_SIZE_LT")
	private String PRIMER_WT_SIZE_LT;
	@JsonProperty("PRIMER_WT_SIZE_GT")
	private String PRIMER_WT_SIZE_GT;
	@JsonProperty("PRIMER_WT_GC_PERCENT_LT")
	private String PRIMER_WT_GC_PERCENT_LT;
	@JsonProperty("PRIMER_WT_GC_PERCENT_GT")
	private String PRIMER_WT_GC_PERCENT_GT;
	@JsonProperty("PRIMER_WT_COMPL_ANY")
	private String PRIMER_WT_COMPL_ANY;
	@JsonProperty("PRIMER_WT_COMPL_END")
	private String PRIMER_WT_COMPL_END;
	@JsonProperty("PRIMER_WT_NUM_NS")
	private String PRIMER_WT_NUM_NS;
	@JsonProperty("PRIMER_WT_REP_SIM")
	private String PRIMER_WT_REP_SIM;
	@JsonProperty("PRIMER_WT_SEQ_QUAL")
	private String PRIMER_WT_SEQ_QUAL;
	@JsonProperty("PRIMER_WT_END_QUAL")
	private String PRIMER_WT_END_QUAL;
	@JsonProperty("PRIMER_WT_POS_PENALTY")
	private String PRIMER_WT_POS_PENALTY;
	@JsonProperty("PRIMER_WT_END_STABILITY")
	private String PRIMER_WT_END_STABILITY;
	@JsonProperty("PRIMER_PAIR_WT_PRODUCT_SIZE_LT")
	private String PRIMER_PAIR_WT_PRODUCT_SIZE_LT;
	@JsonProperty("PRIMER_PAIR_WT_PRODUCT_SIZE_GT")
	private String PRIMER_PAIR_WT_PRODUCT_SIZE_GT;
	@JsonProperty("PRIMER_PAIR_WT_PRODUCT_TM_LT")
	private String PRIMER_PAIR_WT_PRODUCT_TM_LT;
	@JsonProperty("PRIMER_PAIR_WT_PRODUCT_TM_GT")
	private String PRIMER_PAIR_WT_PRODUCT_TM_GT;
	@JsonProperty("PRIMER_PAIR_WT_DIFF_TM")
	private String PRIMER_PAIR_WT_DIFF_TM;
	@JsonProperty("PRIMER_PAIR_WT_COMPL_ANY")
	private String PRIMER_PAIR_WT_COMPL_ANY;
	@JsonProperty("PRIMER_PAIR_WT_COMPL_END")
	private String PRIMER_PAIR_WT_COMPL_END;
	@JsonProperty("PRIMER_PAIR_WT_REP_SIM")
	private String PRIMER_PAIR_WT_REP_SIM;
	@JsonProperty("PRIMER_PAIR_WT_PR_PENALTY")
	private String PRIMER_PAIR_WT_PR_PENALTY;
	@JsonProperty("PRIMER_PAIR_WT_IO_PENALTY")
	private String PRIMER_PAIR_WT_IO_PENALTY;

}