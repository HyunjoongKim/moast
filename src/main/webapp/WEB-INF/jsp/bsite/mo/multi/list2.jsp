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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/xlsx.full.min.js"></script>

<script type="text/javascript">
var path = "${path }";

$(function() {
	alertResMsg(gTxt("${resMap.msg}"));

	initGrid();
	initControls();
	
	if (xbodyStr) {
    	changeScatter('${omicsVO.searchGeneSymbol }', '${omicsVO.searchProbeId }');
	}
	
	$('#geneSetPanel2').removeClass('active');
	$('#geneSetPanel2').removeClass('show');
	
	$('#geneSetPanel3').removeClass('active');
	$('#geneSetPanel3').removeClass('show');
});

function initControls() {
	$('#emExcelButton').click(function() {
		$('#dg1').datagrid('toExcel','EXP_MET.xls');
	});
	
	$('#evExcelButton').click(function() {
		$('#dg2').datagrid('toExcel','EXP_VAR.xls');
		//var wb = XLSX.utils.table_to_book(document.getElementById('extTable11'), {sheet:"Sheet1",raw:true});
		//XLSX.writeFile(wb, ('EXP_VAR.xlsx'));
	});
	
	$('#emvExcelButton').click(function() {
		$('#dg3').datagrid('toExcel','EXP_MET+VAR.xls');
		//var wb = XLSX.utils.table_to_book(document.getElementById('extTable21'), {sheet:"Sheet1",raw:true});
		//XLSX.writeFile(wb, ('EXP_MET+VAR.xlsx'));
	});
}

function initGrid() {
	initGrid1();
	initGrid2();
	initGrid3();
}

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

var xheader2 = [
	[
		{field:'no', title:'No', width:60, sortable:true},
		{field:'gene_symbol', title:'gene_symbol', width:80, sortable:true}, 
		{field:'coefficient', title:'coefficient', width:110, sortable:true},
		{field:'p_value', title:'p_value', width:110, sortable:true},
	]
];

var xheader3 = [
	[
		{field:'no', title:'No', width:60, sortable:true},
		{field:'gene_symbol', title:'gene_symbol', width:80, sortable:true}, 
		{field:'probe_id', title:'probe_id', width:80, sortable:true},
		{field:'coefficient', title:'coefficient', width:110, sortable:true},
		{field:'p_value', title:'p_value', width:110, sortable:true},
	]
];

var xbodyStr = '${xbody}';
var xbodyJson = JSON.parse(xbodyStr);

