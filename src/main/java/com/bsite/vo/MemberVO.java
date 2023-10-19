package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Formula;

import com.bsite.vo.member.PageSearchMBVO;
/*****************************
*  		회원 관리 테이블
******************************/
@Entity
@Table(name = "tbl_member")
@SuppressWarnings("serial")
public class MemberVO extends PageSearchMBVO implements Serializable{

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private	int		me_idx	=0;				//	회원 일련번호
	private	String	me_id	="";			//	아이디
	private	String	me_pwd	="";			//	비밀번호
	private	String	me_name	="";			//	이름
		
	private	String	auth_code	="";		//	권한
	@Column(name = "me_latest_login",insertable=false)
	private	Date	me_latest_login;	//	최종 로그인
	private	String	me_email	="";		//	이메일
	private	String	me_tel	="";			//	연락처
	private	String	me_email_yn	="";		//	이메일 수신여부
	private String	me_type="";				//	회원구분	
	private	String	me_enname	="";		//	영문명
	private	String	me_phone	="";		//	핸드폰
	private	String	me_agency	="";		//	기관명
	private	String	me_department	="";	//	외부부서명
	private	String	me_departcode	="";	//	부서코드
	private	String	me_postno	="";		//	우편번호
	private	String	me_address1	="";		//	주소
	private	String	me_address2	="";		//	상세주소
	private	String	atch_file_id;
	private String  me_repo_code;            //  수장고담당자 유형
	private String  me_fbcc_appr;            //  기탁 결재 권한여부 Y/N
	
	private String  me_is_cert;             //  인증여부 (Y/N)
	private int  	me_fail_cnt=0;          //  로그인 실패 횟수 
	private String  me_is_login;            //  로그인 가능 여부 (Y/N) 
	private String  me_cert_key;            //  인증 키 
	
	private	String me_agency_type="";		//직업
	private	String me_position="";			//직책
	
	
	

	@Formula("FN_AUTH_NAME(auth_code, site_code)")
	@Column(name = "auth_name",insertable=false,updatable=false)
	private	String	auth_name	="";		//	권한명

	@Formula("FN_CODE_NAME('default', site_code ,'414' ,me_type)")
	@Column(name = "me_type_nm",insertable=false,updatable=false)
	private String	me_type_nm="";				//	회원구분
	
	
	
	
	//============================ sj project =================================
	private String tmp_me_bth     ;  //(10)'[기본정보]생년월일.',
	private String tmp_org_name   ;  //(150)'[소속및전공]기관명.',
	private String tmp_camp_name  ;  //(150)'[소속및전공]분교/캠퍼스 명.',
	private String tmp_sc_name    ;  //(150)'[소속및전공]전공명',
	private String tmp_sc_name_dt ;  //(150)'[소속및전공]세부전공명.',
	private String tmp_lab_name   ;  //(150)'[연구실(LAB)]연구실명.',
	private String tmp_lab_cate1  ;  //(30)'[연구실(LAB)]연구분야 대분류.',
	private String tmp_lab_cate2  ;  //(30)'[연구실(LAB)]연구분야 중분류.',
	private String tmp_lab_cate3  ;  //(30)'[연구실(LAB)]연구분야 소분류.',
	private String tmp_lab_dv_type;  //(150)'[연구실(LAB)]주요연구분야.',
	private String tmp_lab_dv_name;  //(250)'[연구실(LAB)]연구명.',
	private String tmp_lab_dv_tel ;  //(20)'[연락처]연구실전화.',
	private String tmp_lab_dv_fax ;  //(20)'[연락처]팩스번호.',
	
	
	@Transient
	private String tmp_lab_dv_tel1;
	@Transient
	private String tmp_lab_dv_tel2;
	@Transient
	private String tmp_lab_dv_tel3;
	
	@Transient
	private String tmp_lab_dv_fax1;
	@Transient
	private String tmp_lab_dv_fax2;
	@Transient
	private String tmp_lab_dv_fax3;
	
