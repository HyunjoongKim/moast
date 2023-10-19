package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class mo_epic850kVO implements Serializable {
	private static final long serialVersionUID = 5254818152324620302L;
	
	private String probe_id;
	private String ref_gene;
	
	private String gene_probe;

}
