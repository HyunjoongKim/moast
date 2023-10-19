package com.adms.mo.visual.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;

import com.bsite.vo.SampleBaseVO;

public class SampleBaseUtils {
	public static void makeSampleID(SampleBaseVO vo) throws Exception {
		makeSampleID(vo, vo);
	}
	
	public static void makeSampleID(SampleBaseVO targetVO, SampleBaseVO sorueceVO) throws Exception {
		targetVO.setSample1List(Arrays.asList(StringUtils.split(sorueceVO.getGrp1(), ",")));
		targetVO.setSample2List(Arrays.asList(StringUtils.split(sorueceVO.getGrp2(), ",")));

		List<String> sampleList = new ArrayList<String>();
		sampleList.addAll(targetVO.getSample1List());
		sampleList.addAll(targetVO.getSample2List());
		targetVO.setSampleList(sampleList);
		
		List<String> groupList = new ArrayList<String>();
		targetVO.getSample1List().forEach(x -> groupList.add("Group1"));
		targetVO.getSample2List().forEach(x -> groupList.add("Group2"));
		targetVO.setSampleGroupList(groupList);
	}
}
