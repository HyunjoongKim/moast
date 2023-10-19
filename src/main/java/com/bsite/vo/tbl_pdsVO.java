package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.UpdateTimestamp;
/*****************************
*  		게시판 테이블
******************************/
@Entity
@Table(name = "tbl_pds")
@SuppressWarnings("serial")
public class tbl_pdsVO extends PageSearchVO{

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int        pd_pkid = 0;
	
	private String     pd_code;
	private int        adms_state = 0;
	private String     pd_security;
	private String     me_fkid;
	private int        pd_ref = 0;
	private int        pd_step = 0;
	private int        pd_order = 0;
	private String     pd_writer;
	private String     pd_title;
	
	@Column(length = 65535,columnDefinition="Text")
	private String     pd_content;
	
	private int        pd_visited = 0;
	
	@Column(updatable=false)
	@CreationTimestamp
	private Date       pd_regdate;
	
	@Column(insertable=false)
	@UpdateTimestamp
	private Date     pd_lastmodify;
	
	private String     pd_globalip;
	private String     pd_localip;
	private String     pd_email;
	private String     pd_pwd;
	private String     pd_cate;
	private int        pd_n_order = 0;
	
	@Column(length=1, columnDefinition="CHAR", insertable=false)
	private String     pd_querystate;
	
	private String     pd_user;
	private String     pd_tel;
	private int        pd_notice = 0;
	
	@Column(length=1, columnDefinition="CHAR")
	private String     pd_secret;
	
	private int        pd_secret_fkid  = 0;
	private String     atch_file_id;
	private String 		pd_qna_state;	//qna 게시판 답변 상태
	private String 		pd_qna_answer;	//qna 답변
	private String 		pd_email_yn;		//qna email 수신 여부
	private String 		pd_left_code;    //레프트 메뉴 코드

	@Column(name = "cmt_count", insertable=false, updatable=false)
	@Formula(value="(select count(c.tc_pkid) from tbl_comment c where c.site_code=site_code and c.del_yn='N' and c.tc_table='tbl_pds' and c.pd_pkid=pd_pkid and c.pd_code=pd_code)")
	private int        	cmt_count = 0;

	@Column(name = "ext", insertable=false, updatable=false)
	@Formula(value="(select f.file_extsn from comtnfiledetail f where f.atch_file_id=atch_file_id limit 1)")
	private String 		ext; //파일 확장자
	
	@Column(name = "childPkid", insertable=false, updatable=false)
	@Formula(value="(select count(a.pd_pkid) from tbl_pds a WHERE a.pd_querystate <> 'D' and a.site_code=site_code and a.pd_code=pd_code AND a.pd_ref=pd_pkid )")
	private int 		childPkid=0;

	
	@Transient
	private String 		superadmscheckbox = "n";
	@Transient
	private String 		admscheckbox = "n";
	@Transient
	private String 		pd_id;  //아이디
	
	
	
	//===============과제안내,사업안내=================
	private	String		tmp_hw_state;			//[과제안내 ] 분류 
	private	String		tmp_hw_title;			//[과제안내] 세부과제명 
	private	String		tmp_hw_org;				//[과제안내] 주관기관 
	private	String		tmp_hw_jnorg;			//[과제안내] 참여기관 
	private	String		tmp_sdate;				//[과제안내+사업공고] 시작일 
	private	String		tmp_edate;				//[과제안내+사업공고] 종료일 
	private	String		tmp_bs_type;			//[사업공고] 지원유형(공통코드) 
	private	String		tmp_bs_state;			//[사업공고] 진행상태(공통코드) 
	private	String		tmp_bs_part;			//[사업공고] 분류 (공통코드) 
	
	

	//===============//과제안내,사업안내===============

	@Transient
	private String searchCate1 ="";
	@Transient
	private String searchCate2 = "";
	@Transient
	private String searchCate3 = "";
	@Transient
	private String searchBgnDe ="";
	@Transient
	private String searchEndDe = "";
	@Transient
	private String searchCnd = "";
	@Transient
	private String sortOrdr = "";
	@Transient
	private String searchType = "";

	//============== 게시판 속성 ===================
	@Transient
	private String   au_typedirectory;



	//=============== 추가 qustr =================
	@Transient
	private String lmCode = "";
	@Transient
	private String  qustr;
	@Transient
	private String isAdms ="N";


	public String getQustr() {
		return qustr;
	}

