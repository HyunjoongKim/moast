package com.bsite.vo;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@SuppressWarnings("serial")
@Embeddable
public class comtnfiledtailPk implements Serializable {
	

	@Column(length=20, columnDefinition="CHAR", insertable=false)
	private String     atch_file_id;
	
	@Column(columnDefinition="DECIMAL(10,0)")
	private	String	file_sn;

	public String getAtch_file_id() {
		return atch_file_id;
	}

	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}

	public String getFile_sn() {
		return file_sn;
	}

	public void setFile_sn(String file_sn) {
		this.file_sn = file_sn;
	}	
	

	

}
