package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

@Entity
@Table(name = "MethylationRecords")
public class MethylationRecordVO extends PageSearchVO implements Serializable{
	
	private static final long serialVersionUID = 7810484822816149737L;
	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;
	
	private String ilmnID;
	
	private String comment;
	
	@Column(columnDefinition = "LONGTEXT")
	private String resultHtml;
	
	private Integer std_idx;
	
	@OneToMany(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "methylationRecordIdx")
	private List<HtPrimerResultVO> htPrimerResults;
	
//	private String studyId;
	
	

}
