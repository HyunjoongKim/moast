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
@Table(name = "VariantProbeResults")
public class VariantProbeResultVO implements Serializable {
	private static final long serialVersionUID = 7810484822816149737L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;

	private String oligo;

	private int start;

	private int len;

	private double tm;

	private double gc;

	private double anyCompl;

	private double threeCompl;

	private double hairpin;

	private String seq;
}
