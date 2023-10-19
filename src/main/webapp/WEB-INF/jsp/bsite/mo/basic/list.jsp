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

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/canvasXpress/37.0/canvasXpress.min.css"/> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/canvasXpress/37.0/canvasXpress.min.js"></script>

<style>
.grp1Header {
	color: blue;
}

.grp2Header {
	color: red;
}

.countOver {
	background-color: #eee;
}
</style>

<script type="text/javascript">
	var path = "${path }";
	
	var expHeatmap;
	var methHeatmap;
	
	var isExpDone = false;
	var isMethDone = false;
	var isMutDone = false;
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initExpGrid();
		initControls();
		
		//testGrid1();
	});
	
	function testGrid1() {
		
		var opt1 = {
			dataSource: {
			    //pageSize: 10,
			    transport: {
			        read:  {
			            url: "https://demos.telerik.com/kendo-ui/service/Products",
			            dataType: "jsonp"
			        }
			    },
			    schema: {
			        model: {
			            id: "ProductID"
			        }
			    }
			},
			height: 300,
			pageable: false,
			//scrollable: false,
			persistSelection: true,
			sortable: true,
			//change: onChange,
			navigatable: true,
			columns: [
			    //{ selectable: true, width: "50px" },
			  
			  
				{ draggable: true, width: "50px", headerTemplate: "순서", },
				//define template column with checkbox and attach click event handler
				{
				    title: 'Select All',
				    headerTemplate: "제외",
				    template: function (dataItem) {
				        return "<input type='checkbox' id='" + dataItem.ProductID + "' class='k-checkbox k-checkbox-md k-rounded-md row-checkbox'>";
				    },
				    width: 50,
				    attributes: {class: "k-text-center"},
				    headerAttributes: {class: "k-text-center"},
				},
			    { field:"ProductName", title: "Product Name" },
				/*
			    { field: "UnitPrice", title:"Unit Price", format: "{0:c}"},
			    { field: "UnitsInStock", title:"Units In Stock"},
			    { field: "Discontinued"}
			    */
			]
      	};
    	$("#testGrid1").kendoGrid(opt1);
    	
    	$("#testGrid2").kendoGrid(opt1);

	}
	
	function showNextButton() {
		if (isExpDone && isMethDone && isMutDone) {
			$("#nextButton").attr("disabled", false);
		} else {
			$("#nextButton").attr("disabled", true);
		}
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
	
	function popupPca(isSample) {
		var win = window.open("", "PopupPcaPlot", "width=850,height=820");
		
		var url = "${path}/mo/basic/popup/pca.do";
		if (isSample)
			url = "${path}/mo/basic/popup/pca_sample.do";
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupPcaPlot");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}
	
	function popupPcaMeth(isSample) {
		var win = window.open("", "PopupPcaMethPlot", "width=850,height=820");
		
		var url = "${path}/mo/basic/popup/pca_meth.do";
		if (isSample)
			url = "${path}/mo/basic/popup/pca_meth_sample.do";
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupPcaMethPlot");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}

	function popupKaplanMeier(isSample) {
		var win = window.open("", "PopupKaplanMeierChart", "width=850,height=820");
		
		var url = "${path}/mo/basic/popup/surv_clinic.do";
		if (isSample)
			url = "${path}/mo/basic/popup/surv_clinic_sample.do";
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupKaplanMeierChart");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}
	
	function makeTable(array) {
	    var table = document.createElement('table');
	    for (var i = 0; i < array.length; i++) {
	        var row = document.createElement('tr');
	        for (var j = 0; j < array[i].length; j++) {
	            var cell = document.createElement('td');
	            cell.textContent = array[i][j];
	            row.appendChild(cell);
	        }
	        table.appendChild(row);
	    }
	    return table;
	}
	
	function fillDegCountTable(array1, array2) {
	    for (var i = 0; i < array1.length; i++) {
	        for (var j = 0; j < array1[i].length; j++) {
	        	$('#deg' + i + "_" + j).html(array1[i][j]);
	        	
	        	$('#deg' + i + "_" + j).removeClass('countOver');
	        	if (array1[i][j] > 2000) {
	        		$('#deg' + i + "_" + j).addClass('countOver');	
	        	} 
	        }
	        
	        for (var j = 0; j < array2[i].length; j++) {
	        	$('#deg' + i + "_a" + j).html(array2[i][j]);
	        	
	        	if (array2[i][j] > 2000) {
	        		$('#deg' + i + "_a" + j).addClass('countOver');	
	        	} else {
	        		$('#deg' + i + "_a" + j).removeClass('countOver');
	        	} 
	        }
	    }
	}
	
	function fillDmpCountTable(array1, array2) {
	    for (var i = 0; i < array1.length; i++) {
	        for (var j = 0; j < array1[i].length; j++) {
	        	$('#dmp' + i + "_" + j).html(array1[i][j]);
	        	
	        	$('#dmp' + i + "_" + j).removeClass('countOver');
	        	if (array1[i][j] > 2000) {
	        		$('#dmp' + i + "_" + j).addClass('countOver');	
	        	} 
	        }
	        
	        for (var j = 0; j < array2[i].length; j++) {
	        	$('#dmp' + i + "_a" + j).html(array2[i][j]);
	        	
	        	if (array2[i][j] > 2000) {
	        		$('#dmp' + i + "_a" + j).addClass('countOver');	
	        	} else {
	        		$('#dmp' + i + "_a" + j).removeClass('countOver');
	        	} 
	        }
	    }
	}
	
	function initControls() {
		$(".kendoDropDown").kendoDropDownList();
		$(".kendoNumeric").kendoNumericTextBox({
			decimals: 9,
			format: "{0:#.#########}",
			step: .001
		});
		$('.kendoPMToggle').kendoSwitch({
	        messages: {
	            checked: "Expand",
	            unchecked: "Collapse"
	        },
	        change: function (e) {
	            var cbody = this.element.closest('.card').find('.card-body');
	            if (e.checked) {
	            	cbody.hide();
	            } else {
	            	cbody.show();
	            }
	        }
	    });
		
		$('#nextButton').click(function() {
			$('#submitForm').prop("action", "${path}/mo/visual/list_pre.do");
			$('#submitForm').prop("target", "_self");
			$('#submitForm').prop("method", "post");
    		$('#submitForm').submit() ;
		});
		
		$('#kaplanMeierButton').click(function() {
			popupKaplanMeier();
		});
		
		$('#kaplanMeierSampleButton').click(function() {
			popupKaplanMeier(true);
		});
		
		$('#historyButton').click(function() {
			var url = "${path}/mo/history/preset/list.do?popYn=Y";
			var win = window.open(url, "PopupHistoryOffset", "width=1500,height=820");
		});
		
		//Methylation
		$('#selectDmpType').change(function() {
			if ($(this).val() == 'ChAMP') {
				$('#dmp_delta_beta').show();
				$('#dmp_intercept').hide();
			} else {
				$('#dmp_delta_beta').hide();
				$('#dmp_intercept').show();
			}
		});
		
		$('#dmpButton').click(function() {
			$('#divDmpCount').hide();
			$('#dmpButton').hide();
			$('#dmpLoding').show();
			$('#dmpType').val($('#selectDmpType').val());
			
			if ($('#selectDmpType').val() == 'DmpFinder') {
				$('.dmpFcLabel').text('intercept');
			} else {
				$('.dmpFcLabel').text('delta beta');
			} 
			
			$.ajax({
	            url: "${path}/mo/basic/dmp_start.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	//console.log(data);
	    			if(data.res == "ok") {
	    				fillDmpCountTable(data.data.dmpAdjPValueCount, data.data.dmpPValueCount);	
	    				$('#divDmpCount').show();
	    				$('#dmpFilterButton').show();
	            	}
	    			alert(data.msg);
	                
	            },
	            complete: function(data) {
	            	$('#dmpButton').show();
    				$('#dmpLoding').hide();
    			}
	        });
			alert("Proceed with DMP basic analysis. \nPlease press 'Confirm' and wait for a moment. \nAfter the task is complete, please apply the filters.");
		});
		
		$('#pcaMethButton').click(function() {
			$('#pcaMethButton').hide();
			$('#pcaMethLoding').show();
			alert("Proceed with methylation PCA analysis. \nPlease press 'Confirm' and wait for a moment. \nAfter the task is complete, a popup window will open.");
			$.ajax({
	            url: "${path}/mo/basic/pca_meth_start.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	//console.log(data);
	            	
	    			alert(data.msg);
	    			if(data.res == "ok") {
	    				popupPcaMeth();		
	            	}
	            },
	            complete: function() {
	            	$('#pcaMethButton').show();
	    			$('#pcaMethLoding').hide();
	            }
	        });
		});
		
		$('#dmpFilterButton').click(function() {
			$('#dmpFilterButton').hide();
			$('#dmpFilterLoding').show();
			if($('#dmpType').val() == '')
				$('#dmpType').val($('#selectDmpType').val());
			isMethDone = false;
			
			$.ajax({
	            url: "${path}/mo/basic/dmp_filter.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	//console.log(data);
	    			alert(data.msg);
	    			if(data.res == "ok") {
	    				isMethDone = true;
	    				makeMethHeatmap(data.data);
	    				showNextButton();
	            	}
	            },
	            complete: function(data) {
	            	$('#dmpFilterButton').show();
    				$('#dmpFilterLoding').hide();
    			}
	        });
		});
		
		$('#dmpSampleButton').click(function() {
			$.ajax({
	            url: "${path}/mo/basic/dmp_heat_sample.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	                //console.log(data);
	                makeMethHeatmap(data);
	                
	            },
	            complete: function() {}
	        });
		});
		
		//Expression
		$('#expType').change(function() {
			if ($(this).val() == 'tpm') {
				$('#wrapperExpTpm').show();
				$('#wrapperExpCnt').hide();
			} else {
				$('#wrapperExpTpm').hide();
				$('#wrapperExpCnt').show();
			}
		});
		
		$('#pcaButton').click(function() {
			$('#pcaButton').hide();
			$('#pcaLoding').show();
			alert("Proceed with PCA analysis. \nPlease press 'Confirm' and wait for a moment. \nAfter the task is complete, a popup window will open.");
			$.ajax({
	            url: "${path}/mo/basic/pca_start.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	//console.log(data);
	            	
	    			alert(data.msg);
	    			if(data.res == "ok") {
	    				popupPca();		
	            	}
	            },
	            complete: function() {
	            	$('#pcaButton').show();
	    			$('#pcaLoding').hide();
	            }
	        });
		});
		
		$('#expDownButton').click(function() {
			var url = "${path}/mo/basic/expCountDown.do";
			if ($('#expType').val() == 'tpm') {
				var url = "${path}/mo/basic/expTpmDown.do";
			}
			
			$('#submitForm').prop("action", url);
			$('#submitForm').prop("target", "_blank");
			$('#submitForm').prop("method", "post");
	        $('#submitForm').submit() ;
		});
		
		$('#metDownButton').click(function() {
			var url = "${path}/mo/basicmetBetaDown.do";
			if ($('#methType').val() == 'betaValue') {
				var url = "${path}/mo/basic/metBetaDown.do";
			}
			
			$('#submitForm').prop("action", url);
			$('#submitForm').prop("target", "_blank");
			$('#submitForm').prop("method", "post");
	        $('#submitForm').submit() ;
		});

		$('#methDensityButton').click(function() {
			popupDensity();
		});
		
		$('#methDmpAnnoButton').click(function() {
			popupDmpAnnotation();
		});
		
		$('#expDegAnnoButton').click(function() {
			popupDegAnnotation();
		});
		
		$('#pcaSampleButton').click(function() {
			popupPca(true);
		});
		
		$('#volcanoButton').click(function() {
			popupVolcano();
		});
		
		$('#volcanoSampleButton').click(function() {
			popupVolcano(true);
		});
		
		$('#degButton').click(function() {
			$('#divDegCount').hide();
			$('#degButton').hide();
			$('#degStatusIcon').show();
			$('#degStatusTxt').text($('#selectDegType').val() +  ' in progress');
			$('#degType').val($('#selectDegType').val());
			
			alert("Proceed with DEG basic analysis. \nPlease press 'Confirm' and wait for a moment. \nAfter the task is complete, please apply the filters.");
			$.ajax({
	            url: "${path}/mo/basic/deg_start.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	// console.log(data);
	    			alert(data.msg);
	    			if(data.res == "ok") {
	    				fillDegCountTable(data.data.degAdjPValueCount, data.data.degPValueCount);	
	    				$('#divDegCount').show();
	    				$('#degFilterButton').show();
	            	}
	                
	            },
	            complete: function(data) {
	            	$('#degButton').show();
    				$('#degStatusIcon').hide();
    				$('#degStatusTxt').text($('#degType').val() +  ' complete');
    			}
	        });
		});
		
		$('#degFilterButton').click(function() {
			$('#degFilterButton').hide();
			$('#degFilterLoding').show();
			if($('#degType').val() == '')
				$('#degType').val($('#selectDegType').val());
			
			isExpDone = false;
			$.ajax({
	            url: "${path}/mo/basic/deg_filter.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	// console.log(data);
	    			alert(data.msg);
	    			if(data.res == "ok") {
	    				isExpDone = true;
	    				makeExpHeatmap(data.data);
	    				showNextButton();
	            	}
	                $('#volcanoButton').show();
	                
	            },
	            complete: function(data) {
	            	$('#degFilterButton').show();
    				$('#degFilterLoding').hide();
    			}
	        });
		});
		
		$('#degSampleButton').click(function() {
			$.ajax({
	            url: "${path}/mo/basic/deg_heat_sample.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	                //console.log(data);
	                makeExpHeatmap(data);
	                
	            },
	            complete: function() {}
	        });
		});
		
		$('#expHeatmapZScoreButton').click(function() {
			expHeatmap.transform("zscore", "samples", null, null);
			expHeatmap.updateTextColorAttribute(["setMinX"], -2);
			expHeatmap.updateTextColorAttribute(["setMaxX"], 2);
		});
		
		$('#expHeatmapClusterButton').click(function() {
			expHeatmap.clusterSamples(true, null);
		});
		
		// mutation
		$('#mutType').change(function() {
			if ($(this).val() == 'SNV') {
				$('#wrapperMutationSnv').show();
				$('#wrapperMutationIndel').hide();
			} else {
				$('#wrapperMutationSnv').hide();
				$('#wrapperMutationIndel').show();
			}
		});
		
		$('#mutSampleButton').click(function() {
			makeMutHeatmapSample()
		});
		
		$('#mutExcButton').click(function() {
			$('#mutExcButton').hide();
			$('#mutLoding').show();
			isMutDone = false;
			$.ajax({
	            url: "${path}/mo/basic/mut_exc.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	//console.log(data);
	    			alert(data.msg);
	    			if(data.res == "ok") {
	    				isMutDone = true;
	    				makeMutHeatmap(data.data);
	    				showNextButton();
	            	}
	            },
	            complete: function(data) {
	            	$('#mutExcButton').show();
    				$('#mutLoding').hide();
    			}
	        });
		});
		
		//
		
		$('#savePresetButton').click(function(){
			savePreset();
		});	
		
		$("#varAnnoButton").click(function(){
			popupVariantAnnotation();
			
		})
	}
	
	function showPresetModal(ht_type) {
		$('#m_ht_type').val(ht_type);
		$('#ht_title').val('');
		$('#ht_note').val('');
		$('#savePresetModal').modal('show');
	}
	
	function savePreset() {
	    $.ajax({
	        url: "${path}/mo/visual/create_preset_action.do",
	        type: "POST",
	        data: $('#savePresetForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
				if (data.res == "ok") {
					alert('저장하였습니다.');
					
					$('#savePresetModal').modal('hide');
	        	} else {
	        		alert('저장 중 오류가 발생했습니다.');
	        	}
	        }
	    });
	}
	
	function popupDensity() {
		var win = window.open("", "PopupDensityPlot", "width=850,height=820");
		
		var url = "${path}/mo/basic/popup/density.do";

		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupDensityPlot");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}
	
	function popupDegAnnotation() {
		var win = window.open("", "PopupDegAnnotation", "width=1600,height=820");
		
		var url = "${path}/mo/basic/popup/degAnnotation.do";

		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupDegAnnotation");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}
	
	function popupDmpAnnotation() {
		var win = window.open("", "PopupDmpAnnotation", "width=1600,height=820");
		
		var url = "${path}/mo/basic/popup/dmpAnnotation.do";

		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupDmpAnnotation");
		$('#submitForm').prop("method", "post");
        $('#submitForm').submit() ;
	}
	
	function popupVariantAnnotation() {
		var win = window.open("", "PopupVariantAnnotation", "width=1600,height=820");
		
		var url = "${path}/mo/basic/popup/varAnnotation.do";

		/* $("#type").val($("#mutType").val()) */
		$('#submitForm').prop("action", url);
		$('#submitForm').prop("target", "PopupVariantAnnotation");
		$('#submitForm').prop("method", "post");
		var typeInput = $("<input />").attr("type", "hidden")
			.attr("name", "type")
        	.attr("value", ($("#mutType").val()=='SNV' ? 'MutationSnv' : 'MutationIndel'));
        typeInput.appendTo("#submitForm");
        $('#submitForm').submit() ;
        typeInput.remove();
	}
	
</script>

<!-- heatmap -->
<script type="text/javascript">	
	
	function makeExpHeatmap(data) {
		$('#divHeatmap').show();
		$('#divExp1').show();
		
		CanvasXpress.destroy('expHeatmap1');
		$('#wrapperExpHeatmap1').html("<div><canvas id='expHeatmap1' width='1000' height='600'></canvas></div>");
		
		var expHeatmapSmps = data.geneList;
		var expHeatmapVars = data.sampleList;
		var expHeatmapData = data.heatmapDataList;
		var expHeatmapGroup = data.sampleGroupList;
		
		expHeatmap = new CanvasXpress({
		    "version": 37.3,
		    "renderTo": "expHeatmap1",
		    "data": {
		        "y": {
		            "smps": expHeatmapSmps,
		            "vars": expHeatmapVars,
		            "data": expHeatmapData
		        },
		        "z": {
		        	"Group": expHeatmapGroup 
		        }
	
		    },
		    "config": {
		        "colorSpectrum": ["blue","white","red"],
		        "graphType": "Heatmap",
		        //'transformData': 'zscore',
		        //"title": "Expression",
		        "broadcast": true,
		        "heatmapIndicatorPosition": "topRight",
		        //"heatmapIndicatorHeight" : 40,
		        //"heatmapIndicatorWidth": 600,
		        //"samplesClustered": true,
		        //"variablesClustered": true,
		        
		        'varOverlays': ['Group'],
		        'varOverlayProperties': {
		        	'Group': {
		                'position': 'top',
		                'showLegend': 'true',
		                'thickness': 20,
		                'type': 'Default',
		                'scheme': 'Matlab',
		                'color': 'rgb(248,204,3)',
		                'spectrum': ['rgb(69,117,180)','rgb(145,191,219)','rgb(224,243,248)','rgb(255,255,191)','rgb(254,224,144)','rgb(252,141,89)','rgb(215,48,39)'],
		                'showName': true,
		                'showBox': true,
		                'rotate': false
		            }
		        }
		    },
		    
		    "info": false,
		    "afterRenderInit": false,
		    "noValidate": true
		    
		});
		
		expHeatmap.updateTextColorAttribute(["setMinX"], data.degMin);
		expHeatmap.updateTextColorAttribute(["setMaxX"], data.degMax);
	}
	//*
	function makeMethHeatmap(data) {
		$('#divHeatmap').show();
		$('#divMeth1').show();
		
		CanvasXpress.destroy('methHeatmap1');
		$('#wrapperMethHeatmap1').html("<div><canvas id='methHeatmap1' width='1000' height='600'></canvas></div>");
		
		var methHeatmapSmps = data.geneProbeList;
		var methHeatmapVars = data.sampleList;
		var methHeatmapData = data.heatmapDataList;
		var methHeatmapGroup = data.sampleGroupList;
		//var methCoefficient = data.coefficientList; // -1, 1 추가
		
		methHeatmap = new CanvasXpress({
		    "version": 37.3,
		    "renderTo": "methHeatmap1",
		    "data": {
		    	'x': {
		    		//'coefficient': methCoefficient 
		    	},
		        "y": {
		        	"smps": methHeatmapSmps,
		            "vars": methHeatmapVars,
		            "data": methHeatmapData
		        },
		        "z": {
		        	"Group": methHeatmapGroup 
		        }
		    },
		    "config": {
		        "colorSpectrum": ["blue","white","red"],
		        //"colorSpectrumBreaks": [0,0.5,1],
		        "graphType": "Heatmap",
		        //"title": "Methylation",
		        "heatmapIndicatorPosition": "topRight",
		        //"heatmapIndicatorHeight" : 25,
		        //"heatmapIndicatorWidth": 400,
		        /*
		        'smpOverlays': ['coefficient'],
		        'smpOverlayProperties': {
		        	'coefficient': {
		                'type': 'Heatmap',
		                //'showHeatmapIndicator' : true,
		                //"heatmapIndicatorPosition": "topRight",
		                
		                'thickness': 70,
		                //'spectrum': ["navy","white","firebrick3"],
		                //'spectrum': ['#4575b4', '#91bfdb', '#e0f3f8', '#ffffbf', '#fee090', '#fc8d59', '#d73027'],
		                
		                'position': 'right',
		                'color': 'rgb(255,175,84)',
		                //'scheme': 'User',
		                'showLegend': true,
		                'showName': true,
		                'showBox': true,
		                'rotate': true
		            },
		        },
		        */
		        'varOverlays': ['Group'],
		        'varOverlayProperties': {
		        	'Group': {
		                'position': 'top',
		                'showLegend': 'true',
		                'thickness': 20,
		                'type': 'Default',
		                'scheme': 'Matlab',
		                'color': 'rgb(248,204,3)',
		                'spectrum': ['rgb(69,117,180)','rgb(145,191,219)','rgb(224,243,248)','rgb(255,255,191)','rgb(254,224,144)','rgb(252,141,89)','rgb(215,48,39)'],
		                'showName': true,
		                'showBox': true,
		                'rotate': false
		            }
		        }
		    },
		});
		
	}
	
	function makeMutHeatmap(data) {
		$('#divHeatmap').show();
		$('#divMut1').show();
		
		CanvasXpress.destroy('mutHeatmap1');
		$('#wrapperMutHeatmap1').html("<div><canvas id='mutHeatmap1' width='1000' height='600'></canvas></div>");
		
		var mutHeatmapSmps = data.geneList;
		var mutHeatmapVars = data.sampleList;
		var mutHeatmapData = data.heatmapDataList;
		var mutHeatmapData3 = data.heatmapData3List;
		var mutHeatmapData4 = data.heatmapData4List;
		var mutHeatmapGroup = data.sampleGroupList;
		
		/*
		var mutHeatmapSmps = ySmps;		//data.geneProbeList;
		var mutHeatmapVars = yVars;		//data.sampleList;
		var mutHeatmapData = yData;		//data.heatmapDataList;
		var mutHeatmapData3 = yData3;	//data.heatmapData3List;
		var mutHeatmapData4 = yData4;	//data.heatmapData4List;
		*/
		
		
		mutHeatmap = new CanvasXpress({
		    "version": 37.3,
		    "renderTo": "mutHeatmap1",
		    "data": {
		        "y": {
		        	"smps": mutHeatmapSmps,
		            "vars": mutHeatmapVars,
		            "data": mutHeatmapData,
		            "data3": mutHeatmapData3,
		            "data4": mutHeatmapData4,
		        },
		        //*
		        "z": {
		        	"Group": mutHeatmapGroup 
		        }
		        //*/
		    },
		    "config": {
		    	'graphType': 'Heatmap',
		        'oncoprintCNA': 'data3',
		        'oncoprintMUT': 'data4',
		        'overlaysThickness': 100,
		        'graphOrientation': 'horizontal',
		        /*
		        'varOverlays': ['Group'],
		        'varOverlayProperties': {
		        	'Group': {
		                'position': 'top',
		                'showLegend': 'true',
		                'thickness': 20,
		                'type': 'Default',
		                'scheme': 'Matlab',
		                'color': 'rgb(248,204,3)',
		                'spectrum': ['rgb(69,117,180)','rgb(145,191,219)','rgb(224,243,248)','rgb(255,255,191)','rgb(254,224,144)','rgb(252,141,89)','rgb(215,48,39)'],
		                'showName': true,
		                'showBox': true,
		                'rotate': false
		            }
		        }
		    	*/
		    },
		});
		
	}
	//*/
</script>

			<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="${path}/mo/basic/list.do">
				<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }" />
				<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }" />
				<input type="hidden" name="ud_idx" id="ud_idx" value="${searchVO.ud_idx }"/>
				<input type="hidden" name="ws_idx" id="ws_idx" value="${searchVO.ws_idx }"/>
				<input type="hidden" name="wp_idx" id="wp_idx" value="${searchVO.wp_idx }"/>
				<input type="hidden" name="ps_idx" id="ps_idx" value="${searchVO.ps_idx }" />
				<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx }" />
				<input type="hidden" name="zscoreStatus" id="zscoreStatus" value="${searchVO.zscoreStatus }"/>
				<input type="hidden" name="geneSetType" id="geneSetType" value="${searchVO.geneSetType }"/>
				<input type="hidden" name="cg_idx" id="cg_idx" value="${searchVO.cg_idx }"/>
				<input type="hidden" name="std_type" id="std_type" value="A"/>

				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Basic result</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>Analysis<i class="fa fa-chevron-right ml-2 mr-2"></i>Basic result</div>
					</div>
				</div>
				<!-- //title -->
				
				<!-- 컨텐츠 영역 -->
				<div class="row">
					<section class="col-lg-12 ui-sortable">
							
									<div class="mt-3 initHide" >
										<div class="card">
											<div class="card-header">
												<h3 class="card-title">
													<i class="ion ion-clipboard mr-1"></i>샘플 조정 패널
												</h3>
											</div>
											<div class="card-body">
												<div class="row">
													<div class="col-6">
														<div id="testGrid1"></div>
													</div>
													<div class="col-6">
														<div id="testGrid2"></div>
													</div>
													
													<div class="col-lg-12 mt-3 text-right">
														<button type="button" id="clearFilterButton" class="btn btn-dark btn-sm"><i class="fas fa-redo-alt"></i>샘플 적용</button>
													</div>
												</div>
											</div>
										</div>
									</div>
					
					
						<div class="mt-3">
							<!-- contents start -->

							<!--  Data Sets -->
							<div class="row">
								<div class="col-lg-6">
									<ul class="nav nav-tabs" id="matrixTab" role="tablist">
										<li class="nav-item" role="presentation"><a class="nav-link active" id="tabExpression" data-toggle="tab" href="#panelExpression" role="tab">Expression</a></li>
										<li class="nav-item" role="presentation"><a class="nav-link " id="tabMethylation" data-toggle="tab" href="#panelMethylation" role="tab">Methylation</a></li>
										<li class="nav-item" role="presentation"><a class="nav-link " id="tabMutation" data-toggle="tab" href="#panelMutation" role="tab">Variant</a></li>
									</ul>
								</div>

								<div class="col-lg-6">
									<div class=" text-right">
										
										<a href="${path}/mo/clinic/list.do?cg_edit=Y&cg_idx=${searchVO.cg_idx }&ud_idx=${searchVO.ud_idx }" target="_self" class="btn btn-dark btn-sm">Reset sample</a>
										<button type="button" id="historyButton" class="btn btn-primary btn-sm">history Popup<!-- <i class="fas fa-external-link-alt"></i> --></button>
										<button type="button" id="kaplanMeierSampleButton" class="btn btn-dark btn-sm mr_20 initHide">KM (Kaplan-Meier) plot (example)</button>
										<button type="button" id="kaplanMeierButton" class="btn btn-primary btn-sm">KM (Kaplan-Meier) plot</button>
									</div>
								</div>
							</div>

							<div class="tab-content mt-3" id="matrixTabContent">
								<!-- tab 01-->
								<div class="tab-pane show active" id="panelExpression" role="tabpanel">
									<div class="card">
										<div class="card-body">
											<div class="row">
												<div class="col-lg-4 col-md-6">
													<select id="expType" name="expType" class="kendoDropDown form-control">
														<option value="count">Count</option>
														<option value="tpm">Tpm</option>
													</select>
												</div>
												
												<div class="col-lg-8 col-md-6 mb-3">
													<div class="inline mt-1 text-right">
														<button type="button" id="expDownButton" class="btn btn-dark btn-sm">Download tsv</button>
														<button type="button" id="pcaSampleButton" class="btn btn-dark btn-sm">PCA (example)</button>
														<button type="button" id="pcaButton" class="btn btn-primary btn-sm">Clustering</button>
														<button id="pcaLoding" class="btn btn-primary initHide" type="button" disabled="">
															<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
														</button>
													</div>
												</div>
											
											
												<div class="col-lg-12">
													<div id="wrapperExpCnt" class="dataTables_wrapper dt-bootstrap4">
														<div id="gridExpCnt"></div>
													</div>
												</div>
												<div class="col-lg-12">	
													<div id="wrapperExpTpm" class="dataTables_wrapper dt-bootstrap4">
														<div id="gridExpTpm"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="card">
										<div class="card-header">
											<h3 class="card-title">
												<i class="ion ion-clipboard mr-1"></i><strong>DEG</strong> (<strong>D</strong>ifferentially <strong>E</strong>xpressed <strong>G</strong>enes) analysis
											</h3>
										</div>

										<div class="card-body">
											<div class="row">
												<div class="col-lg-4 col-md-6">
													<div class="form-group">
														<input type="hidden" id="degType" name="degType" value="EdgeR"/>
														<select id="selectDegType" class="form-control">
															<option value="EdgeR">EdgeR</option>
															<option value="DESeq2">DESeq2</option>
														</select>
													</div>
												</div>

												<div class="col-lg-8 col-md-6">
													<button type="button" id="degButton" class="btn btn-primary "><i class="fas fa-play"></i> Run</button>
													<button id="degStatus" class="btn btn-secondary" type="button" disabled>
														<span id="degStatusIcon" class="spinner-border spinner-border-sm" role="status" aria-hidden="true" style="display: none;"></span>
														<span id="degStatusTxt">Not executed</span>
													</button>
													
												</div>

											</div>
										</div>
									</div>
									
									<div class="card">
										<div class="card-header">
											<h3 class="card-title">
												<i class="ion ion-clipboard mr-1"></i>DEG cutoff
											</h3>
										</div>

										<div class="card-body">
											<div class="row">
												<div class="col-lg-4">
													<label>| log2FC(Fold Change) | &gt;= </label> 
													<input type="text" id="searchLogFC" name="searchLogFC" class="kendoNumeric max-w120" style="" value="3">
												</div>
												
												<div class="col-lg-4">
													<input type="radio" id="searchPValueType_A" name="searchPValueType" value="A" class="mr-2" checked=""><label> adj.P value (FDR) &lt;  </label>&nbsp;
													<input type="text" id="searchAdjPValue" name="searchAdjPValue" class="kendoNumeric max-w120" value="0.05">
												</div>
												
												<div class="col-lg-4">
													<input type="radio" id="searchPValueType_P" name="searchPValueType" value="P" class="mr-2" checked=""> <label>P_value &lt; </label>&nbsp;
													<input type="text" id="searchPValue" name="searchPValue" class="kendoNumeric max-w120" value="0.05">
												</div>
												
												<div class="col-lg-12">
													<div id="divDegCount" class="mt-2 initHide">
														<h4>result count</h4>
														<div>
															<table class="table table-bordered">
																<thead>
																	<tr>
																		<th rowspan="2">   
																		</th>
																		<th colspan="${fn:length(degAdjPValue)}">
																			adj.PValue
																		</th>
																		<th colspan="${fn:length(degPValue)}">
																			PValue  
																		</th>
																	</tr>
																	<tr>
																		<c:forEach var="jh" items="${degAdjPValue}" varStatus="jhStatus">
																			<th>
																				&lt; ${jh }
																			</th>
																		</c:forEach>
																		<c:forEach var="jh" items="${degPValue}" varStatus="jhStatus">
																			<th>
																				&lt; ${jh }
																			</th>
																		</c:forEach>
																	</tr>
																</thead>
																<tbody>
																	
																	<c:forEach var="i" items="${degLog2FC}" varStatus="iStatus">
																		<tr>
																			<th>| log2FC(Fold Change) | >= ${i }</th>
																			<c:forEach var="j" items="${degAdjPValue}" varStatus="jStatus">
																				<td id="deg${iStatus.index }_${jStatus.index }">
																					${iStatus.index }_${jStatus.index }
																				</td>
																			</c:forEach>
																			<c:forEach var="j" items="${degPValue}" varStatus="jStatus">
																				<td id="deg${iStatus.index }_a${jStatus.index }">
																					${iStatus.index }_${jStatus.index }
																				</td>
																			</c:forEach>
																		</tr>
																		
																	</c:forEach>
																</tbody>
															</table>
														</div>
													</div>
												</div>
												<div class=" col-lg-12 text-right mt-3">
													<button type="button" id="degSampleButton" class="btn btn-dark btn-sm">Heatmap (example)</button>
													<!-- <button type="button" id="volcanoSampleButton" class="btn btn-dark btn-sm">샘플 volcano plot</button> -->
													<button type="button" id="degFilterButton" class="btn btn-primary btn-sm ${isLocal eq true ? '' : 'initHide' }"">Apply filter</button>
													<button id="degFilterLoding" class="btn btn-primary initHide btn-sm" type="button" disabled="">
														<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
													</button>
													<!-- <button type="button" id="volcanoButton" class="btn btn-primary  btn-sm">volcano plot</button> -->
												</div>
											</div>
										</div>
									</div>
								</div>
								<!--// tab 01-->
								
									
								<!-- tab 02-->
								<div class="tab-pane show active" id="panelMethylation" role="tabpanel">
									<div class="card">
										<div class="card-body">
											<div class="row">
												<div class="col-lg-4 col-md-6">
													<select id="methType" name="methType" class="kendoDropDown form-control">
														<option value="betaValue">Beta value</option>
													</select>
												</div>
												
												<div class="col-lg-8 col-md-6">
													<div class="inline mt-1 text-right">
														<button type="button" id="metDownButton" class="btn btn-dark btn-sm">Download tsv</button>
														<!-- <button type="button" id="pcaMethSampleButton" class="btn btn-secondary mr_20">샘플 pca plot</button> -->
														<button type="button" id="pcaMethButton" class="btn btn-primary">PCA plot</button>
														<button id="pcaMethLoding" class="btn btn-primary initHide" type="button" disabled>
															<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
														</button>
													</div>
												</div>
												
												<div class="col-lg-12 mt-3">
													<div id="wrapperMethylation" class="dataTables_wrapper dt-bootstrap4">
														<div id="gridMethylation"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="card">
										<div class="card-header">
											<h3 class="card-title">
												<i class="ion ion-clipboard mr-1"></i><strong>DMP</strong> (<strong>D</strong>ifferentially <strong>M</strong>ethylated <strong>P</strong>robes) analysis
											</h3>
										</div>

										<div class="card-body">
											<div class="row">
												<div class="col-lg-4 col-md-6">
													<div class="form-group">
														<input type="hidden" id="dmpType" name="dmpType" value="ChAMP"/>
														<select id="selectDmpType" class="form-control">
															<option value="ChAMP">ChAMP</option>
															<option value="DmpFinder">DmpFinder</option>
														</select>
													</div>
												</div>
												
												<div class="col-lg-8 col-md-6">
													<button type="button" id="dmpButton" class="btn btn-primary"><i class="fas fa-play"></i> Run</button>
													<button id="dmpLoding" class="btn btn-primary initHide" type="button" disabled>
														<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
													</button>
												</div>
												
											</div>
										</div>
									</div>
									
									<div class="card">
										<div class="card-header">
											<h3 class="card-title">
												<i class="ion ion-clipboard mr-1"></i>DMP cutoff
											</h3>
										</div>

										<div class="card-body">
											<div class="row">
												<div class="col-lg-4">
													<div>
														<label id="dmp_delta_beta">delta beta &gt;=  </label>
														<label id="dmp_intercept" class="initHide">intercept &gt;=  </label> 
														<input type="text" id="searchDmpLogFC" name="searchDmpLogFC" class="kendoNumeric max-w120" value="0.4">
													</div>
												</div>
												<div class="col-lg-4">
													<input type="radio" id="searchDmpPValueType_A" name="searchDmpPValueType" value="A" class="mr-2" checked=""><label for="searchDmpPValueType_A"> adj.P value (FDR) &lt;  </label>&nbsp; 
													<input type="text" id="searchDmpAdjPValue" name="searchDmpAdjPValue" class="kendoNumeric max-w120"  value="0.03">
												</div>
												
												<div class="col-lg-4">
													<input type="radio" id="searchDmpPValueType_P" name="searchDmpPValueType" value="P" class="mr-2" checked=""> <label for="searchDmpPValueType_P">P_value &lt; </label>&nbsp;
													<input type="text" id="searchDmpPValue" name="searchDmpPValue" class="kendoNumeric max-w120" value="0.03">
												</div>
												
												<div class="col-lg-12">
													<div id="divDmpCount" class="mt-2 initHide">
														<h4>result count</h4>
														<div>
															<table class="table table-bordered">
																<thead>
																	<tr>
																		<th rowspan="2">   
																		</th>
																		<th colspan="${fn:length(dmpAdjPValue)}">
																			adj.PValue
																		</th>
																		<th colspan="${fn:length(dmpPValue)}">
																			PValue  
																		</th>
																	</tr>
																	<tr>
																		<c:forEach var="jh" items="${dmpAdjPValue}" varStatus="jhStatus">
																			<th>
																				&lt; ${jh }
																			</th>
																		</c:forEach>
																		<c:forEach var="jh" items="${dmpPValue}" varStatus="jhStatus">
																			<th>
																				&lt; ${jh }
																			</th>
																		</c:forEach>
																	</tr>
																</thead>
																<tbody>
																	
																	<c:forEach var="i" items="${dmpLog2FC}" varStatus="iStatus">
																		<tr id="dmpCount_${iStatus.index }">
																			<th>
																				<div><span class="dmpFcLabel">delta beta </span>>= ${i }</div>
																			</th>
																			<c:forEach var="j" items="${dmpAdjPValue}" varStatus="jStatus">
																				<td id="dmp${iStatus.index }_${jStatus.index }">
																					${iStatus.index }_${jStatus.index }
																				</td>
																			</c:forEach>
																			<c:forEach var="j" items="${dmpPValue}" varStatus="jStatus">
																				<td id="dmp${iStatus.index }_a${jStatus.index }">
																					${iStatus.index }_${jStatus.index }
																				</td>
																			</c:forEach>
																		</tr>
																		
																	</c:forEach>
																</tbody>
															</table>
														</div>
													</div>
												</div>
												
												<div class=" col-lg-12 text-right mt-3">
													<button type="button" id="dmpSampleButton" class="btn btn-dark btn-sm">Heatmap (example)</button>
													<button type="button" id="dmpFilterButton" class="btn btn-primary btn-sm ${isLocal eq true ? '' : 'initHide' }">Apply filter</button>
													<button id="dmpFilterLoding" class="btn btn-primary btn-sm initHide" type="button" disabled="">
														<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
													</button>
												</div>
											</div>
										</div>
									</div>

								</div>
								<!-- //tab 02-->

								<!-- tab 03-->
								<div class="tab-pane show active" id="panelMutation" role="tabpanel">
									<div class="card">
										<div class="card-body">
											<div class="row">
												<div class="col-lg-4 col-md-6 mb-3">
													<select id="mutType" name="mutType" class="kendoDropDown form-control">
														<option value="SNV">SNV</option>
														<option value="Indel">Indel</option>
													</select>
												</div>


												<div class="col-lg-8 col-md-6">
													<!-- 
													<div class="inline mt-1 text-right">
														<button type="button" id="mutSampleButton" class="btn btn-dark btn-sm ">샘플 Oncoprint</button>
													</div>
													 -->
												</div>
												
												<div class="col-lg-12">
													<div id="wrapperMutationSnv" class="dataTables_wrapper dt-bootstrap4">
														<div id="gridMutationSnv"></div>
													</div>
												</div>
												
												<div class="col-lg-12">
													<div id="wrapperMutationIndel" class="dataTables_wrapper dt-bootstrap4">
														<div id="gridMutationIndel"></div>
													</div>
												</div>
												
												<div class=" col-lg-12 text-right mt-3">
													<button type="button" id="mutSampleButton" class="btn btn-secondary mr_20 ">Oncoprint (example)</button>
													<button type="button" id="mutExcButton" class="btn btn-primary" ><i class="fas fa-play"></i> Run</button>
													<button id="mutLoding" class="btn btn-primary btn-sm initHide" type="button" disabled="">
														<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
													</button>
												</div>
											</div>
											
										</div>
									</div>
								</div>
							</div>
							
							<!--  Data Sets -->
							<div class="row">
								<div id="divHeatmap" class="col-lg-12 initHideT">
									<div class="card mt-3">
										<div class="card-header">
											<h3 class="card-title">
												<i class="ion ion-clipboard mr-1"></i>1<sup>st</sup> result

											</h3>
										</div>
		
										<div class="card-body">
											<div class="row justify-content-center">
												<div id="divExp1" class="col-lg-12 initHideT">
													<div class="white_box mb_20">
												
														
														<div class="card mt-3">
															<div class="card-header">
																<h3 class="card-title">
																	<!-- <i class="ion ion-clipboard mr-1"></i> -->
																	<input id="switchExp1" class="kendoPMToggle mr-2"/> Expression 
																</h3>
															</div>
															
															<div class="card-body" id="cbodyExp1">
															
																<ul class="nav nav-tabs" id="expResTab" role="tablist">
																	<li class="nav-item" role="presentation">
																		<a class="nav-link active" id="expResTab1" data-toggle="tab" href="#expResPanel1" role="tab">DEG</a>
																	</li>
																	<li class="nav-item" role="presentation">
																		<a class="nav-link " id="expResTab2" data-toggle="tab" href="#expResPanel2" role="tab">Script</a>
																	</li>
																</ul>
																
																<div class="tab-content" id="myTabContent">
																	<div class="tab-pane fade show active" id="expResPanel1" role="tabpanel">
																		<div class="mt-3">
																			<div class="row">
																				<div class="col-12 mb-2">
																					Z-Score Log2(TPM+1)
																					<!-- <button type="button" id="expHeatmapZScoreButton" class="btn btn-sm btn-primary ml-3 inline">Z-Score</button> -->
																					<button type="button" id="expHeatmapClusterButton" class="btn btn-sm btn-primary inline">Cluster</button>
																					<button type="button" id="expDegAnnoButton" class="btn btn-sm btn-primary ml-3 inline">Deg annotation</button>
																					<!-- 
																					<div class="float-right">
																						<button type="button" class="btn btn-dark" id="BtnExpModal" onclick="showPresetModal('exp')">Expression 저장</button>
																					</div>
																					 -->
																				</div>
																				<div class="col-12">
																
																					<div id="wrapperExpHeatmap1" style="width: 100%; height: 100%;">
																						<div>
																							<canvas id='expHeatmap1' width='1000' height='600'></canvas>
																						</div>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																
												
											
															
																	<div class="tab-pane fade" id="expResPanel2" role="tabpanel">
																		<textarea style="height: 400px; width: 100%;" readonly="readonly">#!/usr/bin/env R

