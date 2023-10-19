package com.bsite.vo;

import java.io.UnsupportedEncodingException;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 임상정보 */

@Getter
@Setter
@ToString

public class mo_clinicalD2VO extends PageSearchVO {
	
	private static final long serialVersionUID = -3460367739521820400L;
	
	private Integer ud_idx;
	private Integer cd_idx;
	private String sample_id = "";
	private String tumor_tissue_site = "";
	private String histological_type = "";
	private String gender = "";
	private String vital_status_x = "";
	private String days_to_birth = "";
	private String days_to_death_x = "";
	private String days_to_last_followup_x = "";
	private String tissue_source_site = "";
	private String patient_id = "";
	private String bcr_patient_uuid = "";
	private String informed_consent_verified = "";
	private String icd_o_3_site = "";
	private String icd_10 = "";
	private String tissue_prospective_collection_indicator = "";
	private String tissue_retrospective_collection_indicator = "";
	private String age_at_initial_pathologic_diagnosis = "";
	private String year_of_initial_pathologic_diagnosis = "";
	private String ethnicity = "";
	private String weight = "";
	private String height = "";

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
