<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/canvasXpress/37.0/canvasXpress.min.css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/canvasXpress/37.0/canvasXpress.min.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyuiFree1.10.0/themes/material/easyui.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyuiFree1.10.0/themes/icon.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyuiFree1.10.0/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyuiFree1.10.0/datagrid-filter.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyuiFree1.10.0/datagrid-bufferview.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyuiFree1.10.0/datagrid-export.js"></script>


<script type="text/javascript">
	var path = "${path }";
	
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		//getJson();
		
		drawScatter();
	});
	
	//var scatterVars = [];
	//var scatterData = [];
	function drawScatter(data) {
		var cX = new CanvasXpress({
			"renderTo" : "volcanoScatter",
			"data" : {
		        "z" : {
		        	"FC": logFcAbs,
					"Significant": groupData
				},
				"y" : {
					"smps" : [ "logFC", "${searchVO.volcanoYAxis}" ],
					"vars" : geneSymbol,
					"data" : scatterData,

				}
			},
			"config" : {
				"scatterOutlineThreshold": 0,
				//"scatterType": "visium",
				//'transparency': 0.5,
				"axisAlgorithm" : "rPretty",
				//"backgroundType" : "window",
				//"backgroundWindow" : "rgb(238,238,238)",
				"colorBy": "Significant",
				//"colorBy" : "-logPValue",

				"colors" : [ "rgba(0,104,139,0.5)", "rgba(205,0,0,0.5)",
						"rgba(64,64,64,0.5)" ],
				//*
				"decorations" : {
					"line" : [ {
						"type" : "dottedLine",
						"color" : "rgba(0,104,139,0.5)",
						"width" : 2,
						"x" : ${searchVO.searchLogFC},
						
					}, {
						"type" : "dottedLine",
						"color" : "rgba(0,104,139,0.5)",
						"width" : 2,
						"x" : -${searchVO.searchLogFC}
					}
					, {
						"type" : "dottedLine",
						"color" : "rgba(0,104,139,0.5)",
						"width" : 2,
						"y" : ${searchVO.volcanoY}
					}]
				},
				//*/
				"graphType" : "Scatter2D",
				//"legendBackgroundColor" : "rgb(238,238,238)",
				"legendBox" : true,
				"legendBoxColor" : "rgb(0,0,0)",
				"plotBox" : false,
				"showDecorations" : true,
				"showTransition" : false,
				//"dataPointSize": 5,
				//'showScatterDensity': true,
				"sizeBy" : "FC",
				//"sizes" : [ 1, 1, 2, 4, 6, 8, 10, 12, 14 ],
				"sizes" : [ 1, 2, 8, 10, 14, 16, 18, 20 ],
				//"theme" : "CanvasXpress",
				"title" : "Volcano plot",
				"xAxis" : [ "logFC" ],
				"xAxisTickColor" : "rgb(238,238,238)",
				"yAxis" : [ "${searchVO.volcanoYAxis}" ],
				"yAxisTickColor" : "rgb(238,238,238)",
				"graphOrientation" : "horizontal"
			},
			"info" : false,
			"afterRenderInit" : false,
			//"afterRender" : [ [ "setDimensions", [ 609, 609, true ] ] ],
			"noValidate" : true
		});
	}
	
	var geneSymbol = JSON.parse('${vo.geneSymbolList}');
	var scatterData = JSON.parse('${vo.scatterDataList}');
	var logFcAbs = ${vo.logFcAbs};
	var groupData = ${vo.groupList};
</script>
<form id="submitForm" action="${path}/mo/basic/popup/volcano.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
</form>
<div style="margin: 20px;">
	<!-- 
	<div style="padding-top:20px; padding-left:20px;">
		<div class="box_header ">
	        <div class="main-title">
	            <h3 class="mb-0" >Volcano plot</h3>
	        </div>
	    </div>
    </div>
	 -->
	<div class="white_box">
	
		<div id="wrapperCanvas" style="padding-top: 20px; margin: auto; width:650px;" >
			<div>
				<canvas id='volcanoScatter' width='613' height='613'></canvas>
			</div>
		</div>
	</div>
</div>