args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
    stop("All argument must be supplied ex) input_count_file group1_count group2_count",call.=FALSE)
}

input_count_file = "input.Count.txt"
group1_count = ${fn:length(searchVO.sample1List) }
group2_count = ${fn:length(searchVO.sample2List) }

group1_count = as.numeric(group1_count)
group2_count = as.numeric(group2_count)

library("preprocessCore")
library("edgeR")

## filtered COUNT
data <- read.table(input_count_file, row.names=1, header=T, sep="\t")
dimnames <- dimnames(data)
dim(data)

### make a group
group <- factor(rep(c(1, 2), c(group1_count, group2_count)))

### make a DEGlist
y <- DGEList(counts=data, group = group)

### cutoff at least 1 count per million(CPM) in 4 samples (because of 3 replication samples)
keep <- rowSums(cpm(y) > 1) >= 4
y <- y[keep, , keep.lib.size=TRUE]

### normalize
if ( group1_count < 3 || group2_count < 3 ) {
    print('under 3')
    bcv <- 0.2
    design <- model.matrix(~0 + group, data = y$samples)
    fit <- glmFit(y, design, dispersion=bcv^2)    
} else {
    print('up 3')
    y <- calcNormFactors(y)
    y <- estimateDisp(y)
    design <- model.matrix(~0 + group, data=y$samples)
    fit <- glmFit(y, design)
}

### DEGs of Tumor_vs_Normal
Tumor_vs_Normal = makeContrasts(group2 - group1, levels=design)
lrt.Tumor_vs_Normal = glmLRT(fit, contrast = Tumor_vs_Normal)
DEGs.Tumor_vs_Normal = topTags(lrt.Tumor_vs_Normal , n=Inf, sort.by="logFC")
write.table(DEGs.Tumor_vs_Normal , file="./temp.txt", sep="\t", quote=FALSE)
</textarea>
																			
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
														
												<div id="divMeth1" class="col-lg-12 initHideT">
													<div class="card mt-3">
														<div class="card-header">
															<h3 class="card-title">
																<!-- <i class="ion ion-clipboard mr-1"></i> -->
																<input id="switchMeth1" class="kendoPMToggle mr-2"/> Methylation
															</h3>
														</div>
						
														<div class="card-body" id="cbodyMeth1">
															<ul class="nav nav-tabs" id="methResTab" role="tablist">
																<li class="nav-item" role="presentation">
																	<a class="nav-link active" id="methResTab1" data-toggle="tab" href="#methResPanel1" role="tab">DMP</a>
																</li>
																<li class="nav-item" role="presentation">
																	<a class="nav-link " id="methResTab2" data-toggle="tab" href="#methResPanel2" role="tab">Script</a>
																</li>
															</ul>
														
															<div class="tab-content" id="myTabContent">
																<div class="tab-pane fade show active" id="methResPanel1" role="tabpanel">
																	<div class="mt-2 mb-2">
																		<div class="row">
																			<div class="col-12 mb-2">
																				<button type="button" id="methDensityButton" class="btn btn-sm btn-primary ml-3 inline">Top100 Density Plot</button>
																				<button type="button" id="methDmpAnnoButton" class="btn btn-sm btn-primary inline">DMP annotation</button>
																				<!-- 
																				<div class="float-right">
																					<button type="button" class="btn btn-dark" id="BtnMethModal" onclick="showPresetModal('meth')">Methylation 저장</button>
																				</div>
																				 -->
																			</div>
																		</div>
																	</div>
																	<div id="wrapperMethHeatmap1" style="width: 100%; height: 100%;">
																		<div>
																			<canvas id='methHeatmap1' width='600' height='800'></canvas>
																		</div>
																	</div>
																</div>
																
																<div class="tab-pane fade" id="methResPanel2" role="tabpanel">
																	<textarea style="height: 400px; width: 100%;" readonly="readonly">#!/usr/bin/env R

args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
    stop("All argument must be supplied ex) input_methyl_file group1_count group2_count",call.=FALSE)
}

input_methyl_file = "input.txt"
group1_count = ${fn:length(searchVO.sample1List) }
group2_count = ${fn:length(searchVO.sample2List) }

library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)
library(ChAMP)

data = read.table(input_methyl_file, sep = '\t', header = T, row.names = 1)
dimnames <- dimnames(data)
dim(data)

ann850k = getAnnotation(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)

## create list
methyl_data = list()
methyl_data$beta = data

### make a group
group <- c(rep('1', group1_count), rep('2', group2_count))
pd = as.data.frame(group)
pd$sample_name = colnames(data)
methyl_data$pd = pd

### normalize
myNorm <- champ.norm(beta=methyl_data$beta, arraytype = 'EPIC', core = 5)

### DMPs of Group1_vs_Group2
myDMP = champ.DMP(beta = myNorm , pheno = methyl_data$pd$group, arraytype = 'EPIC', adjPVal = 0.05)
#anno = ann850k[match(rownames(myDMP$"1_to_2"), ann850k$Name), c(1:4,12:19,24:ncol(ann850k))]

### Results
#results = cbind(myDMP$"1_to_2"[,1:9], anno)
write.table(myDMP$"1_to_2", file = 'DMP_table.txt', sep ='\t', quote = F, col.names=NA)

### DMRs of Group1_vs_Group2
#myDMR = champ.DMR(beta = myNorm, pheno = methyl_data$pd$group, arraytype = 'EPIC', method="Bumphunter")
#write.table(myDMR$BumphunterDMR, file = 'DMR_table.txt', sep = '\t', quote = F, col.names = NA)

																	</textarea>
																</div>
															</div>
																
														</div>
													</div>
												</div>
												
												<div id="divMut1" class="col-lg-12 initHideT">
													<div class="card mt-3">
														<div class="card-header">
															<h3 class="card-title">
																<!-- <i class="ion ion-clipboard mr-1"></i> -->
																<input id="switchMeth1" class="kendoPMToggle mr-2"/> Variant
																<!-- 
																<button type="button" id="vDensityButton" class="btn btn-sm btn-primary ml-20 inline">Top100 Density Plot</button>
																<button type="button" id="vmpAnnoButton" class="btn btn-sm btn-primary inline">DMP annotation</button>
																 -->
															</h3>
														</div>
						
														<div class="card-body" id="cbodyMut1">
															<div class="mb-2">
																<div class="row">
																	<div class="col-12 mb-2">
																		<button type="button" id="varAnnoButton" class="btn btn-sm btn-primary inline">Variant annotation</button>
																		<!-- 
																		<div class="float-right">
																			<button type="button" class="btn btn-dark" id="BtnMutModal" onclick="showPresetModal('mut')">Variant 저장</button>
																		</div>
																		 -->
																	</div>
																</div>
															</div>
															
															<div id="wrapperMutHeatmap1" style="width: 100%; height: 100%;">
																<div>
																	<canvas id='mutHeatmap1' width='600' height='800'></canvas>
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
							
							<!-- 버튼 -->
							<div class="row btn-area">
								<div class="col-lg-12 text-right">
									<div>
										<button type="button" id="nextButton" class="btn btn-dark" >Next <i class="fas fa-chevron-right"></i></button>
									</div>
								</div>
							</div>
							<!--//  버튼 -->
							<!-- // contents end -->
							
						</div>
					</section>
				</div>
			</form:form>

			
			
	<!-- Modal Preset 저장 -->
	<div class="modal fade" id="savePresetModal" tabindex="-1" role="dialog" aria-labelledby="savePresetModalLabel" aria-hidden="true">
		<form id="savePresetForm" name="savePresetForm" action="${path}/mo/visual/create_preset_action.do" method="post">
			<input type="hidden" name="wp_idx" id="m_wp_idx" value="${searchVO.wp_idx }"/>
			<input type="hidden" name="ws_idx" id="m_ws_idx" value="${searchVO.ws_idx }"/>
			<input type="hidden" name="ud_idx" id="m_ud_idx" value="${searchVO.ud_idx }"/>
			<input type="hidden" name="me_idx" id="m_me_idx" value="${searchVO.me_idx }"/>
			<%-- 
			<input type="hidden" name="ps_idx" id="m_ps_idx" value="${searchVO.ps_idx }" />
			<input type="hidden" name="std_idx" id="m_std_idx" value="${searchVO.std_idx }" />
			 --%>
			<input type="hidden" name="ht_type" id="m_ht_type" value=""/>
			
		
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="groupSaveModalLabel"><span>Single Omics 저장</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">×</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="text-left mt-3">
							<table class="table table-bordered table-block">
								<colgroup>
									<col width="25%">
									<col width="75%">
								</colgroup>
	
								<tbody>
									<tr>
										<th><span class="text-danger">*</span>제목</th>
										<td>
											<div class="row">
												<div class="col-12"><input type="text" class="form-control" name="ht_title" id="ht_title" placeholder="제목을 입력해주세요." maxlength="199"></div>
											</div>
										</td>
									</tr>
									
									<tr>
										<th>코멘트</th>
										<td>
											<div class="row">
												<div class="col-12">
													<textarea class="form-control" name="ht_note" id="ht_note" placeholder="코멘트를 입력하세요." maxlength="1999" style="height:150px; resize: none;"></textarea>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="clearfix"></div>
					
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Close</button>
						<button type="button" class="btn btn-success" id="savePresetButton">저장 <i class="fas fa-chevron-right"></i></button>
					</div>
				</div>
			</div>
		</form>
	</div>
						
			

<!-- grid -->
<script type="text/javascript">

var expTpmGridFields = ${expGridTpmVO.gridFields};
var expTpmGridColumms = ${expGridTpmVO.gridColumns};
var expTpmGridData = ${expGridTpmVO.gridData};

var expCntGridFields = ${expGridCntVO.gridFields};
var expCntGridColumms = ${expGridCntVO.gridColumns};
var expCntGridData = ${expGridCntVO.gridData};

var methGridFields = ${methGridVO.gridFields};
var methGridColumms = ${methGridVO.gridColumns};
var methGridData = ${methGridVO.gridData};

var mutSnvGridFields = ${mutSnvGridVO.gridFields};
var mutSnvGridColumms = ${mutSnvGridVO.gridColumns};
var mutSnvGridData = ${mutSnvGridVO.gridData};

var mutIndelGridFields = ${mutIndelGridVO.gridFields};
var mutIndelGridColumms = ${mutIndelGridVO.gridColumns};
var mutIndelGridData = ${mutIndelGridVO.gridData};

function initExpGrid() {
	// Expression Grid
	var expTpmDataSource = new kendo.data.DataSource({
		data: expTpmGridData,
		pageSize: 100,
		schema: {
			model: {
				fields: expTpmGridFields
			}
		},
	});
	
	$("#gridExpTpm").kendoGrid({
		dataSource: expTpmDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 400,
		pageable: true,
		//selectable: "multiple",
		resizable: true,
		//sortable: true,
		//groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: expTpmGridColumms
	});
	
	var expCntDataSource = new kendo.data.DataSource({
		data: expCntGridData,
		pageSize: 100,
		schema: {
			model: {
				fields: expCntGridFields
			}
		},
	});
	
	$("#gridExpCnt").kendoGrid({
		dataSource: expCntDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 400,
		pageable: true,
		//selectable: "multiple",
		resizable: true,
		//reorderable: true,
		//sortable: true,
		//groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: expCntGridColumms
	});
	
	// Methylation Grid
	var methDataSource = new kendo.data.DataSource({
		data: methGridData,
		pageSize: 100,
		schema: {
			model: {
				fields: methGridFields
			}
		},
	});
	
	$("#gridMethylation").kendoGrid({
		dataSource: methDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 400,
		pageable: true,
		//selectable: "multiple",
		resizable: true,
		//sortable: true,
		//groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: methGridColumms
	});
	
	// Variant Snv Grid
	var mutSnvDataSource = new kendo.data.DataSource({
		data: mutSnvGridData,
		pageSize: 100,
		schema: {
			model: {
				fields: mutSnvGridFields
			}
		},
	});
	
	$("#gridMutationSnv").kendoGrid({
		dataSource: mutSnvDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 400,
		pageable: true,
		//selectable: "multiple",
		resizable: true,
		//sortable: true,
		//groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: mutSnvGridColumms
	});
	
	console.log("mutSnvGridColumms", mutSnvGridColumms);
	console.log("mutSnvGridFields", mutSnvGridFields);
	console.log("mutSnvDataSource", mutSnvDataSource);
	
	// Variant Indel Grid
	var mutIndelDataSource = new kendo.data.DataSource({
		data: mutIndelGridData,
		pageSize: 100,
		schema: {
			model: {
				fields: mutIndelGridFields
			}
		},
	});
	
	$("#gridMutationIndel").kendoGrid({
		dataSource: mutIndelDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 400,
		pageable: true,
		//selectable: "multiple",
		resizable: true,
		//sortable: true,
		//groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: mutIndelGridColumms
	});
	
	$('#panelMethylation').removeClass('active');
	$('#panelMethylation').removeClass('show');
	$('#panelMutation').removeClass('active');
	$('#panelMutation').removeClass('show');
	
	$('#wrapperExpTpm').hide();
	$('#wrapperMutationIndel').hide();
}
</script>









