package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 임상정보 */
 
@Entity
@Table(name = "mo_clinic_group_dtl")
@Getter
@Setter
@ToString
public class mo_clinic_group_dtlVO extends PageSearchVO {
	private static final long serialVersionUID = -2428273465688461941L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int cgd_idx = 0;
	
	@Column(name = "cg_idx", insertable=false, updatable=false)
	private Integer cg_idx = 0;
	
	private Integer cg_no = 0;
	
	private String sample_id = "";
	
	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		//qs += "&isPopup="+this.isPopup; 
	
		this.qustr = qs;
	}

}
