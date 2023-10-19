<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.common.min.css"/>
<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.default.min.css"/>
<script src="https://kendo.cdn.telerik.com/2023.1.314/js/kendo.all.min.js"></script>

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
	
	var axisData = new Array();
	axisData.push({ text: "PC 1 (2.37%)", value: "0"});//
	axisData.push({ text: "PC 2 (2.17%)", value: "1"});//
	axisData.push({ text: "PC 3 (1.98%)", value: "2"});//
	axisData.push({ text: "PC 4 (1.64%)", value: "3"});//
	axisData.push({ text: "PC 5 (1.32%)", value: "4"});//
	
	var pcsSmps = ["PC 1 (2.37%)","PC 2 (2.17%)","PC 3 (1.98%)","PC 4 (1.64%)","PC 5 (1.32%)"];
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();
		drawScatter();
	});
	
	function initControls() {
		$("#xAxis").kendoDropDownList({
			 dataTextField: "text",
             dataValueField: "value",
             dataSource: axisData,
             index: 0,
             change: drawScatter
		});
		$("#yAxis").kendoDropDownList({
			 dataTextField: "text",
            dataValueField: "value",
            dataSource: axisData,
            index: 1,
            change: drawScatter
		});
	}
	
	function drawScatter() {
		$('#wrapperCanvas').html("<div><canvas id='pcaScatter' width='613' height='613'></canvas></div>");
	
		var x = $("#xAxis").val();
        var y = $("#yAxis").val();
		var cX = new CanvasXpress({
		    'renderTo': 'pcaScatter',
		    'data': {
		        'y': {
		            'vars': ["PM-AA-0055-T","PM-AA-0057-T","PM-AA-0062-T","PM-AA-0063-T","PM-AA-0065-T","PM-AU-0005-T","PM-AU-0045-T","PM-AU-0052-T","PM-AU-0059-T","PM-AU-00660-T"],
		            'smps': pcsSmps,
		            'data': [
		            	[36.7927768203543, -9.7404912319093, 0.624520288031531, -24.3837872834733, 2.86648354563027],
		            	[-13.4267157466597, 16.5044458340001, 45.3954816280275, 1.49604429487242, -0.116684887370897],
		            	[-10.6744766086542, -8.49046725178138, -33.6333618418243, -29.8236417408764, 8.88740964711321],
		            	[49.2627899261398, -45.3188803993227, -14.2543602560428, -22.7525529696832, -19.9844269683378],
		            	[-41.4589267264769, -0.730567707751391, -15.9499580471715, 26.5470155221496, 23.6463927235699],
		            	[-31.4665743342657, 0.584166009531477, -2.20480006899288, -27.3121917835085, -0.966540599198345],
		            	[-5.43290002703069, 2.7840747662509, -24.1713995232661, -13.9151651286566, 4.72061751127294],
		            	[-0.590359210448729, -13.0793894207, -10.9575590016588, -10.7410866595475, 19.3685365750067],
		            	[-20.4553638755014, -16.3323329783677, -6.92785340885317, -24.1272938674649, 6.5760835176463],
		            	[-38.1054586440564, 22.8287915413955, 3.76990524048929, -21.1451970644834, -9.59826680387338]
		            ]
		        },
		        "z" : {
					"Group": ["Group1","Group1","Group1","Group1","Group1","Group2","Group2","Group2","Group2","Group2"]
				},
		    },
		    'config': {
		        //'asSampleFactors': ['cyl'],
		        "colorBy": "Group",
		        'graphType': 'Scatter2D',
		        'legendBox': true,
		        //'stringVariableFactors': ['cyl'],
		        'theme': 'CanvasXpress',
		        'dataPointSize': 10,
		        'xAxis': [pcsSmps[x]],
		        'yAxis': [pcsSmps[y]],
		        'graphOrientation': 'horizontal'
		    },
		    'info': false,
		    'afterRenderInit': false,
		    'noValidate': true
		});
	}
	
</script>
<form id="submitForm" action="${path}/mo/basic/popup/volcano.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
</form>
<div style="margin: 20px;">
		<div class="box_header ">
	        <div class="main-title">
            <h3 class="mb-0" >PCA plot</h3>
	        </div>
	    </div>
	<div class="white_box">
			<div>
			<label for="xAxis">X Axis : </label>
			<div class="inline">
				<input id="xAxis" />
			</div>
			<label for="yAxis" class="ml-10">Y Axis : </label>
			<div class="inline">
				<input id="yAxis" />
			</div>
		</div>
		<div id="wrapperCanvas" style="padding-top: 20px; margin: auto; width:650px;" >
			
		</div>
	</div>
</div>

