package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.codehaus.jackson.annotate.JsonProperty;

@Entity
@Table(name = "tbl_calendar")
@SuppressWarnings("serial")
public class tbl_calendarVO extends PageSearchVO implements Serializable {
	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int id;
	private String title;
	private String start;
	private String end;
	private String url;
	private String xcontent;
	private String xcate;  //필수
	@JsonProperty
	@Transient
	private String actType; //프로그램용  C:등록 U:수정 D:삭제
	@JsonProperty
	@Transient
	private String xdate;  //프로그램용
	
	
	public String getXdate() {
		return xdate;
	}
	public void setXdate(String xdate) {
		this.xdate = xdate;
	}
	public String getActType() {
		return actType;
	}
	public void setActType(String actType) {
		this.actType = actType;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getEnd() {
		return end;
	}
	public void setEnd(String end) {
		this.end = end;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getXcontent() {
		return xcontent;
	}
	public void setXcontent(String xcontent) {
		this.xcontent = xcontent;
	}
	public String getXcate() {
		return xcate;
	}
	public void setXcate(String xcate) {
		this.xcate = xcate;
	}
	
	
	
}
