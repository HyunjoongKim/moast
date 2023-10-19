package com.bsite.vo;

import java.io.UnsupportedEncodingException;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* preset 공유 */

@Getter
@Setter
@ToString

public class mo_preset_shareVO extends PageSearchVO {
	private static final long serialVersionUID = -7891197967731997914L;

	private Integer pss_idx;
	
	private Integer ps_idx;
	private Integer me_idx;
	private Integer target_me_idx;
	
	private String pss_title = "";
	private String pss_note = "";


	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
