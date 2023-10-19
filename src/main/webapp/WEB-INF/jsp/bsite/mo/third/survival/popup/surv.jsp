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

<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.common.min.css"/>
<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.default.min.css"/>
<script src="https://kendo.cdn.telerik.com/2023.1.314/js/kendo.all.min.js"></script>

<style>
#extTable td {width:30px;}

#extTable td.sColor0 {background-color: #FDFDFD;}
#extTable td.sColor1 {background-color: #FFECF2;}
#extTable td.sColor2 {background-color: #ECF1F7;}
#extTable td.sColor3 {background-color: #E7F1C9;}
#extTable td.sColor4 {background-color: #FDF0BD;}

/*
#extTable td.sColor0 {background-color: #FDFDFD;}
#extTable td.sColor1 {background-color: #FEC3D5;}
#extTable td.sColor2 {background-color: #C3D5E6;}
#extTable td.sColor3 {background-color: #D0E394;}
#extTable td.sColor4 {background-color: #FBE17E;}
*/
</style>
<script type="text/javascript">
	var path = "${path }";
	
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
	
		initControls();
		
		//drawScatter(degData);
		excuteSurvAjax('DEG_Genes');
	});
	
	/*
	var degData = new Object();
	degData.survSampleList = ${vo.survSampleList};
	degData.survDataList = ${vo.survDataList};
	degData.survGroupList = ${vo.survGroupList};
	*/
	function drawScatter(data) {
		
		$('#wrapperCanvas').html('<div><canvas id="kaplanmeier1" width="609" height="609"></canvas></div>');
		
		var cX =  new CanvasXpress({
		    //'version': 38.4,
		    'renderTo': 'kaplanmeier1',
		    'data': {
		        'y': {
		            'vars': data.survSampleList,
		            'smps': ['DFS','Recur'],
		            'data': data.survDataList
		        },
		        'z': {
		        	'Group' : data.survGroupList
		        }
		    },
		    'config': {
		    	'colorBy': 'GroupS',
		        'graphType': 'Scatter2D',
		        'showConfidenceIntervals': false,
		        'showDecorations': true,
		        'showLegend': false,
		        'showTransition': false,
		        'title': 'Kaplan-Meier Plot',
		        'xAxisTitle': 'Weeks',
		        'yAxisTitle': 'Probability of Survival',
		        'graphOrientation': 'horizontal'
		    },
		    'info': false,
		    'afterRenderInit': false,
		    //*
		    'afterRender': [
		        [
		            'changeAttribute',
		            ["kaplanMeierBy","Group",false],
		            {}
		        ],
		        [
		            'addKaplanMeierCurve',
		            ["DFS","Recur",null,null,null],
		            {}
		        ]
		    ],
		    //*/
		    'noValidate': true
		});
	}
	
	function drawTable(d) {
		console.log(d.survExtData);
		var data = d.survExtData;
		
		var trTitle = '<tr>';
		data.ctitle.forEach(function (item, index) {
			trTitle += '<td class="' + data.color[index] + '">' + (item ? item : '') + '</td>';
		});
		trTitle += '</tr>';
		
		var trTime = '<tr>';
		data.time.forEach(function (item, index) {
			trTime += '<td class="' + data.color[index] + '">' + (item ? item : '') + '</td>';
		});
		trTime += '</tr>';
		
		var trNRisk = '<tr>';
		data.nrisk.forEach(function (item, index) {
			trNRisk += '<td class="' + data.color[index] + '">' + (item ? item : '') + '</td>';
		});
		trNRisk += '</tr>';
		
		var trNEvent = '<tr>';
		data.nevent.forEach(function (item, index) {
			trNEvent += '<td class="' + data.color[index] + '">' + (item ? item : '') + '</td>';
		});
		trNEvent += '</tr>';
		
		var trNSurvival = '<tr>';
		data.nsurvival.forEach(function (item, index) {
			//trNSurvival += '<td>' + (item ? parseFloat(item).toFixed(3) : '') + '</td>';
			trNSurvival += '<td class="' + data.color[index] + '">' + (item ? item : '') + '</td>';
		});
		trNSurvival += '</tr>';
		
		var trStdErr = '<tr>';
		data.stdErr.forEach(function (item, index) {
			//trStdErr += '<td>' + (item ? parseFloat(item).toFixed(3) : '') + '</td>';
			trStdErr += '<td class="' + data.color[index] + '">' + (item ? item : '') + '</td>';
		});
		trStdErr += '</tr>';
		
		//$('#extTable').append(trTitle);
		$('#extTable').append(trTime);
		$('#extTable').append(trNRisk);
		$('#extTable').append(trNEvent);
		$('#extTable').append(trNSurvival);
		$('#extTable').append(trStdErr);
		
	}
	
	function initControls() {

	}
	
	function excuteSurvAjax(geneType) {
		//$('#geneType').val(geneType);
		$.ajax({
            url: "${path}/mo/third/survival/popup/surv_ajax.do",
            type: "POST",
            data: $('#submitForm').serialize(),
            error: function() {alert('An error occurred during data reception.');},
            success: function(data) {
            	//console.log(data);
            	//$('#genesTxt').val('');
            	$('#kmLoding').hide();
            	$('#pValue').text(data.data.survPValue);
            	drawScatter(data.data);
            	drawTable(data.data)
            },
            complete: function(data) {
			}
        });
	}
	
	
	
