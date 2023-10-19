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
		
		
		drawScatter();
	});
	
	
	
	//var scatterVars = [];
	//var scatterData = [];
	function drawScatter(data) {
		var cX =  new CanvasXpress({
		    //'version': 38.4,
		    'renderTo': 'kaplanmeier1',
		    'data': {
		        'y': {
		            'vars': ['p1','p2','p3','p4','p5','p6','p7','p8','p9','p10','p11','p12','p13','p14','p15','p16','p17','p18','p19','p20'],
		            'smps': ['Time','Censor','Censor1'],
		            'data': [
		                [24,0,1],
		                [3,1,0],
		                [11,0,1],
		                [19,0,1],
		                [24,0,1],
		                [13,0,1],
		                [14,1,0],
		                [2,0,1],
		                [18,0,1],
		                [17,0,1],
		                [4,0,1],
		                [2,0,1],
		                [12,0,1],
		                [11,1,0],
		                [1,0,1],
		                [13,1,0],
		                [6,0,1],
		                [21,1,0],
		                [9,0,1],
		                [17,1,0]
		            ]
		        },
		        'z': {
		        	'Group' : [
		        		'Group 2', 'Group 2',
		        		'Group 1', 'Group 2',
		        		'Group 2', 'Group 2',
		        		'Group 1', 'Group 2',
		        		'Group 1', 'Group 1',
		        		'Group 1', 'Group 2',
		        		'Group 1', 'Group 1',
		        		'Group 1', 'Group 2',
		        		'Group 1', 'Group 2',
		        		'Group 1', 'Group 2'
		        	]
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
		            ["Time","Censor",null,null,null],
		            {}
		        ]
		    ],
		    //*/
		    'noValidate': true
		});
	}
	
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
				<canvas id='kaplanmeier1' width='609' height='609'></canvas>
			</div>
		</div>
	</div>
</div>

