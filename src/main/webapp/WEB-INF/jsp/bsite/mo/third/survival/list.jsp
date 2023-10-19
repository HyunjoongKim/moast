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

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();
		//kExcel2();
	});
	
	function kExcel2() {
		//var sheet1 = ${omicsVO1};
		
		$('#cardSheet1').show();
		
		var spreadsheet = $("#spreadsheet1").kendoSpreadsheet({
            sheets: sheet1
        }).data("kendoSpreadsheet");
	}
	
	function initControls() {
		$('#surv_load1').click(function(){
			showGroupList(1);
		});
		
		$('#surv_load2').click(function(){
			showGroupList(2);
		});
		
		$('#execButton').click(function(){
			var group = $('input[type=radio][name=survGroup12]:checked').val();
			
			var isUF1 = $('#survTool1UF').is(':checked');
			var isUF2 = $('#survTool2UF').is(':checked');
			
			if (isUF1) {
				preExecuteKm(1);
			}
			if (group == '2' && isUF2) {
				preExecuteKm(2);
			}
			
			executeKm();
		});
		
		$('input[type=radio][name=survGroup12]').change(function() {
		    if (this.value == '1') {
		    	$('#surv_load2').hide();
		    	$('#cardSheet2').hide();
		    	
		    	$('#surv_div_load2').hide();
		    	
		    }
		    else if (this.value == '2') {
		    	$('#surv_load2').show();
		    	$('#surv_div_load2').show();
		    }
		});
		
		$('input[type=radio][name=survTool1]').change(function() {
			toggleCutoff(this.value, 1);
		});
		
		$('input[type=radio][name=survTool2]').change(function() {
			toggleCutoff(this.value, 2);
		});
		
		$("#survSGsymbol1").on("change", function(){
		    //$('#survCutOffGene1').prop('checked', true);
		});
		
		$("#survSGsymbol2").on("change", function(){
		    //$('#survCutOffGene2').prop('checked', true);
		});
		
	}
	
	function preExecuteKm(no) {
		
		var records = getSheetRows(no, $('#survOmicsType' + no).val());
		//console.log(records);
		
		//*
		$.ajax({
			url: "${path}/mo/third/survival/presurv_action.do",
			method: 'post',
			dataType: 'json',
			async: false,
			contentType: "application/json",
			data: JSON.stringify(records), 
			success: function(response) {
				if (response.res == "ok") {
					
				} else {
					alert('데이터 처리 중 오류가 발생했습니다.');
				}
			}
		})
		//*/
	}
	
	function sendUserData() {
		
	}
	
	function getSheetRows(no, type) {
		var std_idx = $('#std_idx' + no).val();
		
		var spreadsheet = $("#spreadsheet" + no).data("kendoSpreadsheet");
		var rows = spreadsheet.sheets()[0].toJSON().rows;
		var records = [];
		for (var r=sheetDataLength[type]; r<rows.length; r++) {
			var record = {};
			record.group = no;
			record.std_idx = std_idx;
			for (var c in rows[r].cells) {
				if (c==0) {
					record.rowTitle = rows[r].cells[0].value;
					record.listType = type;
					record.survivalAdditionalRowValues = []
				} else if (c>=2) {
					var value = {
						columnId : String.fromCharCode(65 + rows[r].cells[c].index),
						cellValue : rows[r].cells[c].value
					}
					record.survivalAdditionalRowValues.push(value)
				}
			}
			records.push(record)
		}
		
		return records;
	}
	
	function executeKm() {
		var win = window.open("", "PopupSurvNewPlot", "width=850,height=820");
		
		var url = "${path}/mo/third/survival/popup/surv.do";
		
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupSurvNewPlot");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}
	
	function toggleCutoff(val, no) {
		$('#cutoffGene' + no).hide();
		$('#cutoffUser' + no).hide();
	    if (val == 'SG') {
	    	$('#cutoffGene' + no).show();
	    	$('#cutoffUser' + no).hide();
	    } else if (val == 'UF') {
	    	$('#cutoffGene' + no).hide();
	    	$('#cutoffUser' + no).show();
	    }
	}
	
	function showGroupList(no) {
		$.ajax({
	        url: "${path}/mo/third/survival/list_omics_action.do",
	        type: "POST",
	        data: $('#submitForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
	        	var tbody = '<tr><td colspan="5">No search results found.</td></tr>';
				if (data.res == "ok") {
					if (data.data.resultCnt > 0) {
						tbody = '';
						data.data.resultList.forEach(function(value, index, array) {
	    					//var rowspan = (value.expYN == 'Y' ? 1 : 0) + (value.methYN == 'Y' ? 1 : 0) + (value.mutYN == 'Y' ? 1 : 0)
	    					tbody += '<tr>';
	    					tbody += '<td>' + value.std_title + '</td>';
	    					tbody += '<td>' + value.std_note + '</td>';
	    					if (value.expYN == 'Y') {
	    						if (no == 1) {
		    						tbody += '<td class="text-center"><button type="button" class="btn btn-primary" onclick="loadOmicsS(' + no + ', ' + value.std_idx + ', \'exp\');">Select</button></td>';
		    					} else {
		    						if (value.std_idx == $('#std_idx1').val()) {
			    						tbody += '<td class="text-center"><button type="button" class="btn btn-primary" onclick="loadOmicsS(' + no + ', ' + value.std_idx + ', \'exp\');">Select</button></td>';
			    					} else {
			    						tbody += '<td></td>';
			    					}
		    					}
	    					} else {
	    						tbody += '<td></td>';
	    					}
	    					
	    					if (value.methYN == 'Y') {
	    						if (no == 1) {
		    						tbody += '<td class="text-center"><button type="button" class="btn btn-success" onclick="loadOmicsS(' + no + ', ' + value.std_idx + ', \'meth\');">Select</button></td>';
		    					} else {
		    						if (value.std_idx == $('#std_idx1').val()) {
			    						tbody += '<td class="text-center"><button type="button" class="btn btn-success" onclick="loadOmicsS(' + no + ', ' + value.std_idx + ', \'meth\');">Select</button></td>';
			    					} else {
			    						tbody += '<td></td>';
			    					}
		    					}
	    					} else {
	    						tbody += '<td></td>';
	    					}
	    					
	    					if (value.mutYN == 'Y') {
	    						if (no == 1) {
		    						tbody += '<td class="text-center"><button type="button" class="btn btn-info" onclick="loadOmicsS(' + no + ', ' + value.std_idx + ', \'mut\');">Select</button></td>';
		    					} else {
		    						if (value.std_idx == $('#std_idx1').val()) {
			    						tbody += '<td class="text-center"><button type="button" class="btn btn-info" onclick="loadOmicsS(' + no + ', ' + value.std_idx + ', \'mut\');">Select</button></td>';
			    					} else {
			    						tbody += '<td></td>';
			    					}
		    					}
	    					} else {
	    						tbody += '<td></td>';
	    					}
		    					
	    					tbody += '</tr>';
	    					
	    					
						});
					}
	        	} else {
	        		tbody = '<tr><td colspan="5">An error occurred while querying.</td></tr>';
	        	}
				
				$('#groupListBody').html(tbody);
	        },
	        complete: function(data) {
	        	$('#groupListModal').modal('show');
			}
	    });
	}
	
	function loadOmicsS(no, std_idx, omicsType) {
		$('#std_idx').val(std_idx);
		$('#std_idx' + no).val(std_idx);
		$('#std_idx_g').val(std_idx);
		$('#omicsType_g').val(omicsType);
		$('#survOmicsType' + no).val(omicsType);
		
		$('#surv_div_load' + no).hide();
		$('#surv_div_loading' + no).show();
		
		$('#groupListModal').modal('hide');
		
		$.ajax({
	        url: "${path}/mo/third/survival/read_omics_s.do",
	        type: "POST",
	        data: $('#groupForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
				if (data.res == "ok") {
					var stdVO = data.data.stdVO;
					$('#std_idx').val(stdVO.std_idx);
					$('#std_type').val(stdVO.std_type);
					$('#std_status').val(stdVO.std_status);
					
					$('#cardSheet' + no).show();
					$('#txtSheet' + no).text("[" + omicsType + "] " + stdVO.std_title);
					if(omicsType == 'mut') {
						$('#survTool' + no + 'SG').prop('checked', true);
						$('#cutoffGene' + no).show();
						$('#survCutOffGene' + no).prop('checked', true);
						$('.mutHide' + no).hide();
						$('.mutShow' + no).show();
					} else {
						$('#survTool' + no + 'PC').prop('checked', true);
						toggleCutoff('PC', no);
						$('.mutHide' + no).show();
						$('.mutShow' + no).hide();
					}
					
					var omicsVO = data.data.omicsVO;
					if(omicsType == 'meth') {
						setGeneOption(no, omicsVO.geneProbeList);	
					} else {
						setGeneOption(no, omicsVO.geneList);
					}
					setFunctionOption(no, omicsVO.functions)
					
					kExcel(no, omicsVO.surSheet, omicsType);
					
					$(".btn-save-function-" + no).data("listtype", omicsType)
	        	} else {
	        		alert('An error occurred while querying.');
	        	}
	        },
	        complete: function(data) {
	        	$('#surv_div_load' + no).show();
	    		$('#surv_div_loading' + no).hide();
			}
	    });
	}

	function loadOmicsW(no, survOmicsType) {
		$('#survOmicsType' + no).val(survOmicsType);
		$('#searchTmp').val(no);
		
		$('#surv_div_load' + no).hide();
		$('#surv_div_loading' + no).show();
		
		
		$.ajax({
	        url: "${path}/mo/third/survival/read_omics_w.do",
	        type: "POST",
	        data: $('#submitForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
				if (data.res == "ok") {
					//console.log(data.res);
					var stdVO = data.data.stdVO;
					$('#std_idx').val(stdVO.std_idx);
					$('#std_type').val(stdVO.std_type);
					$('#std_status').val(stdVO.std_status);
					
					$('#cardSheet' + no).show();
					$('#txtSheet' + no).text("[" + survOmicsType + "] " + stdVO.std_title);
					if(survOmicsType == 'mut') {
						$('#survTool' + no + 'SG').prop('checked', true);
						$('#cutoffGene' + no).show();
						$('#survCutOffGene' + no).prop('checked', true);
						$('.mutHide' + no).hide();
						$('.mutShow' + no).show();
					} else {
						$('#survTool' + no + 'PC').prop('checked', true);
						toggleCutoff('PC', no);
						$('.mutHide' + no).show();
						$('.mutShow' + no).hide();
					}
					
					var omicsVO = data.data.omicsVO;

					if(survOmicsType == 'meth') {
						setGeneOption(no, omicsVO.geneProbeList);	
					} else {
						setGeneOption(no, omicsVO.geneList);
					}
					kExcel(no, omicsVO.surSheet, survOmicsType);

					setFunctionOption(no, omicsVO.functions)
					
					//$(".btn-save-function-" + no).data("listtype", survOmicsType)
	        	} else {
	        		alert('An error occurred while querying.');
	        	}
	        },
	        complete: function(data) {
	        	$('#groupListModal').modal('hide');
	        	$('#surv_div_load' + no).show();
	    		$('#surv_div_loading' + no).hide();
			}
	    });
	}
	
	function setGeneOption(no, items) {
		$('#survSGsymbol' + no).empty();
		for(var count = 0; count < items.length; count++){                
            var option = $("<option>"+items[count]+"</option>");
            $('#survSGsymbol' + no).append(option);
        }
	}
	
	function setFunctionOption(no, items) {
		$('#excel-function-' + no).empty();
		for(var count = 0; count < items.length; count++){                
            var option = $("<option>"+items[count].rowTitle+"</option>");
            $('#excel-function-' + no).append(option);
        }
	}
	
	var sheetDataLength = {}
	function kExcel(no, sheetData, type) {
		sheetDataLength[type] = sheetData[0].rows.length - sheetData[0].rows.filter(row => (row.remark != null && row.remark == 'function')).length;
		$('#spreadsheet' + no).empty();
		var spreadsheet = $("#spreadsheet" + no).kendoSpreadsheet({
            sheets: sheetData
		}).data("kendoSpreadsheet");
	}
	
	function saveFunction(no, type) {
		var title = [];
		
		var spreadsheet = $("#spreadsheet" + no).data("kendoSpreadsheet");
		var rows = spreadsheet.sheets()[0].toJSON().rows;
		var records = []
		for (var r=sheetDataLength[type]; r<rows.length; r++) {
			var record = {}
			if (rows[r].cells[0].value == undefined || rows[r].cells[0].value =='') {
				continue;
			}
			for (var c in rows[r].cells) {
				if (c==0) {
					title.push(rows[r].cells[0].value);
					record.rowTitle = rows[r].cells[0].value;
					record.listType = type;
					record.survivalAdditionalRowValues = []
				} else if (c>=2) {
					if (rows[r].cells[c].formula != undefined) {
						var value = {
							columnId : String.fromCharCode(65 + rows[r].cells[c].index),
							columnIndex : rows[r].cells[c].index - 1,
							cellFormula : rows[r].cells[c].formula
						}
						record.survivalAdditionalRowValues.push(value)
						
					} else if (rows[r].cells[c].value != undefined && rows[r].cells[c].value != '') {
						var value = {
							columnId : String.fromCharCode(65 + rows[r].cells[c].index),
							columnIndex : rows[r].cells[c].index - 1,
							cellValue : rows[r].cells[c].value
						}
						record.survivalAdditionalRowValues.push(value)
					}
				}
			}
			records.push(record)
		}
		
		//console.log(records);
		console.log(title);
		
		$('#excel-function-' + no).empty();
		for(var count = 0; count < title.length; count++){                
            var option = $("<option>"+title[count]+"</option>");
            $('#excel-function-' + no).append(option);
        }
		
		//*
		$.ajax({
			url: "${path}/mo/third/survival/excel_write_function.do",
			method: 'post',
			dataType: 'json',
			contentType: "application/json",
			data: JSON.stringify(records), 
			success: function(response) {
				if (response.res == "ok") {
					alert("저장 완료 되었습니다.");
				} else {
					alert('An error occurred during data reception.');
				}
			}
		})
		//*/
	}
	
	$(document).on("click", ".btn-save-function", function(){
		var listtype = $(this).data("listtype");
		var no = $(this).data("no")
		
		console.log(no, listtype)
		saveFunction(no, listtype)
		
		
	})
	
	/*
    $("#insert-button").click(function(){
      var datasource = $("#spreadsheet").data("kendoSpreadsheet");
      console.log(datasource)
      var sheet = datasource.sheets()[0]
      sheet.insertRow(195);
    })
    */
</script>


			<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="${path }/mo/third/survival/list.do">
				<input type="hidden" name="grp1" id="grp1" value="${searchVO.grp1 }" />
				<input type="hidden" name="grp2" id="grp2" value="${searchVO.grp2 }" />
				<%-- <input type="hidden" name="expType" id="expType" value="${param.expType }" /> --%>
				<input type="hidden" name="degType" id="degType" value="${searchVO.degType }" />
				<input type="hidden" name="searchLogFC" id="searchLogFC" value="${searchVO.searchLogFC }" />
				<input type="hidden" name="searchPValueType" id="searchPValueType" value="${searchVO.searchPValueType }" />
				<input type="hidden" name="searchPValue" id="searchPValue" value="${searchVO.searchPValue }" />
				<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${searchVO.searchAdjPValue }" />
				<%-- <input type="hidden" name="methType" id="methType" value="${param.methType }" /> --%>
				<input type="hidden" name="dmpType" id="dmpType" value="${searchVO.dmpType }" />
				<input type="hidden" name="searchDmpLogFC" id="searchDmpLogFC" value="${searchVO.searchDmpLogFC }" />
				<input type="hidden" name="searchDmpPValue" id="searchDmpPValue" value="${searchVO.searchDmpPValue }" />
				<input type="hidden" name="searchDmpPValueType" id="searchDmpPValueType" value="${searchVO.searchDmpPValueType }" />
				<input type="hidden" name="searchDmpAdjPValue" id="searchDmpAdjPValue" value="${searchVO.searchDmpAdjPValue }" />
				<input type="hidden" name="geneType" id="geneType" value="DEG_Genes" />
				<input type="hidden" name="ud_idx" id="ud_idx" value="${searchVO.ud_idx }"/>
				<input type="hidden" name="ws_idx" id="ws_idx" value="${searchVO.ws_idx }"/>
				<input type="hidden" name="wp_idx" id="wp_idx" value="${searchVO.wp_idx }"/>
				<input type="hidden" name="ps_idx" id="ps_idx" value="${searchVO.ps_idx }" />
				<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx }" />
				<input type="hidden" name="geneSetType" id="geneSetType" value="${searchVO.geneSetType }"/>
				<input type="hidden" name="userGeneText" id="userGeneText" value="${searchVO.userGeneText }"/>
				<input type="hidden" name="survOmicsType1" id="survOmicsType1" value="${searchVO.survOmicsType1 }"/>
				<input type="hidden" name="survOmicsType2" id="survOmicsType2" value="${searchVO.survOmicsType2 }"/>
				<input type="hidden" name="std_type" id="std_type" value="${searchVO.std_type }"/>
				<input type="hidden" name="std_status" id="std_status" value="${searchVO.std_status }"/>
				<input type="hidden" name="searchTmp" id="searchTmp" value="${searchVO.searchTmp }"/>
				<input type="hidden" name="std_idx1" id="std_idx1" value="${searchVO.std_idx1 }"/>
				<input type="hidden" name="std_idx2" id="std_idx2" value="${searchVO.std_idx2 }"/>
			
			
				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Survival</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>ThirdPart Tools<i class="fa fa-chevron-right ml-2 mr-2"></i>Survival </div>
					</div>
				</div>
				<!-- //title -->
				
				<!-- 컨텐츠 영역 -->
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!-- contents start -->
							<div class="card">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i>Group selection
									</h3>
								</div>

								<div class="card-body">
									<div class="row">
										<div class="col-3">
											<input type="radio" name="survGroup12" id="survGroup1" value="1" checked="checked"/>
											<label for="survGroup1" class="ml-2">Single group</label>
										</div>
										<div class="col-9">
											<div id="surv_div_load1">
												<c:if test='${searchVO.std_type eq "A"}' >
													<button type="button" class="btn btn-dark" id="surv_load1">Load data</button>
												</c:if>
												<c:if test='${searchVO.std_type eq "G"}' >
													<button type="button" class="btn btn-dark" id="surv_load_exp1" onclick="loadOmicsW(1,'exp')">Load Expression</button>
													<button type="button" class="btn btn-dark" id="surv_load_meth1" onclick="loadOmicsW(1,'meth')">Load Methylation</button>
													<button type="button" class="btn btn-dark" id="surv_load_mut1" onclick="loadOmicsW(1,'mut')">Load Mutation</button>
												</c:if>
											</div>
											<div id="surv_div_loading1" class="initHide">
												<button id="kmLoding" class="btn btn-primary " type="button" disabled="">
													<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
												</button>
											</div>
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-3">
											<input type="radio" name="survGroup12" id="survGroup2" value="2" />
											<label for="survGroup2" class="ml-2">Double group</label>
										</div>
										<div class="col-9">
											<div id="surv_div_load2" style="display: none;">
												<c:if test='${searchVO.std_type eq "A"}' >
													<button type="button" class="btn btn-dark" id="surv_load2">Load data</button>
												</c:if>
												<c:if test='${searchVO.std_type eq "G"}' >
													<button type="button" class="btn btn-dark" id="surv_load_exp2" onclick="loadOmicsW(2,'exp')">Load Expression</button>
													<button type="button" class="btn btn-dark" id="surv_load_meth2" onclick="loadOmicsW(2,'meth')">Load Methylation</button>
													<button type="button" class="btn btn-dark" id="surv_load_mut2" onclick="loadOmicsW(2,'mut')">Load Mutation</button>
												</c:if>
											</div>
											<div id="surv_div_loading2" class="initHide">
												<button id="kmLoding" class="btn btn-primary " type="button" disabled="">
													<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
												</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<div class="card mt-3 initHide" id="cardSheet1">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i><span id="txtSheet1"></span>
									</h3>
								</div>

								<div class="card-body">
									<div class="row mt-3">
										<div class="col-12">
											<div id="spreadsheet1" style="width: 100%;"></div>
										</div>
									</div>
									<div class="row mt-3" id="optrow1">
										<div class="col-4">
											<div class="card">
												<div class="card-header">
													<h3 class="card-title">
														<i class="ion ion-clipboard mr-1"></i>Tools
													</h3>
													<div class="card-tools">
														<input type="button" class="btn btn-sm btn-primary btn-save-function btn-save-function-1" value="Save Function" data-no="1">
													</div>
												</div>
				
												<div class="card-body" id="tool1">
													<div class="mutHide1">
														<input type="radio" name="survTool1" id="survTool1PC" value="PC" checked="checked"/>
														<label for="survTool1PC" class="ml-2">PC value</label>
													</div>
													<div class="mutHide1">
														<input type="radio" name="survTool1" id="survTool1RS" value="RS"/>
														<label for="survTool1RS" class="ml-2">Risk score</label>
													</div>
													<div class="">
														<input type="radio" name="survTool1" id="survTool1SG" value="SG"/>
														<label for="survTool1SG" class="ml-2">Gene interested</label>
													</div>
													<div class="mutHide1">
														<input type="radio" name="survTool1" id="survTool1UF" value="UF"/>
														<label for="survTool1UF" class="ml-2">User Formula</label>
													</div>
												</div>
											</div>
										</div>
										<div class="col-8">
											<div class="card">
												<div class="card-header">
													<h3 class="card-title">
														<i class="ion ion-clipboard mr-1"></i>CUT OFF
													</h3>
												</div>
				
												<div class="card-body" id="cutoff1">
													<div id="cutoffGene1" class="row mb-1 initHide mutShow1">
														<div class="col-12 mt-1">
															<select id="survSGsymbol1" name="survSGsymbol1" class=""></select>
														</div>
														<div class="col-12 mt-1">
															<input type="radio" name="survCutOff1" id="survCutOffGene1" value="value"/>
															<select id="survSGcheck1" name="survSGcheck1" class="mutShow1">
																<option value="1">Variation</option>
																<option value="0">No variation</option>
															</select>
															<label for="survSGvalue1" class="mutHide1"> >= </span>
															<input type="text" id="survSGvalue1" name="survSGvalue1" class="mutHide1"/>
														</div>
													</div>
													<div id="cutoffUser1" class="row mb-1 initHide">
														<div class="col-12 mt-1">
															<select id="excel-function-1" name="survUFsymbol1" class="excel-function"></select>
														</div>
														<div class="col-12 mt-1">
															<input type="radio" name="survCutOff1" id="survCutOffUser1" value="value"/>
															<label for="survUFvalue1" class="mutHide1"> >= </span>
															<input type="text" id="survUFvalue1" name="survUFvalue1" class="mutHide1"/>
														</div>
													</div>
													<div class="mutHide1">
														<input type="radio" name="survCutOff1" id="survCutOff1Med" value="median" checked="checked"/>
														<label for="survCutOff1Med" class="ml-2">Median</label>
													</div>
													<div class="mutHide1">
														<input type="radio" name="survCutOff1" id="survCutOff1Avr" value="average"/>
														<label for="survCutOff1Avr" class="ml-2">average</label>
													</div>
													
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<div class="card mt-3 initHide" id="cardSheet2">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i><span id="txtSheet2"></span>
									</h3>
								</div>

								<div class="card-body">
									<div class="mt-3">
										<div id="spreadsheet2" style="width: 100%;"></div>
									</div>
									
									<div class="row mt-3" id="optrow1">
										<div class="col-4">
											<div class="card">
												<div class="card-header">
													<h3 class="card-title">
														<i class="ion ion-clipboard mr-1"></i>Tools
													</h3>
													<div class="card-tools">
														<input type="button" class="btn btn-sm btn-primary btn-save-function btn-save-function-2" value="Save Function" data-no="2">
													</div>
												</div>
				
												<div class="card-body" id="tool2">
													<div class="mutHide2">
														<input type="radio" name="survTool2" id="survTool2PC" value="PC" checked="checked"/>
														<label for="survTool2PC" class="ml-2">PC value</label>
													</div>
													<div class="mutHide2">
														<input type="radio" name="survTool2" id="survTool2RS" value="RS"/>
														<label for="survTool2RS" class="ml-2">Risk score</label>
													</div>
													<div class="">
														<input type="radio" name="survTool2" id="survTool2SG" value="SG"/>
														<label for="survTool2SG" class="ml-2">Gene interested</label>
													</div>
													<div class="mutHide2">
														<input type="radio" name="survTool2" id="survTool2UF" value="UF"/>
														<label for="survTool2UF" class="ml-2">user Formula</label>
													</div>
												</div>
											</div>
										</div>
										<div class="col-8">
											<div class="card">
												<div class="card-header">
													<h3 class="card-title">
														<i class="ion ion-clipboard mr-1"></i>CUT OFF
													</h3>
												</div>
				
												<div class="card-body" id="cutoff2">
													<div id="cutoffGene2" class="row mb-1 initHide mutShow2">
														<div class="col-12 mt-1">
															<select id="survSGsymbol2" name="survSGsymbol2" class=""></select>
														</div>
														<div class="col-12 mt-1">
															<input type="radio" name="survCutOff2" id="survCutOffGene2" value="value"/>
															<select id="survSGcheck2" name="survSGcheck2" class="mutShow2">
																<option value="1">Variation</option>
																<option value="0">No variation</option>
															</select>
															<label for="survSGvalue2" class="mutHide2"> >= </span>
															<input type="text" id="survSGvalue2" name="survSGvalue2" class="mutHide2"/>
														</div>
													</div>
													<div id="cutoffUser2" class="row mb-1 initHide">
														<div class="col-12 mt-1">
															<select id="excel-function-2" name="survUFsymbol2" class="excel-function"></select>
														</div>
														<div class="col-12 mt-1">
															<input type="radio" name="survCutOff2" id="survCutOffUser2" value="value"/>
															<label for="survUFvalue2" class="mutHide2"> >= </span>
															<input type="text" id="survUFvalue2" name="survUFvalue2" class="mutHide2"/>
														</div>
													</div>
													<div class="mutHide2">
														<input type="radio" name="survCutOff2" id="survCutOff2Med" value="median" checked="checked"/>
														<label for="survCutOff2Med" class="ml-2">Median</label>
													</div>
													<div class="mutHide2">
														<input type="radio" name="survCutOff2" id="survCutOff2Avr" value="average"/>
														<label for="survCutOff2Avr" class="ml-2">average</label>
													</div>
													
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row mt-3" id="optrow2">
								<div class="col-lg-12 text-right">
									<div>
										<button type="button" id="execButton" class="btn btn-primary"><i class="fas fa-play"></i> Run</button>
									</div>
								</div>
							</div>
						</div>
					</section>
				</div>
			</div>
		</form:form>
		
		
		
		
		
		
		
		
<!-- Modal Data List 목록 -->
<form id="groupForm" name="groupForm" action="${path}/mo/third/survival/read_omics_action.do" method="post">
	<input type="hidden" name="std_idx" id="std_idx_g" />
	<input type="hidden" name="omicsType" id="omicsType_g" />
	
	
	<div class="modal fade" id="groupListModal" tabindex="-1" role="dialog" aria-labelledby="groupListModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="groupListModalLabel">Data List</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="text-left mt-3">
						<table class="table table-bordered table-striped">
							<colgroup>
								<col width="30%">
								<col width="25%">
								<col width="15%">
								<col width="15%">
								<col width="15%">
							</colgroup>
							
							<thead>
								<tr>
									<th>Title</th>
									<th>Comments</th>
									<th>Expression</th>
									<th>Methylation</th>
									<th>Variant</th>
								</tr>
							</thead>

							<tbody id="groupListBody">
								<tr>
									<td colspan="5">No search results found.</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="clearfix"></div>
				
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Close</button>
				</div>
			</div>
		</div>
	</div>
</form>
                        