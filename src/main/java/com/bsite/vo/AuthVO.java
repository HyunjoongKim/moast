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

import org.codehaus.jackson.annotate.JsonProperty;

/*****************************
*  		사이트 권한 관리 테이블
******************************/
@Entity
@Table(name = "tbl_auth")
//@DynamicUpdate
//@SelectBeforeUpdate
@SuppressWarnings("serial")
public class AuthVO extends PageSearchVO implements Serializable{


	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int    auth_idx = 0;    	//auto key

	@JsonProperty
	@Column(name = "auth_code", updatable=false)
	private String auth_code;      	//권한 코드

	@JsonProperty
	private String auth_title;      	//타이틀

	@JsonProperty
	private int auth_order=0;          //순번 기본 1

	@JsonProperty
	private String auth_group;          //그룹핑 현재 사용x

	@JsonProperty
	private String auth_etc;            //비고

	@JsonProperty
	private int    auth_mn_usecnt = 0;  //메뉴총개수 대비 사용된 수

	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		//qs += "&searchCate2="+this.searchCate2;

		this.qustr = qs;
	}

	public String getQustr() {
		return qustr;
	}

	public int getAuth_idx() {
		return auth_idx;
	}

	public void setAuth_idx(int auth_idx) {
		this.auth_idx = auth_idx;
	}

	public String getAuth_title() {
		return auth_title;
	}

	public void setAuth_title(String auth_title) {
		this.auth_title = auth_title;
	}


	public int getAuth_order() {
		return auth_order;
	}

	public void setAuth_order(int auth_order) {
		this.auth_order = auth_order;
	}

	public String getAuth_group() {
		return auth_group;
	}

	public void setAuth_group(String auth_group) {
		this.auth_group = auth_group;
	}

	public String getAuth_etc() {
		return auth_etc;
	}

	public void setAuth_etc(String auth_etc) {
		this.auth_etc = auth_etc;
	}

	public int getAuth_mn_usecnt() {
		return auth_mn_usecnt;
	}

	public void setAuth_mn_usecnt(int auth_mn_usecnt) {
		this.auth_mn_usecnt = auth_mn_usecnt;
	}

	public String getAuth_code() {
		return auth_code;
	}

	public void setAuth_code(String auth_code) {
		this.auth_code = auth_code;
	}



}
