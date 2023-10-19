package com.bsite.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class MatrixVO implements Serializable {
	private static final long serialVersionUID = 6681825669337773181L;

	List<String> sample1List = new ArrayList<String>();
	List<String> sample2List = new ArrayList<String>();
	List<String> sampleIdList = new ArrayList<String>();
	List<String> geneList = new ArrayList<String>();
	List<dna_me_probe_geneVO> probeGeneList = new ArrayList<dna_me_probe_geneVO>();
	List<rna_seqVO> expSrcList = new ArrayList<rna_seqVO>();
	List<String> methIdList = new ArrayList<String>();
	List<dna_meVO> metSrcList = new ArrayList<dna_meVO>();

}