	@Formula("FN_CODE_NAME('default', site_code ,'698' ,tmp_lab_cate1)")
	@Column(name = "tmp_lab_cate1_name",insertable=false,updatable=false)
	private String tmp_lab_cate1_name  ;  
	@Formula("FN_CODE_NAME('default', site_code ,'701' ,tmp_lab_cate2)")
	@Column(name = "tmp_lab_cate2_name",insertable=false,updatable=false)
	private String tmp_lab_cate2_name  ; 
	//============================ sj project =================================
	
	@Transient
	private String popType="N";
	@Transient
	private String isPopup="N";
	@Transient
	private String res_idx_id="";       //popup리턴 키 아이디
	@Transient
	private String res_title_id="";     //popup리턴 키 타이틀 
	@Transient
	private String trIdx=""; 
	

	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		if("Y".equals(this.isPopup)){ //팝업때만
			qs += "&isPopup="+this.isPopup; 
			qs += "&res_idx_id="+this.res_idx_id; 
			qs += "&res_title_id="+this.res_title_id;
			qs += "&trIdx="+this.trIdx;
		}		
		this.qustr = qs;
	}

	
	public String getTmp_lab_cate1_name() {
		return tmp_lab_cate1_name;
	}


	public String getTrIdx() {
		return trIdx;
	}


	public void setTrIdx(String trIdx) {
		this.trIdx = trIdx;
	}


	public String getIsPopup() {
		return isPopup;
	}


	public void setIsPopup(String isPopup) {
		this.isPopup = isPopup;
	}


	public void setTmp_lab_cate1_name(String tmp_lab_cate1_name) {
		this.tmp_lab_cate1_name = tmp_lab_cate1_name;
	}


	public String getTmp_lab_cate2_name() {
		return tmp_lab_cate2_name;
	}


	public String getRes_idx_id() {
		return res_idx_id;
	}


	public void setRes_idx_id(String res_idx_id) {
		this.res_idx_id = res_idx_id;
	}


	public String getRes_title_id() {
		return res_title_id;
	}


	public void setRes_title_id(String res_title_id) {
		this.res_title_id = res_title_id;
	}


	public void setTmp_lab_cate2_name(String tmp_lab_cate2_name) {
		this.tmp_lab_cate2_name = tmp_lab_cate2_name;
	}


	public String getPopType() {
		return popType;
	}


	public void setPopType(String popType) {
		this.popType = popType;
	}


	public String getTmp_lab_dv_tel1() {
		return tmp_lab_dv_tel1;
	}


	public void setTmp_lab_dv_tel1(String tmp_lab_dv_tel1) {
		this.tmp_lab_dv_tel1 = tmp_lab_dv_tel1;
	}


	public String getTmp_lab_dv_tel2() {
		return tmp_lab_dv_tel2;
	}


	public void setTmp_lab_dv_tel2(String tmp_lab_dv_tel2) {
		this.tmp_lab_dv_tel2 = tmp_lab_dv_tel2;
	}


	public String getTmp_lab_dv_tel3() {
		return tmp_lab_dv_tel3;
	}


	public void setTmp_lab_dv_tel3(String tmp_lab_dv_tel3) {
		this.tmp_lab_dv_tel3 = tmp_lab_dv_tel3;
	}


	public String getTmp_lab_dv_fax1() {
		return tmp_lab_dv_fax1;
	}


	public void setTmp_lab_dv_fax1(String tmp_lab_dv_fax1) {
		this.tmp_lab_dv_fax1 = tmp_lab_dv_fax1;
	}


	public String getTmp_lab_dv_fax2() {
		return tmp_lab_dv_fax2;
	}


	public void setTmp_lab_dv_fax2(String tmp_lab_dv_fax2) {
		this.tmp_lab_dv_fax2 = tmp_lab_dv_fax2;
	}


	public String getTmp_lab_dv_fax3() {
		return tmp_lab_dv_fax3;
	}


	public void setTmp_lab_dv_fax3(String tmp_lab_dv_fax3) {
		this.tmp_lab_dv_fax3 = tmp_lab_dv_fax3;
	}


	public String getTmp_me_bth() {
		return tmp_me_bth;
	}


	public void setTmp_me_bth(String tmp_me_bth) {
		this.tmp_me_bth = tmp_me_bth;
	}


	public String getTmp_org_name() {
		return tmp_org_name;
	}


	public void setTmp_org_name(String tmp_org_name) {
		this.tmp_org_name = tmp_org_name;
	}


	public String getTmp_camp_name() {
		return tmp_camp_name;
	}


	public void setTmp_camp_name(String tmp_camp_name) {
		this.tmp_camp_name = tmp_camp_name;
	}


	public String getTmp_sc_name() {
		return tmp_sc_name;
	}


	public void setTmp_sc_name(String tmp_sc_name) {
		this.tmp_sc_name = tmp_sc_name;
	}


	public String getTmp_sc_name_dt() {
		return tmp_sc_name_dt;
	}


	public void setTmp_sc_name_dt(String tmp_sc_name_dt) {
		this.tmp_sc_name_dt = tmp_sc_name_dt;
	}


	public String getTmp_lab_name() {
		return tmp_lab_name;
	}


	public void setTmp_lab_name(String tmp_lab_name) {
		this.tmp_lab_name = tmp_lab_name;
	}


	public String getTmp_lab_cate1() {
		return tmp_lab_cate1;
	}


	public void setTmp_lab_cate1(String tmp_lab_cate1) {
		this.tmp_lab_cate1 = tmp_lab_cate1;
	}


	public String getTmp_lab_cate2() {
		return tmp_lab_cate2;
	}


	public void setTmp_lab_cate2(String tmp_lab_cate2) {
		this.tmp_lab_cate2 = tmp_lab_cate2;
	}


	public String getTmp_lab_cate3() {
		return tmp_lab_cate3;
	}


	public void setTmp_lab_cate3(String tmp_lab_cate3) {
		this.tmp_lab_cate3 = tmp_lab_cate3;
	}


	public String getTmp_lab_dv_type() {
		return tmp_lab_dv_type;
	}


	public void setTmp_lab_dv_type(String tmp_lab_dv_type) {
		this.tmp_lab_dv_type = tmp_lab_dv_type;
	}


	public String getTmp_lab_dv_name() {
		return tmp_lab_dv_name;
	}


	public void setTmp_lab_dv_name(String tmp_lab_dv_name) {
		this.tmp_lab_dv_name = tmp_lab_dv_name;
	}


	public String getTmp_lab_dv_tel() {
		return tmp_lab_dv_tel;
	}


	public void setTmp_lab_dv_tel(String tmp_lab_dv_tel) {
		this.tmp_lab_dv_tel = tmp_lab_dv_tel;
	}


	public String getTmp_lab_dv_fax() {
		return tmp_lab_dv_fax;
	}


	public void setTmp_lab_dv_fax(String tmp_lab_dv_fax) {
		this.tmp_lab_dv_fax = tmp_lab_dv_fax;
	}


	

	public String getMe_repo_code() {
		return me_repo_code;
	}


	public void setMe_repo_code(String me_repo_code) {
		this.me_repo_code = me_repo_code;
	}

	

	public String getQustr() {
		return qustr;
	}

	public int getMe_idx() {
		return me_idx;
	}

	public void setMe_idx(int me_idx) {
		this.me_idx = me_idx;
	}

	public String getMe_id() {
		return me_id;
	}

	public void setMe_id(String me_id) {
		this.me_id = me_id;
	}

	public String getMe_pwd() {
		return me_pwd;
	}

	public void setMe_pwd(String me_pwd) {
		this.me_pwd = me_pwd;
	}

	public String getMe_name() {
		return me_name;
	}

	public void setMe_name(String me_name) {
		this.me_name = me_name;
	}

	public String getAuth_code() {
		return auth_code;
	}

	public void setAuth_code(String auth_code) {
		this.auth_code = auth_code;
	}

	public String getAuth_name() {
		return auth_name;
	}

	public void setAuth_name(String auth_name) {
		this.auth_name = auth_name;
	}



	public Date getMe_latest_login() {
		return me_latest_login;
	}

	public void setMe_latest_login(Date me_latest_login) {
		this.me_latest_login = me_latest_login;
	}

	public String getMe_email() {
		return me_email;
	}

	public void setMe_email(String me_email) {
		this.me_email = me_email;
	}

	public String getMe_tel() {
		return me_tel;
	}

	public void setMe_tel(String me_tel) {
		this.me_tel = me_tel;
	}

	public String getMe_email_yn() {
		return me_email_yn;
	}

	public void setMe_email_yn(String me_email_yn) {
		this.me_email_yn = me_email_yn;
	}

	public String getMe_type() {
		return me_type;
	}

	public void setMe_type(String me_type) {
		this.me_type = me_type;
	}

	public String getMe_type_nm() {
		return me_type_nm;
	}

	public void setMe_type_nm(String me_type_nm) {
		this.me_type_nm = me_type_nm;
	}

	public String getMe_enname() {
		return me_enname;
	}


	public void setMe_enname(String me_enname) {
		this.me_enname = me_enname;
	}


	public String getMe_phone() {
		return me_phone;
	}


	public void setMe_phone(String me_phone) {
		this.me_phone = me_phone;
	}


	public String getMe_agency() {
		return me_agency;
	}


	public void setMe_agency(String me_agency) {
		this.me_agency = me_agency;
	}


	public String getMe_department() {
		return me_department;
	}


	public void setMe_department(String me_department) {
		this.me_department = me_department;
	}


	public String getMe_departcode() {
		return me_departcode;
	}


	public void setMe_departcode(String me_departcode) {
		this.me_departcode = me_departcode;
	}


	public String getMe_postno() {
		return me_postno;
	}


	public void setMe_postno(String me_postno) {
		this.me_postno = me_postno;
	}


	public String getMe_address1() {
		return me_address1;
	}


	public void setMe_address1(String me_address1) {
		this.me_address1 = me_address1;
	}


	public String getMe_address2() {
		return me_address2;
	}


	public void setMe_address2(String me_address2) {
		this.me_address2 = me_address2;
	}


	public String getAtch_file_id() {
		return atch_file_id;
	}

	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}


	public String getMe_fbcc_appr() {
		return me_fbcc_appr;
	}


	public void setMe_fbcc_appr(String me_fbcc_appr) {
		this.me_fbcc_appr = me_fbcc_appr;
	}


	public String getMe_is_cert() {
		return me_is_cert;
	}


	public void setMe_is_cert(String me_is_cert) {
		this.me_is_cert = me_is_cert;
	}


	public int getMe_fail_cnt() {
		return me_fail_cnt;
	}


	public void setMe_fail_cnt(int me_fail_cnt) {
		this.me_fail_cnt = me_fail_cnt;
	}


	public String getMe_is_login() {
		return me_is_login;
	}


	public void setMe_is_login(String me_is_login) {
		this.me_is_login = me_is_login;
	}


	public String getMe_cert_key() {
		return me_cert_key;
	}


	public void setMe_cert_key(String me_cert_key) {
		this.me_cert_key = me_cert_key;
	}


	public String getMe_agency_type() {
		return me_agency_type;
	}


	public void setMe_agency_type(String me_agency_type) {
		this.me_agency_type = me_agency_type;
	}


	public String getMe_position() {
		return me_position;
	}


	public void setMe_position(String me_position) {
		this.me_position = me_position;
	}



}
