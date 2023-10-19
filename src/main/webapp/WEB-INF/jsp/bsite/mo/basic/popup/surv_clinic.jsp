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
		
		if ('ClinicSingleGroup' == '${searchVO.kmType}') {
			drawScatter1();	
		} else if ('ClinicTwoGroups' == '${searchVO.kmType}') {
			drawScatter2();
		}
		
		$('#singleButton').click(function() {
			$('#kmType').val('ClinicSingleGroup');
			$('#submitForm').submit() ;
		});
		
		$('#twoButton').click(function() {
			$('#kmType').val('ClinicTwoGroups');
			$('#submitForm').submit() ;
		});
	});
	
	var sampleList = ${vo.sampleList};
	var clinicDataList = ${vo.survDataList};
	var sampleGroupList = ${vo.sampleGroupList};
	
	
	function drawScatter1(data) {
		$('#wrapperCanvas1').show();
		$('#wrapperCanvas2').hide();
		var cX =  new CanvasXpress({
		    //'version': 38.4,
		    'renderTo': 'kaplanmeier1',
		    'data': {
		        'y': {
		            'vars': sampleList,
		            'smps': ['DFS','Recur'],
		            'data': clinicDataList
		        },
		        /*
		        'z': {
		        	'Group' : sampleGroupList
		        }
		        */
		    },
		    'config': {
		    	//'colorBy': 'GroupS',
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
		            'addKaplanMeierCurve',
		            ["DFS","Recur",null,null,null],
		            {}
		        ]
		    ],
		    //*/
		    'noValidate': true
		});
	}
	
	function drawScatter2(data) {
		$('#wrapperCanvas2').show();
		$('#wrapperCanvas1').hide();
		var cX =  new CanvasXpress({
		    //'version': 38.4,
		    'renderTo': 'kaplanmeier2',
		    'data': {
		        'y': {
		            'vars': sampleList,
		            'smps': ['DFS','Recur'],
		            'data': clinicDataList
		        },
		        'z': {
		        	'Group' : sampleGroupList
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
	
</script>
<form id="submitForm" action="${path}/mo/basic/popup/surv_clinic.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
	<input type="hidden" name="kmType" id="kmType" value="${searchVO.kmType }"/>
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
	<div class="mb_20">
		<button type="button" id="singleButton" class="btn btn-primary mr_20" ${searchVO.kmType eq 'ClinicSingleGroup' ? 'disabled' : ''}>Single Group</button>
		<button type="button" id="twoButton" class="btn btn-primary mr_20" ${searchVO.kmType ne 'ClinicSingleGroup' ? 'disabled' : ''}>Two Groups</button>
	</div>
	<div class="white_box">
	
		<div id="wrapperCanvas1" style="padding-top: 20px; margin: auto; width:650px;" >
			<div>
				<canvas id='kaplanmeier1' width='609' height='609'></canvas>
			</div>
		</div>
		
		<div id="wrapperCanvas2" style="padding-top: 20px; margin: auto; width:650px;" >
			<div>
				<canvas id='kaplanmeier2' width='609' height='609'></canvas>
			</div>
		</div>
	</div>
</div>

