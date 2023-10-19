package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class DmpResultVO implements Serializable {
	private static final long serialVersionUID = -8516164270734618573L;
	
	private int ud_id;
	private String probe_id;
	private Double logFC;
	//private Double intercept;
	private Double pValue;
	private Double adjPValue;
	
	private Integer chr;
	private String mapInfo;
	private String strand;

}
