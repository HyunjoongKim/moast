package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* scRNA scatter */

@Getter
@Setter
@ToString

public class mo_sc_scatterVO implements Serializable {
	private static final long serialVersionUID = -1861925331826371896L;
	
	private String cell_id;
	private String gene_name;
	private Integer value = 0;
	private Double tsne_1;
	private Double tsne_2;
	private String cell_type;
	
	private String gene = "";
	private String cluster = "";
	
	public Double getLogValue() {
		return Math.log(this.value + 1);
	}



}
