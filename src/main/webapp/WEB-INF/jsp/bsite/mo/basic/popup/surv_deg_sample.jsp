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
		            'vars': ['PM-AA-0055-T', 'PM-AA-0057-T', 'PM-AA-0062-T', 'PM-AA-0063-T', 'PM-AA-0065-T', 'PM-AU-0005-T', 'PM-AU-0045-T', 'PM-AU-0052-T', 'PM-AU-0059-T', 'PM-AU-0060-T', 'PM-AA-0051-T', 'PM-AA-0052-T', 'PM-AA-0053-T', 'PM-AA-0056-T', 'PM-AA-0058-T', 'PM-AA-0059-T', 'PM-AA-0060-T', 'PM-AA-0061-T', 'PM-AA-0066-T', 'PM-AS-0001-T', 'PM-AS-0002-T', 'PM-AS-0003-T', 'PM-AS-0004-T', 'PM-AS-0005-T', 'PM-AS-0006-T', 'PM-AS-0007-T', 'PM-AS-0008-T', 'PM-AS-0009-T', 'PM-AS-0010-T', 'PM-AS-0011-T', 'PM-AS-0012-T', 'PM-AS-0013-T', 'PM-AS-0014-T', 'PM-AS-0015-T', 'PM-AS-0016-T', 'PM-AS-0017-T', 'PM-AS-0018-T', 'PM-AS-0019-T', 'PM-AS-0020-T', 'PM-AS-0021-T', 'PM-AS-0022-T', 'PM-AS-0023-T', 'PM-AS-0024-T', 'PM-AS-0025-T', 'PM-AS-0026-T', 'PM-AS-0027-T', 'PM-AS-0028-T', 'PM-AS-0029-T', 'PM-AS-0030-T', 'PM-AS-0031-T', 'PM-AS-0032-T', 'PM-AS-0033-T', 'PM-AS-0034-T', 'PM-AS-0035-T', 'PM-AS-0036-T', 'PM-AS-0037-T', 'PM-AS-0038-T', 'PM-AS-0039-T', 'PM-AS-0040-T', 'PM-AS-0041-T', 'PM-AS-0042-T', 'PM-AS-0043-T', 'PM-AS-0044-T', 'PM-AS-0045-T', 'PM-AS-0046-T', 'PM-AS-0047-T', 'PM-AS-0048-T', 'PM-AS-0049-T', 'PM-AS-0050-T', 'PM-AU-0001-T', 'PM-AU-0002-T', 'PM-AU-0003-T', 'PM-AU-0006-T', 'PM-AU-0007-T', 'PM-AU-0008-T', 'PM-AU-0009-T', 'PM-AU-0010-T', 'PM-AU-0014-T', 'PM-AU-0015-T', 'PM-AU-0017-T', 'PM-AU-0018-T', 'PM-AU-0019-T', 'PM-AU-0020-T', 'PM-AU-0021-T', 'PM-AU-0022-T', 'PM-AU-0023-T', 'PM-AU-0024-T', 'PM-AU-0025-T', 'PM-AU-0026-T', 'PM-AU-0027-T', 'PM-AU-0029-T', 'PM-AU-0030-T', 'PM-AU-0031-T', 'PM-AU-0034-T', 'PM-AU-0035-T', 'PM-AU-0036-T', 'PM-AU-0037-T', 'PM-AU-0038-T', 'PM-AU-0039-T', 'PM-AU-0040-T', 'PM-AU-0041-T', 'PM-AU-0042-T', 'PM-AU-0043-T', 'PM-AU-0044-T', 'PM-AU-0047-T', 'PM-AU-0048-T', 'PM-AU-0049-T', 'PM-AU-0050-T', 'PM-AU-0053-T', 'PM-AU-0054-T', 'PM-AU-0055-T', 'PM-AU-0056-T', 'PM-AU-0057-T', 'PM-AU-0058-T', 'PM-AU-0061-T', 'PM-AU-0062-T', 'PM-AU-0063-T', 'PM-AU-0064-T', 'PM-AU-0066-T', 'PM-AU-0067-T', 'PM-AU-0068-T', 'PM-AU-0069-T', 'PM-AU-0070-T', 'PM-AU-0072-T', 'PM-AU-0074-T', 'PM-AU-0075-T', 'PM-AU-0076-T', 'PM-AU-0077-T', 'PM-AU-0078-T', 'PM-AU-0080-T', 'PM-AU-0081-T', 'PM-AU-0082-T', 'PM-AU-0083-T', 'PM-AU-0084-T', 'PM-AU-0085-T', 'PM-AU-0087-T', 'PM-AU-0088-T', 'PM-AU-0089-T', 'PM-AU-0090-T', 'PM-AU-0091-T'],
		            'smps': ['DFS','Recur'],
		            'data': [
		            	[377,	1],	[243,	1],	[1586,	0],	[1749,	0],	[1456,	0],	[535,	1],	[2927,	0],	[2855,	0],	[2544,	0],	[2302,	0],
		            	[1342,	1],	[577,	1],	[404,	1],	[238,	1],	[496,	1],	[1805,	0],	[1786,	0],	[404,	1],	[1632,	0],	[2666,	1],
		            	[480,	1],	[908,	1],	[727,	1],	[116,	1],	[584,	1],	[87,	1],	[522,	1],	[18,	0],	[1764,	0],	[29,	0],
		            	[1807,	0],	[1748,	0],	[2113,	0],	[479,	1],	[82,	0],	[2212,	0],	[1929,	0],	[104,	1],	[728,	1],	[379,	1],
		            	[592,	1],	[29,	1],	[116,	1],	[232,	1],	[120,	1],	[1830,	1],	[498,	1],	[190,	1],	[218,	1],	[1814,	0],
		            	[1186,	0],	[218,	0],	[1805,	0],	[1918,	0],	[165,	1],	[1800,	0],	[1895,	0],	[112,	1],	[1798,	0],	[1791,	0],
		            	[1911,	0],	[22,	0],	[1009,	0],	[1790,	0],	[1787,	0],	[183,	1],	[209,	1],	[89,	1],	[204,	1],	[699,	1],
		            	[519,	1],	[331,	1],	[302,	1],	[382,	1],	[598,	1],	[757,	1],	[584,	1],	[412,	1],	[614,	1],	[322,	1],
		            	[877,	1],	[768,	1],	[539,	1],	[251,	1],	[559,	1],	[411,	1],	[275,	1],	[680,	1],	[611,	1],	[589,	1],
		            	[434,	1],	[504,	1],	[692,	1],	[764,	1],	[710,	1],	[584,	1],	[415,	1],	[724,	1],	[399,	1],	[438,	1],
		            	[364,	1],	[2852,	0],	[2143,	0],	[3004,	0],	[2116,	0],	[1894,	0],	[2844,	0],	[2927,	0],	[2197,	0],	[2795,	0],
		            	[2157,	0],	[2781,	0],	[1571,	0],	[2043,	0],	[2677,	0],	[2762,	0],	[1876,	0],	[2565,	0],	[1989,	0],	[2558,	0],
		            	[2208,	0],	[2634,	0],	[2223,	0],	[2173,	0],	[1882,	0],	[1807,	0],	[1944,	0],	[1961,	0],	[1697,	0],	[1792,	0],
		            	[1872,	0],	[1765,	0],	[1561,	1],	[1795,	0],	[1688,	0],	[1760,	0],	[1799,	0],	[1801,	0],	[1613,	0],	[1606,	0]
		            ]
		        },
		        'z': {
		        	'Group' : [
		        		'upper', 'upper', 'lower', 'lower', 'lower', 'upper', 'lower', 'upper', 'lower', 'lower', 
		        		'lower', 'lower', 'upper', 'upper', 'lower', 'lower', 'lower', 'upper', 'lower', 'lower', 
		        		'upper', 'lower', 'upper', 'upper', 'upper', 'upper', 'lower', 'lower', 'lower', 'upper', 
		        		'lower', 'lower', 'lower', 'lower', 'lower', 'lower', 'lower', 'upper', 'upper', 'lower', 
		        		'lower', 'lower', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'lower', 'lower', 
		        		'lower', 'upper', 'upper', 'upper', 'upper', 'upper', 'lower', 'upper', 'lower', 'lower', 
		        		'lower', 'upper', 'lower', 'lower', 'lower', 'upper', 'upper', 'upper', 'upper', 'upper', 
		        		'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 
		        		'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 'upper', 
		        		'upper', 'upper', 'upper', 'upper', 'lower', 'lower', 'upper', 'upper', 'upper', 'upper', 
		        		'upper', 'lower', 'upper', 'lower', 'lower', 'lower', 'upper', 'lower', 'lower', 'lower', 
		        		'upper', 'lower', 'lower', 'lower', 'lower', 'lower', 'lower', 'upper', 'lower', 'lower', 
		        		'lower', 'lower', 'lower', 'upper', 'upper', 'lower', 'lower', 'lower', 'lower', 'lower', 
		        		'lower', 'lower', 'lower', 'upper', 'lower', 'upper', 'lower', 'lower', 'lower', 'lower'
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
		            ["DFS","Recur",null,null,null],
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

	<div class="white_box">
	
		<div id="wrapperCanvas" style="padding-top: 20px; margin: auto; width:650px;" >
			<div>
				<canvas id='kaplanmeier1' width='609' height='609'></canvas>
			</div>
		</div>
	</div>
</div>

