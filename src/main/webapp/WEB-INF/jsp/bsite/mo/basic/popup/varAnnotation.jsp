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
	}
	

</script>
<form id="submitForm" action="${path}/mo/basic/popup/htPrimer.do" method="post">
	<input type="hidden" name="input_file_string" id="input_file_string" value=""/>
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx}">
	<input type="hidden" name="variantID" id="variantID" value="">
</form>
<div class="card">
	<div class="card-header">
		<h3 class="card-title">
			<i class="ion ion-clipboard mr-1"></i>Variant Annotation
		</h3>
	</div>

	<div class="card-body">
		<div class="row">
			<div class=" col-lg-12 text-right mb-3">
				<button type="button" id="downloadExcelButton" class="btn btn-dark btn-sm">Excel download</button>
				<button type="button" id="primerButton" class="btn btn-primary btn-sm mr-2">Primer Design</button>
				<!-- <button type="button" id="volcanoSampleButton2" class="btn btn-primary btn-sm mr-2">Genomic feature plot</button>
				<button type="button" id="volcanoSampleButton3" class="btn btn-primary btn-sm mr-2">Survival analysis</button>
				<button type="button" id="volcanoSampleButton4" class="btn btn-primary btn-sm mr-2">Box plot</button> -->
				
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

	var columns = [], fields = []
	var input_file_string = [];
	var variantID = "";
	
	for (var i in srcGrid.columns) {
		if (srcGrid.columns[i].columns && srcGrid.columns[i].columns.length > 0) {
			for (var j in srcGrid.columns[i].columns) {
				columns.push(srcGrid.columns[i].columns[j].title)
				fields.push(srcGrid.columns[i].columns[j].field)
			}
		} else {
			columns.push(srcGrid.columns[i].title)
			fields.push(srcGrid.columns[i].field)
		}
	}
	input_file_string.push(columns.join("\t"))
	
    selectedRows.each(function(index, row) {
    	var dataItem = srcGrid.dataItem($(this));
    	
    	var data = []
    	for (var i in fields) {
    		data.push(dataItem[fields[i]])
    		if (fields[i].startsWith("C_") && dataItem[fields[i]]!="") {
    			variantID = dataItem[fields[i]];
    		}
    	}
    	
    	input_file_string.push(data.join("\t"))
	});
	
	if (input_file_string.length > 1) {
		
		var win = window.open("", "PopVariantPrimer", "width=1600,height=820");
		var url = "${path}/mo/basic/popup/varPrimer.do";
		
		$("#input_file_string").val(input_file_string.join("\n"))
		$("#variantID").val(variantID)
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopVariantPrimer");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	    
	} else {
		alert("Please select at least 1 row")
	}
	
}

function initGrid() {
	
	var annotationFields = ${variantGrid.gridFields};
	var annotationColumns = ${variantGrid.gridColumns};
	var annotationDatas = ${variantGrid.gridData};

	

	// Deg annotation Grid
	var annotationDataSource = new kendo.data.DataSource({
		data: annotationDatas,
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
            fileName: "Variant_Annotation.xlsx",
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
