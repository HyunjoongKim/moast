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

		initGrid();

        changeScatter('${searchVO.searchGeneSymbol }', '${searchVO.searchProbeId }');
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
	            console.log(index);
	            console.log(data);
	            changeScatter(data.gene_symbol, data.probe_id);
	        },
		});
	}

	
	function changeScatter(gene_symbol, probe_id) {
		$('#searchGeneSymbol').val(gene_symbol);
		$('#searchProbeId').val(probe_id);
		
		$('#wrapperCanvas').html('<div><canvas id="met_scatter" width="613" height="613"></canvas></div>');
		
		$.ajax({
            url: "${path}/mo/visual/met2/read_ajax.do",
            type: "POST",
            data: $('#submitForm').serialize(),
            error: function() {alert('An error occurred during data reception.');},
            success: function(data) {
                drawScatter(data, gene_symbol, probe_id);
            },
            complete: function() {}
        });
	}
	
	var sampleGroupList = ${vo.sampleGroupList};
	var sampleList = ${vo.sampleList};
	
	function drawScatter(data, gene_symbol, probe_id) {
		var cX = new CanvasXpress({
			"renderTo" : 'met_scatter',
			"data" : {
				"z" : {
					"Group": sampleGroupList
				},
				"y" : {
					"smps" : [ "Methylation", "Expression" ],
					"vars" : sampleList,
					"data" : data
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
			},
			"events" : false,
			"afterRender" : [ [ "addRegressionLine" ] ]

		});
	}
</script>
<form id="submitForm" action="${path}/mo/visual/met2/list.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
	<input type="hidden" name="searchGeneSymbol" id="searchGeneSymbol" value="${searchVO.searchGeneSymbol }"/>
	<input type="hidden" name="searchProbeId" id="searchProbeId" value="${searchVO.searchProbeId }"/>
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

