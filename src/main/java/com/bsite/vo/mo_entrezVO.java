package com.bsite.vo;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* mo_entrez */

@Getter
@Setter
@ToString
public class mo_entrezVO extends PageSearchVO {

	private static final long serialVersionUID = 524044529867334573L;

	private Integer entrez_id;
	private String symbol = "";

	private List<String> geneList = new ArrayList<String>();

	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		// qs += "&isPopup="+this.isPopup;

		this.qustr = qs;
	}

}
