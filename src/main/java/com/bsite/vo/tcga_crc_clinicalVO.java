package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;

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
@Table(name = "tcga_crc_clinical")
@Getter
@Setter
@ToString
public class tcga_crc_clinicalVO extends PageSearchVO {

	private static final long serialVersionUID = -4422180766402303943L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int cl_id = 0;

	private String p_id;
	private String type;
	private Integer age;
	private String gender;
	private String race;
	private String patho_tumor_stage;
	private String histo_type;
	private String vital_status;
	private String tumor_status;
	private String treatment_outcome;
	private Integer os;
	private Integer os_time;
	private Integer dss;
	private Integer dss_time;
	private Integer dfi;
	private Integer dfi_time;
	private Integer pfi;
	private Integer pfi_time;
	private Integer pfi_1;
	private Integer pfi_time_1;
	private Integer pfi_2;
	private Integer pfi_time_2;
	private Integer pfs;
	private Integer pfs_time;
	private Integer dss_cr;
	private Integer dss_time_cr;
	private Integer dfi_cr;
	private Integer dfi_time_cr;
	private Integer pfi_cr;
	private Integer pfi_time_cr;
	private Integer pfi_1_cr;
	private Integer pfi_time_1_cr;
	private Integer pfi_2_cr;
	private Integer pfi_time_2_cr;
	private String pathologic_t;
	private String pathologic_m;
	private String pathologic_n;
	private Integer lvp;
	
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
