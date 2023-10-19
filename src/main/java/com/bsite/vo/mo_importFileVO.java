package com.bsite.vo;

import java.io.FileWriter;
import java.io.IOException;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 임상정보 */

@Getter
@Setter
@ToString
public class mo_importFileVO implements Serializable {

	private static final long serialVersionUID = -5183585581336157801L;
	
	private int ud_idx;
	private String sourceFile;
	private String targetFile;
	private String logFile;
	private long startLine;
	private long lineLimit;
	
	public mo_importFileVO(int ud_idx, String sourceFile, String targetFile, String logFile, long startLine, long lineLimit) {
		this.ud_idx = ud_idx;
		this.sourceFile = sourceFile;
		this.targetFile = targetFile;
		this.logFile = logFile;
		this.startLine = startLine;
		this.lineLimit = lineLimit;
	}
	
	
	
	

	

}
