package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.codehaus.jackson.annotate.JsonProperty;
import org.hibernate.annotations.Formula;

import com.bsite.cmm.CommonFunctions;
/*****************************
*  		공통 코드 테이블
******************************/
@Entity
@Table(name = "tbl_common_code")
@SuppressWarnings("serial")
public class CommonCodeVO extends PageSearchVO{
	@Transient
	CommonFunctions cf = new CommonFunctions();

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@JsonProperty
	private int code_idx = 0;		//코드관리일련번호(pk)
	@JsonProperty
	private String code_cate;       //uniq_main
	@JsonProperty
	private String main_code;		//코드    uniq_main ,site_code
	@JsonProperty
	private String code_name;		//코드명
	@JsonProperty
	private String ptrn_code;		//부모코드
	private String gran_code;		//부모의 부모
	@JsonProperty
	private int code_depth = 0;		//depth
	@JsonProperty
	private int code_order = 0;		//순서
	@JsonProperty
	private String code_use;		//사용여부
	private String code_etc;		//비고

	@Transient
	private	String	gran_code_name;	//부모의 부모 코드명

	@Transient
	private	String 	ptrn_code_name;	//부모 코드명

	@Formula("code_idx")
	@JsonProperty
	private String id;        //트리 뷰에 사용될 아이디

	@Formula("code_name")
	@JsonProperty
	private String name;      //트리 뷰에 사용될 타이틀

	@Formula("ptrn_code")
	@JsonProperty
	private String _parentId; //트리 뷰에 사용될 부모코드

	@Transient
	@JsonProperty
	private String text;      //트리에서 사용될 타이틀

	@Transient
	@JsonProperty
	private int maxdepth = 3;  //root 제외 기본 최대 3단계

	@Transient
	@JsonProperty
	private int change_code_order;  // 바꿀 order의 윗 코드 order
	
	@Transient
	private String code_list = "";

	




	public int getMaxdepth() {
		return maxdepth;
	}
	public void setMaxdepth(int maxdepth) {
		this.maxdepth = maxdepth;
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
	public int getCode_idx() {
		return code_idx;
	}
	public void setCode_idx(int code_idx) {
		this.code_idx = code_idx;
	}
	public String getCode_cate() {
		return code_cate;
	}
	public void setCode_cate(String code_cate) {
		this.code_cate = code_cate;
	}
	public String getMain_code() {
		return main_code;
	}
	public void setMain_code(String main_code) {
		this.main_code = main_code;
	}
	public String getCode_name() {
		return code_name;
	}
	public void setCode_name(String code_name) {
		this.code_name = code_name;
	}
	public String getPtrn_code() {
		return ptrn_code;
	}
	public void setPtrn_code(String ptrn_code) {
		this.ptrn_code = ptrn_code;
	}
	public String getGran_code() {
		return gran_code;
	}
	public void setGran_code(String gran_code) {
		this.gran_code = gran_code;
	}
	public int getCode_depth() {
		return code_depth;
	}
	public void setCode_depth(int code_depth) {
		this.code_depth = code_depth;
	}
	public int getCode_order() {
		return code_order;
	}
	public void setCode_order(int code_order) {
		this.code_order = code_order;
	}
	public String getCode_use() {
		return code_use;
	}
	public void setCode_use(String code_use) {
		this.code_use = code_use;
	}
	public String getCode_etc() {
		return code_etc;
	}
	public void setCode_etc(String code_etc) {
		this.code_etc = code_etc;
	}
	public String getGran_code_name() {
		return gran_code_name;
	}
	public void setGran_code_name(String gran_code_name) {
		this.gran_code_name = gran_code_name;
	}
	public String getPtrn_code_name() {
		return ptrn_code_name;
	}
	public void setPtrn_code_name(String ptrn_code_name) {
		this.ptrn_code_name = ptrn_code_name;
	}
	public CommonFunctions getCf() {
		return cf;
	}
	public void setCf(CommonFunctions cf) {
		this.cf = cf;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public int getChange_code_order() {
		return change_code_order;
	}
	public void setChange_code_order(int change_code_order) {
		this.change_code_order = change_code_order;
	}
	public String getCode_list() {
		return code_list;
	}
	public void setCode_list(String code_list) {
		this.code_list = code_list;
	}

	
}
