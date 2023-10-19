package com.adms.crc.clinic2.service;

import java.util.stream.Stream;

import lombok.Getter;

/* RealGrid Column */

@Getter

public enum ClinicD2Column {
	
	cl2_id ("cl2_id","cl2_id", true, "100", false), 
	
	//patient_id ("patient_id","patient_id", true, "100", true), 
	//tissue_type ("tissue_type","tissue_type", true, "100", true), 
	//cohort_type ("cohort_type","cohort_type", true, "100", true),
	
	sample_id ("sample_id","sample_id", true, "100", true), 
	sample_type ("sample_type","sample_type", true, "100", true), 
	
	//hopital ("hopital","hopital", true, "100", true),
	
	gender ("gender","성별", true, "100", true), 
	age ("age","나이", true, "100", true), 
	date_of_diagnosis ("date_of_diagnosis","진단일", true, "100", true), 
	//dupli ("dupli","중복암여부", true, "100", true), 
	location ("location","암위치 상세", true, "100", true), 
	pathology ("pathology","pathology", true, "100", true), 
	differentiation ("differentiation","분화도", true, "100", true), 
	msi_status ("msi_status","MSI status", true, "100", true), 
	kras ("kras","KRAS", true, "100", true), 
	nras ("nras","NRAS", true, "100", true), 
	braf ("braf","BRAF", true, "100", true), 
	staging ("staging","진단시 병기", true, "100", true), 
	staging_detail ("staging_detail","세부 병기", true, "100", true), 
	t_stage ("t_stage","진단시 T stage", true, "100", true), 
	n_stage ("n_stage","진단시 N stage", true, "100", true), 
	l ("l","L stage", true, "100", true), 
	v ("v","V stage", true, "100", true), 
	p ("p","P stage", true, "100", true), 
	m_stage ("m_stage","진단시 M stage", true, "100", true), 
	metastatic_organ ("metastatic_organ","전이장기", true, "100", true), 
	follow_up ("follow_up","마지막 추적관찰일", true, "100", true), 
	follow_up_state ("follow_up_state","마지막 추적관찰시 상태", true, "100", true), 
	survival ("survival","생존여부", true, "100", true), 
	date_of_death ("date_of_death","사망일", true, "100", true), 
	surgery_day ("surgery_day","surgery_day", true, "100", true), 
	surgery_name ("surgery_name","surgery_name", true, "100", true), 
	chemotherapy ("chemotherapy","chemotherapy", true, "100", true), 
	chemotherapy_name ("chemotherapy_name","chemotherapy_name", true, "100", true), 
	radiation_before ("radiation_before","radiation_before", true, "100", true), 
	radiation_after ("radiation_after","radiation_after", true, "100", true), 
	complete ("complete","complete", true, "100", true), 
	chemotherapy_date ("chemotherapy_date","chemotherapy_date", true, "100", true), 
	recurrence ("recurrence","recurrence", true, "100", true), 
	recurrence_date ("recurrence_date","recurrence_date", true, "100", true), 
	recurrence_pattern ("recurrence_pattern","recurrence_pattern", true, "100", true), 
	recurrence_organ ("recurrence_organ","recurrence_organ", true, "100", true), 
	os_status ("os_status","os_status", true, "100", true), 
	os_time ("os_time","os_time", true, "100", true), 
	dfs_status ("dfs_status","dfs_status", true, "100", true), 
	dfs_time ("dfs_time","dfs_time", true, "100", true);
	
	private String field;
	private String title;
	private boolean sortable;
	private String width;
	private boolean display;
	/*
	private String field;
	private String title;
	private String width;
	private String format;
	private String template;
	*/
	ClinicD2Column(String field, String title, boolean sortable, String width, boolean display) {
		this.field = field;
		this.title = title;
		this.sortable = sortable;
		this.width = width;
		this.display = display;
		
	}
	
	public static Stream<ClinicD2Column> stream() {
        return Stream.of(ClinicD2Column.values()); 
    }
	
}
