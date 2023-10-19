package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
/*****************************
*  		게시판 속성 관리 테이블
******************************/
@Entity
@Table(name = "tbl_authcommon")
@SuppressWarnings("serial")
public class tbl_authcommonVO extends PageSearchVO {

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int      au_pkid = 0;

	private String   au_title;

	private String   ag_code;

	private String   au_type;

	private int      au_sort = 0;

	private String   au_typedirectory;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_secret_yn;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_reply_yn;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_memo_yn;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_category_yn;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_category2_yn;

	private int      au_listcount = 0;

	private int      au_pagescale = 0;

	private int      au_filesize = 0;

	private String   au_admin;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_thum_yn;

	private String   au_thum_width;

	private String   au_thum_height;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_addfile_yn;

	private int      au_file_count = 0;

	@Column(length=1, columnDefinition="CHAR")
	private String   au_edit_yn;

	private String   au_left_menu_code;

	private String 	 au_cate_list;
	
	@Column(length = 65535,columnDefinition="Text")
	private String 	 au_board_adms;

	@Transient
	private String  qustr;


	public String getQustr() {
		return qustr;
	}
	public void setQustr() throws UnsupportedEncodingException {
		String qs = "";
		this.setQueryString(); //set
		qs = this.getQueryString();//get
		//나머지 추가분 여기서 이어나간다.


		this.qustr = qs;
	}





	public String getAu_board_adms() {
		return au_board_adms;
	}
	public void setAu_board_adms(String au_board_adms) {
		this.au_board_adms = au_board_adms;
	}
	public int getAu_pkid() {
		return au_pkid;
	}
	public void setAu_pkid(int au_pkid) {
		this.au_pkid = au_pkid;
	}
	public String getAu_title() {
		return au_title;
	}
	public void setAu_title(String au_title) {
		this.au_title = au_title;
	}
	public String getAg_code() {
		return ag_code;
	}
	public void setAg_code(String ag_code) {
		this.ag_code = ag_code;
	}
	public String getAu_type() {
		return au_type;
	}
	public void setAu_type(String au_type) {
		this.au_type = au_type;
	}
	public int getAu_sort() {
		return au_sort;
	}
	public void setAu_sort(int au_sort) {
		this.au_sort = au_sort;
	}
	public String getAu_typedirectory() {
		return au_typedirectory;
	}
	public void setAu_typedirectory(String au_typedirectory) {
		this.au_typedirectory = au_typedirectory;
	}
	public String getAu_secret_yn() {
		return au_secret_yn;
	}
	public void setAu_secret_yn(String au_secret_yn) {
		this.au_secret_yn = au_secret_yn;
	}
	public String getAu_reply_yn() {
		return au_reply_yn;
	}
	public void setAu_reply_yn(String au_reply_yn) {
		this.au_reply_yn = au_reply_yn;
	}
	public String getAu_memo_yn() {
		return au_memo_yn;
	}
	public void setAu_memo_yn(String au_memo_yn) {
		this.au_memo_yn = au_memo_yn;
	}
	public String getAu_category_yn() {
		return au_category_yn;
	}
	public void setAu_category_yn(String au_category_yn) {
		this.au_category_yn = au_category_yn;
	}
	public String getAu_category2_yn() {
		return au_category2_yn;
	}
	public void setAu_category2_yn(String au_category2_yn) {
		this.au_category2_yn = au_category2_yn;
	}
	public int getAu_listcount() {
		return au_listcount;
	}
	public void setAu_listcount(int au_listcount) {
		this.au_listcount = au_listcount;
	}
	public int getAu_pagescale() {
		return au_pagescale;
	}
	public void setAu_pagescale(int au_pagescale) {
		this.au_pagescale = au_pagescale;
	}
	public int getAu_filesize() {
		return au_filesize;
	}
	public void setAu_filesize(int au_filesize) {
		this.au_filesize = au_filesize;
	}
	public String getAu_admin() {
		return au_admin;
	}
	public void setAu_admin(String au_admin) {
		this.au_admin = au_admin;
	}
	public String getAu_thum_yn() {
		return au_thum_yn;
	}
	public void setAu_thum_yn(String au_thum_yn) {
		this.au_thum_yn = au_thum_yn;
	}
	public String getAu_thum_width() {
		return au_thum_width;
	}
	public void setAu_thum_width(String au_thum_width) {
		this.au_thum_width = au_thum_width;
	}
	public String getAu_thum_height() {
		return au_thum_height;
	}
	public void setAu_thum_height(String au_thum_height) {
		this.au_thum_height = au_thum_height;
	}
	public String getAu_addfile_yn() {
		return au_addfile_yn;
	}
	public void setAu_addfile_yn(String au_addfile_yn) {
		this.au_addfile_yn = au_addfile_yn;
	}
	public int getAu_file_count() {
		return au_file_count;
	}
	public void setAu_file_count(int au_file_count) {
		this.au_file_count = au_file_count;
	}
	public String getAu_edit_yn() {
		return au_edit_yn;
	}
	public void setAu_edit_yn(String au_edit_yn) {
		this.au_edit_yn = au_edit_yn;
	}
	public String getAu_left_menu_code() {
		return au_left_menu_code;
	}
	public void setAu_left_menu_code(String au_left_menu_code) {
		this.au_left_menu_code = au_left_menu_code;
	}
	public String getAu_cate_list() {
		return au_cate_list;
	}
	public void setAu_cate_list(String au_cate_list) {
		this.au_cate_list = au_cate_list;
	}

}
