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
		$('#primerButton').click(function() {
			primerDesign();
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
	

</script>
<form id="submitForm" action="${path}/mo/basic/popup/htPrimer.do" method="post">
	<input type="hidden" name="target_file_string" id="target_file_string" value=""/>
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx}">
	
</form>
<div class="card">
	<div class="card-header">
		<h3 class="card-title">
			<i class="ion ion-clipboard mr-1"></i>DMP Annotation
		</h3>
	</div>

	<div class="card-body">
		<div class="row">
			<div class=" col-lg-12 text-right mb-3">
				<button type="button" id="davidButton" class="btn btn-dark btn-sm">David API</button>
				<button type="button" id="downloadExcelButton" class="btn btn-dark btn-sm">Excel download</button>
				<button type="button" id="primerButton" class="btn btn-primary btn-sm mr-2">Primer Design </button>
				<button type="button" id="volcanoSampleButton2" class="btn btn-primary btn-sm mr-2">Genomic feature plot</button>
				<!-- <button type="button" id="volcanoSampleButton3" class="btn btn-primary btn-sm mr-2">Survival analysis</button> -->
				<!-- <button type="button" id="volcanoSampleButton4" class="btn btn-primary btn-sm mr-2">Box plot</button> -->
				
			</div>
		</div>
		<div id="gridAnnotationWrapper" class="dataTables_wrapper dt-bootstrap4 mb-3">
			<div id="gridAnnotation"></div>
		</div>
	</div>
		
</div>

<script>

function primerDesign() {
	var srcGrid = $('#gridAnnotation').data("kendoGrid");
	var srcDataSource = srcGrid.dataSource;
    var srcData = srcDataSource.data();
    
    var selectedRows = srcGrid.select();

	var target_file = [];
    selectedRows.each(function(index, row) {
    	var dataItem = srcGrid.dataItem($(this));
    	
    	var IlmnID = dataItem["IlmnID"];
    	var CHR_hg38 = dataItem["CHR_hg38"];
    	var Start_hg38 = parseInt(dataItem["Start_hg38"]) - 200;
    	var End_hg38 = parseInt(dataItem["End_hg38"]) + 200;
    	
   		target_file.push(CHR_hg38 + "\t" + Start_hg38 + "\t" + End_hg38 + "\t" + IlmnID)
	});
	if (target_file.length > 0) {
		
		var win = window.open("", "PopHtPrimer", "width=1600,height=820");
		var url = "${path}/mo/basic/popup/htPrimer.do";
		
		$("#target_file_string").val(target_file)
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopHtPrimer");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
		
	    
	} else {
		alert("Please select at least 1 row")
	}
}

function initGrid() {
	var orderData = ${jsonBody};
	
	var annotationFields = {
		IlmnID: {type: "string"},
		Genome_Build: {type: "number"},
		CHR: {type: "number"},
		MAPINFO: {type: "number"},
		Strand: {type: "string"},
		UCSC_RefGene_Name: {type: "string"},
		UCSC_RefGene_Accession: {type: "string"},
		UCSC_RefGene_Group: {type: "string"},
		UCSC_CpG_Islands_Name: {type: "string"},
		Relation_to_UCSC_CpG_Island: {type: "string"},
		CHR_hg38: {type: "string"},
		Start_hg38: {type: "number"},
		End_hg38: {type: "number"},
		Strand_hg38: {type: "string"},
	};
	
	var annotationColumns = [
		{field: "IlmnID", title: "IlmnID", width: 120},
		{field: "CHR_hg38", title: "CHR_hg38", width: 120},
		{field: "Start_hg38", title: "Start_hg38", width: 120},
		{field: "End_hg38", title: "End_hg38", width: 120},
		{field: "Strand_hg38", title: "Strand_hg38", width: 120},
		{field: "Genome_Build", title: "Genome_Build", width: 130},
		{field: "CHR", title: "CHR", width: 70},
		{field: "MAPINFO", title: "MAPINFO", width: 100}, 
		{field: "Strand", title: "Strand", width: 80}, 
		{field: "UCSC_RefGene_Name", title: "UCSC_RefGene_Name", width: 200},
		{field: "UCSC_RefGene_Accession", title: "UCSC_RefGene_Accession", width: 200},
		{field: "UCSC_RefGene_Group", title: "UCSC_RefGene_Group", width: 200},
		{field: "UCSC_CpG_Islands_Name", title: "UCSC_CpG_Islands_Name", width: 200},
		{field: "Relation_to_UCSC_CpG_Island", title: "Relation_to_UCSC_CpG_Island", width: 220},
	];

	

	// Deg annotation Grid
	var annotationDataSource = new kendo.data.DataSource({
		data: orderData,
		//pageSize: 100,
		schema: {
			model: {
				fields: annotationFields
			}
		},
		sort: {field: "IlmnID", dir: "ASC"}
	});
	
	$("#gridAnnotation").kendoGrid({
		//toolbar: ["excel"],
		excel: {
            fileName: "DMP_Annotation.xlsx",
        },
		dataSource: annotationDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 600,
	//	pageable: true,
		selectable: "row",
		resizable: true,
		sortable: true,
	//	groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: annotationColumns
	});
	
	/* function addToGroup() {
		var srcGrid = $('#gridAnnotation').data("kendoGrid");
		var srcDataSource = srcGrid.dataSource;
	    var srcData = srcDataSource.data();
	    
	    var selectedRows = srcGrid.select();
	    


	    selectedRows.each(function(index, row) {
	    	var dataItem = srcGrid.dataItem($(this));
	    	
	    	if (dataItem["grp"] == othGrp) {
	    		//duplSmps = duplSmps + dataItem["sample_id"] + " ";
	    	}
		});
	    
	} */
	
}



</script>
