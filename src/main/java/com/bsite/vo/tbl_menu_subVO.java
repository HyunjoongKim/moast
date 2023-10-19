package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.codehaus.jackson.annotate.JsonProperty;
/*****************************
*  		메뉴별 권한 등록 관리 테이블
******************************/
@Entity
@Table(name = "tbl_menu_sub")
@SuppressWarnings("serial")
public class tbl_menu_subVO extends PageSearchVO{

	private int auth_idx = 0;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@JsonProperty("AD_IDX")
	private int AD_IDX=0;

	@JsonProperty("CREATE_R")
	private String CREATE_R;

	@JsonProperty("READ_R")
	private String READ_R;

	@JsonProperty("UPDATE_R")
	private String UPDATE_R;

	@JsonProperty("DELETE_R")
	private String DELETE_R;

	@JsonProperty("LIST_R")
	private String LIST_R;

	@JsonProperty("LABEL_R")
	private String LABEL_R;

	@JsonProperty("PRINT_R")
	private String PRINT_R;

	@JsonProperty("EXCEL_R")
	private String EXCEL_R;

	@JsonProperty("REPLY_R")
	private String REPLY_R;

	@JsonProperty("CMT_R")
	private String CMT_R;

	@JsonProperty("OPTION_A")
	private String OPTION_A;

	@JsonProperty("OPTION_B")
	private String OPTION_B;

	@JsonProperty("CODE_ETC")
	private String CODE_ETC;

	private String auth_code;
	private int    menu_idx = 0;
	private String menu_code;



	public String getAuth_code() {
		return auth_code;
	}
	public void setAuth_code(String auth_code) {
		this.auth_code = auth_code;
	}
	public int getAuth_idx() {
		return auth_idx;
	}
	public void setAuth_idx(int auth_idx) {
		this.auth_idx = auth_idx;
	}
	public int getAD_IDX() {
		return AD_IDX;
	}
	public void setAD_IDX(int aD_IDX) {
		AD_IDX = aD_IDX;
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
	public String getCODE_ETC() {
		return CODE_ETC;
	}
	public void setCODE_ETC(String cODE_ETC) {
		CODE_ETC = cODE_ETC;
	}
	public int getMenu_idx() {
		return menu_idx;
	}
	public void setMenu_idx(int menu_idx) {
		this.menu_idx = menu_idx;
	}
	public String getMenu_code() {
		return menu_code;
	}
	public void setMenu_code(String menu_code) {
		this.menu_code = menu_code;
	}





}
