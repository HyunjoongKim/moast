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
*  		팝업 관리 테이블
******************************/
@Entity
@Table(name = "tbl_popup")
@SuppressWarnings("serial")
public class tbl_popupVO extends PageSearchVO implements Serializable {

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private	int		pop_idx=0;			//	일련번호
	private	String	pop_title;			//	팝업 제목
	@Column(length = 65535,columnDefinition="Text")
	private	String	pop_content;		//	팝업 내용
	private	String	pop_width;			//	가로
	private	String	pop_height;			//	세로
	private	String	pop_x;				//	x 좌표
	private	String	pop_y;				//	y 좌표
	private	String	pop_sdate;			//	시작날짜
	private	String	pop_stime;			//	시작시간
	private	String	pop_edate;			//	종료날짜
	private	String	pop_etime;			//	종료시간
	private	String	pop_use;			//	사용여부
	private	String	pop_etc;			//	비고

	//검색
	@Transient
	private	String	searchPopIdx	="";
	@Transient
	private	String	searchPopTitle	="";

	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		qs += "&searchPopIdx="+this.searchPopIdx;
		qs += "&searchPopTitle="+this.searchPopTitle;

		this.qustr = qs;
	}

	public String getQustr() {
		return qustr;
	}

	public int getPop_idx() {
		return pop_idx;
	}

	public void setPop_idx(int pop_idx) {
		this.pop_idx = pop_idx;
	}

	public String getPop_title() {
		return pop_title;
	}

	public void setPop_title(String pop_title) {
		this.pop_title = pop_title;
	}

	public String getPop_content() {
		return pop_content;
	}

	public void setPop_content(String pop_content) {
		this.pop_content = pop_content;
	}

	public String getPop_width() {
		return pop_width;
	}

	public void setPop_width(String pop_width) {
		this.pop_width = pop_width;
	}

	public String getPop_height() {
		return pop_height;
	}

	public void setPop_height(String pop_height) {
		this.pop_height = pop_height;
	}

	public String getPop_x() {
		return pop_x;
	}

	public void setPop_x(String pop_x) {
		this.pop_x = pop_x;
	}

	public String getPop_y() {
		return pop_y;
	}

	public void setPop_y(String pop_y) {
		this.pop_y = pop_y;
	}

	public String getPop_sdate() {
		return pop_sdate;
	}

	public void setPop_sdate(String pop_sdate) {
		this.pop_sdate = pop_sdate;
	}

	public String getPop_stime() {
		return pop_stime;
	}

	public void setPop_stime(String pop_stime) {
		this.pop_stime = pop_stime;
	}

	public String getPop_edate() {
		return pop_edate;
	}

	public void setPop_edate(String pop_edate) {
		this.pop_edate = pop_edate;
	}

	public String getPop_etime() {
		return pop_etime;
	}

	public void setPop_etime(String pop_etime) {
		this.pop_etime = pop_etime;
	}

	public String getPop_use() {
		return pop_use;
	}

	public void setPop_use(String pop_use) {
		this.pop_use = pop_use;
	}

	public String getPop_etc() {
		return pop_etc;
	}

	public void setPop_etc(String pop_etc) {
		this.pop_etc = pop_etc;
	}

	public String getSearchPopIdx() {
		return searchPopIdx;
	}

	public void setSearchPopIdx(String searchPopIdx) {
		this.searchPopIdx = searchPopIdx;
	}

	public String getSearchPopTitle() {
		return searchPopTitle;
	}

	public void setSearchPopTitle(String searchPopTitle) {
		this.searchPopTitle = searchPopTitle;
	}



}
