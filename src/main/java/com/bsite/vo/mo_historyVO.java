package com.bsite.vo;

import java.io.UnsupportedEncodingException;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 내 분석 기록 */

@Getter
@Setter
@ToString

public class mo_historyVO extends PageSearchVO {

	private static final long serialVersionUID = -1070971379156829809L;
	
	private Integer ht_idx;
	
	private Integer wp_idx;
	private Integer ws_idx;
	private Integer ud_idx;
	private Integer me_idx;
	
	private String ht_title = "";
	private String ht_note = "";
	private String ht_type = "";
	private String ht_type_nm = "";

	
	private String search_ht_type = "all";
	
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
