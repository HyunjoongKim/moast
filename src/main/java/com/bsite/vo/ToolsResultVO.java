package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* thirdpaty tools result */

@Getter
@Setter
@ToString

public class ToolsResultVO implements Serializable {

	private static final long serialVersionUID = 7200803361917200345L;
	
	private String fileName;
	private String fileFormat;
	


}
