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

@Entity
@Table(name = "tbl_site_log")
public class tbl_siteLogVO extends PageSearchVO{

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int idx;	
	private String infor;	
	private String os;	
	private String browser;	
	private String cookie_user;
	
	
	@Transient
	private int xright;
	@Transient
	private float  xmin=0f;	
	@Transient
	private float  xmax=0f;	
	@Transient
	private float  xavg=0f;	
	@Transient
	private String title;
	@Transient
	private int  cnt=0;
	@Transient
	private String cdate;
	@Transient
	private String site_name;
	@Transient
	private Integer  total;	
	@Transient
	private String ratio;	
	@Transient
	private String search_siteCode;	
	@Transient
	private String search_date;
	@Transient
	private String log_year;
	@Transient
	private String log_month;
	@Transient
	private String log_days;
	@Transient
	private String log_time; 
	
	@Transient
	private int difsecond=0;
	@Transient
	private int sSecond=0;
	
	
	
	public int getXright() {
		return xright;
	}
	public void setXright(int xright) {
		this.xright = xright;
	}
	public float getXmin() {
		return xmin;
	}
	public void setXmin(float xmin) {
		this.xmin = xmin;
	}
	public float getXmax() {
		return xmax;
	}
	public void setXmax(float xmax) {
		this.xmax = xmax;
	}
	public float getXavg() {
		return xavg;
	}
	public void setXavg(float xavg) {
		this.xavg = xavg;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
	public String getSite_name() {
		return site_name;
	}
	public void setSite_name(String site_name) {
		this.site_name = site_name;
	}
	
	public String getSearch_date() {
		return search_date;
	}
	public void setSearch_date(String search_date) {
		this.search_date = search_date;
	}
	
	public String getCdate() {
		return cdate;
	}
	public void setCdate(String cdate) {
		this.cdate = cdate;
	}
	public String getLog_year() {
		return log_year;
	}
	public void setLog_year(String log_year) {
		this.log_year = log_year;
	}
	public String getLog_month() {
		return log_month;
	}
	public void setLog_month(String log_month) {
		this.log_month = log_month;
	}
	public String getLog_days() {
		return log_days;
	}
	public void setLog_days(String log_days) {
		this.log_days = log_days;
	}
	public String getLog_time() {
		return log_time;
	}
	public void setLog_time(String log_time) {
		this.log_time = log_time;
	}
	
}