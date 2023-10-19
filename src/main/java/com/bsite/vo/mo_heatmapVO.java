package com.bsite.vo;

import java.io.UnsupportedEncodingException;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* heatmap */

@Getter
@Setter
@ToString

public class mo_heatmapVO extends PageSearchVO {

	private static final long serialVersionUID = 7950347736972671509L;

	private Integer hm_idx = 0;
	private Integer ud_idx = 0;
	private Integer me_idx = 0;
	private Integer ps_idx = 0;
	private Integer std_idx = 0;
	private String hm_title = "";
	private String hm_note = "";
	private String hm_status = "";
	private String hm_type = "";
	private String hm_type_nm = "";
	private String hm_json = "";
	
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
