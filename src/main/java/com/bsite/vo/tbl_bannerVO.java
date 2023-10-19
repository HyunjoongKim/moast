package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
/*****************************
*  		배너 관리 테이블
******************************/
@Entity
@Table(name = "tbl_banner")
@SuppressWarnings("serial")
public class tbl_bannerVO extends PageSearchVO implements Serializable {

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private	int		bn_idx=0;			//	일련번호
	private	String	bn_loca;			//	배너 위치
	private	String	bn_title;			//	배너 제목
	private	String	bn_src;				//	배너 이미지 경로
	private	String	bn_width;			//	이미지 width
	private	String	bn_height;			//	이미지 height
	private	String	bn_alt;				//	이미지 alt
	private	String	bn_link;			//	이미지 링크
	private	String	bn_sdate;			//	시작날짜
	private	String	bn_stime;			//	시작시간
	private	String	bn_edate;			//	종료날짜
	private	String	bn_etime;			//	종료시간
	private	String	bn_use;				//	사용여부
	private	String	bn_etc;				//	비고
	private String atch_file_id;        //  파일아이디
	

	//검색
	@Transient
	private	String	searchBnIdx	="";
	@Transient
	private	String	searchBnLoca	="";
	@Transient
	private	String	searchBnTitle	="";

	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		qs += "&searchBnIdx="+this.searchBnIdx;
		qs += "&searchBnLoca="+this.searchBnLoca;
		qs += "&searchBnTitle="+this.searchBnTitle;

		this.qustr = qs;
	}

	public String getQustr() {
		return qustr;
	}

	public int getBn_idx() {
		return bn_idx;
	}

	public void setBn_idx(int bn_idx) {
		this.bn_idx = bn_idx;
	}

	public String getAtch_file_id() {
		return atch_file_id;
	}

	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}

	public String getBn_loca() {
		return bn_loca;
	}

	public void setBn_loca(String bn_loca) {
		this.bn_loca = bn_loca;
	}

	public String getBn_title() {
		return bn_title;
	}

	public void setBn_title(String bn_title) {
		this.bn_title = bn_title;
	}

	public String getBn_src() {
		return bn_src;
	}

	public void setBn_src(String bn_src) {
		this.bn_src = bn_src;
	}

	public String getBn_width() {
		return bn_width;
	}

	public void setBn_width(String bn_width) {
		this.bn_width = bn_width;
	}

	public String getBn_height() {
		return bn_height;
	}

	public void setBn_height(String bn_height) {
		this.bn_height = bn_height;
	}

	public String getBn_alt() {
		return bn_alt;
	}

	public void setBn_alt(String bn_alt) {
		this.bn_alt = bn_alt;
	}

	public String getBn_link() {
		return bn_link;
	}

	public void setBn_link(String bn_link) {
		this.bn_link = bn_link;
	}

	public String getBn_sdate() {
		return bn_sdate;
	}

	public void setBn_sdate(String bn_sdate) {
		this.bn_sdate = bn_sdate;
	}

	public String getBn_stime() {
		return bn_stime;
	}

	public void setBn_stime(String bn_stime) {
		this.bn_stime = bn_stime;
	}

	public String getBn_edate() {
		return bn_edate;
	}

	public void setBn_edate(String bn_edate) {
		this.bn_edate = bn_edate;
	}

	public String getBn_etime() {
		return bn_etime;
	}

	public void setBn_etime(String bn_etime) {
		this.bn_etime = bn_etime;
	}

	public String getBn_use() {
		return bn_use;
	}

	public void setBn_use(String bn_use) {
		this.bn_use = bn_use;
	}

	public String getBn_etc() {
		return bn_etc;
	}

	public void setBn_etc(String bn_etc) {
		this.bn_etc = bn_etc;
	}

	public String getSearchBnIdx() {
		return searchBnIdx;
	}

	public void setSearchBnIdx(String searchBnIdx) {
		this.searchBnIdx = searchBnIdx;
	}

	public String getSearchBnTitle() {
		return searchBnTitle;
	}

	public void setSearchBnTitle(String searchBnTitle) {
		this.searchBnTitle = searchBnTitle;
	}

	public String getSearchBnLoca() {
		return searchBnLoca;
	}

	public void setSearchBnLoca(String searchBnLoca) {
		this.searchBnLoca = searchBnLoca;
	}
	
}
