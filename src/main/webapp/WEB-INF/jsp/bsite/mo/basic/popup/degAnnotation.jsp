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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.5/jszip.min.js"></script>


<script type="text/javascript">
	var path = "${path }";
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();
		initGrid();

	});
	
	function initControls() {
		$('#volcanoButton').click(function() {
			popupVolcano();
		});
		
		$('#volcanoSampleButton').click(function() {
			popupVolcano(true);
		});
		
		$('#downloadExcelButton').click(function() {
			var grid = $("#gridAnnotation").data("kendoGrid");
			grid.saveAsExcel();
		});
		
		$('#davidButton').click(function() {
			var len = '${fn:length(ids) }'; 
			if (Number(len) <= 2000) {
				var ids = '${ids}'
				var url = 'https://david.ncifcrf.gov/api.jsp?type=ENTREZ_GENE_ID&tool=summary&ids=' + ids;
				var win = window.open(url, "PopupVolcanoPlot", "width=850,height=820");	
			} else {
				alert('David API Gene 개수는 200개 제한입니다.');
			}
		});
	}
	
	function popupVolcano(isSample) {
		var win = window.open("", "PopupVolcanoPlot", "width=850,height=820");
		
		var url = "${path}/mo/basic/popup/volcano.do";
		if (isSample)
			url = "${path}/mo/basic/popup/volcano_sample.do";
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupVolcanoPlot");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}
	
	
	
</script>
<form id="submitForm" action="${path}/mo/basic/popup/degAnnotation.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
	
	<input type="hidden" name="degType" id="degType" value="${param.degType }"/>
	<input type="hidden" name="searchLogFC" id="searchLogFC" value="${param.searchLogFC }"/>
	<input type="hidden" name="searchPValue" id="searchPValue" value="${param.searchPValue }"/>
	<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${param.searchAdjPValue }"/>
</form>
<div class="card">
	<div class="card-header">
		<h3 class="card-title">
			<i class="ion ion-clipboard mr-1"></i>DEG Annotation
		</h3>
	</div>

	<div class="card-body">
		<div class="row">
			<div class=" col-lg-12 text-right mb-3">
				<button type="button" id="davidButton" class="btn btn-dark btn-sm">David API</button>
				<button type="button" id="downloadExcelButton" class="btn btn-dark btn-sm">Excel download</button>
				<button type="button" id="volcanoSampleButton" class="btn btn-dark btn-sm">volcano plot (example)</button>
				<button type="button" id="volcanoButton" class="btn btn-primary btn-sm">volcano plot</button>
			</div>
		</div>
		<div id="gridAnnotationWrapper" class="dataTables_wrapper dt-bootstrap4 mb-3">
			<div id="gridAnnotation"></div>
		</div>
	</div>
		
</div>

<script>

function initGrid() {
	var orderData = ${jsonBody};
	
	var annotationFields = ${sampleFields};
	
	var annotationEdgeRFields = {
		geneSymbol: {type: "string"},
		logFC: {type: "number"},
		logCPM: {type: "number"},
		LR: {type: "number"},
		pValue: {type: "number"},
		FDR: {type: "number"},
	};
	
	var annotationDESeq2Fields = {
		geneSymbol: {type: "string"},
		baseMean: {type: "number"},
		log2FoldChange: {type: "number"},
		lfcSE: {type: "number"},
		stat: {type: "number"},
		pValue: {type: "number"},
		padj: {type: "number"},
	};
	
	if('${searchVO.degType}' == 'EdgeR') {
		Object.assign(annotationFields, annotationEdgeRFields);	
	} else {
		Object.assign(annotationFields, annotationDESeq2Fields);
	}

	var sampleFields = ${sampleFields};
	
	
	var edgeRColumns = [
		{field: "geneSymbol", title: "geneSymbol", width: 120},
		{field: "geneCards", title: "Gene Cards", width: 120, template: '<a href="https://www.genecards.org/cgi-bin/carddisp.pl?gene=#= geneSymbol#" target="_blank">Gene Cards</a>'},
		{field: "proteinAtlas", title: "Human Protein Atlas", width: 120, template: '<a href="https://www.proteinatlas.org/search/gene_name:#= geneSymbol#" target="_blank">Human Protein Atlas</a>'},
		{field: "logFC", title: "logFC", width: 150},
		{field: "logCPM", title: "logCPM", width: 150}, 
		{field: "LR", title: "LR", width: 150}, 
		{field: "pValue", title: "pValue", width: 180},
		{field: "FDR", title: "FDR", width: 180},
	];

	var deSeq2Columns = [
		{field: "geneSymbol", title: "geneSymbol", width: 120},
		{field: "geneCards", title: "Gene Cards", width: 120, template: '<a href="https://www.genecards.org/cgi-bin/carddisp.pl?gene=#= geneSymbol#" target="_blank">#= geneSymbol#</a>'},
		{field: "proteinAtlas", title: "Human Protein Atlas", width: 120, template: '<a href="https://www.proteinatlas.org/search/gene_name:#= geneSymbol#" target="_blank">#= geneSymbol#</a>'},
		{field: "baseMean", title: "baseMean", width: 150},
		{field: "log2FoldChange", title: "log2FoldChange", width: 150}, 
		{field: "lfcSE", title: "lfcSE", width: 150}, 
		{field: "stat", title: "stat", width: 150}, 
		{field: "pValue", title: "pValue", width: 180},
		{field: "padj", title: "padj", width: 180},
	];
	
	var sampleColumns = ${sampleColumns};

	var annotationColumns = ('${searchVO.degType}' == 'EdgeR') ? edgeRColumns.concat(sampleColumns) : deSeq2Columns.concat(sampleColumns);
	

	// Deg annotation Grid
	var annotationDataSource = new kendo.data.DataSource({
		data: orderData,
		//pageSize: 100,
		schema: {
			model: {
				fields: annotationFields
			}
		},
	});
	
	$("#gridAnnotation").kendoGrid({
		//toolbar: ["excel"],
		excel: {
            fileName: "DEG_Annotation.xlsx",
        },
		dataSource: annotationDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 600,
	//	pageable: true,
	//	selectable: "multiple",
		resizable: true,
		sortable: true,
	//	groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: annotationColumns
	});
}

</script>
