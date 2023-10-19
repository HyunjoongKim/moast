package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* scRNA cell gene */

@Getter
@Setter
@ToString

public class mo_sc_cell_geneVO implements Serializable {
	private static final long serialVersionUID = -2987001482919020259L;
	
	private String cell_id;
	private String gene_name;
	private Integer value;


}
