package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* 작업 */

@Entity
@Table(name = "mo_work_preset")
@Getter
@Setter
@ToString

public class mo_work_presetVO extends PageSearchVO {
	private static final long serialVersionUID = -7890044374764069946L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int wp_idx;

	private Integer ws_idx;
	private Integer ud_idx;
	private Integer me_idx;
	private String work_type;
	private String status;
	private String note;

	@Column(length = 65535, columnDefinition = "Text")
	private String group1;
	@Column(length = 65535, columnDefinition = "Text")
	private String group2;

	private String degType;
	private String degLogFC;
	private String degPValueType;
	private String degPValue;
	private String degAdjPValue;

	private String dmpType;
	private String dmpLogFC;
	private String dmpPValueType;
	private String dmpPValue;
	private String dmpAdjPValue;

}
