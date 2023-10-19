package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 임상정보 */
 
@Entity
@Table(name = "mo_clinic_group")
@Getter
@Setter
@ToString
public class mo_clinic_groupVO extends PageSearchVO {
	private static final long serialVersionUID = -2408614003463549447L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int cg_idx = 0;
	
	private Integer ud_idx = 0;
	private Integer me_idx = 0;
	private String cg_title = "";
	private String cg_note = "";
	private String cg_type = "";
	
	@Formula(value = "case when cg_type = '2' then '2그룹' else '1그룹' end  ")
	private String cg_type_nm = "";
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
	@JoinColumn(name = "cg_idx", referencedColumnName = "cg_idx")
	@Where(clause = "del_yn = 'N'")
	private List<mo_clinic_group_dtlVO> dtlList = new ArrayList<mo_clinic_group_dtlVO>();
	
	@Transient
	private String dtls = "";
	
	@Transient
	private String cgNos = "";
	
	@Transient
	private String samples = "";
	
	@Transient
	private String searchSamples1 = "";
	
	@Transient
	private String searchSamples2 = "";
	
	@Transient
	private String qustr;

	public void setQustr() throws UnsupportedEncodingException {

		String qs = "";
		this.setQueryString();
		qs += this.getQueryString();
		//qs += "&isPopup="+this.isPopup; 
	
		this.qustr = qs;
	}

}
