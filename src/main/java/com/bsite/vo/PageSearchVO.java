package com.bsite.vo;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
/*****************************
*  		페이지및 공통 상속위한 VO
******************************/
@MappedSuperclass
@SuppressWarnings("serial")
public abstract class PageSearchVO implements Serializable {


	/** table 공통정보 **/
	@Column(name = "site_code", updatable=false)
	private String site_code = "";

	@Column(name = "cret_id", updatable=false)
	private String cret_id = "";

	@Column(name = "cret_ip", updatable=false)
	private String cret_ip = "";

	@Column(name = "cret_date", updatable=false)
	@CreationTimestamp
	private Date  cret_date;

	@Column(name = "modi_id", insertable=false)
	private String modi_id = "";

	@Column(name = "modi_ip", insertable=false)
	private String modi_ip = "";

	@Column(name = "modi_date", insertable=false)
	@UpdateTimestamp
	private Date  modi_date;

	@Column(name = "del_yn", insertable=false)
	private String del_yn = "N";

	@Transient
	private String cret_name = "";

	@Transient
    private String isExcel =   "N";        //엑셀인지

	@Transient
    private String sOption =   "N";        //검색 옵션용

	@Transient
    private String isMypage = "N";         //마이페이지 인지 여부
	
	@Transient
	private String isPop ="N";             //팝업인지
	@Transient
	private String retId ="";              //팝업선택후 부모에 돌려줄 아이디
	@Transient
	private String retTitleId ="";         //팝업선택후 부모에 돌려줄 타이틀 아이디
	
	

	/** 파일 컬럼 **/
	@Transient
	private String atch_file_id;

    /** 검색단어 */
	@Transient
	private String searchWrd = "";

    /** 현재페이지 */
	@Transient
    private int pageIndex = 1;

    /** 페이지갯수 */
	@Transient
    private int pageUnit = 20;


    /** 페이지사이즈 */
	@Transient
    private int pageSize = 10;
	@Transient
	private int insertId = 0;

    /** 페이지 별 페이지 갯수 및 사이즈 조정 시 컨트롤러에 아래 내용 선언
     * searchVO.setPageUnit(10);
	   searchVO.setPageSize(10);
     */
    /** firstIndex */
	@Transient
    private int firstIndex = 1;

    /** lastIndex */
	@Transient
    private int lastIndex = 1;

    /** recordCountPerPage */
	@Transient
    private int recordCountPerPage = 10;

    /** rowNo */
	@Transient
    private int rowNo = 0;

    /** 쿼리스트링 */
	@Transient
    private String queryString = "";

	/**
	 * @return the queryString
	 */
	public String getQueryString() {
		return queryString;
	}

	/**
	 * @param queryString the queryString to set
	 */
	public void setQueryString() throws UnsupportedEncodingException {
		String qs = "";
		qs += "searchWrd="+URLEncoder.encode(this.searchWrd, "UTF-8");
		qs += "&pageIndex="+this.pageIndex;
		if("Y".equals(this.isPop)){
			qs += "&retId="+this.retId;
			qs += "&retTitleId="+this.retTitleId;
		}
		this.queryString = qs;
	}






	/** 2차 페이징 쿼리스트링 */
	@Transient
    private int pageIndex2 = 1;
	@Transient
	private String qustrTab; //tab등 리스트의 리스트 에사용
	public String getQustrTab() {
		return qustrTab;
	}
	public void setQustrTab()  throws UnsupportedEncodingException{
		String qustrReCreate = "";
		this.setQueryString(); //set
		qustrReCreate = this.getQueryString();//get
		qustrReCreate += "&pageIndex2="+this.pageIndex2;               //출고일


		this.qustrTab = qustrReCreate;
	}


	public String getIsPop() {
		return isPop;
	}

	public void setIsPop(String isPop) {
		this.isPop = isPop;
	}

	public String getRetId() {
		return retId;
	}

