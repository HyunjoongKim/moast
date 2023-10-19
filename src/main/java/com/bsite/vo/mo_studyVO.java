package com.bsite.vo;

import javax.persistence.Entity;

import com.bsite.vo.OmicsDataVO.OmicsNewType;
import com.bsite.vo.OmicsDataVO.SelectGeneSetType;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* study */

@Entity
@Getter
@Setter
@ToString

public class mo_studyVO extends PageSearchVO {
	private static final long serialVersionUID = -7890044374764069946L;

	private int std_idx;

	private Integer ud_idx;
	private Integer me_idx;
	private String std_title;
	private String std_note;
	private String std_status = "W";
	private String std_type;
	
	private String expYN;
	private String methYN;
	private String mutYN;

	private String genes;
	private String grp1;
	private String grp2;

	private String degType;
	private String degLogFC;
	private String degPValueType;
	private String degPValue;
	private String degAdjPValue;

	private String dmpType;
	private String dmpLogFC;
	//private String dmpIntercept;
	private String dmpPValueType;
	private String dmpPValue;
	private String dmpAdjPValue;
	
	private String expHeatmap;
	private String methHeatmap;
	private String mutHeatmap;
	
	private int ps_idx;
	private String ps_title = "";
	private String ps_note = "";
	private String ps_status = "";
	
	private String omicsType = "";

	public OmicsNewType getOmicsType2() {
		return OmicsNewType.valueOfLabel(omicsType);
	}
	
	public SelectGeneSetType getGeneSetType() {
		return SelectGeneSetType.valueOfLabel(std_type);
	}
}
