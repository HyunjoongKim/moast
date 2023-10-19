package com.bsite.vo;

import java.io.Serializable;
import java.util.Date;

import org.codehaus.jackson.annotate.JsonProperty;
/*****************************
*  		로그인 관련 VO
******************************/
@SuppressWarnings("serial")
public class LoginVO extends PageSearchVO implements Serializable{
	

	@JsonProperty
	private int idx=0; 	//회원관리 고유값 확인하기 위해 idx 추가 2017.09.12[연순모]
	@JsonProperty
	private String id="";
	@JsonProperty
	private String password="";
	@JsonProperty
	private String name="";
	@JsonProperty
	private String email="";
	@JsonProperty
	private String authCode="";
	@JsonProperty
	private String meIsCert=""; //인증유무	
	@JsonProperty
	private int meFailCnt; //로그인실패횟수
	@JsonProperty
	private String meIsLogin=""; //로그인인증유무
	@JsonProperty
	private Date latestLogin;
	@JsonProperty
	private String me_type="";
	@JsonProperty
	private String repoHasRight ="";  //수장고 관련 타입일때 권한들 1,2,3 .. 형태
	@JsonProperty
	private int iat = 0;

	private String requestURL="";
	private String mkUrl;
	private int    menu_idx = 0;


	public String getRepoHasRight() {
		return repoHasRight;
	}
	public void setRepoHasRight(String repoHasRight) {
		this.repoHasRight = repoHasRight;
	}
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	
	public int getIat() {
		return iat;
	}
	public void setIat(int iat) {
		this.iat = iat;
	}
	public int getMenu_idx() {
		return menu_idx;
	}
	public void setMenu_idx(int menu_idx) {
		this.menu_idx = menu_idx;
	}
	public String getMkUrl() {
		return mkUrl;
	}
	public void setMkUrl(String mkUrl) {
		this.mkUrl = mkUrl;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRequestURL() {
		return requestURL;
	}
	public void setRequestURL(String requestURL) {
		this.requestURL = requestURL;
	}
	public String getAuthCode() {
		return authCode;
	}
	public void setAuthCode(String authCode) {
		this.authCode = authCode;
	}
	public String getMe_type() {
		return me_type;
	}
	public void setMe_type(String me_type) {
		this.me_type = me_type;
	}
	public Date getLatestLogin() {
		return latestLogin;
	}
	public void setLatestLogin(Date latestLogin) {
		this.latestLogin = latestLogin;
	}
	public String getMeIsCert() {
		return meIsCert;
	}
	public void setMeIsCert(String meIsCert) {
		this.meIsCert = meIsCert;
	}
	public int getMeFailCnt() {
		return meFailCnt;
	}
	public void setMeFailCnt(int meFailCnt) {
		this.meFailCnt = meFailCnt;
	}
	public String getMeIsLogin() {
		return meIsLogin;
	}
	public void setMeIsLogin(String meIsLogin) {
		this.meIsLogin = meIsLogin;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
}
