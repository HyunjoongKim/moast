package com.bsite.vo;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* preset */

@Getter
@Setter
@ToString

public class mo_presetVO extends PageSearchVO {

	private static final long serialVersionUID = -1070971379156829809L;
	
	private int ps_idx = 0;
	
	private Integer ud_idx;
	private Integer me_idx;
	private Integer share_me_idx = 0;
	private String me_name = "";
	
	private String ps_title = "";
	private String ps_note = "";
	private String ps_status = "";
	
	private Integer std_idx = 0;
	private String std_indices = "";
	private String std_title = ""; 
	private String std_note = "";
	private String std_type = "A";
	private String expYN = "";
	private String methYN = "";
	private String mutYN = "";
	
	private String ud_title = "";
	
	private String std_idx_str = "";
	private String[] std_idx_arr;
	
	private OmicsDataVO workingOmics;
	private List<OmicsDataVO> omicsList = new ArrayList<OmicsDataVO>();
	private List<mo_studyVO> studyList = new ArrayList<mo_studyVO>();
	
	private Integer cg_idx = 0;
	private String cg_type = "";
	private String cg_title = "";
	
	private String popYn = "N";
	
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
