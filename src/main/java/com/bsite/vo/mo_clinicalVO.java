package com.bsite.vo;

import java.io.UnsupportedEncodingException;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 임상정보 */

@Getter
@Setter
@ToString

public class mo_clinicalVO extends PageSearchVO {

	private static final long serialVersionUID = 8937648835795094289L;

	private Integer ud_idx;
	private Integer cd_idx;
	private Integer spm_idx;
	private String patient_id;
	private String sample_id;
	private String sample_type;
	private String cohort;
	private String sex;
	private String age_diag;
	private String pri_location;
	private String pri_location_side;
	private String pathology;
	private String differentiation;
	private String msi;
	private String stage;
	private String substage;
	private String t_diag;
	private String n_diag;
	private String lymphatic_invasion;
	private String venous_invasion;
	private String perineural_invasion;
	private String m_diag;
	private String meta_organs;
	private String dfs;
	private String recur;
	private String lvp;


	private String ck;

	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
