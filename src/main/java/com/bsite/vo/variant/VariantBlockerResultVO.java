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
@Table(name = "VariantBlockerResults")
public class VariantBlockerResultVO implements Serializable {
	private static final long serialVersionUID = 7810484822816149737L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;
	
	private String orientation1;

	private String oligo1;

	private int start1;

	private int len1;

	private double tm1;

	private double gc1;

	private double anyCompl1;

	private double threeCompl1;

	private String seq1;
	
	private String orientation2;

	private String oligo2;

	private int start2;

	private int len2;

	private double tm2;

	private double gc2;

	private double anyCompl2;

	private double threeCompl2;

	private String seq2;
}
