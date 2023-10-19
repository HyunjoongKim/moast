package com.bsite.vo.survival;

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
@Table(name = "SurvivalAdditionalRowValues")
public class SurvivalAdditionalRowValue implements Serializable {
	private static final long serialVersionUID = 7810484822816149737L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;
	
	private String columnId;
	
	private Integer columnIndex;
	
	private String cellFormula;
	
	private String cellValue;


}
