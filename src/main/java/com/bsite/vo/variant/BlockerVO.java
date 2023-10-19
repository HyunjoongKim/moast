package com.bsite.vo.variant;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BlockerVO implements Serializable {
	// http://mutation-marker-example-5000.themoagen.com/cgi-bin/primer3-0.4.0/primer3_results.cgi/
	@JsonProperty("SEQUENCE")
	private String SEQUENCE;
	@JsonProperty("PRIMER_MISPRIMING_LIBRARY")
	private String PRIMER_MISPRIMING_LIBRARY;
	@JsonProperty("MUST_XLATE_PICK_LEFT")
	private String MUST_XLATE_PICK_LEFT;
	@JsonProperty("MUST_XLATE_PICK_RIGHT")
	private String MUST_XLATE_PICK_RIGHT;
	@JsonProperty("PRIMER_LEFT_INPUT")
	private String PRIMER_LEFT_INPUT;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_INPUT")
	private String PRIMER_INTERNAL_OLIGO_INPUT;
	@JsonProperty("PRIMER_RIGHT_INPUT")
	private String PRIMER_RIGHT_INPUT;
	@JsonProperty("Pick Primers")
	private String Pick_Primers;
	@JsonProperty("PRIMER_SEQUENCE_ID")
	private String PRIMER_SEQUENCE_ID;
	@JsonProperty("TARGET")
	private String TARGET;
	@JsonProperty("EXCLUDED_REGION")
	private String EXCLUDED_REGION;
	@JsonProperty("PRIMER_PRODUCT_SIZE_RANGE")
	private String PRIMER_PRODUCT_SIZE_RANGE;
	@JsonProperty("PRIMER_NUM_RETURN")
	private String PRIMER_NUM_RETURN;
	@JsonProperty("PRIMER_MAX_END_STABILITY")
	private String PRIMER_MAX_END_STABILITY;
	@JsonProperty("PRIMER_MAX_MISPRIMING")
	private String PRIMER_MAX_MISPRIMING;
	@JsonProperty("PRIMER_PAIR_MAX_MISPRIMING")
	private String PRIMER_PAIR_MAX_MISPRIMING;
	@JsonProperty("PRIMER_MAX_TEMPLATE_MISPRIMING")
	private String PRIMER_MAX_TEMPLATE_MISPRIMING;
	@JsonProperty("PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING")
	private String PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING;
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
	@JsonProperty("PRIMER_TM_SANTALUCIA")
	private String PRIMER_TM_SANTALUCIA;
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
	@JsonProperty("PRIMER_FIRST_BASE_INDEX")
	private String PRIMER_FIRST_BASE_INDEX;
	@JsonProperty("PRIMER_GC_CLAMP")
	private String PRIMER_GC_CLAMP;
	@JsonProperty("PRIMER_SALT_CONC")
	private String PRIMER_SALT_CONC;
	@JsonProperty("PRIMER_SALT_CORRECTIONS")
	private String PRIMER_SALT_CORRECTIONS;
	@JsonProperty("PRIMER_DIVALENT_CONC")
	private String PRIMER_DIVALENT_CONC;
	@JsonProperty("PRIMER_DNTP_CONC")
	private String PRIMER_DNTP_CONC;
	@JsonProperty("PRIMER_DNA_CONC")
	private String PRIMER_DNA_CONC;
	@JsonProperty("PRIMER_LIBERAL_BASE")
	private String PRIMER_LIBERAL_BASE;
	@JsonProperty("PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS")
	private String PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS;
	@JsonProperty("INCLUDED_REGION")
	private String INCLUDED_REGION;
	@JsonProperty("PRIMER_START_CODON_POSITION")
	private String PRIMER_START_CODON_POSITION;
	@JsonProperty("PRIMER_SEQUENCE_QUALITY")
	private String PRIMER_SEQUENCE_QUALITY;
	@JsonProperty("PRIMER_MIN_QUALITY")
	private String PRIMER_MIN_QUALITY;
	@JsonProperty("PRIMER_MIN_END_QUALITY")
	private String PRIMER_MIN_END_QUALITY;
	@JsonProperty("PRIMER_QUALITY_RANGE_MIN")
	private String PRIMER_QUALITY_RANGE_MIN;
	@JsonProperty("PRIMER_QUALITY_RANGE_MAX")
	private String PRIMER_QUALITY_RANGE_MAX;
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
	@JsonProperty("PRIMER_WT_TEMPLATE_MISPRIMING")
	private String PRIMER_WT_TEMPLATE_MISPRIMING;
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
	@JsonProperty("PRIMER_PAIR_WT_TEMPLATE_MISPRIMING")
	private String PRIMER_PAIR_WT_TEMPLATE_MISPRIMING;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_EXCLUDED_REGION")
	private String PRIMER_INTERNAL_OLIGO_EXCLUDED_REGION;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MIN_SIZE")
	private String PRIMER_INTERNAL_OLIGO_MIN_SIZE;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_OPT_SIZE")
	private String PRIMER_INTERNAL_OLIGO_OPT_SIZE;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MAX_SIZE")
	private String PRIMER_INTERNAL_OLIGO_MAX_SIZE;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MIN_TM")
	private String PRIMER_INTERNAL_OLIGO_MIN_TM;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_OPT_TM")
	private String PRIMER_INTERNAL_OLIGO_OPT_TM;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MAX_TM")
	private String PRIMER_INTERNAL_OLIGO_MAX_TM;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MIN_GC")
	private String PRIMER_INTERNAL_OLIGO_MIN_GC;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_OPT_GC_PERCENT")
	private String PRIMER_INTERNAL_OLIGO_OPT_GC_PERCENT;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MAX_GC")
	private String PRIMER_INTERNAL_OLIGO_MAX_GC;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_SELF_ANY")
	private String PRIMER_INTERNAL_OLIGO_SELF_ANY;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_SELF_END")
	private String PRIMER_INTERNAL_OLIGO_SELF_END;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_NUM_NS")
	private String PRIMER_INTERNAL_OLIGO_NUM_NS;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MAX_POLY_X")
	private String PRIMER_INTERNAL_OLIGO_MAX_POLY_X;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MISHYB_LIBRARY")
	private String PRIMER_INTERNAL_OLIGO_MISHYB_LIBRARY;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MAX_MISHYB")
	private String PRIMER_INTERNAL_OLIGO_MAX_MISHYB;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_MIN_QUALITY")
	private String PRIMER_INTERNAL_OLIGO_MIN_QUALITY;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_SALT_CONC")
	private String PRIMER_INTERNAL_OLIGO_SALT_CONC;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_DNA_CONC")
	private String PRIMER_INTERNAL_OLIGO_DNA_CONC;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_DIVALENT_CONC")
	private String PRIMER_INTERNAL_OLIGO_DIVALENT_CONC;
	@JsonProperty("PRIMER_INTERNAL_OLIGO_DNTP_CONC")
	private String PRIMER_INTERNAL_OLIGO_DNTP_CONC;
	@JsonProperty("PRIMER_IO_WT_TM_LT")
	private String PRIMER_IO_WT_TM_LT;
	@JsonProperty("PRIMER_IO_WT_TM_GT")
	private String PRIMER_IO_WT_TM_GT;
	@JsonProperty("PRIMER_IO_WT_SIZE_LT")
	private String PRIMER_IO_WT_SIZE_LT;
	@JsonProperty("PRIMER_IO_WT_SIZE_GT")
	private String PRIMER_IO_WT_SIZE_GT;
	@JsonProperty("PRIMER_IO_WT_GC_PERCENT_LT")
	private String PRIMER_IO_WT_GC_PERCENT_LT;
	@JsonProperty("PRIMER_IO_WT_GC_PERCENT_GT")
	private String PRIMER_IO_WT_GC_PERCENT_GT;
	@JsonProperty("PRIMER_IO_WT_COMPL_ANY")
	private String PRIMER_IO_WT_COMPL_ANY;
	@JsonProperty("PRIMER_IO_WT_NUM_NS")
	private String PRIMER_IO_WT_NUM_NS;
	@JsonProperty("PRIMER_IO_WT_REP_SIM")
	private String PRIMER_IO_WT_REP_SIM;
	@JsonProperty("PRIMER_IO_WT_SEQ_QUAL")
	private String PRIMER_IO_WT_SEQ_QUAL;

}