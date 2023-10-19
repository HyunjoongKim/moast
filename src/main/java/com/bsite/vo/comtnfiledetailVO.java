package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Where;

@SuppressWarnings("serial")
@Entity
@Table(name = "comtnfiledetail")
public class comtnfiledetailVO extends PageSearchVO{

	@EmbeddedId
	private comtnfiledtailPk pk;
	
	private String	file_stre_cours;
	
	private String	stre_file_nm;
	
	private String 	orignl_file_nm;
	
	private String	file_extsn;
	
	@Column(columnDefinition="MEDIUMTEXT")
	private String     file_cn;
	
	@Column(columnDefinition="DECIMAL(8,0)")
	private	String	file_size;	

	
	private String 	file_content_type;
	
	private String 	menu_type;
	
	private int		menu_idx;
	
	public int orientation = 1;
	

	/**
	 * 검색 항목 ****************************************************************************
	 */
	@Transient
	private String searchCol1 ="";
	@Transient
	private String searchCol2 ="";
	@Transient
	private String searchCol3 ="";
	@Transient
	private String searchCol4 ="";
	@Transient
	private String searchCol5 ="";
	@Transient
	private String searchCol6 ="";
	@Transient
	private String searchCol7 ="";
	@Transient
	private String searchCol8 ="";
	@Transient
	private String searchCol9 ="";
	@Transient
	private String searchCol10 ="";
	@Transient
	private String searchIdx ="";

	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		qs += "&searchCol1="+this.searchCol1;
		qs += "&searchCol2="+this.searchCol2;
		qs += "&searchCol3="+this.searchCol3;
		qs += "&searchCol4="+this.searchCol4;
		qs += "&searchCol5="+this.searchCol5;
		qs += "&searchCol6="+this.searchCol6;
		qs += "&searchCol7="+this.searchCol7;
		qs += "&searchCol8="+this.searchCol8;
		qs += "&searchCol9="+this.searchCol9;
		qs += "&searchCol10="+this.searchCol10;
		qs += "&searchIdx="+this.searchIdx;
		this.qustr = qs;
	}
	

	public String getQustr() {
		return qustr;
	}

	public String getFile_stre_cours() {
		return file_stre_cours;
	}

	public void setFile_stre_cours(String file_stre_cours) {
		this.file_stre_cours = file_stre_cours;
	}

	public String getStre_file_nm() {
		return stre_file_nm;
	}

	public void setStre_file_nm(String stre_file_nm) {
		this.stre_file_nm = stre_file_nm;
	}

	public String getOrignl_file_nm() {
		return orignl_file_nm;
	}

	public void setOrignl_file_nm(String orignl_file_nm) {
		this.orignl_file_nm = orignl_file_nm;
	}

	public String getFile_extsn() {
		return file_extsn;
	}

	public void setFile_extsn(String file_extsn) {
		this.file_extsn = file_extsn;
	}

	public String getFile_cn() {
		return file_cn;
	}

	public void setFile_cn(String file_cn) {
		this.file_cn = file_cn;
	}

	public String getFile_size() {
		return file_size;
	}

	public void setFile_size(String file_size) {
		this.file_size = file_size;
	}

	public String getFile_content_type() {
		return file_content_type;
	}

	public void setFile_content_type(String file_content_type) {
		this.file_content_type = file_content_type;
	}

	public String getMenu_type() {
		return menu_type;
	}

	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}

	public int getMenu_idx() {
		return menu_idx;
	}

	public void setMenu_idx(int menu_idx) {
		this.menu_idx = menu_idx;
	}



	public String getSearchCol1() {
		return searchCol1;
	}


	public void setSearchCol1(String searchCol1) {
		this.searchCol1 = searchCol1;
	}


	public String getSearchCol2() {
		return searchCol2;
	}


	public void setSearchCol2(String searchCol2) {
		this.searchCol2 = searchCol2;
	}


	public String getSearchCol3() {
		return searchCol3;
	}


	public void setSearchCol3(String searchCol3) {
		this.searchCol3 = searchCol3;
	}


	public String getSearchCol4() {
		return searchCol4;
	}


	public void setSearchCol4(String searchCol4) {
		this.searchCol4 = searchCol4;
	}


	public String getSearchCol5() {
		return searchCol5;
	}


	public void setSearchCol5(String searchCol5) {
		this.searchCol5 = searchCol5;
	}


	public String getSearchCol6() {
		return searchCol6;
	}


	public void setSearchCol6(String searchCol6) {
		this.searchCol6 = searchCol6;
	}


	public String getSearchCol7() {
		return searchCol7;
	}


	public void setSearchCol7(String searchCol7) {
		this.searchCol7 = searchCol7;
	}


	public String getSearchCol8() {
		return searchCol8;
	}


	public void setSearchCol8(String searchCol8) {
		this.searchCol8 = searchCol8;
	}


	public String getSearchCol9() {
		return searchCol9;
	}


	public void setSearchCol9(String searchCol9) {
		this.searchCol9 = searchCol9;
	}


	public String getSearchCol10() {
		return searchCol10;
	}


	public void setSearchCol10(String searchCol10) {
		this.searchCol10 = searchCol10;
	}


	public comtnfiledtailPk getPk() {
		return pk;
	}


	public void setPk(comtnfiledtailPk pk) {
		this.pk = pk;
	}


	public String getSearchIdx() {
		return searchIdx;
	}


	public void setSearchIdx(String searchIdx) {
		this.searchIdx = searchIdx;
	}

	public int getOrientation() {
		return orientation;
	}


	public void setOrientation(int orientation) {
		this.orientation = orientation;
	}
	
	
	
	

}
