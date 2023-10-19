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
	function stringTo2dArray(string, d1, d2) {
		return string.split(d1).map(function(x){return x.split(d2)});
	}
	
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));

		initGrid();
		
		if ('${total}' == '0') {
			alert('공통 유전자가 없습니다.');
		} else {
			changeScatter('${searchVO.search_gene_symbol }', '${searchVO.search_probe_id }');	
		}
        

	/*
	var obj = new Object();
        obj.exp_data = 'APC\t3.52250412162961\t3.42598254644873\t3.42719719537129\t3.34276771900567\t3.17525488557937\t3.52010962573454\t3.24248660477962\t3.44111457288777\t3.15454338491981\t3.16843710922';
        obj.meth_data = 'APC\tcg14817997\tAPC$cg14817997\t0.521344627711071\t0.564555336514026\t0.755209313537803\t0.679101364623757\t0.640103940710636\t0.241332724407876\t0.777239869107594\t0.838466129405095\t0.539419215803932\t0.556099065894371';
        
	$.ajax({
			url : "http://10.10.10.108:8001/corr/data/",
			type : "post",
			accept : "application/json",
			contentType : "application/json; charset=utf-8",
			data : JSON.stringify(obj),
			dataType : "json",
			success : function(data) {
				console.log(data)
				// success handle

			},

			error : function(jqXHR, textStatus, errorThrown) {

				// fail handle

			}

		});
*/


        //drawScatter(data1);
	});

	
	//matrix
	var xheader = [
    	[
			{field:'gene_symbol', title:'Exp', rowspan:2, width:90, sortable:true}, 
			{field:'probe_id', title:'Methyl', rowspan:2, width:100, sortable:true},
			{title:'Pearson Correlation', colspan:2},
			{title:'Spearman Correlation', colspan:2}
		], [
			{field:'pearson_coeff', title:'coefficient', width:110, sortable:true},
			{field:'pearson_pvale', title:'p_vale', width:110, sortable:true},
			{field:'spearman_coeff', title:'coefficient', width:110, sortable:true},
			{field:'spearman_pvale', title:'p_vale', width:110, sortable:true}
		]
    ];
	 
	var xbody = ${xbody};
	
	function initGrid() {
		//var colObj = xheader;
		var dg = $('#dg1').datagrid({
		    //title:'타이틀2',
		    width:"100%",
		    height:633,
		    remoteSort:false,
		    singleSelect:true,
		    nowrap:true,
		    fitColumns:true,
		    //url:data,
		    data:xbody,        	    
		    columns:xheader,
		    view:bufferview,
		    rownumbers:false,
		    /* ,
		    pagination: true,
	        clientPaging: false,
	        remoteFilter: false,
	        rownumbers: true */
		    onSelect: function (index, data) {
		    	//console.log(index);
	            //console.log(data);
	            changeScatter(data.gene_symbol, data.probe_id);
	        },
		});
	}

	
	function changeScatter(gene_symbol, probe_id) {
		$('#search_gene_symbol').val(gene_symbol);
		$('#search_probe_id').val(probe_id);
		
		$('#wrapperCanvas').html('<div><canvas id="met_scatter" width="613" height="613"></canvas></div>');
		
		$.ajax({
            url: "${path}/mo/visual/met/read_ajax.do",
            type: "POST",
            data: $('#submitForm').serialize(),
            error: function() {alert('An error occurred during data reception.');},
            success: function(data) {
                //console.log(data);
                drawScatter(data, gene_symbol, probe_id);
            },
            complete: function() {}
        });
	}
	
	function drawScatter(data, gene_symbol, probe_id) {
		var cX = new CanvasXpress({
			"renderTo" : 'met_scatter',
			"data" : {
				"z" : {
					"Group": [  ${sampleGroupList} ]
				},
				"y" : {
					"smps" : [ "Methylation", "Expression" ],
					"vars" : [ ${sampleIdList} ],
					"data" : data
					/*
					[
						['0.521344628', '3.522504122'],
						['0.564555337', '3.425982546'],
						['0.755209314', '3.427197195'],
						['0.679101365', '3.342767719'],
						['0.640103941', '3.175254886'],
						['0.241332724', '3.520109626'],
						['0.777239869', '3.242486605'],
						['0.838466129', '3.441114573'],
						['0.539419216', '3.154543385'],
						['0.556099066', '3.168437109']

					]
					*/
				}
			},
			"config" : {
				"graphType" : "Scatter2D",
				"colorBy": "Group",
				"legendBox": true,
		        //"legendInside": true,
		        //"legendPosition": "topRight",
				"showRegressionFullRange": true,
				"title": 'Linear regression between ("' + gene_symbol + '") expression and ("' + probe_id + '") CpG methylation',
				/*
				"decorations": {
		            "line": [
		                {
		                    "y": 3.45,
		                    "x": -0.3,
		                    "width": 2,
		                    "color": "rgba(5,215,0,0.5)",
		                    "x2": 1.5,
		                    "y2": 3.2
		                }
		            ]
		        },
		        */
			},
			"events" : false,
			"afterRender" : [ [ "addRegressionLine" ] ]

		});
	}
</script>
<form id="submitForm" action="${path}/crc/gsvisual/met/list.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
	<input type="hidden" name="search_gene_symbol" id="search_gene_symbol" value="${searchVO.search_gene_symbol }"/>
	<input type="hidden" name="search_probe_id" id="search_probe_id" value="${searchVO.search_probe_id }"/>
</form>
<div style="margin: 20px;">
	
	<div style="padding-top:20px; padding-left:20px;">
		<div class="box_header ">
	        <div class="main-title">
	            <h3 class="mb-0" >Correlation result</h3>
	        </div>
	    </div>
    </div>
	<div style="width: 690px; float:left;">
		<div class="white_box" style="padding:20px;">
			<div style="padding-top: 20px;">
				<table id="dg1">
				</table>
			</div>
		</div>
	</div>
	<div class="white_box" style="width: 670px; float:left; margin-left: 20px;">
	
		<div id="wrapperCanvas" style="padding-top: 20px; margin-right: 20px; width:650px;" >
			<div>
				<canvas id='met_scatter' width='613' height='613'></canvas>
			</div>
		</div>
	</div>
</div>

