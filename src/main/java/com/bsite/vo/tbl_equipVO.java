package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Formula;

/*****************************
*  		공동활용장비
******************************/
@Entity
@Table(name = "tbl_equip")
@SuppressWarnings("serial")
public class tbl_equipVO extends PageSearchVO implements Serializable{
	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	private	int		eq_idx=0;			//	키

	private	String	eq_name;			//	장비명
	private	String	eq_name_en;			//	영문 장비명
	private	String	eq_maker;			//	제작사명
	private	String	eq_model;			//	모델명
	private	String	eq_cate;			//	표준분류
	private	String	eq_ym;				//	구축년월
	private	String	eq_org;				//	지원기관
	private	String	eq_org_post;		//	지원기관 우편번호
	private	String	eq_org_addr1;		//	지원기관 주소
	private	String	eq_org_addr2;		//	지원기관 상세주소
	private	String	eq_manager;			//	담당자
	private	String	eq_tel;				//	문의전화
	private	String	eq_email;			//	이메일
	@Column(length = 65535,columnDefinition="Text")
	private	String	eq_explan;			//	장비설명

	@Formula("FN_CODE_NAME('default', site_code ,'737' ,eq_cate)")
	private String eq_cate_name;          // 신청상태 
	
	private String atch_file_id;

	@Transient
	private	String	searchCate	="";
	@Transient
	private	String	searchCate2	="";
	@Transient
	private	String	searchCate3	="";
	@Transient
	private	String	searchCate4	="";
	
	@Transient
	private String searchWrdTOT="";
	
	@Transient
	private String qustr;
	

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		qs += "&searchCate="+this.searchCate;
		qs += "&searchCate2="+this.searchCate2;
		qs += "&searchCate3="+this.searchCate3;
		qs += "&searchCate4="+this.searchCate4;
		qs += "&searchWrdTOT="+URLEncoder.encode(this.searchWrdTOT, "UTF-8");
		this.qustr = qs;
	}

	public String getSearchCate2() {
		return searchCate2;
	}

	public void setSearchCate2(String searchCate2) {
		this.searchCate2 = searchCate2;
	}

	public String getSearchCate3() {
		return searchCate3;
	}

	public void setSearchCate3(String searchCate3) {
		this.searchCate3 = searchCate3;
	}

	public String getSearchCate4() {
		return searchCate4;
	}

	public void setSearchCate4(String searchCate4) {
		this.searchCate4 = searchCate4;
	}

	public String getSearchWrdTOT() {
		return searchWrdTOT;
	}

	public void setSearchWrdTOT(String searchWrdTOT) {
		this.searchWrdTOT = searchWrdTOT;
	}

	public String getQustr() {
		return qustr;
	}

	public int getEq_idx() {
		return eq_idx;
	}

	public void setEq_idx(int eq_idx) {
		this.eq_idx = eq_idx;
	}

	public String getEq_name() {
		return eq_name;
	}

	public void setEq_name(String eq_name) {
		this.eq_name = eq_name;
	}

	public String getEq_name_en() {
		return eq_name_en;
	}

	public void setEq_name_en(String eq_name_en) {
		this.eq_name_en = eq_name_en;
	}

	public String getEq_maker() {
		return eq_maker;
	}

	public void setEq_maker(String eq_maker) {
		this.eq_maker = eq_maker;
	}

	public String getEq_model() {
		return eq_model;
	}

	public void setEq_model(String eq_model) {
		this.eq_model = eq_model;
	}

	public String getEq_cate() {
		return eq_cate;
	}

	public void setEq_cate(String eq_cate) {
		this.eq_cate = eq_cate;
	}

	public String getEq_ym() {
		return eq_ym;
	}

	public void setEq_ym(String eq_ym) {
		this.eq_ym = eq_ym;
	}

	public String getEq_org() {
		return eq_org;
	}

	public void setEq_org(String eq_org) {
		this.eq_org = eq_org;
	}

	public String getEq_org_post() {
		return eq_org_post;
	}

	public void setEq_org_post(String eq_org_post) {
		this.eq_org_post = eq_org_post;
	}

	public String getEq_org_addr1() {
		return eq_org_addr1;
	}

	public void setEq_org_addr1(String eq_org_addr1) {
		this.eq_org_addr1 = eq_org_addr1;
	}

	public String getEq_org_addr2() {
		return eq_org_addr2;
	}

	public void setEq_org_addr2(String eq_org_addr2) {
		this.eq_org_addr2 = eq_org_addr2;
	}

	public String getEq_manager() {
		return eq_manager;
	}

	public void setEq_manager(String eq_manager) {
		this.eq_manager = eq_manager;
	}

	public String getEq_tel() {
		return eq_tel;
	}

	public void setEq_tel(String eq_tel) {
		this.eq_tel = eq_tel;
	}

	public String getEq_email() {
		return eq_email;
	}

	public void setEq_email(String eq_email) {
		this.eq_email = eq_email;
	}

	public String getEq_explan() {
		return eq_explan;
	}

	public void setEq_explan(String eq_explan) {
		this.eq_explan = eq_explan;
	}

	public String getSearchCate() {
		return searchCate;
	}

	public void setSearchCate(String searchCate) {
		this.searchCate = searchCate;
	}

	public String getEq_cate_name() {
		return eq_cate_name;
	}

	public void setEq_cate_name(String eq_cate_name) {
		this.eq_cate_name = eq_cate_name;
	}

	public String getAtch_file_id() {
		return atch_file_id;
	}

	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}
	
	
	

}
