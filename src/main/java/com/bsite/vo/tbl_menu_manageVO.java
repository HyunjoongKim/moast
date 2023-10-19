package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
/*****************************
*  		메뉴 관리 테이블
******************************/
@Entity
@Table(name = "tbl_menu_manage")
@SuppressWarnings("serial")
public class tbl_menu_manageVO extends PageSearchVO {

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int    menu_idx = 0;


	private String menu_code;


	private String ptrn_code;


	private String menu_head;


	private String menu_name;


	private String menu_url;


	private String menu_url_patn;


	private String menu_depth;


	private int    menu_ordr = 0;


	private String menu_view;


	private String menu_target;


	private String is_board ="N";  //게시판유형이면y


	@Transient
	private int maxdepth = 4;      //root 제외 기본 최대 3단계

	@Transient
	private String id;        //트리 뷰에 사용될 아이디

	@Transient
	private String name;      //트리 뷰에 사용될 타이틀

	@Transient
	private String _parentId; //트리 뷰에 사용될 부모코드




	public int getMenu_idx() {
		return menu_idx;
	}
	public void setMenu_idx(int menu_idx) {
		this.menu_idx = menu_idx;
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
	public String get_parentId() {
		return _parentId;
	}
	public void set_parentId(String _parentId) {
		this._parentId = _parentId;
	}
	public int getMaxdepth() {
		return maxdepth;
	}
	public void setMaxdepth(int maxdepth) {
		this.maxdepth = maxdepth;
	}
	public String getMenu_code() {
		return menu_code;
	}
	public void setMenu_code(String menu_code) {
		this.menu_code = menu_code;
	}
	public String getPtrn_code() {
		return ptrn_code;
	}
	public void setPtrn_code(String ptrn_code) {
		this.ptrn_code = ptrn_code;
	}
	public String getMenu_head() {
		return menu_head;
	}
	public void setMenu_head(String menu_head) {
		this.menu_head = menu_head;
	}
	public String getMenu_name() {
		return menu_name;
	}
	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}
	public String getMenu_url() {
		return menu_url;
	}
	public void setMenu_url(String menu_url) {
		this.menu_url = menu_url;
	}
	public String getMenu_url_patn() {
		return menu_url_patn;
	}
	public void setMenu_url_patn(String menu_url_patn) {
		this.menu_url_patn = menu_url_patn;
	}
	public String getMenu_depth() {
		return menu_depth;
	}
	public void setMenu_depth(String menu_depth) {
		this.menu_depth = menu_depth;
	}
	public int getMenu_ordr() {
		return menu_ordr;
	}
	public void setMenu_ordr(int menu_ordr) {
		this.menu_ordr = menu_ordr;
	}
	public String getMenu_view() {
		return menu_view;
	}
	public void setMenu_view(String menu_view) {
		this.menu_view = menu_view;
	}
	public String getMenu_target() {
		return menu_target;
	}
	public void setMenu_target(String menu_target) {
		this.menu_target = menu_target;
	}
	public String getIs_board() {
		return is_board;
	}
	public void setIs_board(String is_board) {
		this.is_board = is_board;
	}




}
