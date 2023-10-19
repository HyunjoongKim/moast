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
	
	function initControls() {
		$("#genesTxt").kendoTextArea({
            placeholder: " Enter your genes here. \r\n ex) \r\n BMPR1A \r\n ALK3 \r\n BMPR1B \r\n ALK6 \r\n BMPR2 \r\n ACVR1 \r\n ALK2 \r\n ACVR1B \r\n ALK4 \r\n ACVR1C \r\n ALK7 \r\n ACVR2A \r\n ACVR2B \r\n ACVRL1 \r\n ALK1 \r\n Nodal \r\n GDF1 \r\n GDF11 \r\n INHA \r\n SMAD9/8"
        });
		
		$('#initButton').click(function() {
			$('#genesTxt').val('');
		});
		
		$('#survDegButton').click(function() {
			excuteSurvAjax('DEG_Genes');
		});
		
		$('#survTGFbCoreButton').click(function() {
			excuteSurvAjax('TGFb_Core_Genes');
		});
		
		$('#survTGFbRegulButton').click(function() {
			excuteSurvAjax('TGFb_Regul_Targets');
		});
		
		$('#excuteButton').click(function() {
			excuteSurvUserAjax('UserGeneSet');
		});
	}
	
	function excuteSurvAjax(geneType) {
		$('#geneType').val(geneType);
		$.ajax({
            url: "${path}/mo/basic/popup/surv_ajax.do",
            type: "POST",
            data: $('#submitForm').serialize(),
            error: function() {alert('An error occurred during data reception.');},
            success: function(data) {
            	//console.log(data);
            	$('#genesTxt').val('');
            	drawScatter(data.data);
            },
            complete: function(data) {
			}
        });
	}
	
	function excuteSurvUserAjax(geneType) {
		$('#geneType').val(geneType);
		$.ajax({
            url: "${path}/mo/basic/popup/surv_user_ajax.do",
            type: "POST",
            data: $('#submitForm').serialize(),
            error: function() {alert('An error occurred during data reception.');},
            success: function(data) {
            	//console.log(data);
            	$('#genesTxt').val(data.data.genesTxt);
            	drawScatter(data.data);
            },
            complete: function(data) {
			}
        });
	}
	
</script>
<form id="submitForm" action="${path}/mo/basic/popup/volcano.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }" />
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }" />
	<input type="hidden" name="ws_idx" id="ws_idx" value="${searchVO.ws_idx }"/>
	<input type="hidden" name="expType" id="expType" value="${param.expType }" />
	<input type="hidden" name="searchLogFC" id="searchLogFC" value="${searchVO.searchLogFC }" />
	<input type="hidden" name="searchPValueType" id="searchPValueType" value="${searchVO.searchPValueType }" />
	<input type="hidden" name="searchPValue" id="searchPValue" value="${searchVO.searchPValue }" />
	<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${searchVO.searchAdjPValue }" />
	<input type="hidden" name="methType" id="methType" value="${param.methType }" />
	<input type="hidden" name="searchDmpLogFC" id="searchDmpLogFC" value="${searchVO.searchDmpLogFC }" />
	<input type="hidden" name="searchDmpPValue" id="searchDmpPValue" value="${searchVO.searchDmpPValue }" />
	<input type="hidden" name="searchDmpPValueType" id="searchDmpPValueType" value="${searchVO.searchDmpPValueType }" />
	<input type="hidden" name="searchDmpAdjPValue" id="searchDmpAdjPValue" value="${searchVO.searchDmpAdjPValue }" />
	<input type="hidden" name="geneType" id="geneType" value="${searchVO.geneType }" />
	<input type="hidden" name="ws_idx" id="ws_idx" value="${searchVO.ws_idx }"/>
	<input type="hidden" name="wp_idx" id="wp_idx" value="${searchVO.wp_idx }"/>
	<input type="hidden" name="ps_idx" id="ps_idx" value="${searchVO.ps_idx }" />
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx }" />
	
<div style="margin: 20px;">
	<div class="row">
		<div class="col-6">
			<div class="white_box">
				<div id="wrapperCanvas" style="padding-top: 20px; margin-right: 20px; width:650px;" >
					<div>
						<canvas id="kaplanmeier1" width="609" height="609"></canvas>
					</div>
				</div>
			</div>
		</div>
		<div class="col-6">
			<div class="white_box mb_20">
				<button type="button" id="survDegButton" class="btn btn-primary mr_20">DEG Geneset</button>
				<button type="button" id="survTGFbCoreButton" class="btn btn-primary mr_20">TGFb_Core_Genes</button>
				<button type="button" id="survTGFbRegulButton" class="btn btn-primary mr_20">TGFb_Regul_Targets</button>
				
			</div>
			<div class="white_box">
				<div class="mb_20">
					<button type="button" id="initButton" class="btn btn-secondary">초기화</button>
					<div class="float-right">
						
						<button type="button" id="excuteButton" class="btn btn-success"><i class="fas fa-play"></i> Run</button>
					</div>
				</div>
				
				<textarea id="genesTxt" name="genesTxt" style="width: 100%; height:450px;" required data-required-msg="Please enter a text." data-max-msg="Enter value between 1 and 200" >${vo.genesTxt}</textarea>
				
			</div>
		</div>
	</div>

	
</div>

</form>
