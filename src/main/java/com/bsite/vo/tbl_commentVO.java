package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Formula;
/*****************************
*  		게시판 코멘트 테이블
******************************/
@Entity
@Table(name = "tbl_comment")
@SuppressWarnings("serial")
public class tbl_commentVO extends PageSearchVO{
	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int tc_pkid = 0;
	
	private String tc_table;
	private int pd_pkid;
	private String pd_id;
	private String pd_code;
	private String tc_title;
	@Column(length = 65535,columnDefinition="Text")
	private String tc_cont;
	private String atch_file_id;
	
	@Transient
	private String lmCode;
	@Transient
	private boolean create_r;
	@Transient
	private boolean update_r;
	@Transient
	private boolean delete_r;

	@Formula(value="cret_id")
	private String cret_name;

	public int getTc_pkid() {
		return tc_pkid;
	}

	public void setTc_pkid(int tc_pkid) {
		this.tc_pkid = tc_pkid;
	}

	public String getTc_table() {
		return tc_table;
	}

	public void setTc_table(String tc_table) {
		this.tc_table = tc_table;
	}

	public int getPd_pkid() {
		return pd_pkid;
	}

	public void setPd_pkid(int pd_pkid) {
		this.pd_pkid = pd_pkid;
	}

	public String getPd_id() {
		return pd_id;
	}

	public void setPd_id(String pd_id) {
		this.pd_id = pd_id;
	}

	public String getPd_code() {
		return pd_code;
	}

	public void setPd_code(String pd_code) {
		this.pd_code = pd_code;
	}



	public String getLmCode() {
		return lmCode;
	}

	public void setLmCode(String lmCode) {
		this.lmCode = lmCode;
	}

	public String getTc_title() {
		return tc_title;
	}

	public void setTc_title(String tc_title) {
		this.tc_title = tc_title;
	}

	public String getTc_cont() {
		return tc_cont;
	}

	public void setTc_cont(String tc_cont) {
		this.tc_cont = tc_cont;
	}

	public String getAtch_file_id() {
		return atch_file_id;
	}

	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}

	public boolean isCreate_r() {
		return create_r;
	}

	public void setCreate_r(boolean create_r) {
		this.create_r = create_r;
	}

	public boolean isUpdate_r() {
		return update_r;
	}

	public void setUpdate_r(boolean update_r) {
		this.update_r = update_r;
	}

	public boolean isDelete_r() {
		return delete_r;
	}

	public void setDelete_r(boolean delete_r) {
		this.delete_r = delete_r;
	}

	public String getCret_name() {
		return cret_name;
	}

	public void setCret_name(String cret_name) {
		this.cret_name = cret_name;
	}
	
	
	
	
	
	
}
