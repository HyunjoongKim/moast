package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Formula;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 작업 */

@Entity
@Table(name = "mo_analysis_data")
@Getter
@Setter
@ToString

public class mo_analysisDataVO extends PageSearchVO {
	private static final long serialVersionUID = 2321993331808370604L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int ud_idx;

	private Integer me_idx;
	private String ud_title;
	private String ud_status;
	private String ud_note;
	
	@Formula("FN_CODE_NAME('default', site_code ,'814' ,ud_status)")
	private String ud_statusName;
	
	@Transient
	private String searchUdTitle = "";
	
	@Transient
	private String searchUdStatus = "";
	
	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		
		this.qustr = qs;
	}
	

}
