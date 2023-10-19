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
public class MultiEmRow implements Serializable {

	private static final long serialVersionUID = -765401518736664360L;

	private List<String> cellList = new ArrayList<String>();

	private String geneSymbol = "";
	private String sample = "";
	private List<String> sampleList = new ArrayList<String>();
	private List<List<String>> expList = new ArrayList<List<String>>();
	private List<String> varList = new ArrayList<String>();
	

}
