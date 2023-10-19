package com.bsite.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/* Methylation */

@Getter
@Setter
@ToString

public class VolcanoPlotVO extends SampleBaseVO implements Serializable {
	private static final long serialVersionUID = -6863536758530301669L;
	
	private List<String> geneSymbolList;
	private List<String> groupList;
	private List<Double> logFcAbs;
	private List<List<Double>> scatterDataList;
	
	private List<DegResultVO> degList;
	
	
	
	public VolcanoPlotVO() {
		this.geneSymbolList = new ArrayList<String>();
		this.groupList = new ArrayList<String>();
		this.logFcAbs = new ArrayList<Double> ();
		this.scatterDataList = new ArrayList<List<Double>>();
		
		
		this.degList = new ArrayList<DegResultVO>();
	}
	
	public VolcanoPlotVO(List<DegResultVO> degList) {
		this();
		this.degList = degList;
		degList.forEach(x -> {
			this.geneSymbolList.add(x.getGeneSymbol());
			this.groupList.add(x.getGroup());
			this.logFcAbs.add(x.getLogFcAbs());
			
			List<Double> dataRowList = new ArrayList<Double>();
			dataRowList.add(x.getLogFC());
			dataRowList.add(x.getMinusLogPValue());
			scatterDataList.add(dataRowList);
		});
		
		
	}

}
