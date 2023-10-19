package com.bsite.vo.variant;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@Entity
@Table(name = "VariantBEDFiles")
public class VariantBEDFileVO implements Serializable {
	private static final long serialVersionUID = 7810484822816149737L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;
	

	@ManyToOne(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "variantPrimerRecordIdx")
	private VariantPrimerResultVO variantPrimerResult;

	@ManyToOne(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "variantBlockerRecordIdx")
	private VariantBlockerResultVO variantBlockerResult;

	@ManyToOne(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "variantProbeResultIdx")
	private VariantProbeResultVO variantProbeResult;
	
	@Column(columnDefinition = "LONGTEXT")
	private String bedContent;
	
	// Image, ImageDate, Comment?
}
