package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class genesVO implements Serializable {


	private static final long serialVersionUID = -4509315542363258131L;
	
	private int idx;
	private String gene_symbol;
	

}