	public void setQustr() throws UnsupportedEncodingException {
		String qs = "";
		this.setQueryString(); //set
		qs = this.getQueryString();//get
		//나머지 추가분 여기서 이어나간다.
		qs += "&lmCode="+this.lmCode;
		qs += "&searchCnd="+this.searchCnd;
		qs += "&searchCate1="+this.searchCate1;
		if("Y".equals(this.isAdms)) qs += "&isAdms="+this.isAdms;
		/*
		qs += "&searchArea="+this.searcharea;
		qs += "&searchWline="+this.searchwline;
		qs += "&searchShift="+this.searchshift;
		qs += "&searchPart="+this.searchpart;
		qs += "&searchCate2="+this.searchCate2;
		qs += "&searchCate3="+this.searchCate3;
		qs += "&searchBgnDe="+this.searchBgnDe;
		qs += "&searchEndDe="+this.searchEndDe;

		qs += "&searchWrd="+this.searchWrd;
		qs += "&sortOrdr="+this.sortOrdr;
		qs += "&searchType="+this.searchType;*/
		this.qustr = qs;
	}


	public String getIsAdms() {
		return isAdms;
	}
	public void setIsAdms(String isAdms) {
		this.isAdms = isAdms;
	}
	public int getPd_pkid() {
		return pd_pkid;
	}
	public void setPd_pkid(int pd_pkid) {
		this.pd_pkid = pd_pkid;
	}

	public String getPd_code() {
		return pd_code;
	}
	public void setPd_code(String pd_code) {
		this.pd_code = pd_code;
	}
	public int getAdms_state() {
		return adms_state;
	}
	public void setAdms_state(int adms_state) {
		this.adms_state = adms_state;
	}
	public String getPd_security() {
		return pd_security;
	}
	public void setPd_security(String pd_security) {
		this.pd_security = pd_security;
	}
	public String getMe_fkid() {
		return me_fkid;
	}
	public void setMe_fkid(String me_fkid) {
		this.me_fkid = me_fkid;
	}
	public int getPd_ref() {
		return pd_ref;
	}
	public void setPd_ref(int pd_ref) {
		this.pd_ref = pd_ref;
	}
	public int getPd_step() {
		return pd_step;
	}
	public void setPd_step(int pd_step) {
		this.pd_step = pd_step;
	}
	public int getPd_order() {
		return pd_order;
	}
	public void setPd_order(int pd_order) {
		this.pd_order = pd_order;
	}
	public String getPd_writer() {
		return pd_writer;
	}
	public void setPd_writer(String pd_writer) {
		this.pd_writer = pd_writer;
	}
	public String getPd_title() {
		return pd_title;
	}
	public void setPd_title(String pd_title) {
		this.pd_title = pd_title;
	}
	public String getPd_content() {
		return pd_content;
	}
	public void setPd_content(String pd_content) {
		this.pd_content = pd_content;
	}
	public int getPd_visited() {
		return pd_visited;
	}
	public void setPd_visited(int pd_visited) {
		this.pd_visited = pd_visited;
	}

	public Date getPd_regdate() {
		return pd_regdate;
	}

	public void setPd_regdate(Date pd_regdate) {
		this.pd_regdate = pd_regdate;
	}


	public Date getPd_lastmodify() {
		return pd_lastmodify;
	}

	public void setPd_lastmodify(Date pd_lastmodify) {
		this.pd_lastmodify = pd_lastmodify;
	}

