package com.bsite.vo;

import static javax.persistence.GenerationType.IDENTITY;

import java.io.UnsupportedEncodingException;

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
@Table(name = "mo_workspace")
@Getter
@Setter
@ToString

public class mo_workspaceVO extends PageSearchVO {
	private static final long serialVersionUID = 2321993331808370604L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private int ws_idx;

	private Integer ud_idx;
	private Integer me_idx;
	private String work_type;
	private String status;
	private String note;
	

}