<script>

	function makeMutHeatmapSample() {
		$('#divHeatmap').show();
		$('#divMut1').show();
		
		CanvasXpress.destroy('mutHeatmap1');
		$('#wrapperMutHeatmap1').html("<div><canvas id='mutHeatmap1' width='1000' height='600'></canvas></div>");
		
		mutHeatmap = new CanvasXpress({
		    'version': 38.7,
		    'renderTo': 'mutHeatmap1',
		    'data': {
		        'y': {
		            'vars': yVars,
		            
		            'smps': ySmps,

		            'data': yData,
		            
		            //'data2': yData2,

		            'data3': yData4,
		            
		            'data4': yData4
		        },
		        //'z': zData
		    },
		    'config': {
		        'graphType': 'Heatmap',
		        'oncoprintCNA': 'data3',
		        'oncoprintMUT': 'data4',
		        'overlaysThickness': 100,
		        'graphOrientation': 'horizontal'
		    },
		    'info': false,
		    'afterRenderInit': false,
		    'afterRender': [
		        [
		            'setDimensions',
		            [696,609,true]
		        ]
		    ],
		    'noValidate': true
		  });
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	var yVars = ['TCGA-18-3406-01','TCGA-18-3407-01','TCGA-18-3408-01','TCGA-18-3409-01','TCGA-18-3410-01','TCGA-18-3411-01','TCGA-18-3412-01','TCGA-18-3414-01','TCGA-18-3415-01','TCGA-18-3416-01','TCGA-18-3417-01','TCGA-18-3419-01','TCGA-18-3421-01','TCGA-18-4083-01','TCGA-18-4086-01','TCGA-18-4721-01','TCGA-18-5592-01','TCGA-18-5595-01','TCGA-21-1070-01','TCGA-21-1071-01','TCGA-21-1076-01','TCGA-21-1077-01','TCGA-21-1078-01','TCGA-21-1081-01','TCGA-21-5782-01','TCGA-21-5784-01','TCGA-21-5786-01','TCGA-21-5787-01','TCGA-22-0944-01','TCGA-22-1002-01','TCGA-22-1011-01','TCGA-22-1012-01','TCGA-22-1016-01','TCGA-22-4591-01','TCGA-22-4593-01','TCGA-22-4595-01','TCGA-22-4599-01','TCGA-22-4601-01','TCGA-22-4604-01','TCGA-22-4607-01','TCGA-22-4613-01','TCGA-22-5471-01','TCGA-22-5472-01','TCGA-22-5473-01','TCGA-22-5474-01','TCGA-22-5477-01','TCGA-22-5478-01','TCGA-22-5480-01','TCGA-22-5482-01','TCGA-22-5485-01','TCGA-22-5489-01','TCGA-22-5491-01','TCGA-22-5492-01','TCGA-33-4532-01','TCGA-33-4533-01','TCGA-33-4538-01','TCGA-33-4547-01','TCGA-33-4566-01','TCGA-33-4582-01','TCGA-33-4583-01','TCGA-33-4586-01','TCGA-33-6737-01','TCGA-34-2596-01','TCGA-34-2600-01','TCGA-34-2608-01','TCGA-34-5231-01','TCGA-34-5232-01','TCGA-34-5234-01','TCGA-34-5236-01','TCGA-34-5239-01','TCGA-34-5240-01','TCGA-34-5241-01','TCGA-34-5927-01','TCGA-34-5928-01','TCGA-34-5929-01','TCGA-37-3783-01','TCGA-37-3789-01','TCGA-37-4133-01','TCGA-37-4135-01','TCGA-37-4141-01','TCGA-37-5819-01','TCGA-39-5016-01','TCGA-39-5019-01','TCGA-39-5021-01','TCGA-39-5022-01','TCGA-39-5024-01','TCGA-39-5027-01','TCGA-39-5028-01','TCGA-39-5029-01','TCGA-39-5030-01','TCGA-39-5031-01','TCGA-39-5035-01','TCGA-39-5036-01','TCGA-39-5037-01','TCGA-39-5039-01','TCGA-43-2578-01','TCGA-43-3394-01','TCGA-43-3920-01','TCGA-43-5668-01','TCGA-43-6143-01','TCGA-43-6647-01','TCGA-43-6770-01','TCGA-43-6771-01','TCGA-46-3765-01','TCGA-46-3766-01','TCGA-46-3767-01','TCGA-46-3768-01','TCGA-46-3769-01','TCGA-46-6025-01','TCGA-46-6026-01','TCGA-51-4079-01','TCGA-51-4080-01','TCGA-51-4081-01','TCGA-56-1622-01','TCGA-56-5897-01','TCGA-56-5898-01','TCGA-56-6545-01','TCGA-56-6546-01','TCGA-60-2698-01','TCGA-60-2707-01','TCGA-60-2708-01','TCGA-60-2709-01','TCGA-60-2710-01','TCGA-60-2711-01','TCGA-60-2712-01','TCGA-60-2713-01','TCGA-60-2715-01','TCGA-60-2719-01','TCGA-60-2720-01','TCGA-60-2721-01','TCGA-60-2722-01','TCGA-60-2723-01','TCGA-60-2724-01','TCGA-60-2725-01','TCGA-60-2726-01','TCGA-63-5128-01','TCGA-63-5131-01','TCGA-63-6202-01','TCGA-66-2727-01','TCGA-66-2734-01','TCGA-66-2742-01','TCGA-66-2744-01','TCGA-66-2754-01','TCGA-66-2755-01','TCGA-66-2756-01','TCGA-66-2757-01','TCGA-66-2758-01','TCGA-66-2759-01','TCGA-66-2763-01','TCGA-66-2765-01','TCGA-66-2766-01','TCGA-66-2767-01','TCGA-66-2768-01','TCGA-66-2770-01','TCGA-66-2771-01','TCGA-66-2773-01','TCGA-66-2777-01','TCGA-66-2778-01','TCGA-66-2780-01','TCGA-66-2781-01','TCGA-66-2782-01','TCGA-66-2783-01','TCGA-66-2785-01','TCGA-66-2786-01','TCGA-66-2787-01','TCGA-66-2788-01','TCGA-66-2789-01','TCGA-66-2791-01','TCGA-66-2792-01','TCGA-66-2793-01','TCGA-66-2794-01','TCGA-66-2795-01','TCGA-66-2800-01','TCGA-70-6722-01','TCGA-70-6723-01','TCGA-85-6175-01','TCGA-85-6560-01','TCGA-85-6561-01'];
	
	var ySmps = ['KRAS','HRAS','BRAF','RAF1','MAP3K1','MAP3K2','MAP3K3','MAP3K4','MAP3K5','MAP2K1','MAP2K2','MAP2K3','MAP2K4','MAP2K5','MAPK1','MAPK3','MAPK4','MAPK6','MAPK7','MAPK8','MAPK9','MAPK12','MAPK14','DAB2','RASSF1','RAB25'];
	
	
	
	
	
	
	
	
	
	var yData = [
        [-0.61375,-0.042833333,0.22325,-0.543,1.8155,1.5795,-1.085,0.315,2.06475,-0.6215,-0.088,-0.04175,-0.019,-1.4925,0.047625,-0.578833333,-2.77875,0.467166667,-0.5845,0.1875,0.374,-0.603666667,0.9445,-0.838,-0.554333333,2.189166667],
        [-0.183583333,1.242166667,-0.01325,0.05825,1.1145,1.5195,-1.079833333,0.10075,2.48875,-0.39725,1.4525,0.56075,0.134875,-0.6935,-0.30525,-0.378333333,-3.63725,0.815666667,-0.554166667,0.27,-0.08,-0.8545,0.5545,0.057375,-0.757166667,2.075166667],
        [1.118916667,0.068666667,0.21225,-0.76575,0.4625,1.3702,-1.589666667,0.0225,1.9595,-0.507125,-0.097,0.521333333,0.734625,-0.702833333,0.647875,-0.300333333,-3.11025,0.1075,-0.216166667,-0.3265,-0.15925,1.245666667,0.121083333,-0.461375,-0.693083333,2.4145],
        [0.424416667,-0.319,-0.01625,0.14375,1.0915,1.6242,-1.4735,-0.04025,0.92525,-0.196625,-0.677833333,0.40525,0.969125,-0.586666667,-0.0515,-0.597166667,-1.5,0.371666667,-0.303666667,0,-0.326,-1.280166667,-0.01575,0.87575,-0.461833333,1.1555],
        [0.425,0.478,0.81375,-0.2245,-0.5905,1.1962,-1.719833333,0.25825,1.97975,0.003,0.581333333,-0.467666667,-0.234,-0.243833333,-0.087875,-1.2905,-1.96975,0.778666667,-0.441166667,1.058,-0.94375,-1.335,-0.001416667,-0.723125,-0.346916667,2.007],
        [0.006916667,0.544666667,1.431,-0.86125,0.379,0.7195,-1.811833333,-1.06275,1.115,-0.563625,-0.305833333,0.691583333,-0.221375,-0.831,0.623875,-0.883833333,-3.471,0.317,-0.031,-0.3755,-1.2665,0.701833333,0.5825,0.665625,-0.780666667,2.169333333],
        [0.305583333,0.351333333,1.15375,-0.64125,0.1325,0.86,-1.491833333,-0.44375,0.962,-0.4995,-0.116333333,0.217583333,0.062625,-1.114166667,0.342,-0.231666667,-3.39725,0.555166667,-0.694833333,-0.2535,0.0925,0.522333333,0.468916667,-0.547125,-0.718916667,2.548166667],
        [0.25725,-0.192333333,1.28675,0.1405,-0.284,1.0057,-1.249666667,-0.20225,2.4885,0.024,-0.444833333,-0.088083333,-0.109125,-0.757666667,0.307875,-0.668833333,-2.92975,0.495833333,-0.7745,0.1235,-0.397,-0.428833333,-0.293166667,0.245625,-0.43575,2.75],
        [-0.06925,0.870833333,1.159,-0.489,0.861,1.4094,-1.571833333,-0.65075,1.024,-0.3505,0.112,0.088083333,0.1725,-0.951833333,0.757375,-0.3515,-3.032,1.551,-0.541333333,-0.1225,0.14775,0.632833333,0.649666667,-0.195375,-0.143833333,2.637166667],
        [-0.529916667,-0.285166667,0.55925,-0.414,-0.8615,1.2277,-1.078333333,0.585,3.006,-0.423375,-1.436666667,0.291166667,0.877125,-1.3885,0.235125,-1.753,-4.82725,-0.028833333,-0.890166667,-0.962,1.01275,-1.889333333,-0.414166667,0.61525,-0.53325,1.0245],
        [-0.585833333,0.175166667,0.74575,-1.06225,-2.654,0.4024,-1.184833333,0.10275,1.906,-0.200125,-0.500166667,0.575583333,-0.210875,-2.5815,-0.271625,-0.460333333,-2.43075,-0.168166667,-0.275833333,0.478,-0.19725,-0.416833333,-0.308583333,1.549375,-0.69575,2.327333333],
        [0.404583333,0.2385,1.0705,0.246,0.877,1.709,-0.748833333,-0.55125,1.138,0.403625,-0.016833333,-0.022583333,0.0385,-0.060333333,0.767375,-0.293833333,-3.97275,1.309666667,-1.178,0.4055,0.279,0.185666667,0.69975,-0.7775,-0.19125,2.1005],
        [-0.471166667,0.811666667,0.408,-0.82575,0.1175,0.6155,-1.466,-0.1055,0.84725,-0.199875,-0.073666667,-0.274,-0.380625,-0.246833333,-0.129,-0.583166667,-2.63275,1.248333333,-0.840666667,-0.499,-0.3735,0.238666667,-0.383583333,-0.396875,-0.418333333,2.662166667],
        [0.740333333,0.8795,0.85725,-0.17225,-0.222,0.478,-0.772666667,-0.45575,1.35775,-0.224875,-0.329833333,0.10225,0.159875,-0.686166667,-1.01025,-1.091833333,0.854,-0.531166667,-0.108333333,0.0005,-1.692,-1.323166667,-0.636083333,-0.445875,-0.704083333,1.1285],
        [0.83575,1.017833333,-0.36875,-0.683,-0.104,0.3394,-1.009833333,-0.42625,1.73075,0.016375,-0.194,-0.542166667,0.822625,-1.513833333,-0.26125,-0.950166667,-3.04025,0.263833333,-0.700833333,-0.0095,-0.69425,-0.143166667,-0.091,-0.319,-0.873166667,1.7195],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.4255,0.321,-0.16625,-0.409,0.1735,0.7018,-0.725666667,0.65125,2.55825,-0.511,-0.254333333,0.578333333,0.14875,-1.343833333,0.38575,-0.4865,-2.95925,-0.015,-0.155333333,0.2785,-0.626,-1.061666667,-0.0675,0.061875,-0.523166667,2.400333333],
        [0.684083333,0.428166667,0.09675,-0.26175,0.885,1.3748,-0.4755,0.81,2.12275,-0.117,0.065166667,-0.018333333,0.221625,-0.790666667,-0.4215,-0.713,-3.5445,0.717,-0.224833333,0.0285,0.78575,-0.035,-0.14,0.267,-0.668916667,1.811166667],
        [-0.527416667,-0.399666667,1.5315,-0.11325,-0.105,1.1541,0.141,0.48675,2.82675,-0.27375,-0.133333333,0.382166667,0.18325,-1.118,0.319625,-1.037666667,-2.99075,0.008333333,-0.140833333,-0.6365,-0.42575,-1.3805,-0.32325,1.657,-0.560416667,2.0535],
        [-0.191,0.5225,1.0845,-0.503,-0.596,0.4274,-0.6545,0.0055,1.68675,0.301875,-0.330333333,0.229416667,0.165375,0.014,1.12225,-1.1,-1.5615,0.593333333,-0.440166667,-0.3525,0.43325,1.272,0.29775,0.264625,-0.967666667,2.576833333],
        [-0.266833333,0.7065,0.38075,-0.1005,-0.9905,0.7909,-1.2185,0.078,3.68425,-0.55625,-0.197,0.602416667,0.842125,-0.367166667,-0.43175,-0.731333333,-1.60725,-0.1595,0.104166667,-0.432,-0.051,-2.838,-0.12625,-1.162,-1.60625,3.442666667],
        [-0.34,0.960333333,0.502,-0.25475,-0.477,-0.1395,-0.544666667,0.37425,2.2315,-0.585375,0.380833333,0.184583333,0.116875,-1.167833333,1.003,-0.065,-3.4125,0.0475,0.512333333,-0.5805,-0.91125,-0.146666667,0.0085,0.303625,-0.651416667,3.4145],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.28575,1.766,0.40325,-0.71375,-1.1495,0.2387,-1.321333333,0.58475,2.27075,0.1495,0.2,0.430833333,0.22925,-0.958333333,-0.0405,-0.396833333,-3.508,1.230666667,0.104833333,-0.3395,-0.889,-0.057666667,-0.136,-0.99725,-1.27225,2.525166667],
        [0.549666667,-0.3055,0.3255,-0.1,0.398,0.9675,0.249333333,0.273,2.087,-0.45325,-0.619333333,1.858,0.11925,-0.892666667,-0.061875,-0.4045,-1.296,-0.061833333,0.003666667,-0.1945,-0.78675,-1.608666667,-0.319666667,0.376,-1.225,2.101],
        [-0.740416667,0.920833333,-0.256,0.177,0.206,0.9284,-0.224166667,0.10475,2.81425,-0.061125,0.673666667,0.848666667,-0.04075,-0.396833333,-0.056625,0.323666667,-3.46225,0.998833333,-0.4835,0.2345,-0.47025,-0.457333333,0.117583333,0.116625,-0.331666667,2.3985],
        [1.110416667,1.621333333,1.828,-0.51775,-0.43,0.2712,-0.507,0.5805,0.9605,-0.793875,0.548166667,-0.412916667,-0.173375,-1.1575,0.6825,-0.1465,-3.2505,0.025666667,-0.066833333,-0.2005,-0.6195,-1.3635,-0.2295,-0.324375,-0.915416667,2.731166667],
        [0.179666667,0.329,-0.16775,-0.03775,0.777,0.7717,0.3715,-0.22225,2.26575,-0.505625,0.048666667,0.558333333,0.740125,-1.1345,-0.53975,-0.187833333,-1.75,-0.167833333,-0.062666667,-0.199,-0.19575,-1.416833333,0.13575,1.3915,-0.576083333,2.269666667],
        [0.162416667,0.0725,2.201,-0.804,-1.3525,0.7342,-1.284333333,0.43625,2.249,-0.736625,-0.8085,-0.687,0.29125,-1.385333333,0.8885,-0.812666667,-2.3455,-0.0765,-0.952,0.863,-0.169,-0.7205,0.5415,-0.632375,-0.64225,1.5715],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [1.48375,0.1565,0.56025,-0.40275,0.0385,1.3228,-1.007666667,0.2805,1.7585,-0.323,-0.166166667,-0.487916667,0.118125,-0.691,1.15275,-1.068,-0.97225,0.157333333,-0.4285,0.01,0.26,-1.808333333,0.270416667,0.381375,-0.714166667,1.0815],
        [-0.049916667,0.788833333,0.98975,-0.28775,-1.1245,0.7273,-0.941666667,-0.46975,1.79525,-0.450875,0.421833333,-0.232,0.003875,-1.347833333,0.203875,-0.876333333,-2.7945,-0.392666667,-0.778,-0.153,-0.38575,-0.607166667,-0.67275,0.108875,-0.733333333,0.2275],
        [-0.081166667,0.426833333,0.926,-0.2835,-1.1205,0.9753,-0.684333333,-0.3535,2.09025,0.09675,-0.472666667,0.92675,1.0485,-0.557666667,-0.7035,-0.286833333,-2.254,-0.216166667,0.095833333,0.0175,-0.1165,0.0015,-0.10625,-0.719125,-0.75775,2.8585],
        [0.508,-0.005333333,0.43825,-0.402,-0.398,0.3284,-0.930833333,0.2915,1.74525,-0.1155,-0.098166667,-0.335333333,-0.068,-0.830666667,-0.038625,-1.279,-0.74325,0.104333333,-0.536333333,0.2685,-0.97275,-0.558333333,0.315083333,0.630125,-0.707833333,1.379333333],
        [-0.2975,0.2425,-0.6885,-0.98275,-0.2785,-0.1492,-1.1325,-0.93975,1.70175,-0.14,-1.2205,-0.44625,-0.6315,-1.1445,-0.188375,-0.9135,-3.0065,0.609166667,-0.458166667,0.267,-0.64525,-0.889,0.305333333,-0.310125,-0.393666667,2.214333333],
        [-2.19725,0.404,0.73225,-0.95125,-1.3405,0.2131,-1.304666667,0.183,1.08975,0.08875,-0.258166667,-0.286916667,0.149625,-0.7945,0.266125,-0.900833333,-4.3735,-0.321166667,-0.655333333,-1.1285,-1.331,-0.5158,-0.693,0.083142857,-0.90675,2.180833333],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.307333333,0.3375,1.33975,-0.40325,-0.314,0.7293,-1.8175,-0.5025,1.24925,-0.1935,-0.524166667,0.193,0.529125,-0.591666667,0.216375,-0.768833333,-3.58125,1.080333333,-0.154,0.0055,-0.33475,-0.766,0.64875,-1.21,-1.028916667,1.459166667],
        [-0.373666667,-0.465833333,-0.9875,-0.0815,-0.864,0.527,-0.958166667,1.009,1.6775,-0.286,0.150833333,-0.447666667,0.95425,-0.7945,-0.082375,-1.514833333,0.468,-0.826,0.183333333,0.5955,0.142,-1.248666667,-0.315416667,0.87675,-1.243666667,-0.348666667],
        [1.251833333,0.121,0.647,-0.3915,0.178,0.7716,-1.373,-0.26325,2.28875,0.039875,-0.054333333,0.45,0.78975,-0.282166667,0.064375,-1.316,-2.7875,1.0255,0.139166667,0.2635,-0.725,-0.568833333,-0.088666667,-0.026125,-1.114916667,1.543333333],
        [0.871416667,-0.2105,0.18325,0.04525,0.8495,1.4783,-1.083166667,0.738,3.0205,-0.01025,-0.916833333,-0.352166667,-0.071625,-0.923,-0.264375,-1.367666667,-3.422,0.274333333,-0.4955,0.321,-1.0325,-1.253,-0.9415,0.230125,-1.222833333,1.5265],
        [-0.1445,0.135333333,0.3495,-0.6235,-1.1105,0.5435,-1.364833333,-0.6205,1.4615,0.150875,0.369666667,0.669916667,-0.804,-0.6206,-0.25675,-0.7985,-2.52875,-0.222,-0.832333333,0.231,0.4815,0.268,0.533333333,0.2085,-0.962583333,2.235833333],
        [0.010083333,0.824,0.34775,-0.58475,-1.152,1.4758,-1.088333333,-0.4435,2.0525,-0.868875,-0.327833333,0.27375,-0.03,-0.582,0.790375,-0.264166667,-3.2325,0.938333333,-0.314,0.6045,-0.63175,-1.282666667,-0.7725,-0.697428571,-1.8235,1.6255],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.755916667,0.990666667,2.07125,-0.69075,-0.1655,0.7181,-0.8105,-0.69575,1.006,-0.152,0.3525,0.124666667,1.07375,-0.304,0.064125,-0.932333333,-0.8475,0.029833333,0.020333333,-0.436,-0.63475,-0.899333333,-1.00925,-0.7555,-0.911333333,1.585666667],
        [0.514166667,0.641,1.9185,-0.30825,1.3645,0.9134,-1.476,0.30825,1.16225,-0.27125,0.472333333,0.173666667,0.739625,-0.264166667,0.01825,-0.567166667,-1.30025,-0.537833333,0.020333333,0.2575,-0.884,-2.575166667,0.18725,-1.430625,-1.03775,2.968666667],
        [-0.131,0.762666667,0.299,-0.5855,-0.458,0.9052,-0.938,-0.125,2.414,-0.38025,-0.458666667,0.042583333,0.227125,-1.3595,-0.14125,-0.617666667,-2.65725,0.364666667,-0.449,-0.226,-0.504,-0.216333333,-0.035,0.926125,-0.32725,1.738333333],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [-0.7825,-0.133166667,-0.3815,-0.51,-2.8715,0.196,-1.2545,-0.7155,1.38175,0.198,-0.084666667,-0.245,-0.462625,-0.877666667,0.276875,-0.433,-3.203,0.541666667,-0.8095,-0.221,0.02825,-0.040833333,-0.575833333,0.01325,-0.926416667,2.216333333],
        [-1.100583333,-0.253333333,0.931,-0.89775,-3.0785,-0.3223,-1.488333333,-0.556,1.632,0.424125,-0.940666667,0.869333333,0.108375,-0.633,0.438875,-0.419666667,-1.9305,1.132833333,0.879666667,0.2365,-0.59725,0.219833333,0.122666667,0.440625,-0.542833333,2.183],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [-0.7135,-0.245666667,1.219,-1.023,0.4605,0.375,-1.576166667,0.3135,2.4925,-0.32575,-0.793333333,-0.702916667,-0.931875,-1.4955,-0.02125,-1.139833333,-2.81125,0.301333333,-1.018666667,0.462,0.17475,-1.081333333,0.476833333,-0.01,-0.5135,2.567833333],
        [0.054416667,0.134666667,-0.27175,-0.9695,0.3265,1.2136,-1.883666667,0.68075,1.749,-0.165875,-1.064333333,-0.283833333,-0.1565,-1.37,-0.08325,-1.294333333,-2.02575,0.879666667,-0.684166667,0.89,0.18025,-0.958666667,0.281666667,-0.165125,-0.87425,1.948166667],
        [-0.2015,0.1465,0.3725,-0.97225,-0.5925,-0.0556,-1.2,-1.784,1.18575,-0.86925,-0.887666667,-0.671416667,0.118125,-1.708833333,-0.0315,-0.593666667,-2.455,-0.476666667,-0.702166667,-0.1025,-0.16475,-0.130333333,0.345583333,-1.017875,-0.65125,3.186166667],
        [0.434416667,-0.284,0.187,-1.20825,-1.4085,-0.5315,-1.611333333,-0.5485,0.50225,-1.036625,-1.1095,-1.00225,-1.358875,-1.0455,0.11025,-0.829,-1.66975,-0.406666667,-0.744,0.195,-1.05475,-1.800833333,0.050166667,-0.962428571,0.032,2.048333333],
        [-0.73025,-1.857333333,0.39525,-0.805,-1.1375,0.0919,-1.4,-0.99225,-0.27,-0.620875,-1.187333333,-0.8065,0.076875,-1.538833333,0.013875,-1.359166667,-2.71225,-1.355166667,-0.6775,0.2875,0.13625,-2.133,2.644333333,-0.57475,-0.953583333,1.405833333],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [-0.765666667,0.646,0.20775,-0.31075,-0.0065,1.4117,-1.036666667,-0.074,1.937,-0.75,0.7325,0.041166667,-0.314125,-1.068833333,0.2645,-0.812666667,-3.23325,-0.114666667,-0.672333333,-0.5245,0.3125,-0.1905,-0.323916667,0.7115,-1.238166667,2.2015],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [1.556,0.582166667,0.41225,-0.9155,-0.98,0.329,-1.071333333,-0.63275,1.463,-0.451,-0.4665,0.089666667,0.1175,-1.207166667,-0.207875,-0.820333333,-2.1665,-1.3045,-0.180166667,0.058,-0.913,-0.5955,-0.373166667,0.0295,-0.720333333,1.609],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [-1.9915,0.715,0.991,0.31175,-1.668,1.6131,-1.173,0.66875,2.3245,0.130125,-0.2085,0.111416667,-0.312,-1.374333333,0.605125,-0.418666667,-2.37375,-0.496666667,-0.4975,-0.5025,-0.801,0.262333333,-0.498583333,0.361625,-0.86925,1.148166667],
        [-1.353416667,0.4745,-0.238,-0.15675,-1.0985,0.7703,-0.708833333,-0.4775,2.039,-0.004125,0.379666667,0.536416667,0.02375,-1.495333333,-0.204875,-0.5725,-2.189,-1.103833333,-0.501666667,0.024,-0.18975,-0.528666667,-0.372,0.9125,-0.431,0.761166667],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.775333333,-0.451,-1.018,-0.27375,-0.746,0.7781,-0.339,0.84725,1.17675,-0.099625,-0.375833333,0.146666667,-0.852625,-2.084666667,-1.124125,-0.785,-2.2425,-0.465333333,-0.253833333,-0.1305,-1.3085,-1.2025,-0.321333333,-0.266285714,-0.410083333,2.074666667],
        [-0.739083333,1.301666667,0.75475,-0.762,-1.571,0.5001,-1.359166667,-0.0375,1.36925,0.307875,-0.058833333,0.948333333,0.33825,-1.3002,1.289625,-0.326833333,-2.302,0.1635,-0.358,-0.0445,-1.13225,0.393333333,-0.046583333,-0.949714286,-0.76275,2.3035],
        [0.129666667,1.093,0.5005,-0.60875,-1.195,0.9905,-1.420833333,-0.20675,0.68825,-0.085625,-0.590833333,0.037,-0.813625,-0.513166667,0.012,-0.880666667,-1.98875,0.738166667,-0.745333333,-0.046,-1.69775,-0.097,-0.85375,-1.3015,-0.679916667,1.994333333],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.872083333,-0.072,1.45025,-0.09625,-0.221,1.1389,-1.193833333,0.60475,0.5855,-0.7375,-0.374666667,1.007333333,1.045875,-0.7105,-1.095875,-0.524833333,-2.80575,-0.694666667,0.733666667,0.0765,-0.6975,-0.058333333,-0.19325,-0.12875,-0.536416667,1.088666667],
        [1.947,0.6785,1.88875,-0.96175,-1.3485,1.0987,-1.960833333,-0.41325,1.893,0.3635,0.059666667,0.182083333,0.329875,-0.166,0.083125,-1.092833333,-2.5695,0.552666667,-0.119666667,-0.4015,0.22,0.200833333,0.265916667,-0.318125,-0.4665,2.551666667],
        [0.351583333,-0.256,0.01175,-0.622,-0.547,0.9628,-1.6625,0.2875,2.06525,-0.592125,-0.018166667,-0.657666667,1.029875,-0.7215,-0.5345,-1.372,-2.76625,0.728166667,-0.47,-0.748,-0.69325,-0.19,-0.206083333,0.276,-0.399916667,2.514333333],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.423083333,1.271333333,0.50775,-0.523,-0.658,0.9295,-1.404,-0.5865,0.99575,-0.208625,0.162833333,-0.446083333,-0.172625,-0.487166667,1.133875,-0.863,-3.22625,0.478666667,-0.593333333,-0.2615,-0.35275,-0.545166667,0.259083333,0.1345,-0.417333333,2.430833333],
        [0.20575,0.383333333,-0.49925,-0.68875,0.585,0.9048,-0.4915,0.70825,2.3625,0.109125,-0.358166667,0.16225,0.403625,-0.4495,-0.027375,-0.572666667,-2.4675,-0.408,-0.621,-0.308,-0.229,-0.910333333,-0.06725,0.896375,-0.146666667,1.291166667],
        [0.757416667,-0.134333333,0.17625,-0.2085,1.136,1.3535,-0.797666667,0.3555,2.36975,-0.2915,-0.463166667,0.540083333,0.315375,-0.825166667,0.033875,-0.501833333,-1.584,0.218333333,-0.435,-0.242,-0.1365,-0.6225,0.10575,0.743625,-0.425,1.507166667],
        [0.580166667,0.649,1.42425,-0.7385,-0.351,0.9843,-0.873333333,0.05925,1.62,-0.394375,0.689666667,1.30875,0.258625,-0.730666667,0.130875,-0.4705,-3.345,-0.0935,-0.6325,-0.919,0.3505,0.259,-0.619083333,-0.27175,-0.768583333,2.626],
        [0.017666667,-1.1565,0.0385,-0.61975,-0.2555,1.365,-1.644833333,-0.33225,1.3615,-0.10325,0.180333333,0.655833333,0.6285,-1.0145,0.093125,-1.017166667,-3.4155,-0.847833333,-0.446833333,-0.098,1.02175,0.401333333,0.6135,1.292,-0.615166667,1.5995],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [1.266416667,1.086833333,0.1215,-0.62775,0.1325,0.1997,-1.133666667,-0.80275,2.13275,0.279625,-0.110166667,0.250666667,0.719875,-0.750166667,-0.147375,-0.8755,-3.20475,0.789333333,-0.047333333,-0.4735,-0.81175,-0.378333333,-0.103333333,0.676375,-1.340833333,2.124166667],
        [0.496666667,1.305333333,1.37525,-1.4015,0.261,0.6529,-1.534166667,-0.2775,0.48975,-0.3675,-0.076666667,-1.21325,-0.52275,-0.69,-0.487875,-1.1325,-2.014,0.152,-1.189,-0.172,0.115,-0.0095,-0.379083333,-0.816375,-1.6985,2.443166667],
        [1.771916667,0.896,1.37675,-0.514,0.466,0.4959,-0.645333333,-0.08725,1.68025,-0.088875,-0.255166667,0.120916667,1.00675,-0.790666667,0.45775,-1.145666667,-3.00425,0.508666667,-0.193166667,-0.327,-0.527,-0.296666667,-0.830666667,0.034125,-1.49375,1.762666667],
        [1.564083333,0.985166667,0.19375,-0.18975,0.161,1.5921,-0.109833333,0.6505,2.56175,0.004875,0.391333333,0.59475,0.234,-0.3385,0.98275,0.4785,-3.12925,0.719666667,-0.078833333,-0.48,-0.49725,1.0535,0.158416667,-0.96525,-0.805,2.408166667],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.834,0.189,0.7005,-0.68125,-0.5885,0.6434,-1.136833333,0.36675,1.514,-0.371875,0.004,0.40775,0.282625,-1.2895,0.034875,-0.720666667,-3.061,0.282166667,0.007166667,-0.423,0.204,-0.325666667,0.224166667,0.474125,-0.416833333,2.556166667],
        [0.458583333,0.524333333,0.01125,-0.75,0.1305,1.383,-1.264166667,-0.342,2.14725,-0.092,-0.616166667,1.352333333,0.028375,-1.047833333,0.268375,-0.164333333,-2.798,1.104,0.432666667,0.1815,-0.30175,-1.184,-0.072416667,0.976,-0.761916667,2.661833333],
        [0.445416667,0.75,1.18675,-1.28775,0.4295,1.4651,-1.259166667,0.29875,1.5755,-0.671375,0.172833333,0.588083333,0.140125,-1.394166667,0.804375,-0.979833333,-2.66775,0.387166667,0.062833333,-0.1375,-1.09575,0.8665,0.072416667,0.9685,-1.048916667,0.8515],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.563333333,1.447166667,0.31175,-0.37025,-0.1635,0.9002,-0.907166667,0.11425,2.6755,0.33225,0.157,1.344583333,0.38125,-0.184166667,0.203875,-0.802833333,-2.7775,0.941166667,-0.497333333,0.3375,-0.1875,-0.788,0.2255,0.09125,-0.955666667,1.7275],
        [0.157833333,1.232333333,1.767,-0.35625,-1.0315,0.9212,-1.126,1.291,2.221,0.3575,-0.117,0.714916667,-0.24875,0.2635,0.278375,-0.979333333,-0.144,0.149166667,-0.544166667,0.4735,-0.85825,-1.0075,-0.100333333,-1.224375,-1.195833333,1.9135],
        [-0.331083333,0.6055,-0.78775,-0.59325,0.026,0.8013,-0.560833333,0.26525,1.2385,-0.44525,0.586333333,-0.112416667,0.021375,-1.096666667,-0.633125,-0.747833333,-3.11225,-1.151666667,-0.229666667,-0.128,-0.02725,-1.061166667,0.041333333,0.44175,0.245416667,2.071166667],
        [-0.073916667,1.223833333,1.27525,-0.39825,-0.99,1.1368,-0.786333333,1.08425,2.2645,-0.018,-0.590166667,-0.257083333,0.40425,-0.1915,0.082625,-0.843666667,-1.4875,0.182333333,-0.271,-0.1875,-0.635,-2.336333333,0.020333333,0.552875,-0.512416667,1.446],
        [-0.077666667,-0.406333333,-0.14925,-0.31775,0.583,0.7098,0.234166667,-0.0065,2.198,-0.389875,-0.440166667,0.425583333,0.653625,-1.4865,-0.476125,-0.457333333,-1.68425,-0.2275,-0.135,0.0145,-0.459,-1.503333333,-0.419083333,1.63075,-0.306666667,1.509],
        [0.4525,1.301666667,1.03825,-0.4975,-0.4505,0.8195,-1.4865,0.56075,1.98975,0.32675,0.193166667,0.17775,0.803,0.152,0.21725,-1.6215,-2.60325,1.066666667,-0.44,0.367,-0.21325,-2.897,1.086083333,-0.0845,-0.233333333,1.145333333],
        [0.735416667,0.487,0.4375,-0.5795,-0.2575,1.7392,-1.256666667,0.3495,2.5815,-0.761,-0.015833333,1.365416667,0.358875,-1.795,-0.2045,-1.0625,-1.567,0.226333333,0.04,0.0395,-0.1525,-0.977333333,0.045166667,1.8295,-0.45625,1.374833333],
        [0.2805,-0.093333333,0.831,-0.35,0.1915,1.1553,-1.039333333,0.871,2.6415,-0.241625,-0.754,-0.165833333,0.118625,-0.649833333,0.20975,-0.846166667,-4.05175,0.824833333,-0.531166667,0.4325,-1.0555,-2.035166667,-0.007166667,0.343375,-0.620833333,2.571833333],
        [0.1575,1.259166667,0.76875,-0.27025,-0.423,0.8773,-1.33,-0.12575,0.54,0.216875,-0.131166667,-2.419666667,-0.02075,-0.214333333,0.68,-0.9065,-2.2255,0.604666667,-1.075,-0.4755,-0.04975,1.368166667,0.024833333,-0.583,-0.827833333,3.185666667],
        [0.282833333,0.000833333,0.78175,-0.744,-0.8405,0.8836,-1.372666667,-0.112,1.66225,-0.98275,-0.0705,-0.194666667,0.0565,-0.740166667,0.512625,-0.904166667,-3.00075,0.288,-0.306,-0.4755,-0.556,-0.6455,0.0475,0.44775,-0.971416667,1.6915],
        [-0.22675,0.0845,-0.36975,-1.108,-0.7085,0.2231,-1.338333333,-0.2235,1.82025,-0.220375,-0.297166667,0.429583333,1.042,-0.505833333,-0.00825,-0.451166667,-3.77575,1.4945,-0.0485,0.293,-0.512,0.170166667,0.541333333,0.248625,0.020583333,1.845],
        [0.494,0.100833333,0.7295,-0.37625,-0.0055,0.9027,-1.163166667,0.188,2.2445,-0.03875,-0.436833333,0.137666667,0.142,-0.749833333,0.3835,-1.006166667,-3.002,0.671166667,-0.721,-0.5325,-0.7645,-1.891166667,-0.47875,0.70325,-0.386583333,1.459],
        [0.448666667,1.156,0.4415,-0.82925,-0.097,0.8458,-0.372333333,-0.27525,1.5895,-1.084625,-0.247166667,0.134916667,0.565375,-1.748166667,-0.65475,-0.794,-2.26225,-0.674333333,-0.479,0.2045,-1.7875,-0.539833333,-0.597083333,-0.2115,-0.335416667,1.481666667],
        [0.906083333,0.867833333,1.14675,-0.49325,-0.92,1.1821,-1.535166667,-0.0255,1.5445,0.734125,0.876833333,0.000666667,1.029375,-0.393833333,0.565625,-0.917166667,-2.5575,1.513166667,0.071666667,-0.1815,-0.44175,-0.221666667,0.235083333,-0.016875,-1.292416667,2.360333333],
        [-0.2275,0.446833333,1.30575,-0.05875,-1.7645,1.3607,-0.941333333,-0.34175,2.4945,-0.546125,0.683166667,0.069416667,0.092875,-1.218,0.479875,0.414166667,-2.723,-0.5845,-0.523333333,0.1825,-0.5775,-0.676166667,-0.46825,2.21225,-1.058333333,2.367166667],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0.301583333,1.425,0.35275,-0.35125,-0.0545,1.2963,-1.058333333,0.5055,2.08475,-0.305875,0.088166667,-0.10525,0.0415,-0.552166667,0.112375,-0.763833333,-2.91675,1.162833333,-0.729666667,0.1915,0.68925,0.412166667,0.559833333,-0.216,-0.883,2.227333333],
        [-0.147166667,1.170666667,0.5135,-0.57825,-0.248,1.0452,-0.719166667,0.88725,3.33175,-0.003875,0.06,1.440833333,0.0705,-0.820666667,0.540125,-0.726,-3.678,1.209,0.6075,0.361,-0.40875,0.310833333,0.36325,0.902125,-0.32675,1.871833333],
        [0.43875,0.232166667,0.155,-0.7065,-0.652,0.8416,-0.699833333,-0.16625,2.56175,-0.7395,-0.149166667,-0.141583333,0.03625,-1.548333333,-0.267625,-1.21,-3.61225,-0.192333333,-0.312333333,-0.6075,-0.2675,-0.464166667,-0.28675,0.009625,-0.666333333,2.561333333],
        [0.627,0.0645,0.1355,-0.0895,0.86,1.2371,-0.901166667,0.33525,1.651,-0.538125,0.124666667,0.669083333,0.427125,-1.465166667,0.412875,-0.439166667,-2.342,-0.725333333,-0.376,-0.26,-0.05775,-0.542,0.25175,0.8875,-0.122916667,1.038666667],
        [0.40575,0.906833333,-0.92075,-0.86575,-0.272,0.9808,-1.697666667,1.059,1.38,0.931875,0.0875,0.53725,-0.13675,-0.352833333,-0.143875,-0.8015,-2.81025,0.374333333,-1.060833333,0.1905,0.8595,0.743166667,0.779083333,0.168125,-0.0535,1.907833333],
        [-0.259166667,0.565,0.71425,-0.13025,-0.1495,1.0693,-1.198333333,0.029,0.951,0.693875,0.040833333,0.266166667,0.780875,0.497333333,-0.06025,-1.124833333,-3.94025,-0.196333333,-0.436166667,0.3085,-0.6015,-2.415666667,-0.129166667,0.504875,-0.286333333,-0.124666667],
        [0.771583333,0.072,1.48275,-1.13125,-0.4615,-0.0746,-1.4925,-1.06175,0.68875,-0.89425,-0.8325,-0.083833333,-0.096375,-1.860333333,-1.0525,-0.463166667,-3.576,-0.758333333,-0.680166667,0.459,-0.3835,-0.897,-0.365,-0.847375,-0.22175,1.766666667],
        [0.394583333,-0.163666667,0.083,-0.663,0.129,0.4123,-1.354,0.231,0.3815,-0.4095,-0.705333333,-1.10925,-0.3615,-0.4465,-1.3645,-1.380666667,-0.39475,0.253333333,-0.7575,-0.5605,-0.6885,-2.697666667,0.338166667,-0.24475,-0.533583333,1.459666667],
        [0.750166667,1.288,1.091,-0.8265,-0.8055,0.7183,-1.637666667,-0.7195,0.93475,-0.377125,0.127333333,-0.086333333,0.916875,-0.599333333,0.006375,-1.249166667,-2.89175,0.360166667,-1.354833333,-0.393,0.1195,0.540833333,-0.599583333,-0.377625,-0.437,2.198333333],
        [-0.091583333,0.652166667,0.9975,-0.20675,0.773,1.3631,-1.591666667,-0.2215,2.72125,0.236375,-0.106833333,-0.142916667,0.29875,-0.9775,-0.072625,-0.857166667,-3.6665,1.428,-0.3375,0.136,-0.03625,-1.230833333,0.629416667,0.2005,-0.248333333,2.099333333],
        [0.327333333,-0.825833333,0.97525,-0.378,-0.476,1.3313,-1.257666667,-0.889,1.37925,-0.080125,0.322166667,-0.202416667,0.0145,-0.241833333,0.25125,0.599833333,-3.0055,0.45,-0.4175,0.337,-0.221,-1.34,0.753,-0.71975,-0.190833333,2.235666667],
        [-0.809333333,1.624,-0.43275,-0.96675,0.5135,0.5491,-1.413333333,0.918,2.92925,-0.2985,0.144333333,0.708,0.415625,-0.5865,0.335375,-0.762166667,-3.1585,0.663666667,0.255166667,0.4295,-0.09175,-0.139333333,0.485333333,-0.138875,-0.319916667,1.484833333],
        [0.184666667,0.802333333,1.12825,-0.24875,0.1405,0.2823,-1.580333333,-0.971,0.93925,-0.05775,-0.524333333,-1.06975,-0.39525,-0.621333333,0.191375,-0.721166667,-2.80425,1.326,-0.548833333,0.2095,0.132,-0.694333333,0.763166667,-0.7525,-0.226166667,2.023833333],
        [0.956166667,1.039833333,1.717,-0.365,-0.1885,1.0955,-0.751833333,0.156,2.21275,-0.717125,-0.0845,-0.038666667,0.27175,-0.594833333,-0.09275,-0.650333333,-3.0325,-0.485833333,-0.559833333,-0.6835,-0.342,-1.470333333,-0.37525,0.7155,-0.543916667,1.7815],
        [-0.044916667,0.686166667,0.94675,-0.9535,-0.524,0.6203,-1.178666667,0.83,2.08675,-0.015625,-0.5955,-0.379916667,-0.3865,-1.355833333,0.139,-0.4715,-2.2925,0.947,-0.688666667,0.4725,0.32175,0.941333333,0.34475,0.224,-0.922,2.206],
        [0.13525,1.402833333,-0.34575,-0.581,0.2085,1.1971,-0.811,-0.362,1.6205,-0.210125,-0.11,0.04375,0.809625,-0.583833333,-0.32475,-0.8675,-3.1055,0.5985,-0.011666667,-0.52,-0.173,0.0355,-0.229666667,0.189125,-0.91575,1.7145],
        [-0.530916667,-0.486833333,0.18325,-0.42875,-0.149,0.6118,-1.525166667,-0.0995,1.58725,-0.336,-0.048,0.060166667,-0.186,-0.512166667,-0.4165,-0.092666667,-2.72475,1.008,-0.7735,-0.269,-0.337,-1.189833333,0.382916667,0.32075,0.395083333,2.516],
        [0.152833333,0.270666667,0.10075,-0.51625,-0.239,0.8187,-0.969666667,-0.4415,2.57975,0.0215,0.162666667,-0.117583333,0.3245,-0.804833333,0.22025,-0.8855,-4.125,1.157166667,-0.470666667,0.0395,-0.48325,0.134666667,0.11075,-0.007,-0.820666667,2.21],
        [1.235416667,0.903833333,1.40775,-0.543,-0.5095,0.6465,-0.905166667,-0.196,2.0615,0.009375,-0.3255,0.422416667,0.003125,-0.601166667,1.40875,-0.7965,-2.85025,0.427666667,-0.7685,0.0815,-0.624,-0.156,0.233916667,0.40375,-0.696166667,2.024666667],
        [0.13925,0.216166667,0.03625,-1.3955,0.2285,0.4055,-1.931833333,-0.79575,1.836,-0.737875,-0.399833333,0.2525,-0.291,-1.150666667,-0.01625,-0.856,-2.4225,1.293,0.027,0.394,-1.5025,0.291166667,0.43575,-0.489625,0.281166667,3.02],
        [-0.256666667,-0.200333333,0.73225,-0.68975,1.016,0.8905,-2.003,0.04425,1.8625,-0.121625,-0.782,0.469166667,0.014375,-1.0245,0.19525,-0.956833333,-2.943,0.888666667,-0.427333333,0.306,-0.3995,0.721833333,0.108166667,-0.182,-0.379666667,1.757],
        [0.04325,-0.149333333,0.0955,-0.847,-1.1945,0.675,-1.615666667,-0.24175,2.1805,-0.475375,-0.544833333,0.183833333,0.4875,-1.454166667,0.356125,-0.922,-2.56875,0.3595,-0.698166667,0.112,-0.49225,1.222666667,0.708333333,-0.792714286,0.0065,2.001833333],
        [0.150833333,-0.073333333,0.599,-0.71,1.1665,1.0884,-1.180666667,-0.20675,2.051,-0.89025,-0.716333333,-0.045166667,-0.325375,-0.9795,-0.457125,-0.419833333,-3.259,0.343333333,-0.378,0.5585,-0.70525,-0.377333333,-0.27625,-0.013375,-0.369166667,1.978],
        [0.037166667,1.693666667,1.643,-0.6105,0.2075,0.7946,-1.073833333,-0.702,2.0945,-0.069125,0.173666667,-0.333333333,-0.564875,-0.053333333,0.52275,-0.466166667,-3.773,1.3505,-0.373,-0.619,0.477,-0.5595,0.73325,-0.438625,-0.729083333,2.872],
        [0.684583333,-0.376666667,0.527,-0.609,-0.5925,1.0455,-1.157333333,0.2545,1.7535,0.093125,-0.602833333,0.693416667,-0.072875,-0.901333333,-0.9115,-1.017166667,2.20625,-0.135,-0.595166667,0.4305,-0.53525,-1.844,0.062333333,1.378125,-0.112833333,2.533666667],
        [-0.087833333,1.341833333,0.13625,-1.025,-0.7325,0.3117,-0.8645,0.97675,2.46075,-0.10175,-0.5245,0.649333333,0.00175,-1.645333333,-0.14975,-0.959833333,-2.2255,0.017666667,-0.2535,-0.077,-0.45925,-0.5125,-0.455583333,0.489875,-0.635083333,1.532666667],
        [1.342,1.265,0.916,-0.405,0.4335,1.1441,-0.426333333,-0.1455,1.1375,0.038,0.012833333,0.268166667,1.61,0.0785,-0.064125,-0.993166667,-0.6115,0.444833333,-0.695333333,-0.2975,-0.20775,-0.226833333,0.0035,0.007,-0.306,2.357833333],
        [-0.206666667,0.058333333,0.785,-0.3665,-0.375,1.1693,-1.243833333,0.2555,2.63375,-0.01225,-0.535333333,0.217166667,0.193625,-1.023,0.328625,-0.361833333,-3.65025,0.774333333,-0.639333333,-0.129,-0.2605,0.615,0.283416667,0.75975,-0.503083333,1.8525],
        [0.28725,-0.131833333,0.269,-0.04125,0.1165,1.4327,-0.910333333,0.618,2.487,-0.3355,-0.697166667,-0.336166667,0.223125,-1.199,-0.64475,-0.9315,-2.587,0.367,-0.595833333,-0.233,-0.396,-1.390833333,0.347583333,0.492125,-1.354916667,2.033833333],
        [0.054083333,-0.011166667,0.0995,-0.12175,0.207,0.7769,-1.179333333,-0.738,1.66925,0.1065,-0.044,-0.487666667,0.355875,-0.6115,0.067125,-0.840333333,-3.5055,0.235166667,-0.725666667,-0.9945,0.67875,-0.669666667,-0.024583333,0.3555,-0.737333333,0.907333333],
        [0.151333333,0.7265,1.2595,-0.7185,-0.719,1.4697,-1.399,0.45725,2.33925,-0.035375,-0.041,0.33825,1.298625,-0.301666667,0.9285,-1.264666667,-2.553,1.294,0.153666667,-0.636,0.1715,0.506666667,-0.372333333,1.404125,-0.481916667,1.768666667],
        [0.363833333,0.844666667,1.81725,-0.49175,-0.6125,0.8442,-1.282333333,1.90575,1.64175,-0.560125,-1.260833333,-0.25125,2.0065,-0.846,-0.950625,-0.999666667,0.594,0.799166667,0.108333333,0.3945,-0.43825,-1.995666667,0.36225,-1.188875,-1.308083333,1.510833333],
        [1.400916667,0.402,0.60775,-0.12425,-0.533,-0.0111,-1.0295,-0.63375,2.22425,-0.8235,0.449,0.198166667,0.293375,-1.733333333,-0.187125,-1.090166667,-2.46525,-1.060666667,-0.3575,-0.083,-1.20975,-0.456333333,-1.049666667,-0.487875,-0.24825,1.731666667],
        [-0.0835,0.657666667,1.089,-1.08975,0.748,0.5883,-1.198166667,-0.7565,0.842,-0.3705,-0.485333333,-0.587916667,-0.286,-0.907333333,-0.683875,-0.789,-2.34375,-0.301666667,-0.785833333,-0.583,0.624,-0.038,-0.102416667,0.1355,-0.709666667,2.894166667],
        [0.498833333,-0.343166667,1.00425,-0.5545,-0.488,0.3349,-1.444833333,-0.05525,1.3625,-0.248,-0.417166667,-0.120916667,0.5335,-1.017333333,0.233875,-1.4355,-2.13175,-0.542166667,-0.324166667,0.244,-0.8945,-0.6075,-0.161083333,0.477875,-0.404333333,1.613833333],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    ];
	
	var yData2 = [
        [-0.424,-0.2,-0.453,-0.467,0.043,-0.068,0.464,0.493,0.511,-0.384,-0.036,-0.485,-0.485,-0.384,-0.03,0.038,0,-0.384,-0.485,-0.231,-0.003,-0.014,0.462,0.043,-0.452,0.09],
        [-0.293,0.165,0.184,-0.303,-0.002,0.174,0.188,-0.082,-0.082,-0.083,1.784,-0.373,-0.373,-0.083,-0.157,0,0.189,-0.083,-0.373,0.135,-0.002,-0.157,-0.082,-0.002,-0.303,-0.085],
        [0.015,-0.771,-0.109,-0.758,-0.753,0.039,0.023,-0.138,-0.138,-0.493,-0.014,0.023,0.023,-0.493,0.929,0.024,0.038,-0.493,0.023,-0.054,-0.753,0.929,-0.138,0.034,-0.758,0.5],
        [-0.012,-0.178,0.11,-0.311,-0.258,0.135,-0.014,0.045,0.045,0.017,-0.219,-0.014,-0.014,0.017,0.402,-0.041,0.06,-0.015,-0.014,-0.062,-0.258,0.463,0.249,-0.258,-0.306,-0.047],
        [0.47,-0.57,-0.016,-0.522,-0.524,0.006,0.304,1.471,-0.004,0.534,0.844,-0.556,-0.584,0.534,-0.056,-0.551,0.006,0.534,0.516,-0.032,-0.527,-0.056,-0.004,0.515,-0.522,-0.004],
        [0,-0.075,0.408,-0.369,-0.063,0.258,0.257,-0.35,-0.35,-0.07,-0.473,2.002,-0.462,-0.07,0.791,-0.08,0.226,-0.07,2.087,-0.393,-0.738,0.122,0.622,0.583,-0.369,0.833],
        [0.969,-0.229,0.776,-0.499,0.974,0.496,0.926,0.444,-0.175,-0.249,-0.619,-0.259,-0.29,-0.249,0.336,0.476,-0.512,-0.249,-0.259,-0.275,-0.157,0.329,-0.131,0.974,-0.499,0],
        [0.006,-0.789,0.185,-0.031,-0.794,-0.07,0.076,-0.035,-0.034,0.195,-0.039,-0.773,-0.826,0.195,0.719,-0.043,-0.246,0.195,-0.773,-0.007,-0.7,0.738,-0.034,2.837,-0.792,0.775],
        [0.031,0.022,0.067,-0.363,-0.345,-0.012,0.762,-0.373,-0.339,0.017,-0.065,-0.369,-0.369,0.017,0.095,0.378,0.045,0.394,-0.369,0.043,-0.369,0.089,0.063,0.334,-0.35,1.079],
        [0.025,-0.38,0.108,-0.374,-0.407,-0.002,0.734,0.377,0.377,-0.379,-0.011,-0.382,-0.382,-0.379,0.063,0.376,-0.378,-0.379,-0.382,0.381,-0.403,0.104,-0.422,-0.038,-0.39,0.387],
        [1.456,-0.213,0.493,-0.228,-0.248,-0.191,0.19,0,0,0.134,-0.23,0.19,0.19,0.134,-0.127,0.205,-0.215,0.121,0.19,0.425,-0.246,-0.127,-0.004,1.265,-0.238,0.42],
        [0.003,-0.647,0.535,-0.001,0.009,-0.028,0.551,-0.582,-0.582,0.028,-0.035,-0.596,-0.596,0.028,0,-0.087,0.022,0.028,-0.596,0.009,-0.017,0.028,-0.042,0.001,-0.012,0.002],
        [0.191,-0.461,-0.045,-0.014,0.057,0.117,0.261,-0.053,-0.463,0.333,0.14,-0.426,-0.426,0.333,0.366,-0.047,-0.03,0.31,-0.426,-0.42,-0.439,0.263,-0.059,0.864,-0.41,0.006],
        [0.162,-0.039,0.871,-0.404,-0.387,0.04,0.054,-0.409,-0.357,0.388,0.055,-0.015,-0.015,0.388,-0.42,0.005,1.249,0.388,-0.015,-0.385,-0.933,-0.42,-0.376,1.339,-0.382,0.072],
        [0.116,-0.044,0.032,-0.553,-0.593,0.01,0.007,-0.009,-0.023,0.034,-0.067,-0.601,-0.024,0.034,0,-0.011,0.032,0.034,-0.601,-0.069,-0.593,0.009,0.014,0.028,-0.553,0.026],
        [0.127,0.016,-0.204,-0.348,-0.335,0.003,0.024,-0.005,0,0.003,-0.012,-0.359,-0.368,0.003,0.111,0.014,-0.01,0.023,-0.359,-0.339,-0.366,-0.043,-0.295,0.041,-0.349,0.369],
        [0.074,-0.777,0.003,-0.767,-0.772,0.014,0.004,-0.787,-0.787,-0.26,-0.357,0.004,0.004,-0.26,0.012,-0.778,0.007,-0.26,0.004,0.041,-0.805,0.012,0.085,1.481,-0.767,1.199],
        [0.007,0.015,-0.871,-0.011,-0.016,-0.024,0.041,-0.004,-0.004,0.045,0.033,0.041,0.041,0.045,0.523,0.13,0.014,0.045,0.041,0.016,-0.021,0.054,-0.004,-0.016,-0.005,0],
        [0.172,-0.313,-0.338,-0.321,-0.334,-0.061,-0.298,-0.045,-0.045,-0.257,-0.295,-0.298,-0.298,-0.257,0.281,-0.31,-0.297,-0.257,-0.298,0.162,-0.33,-0.309,-0.105,0.126,-0.315,0.2],
        [0.105,-0.252,0.006,-0.282,0.196,0.084,0.407,-0.007,-0.007,-0.109,-0.209,-0.367,-0.367,-0.109,-0.278,0.116,-0.264,-0.109,-0.367,-0.167,0.176,-0.278,0.016,0.196,-0.106,0.312],
        [-0.023,-0.156,0.323,-0.056,-0.021,0.041,-0.081,0.107,0.107,0.022,0.076,-0.081,-0.081,0.022,0.17,-0.161,-0.047,0.022,-0.081,-0.164,-0.16,0.17,-0.169,-0.021,-0.056,0.014],
        [0.205,-0.12,0.257,-0.121,0.574,-0.028,0.414,-0.051,-0.051,0.307,-0.102,-0.141,-0.141,0.307,0.715,-0.091,0.05,0.307,-0.141,-0.104,0.029,0.715,0.301,0.574,-0.121,0.395],
        [-0.004,-0.005,0.026,0.001,0.023,0.01,-0.018,-0.015,-0.004,-0.012,-0.028,-0.018,-0.018,-0.012,-0.025,0,-0.002,-0.012,-0.018,-0.013,0.023,-0.025,-0.004,0.023,0.001,-0.01],
        [0.054,-0.072,0.292,-0.09,-0.071,0.337,0.307,-0.056,-0.056,-0.07,-0.112,-0.097,-0.097,-0.07,1.348,0.7,0,-0.07,-0.097,-0.089,-0.071,0.443,0.298,1.027,-0.09,0.624],
        [0.501,-0.506,0.011,-0.506,-0.494,-0.491,-0.002,0.024,0.056,0,-0.084,-0.511,-0.511,0,-0.021,-0.008,-0.481,0,-0.511,-0.019,-0.025,-0.084,0.028,1.649,-0.506,-0.003],
        [-0.043,0.063,-0.003,0.056,-0.164,0.002,-0.004,-0.001,-0.002,0.004,0.086,0.004,0.004,0.004,0.173,-0.005,0.171,0.004,0.004,-0.007,-0.173,0.116,-0.002,0.771,0.056,0.336],
        [2.429,-0.327,-0.181,-0.289,-0.289,-0.279,0.374,-0.259,-0.21,0.624,-0.334,3.657,-0.325,0.624,0.122,-0.322,-0.298,-0.271,-0.325,0.574,-0.289,0.122,0.197,1.35,-0.289,0.201],
        [0.249,-0.226,0.254,-0.381,-0.318,-0.313,0.154,-0.269,-0.269,0.64,-0.294,-0.277,-0.277,0.64,-0.282,0.122,-0.211,-0.18,-0.277,0.35,0.087,-0.276,0.666,1.136,-0.381,-0.168],
        [-0.087,0.053,0,-0.55,-0.569,0.09,0.086,0.061,0.061,-0.219,0.072,-0.585,-0.585,-0.219,0.093,0.018,-0.046,-0.219,-0.585,-0.28,-0.59,0.093,0.061,0.645,-0.55,0.041],
        [0,-0.04,0.076,-0.279,-0.291,0.044,0.069,-0.099,-0.062,-0.075,-0.174,1.269,-0.288,-0.075,0.157,-0.141,0.072,-0.075,-0.288,-0.053,-0.156,0.157,0.114,0.527,-0.279,0.049],
        [0.049,0.052,-0.151,0.024,-0.157,0.074,-0.179,-0.034,-0.034,-0.026,0.115,-0.179,-0.179,-0.026,0.175,0.115,-0.08,-0.026,-0.179,-0.168,-0.178,0.175,-0.034,0.549,0.024,0.139],
        [0.728,0.153,0.397,-0.339,-0.338,0.034,0.299,0.266,0.813,-0.312,0.277,-0.314,-0.314,-0.128,0.232,-0.314,0.517,-0.312,-0.314,-0.118,-0.351,-0.031,-0.33,1.563,-0.339,0.443],
        [-0.419,-0.081,-0.143,-0.235,-0.192,0.064,-0.14,0.042,0.042,-0.119,0.021,-0.14,-0.14,-0.166,-0.155,-0.056,-0.242,-0.119,-0.14,-0.379,-0.166,-0.177,0.098,1.191,-0.235,0.388],
        [0.515,0.286,0.345,-0.52,-0.5,-0.086,0.837,-0.015,-0.015,-0.489,-0.54,-0.514,-0.469,-0.489,0.848,-0.031,-0.008,-0.495,-0.514,3.657,-0.552,0.911,0.467,2.965,-0.506,0.229],
        [0.147,-0.307,0.291,0.001,-0.266,0,0.14,-0.02,-0.02,0.127,0.098,0.124,0.66,0.127,0.306,0.299,-0.274,0.127,0.124,-0.34,-0.329,0.306,-0.158,1.896,0.001,-0.256],
        [0.965,-0.184,-0.183,-0.167,-0.165,0.636,0.825,-0.151,-0.15,-0.184,0.306,-0.199,-0.199,-0.184,0.378,0.377,0.422,-0.181,-0.199,-0.177,0.29,0.378,-0.201,1.11,-0.175,0.449],
        [1.071,-0.063,0.771,-0.341,-0.331,0.027,0.444,-0.333,-0.333,-0.338,-0.022,-0.371,-0.371,-0.338,0.03,-0.235,-0.338,-0.338,-0.371,-0.319,-0.36,0.031,-0.333,0.61,-0.341,0.887],
        [0.127,-0.288,0.042,-0.622,-0.482,0.07,0.153,-0.583,-0.583,0.043,-0.598,0.153,0.153,0.043,-0.679,0.06,-0.106,0,0.153,0.009,-0.481,0.196,0.73,0.278,-0.622,0.976],
        [0.358,0.039,0.288,-0.413,-0.314,-0.296,0.31,-0.031,-0.01,0.185,0.23,-0.391,-0.391,0.185,0.185,-0.171,1.159,0.185,-0.391,0.027,-0.436,0.201,0.339,0.65,-0.421,-0.026],
        [0.033,-0.525,0.016,-0.589,-0.632,0.002,0.5,-0.599,-0.572,-0.022,-0.709,-0.66,-0.66,-0.022,-0.085,-0.059,0.017,-0.006,-0.66,0.025,-0.603,-0.127,0.543,0.094,-0.619,0.488],
        [0.066,-0.002,0.04,-0.543,-0.589,0.685,0.605,0.002,0.002,-0.001,-0.031,-0.498,-0.498,-0.001,0.946,-0.024,-0.441,-0.001,-0.498,-0.392,-0.587,-0.224,-0.032,0.836,-0.539,0.016],
        [2.25,-0.299,0.39,-0.248,-0.265,-0.219,0.362,-0.232,-0.232,-0.223,0.041,0.004,0.004,-0.223,0.044,0.005,-0.308,-0.218,0.004,0.06,-0.265,0.069,0,0.235,-0.248,0.87],
        [0.005,0.053,0.177,-0.581,-0.488,-0.011,-0.373,0.029,0.029,0.131,-0.035,-0.373,-0.373,0.131,0.095,0.027,-0.064,0.131,-0.373,-0.065,-0.511,0.095,0.029,0.188,-0.581,0.025],
        [1.568,-0.316,0.548,-0.34,-0.334,0.054,0.225,0.028,0.072,0.044,0.056,0.225,-0.364,0.044,0.123,-0.291,-0.331,0.044,-0.364,-0.822,-0.367,0.072,-0.347,0.955,-0.34,0.143],
        [0,-0.07,0.029,0.066,-0.437,0.081,0.106,-0.05,-0.05,0.186,-0.323,0.106,0.106,0.186,0.074,-0.092,0.006,0.186,0.106,-0.148,-0.421,0.074,0.065,0.511,-0.41,0.674],
        [3.657,-0.585,0.511,-0.547,-0.595,-0.626,0.211,0.081,0.13,0.086,0.257,-0.62,-0.62,0.086,0.912,-0.009,0.056,0.086,-0.62,0.203,-0.616,0.912,-0.616,1.874,-0.539,-0.162],
        [-0.201,-0.219,0.306,-0.493,-0.489,0.023,0.497,-0.362,-0.362,0.024,-0.471,0.472,-0.246,0.024,0.386,-0.23,0.135,0.024,0.472,-0.226,-0.499,0.321,-0.367,1.319,-0.493,0.054],
        [0.127,0.023,0.152,-0.234,0.074,0.606,0.054,-0.023,-0.04,-0.48,0.059,-0.48,-0.48,-0.48,-0.47,-0.496,0.179,-0.48,-0.48,-0.02,0.066,0.226,-0.016,0.074,-0.544,1.085],
        [0.164,-0.108,-0.263,-0.697,-0.54,0.064,-0.076,0.449,0.449,0.142,-0.096,-0.087,-0.087,0.142,0.191,-0.479,0.054,0.142,-0.087,-0.104,-0.549,0.191,0.449,1.309,-0.699,0.093],
        [-0.003,-0.013,0.04,-0.669,-0.649,0.026,-0.089,0.076,0.076,-0.019,0.374,-0.089,-0.089,-0.019,-0.098,-0.028,0.059,-0.019,-0.089,0,-0.73,-0.098,0.003,0.618,-0.673,0.511],
        [0.388,0.001,0.006,0.003,-0.005,0.216,-0.006,-0.445,-0.004,0.005,-0.034,-0.437,-0.437,0.005,-0.416,0.017,0.107,0.005,-0.437,0.008,-0.038,0.005,0,-0.005,-0.429,0.558],
        [0.15,0.082,0.017,-0.566,-0.589,0.112,0.115,0.01,0.01,0.09,-0.032,-0.687,-0.687,0.09,0.339,0.016,0.404,0.105,-0.687,-0.131,-0.534,0.364,-0.517,-0.036,-0.566,-0.014],
        [0.02,0.001,0.574,-0.566,-0.561,-0.035,0.029,-0.566,-0.566,-0.047,-0.511,-1.129,-0.553,-0.047,0.573,-0.001,-0.569,-0.047,-0.553,-0.017,-0.022,-0.551,-0.53,1.594,-0.566,0.011],
        [0.212,-0.656,0.039,-0.311,-0.29,0.234,0.463,0.016,0.016,-0.06,-0.604,0.209,0.117,-0.06,0.352,0.191,0.335,-0.06,0.229,-0.021,-0.333,-0.669,-0.079,0.84,-0.295,-0.019],
        [-0.097,-0.111,-0.766,0.176,-0.46,0,0.099,0.194,0.222,-0.272,0.239,0.077,0.09,-0.276,0.057,-0.544,-0.109,-0.257,0.077,2.183,0.103,0.055,0.222,2.818,-0.718,0.751],
        [0.342,-0.469,0.431,-0.424,-0.411,0.785,-0.315,0.002,0.002,0.353,0.292,0.19,0.253,0.353,-0.042,0,-0.417,0.353,0.253,0.009,-0.434,0.772,0.009,0.429,-0.448,0.408],
        [0.002,-0.504,-0.008,-0.036,-0.516,0.004,0.018,0.477,0.462,0.025,-0.421,-0.496,-0.492,0.025,0.052,-0.523,-0.502,0.013,-0.492,0.002,-0.525,0.08,-0.522,0.508,-0.509,0.012],
        [2.34,-0.058,-0.041,0.01,-0.031,0.352,0.008,-0.048,-0.048,0.38,-0.089,-0.038,-0.038,0.38,-0.073,-0.075,-0.488,0.38,-0.038,0.386,-0.06,-0.122,0.608,0.857,-0.031,0.685],
        [0.481,-0.229,0.051,-0.188,-0.204,0.097,0.404,-0.223,-0.223,-0.212,-0.283,-0.243,-0.243,-0.212,0.643,0,0.17,0.46,-0.243,0.465,-0.031,-0.653,-0.121,0.265,-0.188,0.116],
        [-0.166,0.174,0.023,-0.494,0.101,0.127,-0.192,-0.149,-0.149,0.161,0.087,-0.21,-0.21,0.161,-0.464,0.138,-0.393,0.161,-0.21,-0.167,0.071,-0.464,-0.172,0.101,-0.51,0.724],
        [0.286,-0.043,0.783,-0.298,-0.294,0.023,0.266,-0.005,0.002,0.035,-0.367,-0.312,-0.312,0.035,0.305,0.275,0.328,-0.269,-0.312,-0.294,-0.346,0.305,-0.008,0.515,-0.298,0.799],
        [0.309,-0.328,0.014,0.016,0.001,-0.005,0.018,-0.291,-0.019,0.017,-0.318,0.015,0.033,0.024,-0.318,-0.325,-0.306,0.017,0.033,0.333,-0.32,-0.315,0.002,0.301,-0.691,0.018],
        [0.663,-0.019,3.657,-0.238,-0.217,-0.037,0.612,-0.221,-0.216,0.623,0.506,0.612,0.612,0.623,0.624,-0.248,0.667,-0.213,0.612,-0.236,-0.217,0.133,-0.262,0.705,-0.27,0.715],
        [0.048,-0.561,0.427,-0.6,-0.538,0.179,-0.581,0.004,0.004,0.593,0.308,-0.595,-0.595,0.593,0.605,0.044,0.093,-0.58,-0.595,0.039,-0.429,0.16,-0.018,0.454,-0.606,0.643],
        [0.008,0.006,0.08,-0.241,-0.233,-0.003,0.009,-0.146,-0.1,0.036,-0.261,-0.289,-0.289,0.036,0.145,0.027,-0.105,0.036,-0.289,-0.021,-0.259,0.145,-0.066,0.56,-0.241,0.205],
        [0.625,-0.384,0.497,-0.412,-0.423,-0.006,0.346,-0.416,-0.416,0.398,0.336,0.346,-0.523,0.398,0.302,-0.055,-0.438,0.398,0.346,0,-0.423,0.316,0.004,-0.423,-0.444,0.429],
        [0.016,-0.285,0.001,-0.295,-0.004,0.001,-0.067,-0.071,-0.071,0.012,0.005,-0.067,-0.067,0.012,0.012,0.001,0.004,0.012,-0.067,0,-0.004,0.012,-0.071,-0.004,-0.295,0.006],
        [0,-0.007,0.063,0.002,-0.006,0.01,-0.042,-0.041,-0.041,0.021,-0.065,-0.042,-0.042,0.021,0.099,0.023,-0.094,0.021,-0.042,-0.03,-0.119,0.099,-0.041,-0.006,0.002,0.02],
        [-0.084,-0.116,0.412,-0.22,-0.177,0.207,0.181,-0.027,-0.027,0.017,-0.156,0.001,0.001,0.017,0.282,-0.103,-0.342,0.017,0.001,-0.157,-0.134,0.287,-0.027,0.389,-0.218,0.088],
        [0.183,0.496,0,-0.336,-0.346,0.024,-0.058,-0.06,-0.04,-0.087,0.193,-0.074,-0.074,-0.087,0.173,-0.152,0.273,-0.087,-0.074,-0.076,-0.346,0.173,-0.04,0.457,-0.336,0.478],
        [0.465,-0.05,0.461,-0.062,-0.037,0.407,0.85,-0.027,-0.027,0.866,0.661,-0.157,-0.157,0.866,0.847,0.375,-0.061,0.864,-0.157,-0.07,-0.143,0.829,-0.053,1.884,-0.062,0.435],
        [0.377,-0.179,0.134,-0.202,-0.279,-0.176,-0.195,0,0,0.414,-0.12,0.56,0.232,0.414,0.208,0.193,-0.196,0.78,1.663,0.18,-0.192,0.208,-0.004,0.572,-0.202,0.011],
        [0.016,0.007,0.07,-0.722,-0.717,0.001,-0.044,0.016,0.034,0,-0.07,-0.044,-0.036,0,0.074,1.544,0.028,0,-0.044,-0.709,-0.734,0.074,0.003,0.022,-0.722,0.017],
        [0.139,-0.346,0.617,-0.334,-0.009,-0.036,0.618,-0.343,-0.343,-0.008,-0.335,-0.019,-0.055,-0.008,0.622,-0.347,-0.029,-0.008,-0.019,0.301,-0.034,-0.355,0.622,1.209,-0.334,0.446],
        [0.016,-0.671,0.029,-0.669,-0.671,0.014,-0.052,-0.686,0.045,0.281,-0.11,-0.073,-0.073,0.281,-0.045,-0.035,0.033,0.281,-0.073,-0.673,-0.671,-0.045,0.045,0.69,-0.67,0.003],
        [-0.099,-0.393,0.368,-0.391,0,0.005,0.432,0.742,0.767,-0.102,-0.011,-0.381,-0.381,-0.102,0.023,0.03,-0.083,-0.102,-0.381,-0.008,-0.029,0.034,0.009,0.507,-0.39,0.422],
        [0.007,-0.604,-0.625,-0.598,-0.361,-0.005,0.008,0.005,0.005,0.005,-0.538,-0.622,-0.622,0.005,0.027,0.024,-0.604,0.005,-0.622,0.582,0.038,0.027,-0.014,-0.01,-0.626,0],
        [0.055,-0.399,0.635,-0.435,-0.45,-0.078,0.526,-0.374,-0.374,-0.454,-0.539,-0.11,-0.11,-0.454,0.266,0.317,-0.232,-0.454,-0.11,0.016,-0.459,0.266,0.415,0.447,-0.448,1.018],
        [1.251,-0.569,0.655,-0.6,-0.57,0.042,0.906,2.26,0.632,0.043,-0.634,-0.611,-0.611,0.043,3.44,0.661,0.058,0.043,-0.611,-0.563,-0.563,0.032,0.03,0.637,-0.58,1.196],
        [-0.61,-0.631,0.162,-0.632,-0.663,-0.361,0.289,0.225,0.225,-0.626,-0.627,-0.631,-0.651,-0.626,0.109,0.142,0.262,-0.626,-0.631,0.251,0.089,-0.662,0.153,1.027,-0.632,0.309],
        [0.004,-0.013,-0.463,0.452,-0.152,-0.069,0.874,0.131,0.131,-0.514,-0.575,-0.563,-0.563,-0.514,-0.511,0.48,0.063,0.549,-0.563,-0.553,-0.818,0.351,-0.551,0.424,-0.493,0.774],
        [0.062,-0.062,0.027,-0.292,-0.321,0.678,0.593,-0.279,-0.279,-0.298,0.305,-0.318,-0.318,-0.298,0.783,-0.15,-0.308,-0.298,-0.318,0.065,0.03,-0.288,-0.315,0.396,-0.292,0.39],
        [0.353,-0.109,0.712,-0.23,-0.043,0.231,0.704,0.17,0.132,0.099,-0.187,-0.097,-0.097,0.099,0.205,0,0.16,0.099,-0.097,-0.156,-0.014,0.866,0.132,-0.043,-0.23,-0.015],
        [0.573,0.035,0.081,-0.28,-0.282,0.081,0.073,-0.235,-0.235,-0.172,-0.331,0.073,0.073,-0.172,0.188,0,0.379,-0.172,0.073,-0.17,-0.282,0.146,0.136,0.453,-0.28,0.183],
        [-0.016,-0.116,0.005,-0.153,0.006,-0.045,0,0,0,-0.032,0.075,0,0,-0.032,0.06,-0.011,0.06,-0.032,0,-0.099,0.006,0.077,0.106,0.507,-0.153,0.139],
        [0.004,-0.004,-0.329,-0.308,-0.154,0.066,-0.008,0.072,0.072,-0.059,0.026,-0.008,-0.299,-0.059,0.032,0.004,-0.04,-0.059,-0.008,-0.002,-0.154,0.032,0.072,1.606,-0.308,0.17],
        [0.076,-0.564,0.621,-0.532,-0.564,0.188,0.147,-0.394,-0.394,0.042,-0.016,1.24,-0.438,0.042,0.093,-0.228,-0.562,0.042,1.24,-0.581,-0.564,0.084,-0.386,0.035,-0.532,0.021],
        [0.066,0,-0.079,-0.195,0.023,-0.062,0.058,-0.303,0.058,-0.156,0.073,-0.095,-0.095,-0.156,-0.021,-0.134,-0.196,-0.156,-0.095,0.081,-0.074,-0.021,-0.036,0.023,-0.195,-0.047],
        [-0.094,0.101,0.191,0.487,-0.358,0.065,-0.166,-0.024,-0.024,-0.344,-0.343,-0.166,-0.166,-0.344,0.102,0.054,0.103,-0.344,-0.166,-0.122,-0.375,0.305,-0.353,0.692,-0.372,-0.224],
        [0.012,0.013,0.01,-0.25,-0.244,0,0.007,-0.006,-0.006,-0.166,-0.007,0.007,-0.257,-0.166,0.001,0.028,-0.029,-0.166,0.007,-0.223,-0.256,0.001,-0.006,0.487,-0.25,0.013],
        [0.026,-0.289,0.303,-0.303,-0.298,-0.09,-0.049,-0.067,-0.067,-0.29,0.262,-0.049,-0.049,-0.29,0.087,0.02,0.479,-0.29,-0.049,-0.294,-0.306,0.087,-0.032,1.332,-0.303,0.022],
        [0.302,-0.305,0.306,-0.323,-0.02,0.277,0.565,-0.018,-0.018,-0.002,-0.314,-0.316,-0.316,-0.002,-0.292,0.03,0,-0.006,-0.316,-0.014,-0.005,-0.349,0.297,1.268,-0.323,0.295],
        [0.723,0.123,0.109,-0.404,-0.386,0.22,-0.018,0.037,0.037,-0.068,-0.141,0.025,0.025,-0.068,1.76,0.188,-0.19,-0.068,0.025,-0.405,-0.469,0.127,-0.02,0.321,-0.404,0.24],
        [0.957,-0.104,0.23,-0.169,-0.192,0.738,0.404,-0.138,-0.263,0.598,-0.13,-0.051,-0.529,0.598,0.748,-0.097,0.221,0.598,-0.051,0.728,-0.497,0.849,-0.223,0.387,-0.169,0.905],
        [-0.042,-0.043,0.083,-0.068,-0.164,0.056,-0.052,-0.165,-0.165,-0.048,-0.027,-0.052,-0.052,-0.048,0.304,0.067,-0.009,-0.048,-0.052,-0.136,-0.164,0.304,-0.165,0.343,-0.068,0.03],
        [0.043,-0.404,0.428,0.048,-0.408,-0.02,0.164,1.003,1.002,-0.389,-0.4,0.891,0.201,-0.389,-0.383,0.251,-0.386,-0.389,0.891,-0.406,-0.417,-0.395,0.207,-0.408,-0.408,-0.189],
        [2.77,-0.007,0.686,-0.42,-0.453,0.241,0.43,0,0,0.444,0.384,1.209,-0.463,0.444,0.059,-0.393,-0.133,0.326,1.209,-0.444,-0.437,0.932,0.172,2.086,-0.42,0.846],
        [0.139,-0.19,0.3,-0.392,-0.388,0.159,1.221,0.384,0.384,-0.005,0.379,-0.034,-0.034,-0.005,0.655,-0.043,0.373,-0.005,-0.034,-0.795,-0.426,0.655,-0.013,1.399,-0.392,0.661],
        [-0.126,-0.617,-0.184,0.028,-0.268,0.276,0.229,-0.563,0,-0.275,-0.6,0.237,-0.296,-0.275,0.737,0.255,-0.256,-0.27,-0.296,0.062,-0.268,-0.305,0,0.242,0.013,-0.086],
        [-0.256,-0.552,-0.011,-0.53,0.395,-0.209,-0.021,-0.497,-0.497,-0.076,-0.528,-0.542,-0.542,-0.076,0.854,0.264,1.209,-0.076,-0.542,-0.088,0.339,-0.153,-0.313,0.395,-0.53,1.444],
        [0.047,0.082,0.128,-0.096,-0.143,-0.012,-0.047,-0.023,-0.023,0.048,0.066,-0.047,-0.047,0.048,0.109,0.096,-0.084,0.048,-0.047,-0.001,-0.142,0.103,0.01,0.534,-0.096,0],
        [0.748,0.074,-0.102,-0.603,-0.561,0.001,0.322,-0.536,0.18,0.13,-0.544,-0.032,0.069,-0.505,0.579,0.002,0.091,0.13,0.708,-0.578,-0.485,1.365,0.125,0.062,-0.598,0.048],
        [0.184,0.243,-0.235,0.235,0,0.006,0.003,0.004,0.004,-0.069,-0.051,-0.017,-0.01,-0.069,-0.202,-0.091,-0.008,-0.069,-0.017,-0.014,0,-0.202,-0.003,0,0.244,0.007],
        [0.005,0.031,-0.491,-0.005,-0.516,0.491,0.033,-0.234,-0.234,-0.001,-0.029,-0.549,-0.549,-0.001,1.895,-0.25,0.001,-0.001,-0.549,-0.169,-0.547,0.015,0.076,1.657,-0.494,0.038],
        [-0.02,0.109,0,-0.167,-0.169,-0.024,-0.095,0.063,0.072,0.955,-0.013,-0.095,-0.095,0.955,0.124,0.002,-0.041,-0.022,-0.095,0.015,-0.169,0.122,0.062,0.221,-0.167,0.011],
        [0.241,-0.022,0.069,-0.167,-0.132,0.044,-0.087,0.069,0.069,0,0.027,-0.087,-0.087,0,0.107,0.042,-0.026,0,-0.087,-0.002,-0.092,0.054,0.069,0.599,-0.167,0.029],
        [0.259,-0.491,0.341,-0.535,-0.503,0.266,0.281,0.189,0.189,-0.23,0.172,0.281,-0.501,-0.23,0.109,-0.041,-0.222,-0.23,-0.501,0.14,-0.525,0.109,-0.391,0.894,-0.535,0.544],
        [0.547,-0.409,0.295,-0.077,-0.389,0.105,-0.446,0.383,0.251,-0.029,-0.043,0.269,0.049,-0.029,0.609,-0.007,1.797,-0.425,0.049,0.361,0.27,-0.11,-0.034,0.971,-0.075,0.293],
        [0.358,-0.212,0.191,0.334,-0.168,-0.237,0.955,-0.172,-0.172,-0.223,-0.192,-0.136,-0.136,0.262,0.39,0.129,-0.217,0.581,-0.136,-0.191,-0.224,0.964,0.494,1.19,-0.163,0.514],
        [0.537,0.484,-0.399,-0.397,-0.875,0.065,0.499,0.548,0.548,-0.389,-0.39,-0.392,-0.392,-0.389,0.062,0.071,0.136,-0.364,-0.392,0.056,-0.875,0.062,0.546,1.756,-0.397,-0.381],
        [0.184,0.071,0.123,-0.416,-0.53,0.057,0.014,0.041,0.048,0.214,-0.273,0.014,0.014,0.214,-0.072,0.076,-0.407,0.214,0.014,0.085,-0.526,-0.072,-0.023,0.007,-0.398,0.95],
        [0.015,0.04,-0.009,-0.907,-0.019,1.553,0.868,-0.015,0.009,0.049,-0.034,-0.918,-0.918,0.049,0.083,0.024,0.042,0.049,-0.918,-0.881,0.002,0.02,-0.023,-0.019,-0.907,0.835],
        [0.863,0.021,0.147,-0.684,-0.654,-0.359,0.053,-0.262,-0.224,0.042,-0.172,0.044,0.002,0.042,0.733,0.084,0.115,0.042,0.033,-0.59,-0.648,-0.088,-0.617,0.868,-0.661,0],
        [1.047,-0.525,-0.509,-0.49,-0.494,0.407,0.5,0.24,0.24,-0.015,-0.141,-0.374,-0.374,-0.015,1.323,0.368,-0.495,-0.015,-0.374,-0.516,-0.494,1.323,0.261,0.555,-0.481,0.034],
        [0,0.024,0.008,-0.297,-0.193,-0.137,-0.068,-0.03,-0.03,0.047,-0.112,-0.139,-0.139,0.047,0.363,-0.006,-0.291,0.048,-0.139,0.027,-0.3,0.357,0.015,-0.193,-0.297,0.024],
        [0.142,-0.085,0.116,-0.417,0.178,0.12,-0.131,0.077,0.077,0,-0.397,-0.412,-0.412,0,0.495,-0.035,0.111,0,-0.412,-0.411,-0.396,0.495,0.19,0.178,-0.417,0.196],
        [0.245,-0.265,-0.261,0.008,-0.243,0.519,0,-0.253,-0.253,-0.09,0.024,0,0,-0.09,0.227,-0.288,-0.12,-0.09,0,-0.048,0.008,0.227,0.301,0.976,-0.172,0.249],
        [0.164,0.023,0.175,-0.04,-0.224,0.151,-0.043,0.118,0.13,-0.037,-0.228,-0.043,-0.043,-0.037,-0.106,-0.045,0.092,-0.037,-0.043,-0.011,-0.236,-0.106,0.13,0.697,-0.04,-0.019],
        [1.597,-0.34,0.044,-0.308,-0.298,0.105,0.054,0.096,0.096,-0.278,-0.129,0.523,-0.334,-0.278,-0.154,0.065,-0.511,-0.278,0.523,-0.303,-0.028,0.021,-0.239,0.065,-0.308,0.358],
        [0.003,-0.006,0,-0.519,-0.516,0.065,0.112,-0.424,-0.426,-0.027,-0.446,0.112,-0.454,-0.027,0.238,0.095,-0.097,-0.027,0.112,0.043,-0.532,0.222,-0.354,0.477,-0.51,0.115],
        [0.637,-0.144,0.955,-0.71,-0.226,0.271,0.212,0.04,0,-0.255,0.354,0.729,-0.299,-0.255,1.559,-0.299,-0.215,-0.255,-0.299,-0.248,-0.248,1.559,0,-0.181,-0.71,0.265],
        [0.043,-0.024,0.128,-0.118,-0.114,0,0.076,-0.072,-0.079,0.003,0.088,0.076,0.076,0.003,0.082,-0.083,0.079,0.003,0.076,-0.116,-0.122,0.082,-0.015,0.392,-0.118,0.033],
        [0.01,0.02,0.032,-0.638,-0.621,0,-0.001,0.008,0.008,0.587,-0.04,1.699,-0.656,0.587,-0.015,-0.059,0.025,0.587,-0.656,0.024,-0.626,-0.068,0.008,0.559,-0.636,-0.006],
        [0.576,0,0.561,-0.533,-0.528,0.746,0.557,0.37,0.37,0.819,-0.485,0.557,-0.579,0.819,0.559,-0.053,0.563,0.652,-0.579,-0.015,-0.529,0.559,-0.097,1.195,-0.533,0.011],
        [0.144,-0.131,-0.44,-0.446,0.138,0.181,-0.096,0.024,0.024,-0.404,0.175,-0.4,-0.4,-0.404,-0.093,-0.074,0.163,-0.404,-0.4,0.158,0.145,-0.058,0.024,0.138,-0.446,0],
        [0.1,0.031,0.01,-0.626,-0.628,0.052,0.017,0.033,0.033,0,0.019,-0.612,-0.612,0,0,0.378,0.045,-0.006,-0.612,-0.603,-0.637,0.635,0,0.55,-0.626,-0.002],
        [-0.014,-0.074,0.082,-0.103,0,-0.1,0.269,-0.098,-0.061,0.05,-0.059,0.053,0.053,0.05,0.037,0.06,-0.098,0.05,0.053,-0.102,-0.11,0.031,0.22,0,-0.098,0.133],
        [0.177,0.172,0.235,-0.595,-0.695,0.208,-0.197,0.174,0.177,0.234,0.208,-0.26,-0.263,0.234,0.265,-0.685,-0.06,0.234,-0.26,-0.68,-0.655,0.265,0.222,1.869,-0.595,-0.21],
        [0,-0.17,0.06,-0.212,-0.226,0.069,-0.227,0.075,0.075,-0.231,-0.218,-0.227,-0.227,-0.231,0.117,-0.236,-0.192,-0.231,-0.227,0.007,0.091,0.117,0.087,0.715,-0.009,0.079],
        [0.018,-0.575,0.011,-0.587,-0.462,-0.014,0.052,0.061,0.061,0.019,-0.559,-0.555,-0.555,0.019,-0.021,0.015,0.012,0.019,-0.555,-0.018,-0.624,-0.021,0.061,0.319,-0.59,0.36],
        [-0.132,0.299,0.486,-0.694,-0.101,-0.086,0.209,-0.697,-0.697,0.179,-0.307,-1.293,-0.808,0.179,0.63,0.188,0.366,0.179,-0.784,-0.125,-0.804,0.63,-0.312,-0.126,-0.71,2.229],
        [0.442,-0.612,0.131,-0.229,-0.24,0.049,0.485,0.238,0.238,-0.234,-0.229,-0.237,-0.237,-0.234,0.989,-0.248,0.026,-0.234,-0.237,-0.242,-0.2,0.989,-0.24,1.168,-0.229,0.264],
        [0.131,-0.38,-0.06,-0.365,-0.363,-0.107,0.087,-0.036,-0.036,0.112,0.003,0.127,0.049,0.112,0.061,0.301,-0.049,0.112,0.488,0.107,-0.384,0.061,0,1.674,-0.382,0.085],
        [0.338,-0.009,0.031,-0.214,-0.217,-0.017,0.169,0.181,0.15,0.148,0.093,-0.229,-0.229,0.148,0.499,0.475,0.121,0.148,-0.229,-0.221,-0.217,0.447,-0.17,0.351,-0.221,0.147],
        [0.641,-0.196,-0.208,-0.196,0.02,0.199,0.27,-0.203,-0.217,-0.191,-0.096,-0.196,-0.196,-0.191,0.346,0.429,-0.646,-0.191,-0.196,0.287,0,0.346,0.247,0.789,-0.205,0.231],
        [1.518,0.026,0.414,-0.383,-0.419,0.022,0.022,-0.348,-0.348,0.464,0.364,0.022,0.436,0.464,0.442,-0.417,0.432,0.455,0.022,-0.408,-0.419,0.462,0.039,0.465,-0.371,0.438],
        [0.004,-0.373,0.283,-0.34,-0.381,0.248,0.911,0.056,0.056,-0.352,-0.087,-0.404,-0.404,-0.352,0.307,0.191,-0.453,-0.347,-0.404,-0.046,-0.381,0.307,0.037,1.596,-0.34,0.297],
        [0.006,-0.16,0.375,0.036,0.366,-0.378,0.268,-0.192,-0.192,-0.081,-0.106,-0.18,-0.18,-0.081,-0.201,-0.203,0.064,-0.081,-0.18,0.268,-0.179,-0.201,0.279,1.147,-0.092,0.928],
        [0.29,0.064,0.034,-0.254,-0.273,0.022,0.038,0.654,0.673,-0.003,-0.133,-0.505,-0.505,-0.003,-0.247,-0.265,0.067,-0.003,-0.505,-0.143,0.035,-0.254,0.019,1.364,-0.572,0.3],
        [-0.002,0.141,0.126,-0.248,-0.25,-0.051,-0.023,0.112,0.112,0.134,-0.126,0.495,-0.288,0.134,0.265,-0.146,-0.244,0.134,0.418,0.001,-0.25,0.265,0.112,0.179,-0.248,0.135],
        [-0.025,-0.37,0.465,-0.377,-0.359,0,0.582,-0.017,-0.017,-0.358,-0.08,-0.392,-0.392,-0.358,0.141,0.008,-0.005,-0.358,-0.392,0.115,-0.389,0.141,-0.022,0.307,-0.372,1.475],
        [0.446,-0.043,1.064,0.036,0.005,0.331,-0.035,0.017,0.017,-0.017,-0.063,-0.035,-0.058,-0.017,1.133,0.098,-0.388,-0.017,-0.035,-0.039,-0.016,-0.05,-0.017,1.052,-0.017,-0.02],
        [0.619,0.068,-0.492,-0.535,-0.498,0.023,0.584,0.091,0.122,0.595,-0.158,-0.565,-0.565,0.595,-0.286,0.006,0.093,-0.502,-0.565,-0.502,-0.619,-0.286,1.081,0.571,-0.538,0.48],
        [0.024,0.014,0.504,-0.211,-0.504,0.019,0.017,0.447,0.447,-0.046,0.007,0.017,0.017,-0.046,0.256,0.017,0.034,-0.046,0.017,-0.146,-0.504,0.256,0,0.423,-0.211,0.504],
        [0.476,-0.067,1.796,-0.518,-0.484,-0.049,0.934,-0.003,-0.011,-0.534,-0.559,-0.058,-0.058,-0.534,2.257,0.217,0,-0.534,-0.058,-0.279,-0.446,-0.067,-0.033,3.218,-0.523,0.938],
        [0.06,0.049,-0.061,-0.897,-0.911,0,1.149,0.48,0.48,0.019,-0.067,-0.905,-0.905,0.019,-0.795,-0.113,0.033,0.019,-0.905,-0.896,-0.904,-0.795,0.463,0.764,-0.897,0.007],
        [0.587,-0.329,0.688,-0.319,-0.331,0.414,0.378,-0.343,-0.341,0.043,0.063,-0.248,0.38,0.043,0.041,-0.373,-0.725,0.043,-0.791,-0.334,-0.08,0.792,-0.353,1.198,-0.319,0.656],
        [0,-0.358,0.054,-0.008,-0.298,0.192,0.023,-0.016,1.485,0.011,-0.387,-0.371,-0.373,0.011,-0.345,0.04,0.609,0.011,-0.371,-0.383,-0.309,-0.345,-0.013,0.737,-0.396,0.205],
        [0.009,-0.519,0.141,-0.506,-0.423,0.254,0.113,-0.49,-0.469,-0.038,0.055,-0.52,-0.52,-0.038,-0.016,0.83,-0.486,-0.056,-0.52,0.331,-0.453,-0.09,0,0.013,-0.486,0.329],
        [0.005,0.476,0.011,-0.497,0.017,0.006,-0.049,0.498,0.498,-0.029,-0.071,-0.062,-0.062,-0.029,-0.055,-0.006,-0.478,-0.029,-0.062,-0.004,0.007,-0.055,0.483,0.017,-0.497,0],
        [0.064,-0.519,0.56,0.692,-0.541,0.042,0.011,0,0,0.074,-0.559,-0.494,-0.494,0.074,0.343,-0.005,-0.441,0.074,-0.494,0.055,0.225,0.025,0.485,1.568,-0.276,0.022],
        [1.196,0.205,0.305,-0.262,-0.053,0.183,0.197,-0.046,-0.046,-0.256,0.079,-0.287,-0.287,2.441,-0.037,0.181,0.047,-0.256,-0.287,-0.096,-0.095,-0.037,-0.081,-0.053,-0.266,0.094],
        [0.011,-0.578,0.008,-0.58,-0.583,-0.056,-0.035,-0.017,0.032,0.002,-0.652,-0.623,-0.623,0.002,-0.018,-0.021,-0.58,0.014,-0.623,0.001,-0.017,-0.018,0.003,0.574,-0.593,0],
        [-0.07,0.462,-0.369,-0.372,-0.079,0.175,0.181,-0.083,-0.083,0.188,0.213,0.206,0.206,0.188,-0.099,0.2,0.237,0.188,0.206,-0.377,-0.079,-0.084,-0.086,0.449,-0.372,0.647],
        [0.094,-0.329,0.161,-0.326,-0.314,-0.036,0.101,0.022,0.127,0.103,0.046,-0.358,-0.358,0.103,-0.321,0.081,-0.187,0.103,-0.358,-0.089,-0.371,-0.341,-0.303,0.376,-0.326,-0.217],
        [0.107,-0.306,-0.306,-0.303,-0.255,0.157,0.267,-0.376,-0.361,0.259,0.023,-0.205,-0.205,0.259,0.261,-0.112,-0.378,0.254,-0.205,0.026,-0.325,0.251,0.057,-0.255,-0.304,0.369],
        [0.21,0.146,-0.04,-0.316,-0.29,0.198,0.134,-0.097,0.029,0.097,-0.409,-0.397,-0.397,0.097,0.634,0.075,0.265,0.097,-0.397,0.172,-0.452,0.517,0.029,0.231,-0.373,0.318],
        [-0.007,-0.07,0.008,-0.361,0.366,-0.001,-0.082,0.009,0.009,0.004,-0.023,-0.082,-0.082,0.004,-0.169,-0.059,0.003,0.004,-0.082,-0.009,-0.358,-0.353,0,0.366,-0.361,0.005],
        [0.058,-0.448,0.104,-0.449,0.024,0,-0.452,-0.286,-0.286,0.042,-0.429,-0.465,-0.47,0.042,0.039,0.014,-0.435,0.042,-0.465,0.049,-0.489,0.055,-0.087,0.175,-0.449,0.045],
        [0.372,-0.386,0.026,-0.334,-0.692,0,0.292,0.149,0.149,-0.004,-0.103,-0.404,-0.404,-0.004,0.429,0.259,-0.398,-0.004,-0.404,-0.033,-0.409,0.429,0.272,-0.004,-0.342,0.139],
        [0.041,-0.333,0.315,-0.328,0.222,0.071,-0.122,-0.327,-0.327,-0.073,-0.314,-0.122,-0.122,-0.073,-0.183,0.298,-0.051,-0.073,-0.122,0.192,-0.293,-0.188,-0.231,0.222,-0.33,0.113],
        [0.019,-0.009,0.006,-0.597,0.008,0.015,-0.069,-0.588,-0.572,-0.093,-0.131,-0.618,-0.618,-0.079,-0.021,-0.055,0.022,-0.021,-0.618,-0.037,0.543,0.492,-0.016,0.013,-0.616,0.846],
        [0.371,-0.369,0.355,-0.352,-0.722,0.34,-0.037,0.01,0.01,0.003,-0.377,-0.379,-0.379,0.003,-0.366,-0.347,-0.374,0.016,-0.379,0.028,-0.371,0.334,0.659,0.368,-0.352,0.647],
        [0.024,0.001,0.009,-0.61,-0.598,-0.062,-0.586,0.848,0.306,0.033,-0.556,-0.569,-0.599,0.033,0.038,-0.329,0.251,0.033,-0.569,-0.091,-0.601,0.008,-0.387,1.347,-0.61,0.021],
        [0.273,0.039,0.346,-0.284,-0.296,0.061,0.641,0.039,0.039,0.013,0.189,0.289,0.967,0.295,-0.038,-0.268,0.278,0.013,-0.34,-0.302,-0.296,-0.024,0.039,0.581,-0.284,0.771],
        [0.018,-0.345,-0.109,-0.322,-0.325,0.004,0.067,0.085,0.082,-0.017,-0.316,-0.331,-0.331,-0.017,0.11,0,-0.041,-0.017,-0.331,-0.103,-0.325,0.269,0.066,0.482,-0.32,0.06],
        [0.081,-0.511,-0.01,0.027,-0.547,-0.019,0.635,0.347,0.205,0.062,-0.425,-0.475,-0.475,0.062,-0.473,0.093,-0.012,0.062,-0.475,0.086,-0.542,-0.473,-0.271,0.52,-1.077,0.039],
        [0.086,-0.225,0.107,-0.126,-0.319,-0.224,0.326,-0.322,-0.322,0.151,-0.034,-0.348,-0.348,0.151,0.202,0.155,-0.288,-0.321,-0.348,-0.202,0.183,-0.295,0.165,0.42,-0.311,0.257],
        [0.065,-0.455,0.043,-0.427,-0.419,0.637,0.581,0.053,-0.42,0,0.047,0.436,0.436,0,0.637,-0.533,-0.44,0.475,0.436,-0.458,-0.501,0.619,-0.467,1.004,-0.439,0.037],
        [0.297,-0.393,0.282,-0.727,-0.736,-0.225,0.632,1.733,0.849,-0.212,-0.75,-0.255,1.184,-0.212,-0.754,0.4,-0.017,-0.212,-0.255,-0.753,-0.757,-0.761,0.696,-0.736,-0.742,0.25],
        [1.107,0.022,0.568,-0.02,-0.608,0.008,0.005,-0.005,-0.005,-0.602,0.465,-0.015,-0.015,-0.602,0.04,-0.023,0.695,-0.58,-0.015,-0.07,-0.664,0.695,-0.62,0.534,-0.032,0.035],
        [0.054,-0.221,0.086,-0.708,0.045,0.003,0.747,-0.713,-0.671,0.019,-0.739,-0.719,-0.719,0.019,-0.729,-0.034,-0.671,-0.44,-0.719,-0.056,0.009,-0.013,0.008,0.644,-0.67,1.934],
        [0.133,-0.475,0.313,-0.315,-0.515,-0.138,0.08,0,-0.004,-0.335,0.213,0.041,0.041,-0.335,0.493,-0.322,0.194,-0.335,0.041,-0.414,-0.573,-0.212,0.016,1.023,-0.336,0.168],
        [0.195,-0.053,0.228,-0.267,-0.023,1.005,-0.027,0.093,0.093,-0.127,-0.027,-0.122,-0.122,-0.127,0.141,0.264,-0.116,-0.127,-0.122,0,-0.085,-0.084,0.09,-0.023,-0.239,0.051],
        [1.084,-0.467,0.398,-0.442,-0.409,0.671,0.164,-0.425,-0.425,0,-0.512,0.481,0.987,0,0.126,-0.446,-1.035,-0.044,0.481,-0.406,-0.411,-0.447,1.755,0.13,-0.438,1.397],
        [-0.041,-0.067,0.051,-0.115,0.127,0.106,0.542,0.01,0.01,-0.115,-0.222,-0.009,-0.009,-0.115,0.15,0.111,-0.141,-0.115,-0.009,-0.029,0.127,0.15,0.121,0.127,-0.115,-0.109],
        [0.551,0.151,-0.227,-0.228,-0.242,0.136,0.338,0.143,0.143,-0.223,-0.212,-0.223,-0.587,-0.223,-0.147,0.161,-0.239,-0.223,-0.502,0.522,-0.236,-0.159,0.549,1.209,-0.226,0.159],
        [0,-0.111,0.116,-0.308,-0.314,0.014,-0.061,-0.067,-0.067,0.111,0.135,0.051,0.051,0.111,0.138,-0.018,-0.303,0.111,0.051,0.154,-0.307,0.138,-0.029,-0.314,-0.308,0.121]
    ];
	
	var yData3 = [
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','Amplification','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','Amplification','','','','','','','Amplification','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','Amplification','','','','','','','','','','','','','','','','','','','Amplification'],
        ['','','','','','','Amplification','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','Amplification','','','','Deep Deletion','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','','Amplification'],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','Amplification','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','Amplification','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','Amplification','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','Amplification','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','Deep Deletion','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','','Amplification'],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','Deep Deletion','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','Amplification','','','','Amplification','',''],
        ['','','','','','Amplification','','','','','','','','','','','','','','','','Amplification','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','Deep Deletion',''],
        ['','','Amplification','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','Deep Deletion','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','Deep Deletion','Deep Deletion','','','','','','Deep Deletion','','Deep Deletion','','','','',''],
        ['','','','','','','','','','','','','','','','','','Amplification','Amplification','','','','','','',''],
        ['','','','','','','','','','','','','','','','Amplification','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','Amplification','','','','','','','','','','','','','','Deep Deletion','','','','','Amplification'],
        ['','','','','','','','','','','','','','','Amplification','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','Amplification','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','Amplification','','','','','','','Amplification','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','Amplification','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','Deep Deletion','','','','','',''],
        ['','Deep Deletion','','','','','','Deep Deletion','','','Deep Deletion','','','','Amplification','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','Amplification','','','','','','','','','Amplification'],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','Amplification','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','Amplification','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','Amplification','','','','Amplification','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','Amplification','','','','','','','','',''],
        ['','','','','','','Amplification','','','','','','','','','','','','','','','Amplification','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','','Amplification'],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','Amplification','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','Deep Deletion','','','','','','','','','','','','','','Amplification'],
        ['','Deep Deletion','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','Deep Deletion','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','','Amplification'],
        ['','','','','','','','','','','','','','','Amplification','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Amplification','','','','','','','','','','','','Amplification','','','','','','','','','Amplification','',''],
        ['','','','','','','Amplification','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','Deep Deletion','','Deep Deletion','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','Amplification','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','Deep Deletion','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','Deep Deletion','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','','','','','Amplification','','','','','Amplification','','','','','','','','','','','','',''],
        ['Amplification','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','','Amplification'],
        ['','','','','','','','','','','','','','','','','','','','','','','','Amplification','',''],
        ['','','','Deep Deletion','','Amplification','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','Amplification','','','Amplification'],
        ['','','','','','','Amplification','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','Deep Deletion','','','','','','Deep Deletion','','','','','Amplification','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','','']
    ];
	
	var yData4 = [
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Missense Mutation (putative driver)','','','','','','','','','Truncating mutation (putative passenger)','','','','','','','','Missense Mutation (putative passenger)','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Truncating mutation (putative passenger)','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Truncating mutation (putative passenger)','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','Truncating mutation (putative passenger)','','','',''],
        ['','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','Truncating mutation (putative passenger)','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','Missense Mutation (putative passenger)','','Missense Mutation (putative passenger)','','','','','','','','','Truncating mutation (putative passenger)','','','','','','','','','','','',''],
        ['','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','',''],
        ['Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','Missense Mutation (putative driver)','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','Missense Mutation (putative passenger)','','','','','','','','Missense Mutation (putative passenger)','','','','','','','Missense Mutation (putative passenger)','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','Missense Mutation (putative passenger)','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','Truncating mutation (putative passenger)','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','Missense Mutation (putative passenger)','',''],
        ['','','','','','','','','','','','','','','','','','','','','','','','','','']
    ];
	
	var zData = {
	    'Study ID': ['lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga','lusc_tcga'],
	    'Patient ID': ['TCGA-18-3406','TCGA-18-3407','TCGA-18-3408','TCGA-18-3409','TCGA-18-3410','TCGA-18-3411','TCGA-18-3412','TCGA-18-3414','TCGA-18-3415','TCGA-18-3416','TCGA-18-3417','TCGA-18-3419','TCGA-18-3421','TCGA-18-4083','TCGA-18-4086','TCGA-18-4721','TCGA-18-5592','TCGA-18-5595','TCGA-21-1070','TCGA-21-1071','TCGA-21-1076','TCGA-21-1077','TCGA-21-1078','TCGA-21-1081','TCGA-21-5782','TCGA-21-5784','TCGA-21-5786','TCGA-21-5787','TCGA-22-0944','TCGA-22-1002','TCGA-22-1011','TCGA-22-1012','TCGA-22-1016','TCGA-22-4591','TCGA-22-4593','TCGA-22-4595','TCGA-22-4599','TCGA-22-4601','TCGA-22-4604','TCGA-22-4607','TCGA-22-4613','TCGA-22-5471','TCGA-22-5472','TCGA-22-5473','TCGA-22-5474','TCGA-22-5477','TCGA-22-5478','TCGA-22-5480','TCGA-22-5482','TCGA-22-5485','TCGA-22-5489','TCGA-22-5491','TCGA-22-5492','TCGA-33-4532','TCGA-33-4533','TCGA-33-4538','TCGA-33-4547','TCGA-33-4566','TCGA-33-4582','TCGA-33-4583','TCGA-33-4586','TCGA-33-6737','TCGA-34-2596','TCGA-34-2600','TCGA-34-2608','TCGA-34-5231','TCGA-34-5232','TCGA-34-5234','TCGA-34-5236','TCGA-34-5239','TCGA-34-5240','TCGA-34-5241','TCGA-34-5927','TCGA-34-5928','TCGA-34-5929','TCGA-37-3783','TCGA-37-3789','TCGA-37-4133','TCGA-37-4135','TCGA-37-4141','TCGA-37-5819','TCGA-39-5016','TCGA-39-5019','TCGA-39-5021','TCGA-39-5022','TCGA-39-5024','TCGA-39-5027','TCGA-39-5028','TCGA-39-5029','TCGA-39-5030','TCGA-39-5031','TCGA-39-5035','TCGA-39-5036','TCGA-39-5037','TCGA-39-5039','TCGA-43-2578','TCGA-43-3394','TCGA-43-3920','TCGA-43-5668','TCGA-43-6143','TCGA-43-6647','TCGA-43-6770','TCGA-43-6771','TCGA-46-3765','TCGA-46-3766','TCGA-46-3767','TCGA-46-3768','TCGA-46-3769','TCGA-46-6025','TCGA-46-6026','TCGA-51-4079','TCGA-51-4080','TCGA-51-4081','TCGA-56-1622','TCGA-56-5897','TCGA-56-5898','TCGA-56-6545','TCGA-56-6546','TCGA-60-2698','TCGA-60-2707','TCGA-60-2708','TCGA-60-2709','TCGA-60-2710','TCGA-60-2711','TCGA-60-2712','TCGA-60-2713','TCGA-60-2715','TCGA-60-2719','TCGA-60-2720','TCGA-60-2721','TCGA-60-2722','TCGA-60-2723','TCGA-60-2724','TCGA-60-2725','TCGA-60-2726','TCGA-63-5128','TCGA-63-5131','TCGA-63-6202','TCGA-66-2727','TCGA-66-2734','TCGA-66-2742','TCGA-66-2744','TCGA-66-2754','TCGA-66-2755','TCGA-66-2756','TCGA-66-2757','TCGA-66-2758','TCGA-66-2759','TCGA-66-2763','TCGA-66-2765','TCGA-66-2766','TCGA-66-2767','TCGA-66-2768','TCGA-66-2770','TCGA-66-2771','TCGA-66-2773','TCGA-66-2777','TCGA-66-2778','TCGA-66-2780','TCGA-66-2781','TCGA-66-2782','TCGA-66-2783','TCGA-66-2785','TCGA-66-2786','TCGA-66-2787','TCGA-66-2788','TCGA-66-2789','TCGA-66-2791','TCGA-66-2792','TCGA-66-2793','TCGA-66-2794','TCGA-66-2795','TCGA-66-2800','TCGA-70-6722','TCGA-70-6723','TCGA-85-6175','TCGA-85-6560','TCGA-85-6561'],
	    'Diagnosis Age': [67,72,77,74,81,63,52,73,77,83,65,73,65,63,64,74,57,50,60,67,54,64,77,69,68,80,64,65,61,69,73,80,65,80,77,57,73,73,73,75,73,75,67,78,74,65,79,66,81,58,64,74,73,68,76,66,68,40,55,73,57,71,70,76,84,72,75,71,60,75,73,79,70,83,78,51,65,63,68,65,64,44,70,70,76,65,73,75,67,81,76,72,73,65,76,59,52,71,78,70,69,59,85,59,62,76,58,57,71,81,73,65,55,58,74,69,77,67,62,70,64,69,67,64,79,64,51,83,60,73,66,74,47,74,56,'','','',55,62,70,71,67,63,68,65,71,66,63,64,54,62,57,79,60,69,71,68,65,67,71,67,65,68,57,56,73,66,58,68,64,68,70,47,65,63,59,66],
	    'American Joint Committee on Cancer Metastasis Stage Code': ['M0','M0','M0','M0','M0','M0','M0','M1','M0','M0','M1','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','MX','MX','MX','M0','M0','M0','M0','M0','M0','M0','','','M0','M0','MX','M0','M0','MX','M0','M0','M0','MX','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M1','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0','M0'],
	    'Neoplasm Disease Lymph Node Stage American Joint Committee on Cancer Code': ['N0','N0','N0','N0','N0','N2','N0','N1','N0','N1','N1','N1','N0','N1','N0','N0','N0','N0','N0','N0','N0','N1','N0','N1','N0','N0','N0','N2','N0','N0','N0','N0','N0','N2','N0','N2','N0','N0','N1','N0','N0','N0','N0','N0','N0','N0','N0','N0','N0','N0','N0','N0','N2','N0','N0','N2','N0','N0','N0','N0','N2','N2','N1','N0','N0','N0','N1','N0','N0','N0','N1','N0','N0','N1','N0','N2','N0','N0','N0','N0','N2','N1','N0','N0','N0','N2','N0','N1','N2','N2','N0','N0','N0','N1','N0','N0','N0','N0','N1','N0','N1','N0','N0','N0','N0','N0','N1','N0','N1','N1','N0','N1','N1','N0','N0','N0','N0','N0','N1','N0','N1','N0','N1','N0','N1','N0','N0','N0','N0','N0','N1','N0','N1','N0','N1','N0','N1','N0','N0','N0','N1','N1','N2','N0','N0','N0','N0','N2','N0','N0','N2','N3','N1','N0','N1','N0','N0','N3','N0','N0','N0','N3','N0','N0','N0','N0','N3','N3','N1','N1','N2','N1','N0','N1','N0','N0','N1','NX'],
	    'Neoplasm Disease Stage American Joint Committee on Cancer Code': ['Stage IA','Stage IB','Stage IB','Stage IA','Stage IIB','Stage IIIA','Stage IB','Stage IV','Stage IB','Stage IIB','Stage IV','Stage IIB','Stage IB','Stage IIB','Stage IB','Stage IA','Stage IIB','Stage IB','Stage IIIA','Stage IB','Stage IB','Stage IIB','Stage IB','Stage IIB','Stage IB','Stage IB','Stage IB','Stage IIIA','Stage IB','Stage IA','Stage IB','Stage IB','Stage IB','Stage IIIA','Stage IIA','Stage IIIA','Stage IB','Stage IIIA','Stage IIA','Stage IB','Stage IA','Stage IB','Stage IB','','Stage IB','Stage IA','Stage IB','Stage IA','Stage IB','Stage IA','Stage IA','Stage IA','Stage IIIA','Stage IB','Stage IB','Stage IIIA','Stage IB','Stage IB','Stage IA','Stage IA','Stage IIIA','Stage IIIA','Stage IIB','Stage IA','Stage IB','Stage IA','Stage IIA','Stage IA','Stage IIB','Stage IIIA','Stage IIB','Stage IB','Stage IA','Stage IIB','Stage IB','Stage IIIA','Stage IB','Stage IIIA','Stage IB','Stage IA','Stage IIIA','Stage IIA','Stage IB','Stage IB','Stage IB','Stage IIIA','Stage IB','Stage IIIA','Stage IIIA','Stage IIIA','Stage IA','Stage IA','Stage IB','Stage IIA','Stage IIA','Stage IA','Stage IB','Stage IB','Stage IIA','Stage IB','Stage IIB','Stage IB','Stage IB','Stage IA','Stage IA','Stage IA','Stage IIIA','','Stage IIB','Stage IIB','Stage IB','Stage IIIB','Stage IIB','Stage IB','Stage IA','Stage IA','Stage IB','Stage IIA','Stage IIB','Stage IB','Stage IIB','Stage IB','Stage IIA','Stage IB','Stage IIB','Stage IB','Stage IA','Stage IB','Stage IB','Stage IB','Stage IIB','Stage IB','Stage IIIA','Stage IB','Stage IIA','Stage IB','Stage IIB','Stage IIA','Stage IB','Stage IB','Stage IV','Stage IIB','Stage IIIA','Stage IB','Stage IIIB','Stage IA','Stage IB','Stage IIIA','Stage IB','Stage IB','Stage IIIA','Stage IIIB','Stage IIB','Stage IB','Stage IIB','Stage IB','Stage IB','Stage IIIB','Stage IB','Stage IB','Stage IIB','Stage IIIB','Stage IB','Stage IA','Stage IA','Stage IB','Stage IIIB','Stage IIIB','Stage IIB','Stage IIIB','Stage IIIB','Stage IIIB','Stage IIIB','Stage IIIA','Stage IIA','Stage IIB','Stage IIA','Stage IB'],
	    'American Joint Committee on Cancer Publication Version Type': ['','','','6th','','','','','','','','','','','','','','','','','','','','','','6th','6th','','','','','','','','7th','','','','','','','6th','','','','','','','','','','','','5th','5th','6th','6th','4th','5th','5th','6th','6th','','','','6th','6th','6th','6th','7th','6th','','','7th','7th','7th','7th','7th','7th','7th','7th','6th','7th','','7th','7th','7th','','','','6th','6th','6th','6th','','6th','6th','7th','7th','7th','7th','7th','6th','','','','','','','','6th','','','','7th','7th','7th','7th','','','','6th','6th','','','','6th','','','','','','','','','6th','6th','6th','5th','5th','5th','5th','6th','5th','6th','6th','5th','5th','6th','6th','6th','6th','6th','6th','6th','6th','6th','6th','6th','6th','5th','6th','6th','5th','6th','6th','6th','6th','6th','6th','6th','6th','5th','6th','6th','7th','7th','7th'],
	    'American Joint Committee on Cancer Tumor Stage Code': ['T1','T2','T2','T1','T3','T2','T2','T4','T2','T2','T2','T2','T2','T2','T2','T1','T3','T2','T3','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T1','T2','T2','T2','T3','T2b','T3','T2a','T4','T2a','T2a','T1b','T2','T2a','T3','T2a','T1','T2a','T1b','T2a','T1a','T1b','T1a','T2a','T2','T2','T2','T2','T2','T1','T1','T2','T2','T2','T1','T2','T1','T1','T1','T3','T4','T2','T2','T1','T2','T2','T3','T2','T4','T2a','T1b','T2','T2a','T2a','T2a','T2a','T2a','T2a','T4','T1b','T2a','T1a','T1b','T2','T1b','T2b','T1','T2a','T2','T1b','T2','T2b','T2a','T2','T1','T1','T1a','T3','T4','T2b','T2a','T2','T4','T2a','T2','T1b','T1b','T2a','T2b','T2','T2','T2','T2','T1','T2','T2','T2','T1','T1','T2','T2','T2','T2','T3','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T4','T1','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T2','T3','T2','T2','T1','T1','T2','T1','T2','T2','T4','T4','T4','T4','T3','T3','T3','T1b','T2a'],
	    'ALK Translocation Status': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','','','','','','','','','','','','YES','NO','NO','','','YES','NO','NO','NO','NO','NO','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','',''],
	    'Cancer Type': ['Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer','Non-Small Cell Lung Cancer'],
	    'Cancer Type Detailed': ['Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma'],
	    'Carbon monoxide diffusion dlco': ['','','','','','','','','','','','','','','','','','','','','','','','','',69,71,'','','','','','','','','','','','','','','','','','','','','','','','','','',27,11,20,'',23,25,29,37,'','','','','','','','','','','','','','','','','','','','',98,96,'','',81,79,'','','',58,39,71,79,'','',81,50,61,40,'',59,101,'','','','','','','','','','','','','','','','','','','',61,'','','',134,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Disease Free (Months)': [11.73,'',58.9,75.26,'',117.48,8.97,'','',30.88,'',92.35,86.89,'','',154.2,49.9,'',119.45,32.62,51.74,21.16,8.44,'','',41.66,26.84,3.38,'','','','','',14.55,'',19.19,'',17.25,10.05,'','',7.52,29.63,54.37,'',16.79,'',58.44,'',27.6,23.98,'','','',133.64,'',79.47,'',96.02,'',5.55,'','','','','',81.18,74.61,3.71,50.26,50.62,'',8.05,39.29,'',4.01,0.43,7.82,6.8,0.39,3.38,126.48,12.42,61.6,47.57,82.46,101.22,'',16.13,'','',68.33,71.12,55.52,'','',18.13,33.08,15.44,22.96,24.87,21.45,5.06,13.3,12.16,13.01,'',4.43,10.64,13.9,'','',29.93,'',12.42,18.23,21.88,'',3.75,19.02,80.39,49.44,66.49,41.39,'',47.08,'',42.61,3.19,32.29,27.96,35.87,23.55,26.81,'','','',52.63,'',43.07,21.06,0.99,2,0.92,0.99,29.96,20.99,25.03,0.99,2,1.02,2,2,23,18.99,'',2,18.99,'',3.98,9.99,24.93,1.97,25.95,39.98,22.96,'','',29.99,'',54.04,4.01,49.01,9.63,10.25,'',41.36,40.21],
	    'Disease Free Status': ['Recurred/Progressed','','Recurred/Progressed','Recurred/Progressed','','DiseaseFree','Recurred/Progressed','','','Recurred/Progressed','','DiseaseFree','DiseaseFree','','','DiseaseFree','DiseaseFree','','DiseaseFree','Recurred/Progressed','Recurred/Progressed','Recurred/Progressed','Recurred/Progressed','','','DiseaseFree','Recurred/Progressed','Recurred/Progressed','','','','','','Recurred/Progressed','','Recurred/Progressed','','Recurred/Progressed','Recurred/Progressed','','','Recurred/Progressed','Recurred/Progressed','Recurred/Progressed','','Recurred/Progressed','','Recurred/Progressed','','Recurred/Progressed','Recurred/Progressed','','','','DiseaseFree','','DiseaseFree','','Recurred/Progressed','','Recurred/Progressed','','','','','','DiseaseFree','DiseaseFree','Recurred/Progressed','Recurred/Progressed','DiseaseFree','','Recurred/Progressed','DiseaseFree','','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','Recurred/Progressed','Recurred/Progressed','Recurred/Progressed','DiseaseFree','Recurred/Progressed','','Recurred/Progressed','','','DiseaseFree','DiseaseFree','DiseaseFree','','','Recurred/Progressed','DiseaseFree','Recurred/Progressed','DiseaseFree','DiseaseFree','DiseaseFree','Recurred/Progressed','DiseaseFree','DiseaseFree','DiseaseFree','','DiseaseFree','DiseaseFree','DiseaseFree','','','DiseaseFree','','DiseaseFree','DiseaseFree','DiseaseFree','','Recurred/Progressed','Recurred/Progressed','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','','Recurred/Progressed','','DiseaseFree','DiseaseFree','DiseaseFree','Recurred/Progressed','DiseaseFree','DiseaseFree','DiseaseFree','','','','DiseaseFree','','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','Recurred/Progressed','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','','DiseaseFree','DiseaseFree','','DiseaseFree','Recurred/Progressed','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','DiseaseFree','','','DiseaseFree','','DiseaseFree','DiseaseFree','DiseaseFree','Recurred/Progressed','Recurred/Progressed','','DiseaseFree','DiseaseFree'],
	    'Performance Status': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',1,'','',0,3,'',1,'','','','','','','','',1,'','',1,2,2,2,1,1,1,1,'','','','','','','','','','','','','','','','',2,1,'',1,'','','','','','','','','','','','','','',0,0,'',1,1,0,'','','','','','','',1,3,'','','','','','','','','','','','','','','','',0,'','','','','','',0,'','','',1,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Ethnicity Category': ['NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','','','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','','','','','','','','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','','','NOT HISPANIC OR LATINO','','','','','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','HISPANIC OR LATINO','','','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','NOT HISPANIC OR LATINO','','HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO','NOT HISPANIC OR LATINO'],
	    'Fev1 fvc ratio postbroncholiator': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',76,63,'','','',37,'',69,'','','','','','','','','','','','','','','','','','','','',73,72,'','',96,82,'','','',89,67,49,56,'',60,60,97,89,77,'',96,121,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Fev1 fvc ratio prebroncholiator': ['','','','','','','','','','','','','','','','','','','','','','','','','',74,76,'','','','','','','','','','','','','','','','','','','','','','','','','','',78,63,3,'',77,'',73,70,'','','','','','','','','','','','','','','','','','','','',73,76,'','',91,78,'','','',85,63,53,61,'',63,60,95,84,78,'',99,117,'','','','','','','','','','','','','','','','','','','',67,'','','',61,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Fev1 percent ref postbroncholiator': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',3,1,'','','','','',2,'','','','','','','','','','','','','','','','','','','','',75,62,'','',87,63,'','','',79,71,62,60,'',45,50,77,83,50,'',93,109,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Fev1 percent ref prebroncholiator': ['','','','','','','','','','','','','','','','','','','','','','','','','',80,76,'','','','','','','','','','','','','','','','','','','','','','','','','','',3,1,2,62,4,1,3,2,'','','','','','','','','','','','','','','','','','','','',77,57,'','',88,55,'','','',76,68,61,56,'',42,36,78,74,45,76,97,104,'','','','','','','','','','','','','','','','','','','',61,'','','',86,'','','','','','','','',60,60,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Form completion date': ['3/9/11','3/9/11','3/9/11','3/17/11','4/4/11','3/17/11','3/25/11','3/25/11','3/25/11','3/25/11','3/25/11','3/25/11','4/4/11','4/4/11','4/4/11','4/4/11','4/27/11','4/27/11','2/24/10','2/23/10','3/3/10','3/3/10','3/4/10','2/23/10','5/2/11','5/2/11','5/2/11','5/3/11','2/12/10','2/12/10','2/15/10','2/15/10','2/15/10','1/4/11','8/5/11','1/5/11','11/30/10','2/10/11','2/10/11','2/10/11','2/10/11','5/5/11','4/29/11','4/29/11','5/4/11','5/2/11','5/5/11','5/6/11','5/6/11','5/10/11','5/11/11','5/11/11','5/11/11','2/3/11','2/3/11','2/3/11','2/3/11','2/3/11','2/3/11','2/3/11','2/3/11','9/23/11','8/9/10','9/13/10','8/26/10','8/26/11','8/26/11','3/8/11','8/26/11','8/26/11','2/10/11','2/10/11','8/26/11','8/26/11','8/26/11','12/17/10','12/17/10','12/16/10','12/16/10','12/17/10','5/20/11','12/4/10','6/20/11','12/4/10','9/19/11','10/6/11','9/19/11','12/4/10','12/4/10','12/4/10','12/6/10','12/6/10','12/6/10','12/6/10','12/6/10','10/18/10','10/11/10','10/11/10','4/14/11','8/24/11','8/24/11','8/24/11','8/26/11','12/1/10','12/1/10','12/1/10','12/1/10','12/1/10','6/1/11','6/1/11','12/7/10','12/7/10','12/7/10','2/3/10','9/16/10','7/12/10','7/22/11','7/19/11','7/26/10','7/16/10','7/16/10','8/2/11','7/16/10','7/16/10','7/16/10','7/19/10','5/9/11','7/19/10','7/19/10','7/20/10','7/20/10','7/20/10','7/20/10','4/13/11','7/20/10','4/4/11','4/6/11','8/11/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','3/7/11','8/9/11','8/9/11','6/21/11','8/31/11','8/23/11'],
	    'Fraction Genome Altered': [0.2702,0.2552,0.2738,0.2572,0.5446,0.5275,0.6524,0.3907,0.6074,0.6754,0.4697,0.3291,0.4823,0.6112,0.2173,0.2381,0.5567,0.1299,0.4323,0.2736,0.0804,0.1839,0.0205,0.6962,0.3733,0.0395,0.7311,0.4027,0.3465,0.194,0.0184,0.4887,0.2312,0.5458,0.52,0.6031,0.6777,0.4094,0.456,0.385,0.439,0.4238,0.2486,0.617,0.3815,0.704,0.4435,0.3182,0.3978,0.3931,0.2937,0.4358,0.354,0.4665,0.485,0.627,0.3885,0.2164,0.2933,0.3031,0.4821,0.4436,0.8344,0.673,0.0612,0.691,0.1499,0.0002,0.2159,0.2422,0.6309,0.0986,0.4569,0.5559,0.4438,0.297,0.342,0.5885,0.6925,0.7338,0.6739,0.6401,0.286,0.2476,0.0215,0.1328,0.4995,0.0701,0.3887,0.0782,0.4247,0.394,0.4163,0.4418,0.0331,0.4834,0.6657,0.5638,0.3073,0.6758,0.0402,0.4276,0.0423,0.3617,0.0588,0.0805,0.6107,0.4243,0.5295,0.4194,0.3895,0.3449,0.5713,0.6922,0.2066,0.3753,0.3498,0.1258,0.3627,0.3205,0.6958,0.0427,0.368,0.6256,0.2869,0.4712,0.0545,0.8519,0.0634,0.334,0.5892,0.5274,0.3257,0.0877,0.6693,0.7388,0.5194,0.2614,0.3638,0.0471,0.403,0.1361,0.5903,0.3397,0.5389,0.4916,0.7396,0.498,0.7082,0.3137,0.6367,0.3278,0.2459,0.3199,0.3567,0.4252,0.3801,0.3033,0.3673,0.5878,0.3826,0.3125,0.6464,0.404,0.5107,0.2566,0.4025,0.4306,0.7393,0.8301,0.382,0.4341,0.5956,0.1633,0.7224,0.1427,0.3285,0.4219],
	    'Neoplasm Histologic Type Name': ['Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma','Lung Squamous Cell Carcinoma'],
	    'Neoadjuvant Therapy Type Administered Prior To Resection Text': ['No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','Yes','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','Yes','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No'],
	    'Prior Cancer Diagnosis Occurence': ['Yes','Yes','No','Yes','Yes','No','No','No','No','Yes','No','No','No','Yes','No','No','No','Yes','Yes','No','No','Yes','Yes','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','Yes','Yes','No','No','No','No','No','No','No','No','No','No','Yes','Yes','No','No','No','No','No','No','Yes','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','Yes','Yes','No','No','Yes','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','Yes','Yes','No','Yes','No','No','Yes','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No','No'],
	    'ICD-10 Classification': ['C34.1','C34.1','C34.3','C34.1','C34.3','C34.1','C34.3','C34.3','C34.1','C34.1','C34.9','C34.3','C34.3','C34.3','C34.3','C34.3','C34.1','C34.3','C34.1','C34.1','C34.3','C34.1','C34.3','C34.3','C34.3','C34.1','C34.1','C34.1','C34.9','C34.9','C34.9','C34.9','C34.9','C34.3','C34.3','C34.3','C34.8','C34.1','C34.1','C34.3','C34.1','C34.3','C34.3','C34.3','C34.1','C34.3','C34.3','C34.1','C34.1','C34.1','C34.1','C34.3','C34.1','C34.3','C34.9','C34.1','C34.1','C34.1','C34.3','C34.3','C34.3','C34.1','C34.9','C34.3','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.3','C34.3','C34.3','C34.1','C34.1','C34.1','C34.9','C34.3','C34.1','C34.1','C34.3','C34.1','C34.1','C34.1','C34.9','C34.3','C34.1','C34.3','C34.3','C34.1','C34.3','C34.1','C34.3','C34.1','C34.1','C34.3','C34.1','C34.1','C34.3','C34.3','C34.1','C34.1','C34.1','C34.3','C34.3','C34.1','C34.1','C34.3','C34.3','C34.1','C34.1','C34.1','C34.3','C34.1','C34.1','C34.1','C34.1','C34.3','C34.1','C34.3','C34.1','C34.1','C34.9','C34.1','C34.3','C34.1','C34.9','C34.3','C34.1','C34.1','C34.9','C34.9','C34.1','C34.2','C34.1','C34.9','C34.1','C34.3','C34.3','C34.1','C34.3','C34.1','C34.1','C34.1','C34.1','C34.1','C34.3','C34.1','C34.3','C34.1','C34.3','C34.3','C34.3','C34.1','C34.3','C34.2','C34.3','C34.1','C34.1','C34.1','C34.3','C34.1','C34.1','C34.1','C34.3','C34.3','C34.3','C34.3','C34.2','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1'],
	    'International Classification of Diseases for Oncology, Third Edition ICD-O-3 Histology Code': ['8070/3','8070/3','8070/3','8083/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8083/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8083/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8083/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8083/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8070/3','8052/3','8070/3','8070/3','8070/3'],
	    'International Classification of Diseases for Oncology, Third Edition ICD-O-3 Site Code': ['C34.1','C34.1','C34.3','C34.1','C34.3','C34.1','C34.3','C34.3','C34.1','C34.1','C34.9','C34.3','C34.3','C34.3','C34.3','C34.3','C34.1','C34.3','C34.1','C34.1','C34.3','C34.1','C34.3','C34.3','C34.3','C34.1','C34.1','C34.1','C34.9','C34.9','C34.9','C34.9','C34.9','C34.3','C34.3','C34.3','C34.8','C34.1','C34.1','C34.3','C34.1','C34.3','C34.3','C34.3','C34.1','C34.3','C34.3','C34.1','C34.1','C34.1','C34.1','C34.3','C34.1','C34.3','C34.9','C34.1','C34.1','C34.1','C34.3','C34.3','C34.3','C34.1','C34.9','C34.3','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.3','C34.3','C34.3','C34.1','C34.1','C34.1','C34.9','C34.3','C34.1','C34.1','C34.3','C34.1','C34.1','C34.1','C34.9','C34.3','C34.1','C34.3','C34.3','C34.1','C34.3','C34.1','C34.3','C34.1','C34.1','C34.3','C34.1','C34.1','C34.3','C34.3','C34.1','C34.1','C34.1','C34.3','C34.3','C34.1','C34.1','C34.3','C34.3','C34.1','C34.1','C34.1','C34.3','C34.1','C34.1','C34.1','C34.1','C34.3','C34.1','C34.3','C34.1','C34.1','C34.9','C34.1','C34.3','C34.1','C34.9','C34.3','C34.1','C34.1','C34.9','C34.9','C34.1','C34.2','C34.1','C34.9','C34.1','C34.3','C34.3','C34.1','C34.3','C34.1','C34.1','C34.1','C34.1','C34.1','C34.3','C34.1','C34.3','C34.1','C34.3','C34.3','C34.3','C34.1','C34.3','C34.2','C34.3','C34.1','C34.1','C34.1','C34.3','C34.1','C34.1','C34.1','C34.3','C34.3','C34.3','C34.3','C34.2','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1','C34.1'],
	    'Informed consent verified': ['YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES'],
	    'Year Cancer Initial Diagnosis': [2003,2003,2004,2004,2004,2005,2005,2005,2006,2006,2006,2007,2007,2005,2009,2002,2010,2008,2000,2001,2005,2006,2006,1996,2004,2008,2009,2009,2000,2001,2001,2001,2001,2001,2002,2002,2002,2003,2003,2003,2004,2005,2005,2005,2005,2004,2004,2002,2005,2001,2003,2003,2003,2001,2001,2002,2007,1996,2000,1999,2007,2008,2004,2000,1999,2006,2006,2007,2007,2010,2009,2009,2009,2010,2010,2006,2006,2010,2010,2010,2010,2003,2004,2004,2005,2005,2006,2006,2006,2006,2007,2007,2007,2007,2008,2009,2009,2009,2010,2010,2010,2011,2006,2009,2009,2009,2010,2009,2010,2010,2009,2009,2009,2007,2010,2010,2010,2011,1993,2003,2004,2004,2005,2007,2006,2006,2008,2007,2007,2008,2008,2008,2008,2009,2009,2007,2008,2008,2004,2005,2006,2006,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2004,2008,2008,2008,2004,2008,2008,2008,2008,2008,2006,2008,2004,2010,2010,2010,2011,2011],
	    'Is FFPE': ['NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO'],
	    'Karnofsky Performance Score': [0,0,'','',0,'','',0,'','','','','','','','','','','','','','','','',0,'','',0,'','','','','',0,0,0,0,0,0,'',0,'',0,0,0,0,0,0,0,0,0,0,0,'','','','','','','','','','','','','','',90,'','','','','','','','','',50,80,'',90,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',0,'','','','','',0,'',100,'','','','','','',90,0,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',20,40,'','',''],
	    'Kras gene analysis indicator': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','NO','','','','','','','','','','','NO','','','NO','NO','','','','NO','NO','NO','NO','NO','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','NO','NO'],
	    'KRAS Mutation': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','','','','','','','','','','','','NO','','','','NO','','NO','','','','','NO','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Location lung parenchyma': ['','','','','Peripheral Lung','','Central Lung','','','','','','','','','','','','','','','','','','','Central Lung','Central Lung','','','','','','','Peripheral Lung','Central Lung','','Central Lung','','Central Lung','Peripheral Lung','','','','','','','Peripheral Lung','Central Lung','','','','','','','','','','','','','','','','Central Lung','','','','Central Lung','','','Central Lung','','','','','Central Lung','Central Lung','Peripheral Lung','Peripheral Lung','Peripheral Lung','Peripheral Lung','Central Lung','Peripheral Lung','Central Lung','Peripheral Lung','Central Lung','Peripheral Lung','Central Lung','Central Lung','Peripheral Lung','Peripheral Lung','Central Lung','Peripheral Lung','Central Lung','Central Lung','','','','','','','','','Central Lung','Central Lung','Central Lung','Central Lung','Central Lung','Central Lung','Central Lung','Central Lung','Central Lung','Central Lung','','','','','','','Peripheral Lung','Central Lung','Peripheral Lung','Peripheral Lung','Peripheral Lung','Central Lung','','','Central Lung','Central Lung','Central Lung','Central Lung','Peripheral Lung','','Central Lung','Central Lung','','Central Lung','Central Lung','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','Central Lung','Peripheral Lung','Central Lung'],
	    'Longest Dimension': [0.8,0.5,0.5,0.9,0.5,0.6,0.6,0.7,0.8,0.5,0.8,0.9,1,0.5,0.8,1,1.1,0.8,1.2,1.2,1,0.9,2,2.2,1.3,1,1,1.1,0.6,0.8,1,0.6,1,1.1,0.8,1,1.1,0.7,1.5,1.1,1.1,0.9,1.2,1.1,1,1.4,1.1,1.5,1.2,1.2,1.6,0.8,1.8,2,1.5,0.9,1.7,1.5,1.1,1,1.5,2,1.8,1.1,1.9,1.5,1.5,1.5,2.1,1.1,1.2,1.5,1,1,1.5,0.5,1,1.8,1,1.3,1.2,1.3,1.8,1.8,1.4,1.7,1.8,1.9,2,2,1.9,1.8,1.5,1.3,2,0.8,0.9,1.3,1.3,1.6,1,2,1,0.8,0.8,0.8,0.7,0.9,1,1,0.8,1.3,1,0.9,0.6,0.8,1,0.9,1.7,1.5,1.4,2,1.5,1.3,0.9,0.9,0.5,1.2,1.2,1.2,0.6,1.2,1.5,1.2,1,1.1,1.2,1,1,1,1.2,0.6,0.7,0.6,1.2,1,1,1,1.5,1.3,2,0.8,1.1,1.3,0.9,1.2,1,0.6,1.2,1,3.3,1,1.4,0.9,1.4,0.9,1.5,1,1,0.9,1.2,1,2,2.2,1.5,2.1,2.4,2.6],
	    'Mutation Count': [228,129,86,2459,240,320,151,309,156,373,254,332,344,272,139,138,260,203,431,163,264,180,73,161,333,191,332,353,103,199,92,237,293,203,160,286,312,177,227,82,541,210,316,666,89,144,155,137,142,182,204,311,197,348,251,167,186,1091,166,455,294,380,215,445,128,545,155,161,189,199,141,3,247,332,179,312,379,239,245,287,660,292,160,120,252,179,288,169,129,242,543,133,259,204,148,266,133,250,535,275,148,189,164,283,2,175,288,717,170,181,325,253,172,181,92,125,259,275,1038,107,171,158,179,94,75,216,142,164,357,66,275,239,275,138,237,262,251,300,193,254,190,220,262,177,435,214,278,381,349,84,319,282,216,184,213,488,159,116,105,129,283,210,1030,210,460,174,292,281,140,263,138,306,192,251,100,49,386,699],
	    'Mutation Status': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','','','','','','','','YES','YES','NO','YES','YES','NO','','','','YES','NO','NO','NO','NO','NO','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','','','','NO','NO','NO','NO','YES','NO','NO','NO','NO','NO','','','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','',''],
	    'Oncotree Code': ['LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC','LUSC'],
	    'Overall Survival (Months)': [12.19,4.47,75.69,123.09,4.8,117.48,11.33,23.52,92.08,31.96,36.04,92.35,86.89,6.18,2.79,154.2,49.9,27.17,119.45,46.85,60.84,34.76,15.57,9.33,31.6,41.66,33.9,10.81,7.33,4.3,1.74,14.09,27,20.47,35.05,24.11,38.14,34.72,13.11,19.28,11.76,60.61,64.88,63.5,14.62,44.22,0.79,71.29,11.73,30.09,62.81,56.27,16.62,128.91,133.64,97.86,79.47,173.69,103.45,151.15,14.06,19.74,2.63,61.56,32.85,65.18,81.18,74.61,9.07,60.25,50.62,16.92,44.71,39.29,4.96,4.01,0.43,7.82,6.8,0.39,3.38,126.48,111.27,68.53,55.16,82.46,102.1,1.71,24.31,1.94,60.48,68.33,71.12,55.52,17.87,22.47,39.09,33.08,18.36,22.96,24.87,21.45,5.45,13.3,12.16,13.01,9.82,4.43,10.64,13.9,0.39,0.39,29.93,28.94,12.42,18.23,21.88,'',10.22,21.91,80.39,49.44,66.49,41.39,9,56.87,35.32,42.61,3.19,32.29,29.83,35.87,23.55,26.81,11.76,'','',52.63,16.95,43.07,21.06,0.99,2,0.92,0.99,43.96,20.99,25.03,0.99,2,1.02,2,2,23,18.99,3.02,2,18.99,12.02,3.98,11.99,24.93,1.97,25.95,39.98,22.96,4.04,5.03,29.99,10.05,54.04,4.01,49.01,12.06,12.32,9.66,41.36,40.21],
	    'Overall Survival Status': ['DECEASED','DECEASED','DECEASED','LIVING','DECEASED','LIVING','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','LIVING','LIVING','DECEASED','DECEASED','LIVING','LIVING','DECEASED','LIVING','DECEASED','LIVING','DECEASED','DECEASED','DECEASED','DECEASED','LIVING','LIVING','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','LIVING','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','LIVING','DECEASED','LIVING','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','DECEASED','LIVING','LIVING','DECEASED','LIVING','LIVING','DECEASED','LIVING','LIVING','DECEASED','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','DECEASED','DECEASED','LIVING','LIVING','DECEASED','DECEASED','DECEASED','DECEASED','LIVING','LIVING','LIVING','DECEASED','DECEASED','DECEASED','LIVING','DECEASED','LIVING','LIVING','LIVING','DECEASED','LIVING','LIVING','LIVING','DECEASED','LIVING','LIVING','LIVING','DECEASED','DECEASED','LIVING','DECEASED','LIVING','LIVING','LIVING','DECEASED','DECEASED','DECEASED','LIVING','LIVING','LIVING','LIVING','DECEASED','LIVING','DECEASED','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','DECEASED','DECEASED','DECEASED','LIVING','DECEASED','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','DECEASED','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','LIVING','DECEASED','LIVING','LIVING','DECEASED','LIVING','DECEASED','LIVING','LIVING','LIVING','LIVING','LIVING','DECEASED','DECEASED','LIVING','DECEASED','LIVING','LIVING','LIVING','LIVING','LIVING','DECEASED','LIVING','LIVING'],
	    'Other Patient ID': ['95b83006-02c9-4c4d-bf84-a45115f7d86d','4e1ad82e-23c8-44bb-b74e-a3d0b1126b96','d4bc755a-2585-4529-ae36-7e1d88bdecfe','b09e872a-e837-49ec-8a27-84dcdcabf347','99599b60-4f5c-456b-8755-371b1aa7074e','f1a1bbf9-4751-4fb4-8a2b-19f8d4ba57bd','c8802713-b814-4b55-993f-3ffebf8c3ab8','af1d9d69-0a45-4ad3-9873-57fbe4a4b895','9a874b64-d0d6-416e-97bc-e9071ed0b16b','6eb61cab-8e83-4c18-a59a-ae0985ec9d2e','e28cbc9a-aa60-4bfb-8d89-8c33ee97f560','03fa3310-406d-4c12-a409-136fc47d996d','34d5d8b7-9737-43fa-86fe-7c2885c787cf','a33f0741-2161-4818-89f2-ec8ccae57949','4c806d29-1674-4542-9f30-5c9a0fc184c4','19f0cb8c-2e57-4310-967f-a9890f1605db','2c89b366-c394-4067-bbb0-f24f5920ecaa','628b1bc3-825b-4d0e-a4cd-57eeaf98e798','28f899c5-ea17-4df6-83e6-e744e04d0ea1','d87e30a3-1b5a-41cf-bafe-27914a01c8d9','220be009-8f1e-4a77-ab04-3220b5f87ea6','f516991c-5139-4b3e-b605-5a3d90688209','0ab8d063-62b4-4d47-82aa-e3351a60029d','2afa2fd8-e4d9-4e7b-b387-7e2451764d5d','e21964b8-47c7-4a5f-bfa7-7206222883d2','4add88b7-169a-448f-b063-c7e6402628f1','9d841e6a-b292-45be-8a7a-50d54606592b','d11c4976-ba19-4616-be79-d1e321c26d07','df7c9193-0bd2-4fd9-8ae1-1f9d341e92c5','96006f5e-5922-4e55-afa5-5e43773d72f2','18058bfb-a008-410f-8e04-7c2b45a856b7','6ab57144-16ea-4844-b737-e726787d23b9','037c57d1-b4a5-45dc-bda4-0550461d321b','211bb982-16f4-4f07-b24f-e633703f24c4','8fbe1f9e-f2a6-4550-aabf-b06607b821f0','aa53c701-4b65-4c26-a6f0-02a4498717a8','e5e4ead7-f2d8-4d72-aedc-393ee002a081','5f99343b-e8ea-4b41-b36d-cd5c8fd918d0','0c80ab20-7e33-4f1d-b136-07782b68e98b','2e7cd434-0440-47a2-bc59-8805b8324ec4','2c8877f9-ee7f-4216-97ad-d2939a13daa4','bece6b8e-5d6c-4dd6-85a3-9b3a9c670aa7','bd3bf142-7c14-4538-8a76-3c6e140fa01a','eea9575a-c842-4a95-9e47-3a3b12533f25','9101d953-1eb6-4808-aa44-a7b04e0ef412','bd15f523-45c4-4d7c-a3cc-4fb56abb0e54','4daf4a91-bc36-40c8-8fca-ea61b6706775','396932ab-c4b3-4526-9201-9222f5f062a5','dd5e3a1e-2adf-4eee-ac6b-c6efad97724a','305f72a8-069b-410b-bbe4-4ecb761c748d','df6a7005-92ed-4701-bd59-7b5f09715f9d','4cdeafe4-a6db-498f-a019-6e3a9dc35b2f','422a46b2-a67c-4a7e-923f-9b651ced96f8','6ee6ca0a-8702-480d-b2d1-9224e7dd9211','b4ff0f49-b787-48ec-91cc-ee26786ff1bf','c70a5975-c37b-47cc-9113-427a754807d8','44b1d457-3a50-404e-b54c-ca619262bc2f','fad202a4-11f2-467c-8311-aca60cecf16b','0d3c11b5-856e-4d41-b94a-b2e32f9c5792','f728a4d9-53d4-43a5-abc1-4016d388efa8','376dfd27-68e8-4a1a-9c4f-5064279b2a9e','afedf3fb-fc77-45a7-bdcd-2c78706a0f8a','7d3e77cc-9603-4722-8e39-1912b678871b','da61857a-b00e-4a19-ab02-8fbb2ee56bea','44c56277-37e5-47a9-b476-d8475ef477ca','f8733921-44bc-4c62-8b2d-33a9b82ef665','d04bf59d-3429-4641-9f9e-81d8cde15295','349e01b0-0c88-4321-839e-0a84edf11a73','31798d61-fb34-49dc-a20e-091c1a20eb6a','4631400b-1c96-4074-b779-7cbc77a49d99','e7d1b042-5b1c-4c29-b501-a5ef4810ecd2','6013a4fd-89cf-48a7-a465-c7b644afb4a5','18f18672-2a23-4e26-987b-38c454ff46c7','7abb4883-60b7-4882-b946-1a4665889257','ea34663c-f40e-4a3e-9ac0-65d5e9eef12b','8a235eb8-d67d-49fe-a473-1777eb7e7c60','fd881d58-c9c7-479b-b76b-1f3c2ab1b015','34193c52-837c-4cf8-850a-00ae55be28ec','1f6b2aca-7357-40d1-ba7a-99227d9900a2','5d3d3918-7da8-4147-90a3-dc015be1dfbe','6eae9623-b4f2-440c-8283-46c7016f953a','17919a6e-3106-49fa-9fea-8f06c595d617','14a4a93a-e24d-46f2-bee3-18bd792ef95a','e7020168-1afe-4361-800a-8979aafca12a','9eb9e06f-bdfd-47f0-b5be-472a1e276f2c','3a74420c-9ee6-4131-8aff-7265b047e6a8','dd7eda40-9aae-46b2-914e-788b76b43087','d9b6a10e-ab02-47d9-a6c2-bb0c80238d29','2f39e89c-a8f7-4df8-a0f5-ef9990c2133c','865a1b5a-6d94-4e06-b5a0-ac11e2221679','9f20b4bc-ee09-42ef-9392-68054a7a2cfe','ba10f90b-66e1-44cd-b6c0-08c448a9d688','3ebd3dcd-b4f1-449c-8b2f-86f90643676b','02eb85cc-a597-4eaa-9614-c94c0f035929','ffb83f21-06d9-4e52-a2d0-e85c13f4037f','37f5457e-21d9-4b79-95d5-ded6f2e43087','ce8612ab-3149-4a6a-b424-29c0c21c9b8b','9293e197-e38a-4e19-a7d0-1b45d1ad48bd','f5ad138c-1714-41e9-9c2d-c88050bec407','a8764401-d2a5-45dd-941d-2ffb2e7a4664','40e928e8-bedd-4b86-81bc-b581bfc897d4','381edbe7-f391-4154-b16e-ac91d550582e','b0818bee-c32c-405c-ba09-956091fbe09b','ec10dc91-2743-4e0c-af77-2f0105bf6a9e','ec260f86-7186-4bf2-9de9-320b4ca155a4','6b0b6fc0-d808-49c3-8f2a-e122bc3142f5','a402e786-132c-4095-bb75-22be04b5d835','d38dbe20-bd5a-45d5-8db3-d5f777b454b6','6020ec67-8f3b-409f-a0ed-2af849b4d76f','e8bc2eea-dc6e-420b-abe8-e36989e75df8','2f586b38-5be6-4ffa-8a0f-c870fdf3dad3','8479ec58-f5e7-4d9d-a382-2688ed93ca8e','3f43c83e-c2a2-4224-9da0-0757b9c7d4ca','3edf933a-be1a-46e8-bfb0-acdff30e64a0','b3a6edcd-6592-44fb-9ec1-037138bfbdaf','6467bc69-4e89-49f6-8912-fa86d513cf51','af02050f-ebc4-4171-b63b-3b3faa279f2b','d566fa32-382b-499c-820a-c2bbb22501fb','fd9ee494-65fe-4de4-adff-7952a059b17f','4d687740-96ca-4d78-8c78-1a2024ce6b6c','2ca47049-bc12-4992-b9cf-1c01dda639be','4718e180-c166-4826-b5a1-945f4a56eb16','b28e3be1-9843-4204-b999-b3e2a909c7bd','1f11de87-a5fe-49fd-80c1-e279b2bc69de','f355cd59-eaa9-46c7-ab07-b90a7afc875c','e58e8850-154f-4695-bee0-005c76410327','f3e67161-1532-4b50-a9b5-0da80410c4d7','585e6487-b0a3-4828-8a06-46bee01dff74','337e77b3-7f58-4f92-96a4-c764b1ebfa56','bcd78677-98d5-4403-8313-e1fbd76e8ef7','6fd72426-f6c8-47ca-a500-d5d3600b9b15','0d6a7cdf-daf5-4181-864f-430952e6fdb3','a3e1ac67-a1f2-44fb-8343-a7e8239fc24a','f03aacb8-5565-425f-a8d5-be1056f882e0','3d1f4059-2220-45b4-a4d2-b14f76cec96a','dce87821-a5cd-4415-ab0c-ac5ed2459929','68107725-a883-4b33-a366-d9b4adb18028','e171b02c-da2f-4452-a100-9ed989e73276','5860a9f1-30e8-4833-99bb-a6863e78914b','12bd70f5-2542-48cb-b296-ae9241b38f7f','a355bad1-bb49-4de5-892b-691ed0022d91','1ee543d5-b8c0-4f79-8373-6bb6319f2ee2','637e900e-64ab-4bff-82b9-3ba6b5632f35','df7cfd84-a36a-44a0-b39f-a9ea1e0fd500','43abe847-4ba7-466e-8283-5d7b80b999a7','a02932f3-5606-42a5-aee4-e5b9f5aa1aaa','dca4c540-897f-435b-9ee2-8f5b2e8734c6','e6b72c24-1607-43b9-8b8a-7bf83eea5895','1e3eb77c-d85b-437e-8b8c-12e5bd0e93dc','32c86f17-34c3-406b-85c5-4f5965619247','b913d254-8307-4b8a-8313-d978e32bb38f','174cdc32-e94a-4829-b6b7-df560de55be2','d3f8c35d-5197-43fa-a243-2baf9c44cf74','f1b357e4-d67a-42c9-b0b7-12f69fa3da58','1535c8ab-100d-4886-8598-12a94483d010','791f1b21-695e-4db1-b41d-80590c09d257','23e65963-d9f3-4cec-953c-4dd06f7d8668','aabc43bb-485a-49bc-b48a-d4e4ecd46d33','7ccce724-d401-487d-b444-6edbbd032303','d49b0369-905c-4608-96a9-cc854980fc4c','90b02be3-5496-40a2-8c6e-460d2898aadb','d5e14ef5-1b78-4498-a2e2-77070c83eb7f','ce94e544-8887-479f-83cd-27b1c740e4c2','a9d7adec-3849-40e2-a2a2-f43443ec43bb','e1a2cccc-f0ce-4d23-bd58-e098009ebdac','e487c72f-2cb4-4a88-bd69-cd006d5b4c1a','87ac0ad4-8c9d-409e-9a86-1d201d01769d','a8e79b70-76c4-4d4f-8e1d-37daebf2a921','40dc2edc-4bde-441d-8fc5-8ce1bd42f267','9af6ed4e-8cdc-4f49-84e9-ba1053b5b3ca','8d20352a-6180-40d0-adc0-c87fef854dfa','da93a143-5799-4856-a5f4-3ff3b9284311','4fbf2497-0774-4599-8c90-1961612b8e3a','f7287eb4-c77d-4c67-a768-87fcccd668f5','15b0bfd4-2068-4ac8-aaa8-a2a6797253d8','2e007464-f3f4-4eb2-bab8-91b8272c96d1','870fb708-7631-4578-a470-3c7bd5228e5a','46f35964-bd43-47e6-83fe-40da33828c94'],
	    'Other Sample ID': ['7a55a700-a706-443d-8bad-e70483c464f2','49963d3b-a50e-4086-bc94-fe2042f9fcae','eeffadf9-2ccb-4937-ae1e-1d50aba41c4d','f27ece99-8357-4648-9d1d-5e4127968c5f','cdffec20-96a8-4b64-9959-f701504ad186','f85af662-1de5-42a8-a22d-721a9ad00ce6','5cdca8c3-1f5d-461c-b09a-6e34a0af1cbb','a3613a4d-7138-4878-9a26-2b377512b70e','23327c39-2e21-4604-9eba-15884ae356fc','da725c46-31b4-4498-a45e-dedebba6e96e','cae87e34-a5df-4441-bee6-3d7011d3fde6','a3a422fe-6369-4a40-bb43-a9adfcf90c42','5f4626e5-7427-4027-8bbb-504772710e02','2be9b353-e4bb-4356-b9a1-080be2ebc80d','05c153b3-1b3d-4332-a2f3-2f19977f2ecf','1bac4ff6-e35b-40f6-bbe4-705ab672d102','a6ca2f89-d997-496d-9e2f-996abda1d896','86d94dd2-72f8-4969-9989-67dd684fa6a4','6ec09b78-7ff6-491d-adef-29535869d33a','7a6f5405-a196-460c-bbe2-6c75ecaf0da0','22be9844-4d9e-4372-a46a-b5c64480e5aa','17cc65cf-816c-4656-b2bf-e9889fe4c5e7','efacac80-9428-4482-9aea-6b57fd172d49','ea658763-5482-44b6-a1d1-d9bb66f40092','9abf3a20-b34d-429b-9c13-0468dfc20700','5b9af04f-0616-42f0-a70d-eba38a22b531','e7f4b521-29a2-4f17-8819-f02507db90f2','261a8506-2f74-4beb-97ec-1818fa824db6','3ad22921-3e1a-488e-83df-5ae8d24dbd06','05466eb7-be72-4759-94fe-d9b4940270ca','ad8d4ef5-5c51-4342-983d-ef912fda745a','eb9cc301-c323-47e4-97bf-b2605b599d3e','ddb395e5-4b12-4610-9755-01e444b35c2e','b2a531d4-d4dd-4d33-9bc2-5f8ec2351a78','28375fb3-f552-477a-b7d1-16a85275a15d','d746415e-2761-464f-b2ae-90eafb0eabe3','5de486c6-1569-4f07-97ce-dbbc7889b402','7f411683-9d4e-4470-9987-eeccbdf090bb','ceb7629b-71ae-458a-b6a2-5e34cafcc41a','4bdd3cb5-af16-4ba6-b54f-7fc922952eb8','4e11ad69-d473-4433-822f-276dd3b5ca63','9babf36a-fe87-4973-a220-97c5c26b76a2','aad71c1a-585c-45c2-925c-99ceace2e6f9','97e9d32a-d9f8-43d3-a459-9cd2bc8cd781','85477745-5f19-431d-b592-a0942f13b4fe','f9d568b1-6951-4eaf-8867-4c86bdaeaa04','9fc48d9d-cfb3-4c04-b918-878c05c57a35','490b0c15-ec7e-44ba-8522-08b467c34876','f1f5990d-91b0-4147-89f1-ffe7d2eca3e3','abc3a25f-d5bc-469e-8c3e-8e6f5b129e8f','a13b5c1e-dce0-4626-8a90-6611fa51f286','7be5134a-24c9-43cb-a811-3c8aa89afe53','8a0b8a54-d4f7-4911-a692-6731d089eba2','8a33687a-d3f7-4a05-bd24-22b1a25bf9cb','be768285-0d6d-4149-bd9d-8f95519f817a','d12fe64f-64da-4922-ab3d-c4d1be92e3d5','0d7c693e-b6f6-4ee0-8f13-d1ce1033bfae','1ab08501-81db-434d-8f1a-672a5054661c','43a62dbd-5e29-4ba5-a91e-5033f01f118f','6bde2659-f01a-4c1c-99c2-edbcad232af3','a41992a4-d0f9-4d5b-8d05-0e3025d9c8ff','901e3068-7ed3-417f-bad4-1266d9e63b03','c07c8c94-150b-40a2-8830-5be34dd99554','b0c827c6-b7ef-420b-9a6f-7e8b79c320cc','6d03be57-c36d-4218-b2e8-a2864f23a554','a2a8125a-aadb-4e8f-9e80-841b65c647ee','2ffbc6b0-c56b-474f-add4-747caa6de728','8620b5a0-e9ed-427b-9675-ee8ee798686e','3393f98c-30f2-48e7-acee-aaac8efe9ee4','4e006ec7-f125-4798-addc-a5d63d373044','49395d22-cd07-4ab7-bdf3-cfa56687ba43','f9bda334-2bd7-49e8-b054-858cc335f3c5','f7ffbccc-153e-47a7-8545-d2ff00d19a80','0109063d-7bc6-4973-8c67-98e48a2a2e4e','21095913-9f26-4968-af07-442e2d73ead5','7fa7fa60-b786-4b9b-9647-649ae411c6e9','c4a87ac6-5925-4c2b-aa66-22550d4c1871','e47265aa-38bc-4122-ad50-44dda65c6bf3','5294476f-a200-453e-9d11-9c50f3c3fa5d','bc1b8610-9e9d-4fbf-9698-82ceca1e935f','4850539f-43c5-4170-8ecd-43d449e12ac3','d3d6d019-fa30-479d-9298-20f7337827b2','e47e21b7-550b-4268-8e1a-ab176b0abc1d','c4d764a5-b669-4e88-a989-f7b00384683a','c77cd407-545a-47b9-a0aa-ec27095f934b','b8ecc173-de26-49b0-a2bb-fa3810a50fb0','a6e8c3e6-28a4-4b3b-9785-d6f0773fa1e0','6c166089-b182-4260-8500-99505210f8cb','32bf8629-ef58-4944-ae9e-2dc4682bfb86','b365494a-52f7-4925-9bdb-1862a54f5dc7','87d44aca-1b6c-40c1-ba75-e27483aafeed','5b6bf6e9-12ca-4541-8e67-351740f7cd43','ed8042d0-27f6-44bd-8e86-a3a41aa6dc36','2b482b5d-5672-4035-b2dd-47311ed936b9','f45559d0-fa59-42ba-92f8-a4c7a1ca403d','0279f6b8-a605-4f5f-b4f2-c0506cda07b9','d8f165af-1df5-4876-abf8-7596e52a3bc3','bbc07c89-5540-4217-aa56-3608539983c2','223afbf5-62ee-4ce2-9393-b699f558236a','5489d637-e679-4614-9677-f87fee997e3d','12452c88-c886-4449-84cd-04d44b29d704','0e225b33-d4aa-4dc9-9a51-a642b4a13c4e','12b448e3-2d58-4e68-92e1-dd484742cd99','b89028a9-39e2-4f7e-9746-911414712921','ca0505aa-b12a-4bca-ba04-317cd551bd2b','c4789d6b-15be-43b5-8b21-e57048a5d42a','fedc687f-a217-4e70-a4fd-9c73b3becd75','ee851ee4-0c49-4839-8c92-9a61c5dc609e','2896f7fb-d6cb-4da3-ab40-52d1e739b8d9','43ddcc1b-208a-4857-ad5c-4db159871bc8','0e2d6eec-a531-4e75-8067-2e86857d69cc','a18c0edd-ca60-4bcc-a5b5-5c1db1d70211','5e39b554-238a-4e41-934d-85741069f1c0','4083de2f-3ff5-487b-a27b-783d51c4f853','d2aaf939-ecde-499c-b301-134d1a9dcc5a','810446e8-1a50-4793-a2c4-14a5d41167b8','6b5140f1-7e45-4285-a686-d5dd736e54b3','2665b625-a5ef-4c1a-aa93-c0413bad57bf','a908ce38-12e6-4ec6-baab-9d79221ab6eb','b02098da-6576-430e-a317-90b22794f164','dc117e4d-6f37-4f90-ad32-29d2d051d506','a30c673c-9a0b-462a-824d-8b4db17d4498','aecf427e-75cf-419a-95d5-47563c9d3e0a','8a3a376a-a4db-4d4f-85ce-a894a2aa60bb','918bd17a-9ed5-4c0b-8ef6-7fa4bf53579e','88a9b60f-89dd-4c2b-b13b-5ef5e10b94ab','5848ee1c-191f-4434-b7c6-598058aa0dd8','dd32ef9a-246b-47c9-a0e3-60a110e9047c','7866bbce-6e55-459f-aec9-00d8b8dbfb2e','271e4445-d542-451b-b298-633574bc3a1a','060717ad-f034-46fa-8e9b-94a9422e4666','b8b3957d-ba76-47b3-99d2-29f49eb38893','048e7eb0-57a4-4eed-a999-4e46d9fef885','5adad639-10dc-4427-8fff-b064bd3d6c72','91a60807-2d0f-474e-b02f-18fea788b319','9a982d6f-1006-486a-8479-3f011e8a6e49','b37cf4c9-e67c-4653-af68-c4b4c57c8412','c3a51666-bb41-4d90-8cbb-dd2f13e5c8f5','2a343bff-6562-48b8-b84f-402305b5ef3f','c229a069-e9e1-43cf-9231-7ef5a1f18e52','a75dde6a-c75d-42c3-a456-dff0f8d3c960','75e00dd8-0ad9-4447-9407-0ab6ac0a7173','308abb87-046a-42a1-983d-984ee83a8d87','1f963f26-4ee8-42cb-bdce-1f375829d3cb','d80486cd-f054-4527-a886-cf9446381b9f','7c727433-a8a8-44eb-ac11-dcb5ebd9250c','f4f08354-33f0-4a59-8510-b4406aeab46e','33918a59-c2b0-435e-ba63-8a39da191712','a7d715ab-8ecd-4a25-9035-97aeba7a24c0','0748861e-1332-4a53-b714-aaaa467951e6','09215e83-edac-472d-b849-9225c532358c','86cb7ccd-7601-4828-93f0-21429d404688','778481c5-9fd9-4948-9f1f-229b9569faf1','1d014bf1-95ae-42e3-ae39-97ff4841d8ca','bccca633-bec7-4a55-9bcd-d4a0e598ada1','a29977a3-cedd-4861-a566-d4e942002ade','13dfbc40-36bc-4662-9d55-74485c3d3088','84546dd9-6fe9-4526-9f7f-d0937f7b2ee3','efb52770-85f3-4854-b335-a2c750ec77d5','c7b943ab-3ca3-43d3-9bfc-4c6785964b28','a375634e-d23e-4b80-b336-39f408730155','9d57624f-2b29-4608-85c0-28dab5c473eb','de076495-e2ae-4e2a-a38c-1ec45e552131','290bbfa2-1028-46a3-b8a4-ca7848590bbf','a26f9de7-3ee7-4ed6-928a-ce9dc5734267','610a33d9-5e0e-48af-ac34-d75ba48d917f','a633a5ca-c207-45be-8903-93527de31c22','179b480b-bbbf-4fa5-9ac5-71e7e0b01f99','c5032c5f-4386-4aae-b986-480e4c7855db','daa128eb-bf5a-4c2c-a7dc-e6e06b6aeb85','69ef0674-f493-4dfe-84ea-61f28d11ba69','9dc330bf-acbd-4419-b533-35cf59acec71','2aaab31d-2622-4b76-8fa0-0a433ad7533e','e9838cd6-7761-4ac3-9cd5-534808d320a8','9e642315-76c0-4c15-8cef-2805b1b73dd8','4da87998-a3a3-4f8d-bdd0-06c340613113','2fe8863d-85e3-454e-bd2e-01d5a5cd082b','57b69a21-a1cd-48cd-93f7-aa196441c345'],
	    'Pathology Report File Name': ['TCGA-18-3406.a0eef850-7543-4f82-8e46-3d81e203412d.pdf','TCGA-18-3407.c9b161d4-e3e2-43a9-8997-195db2fcc1d7.pdf','TCGA-18-3408.ef586d16-0c67-42db-9d31-86df9476d49d.pdf','TCGA-18-3409.978339c6-aea3-4ac1-87db-40388a3adf39.pdf','TCGA-18-3410.956030d1-c74c-4bb6-93d9-04eb5c786905.pdf','TCGA-18-3411.03efa03c-f8f9-43c3-9244-265bc02cbb5c.pdf','TCGA-18-3412.cae58929-ecc1-4c4a-8df6-cf48a32785ee.pdf','TCGA-18-3414.f0bd5a6e-4ebf-4859-b139-80fbb3a54daf.pdf','TCGA-18-3415.a37738c0-91cf-4e7e-b16c-3737a61bea72.pdf','TCGA-18-3416.d313ac3e-6ce5-411c-b014-8b88c7b7198b.pdf','TCGA-18-3417.71b38c75-44cf-4f27-90c2-04caee0d55a6.pdf','TCGA-18-3419.be697b2e-96c7-401c-935b-5046a939f6af.pdf','TCGA-18-3421.7640a498-7b8b-4e83-959d-c87e6753e12c.pdf','TCGA-18-4083.17a6525d-91d1-4cf5-b718-ea4c5e133a64.pdf','TCGA-18-4086.f83c1343-f2dc-4602-a34c-3a259edfb343.pdf','TCGA-18-4721.107fcb94-0216-4e11-90e0-31f2bdc044fb.pdf','TCGA-18-5592.fe921521-1681-4f88-bcda-b216cea7981a.pdf','TCGA-18-5595.3ca67814-08d3-4146-985d-b6608b3a7fe6.pdf','TCGA-21-1070.32e48ff2-1c64-46c0-a1ff-eb77f4ad21b5.pdf','TCGA-21-1071.7e0fc9aa-af71-4605-a396-3edf6b1870f4.pdf','TCGA-21-1076.990cc93f-4af3-4af5-8cd7-0bb81133e1be.pdf','TCGA-21-1077.9313f5a4-32ef-4a20-890f-d437c24e2f8a.pdf','TCGA-21-1078.8366df03-5b00-4476-9fd2-3bf80d53dc6e.pdf','TCGA-21-1081.b7eb9e52-9c41-4398-9cfb-7832a6183258.pdf','TCGA-21-5782.644e67c4-61cd-40f8-b2cb-287b8a868eb4.pdf','TCGA-21-5784.5d154faf-bb6e-4237-80cf-9d02e2127adb.pdf','TCGA-21-5786.7c63d47f-0a73-415c-b4e5-d5c70886709e.pdf','TCGA-21-5787.fe205444-57af-48ab-8e50-ea8c4a42eb07.pdf','TCGA-22-0944.A4E962A1-69D2-4D46-977B-DCDE3E696772.pdf','TCGA-22-1002.D486319E-ED8A-4F0A-BAEC-219B56AAF33E.pdf','TCGA-22-1011.5B20E854-19A2-422A-8ED2-9339845AB6CE.pdf','TCGA-22-1012.442C89DF-A3F3-44DD-960E-F4B26281D9AE.pdf','TCGA-22-1016.DDA12CCE-0C66-4E29-9B36-BC4E24CFEC7B.pdf','TCGA-22-4591.97a5b9f1-ac4b-4744-abd9-03ccf04d1892.pdf','TCGA-22-4593.d20d26e3-da2c-4456-894d-6f08d62856ea.pdf','TCGA-22-4595.797ad94e-b3d2-44a4-8412-d8361a58bcd5.pdf','TCGA-22-4599.39e30903-77e8-47ed-9f00-64d4225f996d.pdf','TCGA-22-4601.1de412fd-daf8-4125-9eff-98e902a6c377.pdf','TCGA-22-4604.a66769a0-8ad7-4912-8eee-ec76d5aef626.pdf','TCGA-22-4607.261ab183-8f0c-4288-9bdb-53fd2754da31.pdf','TCGA-22-4613.bbb6127c-7368-415d-b984-65e21e23c03a.pdf','TCGA-22-5471.139e042e-6971-4840-97b1-a54988346967.pdf','TCGA-22-5472.a882eb26-0b08-463e-9700-4396fce9e8fd.pdf','TCGA-22-5473.12973d4a-4c25-43dc-920b-d32407d45461.pdf','TCGA-22-5474.e0bf9b86-3d7e-4a37-9545-b74dd999e128.pdf','TCGA-22-5477.9dcdc788-4ebd-4376-ab97-b0602a684b90.pdf','TCGA-22-5478.912bf8ba-d6bb-4643-a5dd-3449c86ceec3.pdf','TCGA-22-5480.62c5d0aa-1dbd-456a-b16f-cb233be02a88.pdf','TCGA-22-5482.b98aff53-a7e3-4bf9-b0b3-608f20940ac3.pdf','TCGA-22-5485.1a1abb9b-fe80-4a56-a276-94135fcedf4b.pdf','TCGA-22-5489.c83cbd0b-f2e0-42df-b68e-4ca20dfbce00.pdf','TCGA-22-5491.187ab883-e568-47db-a048-c39c4e9d0f29.pdf','TCGA-22-5492.d3432f86-2b6a-4c4b-81e5-827f8e5e918c.pdf','TCGA-33-4532.6ec80633-f41f-4a9d-abfe-b1c72f9f9d10.pdf','TCGA-33-4533.1791e931-cced-44e6-b530-21bba650cc8c.pdf','TCGA-33-4538.fcc5edd0-a274-49b7-83c8-ea8de74b9571.pdf','TCGA-33-4547.c2a8e692-5b5a-4a56-85e9-165e523a341c.pdf','TCGA-33-4566.cd1a9ba4-3ccf-4f10-b512-a76baa9d8d44.pdf','TCGA-33-4582.3c5a7297-2aad-496b-a552-c570cbee49b0.pdf','TCGA-33-4583.535235c0-4540-4638-b799-b7dfd082f5b8.pdf','TCGA-33-4586.7fbf4e5b-0ea6-4630-b35f-9af85414be08.pdf','TCGA-33-6737.d8a5d5d4-48a9-4b5a-bf57-ff32e7302d74.pdf','TCGA-34-2596.03af2ab8-fad5-49f6-94d7-8faaec71b63f.pdf','TCGA-34-2600.cfe4e419-1c0d-4a22-8a6a-968aaacbf935.pdf','TCGA-34-2608.18c043ab-df83-40bf-bafc-e33aed1ebdea.pdf','TCGA-34-5231.f86f0624-ede3-4128-80c7-35d5f1d65fc4.pdf','TCGA-34-5232.5b40bf87-de4d-4010-934f-b117f286562f.pdf','TCGA-34-5234.ecde2410-dc20-4f6d-9215-4bf5452d530c.pdf','TCGA-34-5236.8aadcd05-f598-4c12-87eb-6769bbf24b51.pdf','TCGA-34-5239.63c38b6b-14d2-4a12-bd73-957ac5207fee.pdf','TCGA-34-5240.060ba86b-73eb-4636-b706-d813bee1dd5c.pdf','TCGA-34-5241.9d9a1bba-2489-40b3-bad8-950bc742862d.pdf','TCGA-34-5927.581a7cc6-ceab-4ba3-baec-fd675fd87732.pdf','TCGA-34-5928.0880181a-6d0e-4b59-82b3-46a4f44f49b6.pdf','TCGA-34-5929.9fcfe85f-c7ed-4c1f-b21a-dae956cf8616.pdf','TCGA-37-3783.b3f279c3-f3a4-45a3-a711-b61873a3ca0a.pdf','TCGA-37-3789.9051358f-5b74-4f6c-b7f2-fc83e8f43306.pdf','TCGA-37-4133.7f0f7712-3db1-4f55-aa5d-724e58d5fb90.pdf','TCGA-37-4135.27fd3de4-a7da-4dc1-a135-637bcb4b7316.pdf','TCGA-37-4141.6cf75b07-d6a7-4b78-af73-e37c3a0581f8.pdf','TCGA-37-5819.8c9b5277-0cbf-4ba1-bda0-2c84bdadc9bd.pdf','TCGA-39-5016.7b50ffbc-010e-415b-8d85-b5639801e287.pdf','TCGA-39-5019.6cd83aca-c74c-49a4-8115-324e7c359cc9.pdf','TCGA-39-5021.84d7dc8e-29cd-4adc-93ea-cda77cf855b4.pdf','TCGA-39-5022.76f4d72a-526a-4b52-ba4d-067a81281984.pdf','TCGA-39-5024.ec84ade8-8988-4735-be04-97a52b8b8033.pdf','TCGA-39-5027.02693e05-2498-437a-9c26-7de09702c5ee.pdf','TCGA-39-5028.3e8d3fab-2418-4860-8119-a011528f2f06.pdf','TCGA-39-5029.61c4772e-24ff-4b25-94d2-2d8e64c4753a.pdf','TCGA-39-5030.ae1b3081-2545-4236-94b3-2d474b021363.pdf','TCGA-39-5031.45179ec8-08fe-4e6c-b5b3-e2ef7711b710.pdf','TCGA-39-5035.65d294e9-bdde-476e-8b45-dcee87915a69.pdf','TCGA-39-5036.b5f0955a-6175-4c71-ab34-639f8ac6d69a.pdf','TCGA-39-5037.7a100e58-1e99-48b4-9db1-0228aaf4bb71.pdf','TCGA-39-5039.10fd2687-7713-4435-9fcc-0cd6f9a430e1.pdf','TCGA-43-2578.ebd86e31-d68f-404b-ad7d-bdfbee556f3b.pdf','TCGA-43-3394.ab2c3289-581e-4bb2-a41f-418b057ef54b.pdf','TCGA-43-3920.93f563a8-23e6-4a60-a7ca-b51ab176f978.pdf','TCGA-43-5668.e41d4d1f-8334-42c6-8759-ad5366a11c93.pdf','TCGA-43-6143.0a88e8ad-53bb-4450-8131-f7ac7c79960a.pdf','TCGA-43-6647.c4fee0a5-5591-4466-8f65-d2e0bf29f990.pdf','TCGA-43-6770.cacfd9dd-aad5-48d8-9ecc-3db108bff2f8.pdf','TCGA-43-6771.09fbd8e1-9f86-47c1-abea-fd8e96366908.pdf','TCGA-46-3765.70f74440-e1da-4d78-9b0d-633342c3b4c3.pdf','TCGA-46-3766.188fd38f-839c-49ec-b8e6-41655c2a8479.pdf','TCGA-46-3767.8e91ee2e-da06-49fe-aa5e-4faca1240a25.pdf','TCGA-46-3768.83e30a4b-4df4-41d8-aa7c-7ae95be3b9fb.pdf','TCGA-46-3769.edd4e055-6670-43a8-ba91-0b4ac766abfd.pdf','TCGA-46-6025.1664466d-20af-4e97-b5e1-a013803f5e6a.pdf','TCGA-46-6026.ad6737a0-c741-40d5-9548-34b0fc17f542.pdf','TCGA-51-4079.8bc3980d-0a81-419b-8383-400c03be01f0.pdf','TCGA-51-4080.4142077f-f67b-46f9-9302-18ba26e15e27.pdf','TCGA-51-4081.0bf5aacf-58ab-45dd-b257-2d56045b9877.pdf','TCGA-56-1622.8b6c2041-dff4-4ce6-bbd1-683736983803.pdf','TCGA-56-5897.8efc19c8-ab28-4ff9-a2c6-4caefe60d0f2.pdf','TCGA-56-5898.04ca3e3e-ca70-4616-b7ba-8d48d88007bd.pdf','TCGA-56-6545.526beb21-7ffd-4d23-a870-47fcc5ec6b73.pdf','TCGA-56-6546.6bf4b1cb-22c2-45ec-b45f-9ccf5db582fe.pdf','TCGA-60-2698.fd7aab4d-f043-48e5-af10-789c56debc41.pdf','TCGA-60-2707.c3e54948-6849-4bac-b04b-3e1a196e866b.pdf','TCGA-60-2708.7f0ed176-146a-4ea2-8f39-36d402d74757.pdf','TCGA-60-2709.f1e99e51-52e3-4f5d-b483-3c1b1eadd977.pdf','TCGA-60-2710.da7da3b9-53af-4b12-be95-07dfc7be8458.pdf','TCGA-60-2711.efc8dedf-808c-4872-87a0-4249493f59b3.pdf','TCGA-60-2712.dc936761-8bc0-4f4d-ba51-d6c9c0009c3b.pdf','TCGA-60-2713.55688ea3-81a1-45bc-92c6-431f7a53a734.pdf','TCGA-60-2715.3378cd9a-00ea-42f9-9884-a72a54f1dd32.pdf','TCGA-60-2719.1843b1c7-9197-4595-ad5d-862e0f1ec3f8.pdf','TCGA-60-2720.02b1ae97-4962-46c8-9672-0597bdc85705.pdf','TCGA-60-2721.1447d27e-c268-4bc6-8919-b13878f8e862.pdf','TCGA-60-2722.1695c98e-f870-4a29-8987-acb46860b525.pdf','TCGA-60-2723.681ea3dd-7685-4dc2-aa6c-73de2ae4cc60.pdf','TCGA-60-2724.7a4d6104-67c3-4cbc-ab20-34babe747aba.pdf','TCGA-60-2725.86e5a074-bb1a-426e-987d-fc91ffd0ef21.pdf','TCGA-60-2726.ef1d119f-abc8-4adf-bc23-53141a65cfff.pdf','TCGA-63-5128.0883f7aa-5aa8-45d8-89b2-6279d2088c72.pdf','TCGA-63-5131.de9fb170-d3d9-4642-a3d3-60639889df2d.pdf','TCGA-63-6202.b8730165-2c60-469b-ae9a-f630fd97016a.pdf','TCGA-66-2727.97328404-08ac-4c35-b15c-79485d60c892.pdf','TCGA-66-2734.5cda5b60-06f5-411c-805f-0ec3ee89de67.pdf','TCGA-66-2742.07c5c025-c1cd-486e-b510-ebc19d3e53d0.pdf','TCGA-66-2744.75ad62a3-0cf4-45ef-a1cf-4c710a3368d3.pdf','TCGA-66-2754.d291f110-97b0-4ef7-b9ef-552e445e8378.pdf','TCGA-66-2755.bbae44d1-526f-4dad-9224-cf2dc56d0852.pdf','TCGA-66-2756.1ac41670-2aaf-428f-b8b5-d257951e6f5f.pdf','TCGA-66-2757.b44205a6-8c17-4b6b-bb91-ec1ad1be0b3f.pdf','TCGA-66-2758.c35772e8-176c-4572-80bd-e4ea7bd0684d.pdf','TCGA-66-2759.adc593c7-44fc-4059-a161-a80b267db72a.pdf','TCGA-66-2763.109e31cb-1414-4d8c-89da-c3b3eccf20a0.pdf','TCGA-66-2765.89c0d8ed-b798-4684-8c7f-1ef75968df1b.pdf','TCGA-66-2766.d210f986-d5a2-4490-87a4-e14564a6d0ff.pdf','TCGA-66-2767.bc27c9ee-26e1-4362-b03d-4e2c08ed6111.pdf','TCGA-66-2768.ebd0c8a9-a96a-4e09-8498-3476d1faf292.pdf','TCGA-66-2770.495898f2-833b-4db0-9fac-680970795f2e.pdf','TCGA-66-2771.e09c6c36-88a1-4f23-8611-241130866096.pdf','TCGA-66-2773.406db03f-3258-48b3-b0de-b7388d63a559.pdf','TCGA-66-2777.32548c06-21b0-4a9c-a8b4-ead02948d323.pdf','TCGA-66-2778.b4ddc4fa-5416-4a8b-8187-b328dbc0b946.pdf','TCGA-66-2780.56ff78fe-0830-483a-a8b9-72a62f80e101.pdf','TCGA-66-2781.4227efe2-597d-4d53-91f5-73c3fa32f6f5.pdf','TCGA-66-2782.bdae0797-b3e2-47fd-b95b-20d4510277b8.pdf','TCGA-66-2783.15cde679-e737-4f03-ae8b-ce80908fea17.pdf','TCGA-66-2785.92f38512-f7c8-462c-b7f4-018648ad4f56.pdf','TCGA-66-2786.1f8077d2-efa8-4e09-b4a2-e848c3723278.pdf','TCGA-66-2787.aa241183-bb71-4b0c-8d00-e10ec86145e1.pdf','TCGA-66-2788.8ec97dec-6e60-43c6-97c6-c164f28e3639.pdf','TCGA-66-2789.50601de1-9156-4793-9cdc-b140bb932cc0.pdf','TCGA-66-2791.402c71d9-26d5-4e94-82a6-6ae5ea39a391.pdf','TCGA-66-2792.c4e1fcb9-cf6d-434e-a38d-57ed9579b588.pdf','TCGA-66-2793.c2a1ad10-926c-4bab-9a34-467b3496a453.pdf','TCGA-66-2794.b0788a69-3dd0-42d6-8564-958a0108654b.pdf','TCGA-66-2795.7993de3e-afeb-4eaf-96fa-4efbb5167130.pdf','TCGA-66-2800.06d8266a-1fc8-4082-8a06-178dc57639c6.pdf','TCGA-70-6722.09915ca9-3880-4aa5-aab2-3762bf1d162c.pdf','TCGA-70-6723.09544798-db0a-443e-8f57-ca404db4f4ef.pdf','TCGA-85-6175.616d5519-7f8d-4eb0-b78a-6a90c84616ff.pdf','TCGA-85-6560.de1a9413-405b-4f15-ba7f-062ae63ea44b.pdf','TCGA-85-6561.66456b4b-5859-4045-91e1-5d528c1cee18.pdf'],
	    'Pathology report uuid': ['a0eef850-7543-4f82-8e46-3d81e203412d','c9b161d4-e3e2-43a9-8997-195db2fcc1d7','ef586d16-0c67-42db-9d31-86df9476d49d','978339c6-aea3-4ac1-87db-40388a3adf39','956030d1-c74c-4bb6-93d9-04eb5c786905','03efa03c-f8f9-43c3-9244-265bc02cbb5c','cae58929-ecc1-4c4a-8df6-cf48a32785ee','f0bd5a6e-4ebf-4859-b139-80fbb3a54daf','a37738c0-91cf-4e7e-b16c-3737a61bea72','d313ac3e-6ce5-411c-b014-8b88c7b7198b','71b38c75-44cf-4f27-90c2-04caee0d55a6','be697b2e-96c7-401c-935b-5046a939f6af','7640a498-7b8b-4e83-959d-c87e6753e12c','17a6525d-91d1-4cf5-b718-ea4c5e133a64','f83c1343-f2dc-4602-a34c-3a259edfb343','107fcb94-0216-4e11-90e0-31f2bdc044fb','fe921521-1681-4f88-bcda-b216cea7981a','3ca67814-08d3-4146-985d-b6608b3a7fe6','32e48ff2-1c64-46c0-a1ff-eb77f4ad21b5','7e0fc9aa-af71-4605-a396-3edf6b1870f4','990cc93f-4af3-4af5-8cd7-0bb81133e1be','9313f5a4-32ef-4a20-890f-d437c24e2f8a','8366df03-5b00-4476-9fd2-3bf80d53dc6e','b7eb9e52-9c41-4398-9cfb-7832a6183258','644e67c4-61cd-40f8-b2cb-287b8a868eb4','5d154faf-bb6e-4237-80cf-9d02e2127adb','7c63d47f-0a73-415c-b4e5-d5c70886709e','fe205444-57af-48ab-8e50-ea8c4a42eb07','A4E962A1-69D2-4D46-977B-DCDE3E696772','D486319E-ED8A-4F0A-BAEC-219B56AAF33E','5B20E854-19A2-422A-8ED2-9339845AB6CE','442C89DF-A3F3-44DD-960E-F4B26281D9AE','DDA12CCE-0C66-4E29-9B36-BC4E24CFEC7B','97a5b9f1-ac4b-4744-abd9-03ccf04d1892','d20d26e3-da2c-4456-894d-6f08d62856ea','797ad94e-b3d2-44a4-8412-d8361a58bcd5','39e30903-77e8-47ed-9f00-64d4225f996d','1de412fd-daf8-4125-9eff-98e902a6c377','a66769a0-8ad7-4912-8eee-ec76d5aef626','261ab183-8f0c-4288-9bdb-53fd2754da31','bbb6127c-7368-415d-b984-65e21e23c03a','139e042e-6971-4840-97b1-a54988346967','a882eb26-0b08-463e-9700-4396fce9e8fd','12973d4a-4c25-43dc-920b-d32407d45461','e0bf9b86-3d7e-4a37-9545-b74dd999e128','9dcdc788-4ebd-4376-ab97-b0602a684b90','912bf8ba-d6bb-4643-a5dd-3449c86ceec3','62c5d0aa-1dbd-456a-b16f-cb233be02a88','b98aff53-a7e3-4bf9-b0b3-608f20940ac3','1a1abb9b-fe80-4a56-a276-94135fcedf4b','c83cbd0b-f2e0-42df-b68e-4ca20dfbce00','187ab883-e568-47db-a048-c39c4e9d0f29','d3432f86-2b6a-4c4b-81e5-827f8e5e918c','6ec80633-f41f-4a9d-abfe-b1c72f9f9d10','1791e931-cced-44e6-b530-21bba650cc8c','fcc5edd0-a274-49b7-83c8-ea8de74b9571','c2a8e692-5b5a-4a56-85e9-165e523a341c','cd1a9ba4-3ccf-4f10-b512-a76baa9d8d44','3c5a7297-2aad-496b-a552-c570cbee49b0','535235c0-4540-4638-b799-b7dfd082f5b8','7fbf4e5b-0ea6-4630-b35f-9af85414be08','d8a5d5d4-48a9-4b5a-bf57-ff32e7302d74','03af2ab8-fad5-49f6-94d7-8faaec71b63f','cfe4e419-1c0d-4a22-8a6a-968aaacbf935','18c043ab-df83-40bf-bafc-e33aed1ebdea','f86f0624-ede3-4128-80c7-35d5f1d65fc4','5b40bf87-de4d-4010-934f-b117f286562f','ecde2410-dc20-4f6d-9215-4bf5452d530c','8aadcd05-f598-4c12-87eb-6769bbf24b51','63c38b6b-14d2-4a12-bd73-957ac5207fee','060ba86b-73eb-4636-b706-d813bee1dd5c','9d9a1bba-2489-40b3-bad8-950bc742862d','581a7cc6-ceab-4ba3-baec-fd675fd87732','0880181a-6d0e-4b59-82b3-46a4f44f49b6','9fcfe85f-c7ed-4c1f-b21a-dae956cf8616','b3f279c3-f3a4-45a3-a711-b61873a3ca0a','9051358f-5b74-4f6c-b7f2-fc83e8f43306','7f0f7712-3db1-4f55-aa5d-724e58d5fb90','27fd3de4-a7da-4dc1-a135-637bcb4b7316','6cf75b07-d6a7-4b78-af73-e37c3a0581f8','8c9b5277-0cbf-4ba1-bda0-2c84bdadc9bd','7b50ffbc-010e-415b-8d85-b5639801e287','6cd83aca-c74c-49a4-8115-324e7c359cc9','84d7dc8e-29cd-4adc-93ea-cda77cf855b4','76f4d72a-526a-4b52-ba4d-067a81281984','ec84ade8-8988-4735-be04-97a52b8b8033','02693e05-2498-437a-9c26-7de09702c5ee','3e8d3fab-2418-4860-8119-a011528f2f06','61c4772e-24ff-4b25-94d2-2d8e64c4753a','ae1b3081-2545-4236-94b3-2d474b021363','45179ec8-08fe-4e6c-b5b3-e2ef7711b710','65d294e9-bdde-476e-8b45-dcee87915a69','b5f0955a-6175-4c71-ab34-639f8ac6d69a','7a100e58-1e99-48b4-9db1-0228aaf4bb71','10fd2687-7713-4435-9fcc-0cd6f9a430e1','ebd86e31-d68f-404b-ad7d-bdfbee556f3b','ab2c3289-581e-4bb2-a41f-418b057ef54b','93f563a8-23e6-4a60-a7ca-b51ab176f978','e41d4d1f-8334-42c6-8759-ad5366a11c93','0a88e8ad-53bb-4450-8131-f7ac7c79960a','c4fee0a5-5591-4466-8f65-d2e0bf29f990','cacfd9dd-aad5-48d8-9ecc-3db108bff2f8','09fbd8e1-9f86-47c1-abea-fd8e96366908','70f74440-e1da-4d78-9b0d-633342c3b4c3','188fd38f-839c-49ec-b8e6-41655c2a8479','8e91ee2e-da06-49fe-aa5e-4faca1240a25','83e30a4b-4df4-41d8-aa7c-7ae95be3b9fb','edd4e055-6670-43a8-ba91-0b4ac766abfd','1664466d-20af-4e97-b5e1-a013803f5e6a','ad6737a0-c741-40d5-9548-34b0fc17f542','8bc3980d-0a81-419b-8383-400c03be01f0','4142077f-f67b-46f9-9302-18ba26e15e27','0bf5aacf-58ab-45dd-b257-2d56045b9877','8b6c2041-dff4-4ce6-bbd1-683736983803','8efc19c8-ab28-4ff9-a2c6-4caefe60d0f2','04ca3e3e-ca70-4616-b7ba-8d48d88007bd','526beb21-7ffd-4d23-a870-47fcc5ec6b73','6bf4b1cb-22c2-45ec-b45f-9ccf5db582fe','fd7aab4d-f043-48e5-af10-789c56debc41','c3e54948-6849-4bac-b04b-3e1a196e866b','7f0ed176-146a-4ea2-8f39-36d402d74757','f1e99e51-52e3-4f5d-b483-3c1b1eadd977','da7da3b9-53af-4b12-be95-07dfc7be8458','efc8dedf-808c-4872-87a0-4249493f59b3','dc936761-8bc0-4f4d-ba51-d6c9c0009c3b','55688ea3-81a1-45bc-92c6-431f7a53a734','3378cd9a-00ea-42f9-9884-a72a54f1dd32','1843b1c7-9197-4595-ad5d-862e0f1ec3f8','02b1ae97-4962-46c8-9672-0597bdc85705','1447d27e-c268-4bc6-8919-b13878f8e862','1695c98e-f870-4a29-8987-acb46860b525','681ea3dd-7685-4dc2-aa6c-73de2ae4cc60','7a4d6104-67c3-4cbc-ab20-34babe747aba','86e5a074-bb1a-426e-987d-fc91ffd0ef21','ef1d119f-abc8-4adf-bc23-53141a65cfff','0883f7aa-5aa8-45d8-89b2-6279d2088c72','de9fb170-d3d9-4642-a3d3-60639889df2d','b8730165-2c60-469b-ae9a-f630fd97016a','97328404-08ac-4c35-b15c-79485d60c892','5cda5b60-06f5-411c-805f-0ec3ee89de67','07c5c025-c1cd-486e-b510-ebc19d3e53d0','75ad62a3-0cf4-45ef-a1cf-4c710a3368d3','d291f110-97b0-4ef7-b9ef-552e445e8378','bbae44d1-526f-4dad-9224-cf2dc56d0852','1ac41670-2aaf-428f-b8b5-d257951e6f5f','b44205a6-8c17-4b6b-bb91-ec1ad1be0b3f','c35772e8-176c-4572-80bd-e4ea7bd0684d','adc593c7-44fc-4059-a161-a80b267db72a','109e31cb-1414-4d8c-89da-c3b3eccf20a0','89c0d8ed-b798-4684-8c7f-1ef75968df1b','d210f986-d5a2-4490-87a4-e14564a6d0ff','bc27c9ee-26e1-4362-b03d-4e2c08ed6111','ebd0c8a9-a96a-4e09-8498-3476d1faf292','495898f2-833b-4db0-9fac-680970795f2e','e09c6c36-88a1-4f23-8611-241130866096','406db03f-3258-48b3-b0de-b7388d63a559','32548c06-21b0-4a9c-a8b4-ead02948d323','b4ddc4fa-5416-4a8b-8187-b328dbc0b946','56ff78fe-0830-483a-a8b9-72a62f80e101','4227efe2-597d-4d53-91f5-73c3fa32f6f5','bdae0797-b3e2-47fd-b95b-20d4510277b8','15cde679-e737-4f03-ae8b-ce80908fea17','92f38512-f7c8-462c-b7f4-018648ad4f56','1f8077d2-efa8-4e09-b4a2-e848c3723278','aa241183-bb71-4b0c-8d00-e10ec86145e1','8ec97dec-6e60-43c6-97c6-c164f28e3639','50601de1-9156-4793-9cdc-b140bb932cc0','402c71d9-26d5-4e94-82a6-6ae5ea39a391','c4e1fcb9-cf6d-434e-a38d-57ed9579b588','c2a1ad10-926c-4bab-9a34-467b3496a453','b0788a69-3dd0-42d6-8564-958a0108654b','7993de3e-afeb-4eaf-96fa-4efbb5167130','06d8266a-1fc8-4082-8a06-178dc57639c6','09915ca9-3880-4aa5-aab2-3762bf1d162c','09544798-db0a-443e-8f57-ca404db4f4ef','616d5519-7f8d-4eb0-b78a-6a90c84616ff','de1a9413-405b-4f15-ba7f-062ae63ea44b','66456b4b-5859-4045-91e1-5d528c1cee18'],
	    'Performance Status Assessment Timepoint Category': ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','Other','','','Other','Other','','Pre-Adjuvant Therapy','','','','','','','','','Other','','','','','Pre-Adjuvant Therapy','Other','Other','Other','Other','Other','','','','','','','','','','','','','','','','','Post-Adjuvant Therapy','Other','','Post-Adjuvant Therapy','','','','','','','','','','','','','','','Preoperative','Other','','Pre-Adjuvant Therapy','Pre-Adjuvant Therapy','Preoperative','','','','','','','','Post-Adjuvant Therapy','Post-Adjuvant Therapy','','','','','','','','','','','','','','','','','Preoperative','','','','','','','Preoperative','','','','Preoperative','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''],
	    'Patient Primary Tumor Site': ['L-Upper','L-Upper','R-Lower','L-Upper','R-Lower','R-Upper','L-Lower','R-Lower','R-Upper','L-Upper','R-Upper','L-Lower','R-Lower','L-Lower','R-Lower','L-Lower','L-Upper','R-Lower','L-Upper','R-Upper','L-Lower','R-Upper','R-Lower','L-Lower','L-Lower','R-Upper','R-Upper','L-Upper','L-Upper','R-Middle','R-Upper','R-Lower','R-Upper','R-Lower','R-Lower','L-Lower','','R-Upper','L-Upper','R-Lower','L-Upper','L-Lower','R-Lower','','L-Upper','R-Lower','R-Lower','L-Upper','L-Upper','R-Upper','L-Upper','L-Lower','L-Upper','R-Lower','L-Upper','L-Upper','R-Upper','R-Upper','L-Lower','L-Lower','L-Lower','R-Upper','Bronchial','R-Lower','L-Upper','R-Upper','L-Upper','L-Upper','L-Upper','L-Upper','L-Upper','R-Lower','R-Lower','L-Lower','L-Upper','L-Upper','L-Upper','R-Lower','R-Lower','R-Upper','R-Upper','R-Lower','R-Upper','L-Upper','R-Upper','Bronchial','R-Lower','R-Upper','L-Lower','L-Lower','L-Upper','R-Lower','L-Upper','L-Lower','R-Upper','L-Upper','L-Lower','R-Upper','R-Upper','R-Lower','R-Lower','L-Upper','L-Upper','R-Upper','R-Lower','L-Lower','L-Upper','R-Upper','R-Lower','R-Lower','R-Upper','R-Upper','R-Upper','R-Lower','R-Upper','R-Upper','R-Upper','R-Upper','R-Lower','L-Upper','L-Lower','L-Upper','L-Upper','R-Lower','L-Upper','R-Lower','L-Upper','R-Upper','R-Lower','R-Upper','R-Upper','R-Middle','Bronchial','L-Upper','R-Middle','L-Upper','R-Lower','R-Upper','L-Lower','L-Lower','R-Upper','R-Lower','R-Upper','R-Upper','L-Upper','L-Upper','L-Upper','L-Lower','L-Upper','L-Lower','L-Upper','R-Lower','L-Lower','R-Lower','R-Upper','L-Lower','R-Middle','L-Lower','L-Upper','L-Upper','R-Upper','L-Lower','L-Upper','R-Upper','','L-Lower','L-Lower','R-Lower','L-Lower','R-Middle','L-Upper','L-Upper','R-Upper','R-Upper','R-Upper','L-Upper','R-Upper','R-Upper'],
	    'Tissue Prospective Collection Indicator': ['NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','','','','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','YES','YES','YES','YES','YES','YES','YES','NO','YES','YES','YES','YES','YES','YES','YES','NO','NO','NO','YES','NO','NO','YES','YES','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','NO','YES','YES','YES','YES','YES'],
	    'Pulmonary function test indicator': ['','','','NO','','','','','','','','','','','','','','','','','','','','','','YES','YES','','','','','','','','','','','','','','','','','','','','','','','','','','','YES','YES','YES','YES','YES','YES','YES','YES','','','','','','NO','NO','','NO','NO','','NO','NO','','YES','YES','YES','YES','YES','YES','YES','YES','','','YES','YES','','','','YES','YES','YES','YES','','YES','YES','YES','YES','YES','YES','YES','YES','','','','','','','','','','','','','NO','','YES','','','','','YES','','','','YES','','','','','','','','','','YES','YES','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','NO','NO','NO'],
	    'Race Category': ['WHITE','ASIAN','WHITE','WHITE','','','WHITE','ASIAN','','','','','WHITE','WHITE','','WHITE','','','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','','WHITE','WHITE','WHITE','WHITE','WHITE','','WHITE','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','ASIAN','','WHITE','WHITE','WHITE','WHITE','WHITE','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','BLACK OR AFRICAN AMERICAN','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','','WHITE','BLACK OR AFRICAN AMERICAN','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','WHITE','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','ASIAN','ASIAN','WHITE','WHITE','WHITE'],
	    'Surgical Margin Resection Status': ['R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R2','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','RX','R0','R0','R0','R0','','','R0','R0','R0','','','R0','','','','','','','','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','','RX','RX','RX','RX','R0','R0','R0','R0','R1','R0','R2','R0','R0','R0','R0','','R0','R0','','RX','RX','R0','R0','','R0','R0','R0','RX','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R0','R2','R0','R0','R0','R2','R0','R0','R0','R0','R0','R1','R0','R0','R0','R0','R0','RX','RX','R0','R0','R0'],
	    'Tissue Retrospective Collection Indicator': ['YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','','','','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','NO','NO','NO','NO','NO','NO','NO','YES','NO','NO','NO','NO','NO','NO','NO','YES','YES','YES','NO','YES','YES','NO','NO','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','YES','NO','NO','NO','NO','NO'],
	    'Number of Samples Per Patient': [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	    'Sample Type': ['Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary','Primary'],
	    'Sample type id': [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	    'Sex': ['Male','Male','Female','Male','Male','Female','Male','Male','Male','Male','Male','Male','Male','Male','Male','Male','Male','Male','Female','Male','Female','Male','Male','Male','Female','Female','Male','Male','Male','Male','Male','Female','Male','Male','Male','Male','Female','Female','Male','Male','Female','Male','Male','Male','Male','Male','Male','Female','Male','Female','Male','Male','Female','Male','Female','Male','Male','Male','Male','Male','Male','Male','Male','Female','Male','Male','Female','Female','Male','Male','Female','Male','Female','Female','Female','Male','Male','Male','Male','Female','Male','Male','Male','Male','Male','Female','Male','Male','Male','Female','Female','Female','Male','Male','Male','Female','Male','Male','Male','Male','Female','Female','Male','Female','Female','Male','Male','Male','Male','Male','Female','Male','Male','Male','Male','Male','Female','Male','Male','Male','Female','Male','Female','Female','Female','Male','Male','Female','Female','Male','Male','Female','Male','Male','Male','Male','Male','Male','Female','Female','Male','Male','Male','Male','Male','Female','Male','Male','Female','Male','Male','Male','Male','Male','Male','Male','Male','Female','Male','Male','Male','Male','Male','Female','Male','Male','Male','Male','Male','Male','Male','Male','Male','Male','Male','Female','Male','Male'],
	    'Shortest Dimension': [0.3,0.2,0.3,0.2,0.3,0.5,0.3,0.4,0.2,0.4,0.3,0.2,0.3,0.3,0.3,0.3,0.4,0.3,0.8,0.3,0.6,0.4,0.8,0.8,0.3,0.4,0.3,0.2,0.2,0.2,0.4,0.2,0.1,0.4,0.2,0.2,0.1,0.2,0.2,0.4,0.3,0.4,0.3,0.5,0.3,0.3,0.3,0.3,0.5,0.2,0.2,0.2,0.2,0.3,0.2,0.1,0.4,0.3,0.2,0.3,0.3,0.3,0.4,0.2,0.6,0.3,0.4,0.3,0.2,0.3,0.2,0.3,0.4,0.3,0.4,0.4,0.3,0.4,0.4,0.3,0.6,0.3,0.4,0.4,0.4,0.4,0.4,0.4,0.3,0.4,0.3,0.4,0.1,0.4,0.1,0.7,0.6,0.3,0.4,0.8,0.5,0.4,0.7,0.3,0.1,0.1,0.3,0.2,0.3,0.2,0.2,0.3,0.3,0.4,0.2,0.3,0.3,0.4,0.5,0.4,0.5,0.4,0.5,0.3,0.5,0.4,0.3,0.3,0.2,0.4,0.4,0.3,0.4,0.3,0.3,0.4,0.6,0.4,0.6,0.5,0.6,0.3,0.2,0.6,0.4,0.3,0.7,0.4,0.6,0.2,0.5,0.2,0.3,0.3,0.2,0.4,0.3,0.5,0.2,0.4,0.5,0.5,0.5,0.3,0.2,0.4,0.2,0.2,0.3,0.4,0.3,0.3,0.6,0.6,0.8,0.3,0.4,0.4],
	    'Tumor Tissue Site': ['Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung','Lung'],
	    'Person Cigarette Smoking History Pack Year Value': [200,40,30,20,'',50,25,25,30,40,25,50,40,45,30,'',40,'',15,90,35,56,9,45,48,14,75,100,38,85,83,60,40,'',30,37,25,60,50,20,30,50,35,45,50,100,'',50,60,60,70,57,50,53,50,51,40,20,86,46,108,20,60,50,60,50,'',40,'','',56,25,'',40,40,'','',40,45,'',45,40,30,114,35,40,40,30,192,8,60,47,63,26,64,64,15,50,20,114,36,34,40,'','','','','','','',25,'',80,86,'','','','','',49,20,157.5,63,39,10,110,25,7,110,93,90,58,60,56,42,'',50,35,56,40,44,63,40,20,'',72,56,16,40,108,80,43,'',25,70,58,12,37,28,80,50,65,70,74,40,80,40,25,10,112,100,86,75,'','','',40,35],
	    'Started Smoking Year': [1951,'','','','','','','','','',1963,'','','','','','','','','','','',1947,'',1953,'',1959,1956,1970,1952,1946,1940,1954,1933,1942,'','','','',1948,1958,'',1964,1942,1944,'','',1952,1944,'','','',1953,'',1940,'',1950,'',1966,1941,1961,'','','','','','',1960,'','',1953,1954,'','','','','',1970,1965,'',1965,'','',1947,1996,1964,1946,1946,1958,1960,1946,1950,1957,1969,1949,1968,1979,1959,'',1953,1959,1977,1936,'','','','','','','','','','',1962,'',1955,1952,1954,'',1950,1963,1959,1963,1969,1959,1955,1983,1950,1967,1946,'',1949,1976,1950,1967,'','',1973,1967,1965,1956,1956,1967,1970,1962,1959,1951,1959,1967,1953,1967,1964,'',1942,1971,1946,1972,1958,1956,1954,1954,1960,'',1959,1964,1968,1955,1977,1968,1952,1957,1965,1950,'','','',1970,1975],
	    'Stopped Smoking Year': ['',1988,2004,1974,'','',1995,1997,1975,'',1989,2002,2007,'',2001,2001,'','',1992,'',1994,1996,2006,1992,2004,1978,'',2009,'',2001,'',2001,1984,'',2002,'','','','',1968,1988,2005,1999,1987,1994,'',1994,2002,2004,'',2003,'',2003,'',1990,'',1970,'','',1987,2004,'',1974,1997,1959,'','',2000,'','','',1979,'',1993,1985,'','',2010,2010,'',2010,2003,'',2004,2005,2005,2002,1981,2006,1971,1997,1997,2000,'',1983,2000,'',2009,1983,2010,1995,'',1976,'','','','','',2010,1985,2007,2005,'',2006,1983,'',1996,2011,1993,1983,2003,'',2005,2008,1979,'',2006,1978,2007,2008,2008,2008,2006,1978,2009,2002,2001,2008,2004,2005,1991,2006,2007,1990,2002,2007,2007,1990,2007,2007,2007,2007,'',1967,2006,1969,2007,1995,1970,2007,2004,2003,2008,2007,2004,2008,1995,2002,2008,2008,1993,2008,2000,'','','',2011,2000],
	    'Specimen Second Longest Dimension': [0.5,0.5,0.4,0.4,0.4,0.5,0.5,0.5,0.5,0.5,0.4,0.6,0.8,0.4,0.5,0.8,0.5,0.6,1,1,0.8,0.6,1,1.5,0.9,1,1,1,0.6,0.5,0.4,0.4,0.6,0.9,0.8,0.5,0.6,0.4,0.5,0.8,0.8,0.5,0.8,1,1,0.8,0.5,0.6,1,0.7,0.8,0.7,1,1,1.3,0.6,1.3,0.9,1,1,0.9,0.4,1.2,0.5,0.7,1,1,0.7,0.7,1,0.6,1,0.7,0.6,1,0.5,0.5,0.7,1,0.6,0.9,1.2,1.2,1.6,1.2,1.5,1.3,1.5,1.6,1.4,1,1.5,0.9,1,1.2,0.7,0.9,0.7,0.6,0.8,1,0.7,0.8,0.5,0.5,0.8,0.6,0.8,0.8,0.9,0.4,0.6,0.3,0.6,0.4,0.6,0.8,0.7,1.5,1,0.5,1,0.6,0.9,0.9,0.8,0.4,1,0.6,1,0.5,0.4,0.9,0.6,0.8,0.8,0.6,0.5,0.8,0.7,0.7,0.6,0.7,0.6,1,0.4,0.7,0.8,0.6,0.5,0.7,0.8,0.7,0.9,0.7,1,0.8,0.6,0.6,0.6,1,0.9,0.5,0.7,0.4,0.9,0.8,0.8,0.5,0.5,1,1,1,0.6,1,1.3,1.2,2.2],
	    'Tissue Source Site': [18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,33,33,33,33,33,33,33,33,33,34,34,34,34,34,34,34,34,34,34,34,34,34,37,37,37,37,37,37,39,39,39,39,39,39,39,39,39,39,39,39,39,39,43,43,43,43,43,43,43,43,46,46,46,46,46,46,46,51,51,51,56,56,56,56,56,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,63,63,63,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,70,70,85,85,85],
	    'Patient Smoking History Category': [4,3,4,3,3,2,4,4,3,3,3,4,4,2,4,4,3,1,4,2,4,4,4,4,4,3,2,4,2,4,2,4,3,2,4,2,2,2,2,3,3,4,4,3,4,2,4,4,4,2,4,2,4,2,4,2,3,2,2,4,4,4,3,4,3,3,'',4,'','',2,3,'',3,3,'',1,4,4,1,4,4,3,4,4,4,4,3,4,3,4,4,4,2,3,4,2,4,3,4,4,2,3,2,4,3,4,4,4,3,4,4,2,4,3,2,4,4,4,3,4,2,4,4,3,2,4,3,4,4,4,4,4,3,4,4,4,4,4,4,3,4,4,3,4,4,4,3,4,4,4,4,2,3,4,3,4,4,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,1,1,1,4,4],
	    'Person Neoplasm Status': ['WITH TUMOR','TUMOR FREE','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','','TUMOR FREE','','TUMOR FREE','WITH TUMOR','WITH TUMOR','WITH TUMOR','','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE','WITH TUMOR','','WITH TUMOR','WITH TUMOR','TUMOR FREE','','','','TUMOR FREE','TUMOR FREE','','TUMOR FREE','WITH TUMOR','TUMOR FREE','WITH TUMOR','WITH TUMOR','','','TUMOR FREE','TUMOR FREE','','TUMOR FREE','','','','','WITH TUMOR','TUMOR FREE','','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','WITH TUMOR','TUMOR FREE','TUMOR FREE','','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','','WITH TUMOR','','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','','','WITH TUMOR','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','','','WITH TUMOR','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE','TUMOR FREE','','','','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','','','','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','TUMOR FREE','','','TUMOR FREE','TUMOR FREE','','','TUMOR FREE','','','TUMOR FREE','','','','TUMOR FREE','','','TUMOR FREE','','TUMOR FREE','','TUMOR FREE','TUMOR FREE','TUMOR FREE','WITH TUMOR','TUMOR FREE'],
	    'Vial number': ['A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A','A'],
	    'Patients Vital Status': ['Dead','Dead','Dead','Alive','Dead','Alive','Dead','Dead','Dead','Dead','Dead','Alive','Alive','Dead','Dead','Alive','Alive','Dead','Alive','Dead','Alive','Dead','Dead','Dead','Dead','Alive','Alive','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Alive','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Alive','Dead','Alive','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Dead','Alive','Alive','Dead','Alive','Alive','Dead','Alive','Alive','Dead','Alive','Alive','Alive','Alive','Alive','Alive','Alive','Alive','Dead','Dead','Alive','Alive','Dead','Dead','Dead','Dead','Alive','Alive','Alive','Dead','Dead','Dead','Alive','Dead','Alive','Alive','Alive','Dead','Alive','Alive','Alive','Dead','Alive','Alive','Alive','Dead','Dead','Alive','Dead','Alive','Alive','Alive','Dead','Dead','Dead','Alive','Alive','Alive','Alive','Dead','Alive','Dead','Alive','Alive','Alive','Alive','Alive','Alive','Alive','Dead','Dead','Dead','Alive','Dead','Alive','Alive','Alive','Alive','Alive','Alive','Dead','Alive','Alive','Alive','Alive','Alive','Alive','Alive','Alive','Alive','Dead','Alive','Alive','Dead','Alive','Dead','Alive','Alive','Alive','Alive','Alive','Dead','Dead','Alive','Dead','Alive','Alive','Alive','Alive','Alive','Dead','Alive','Alive']
	};

</script>

