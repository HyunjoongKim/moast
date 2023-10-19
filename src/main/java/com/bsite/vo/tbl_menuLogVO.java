package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;

@SuppressWarnings("serial")
@Entity
@Table(name = "tbl_menu_log")
public class tbl_menuLogVO extends PageSearchVO{

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int idx;
	private String url;	
	private String infor;	
	private String os;	
	private String browser;	
	
	private int menu_idx;
	private String  cookie_user;
	
	@Transient
	private int cnt = 0;
	@Transient
	private String site_name;
	@Transient
	private String menu_name;
	@Transient
	private String menu_target;		
	@Transient
	private Integer  total;	
	@Transient
	private String ratio;
	
	@Transient
	private int difsecond=0;
	@Transient
	private int sSecond=0;
	
	
	@Transient
	private String search_siteCode;
	@Transient
	private int [] idxArr;
	
	
	public int[] getIdxArr() {
		return idxArr;
	}
	public void setIdxArr(int[] idxArr) {
		this.idxArr = idxArr;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public int getDifsecond() {
		return difsecond;
	}
	public void setDifsecond(int difsecond) {
		this.difsecond = difsecond;
	}
	public int getsSecond() {
		return sSecond;
	}
	public void setsSecond(int sSecond) {
		this.sSecond = sSecond;
	}
	public int getMenu_idx() {
		return menu_idx;
	}
	public void setMenu_idx(int menu_idx) {
		this.menu_idx = menu_idx;
	}
	public String getCookie_user() {
		return cookie_user;
	}
	public void setCookie_user(String cookie_user) {
		this.cookie_user = cookie_user;
	}
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getInfor() {
		return infor;
	}
	public void setInfor(String infor) {
		this.infor = infor;
	}
	public String getOs() {
		return os;
	}
	public void setOs(String os) {
		this.os = os;
	}
	public String getBrowser() {
		return browser;
	}
	public void setBrowser(String browser) {
		this.browser = browser;
	}
	
	public String getSearch_siteCode() {
		return search_siteCode;
	}
	public void setSearch_siteCode(String search_siteCode) {
		this.search_siteCode = search_siteCode;
	}

	public Integer  getTotal() {
		return total;
	}
	public void setTotal(Integer  total) {
		this.total = total;
	}
	public String getRatio() {
		return ratio;
	}
	public void setRatio(String ratio) {
		this.ratio = ratio;
	}
	public String getMenu_name() {
		return menu_name;
	}
	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}
	public String getMenu_target() {
		return menu_target;
	}
	public void setMenu_target(String menu_target) {
		this.menu_target = menu_target;
	}
	
	public String getSite_name() {
		return site_name;
	}
	public void setSite_name(String site_name) {
		this.site_name = site_name;
	}
	
}