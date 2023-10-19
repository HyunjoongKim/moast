package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Expression count */

@Getter
@Setter
@ToString

public class PcaResultVO implements Serializable {

	private static final long serialVersionUID = 3353597157258644842L;
	
	private String geneSymbol;
	private Double pc1;
	private Double pc2;
	private Double pc3;
	private Double pc4;
	private Double pc5;


}
