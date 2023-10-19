package com.bsite.vo;

import java.io.Serializable;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Survival s_table */

@Getter
@Setter
@ToString

public class SurvExtData implements Serializable {

	private static final long serialVersionUID = -2951681016002739748L;
	
	private String[] cTitle;
	private String[] time;
	private String[] nRisk;
	private String[] nEvent;
	private String[] nSurvival;
	private String[] stdErr;
	
	private String[] color;
	
	/*
	private List<Integer> timeNum;
	private List<Integer> nRiskNum;
	private List<Integer> nEventNum;
	private List<Float> nSurvivalNum;
	private List<Float> stdErrNum;
	*/
	

}
