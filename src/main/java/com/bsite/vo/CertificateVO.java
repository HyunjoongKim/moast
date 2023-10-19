package com.bsite.vo;

import java.io.Serializable;

@SuppressWarnings("serial")
public class CertificateVO implements Serializable {
	private int rd_idx = 0;
	private String name;
	private String regYear;
	private String regMonth;
	private String regDay;
	private String resName;
	private String resNo;
	private String certYear;
	private String certMonth;
	private String certDay;
	private String rootPath;

	public int getRd_idx() {
		return rd_idx;
	}

	public void setRd_idx(int rd_idx) {
		this.rd_idx = rd_idx;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getRegYear() {
		return regYear;
	}

	public void setRegYear(String regYear) {
		this.regYear = regYear;
	}

	public String getRegMonth() {
		return regMonth;
	}

	public void setRegMonth(String regMonth) {
		this.regMonth = regMonth;
	}

	public String getRegDay() {
		return regDay;
	}

	public void setRegDay(String regDay) {
		this.regDay = regDay;
	}

	public String getResName() {
		return resName;
	}

	public void setResName(String resName) {
		this.resName = resName;
	}

	public String getResNo() {
		return resNo;
	}

	public void setResNo(String resNo) {
		this.resNo = resNo;
	}

	public String getCertYear() {
		return certYear;
	}

	public void setCertYear(String certYear) {
		this.certYear = certYear;
	}

	public String getCertMonth() {
		return certMonth;
	}

	public void setCertMonth(String certMonth) {
		this.certMonth = certMonth;
	}

	public String getCertDay() {
		return certDay;
	}

	public void setCertDay(String certDay) {
		this.certDay = certDay;
	}

	public String getRootPath() {
		return rootPath;
	}

	public void setRootPath(String rootPath) {
		this.rootPath = rootPath;
	}

}