	public void setRetId(String retId) {
		this.retId = retId;
	}

	public String getRetTitleId() {
		return retTitleId;
	}

	public void setRetTitleId(String retTitleId) {
		this.retTitleId = retTitleId;
	}

	public String getIsMypage() {
		return isMypage;
	}

	public void setIsMypage(String isMypage) {
		this.isMypage = isMypage;
	}

	public int getPageIndex2() {
		return pageIndex2;
	}
	public void setPageIndex2(int pageIndex2) {
		this.pageIndex2 = pageIndex2;
	}



	public String getAtch_file_id() {
		return atch_file_id;
	}

	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}

	public String getsOption() {
		return sOption;
	}

	public void setsOption(String sOption) {
		this.sOption = sOption;
	}


	public int getInsertId() {
		return insertId;
	}

	public void setInsertId(int insertId) {
		this.insertId = insertId;
	}


	public String getIsExcel() {
		return isExcel;
	}

	public void setIsExcel(String isExcel) {
		this.isExcel = isExcel;
	}




	/**
	 * @return the searchWrd
	 */
	public String getSearchWrd() {
		return searchWrd;
	}

	/**
	 * @param searchWrd the searchWrd to set
	 */
	public void setSearchWrd(String searchWrd) {
		this.searchWrd = searchWrd;
	}



	/**
	 * @return the pageIndex
	 */
	public int getPageIndex() {
		return pageIndex;
	}

	/**
	 * @param pageIndex the pageIndex to set
	 */
	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}

	/**
	 * @return the pageUnit
	 */
	public int getPageUnit() {
		return pageUnit;
	}

	/**
	 * @param pageUnit the pageUnit to set
	 */
	public void setPageUnit(int pageUnit) {
		this.pageUnit = pageUnit;
	}

	/**
	 * @return the pageSize
	 */
	public int getPageSize() {
		return pageSize;
	}

	/**
	 * @param pageSize the pageSize to set
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	/**
	 * @return the firstIndex
	 */
	public int getFirstIndex() {
		return firstIndex;
	}

	/**
	 * @param firstIndex the firstIndex to set
	 */
	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}

	/**
	 * @return the lastIndex
	 */
	public int getLastIndex() {
		return lastIndex;
	}

	/**
	 * @param lastIndex the lastIndex to set
	 */
	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}

	/**
	 * @return the recordCountPerPage
	 */
	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}

	/**
	 * @param recordCountPerPage the recordCountPerPage to set
	 */
	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}

	/**
	 * @return the rowNo
	 */
	public int getRowNo() {
		return rowNo;
	}

	/**
	 * @param rowNo the rowNo to set
	 */
	public void setRowNo(int rowNo) {
		this.rowNo = rowNo;
	}

	public String getSite_code() {
		return site_code;
	}

	public void setSite_code(String site_code) {
		this.site_code = site_code;
	}

	public String getCret_id() {
		return cret_id;
	}

	public void setCret_id(String cret_id) {
		this.cret_id = cret_id;
	}

	public String getCret_ip() {
		return cret_ip;
	}

	public void setCret_ip(String cret_ip) {
		this.cret_ip = cret_ip;
	}

	public String getModi_id() {
		return modi_id;
	}

	public void setModi_id(String modi_id) {
		this.modi_id = modi_id;
	}

	public String getModi_ip() {
		return modi_ip;
	}

	public void setModi_ip(String modi_ip) {
		this.modi_ip = modi_ip;
	}

	public String getCret_name() {
		return cret_name;
	}

	public void setCret_name(String cret_name) {
		this.cret_name = cret_name;
	}

	public String getDel_yn() {
		return del_yn;
	}

	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}

	public Date getCret_date() {
		return cret_date;
	}

	public void setCret_date(Date cret_date) {
		this.cret_date = cret_date;
	}

	public Date getModi_date() {
		return modi_date;
	}

	public void setModi_date(Date modi_date) {
		this.modi_date = modi_date;
	}









}
