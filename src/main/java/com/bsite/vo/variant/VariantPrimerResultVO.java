package com.bsite.vo.variant;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@Entity
@Table(name = "VariantPrimerResults")
public class VariantPrimerResultVO implements Serializable {
	private static final long serialVersionUID = 7810484822816149737L;
	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;

	private String specificOrientation;

	private int specificStart;

	private int specificLen;

	private double specificTm;

	private double specificGc;

	private double specificAnyCompl;

	private double specificThreeCompl;
	
	private double specificScore;
	
	private String specificSnp;
	
	private int specificPos;

	private String specificPrimerSeq;
	
	private String flankingOrientation;

	private int flankingStart;

	private int flankingLen;

	private double flankingTm;

	private double flankingGc;

	private double flankingAnyCompl;

	private double flankingThreeCompl;

	private String flankingPrimerSeq;
	

}