function initGrid1() {
	if (xbodyStr) {
		
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
		    data:JSON.parse(xbodyStr),        	    
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
}

function initGrid2() {
	var xbodyStr = '${xbody2}';
	var xbodyJson = JSON.parse(xbodyStr);
	
	if (xbodyStr) {
		var dg = $('#dg2').datagrid({
		    width:"100%",
		    height:633,
		    remoteSort:false,
		    singleSelect:true,
		    nowrap:true,
		    fitColumns:true,
		    data:xbodyJson,        	    
		    columns:xheader2,
		    view:bufferview,
		    rownumbers:false,
		    onSelect: function (index, data) {
	            //console.log(data);
	            box2(data.no);
	        },
		});
	}
}

function initGrid3() {
	var xbodyStr = '${xbody3}';
	var xbodyJson = JSON.parse(xbodyStr);
	
	if (xbodyStr) {
		var dg = $('#dg3').datagrid({
		    width:"100%",
		    height:633,
		    remoteSort:false,
		    singleSelect:true,
		    nowrap:true,
		    fitColumns:true,
		    data:xbodyJson,        	    
		    columns:xheader3,
		    view:bufferview,
		    rownumbers:false,
		    onSelect: function (index, data) {
	            //console.log(data);
		    	box3(data.no);
	        },
		});
	}
}

function getTab2() {
	$.ajax({
        url: "${path}/mo/multi/tab2.do",
        type: "POST",
        data: $('#submitForm').serialize(),
        error: function() {alert('An error occurred during data reception.');},
        success: function(data) {
            console.log(data);
            var a = 0;
            a++;
        },
        complete: function() {}
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




<form:form commandName="searchVO" method="post" name="submitForm" id="submitForm" action="${path }/mo/multi/list.do">
	<input type="hidden" name="grp1" id="grp1" value="${omicsVO.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${omicsVO.grp2 }"/>
	<input type="hidden" name="searchGeneSymbol" id="searchGeneSymbol" value="${omicsVO.searchGeneSymbol }"/>
	<input type="hidden" name="searchProbeId" id="searchProbeId" value="${omicsVO.searchProbeId }"/>
	<input type="hidden" name="std_idx" id="std_idx" value="${omicsVO.std_idx }"/>
				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Multi-omics analysis</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>Analysis<i class="fa fa-chevron-right ml-2 mr-2"></i>Multi-omics analysis</div>
					</div>
				</div>
				<!-- //title -->
				
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!--  Data Sets -->
							<div class="row">
								<div class="col-lg-12 ">
									<div class="card mt-3">
										<div class="card-header">
											<h3 class="card-title">
												<i class="ion ion-clipboard mr-1"></i>Multi-omics analysis
											</h3>
										</div>
		
										<div class="card-body">
										
										
									
											<div>
												<ul class="nav nav-tabs" id="geneSetTab" role="tablist">
													<li class="nav-item" role="presentation">
														<a class="nav-link active" id="geneSetTab1" data-toggle="tab" href="#geneSetPanel1" role="tab">EXP ~ MET</a>
													</li>
													<li class="nav-item" role="presentation">
														<a class="nav-link " id="geneSetTab2" data-toggle="tab" href="#geneSetPanel2" role="tab">EXP ~ VAR</a>
													</li>
													<li class="nav-item" role="presentation">
														<a class="nav-link " id="geneSetTab3" data-toggle="tab" href="#geneSetPanel3" role="tab">EXP ~ MET + VAR</a>
													</li>
												</ul>
												<div class="tab-content" id="myTabContent">
													<div class="tab-pane fade show active" id="geneSetPanel1" role="tabpanel">
														<div style="margin: 20px; height: 800px;">
							
															<div style="padding-top:20px; padding-left:20px;">
																<div class="box_header ">
															        <div class="main-title">
															            <h3 class="mb-0" >Correlation result</h3>
															        </div>
															    </div>
														    </div>
															<div style="width: 690px; float:left;">
																<div class="white_box" style="padding:20px;">
																	<button type="button" id="emExcelButton" class="btn btn-dark btn-sm float-right mb-1">Excel 다운로드</button>
																	<div >
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
													</div>
													
													<div class="tab-pane active" id="geneSetPanel2" role="tabpanel">
														<div style="margin: 20px; height: 800px;">
							
															<div style="width: 690px; float:left;">
																<div class="white_box" style="padding:20px;">
																	<button type="button" id="evExcelButton" class="btn btn-dark btn-sm float-right mb-1">Excel 다운로드</button>
																	<div >
																		<table id="dg2">
																		</table>
																	</div>
																	
																	<c:set var="i2" value="0" />
																	<c:forEach var="resultRow" items="${omicsVO.multiEmCorrList}" varStatus="iStatus">
																		<c:forEach var="resultCell" items="${resultRow.cellList}" varStatus="jStatus">
																			<c:if test="${jStatus.last}">
																				<c:set var="cEnd" value="${jStatus.index}" />
																				<c:set var="cPVal" value="${resultCell}" />
																			</c:if>
																		</c:forEach>
																			
																		<c:if test="${cPVal ne 'NA' }">
																			<c:if test="${iStatus.index > 0 }">
																				<c:set var="i2" value="${i2 + 1}" />
																				<input type="hidden" id="emSample${i2 }" value="<c:out value="${resultRow.sample}"/>"/>
																				<input type="hidden" id="emExp${i2 }" value="${resultRow.expList}"/>
																				<input type="hidden" id="emVar${i2 }" value="${resultRow.varList}"/>
																			</c:if>
																		</c:if>
																	</c:forEach>
																</div>
															</div>
															<div class="white_box" style="width: 670px; float:left; margin-left: 20px; margin-top: 50px;">
																<div id="wrapperBox2" style="width: 100%; height: 100%;">
																	<div>
																		<canvas id='boxplot2' width='613' height='613'></canvas>
																	</div>
																</div>
															</div>
														</div>
													</div>
													
													
													<div class="tab-pane active" id="geneSetPanel3" role="tabpanel">
														<div style="margin: 20px; height: 800px;">
							
															<div style="width: 690px; float:left;">
																<div class="white_box" style="padding:20px;">
																	<button type="button" id="emvExcelButton" class="btn btn-dark btn-sm float-right mb-1">Excel 다운로드</button>
																	<div >
																		<table id="dg3">
																		</table>
																	</div>
																	
																	<c:set var="i3" value="0" />
																	<c:forEach var="resultRow" items="${omicsVO.multiEmmCorrList}" varStatus="iStatus">
																		<c:forEach var="resultCell" items="${resultRow.cellList}" varStatus="jStatus">
																			<c:if test="${jStatus.last}">
																				<c:set var="cEnd" value="${jStatus.index}" />
																				<c:set var="cPVal" value="${resultCell}" />
																			</c:if>
																		</c:forEach>
																			
																		<c:if test="${cPVal ne 'NA' }">
																			<c:if test="${iStatus.index > 0 }">
																				<c:set var="i3" value="${i3 + 1}" />
																				<input type="hidden" id="emmSample${i3 }" value="<c:out value="${resultRow.sample}"/>"/>
																				<input type="hidden" id="emmExp${i3 }" value="${resultRow.expList}"/>
																				<input type="hidden" id="emmVar${i3 }" value="${resultRow.varList}"/>
																				<input type="hidden" id="emmMeth${i3 }" value="<c:out value="${resultRow.meth}"/>"/>
																				<input type="hidden" id="emmMethB${i3 }" value="${resultRow.methList}"/>
																			</c:if>
																		</c:if>
																	</c:forEach>
																</div>
															</div>
															<div class="white_box" style="width: 670px; float:left; margin-left: 20px; margin-top: 50px;">
																<div id="wrapperBox3" style="width: 100%; height: 100%;">
																	<div>
																		<canvas id='boxplot3' width='613' height='613'></canvas>
																	</div>
																</div>
															</div>
														</div>
													
													</div>
												</div>
						                    
											</div>
										</div>
									</div>
			
								</div>
							</div>
						</div>
					</section>
				</div>
</form:form>

<script>
	function drawBoxPlot1() {
		var xc = new CanvasXpress(
				{
					//'version' : 40.7,
					"version": 37.3,
					'renderTo' : 'boxplot1',
					'data' : {
						'y' : {
							'smps' : [ 'Var1', 'Var2', 'Var3', 'Var4', 'Var5',
									'Var6', 'Var7', 'Var8', 'Var9', 'Var10',
									'Var11', 'Var12', 'Var13', 'Var14',
									'Var15', 'Var16', 'Var17', 'Var18',
									'Var19', 'Var20', 'Var21', 'Var22',
									'Var23', 'Var24', 'Var25', 'Var26',
									'Var27', 'Var28', 'Var29', 'Var30',
									'Var31', 'Var32', 'Var33', 'Var34',
									'Var35', 'Var36', 'Var37', 'Var38',
									'Var39', 'Var40', 'Var41', 'Var42',
									'Var43', 'Var44', 'Var45', 'Var46',
									'Var47', 'Var48', 'Var49', 'Var50',
									'Var51', 'Var52', 'Var53', 'Var54',
									'Var55', 'Var56', 'Var57', 'Var58',
									'Var59', 'Var60' ],
							'data' : [ [ 4.2, 11.5, 7.3, 5.8, 6.4, 10, 11.2,
									11.2, 5.2, 7, 16.5, 16.5, 15.2, 17.3, 22.5,
									17.3, 13.6, 14.5, 18.8, 15.5, 23.6, 18.5,
									33.9, 25.5, 26.4, 32.5, 26.7, 21.5, 23.3,
									29.5, 15.2, 21.5, 17.6, 9.7, 14.5, 10, 8.2,
									9.4, 16.5, 9.7, 19.7, 23.3, 23.6, 26.4, 20,
									25.2, 25.8, 21.2, 14.5, 27.3, 25.5, 26.4,
									22.4, 24.5, 24.8, 30.9, 26.4, 27.3, 29.4,
									23 ] ],
							'vars' : [ 'len' ]
						},
						'x' : {
							'supp' : [ 'VC', 'VC', 'VC', 'VC', 'VC', 'VC',
									'VC', 'VC', 'VC', 'VC', 'VC', 'VC', 'VC',
									'VC', 'VC', 'VC', 'VC', 'VC', 'VC', 'VC',
									'VC', 'VC', 'VC', 'VC', 'VC', 'VC', 'VC',
									'VC', 'VC', 'VC', 'OJ', 'OJ', 'OJ', 'OJ',
									'OJ', 'OJ', 'OJ', 'OJ', 'OJ', 'OJ', 'OJ',
									'OJ', 'OJ', 'OJ', 'OJ', 'OJ', 'OJ', 'OJ',
									'OJ', 'OJ', 'OJ', 'OJ', 'OJ', 'OJ', 'OJ',
									'OJ', 'OJ', 'OJ', 'OJ', 'OJ' ],
							'order' : [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3,
									4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7,
									8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1,
									2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5,
									6, 7, 8, 9, 10 ],
							'dose' : [ 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
									0.5, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2,
									2, 2, 2, 2, 2, 2, 2, 2, 2, 0.5, 0.5, 0.5,
									0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1,
									1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2,
									2, 2, 2 ]
						}
					},
					'config' : {
						'axisAlgorithm' : 'rPretty',
						'axisTickScaleFontFactor' : 1.8,
						'axisTitleFontStyle' : 'bold',
						'axisTitleScaleFontFactor' : 1.8,
						
						'background' : "white",
						'backgroundType' : "window",
						'backgroundWindow' : "#E5E5E5",
						'colorBy' : 'dose',
						'colorScheme' : "GGPlot",
						'graphOrientation' : 'vertical',
						'graphType' : 'Boxplot',
						'groupingFactors' : [ 'dose' ],
						'guides' : '"solid',
						'guidesColor' : "white",
						'legendTextScaleFontFactor' : 1.8,
						'legendTitleScaleFontFactor' : 1.8,
						
						'showLegend' : true,
						'smpLabelRotate' : 90,
						'smpLabelScaleFontFactor' : 1.8,
						'smpTitle' : 'dose',
						'smpTitleFontStyle' : 'bold',
						'smpTitleScaleFontFactor' : 1.8,
						//'theme' : 'CanvasXpress',
						'stringSampleFactors' : [ 'dose' ],
						'title' : 'The Effect of Vitamin C on Tooth Growth in Guinea Pigs',
						'xAxis2Show' : false,
						'xAxisTickColor' : "white",
						'xAxisTicksMinorShow' : false,
						'xAxisTitle' : 'len'
					},
					'events' : false,
					'info' : false,
					'afterRenderInit' : false,
					'afterRender' : [ [ 'setDimensions', [ 609, 609, true ] ] ],
					'noValidate' : true
				}
			);
	}
</script>



<script>
	function box2(i) {
		CanvasXpress.destroy('boxplot2');
		$('#wrapperBox2').html('<div><canvas id="boxplot2" width="613" height="613"></canvas></div>');
		
		
		var smp1 = $('#emSample' + i).val();
		var smp2 = JSON.parse(smp1);
		var smp3 = [ 'PM-AA-0055-T', 'PM-AA-0057-T', 'PM-AA-0062-T', 'PM-AA-0063-T', 'PM-AA-0065-T', 'PM-AU-0005-T', 'PM-AU-0045-T', 'PM-AA-0051-T', 'PM-AA-0052-T', 'PM-AA-0053-T', 'PM-AA-0056-T', 'PM-AA-0058-T', 'PM-AA-0059-T', 'PM-AA-0060-T', 'PM-AA-0061-T' ];
		
		var exp1 = $('#emExp' + i).val();
		var exp2 = JSON.parse(exp1);
		var exp3 = [ [ 9.78441089251199, 7.16100635265451, 5.9381730638782, 5.4948091212503, 12.3751341195274, 5.72490453696575, 9.70986803177914, 7.18798123822611, 9.29695047902187, 2.45483078786251, 6.87922008471578, 6.66461858067641, 52.8472647925031, 2.25571623306337, 1.70475021829327 ] ];
		
		var var1 = $('#emVar' + i).val();
		var var2 = JSON.parse(var1);
		var var3 = [ 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1 ];
		
		try {
		
			//*
			var xc = new CanvasXpress({
				"version": 37.3,
				'renderTo' : 'boxplot2',
				'data' : {
					'y' : {
						'smps' : smp2,
						'data' : exp2,
						//'vars' : [ 'len' ]
					},
					'x' : {
						
						'Variant' : var2
					}
				},
				'config' : {
					'axisAlgorithm' : 'rPretty',
					'axisTickScaleFontFactor' : 1.8,
					'axisTitleFontStyle' : 'bold',
					'axisTitleScaleFontFactor' : 1.8,
					
					'background' : "white",
					'backgroundType' : "window",
					'backgroundWindow' : "#E5E5E5",
					'colorBy' : 'Variant',
					'colorScheme' : "GGPlot",
					'graphOrientation' : 'vertical',
					'graphType' : 'Boxplot',
					'groupingFactors' : [ 'Variant' ],
					'guides' : '"solid',
					'guidesColor' : "white",
					'legendTextScaleFontFactor' : 1.8,
					'legendTitleScaleFontFactor' : 1.8,
					
					'showLegend' : true,
					'smpLabelRotate' : 90,
					'smpLabelScaleFontFactor' : 1.8,
					'smpTitle' : 'Variant',
					'smpTitleFontStyle' : 'bold',
					'smpTitleScaleFontFactor' : 1.8,
					'stringSampleFactors' : [ 'Variant' ],
					'title' : '',
					'xAxis2Show' : false,
					'xAxisTickColor' : "white",
					'xAxisTicksMinorShow' : false,
					'xAxisTitle' : 'Expression',
					
					
				},
				'events' : false,
				'info' : false,
				'afterRenderInit' : false,
				'noValidate' : true
			});
		} catch (error) {
			console.error(error);
		}
		//*/
	}
	
	
	function box3(i) {
		CanvasXpress.destroy('boxplot3');
		$('#wrapperBox3').html('<div><canvas id="boxplot3" width="613" height="613"></canvas></div>');

		var smp1 = $('#emmSample' + i).val();
		var smp2 = JSON.parse(smp1);
		
		var exp1 = $('#emmExp' + i).val();
		var exp2 = JSON.parse(exp1);
		
		var var1 = $('#emmVar' + i).val();
		var var2 = JSON.parse(var1);
		
		var meth1 = $('#emmMeth' + i).val();
		var meth2 = JSON.parse(meth1);

		/*
		var smp2 = [ 'PM-AA-0055-T', 'PM-AA-0057-T', 'PM-AA-0062-T', 'PM-AA-0063-T', 'PM-AA-0065-T', 'PM-AU-0005-T', 'PM-AU-0045-T', 'PM-AA-0051-T', 'PM-AA-0052-T', 'PM-AA-0053-T', 'PM-AA-0056-T', 'PM-AA-0058-T', 'PM-AA-0059-T', 'PM-AA-0060-T', 'PM-AA-0061-T' ];
		var exp2 = [ [ 9.78441089251199, 7.16100635265451, 5.9381730638782, 5.4948091212503, 12.3751341195274, 5.72490453696575, 9.70986803177914, 7.18798123822611, 9.29695047902187, 2.45483078786251, 6.87922008471578, 6.66461858067641, 52.8472647925031, 2.25571623306337, 1.70475021829327 ] ];
		var var2 = [ 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1 ];
		var meth2 = [ 'Hypo', 'Hyper', 'Hyper', 'Hyper', 'Hyper', 'Hypo', 'Hyper', 'Hypo', 'Hypo', 'Hyper', 'Hypo', 'Hypo', 'Hyper', 'Hypo', 'Hyper' ];
		*/
		
		try {
		
			//*
			var xc = new CanvasXpress({
				"version": 37.3,
				'renderTo' : 'boxplot3',
				'data' : {
					'y' : {
						'smps' : smp2,
						'data' : exp2,
						//'vars' : [ 'len' ]
					},
					'x' : {
						
						'Variant' : var2,
						'Meth' : meth2
						
					}
				},
				'config' : {
					'axisAlgorithm' : 'rPretty',
					'axisTickScaleFontFactor' : 1.8,
					'axisTitleFontStyle' : 'bold',
					'axisTitleScaleFontFactor' : 1.8,
					
					'background' : "white",
					'backgroundType' : "window",
					'backgroundWindow' : "#E5E5E5",
					'colorBy' : 'Variant',
					'colorScheme' : "GGPlot",
					'graphOrientation' : 'vertical',
					'graphType' : 'Boxplot',
					'groupingFactors' : [ 'Variant', 'Meth' ],
					'guides' : '"solid',
					'guidesColor' : "white",
					'legendTextScaleFontFactor' : 1.8,
					'legendTitleScaleFontFactor' : 1.8,
					
					'showLegend' : true,
					'smpLabelRotate' : 90,
					'smpLabelScaleFontFactor' : 1.8,
					'smpTitle' : 'Meth',
					'smpTitleFontStyle' : 'bold',
					'smpTitleScaleFontFactor' : 1.8,
					'stringSampleFactors' : [ 'Variant' ],
					'title' : '',
					'xAxis2Show' : false,
					'xAxisTickColor' : "white",
					'xAxisTicksMinorShow' : false,
					'xAxisTitle' : 'Expression',
					
					
				},
				'events' : false,
				'info' : false,
				'afterRenderInit' : false,
				'noValidate' : true
			});
		} catch (error) {
			console.error(error);
		}
		//*/
	}
</script>