package com.bsite.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class SampleBaseVO implements Serializable {
	private static final long serialVersionUID = 8992681641273122948L;
	
	private Integer ud_idx = 1;
	private Integer ws_idx = 0;
	private Integer wp_idx = 0;
	private Integer me_idx = 0;
	private String grp1;
	private String grp2;
	private List<String> sample1List = new ArrayList<String>();
	private List<String> sample2List = new ArrayList<String>();
	private List<String> sampleGroupList = new ArrayList<String>();
	private List<String> sampleList = new ArrayList<String>();
	private List<String> geneList = new ArrayList<String>();
	private String genesTxt = "";
	
	private int dmpSampleCnt1 = 0;
	private int dmpSampleCnt2 = 0;

}