</script>
<form id="submitForm" action="${path}/mo/third/survival/popup/surv.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${searchVO.grp1 }" />
	<input type="hidden" name="grp2" id="grp2" value="${searchVO.grp2 }" />
	<input type="hidden" name="degType" id="degType" value="${searchVO.degType }" />
	<input type="hidden" name="searchLogFC" id="searchLogFC" value="${searchVO.searchLogFC }" />
	<input type="hidden" name="searchPValueType" id="searchPValueType" value="${searchVO.searchPValueType }" />
	<input type="hidden" name="searchPValue" id="searchPValue" value="${searchVO.searchPValue }" />
	<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${searchVO.searchAdjPValue }" />
	<input type="hidden" name="dmpType" id="dmpType" value="${searchVO.dmpType }" />
	<input type="hidden" name="searchDmpLogFC" id="searchDmpLogFC" value="${searchVO.searchDmpLogFC }" />
	<input type="hidden" name="searchDmpPValue" id="searchDmpPValue" value="${searchVO.searchDmpPValue }" />
	<input type="hidden" name="searchDmpPValueType" id="searchDmpPValueType" value="${searchVO.searchDmpPValueType }" />
	<input type="hidden" name="searchDmpAdjPValue" id="searchDmpAdjPValue" value="${searchVO.searchDmpAdjPValue }" />
	<input type="hidden" name="geneType" id="geneType" value="DEG_Genes" />
	<input type="hidden" name="ud_idx" id="ud_idx" value="${searchVO.ud_idx }"/>
	<input type="hidden" name="ws_idx" id="ws_idx" value="${searchVO.ws_idx }"/>
	<input type="hidden" name="wp_idx" id="wp_idx" value="${searchVO.wp_idx }"/>
	<input type="hidden" name="ps_idx" id="ps_idx" value="${searchVO.ps_idx }" />
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx }" />
	<input type="hidden" name="geneSetType" id="geneSetType" value="${searchVO.geneSetType }"/>
	<input type="hidden" name="userGeneText" id="userGeneText" value="${searchVO.userGeneText }"/>
	<input type="hidden" name="survOmicsType1" id="survOmicsType1" value="${searchVO.survOmicsType1 }"/>
	<input type="hidden" name="survOmicsType2" id="survOmicsType2" value="${searchVO.survOmicsType2 }"/>
	<input type="hidden" name="std_type" id="std_type" value="${searchVO.std_type }"/>
	<input type="hidden" name="std_status" id="std_status" value="${searchVO.std_status }"/>
	<input type="hidden" name="searchTmp" id="searchTmp" value="${searchVO.searchTmp }"/>
	<input type="hidden" name="std_idx1" id="std_idx1" value="${searchVO.std_idx1 }"/>
	<input type="hidden" name="std_idx2" id="std_idx2" value="${searchVO.std_idx2 }"/>
	<input type="hidden" name="survGroup12" id="survGroup12" value="${searchVO.survGroup12 }"/>
	<input type="hidden" name="survTool1" id="survTool1" value="${searchVO.survTool1 }"/>
	<input type="hidden" name="survSGsymbol1" id="survSGsymbol1" value="${searchVO.survSGsymbol1 }"/>
	<input type="hidden" name="survSGcheck1" id="survSGcheck1" value="${searchVO.survSGcheck1 }"/>
	<input type="hidden" name="survSGvalue1" id="survSGvalue1" value="${searchVO.survSGvalue1 }"/>
	<input type="hidden" name="survUFsymbol1" id="survUFsymbol1" value="${searchVO.survUFsymbol1 }"/>
	<input type="hidden" name="survUFvalue1" id="survUFvalue1" value="${searchVO.survUFvalue1 }"/>
	<input type="hidden" name="survCutOff1" id="survCutOff1" value="${searchVO.survCutOff1 }"/>
	<input type="hidden" name="survTool2" id="survTool2" value="${searchVO.survTool2 }"/>
	<input type="hidden" name="survSGsymbol2" id="survSGsymbol2" value="${searchVO.survSGsymbol2 }"/>
	<input type="hidden" name="survSGcheck2" id="survSGcheck2" value="${searchVO.survSGcheck2 }"/>
	<input type="hidden" name="survSGvalue2" id="survSGvalue2" value="${searchVO.survSGvalue2 }"/>
	<input type="hidden" name="survUFsymbol2" id="survUFsymbol2" value="${searchVO.survUFsymbol2 }"/>
	<input type="hidden" name="survUFvalue2" id="survUFvalue2" value="${searchVO.survUFvalue2 }"/>
	<input type="hidden" name="survCutOff2" id="survCutOff2" value="${searchVO.survCutOff2 }"/>	

	
	
	
	
<div style="margin: 20px;">
	<div class="row">
		<div class="col-12">
			<button id="kmLoding" class="btn btn-primary " type="button" disabled="">
				<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
			</button>
			<div class="white_box">
				<div id="wrapperCanvas" style="padding-top: 20px; margin-right: 20px; width:650px;" >
					<div>
						<canvas id="kaplanmeier1" width="609" height="609"></canvas>
					</div>
				</div>
					
				<div class="mt-3">
					pValue = <span id="pValue"></span>
				</div>
				<div id="wrrapperTable" class="mt-3">
					<table id="extTable" class="table table-bordered">
					</table>
				</div>
			</div>
		</div>
	</div>

	
</div>

</form>
