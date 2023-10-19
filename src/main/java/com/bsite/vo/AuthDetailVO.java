package com.bsite.vo;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;

import org.codehaus.jackson.annotate.JsonProperty;
/*****************************
*  		권한 관련 VO
******************************/
@SuppressWarnings("serial")
public class AuthDetailVO extends AuthVO implements Serializable{
	private int AD_IDX = 0;
	private String FTR_CODE;
	@JsonProperty("MENU_CODE")
	private String MENU_CODE;
	@JsonProperty("AUTH_IDX")
	private int AUTH_IDX = 0;     //부모코드 1:N
	@JsonProperty("CREATE_R")
	private String CREATE_R      = "Y"; //= "N";
	@JsonProperty("READ_R")
	private String READ_R        = "Y"; //= "N";
	@JsonProperty("UPDATE_R")
	private String UPDATE_R	     = "Y"; //= "N";
	@JsonProperty("DELETE_R")
	private String DELETE_R      = "Y"; //= "N";
	@JsonProperty("LIST_R")
	private String LIST_R        = "Y"; //= "N";
	@JsonProperty("LABEL_R")
	private String LABEL_R       = "Y"; //= "N";
	@JsonProperty("PRINT_R")
	private String PRINT_R       = "Y"; //= "N";
	@JsonProperty("EXCEL_R")
	private String EXCEL_R       = "Y"; //= "N";
	@JsonProperty("REPLY_R")
	private String REPLY_R       = "Y"; //= "N";
	@JsonProperty("CMT_R")
	private String CMT_R         = "Y"; //= "N";
	@JsonProperty("OPTION_A")
	private String OPTION_A;     
	@JsonProperty("OPTION_B")
	private String OPTION_B;
	
	private String naviGName;

	
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		//qs += "&searchCate2="+this.searchCate2;

		this.qustr = qs;
	}

	public int getAD_IDX() {
		return AD_IDX;
	}

	public void setAD_IDX(int aD_IDX) {
		AD_IDX = aD_IDX;
	}

	public String getFTR_CODE() {
		return FTR_CODE;
	}

	public void setFTR_CODE(String fTR_CODE) {
		FTR_CODE = fTR_CODE;
	}

	public String getMENU_CODE() {
		return MENU_CODE;
	}

	public void setMENU_CODE(String mENU_CODE) {
		MENU_CODE = mENU_CODE;
	}

	public int getAUTH_IDX() {
		return AUTH_IDX;
	}

	public void setAUTH_IDX(int aUTH_IDX) {
		AUTH_IDX = aUTH_IDX;
	}

	public String getCREATE_R() {
		return CREATE_R;
	}

	public void setCREATE_R(String cREATE_R) {
		CREATE_R = cREATE_R;
	}

	public String getREAD_R() {
		return READ_R;
	}

	public void setREAD_R(String rEAD_R) {
		READ_R = rEAD_R;
	}

	public String getUPDATE_R() {
		return UPDATE_R;
	}

	public void setUPDATE_R(String uPDATE_R) {
		UPDATE_R = uPDATE_R;
	}

	public String getDELETE_R() {
		return DELETE_R;
	}

	public void setDELETE_R(String dELETE_R) {
		DELETE_R = dELETE_R;
	}

	public String getLIST_R() {
		return LIST_R;
	}

	public void setLIST_R(String lIST_R) {
		LIST_R = lIST_R;
	}

	public String getLABEL_R() {
		return LABEL_R;
	}

	public void setLABEL_R(String lABEL_R) {
		LABEL_R = lABEL_R;
	}

	public String getPRINT_R() {
		return PRINT_R;
	}

	public void setPRINT_R(String pRINT_R) {
		PRINT_R = pRINT_R;
	}

	public String getEXCEL_R() {
		return EXCEL_R;
	}

	public void setEXCEL_R(String eXCEL_R) {
		EXCEL_R = eXCEL_R;
	}

	public String getREPLY_R() {
		return REPLY_R;
	}

	public void setREPLY_R(String rEPLY_R) {
		REPLY_R = rEPLY_R;
	}

	public String getCMT_R() {
		return CMT_R;
	}

	public void setCMT_R(String cMT_R) {
		CMT_R = cMT_R;
	}

	public String getOPTION_A() {
		return OPTION_A;
	}

	public void setOPTION_A(String oPTION_A) {
		OPTION_A = oPTION_A;
	}

	public String getOPTION_B() {
		return OPTION_B;
	}

	public void setOPTION_B(String oPTION_B) {
		OPTION_B = oPTION_B;
	}

	public String getNaviGName() {
		return naviGName;
	}

	public void setNaviGName(String naviGName) {
		this.naviGName = naviGName;
	}

	
}
