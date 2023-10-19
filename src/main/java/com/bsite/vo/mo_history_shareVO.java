package com.bsite.vo;

import java.io.UnsupportedEncodingException;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 분석 기록 공유 */

@Getter
@Setter
@ToString

public class mo_history_shareVO extends PageSearchVO {
	private static final long serialVersionUID = -7891197967731997914L;

	private Integer hts_idx;
	
	private Integer wp_idx;
	private Integer ws_idx;
	private Integer ud_idx;
	private Integer me_idx;
	private Integer target_me_idx;
	
	
	private String hts_title = "";
	private String hts_note = "";


	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
