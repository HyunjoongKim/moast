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
import javax.persistence.Transient;

import com.bsite.vo.variant.VariantBlockerResultVO;
import com.bsite.vo.variant.VariantPrimerResultVO;
import com.bsite.vo.variant.VariantProbeResultVO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

@Entity
@Table(name = "VariantRecords")
public class VariantRecordVO extends PageSearchVO implements Serializable{
	
	private static final long serialVersionUID = 7810484822816149737L;
	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;
	
	private String variantID;
	
	private String comment;
	
	@Column(columnDefinition = "LONGTEXT")
	private String annotation;
	
	@Column(columnDefinition = "LONGTEXT")
	private String fasta1;
	
	@Column(columnDefinition = "LONGTEXT")
	private String fasta2;
	
	@Column(columnDefinition = "LONGTEXT")
	private String fasta3;
	
	private Integer std_idx;
	
	@OneToMany(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "variantRecordIdx")
	private List<VariantPrimerResultVO> variantPrimerResults;
	
	@OneToMany(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "variantRecordIdx")
	private List<VariantBlockerResultVO> variantBlockerResults;
	
	@OneToMany(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "variantRecordIdx")
	private List<VariantProbeResultVO> variantProbeResults;
	
	private int maxPosition;
	
	public String getChr() {
		if (variantID==null) return null;
		return variantID.split(";")[1].split("_")[0];
	};
	
	public int getStartPosition() {
		if (variantID==null) return 0;
		return Integer.parseInt(variantID.split(";")[1].split("_")[1].split(":")[0]);
	}
	
	public int getEndPosition() {
		if (variantID==null) return 0;
		return Integer.parseInt(variantID.split(";")[1].split("_")[1].split(":")[1]);
	}
	
	public String getRef() {
		if (variantID==null) return null;
		return variantID.split(";")[2].split(">")[0];
	}

	public String getAlt() {
		if (variantID==null) return null;
		return variantID.split(";")[2].split(">")[1];
	}
	
	public String getMultationType() {
		if (variantID==null) return null;
		return variantID.split(";")[0];
	}
	
	

}
