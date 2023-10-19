package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class mo_file_logVO implements Serializable {
	private static final long serialVersionUID = 4574815933520632534L;
	
	private long idx;
	private String tb_name;
	private long line_no;
	private String note;
	
	private long startTime;
	private long beforeTime;
	private long fileLine;
	private long lineCount;
	private long cellCount;
	private String itemName;
}
