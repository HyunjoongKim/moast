package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

@Entity
@Table(name = "HtPrimerResults")
public class HtPrimerResultVO extends PageSearchVO implements Serializable {

	private static final long serialVersionUID = 5441980932483907941L;
	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	private Integer recordIdx;
	
	private String tsId;
	
	private String fpSeq;

	private String rpSeq;
	
	private String ampId;
	
	private String ampBed;
	
	private String hybProbe;
	
	private String ucscGenomeBrowserViewLink;
	
	private String ucscGenomeBrowserDownloadLink;
	
	private String ucscInsilicoPrimerViewLink;
	
	private String imageFilename;
	
	private Date imageUploadDate;
	
	private String comment;
	
	private Boolean option1;
	
	private Boolean option2;

	@JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
	@JsonBackReference("annotation")
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "methylationRecordIdx")
	private MethylationRecordVO methylationRecord;
	
	@Transient
	private String base64Image;
	
	
	

}