	public String getPd_globalip() {
		return pd_globalip;
	}
	public void setPd_globalip(String pd_globalip) {
		this.pd_globalip = pd_globalip;
	}
	public String getPd_localip() {
		return pd_localip;
	}
	public void setPd_localip(String pd_localip) {
		this.pd_localip = pd_localip;
	}
	public String getPd_email() {
		return pd_email;
	}
	public void setPd_email(String pd_email) {
		this.pd_email = pd_email;
	}
	public String getPd_pwd() {
		return pd_pwd;
	}
	public void setPd_pwd(String pd_pwd) {
		this.pd_pwd = pd_pwd;
	}
	public String getPd_cate() {
		return pd_cate;
	}
	public void setPd_cate(String pd_cate) {
		this.pd_cate = pd_cate;
	}
	public int getPd_n_order() {
		return pd_n_order;
	}
	public void setPd_n_order(int pd_n_order) {
		this.pd_n_order = pd_n_order;
	}
	public String getPd_querystate() {
		return pd_querystate;
	}
	public void setPd_querystate(String pd_querystate) {
		this.pd_querystate = pd_querystate;
	}
	public String getPd_user() {
		return pd_user;
	}
	public void setPd_user(String pd_user) {
		this.pd_user = pd_user;
	}
	public String getPd_tel() {
		return pd_tel;
	}
	public void setPd_tel(String pd_tel) {
		this.pd_tel = pd_tel;
	}
	public int getPd_notice() {
		return pd_notice;
	}
	public void setPd_notice(int pd_notice) {
		this.pd_notice = pd_notice;
	}
	public String getPd_secret() {
		return pd_secret;
	}
	public void setPd_secret(String pd_secret) {
		this.pd_secret = pd_secret;
	}
	public int getPd_secret_fkid() {
		return pd_secret_fkid;
	}
	public void setPd_secret_fkid(int pd_secret_fkid) {
		this.pd_secret_fkid = pd_secret_fkid;
	}
	@Override
	public String getAtch_file_id() {
		return atch_file_id;
	}
	@Override
	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}
	public String getExt() {
		return ext;
	}
	public void setExt(String ext) {
		this.ext = ext;
	}
	public String getSuperadmscheckbox() {
		return superadmscheckbox;
	}
	public void setSuperadmscheckbox(String superadmscheckbox) {
		this.superadmscheckbox = superadmscheckbox;
	}
	public String getAdmscheckbox() {
		return admscheckbox;
	}
	public void setAdmscheckbox(String admscheckbox) {
		this.admscheckbox = admscheckbox;
	}
	public int getCmt_count() {
		return cmt_count;
	}
	public void setCmt_count(int cmt_count) {
		this.cmt_count = cmt_count;
	}
	public String getPd_id() {
		return pd_id;
	}
	public void setPd_id(String pd_id) {
		this.pd_id = pd_id;
	}
	public String getSearchCate1() {
		return searchCate1;
	}
	public void setSearchCate1(String searchCate1) {
		this.searchCate1 = searchCate1;
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
	public String getSearchBgnDe() {
		return searchBgnDe;
	}
	public void setSearchBgnDe(String searchBgnDe) {
		this.searchBgnDe = searchBgnDe;
	}
	public String getSearchEndDe() {
		return searchEndDe;
	}
	public void setSearchEndDe(String searchEndDe) {
		this.searchEndDe = searchEndDe;
	}
	public String getSearchCnd() {
		return searchCnd;
	}
	public void setSearchCnd(String searchCnd) {
		this.searchCnd = searchCnd;
	}
	public String getSortOrdr() {
		return sortOrdr;
	}
	public void setSortOrdr(String sortOrdr) {
		this.sortOrdr = sortOrdr;
	}
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getLmCode() {
		return lmCode;
	}
	public void setLmCode(String lmCode) {
		this.lmCode = lmCode;
	}
	public String getPd_qna_state() {
		return pd_qna_state;
	}
	public void setPd_qna_state(String pd_qna_state) {
		this.pd_qna_state = pd_qna_state;
	}
	public String getPd_qna_answer() {
		return pd_qna_answer;
	}
	public void setPd_qna_answer(String pd_qna_answer) {
		this.pd_qna_answer = pd_qna_answer;
	}
	public String getPd_email_yn() {
		return pd_email_yn;
	}
	public void setPd_email_yn(String pd_email_yn) {
		this.pd_email_yn = pd_email_yn;
	}
	public String getPd_left_code() {
		return pd_left_code;
	}
	public void setPd_left_code(String pd_left_code) {
		this.pd_left_code = pd_left_code;
	}

	public String getAu_typedirectory() {
		return au_typedirectory;
	}

	public void setAu_typedirectory(String au_typedirectory) {
		this.au_typedirectory = au_typedirectory;
	}

	public int getChildPkid() {
		return childPkid;
	}

	public void setChildPkid(int childPkid) {
		this.childPkid = childPkid;
	}

	public String getTmp_hw_state() {
		return tmp_hw_state;
	}

	public void setTmp_hw_state(String tmp_hw_state) {
		this.tmp_hw_state = tmp_hw_state;
	}

	public String getTmp_hw_title() {
		return tmp_hw_title;
	}

	public void setTmp_hw_title(String tmp_hw_title) {
		this.tmp_hw_title = tmp_hw_title;
	}

	public String getTmp_hw_org() {
		return tmp_hw_org;
	}

	public void setTmp_hw_org(String tmp_hw_org) {
		this.tmp_hw_org = tmp_hw_org;
	}

	public String getTmp_hw_jnorg() {
		return tmp_hw_jnorg;
	}

	public void setTmp_hw_jnorg(String tmp_hw_jnorg) {
		this.tmp_hw_jnorg = tmp_hw_jnorg;
	}

	public String getTmp_sdate() {
		return tmp_sdate;
	}

	public void setTmp_sdate(String tmp_sdate) {
		this.tmp_sdate = tmp_sdate;
	}

	public String getTmp_edate() {
		return tmp_edate;
	}

	public void setTmp_edate(String tmp_edate) {
		this.tmp_edate = tmp_edate;
	}

	public String getTmp_bs_type() {
		return tmp_bs_type;
	}

	public void setTmp_bs_type(String tmp_bs_type) {
		this.tmp_bs_type = tmp_bs_type;
	}

	public String getTmp_bs_state() {
		return tmp_bs_state;
	}

	public void setTmp_bs_state(String tmp_bs_state) {
		this.tmp_bs_state = tmp_bs_state;
	}

	public String getTmp_bs_part() {
		return tmp_bs_part;
	}

	public void setTmp_bs_part(String tmp_bs_part) {
		this.tmp_bs_part = tmp_bs_part;
	}



}
