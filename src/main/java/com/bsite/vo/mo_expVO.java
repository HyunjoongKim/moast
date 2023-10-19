package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Expression count */

@Getter
@Setter
@ToString

public class mo_expVO implements Serializable {
	private static final long serialVersionUID = -3513618225204263004L;
	
	private int ud_id;
	private String gene_symbol;
	private String sample_id;
	private Double val;
	
	private Double valPlus1Log2;
	
	public void setVal(Double val) {
		this.val = val;
		this.valPlus1Log2 = Math.log(this.val + 1) / Math.log(2);
	}


}
