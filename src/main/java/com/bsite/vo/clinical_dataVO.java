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

/* 임상정보2 */

@Entity
@Table(name = "clinical_data")
@Getter
@Setter
@ToString

public class clinical_dataVO extends PageSearchVO {

	private static final long serialVersionUID = 8937648835795094289L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int cl2_id;

	private String patient_id;
	private String tissue_type;
	private String cohort_type;
	private String sample_id;
	private String sample_type;
	private String hopital;
	private String gender;
	private Integer age;
	private String date_of_diagnosis;
	private String dupli;
	private Integer location;
	private Integer pathology;
	private Integer differentiation;
	private Integer msi_status;
	private Integer kras;
	private Integer nras;
	private Integer braf;
	private Integer staging;
	private String staging_detail;
	private String t_stage;
	private String n_stage;
	private Integer l;
	private Integer v;
	private Integer p;
	private Integer m_stage;
	private String metastatic_organ;
	private String follow_up;
	private Integer follow_up_state;
	private Integer survival;
	private String date_of_death;
	private String surgery_day;
	private String surgery_name;
	private Integer chemotherapy;
	private Integer chemotherapy_name;
	private Integer radiation_before;
	private Integer radiation_after;
	private Integer complete;
	private String chemotherapy_date;
	private Integer recurrence;
	private String recurrence_date;
	private String recurrence_pattern;
	private String recurrence_organ;
	private Integer os_status;
	private Integer os_time;
	private Integer dfs_status;
	private Integer dfs_time;

	@Transient
	private String ck;

	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
