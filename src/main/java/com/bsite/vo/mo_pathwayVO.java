package com.bsite.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* pathway genes */

@Getter
@Setter
@ToString

public class mo_pathwayVO implements Serializable {
	private static final long serialVersionUID = 3903174738440673502L;
	
	private String pathway_id = "";
	private String pathway_nm = "";
	private List<String> pathway_genes = new ArrayList<String>();

}

