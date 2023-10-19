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

<script type="text/javascript">
	var path = "${path }";
	
	var axisData = new Array();
	//<c:forEach var="result" items="${vo.pcaSmps}" varStatus="status">
	axisData.push({ text: "${result}", value: "${status.index}"});//</c:forEach>

	var geneSymbol = ${vo.geneList};
	var pcsSmps = ${vo.pcaSmps};
	var scatterData = ${vo.pcaPlotDataList};
	var groupData = ${vo.sampleGroupList};
	
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
		            'vars': geneSymbol,
		            'smps': pcsSmps,
		            'data': scatterData
		        },
		        "z" : {
					"Group": groupData
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

