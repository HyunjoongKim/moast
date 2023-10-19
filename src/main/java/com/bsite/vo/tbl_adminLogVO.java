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
*  	관리자로그인 관리 테이블
******************************/
@Entity
@Table(name = "tbl_admin_log")
@SuppressWarnings("serial")
public class tbl_adminLogVO extends PageSearchVO implements Serializable {
	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int idx;
	private int user_idx;	 
	private String menu_code;	
	private String gubun;	
	@Column(name = "infor", columnDefinition="TEXT")
	private String infor;
		

	//검색항목
	@Transient
	private	String	searchId ="";	
	@Transient
	private	String	searchMenuCode	="";
	@Transient
	private	String	searchGubun	="";
	@Transient
	private	String	searchInfor	="";
	@Transient
	private	String	searchIp	="";
	@Transient
	private	String	searchSdate	="";
	@Transient
	private	String	searchEdate	="";
	
	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		qs += "&searchId="+this.searchId;
		qs += "&searchMenuCode="+this.searchMenuCode;
		qs += "&searchgubun="+this.searchGubun;
		qs += "&searchInfor="+this.searchInfor;
		qs += "&searchIp="+this.searchIp;
		qs += "&searchSdate="+this.searchSdate;
		qs += "&searchEdate="+this.searchEdate;
		this.qustr = qs;
	}
	

	public String getQustr() {
		return qustr;
	}

	
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public int getUser_idx() {
		return user_idx;
	}
	public void setUser_idx(int user_idx) {
		this.user_idx = user_idx;
	}
	public String getMenu_code() {
		return menu_code;
	}
	public void setMenu_code(String menu_code) {
		this.menu_code = menu_code;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getInfor() {
		return infor;
	}
	public void setInfor(String infor) {
		this.infor = infor;
	}

	public String getSearchId() {
		return searchId;
	}


	public void setSearchId(String searchId) {
		this.searchId = searchId;
	}

	public String getSearchMenuCode() {
		return searchMenuCode;
	}


	public void setSearchMenuCode(String searchMenuCode) {
		this.searchMenuCode = searchMenuCode;
	}


	public String getSearchGubun() {
		return searchGubun;
	}


	public void setSearchGubun(String searchGubun) {
		this.searchGubun = searchGubun;
	}


	public String getSearchInfor() {
		return searchInfor;
	}


	public void setSearchInfor(String searchInfor) {
		this.searchInfor = searchInfor;
	}


	public String getSearchIp() {
		return searchIp;
	}


	public void setSearchIp(String searchIp) {
		this.searchIp = searchIp;
	}


	public String getSearchSdate() {
		return searchSdate;
	}


	public void setSearchSdate(String searchSdate) {
		this.searchSdate = searchSdate;
	}


	public String getSearchEdate() {
		return searchEdate;
	}


	public void setSearchEdate(String searchEdate) {
		this.searchEdate = searchEdate;
	}
	
}