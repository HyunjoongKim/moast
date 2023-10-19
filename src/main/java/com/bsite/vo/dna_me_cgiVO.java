package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation CGI */

@Getter
@Setter
@ToString

public class dna_me_cgiVO implements Serializable {

	private static final long serialVersionUID = 7495736981573494947L;
	private String probe_id;
	private String annotaion;
	private String gene_symbol;

}
