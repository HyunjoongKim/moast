package com.bsite.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;



@Entity
@Getter
@Setter
@ToString
public class MultiEmmRow implements Serializable {

	private static final long serialVersionUID = -3033019825843358209L;

	private List<String> cellList = new ArrayList<String>();

	private String geneSymbol = "";
	private String sample = "";
	private String meth = "";
	private List<String> sampleList = new ArrayList<String>();
	private List<List<String>> expList = new ArrayList<List<String>>();
	private List<String> varList = new ArrayList<String>();
	private List<String> methList = new ArrayList<String>();
	

}
