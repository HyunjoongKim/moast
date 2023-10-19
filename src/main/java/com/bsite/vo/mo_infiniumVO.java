package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Illumina Infinium */

@Getter
@Setter
@ToString

public class mo_infiniumVO implements Serializable {

	private static final long serialVersionUID = 4124411623138755054L;
	
	private Integer infinium_idx;
	private String ilmnID;
	private String cName;
	private Integer addressA_ID;
	private String alleleA_ProbeSeq;
	private String addressB_ID;
	private String alleleB_ProbeSeq;
	private String infinium_Design_Type;
	private String next_Base;
	private String color_Channel;
	private String forward_Sequence;
	private String genome_Build;
	private String cHR;
	private String mAPINFO;
	private String sourceSeq;
	private String strand;
	private String uCSC_RefGene_Name;
	private String uCSC_RefGene_Accession;
	private String uCSC_RefGene_Group;
	private String uCSC_CpG_Islands_Name;
	private String relation_to_UCSC_CpG_Island;
	private String phantom4_Enhancers;
	private String phantom5_Enhancers;
	private String dMR;
	private String c450k_Enhancer;
	private String hMM_Island;
	private String regulatory_Feature_Name;
	private String regulatory_Feature_Group;
	private String gencodeBasicV12_NAME;
	private String gencodeBasicV12_Accession;
	private String gencodeBasicV12_Group;
	private String gencodeCompV12_NAME;
	private String gencodeCompV12_Accession;
	private String gencodeCompV12_Group;
	private String dNase_Hypersensitivity_NAME;
	private String dNase_Hypersensitivity_Evidence_Count;
	private String openChromatin_NAME;
	private String openChromatin_Evidence_Count;
	private String tFBS_NAME;
	private String tFBS_Evidence_Count;
	private String methyl27_Loci;
	private String methyl450_Loci;
	private String chromosome_36;
	private String coordinate_36;
	private String sNP_ID;
	private String sNP_DISTANCE;
	private String sNP_MinorAlleleFrequency;
	private String random_Loci;
	private String mFG_Change_Flagged;
	private String cHR_hg38;
	private String start_hg38;
	private String end_hg38;
	private String strand_hg38;


}
