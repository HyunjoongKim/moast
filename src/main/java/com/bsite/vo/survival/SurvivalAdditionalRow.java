package com.bsite.vo.survival;

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

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString


@Entity
@Table(name = "SurvivalAdditionalRows")
public class SurvivalAdditionalRow implements Serializable {
	private static final long serialVersionUID = 7810484822816149737L;

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "recordIdx")
	private Integer recordIdx;
	
	private String rowTitle;
	
	private String listType;
	
	private Integer ps_idx;
	
	private Integer std_idx;
	
	@Transient
	private Integer group;
	

	@OneToMany(fetch=FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "rowIdx")
	private List<SurvivalAdditionalRowValue> survivalAdditionalRowValues;
	
	public int getLastColumnId() {
		int lastColumnId = 0;
		if (survivalAdditionalRowValues!=null) {
			for (SurvivalAdditionalRowValue cell : survivalAdditionalRowValues) {
				int colId = (int) cell.getColumnId().charAt(0) - 65;
				lastColumnId = lastColumnId < colId ? colId : lastColumnId;
			}
		}
		return lastColumnId;
	}

}
