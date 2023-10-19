package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Expression count */

@Getter
@Setter
@ToString

public class DegResultVO implements Serializable {

	private static final long serialVersionUID = 5993840435426630L;

	private String geneSymbol;
	private Double logFC;
	private Double pValue;
	
	private Double logCPM;
	private Double lR;
	private Double fDR;
	
	private Double baseMean;
	private Double log2FoldChange;
	private Double lfcSE;
	private Double stat;
	private Double padj;

	private Double logFcAbs;
	private String group;
	
	public String getStrPValue() {
		return String.valueOf(pValue);
	}
	
	public String getStrPadj() {
		return String.valueOf(padj);
	}
	


	public Double getMinusLogPValue() {
		if (this.pValue != null && this.pValue != 0) {
			
		} else {
			System.out.println(this.pValue);
			System.out.println(this);
		}
		return (this.pValue != null && this.pValue != 0) ? -Math.log(this.pValue) : -0d;
	}

}
