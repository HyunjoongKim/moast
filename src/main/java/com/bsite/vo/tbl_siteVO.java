package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
/*****************************
*  		사이트 관리 테이블
******************************/
@Entity
@Table(name = "tbl_site")
@SuppressWarnings("serial")
public class tbl_siteVO extends PageSearchVO implements Serializable{

	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int    ts_pkid = 0;    	//auto key
	
	private String ts_title;
	private String ts_domain;
	@Column(name = "ts_stat_yn", insertable=false)
	private String ts_stat_yn;
	private String ts_etc;
	private int ts_order = 0;
	
	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		//qs += "&searchCate2="+this.searchCate2;

		this.qustr = qs;
	}

	public int getTs_order() {
		return ts_order;
	}

	public void setTs_order(int ts_order) {
		this.ts_order = ts_order;
	}

	public String getQustr() {
		return qustr;
	}
	
	
	public String getTs_etc() {
		return ts_etc;
	}

	public void setTs_etc(String ts_etc) {
		this.ts_etc = ts_etc;
	}

	public int getTs_pkid() {
		return ts_pkid;
	}
	public void setTs_pkid(int ts_pkid) {
		this.ts_pkid = ts_pkid;
	}
	public String getTs_title() {
		return ts_title;
	}
	public void setTs_title(String ts_title) {
		this.ts_title = ts_title;
	}
	public String getTs_domain() {
		return ts_domain;
	}
	public void setTs_domain(String ts_domain) {
		this.ts_domain = ts_domain;
	}
	public String getTs_stat_yn() {
		return ts_stat_yn;
	}
	public void setTs_stat_yn(String ts_stat_yn) {
		this.ts_stat_yn = ts_stat_yn;
	}
	
	
	
}
