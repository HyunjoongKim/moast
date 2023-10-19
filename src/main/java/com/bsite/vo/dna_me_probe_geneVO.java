package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation Probe Gene */

@Getter
@Setter
@ToString

public class dna_me_probe_geneVO implements Serializable {

	
	private static final long serialVersionUID = -8237222491044652533L;
	private int idx = 0;
	private String probe_id;
	private String annotaion;
	private String gene_symbol;
	
}
