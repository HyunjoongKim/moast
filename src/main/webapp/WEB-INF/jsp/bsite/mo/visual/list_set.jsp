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

.card-title {
	width: 100%
}
</style>

<script>

	var path = "${path }";
	
	var jsonHeatmapArg = new Array();
	var expHeatmap = new Array();
	var methHeatmap = new Array();
	var mutHeatmap = new Array();
	var expData = new Array();
	var methData = new Array();
	var mutData = new Array();
	
	let ORI_COLORS = ['aliceblue', 'antiquewhite', 'aqua', 'aquamarine', 'azure', 'beige', 'bisque', 'black', 'blanchedalmond', 'blue', 'blueviolet', 'brown', 'burlywood', 'cadetblue', 'chartreuse', 'chocolate', 'coral', 'cornflowerblue', 'cornsilk', 'crimson', 'cyan', 'darkblue', 'darkcyan', 'darkgoldenrod', 'darkgray', 'darkgrey', 'darkgreen', 'darkkhaki', 'darkmagenta', 'darkolivegreen', 'darkorange', 'darkorchid', 'darkred', 'darksalmon', 'darkseagreen', 'darkslateblue', 'darkslategray', 'darkslategrey', 'darkturquoise', 'darkviolet', 'deeppink', 'deepskyblue', 'dimgray', 'dimgrey', 'dodgerblue', 'firebrick', 'floralwhite', 'forestgreen', 'fuchsia', 'gainsboro', 'ghostwhite', 'gold', 'goldenrod', 'gray', 'grey', 'green', 'greenyellow', 'honeydew', 'hotpink', 'indianred', 'indigo', 'ivory', 'khaki', 'lavender', 'lavenderblush', 'lawngreen', 'lemonchiffon', 'lightblue', 'lightcoral', 'lightcyan', 'lightgoldenrodyellow', 'lightgray', 'lightgrey', 'lightgreen', 'lightpink', 'lightsalmon', 'lightseagreen', 'lightskyblue', 'lightslategray', 'lightslategrey', 'lightsteelblue', 'lightyellow', 'lime', 'limegreen', 'linen', 'magenta', 'maroon', 'mediumaquamarine', 'mediumblue', 'mediumorchid', 'mediumpurple', 'mediumseagreen', 'mediumslateblue', 'mediumspringgreen', 'mediumturquoise', 'mediumvioletred', 'midnightblue', 'mintcream', 'mistyrose', 'moccasin', 'navajowhite', 'navy', 'oldlace', 'olive', 'olivedrab', 'orange', 'orangered', 'orchid', 'palegoldenrod', 'palegreen', 'paleturquoise', 'palevioletred', 'papayawhip', 'peachpuff', 'peru', 'pink', 'plum', 'powderblue', 'purple', 'red', 'rosybrown', 'royalblue', 'saddlebrown', 'salmon', 'sandybrown', 'seagreen', 'seashell', 'sienna', 'silver', 'skyblue', 'slateblue', 'slategray', 'slategrey', 'snow', 'springgreen', 'steelblue', 'tan', 'teal', 'thistle', 'tomato', 'turquoise', 'violet', 'wheat', 'white', 'whitesmoke', 'yellow', 'yellowgreen'];
	let CSS_COLORS = ['aliceblue', 'antiquewhite', 'darkseagreen', 'darksalmon', 'darkred', 'darkseagreen', 'azure', 'beige', 'bisque', 'blanchedalmond', 'blue', 'blueviolet', 'brown', 'burlywood', 'cadetblue', 'chartreuse', 'chocolate', 'coral', 'cornflowerblue', 'cornsilk', 'crimson', 'cyan', 'darkblue', 'darkcyan', 'darkgoldenrod', 'darkgray', 'darkgrey', 'darkgreen', 'darkkhaki', 'darkmagenta', 'darkolivegreen', 'darkorange', 'darkorchid', 'darkred', 'darksalmon', 'darkseagreen', 'darkslateblue', 'darkslategray', 'darkslategrey', 'darkturquoise', 'darkviolet', 'deeppink', 'deepskyblue', 'dimgray', 'dimgrey', 'dodgerblue', 'firebrick', 'floralwhite', 'forestgreen', 'fuchsia', 'gainsboro', 'ghostwhite', 'gold', 'goldenrod', 'gray', 'grey', 'green', 'greenyellow', 'honeydew', 'hotpink', 'indianred', 'indigo', 'ivory', 'khaki', 'lavender', 'lavenderblush', 'lawngreen', 'lemonchiffon', 'lightblue', 'lightcoral', 'lightcyan', 'lightgoldenrodyellow', 'lightgray', 'lightgrey', 'lightgreen', 'lightpink', 'lightsalmon', 'lightseagreen', 'lightskyblue', 'lightslategray', 'lightslategrey', 'lightsteelblue', 'lightyellow', 'lime', 'limegreen', 'linen', 'magenta', 'maroon', 'mediumaquamarine', 'mediumblue', 'mediumorchid', 'mediumpurple', 'mediumseagreen', 'mediumslateblue', 'mediumspringgreen', 'mediumturquoise', 'mediumvioletred', 'midnightblue', 'mintcream', 'mistyrose', 'moccasin', 'navajowhite', 'navy', 'oldlace', 'olive', 'olivedrab', 'orange', 'orangered', 'orchid', 'palegoldenrod', 'palegreen', 'paleturquoise', 'palevioletred', 'papayawhip', 'peachpuff', 'peru', 'pink', 'plum', 'powderblue', 'purple', 'red', 'rosybrown', 'royalblue', 'saddlebrown', 'salmon', 'sandybrown', 'seagreen', 'seashell', 'sienna', 'silver', 'skyblue', 'slateblue', 'slategray', 'slategrey', 'snow', 'springgreen', 'steelblue', 'tan', 'teal', 'thistle', 'tomato', 'turquoise', 'violet', 'wheat', 'white', 'whitesmoke', 'yellow', 'yellowgreen'];
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();

		heatmapHtml();
		//<c:forEach var="result" items="${presetVO.omicsList}" varStatus="status">
		//</c:forEach>
		
		$("#sortable-omics").kendoSortable({
			axis: "y",
			cursor: "move",
			container: "#sortable-omics",
			filter: ">div:not(.kdBlock)"
        });
		
		$('#correlationButton').click(function() {
			//console.log(expHeatmap);
			var win = window.open("", "PopupCorrelationWin", "width=1450,height=820");
			
			var url = "${path}/mo/visual/met/list.do";
			$('#submitFormT').prop("action", url);
			$('#submitFormT').prop("target", "PopupCorrelationWin");
			$('#submitFormT').prop("method", "post");
	        $('#submitFormT').submit() ;
		});
		
		$('#correlation2Button').click(function() {
			//console.log(expHeatmap);
			var win = window.open("", "PopupCorrelationWin", "width=1450,height=820");
			
			var url = "${path}/mo/visual/met2/list.do";
			$('#submitForm').prop("action", url);
			$('#submitForm').prop("target", "PopupCorrelationWin");
			$('#submitForm').prop("method", "post");
	        $('#submitForm').submit() ;
		});
	});
	
	function heatmapHtml() {
		var oLen = ${fn:length(presetVO.omicsList)};
		for(var i = 0; i < oLen; i++) {
			var dummy = $('#dummyHeatmap').html();
			var dummyHtml = dummy.replace(/###/gi, i);
			
			$('#sortable-omics').append(dummyHtml);
			
			$('#expTitle' + i).closest('.card-header').css("background-color", CSS_COLORS[i]);
			$('#expTitle' + i).text($('#std_title' + i).val());
			$('#methTitle' + i).text($('#std_title' + i).val());
			$('#methTitle' + i).closest('.card-header').css("background-color", CSS_COLORS[i]);
			$('#mutTitle' + i).text($('#std_title' + i).val());
			$('#mutTitle' + i).closest('.card-header').css("background-color", CSS_COLORS[i]);
			
			callDeg(i);
			//*
			callDmp(i);
			callMut(i);
			//*/
		}
		
		initSwitch();
		
	}
	
	function reOrder(plotType, no) {
		// get heatmap json
		// var t = expHeatmap[no];
		// var tJson = JSON.parse(t.prettyJSON(t.cleanDataObject(t.cloneObject(CanvasXpress.stack[t.target]))));
		
		var sI = expHeatmap[no].varIndices;
		if (plotType == 'exp') {
			sI = expHeatmap[no].varIndices;
		} else if (plotType == 'meth') {
			sI = methHeatmap[no].varIndices;
		}
		
		//exp
		for(var i = 0; i < expHeatmap.length; i++) {
			var tVars = [];
			var tData = [];
			var tGroup = [];
			
			if (expData[i] && i != no) {
				for(var j = 0; j < sI.length; j++) {
	
					tVars[j] = expData[i].vars[sI[j]];
					tData[j] = expData[i].data[sI[j]];
					tGroup[j] = expData[i].group[sI[j]];
				}
				
				makeExpHeatmap(expData[i].smps, tVars, tData, tGroup, expData[i].degMin, expData[i].degMax, i);
			}
		}
		
		//meth
		for(var i = 0; i < methHeatmap.length; i++) {
			var tVars = [];
			var tData = [];
			var tGroup = [];
			
			if (methData[i]) {
				for(var j = 0; j < sI.length; j++) {
	
					tVars[j] = methData[i].vars[sI[j]];
					tData[j] = methData[i].data[sI[j]];
					tGroup[j] = methData[i].group[sI[j]];
				}
				makeMethHeatmap(methData[i].smps, tVars, tData, tGroup, i);
			}
			
			
		}
	}
	
	function undoOrder(plotType, no) {
		if (plotType == 'exp') {
			makeExpHeatmap(expData[no].smps, expData[no].vars, expData[no].data, expData[no].group, expData[no].degMin, expData[no].degMax, no);
		} else if (plotType == 'meth') {
			makeMethHeatmap(methData[no].smps, methData[no].vars, methData[no].data, methData[no].group, no);
		}
	}
	
	function undoOrderAll() {
		for(var i = 0; i < expHeatmap.length; i++) {
			makeExpHeatmap(expData[i].smps, expData[i].vars, expData[i].data, expData[i].group, expData[no].degMin, expData[no].degMax, i);
		}
		
		for(var i = 0; i < methHeatmap.length; i++) {
			makeMethHeatmap(methData[i].smps, methData[i].vars, methData[i].data, methData[i].group, i);
		}
	}
	
	function callDeg(no) {
		
		if($('#expYN' + no).val() == 'Y') {
			$.ajax({
	            url: "${path}/mo/basic/deg_filter.do",
	            type: "POST",
	            data: $('#submitForm' + no).serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	 console.log(data);
	    			if(data.res == "ok") {
	    				var h = new Object();
	    				h.smps = data.data.geneList;
	    				h.vars = data.data.sampleList;
	    				h.data = data.data.heatmapDataList;
	    				h.group = data.data.sampleGroupList;
	    				h.degMin = data.data.degMin;
	    				h.degMax = data.data.degMax;
	    				h.geneSetType = data.data.geneSetType;
	    				expData[no] = h;
	    				
	    				makeExpHeatmap(h.smps, h.vars, h.data, h.group, h.degMin, h.degMax, no);
	            	}
	                
	            },
	            complete: function(data) {
				}
	        });
		}
		
	}
	
	function callDmp(no) {
		if($('#methYN' + no).val() == 'Y') {
			$.ajax({
	            url: "${path}/mo/basic/dmp_filter.do",
	            type: "POST",
	            data: $('#submitForm' + no).serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	// console.log(data);
	    			if(data.res == "ok") {
	    				var h = new Object();
	    				h.smps = data.data.geneProbeList;
	    				h.vars = data.data.sampleList;
	    				h.data = data.data.heatmapDataList;
	    				h.group = data.data.sampleGroupList;
	    				methData[no] = h;
	    				
	    				makeMethHeatmap(h.smps, h.vars, h.data, h.group, no);
	            	}
	            },
	            complete: function(data) {
				}
	        });
		}
	}
	
	function callMut(no) {
		if($('#mutYN' + no).val() == 'Y') {
			$.ajax({
	            url: "${path}/mo/basic/mut_exc.do",
	            type: "POST",
	            data: $('#submitForm' + no).serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	//console.log(data);
	    			if(data.res == "ok") {
	    				makeMutHeatmap(data.data, no);
	            	}
	            },
	            complete: function(data) {
	   			}
	        });
		}
		
	}
	
	function initSwitch() {
		$('.kendoPMToggle').kendoSwitch({
	        messages: {
	            checked: "Expand",
	            unchecked: "Collapse"
	        },
	        change: function (e) {
	            var cbody = this.element.closest('.card').find('.card-body');
	            var cWrap = this.element.closest('.wrso');
	            if (e.checked) {
	            	cbody.hide();
	            	cWrap.removeClass('kdBlock');
	            } else {
	            	cbody.show();
	            	cWrap.addClass('kdBlock');
	            }
	        }
	    });
	}
	
	function initControls() {
		initSwitch();
		
		
		$('#btnSelectGeneset').click(function(){
			var url = '${path }/mo/multi/list.do';
			$('#submitForm').attr('action', url).submit();
		});
		
		$('#btnSelectGeneset2').click(function(){
			var url = '${path }/mo/multi/list2.do';
			$('#submitForm').attr('action', url).submit();
		});
		
		
		$('#btnAddSimgleOmics').click(function(){
			$.ajax({
	            url: "${path}/mo/basic/create_study.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	console.log(data);
	    			if(data.res == "ok") {
	    				$('#std_idx').val(data.data.std_idx);
	    				
	    				$('#geneSetType').val('Single_Omics_Analysis');
	    				var url = '${path}/mo/basic/list.do';
	    				$('#submitForm').attr('action', url).submit();
	            	}
	            },
	            complete: function(data) {
    			}
	        });
		});
		

		$('#btnAddGeneSet').click(function(){
			$.ajax({
	            url: "${path}/mo/basic/create_study.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	console.log(data);
	    			if(data.res == "ok") {
	    				$('#std_idx').val(data.data.std_idx);
	    				
	    				$('#geneSetType').val('Add_Gene_Set');
	    				var url = '${path}/mo/addgeneset/list.do';
	    				$('#submitForm').attr('action', url).submit();
	            	}
	            },
	            complete: function(data) {
    			}
	        });
		});
		
		$('#savePresetButton').click(function(){
			savePreset();
		});
		
		$('#saveStudyButton').click(function(){
			saveStudy();
		});
		
	}
	
	function savePreset() {
		$('#savePresetForm').submit();
		/*
	    $.ajax({
	        url: "${path}/mo/visual/create_preset_action.do",
	        type: "POST",
	        data: $('#savePresetForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
				if (data.res == "ok") {
					alert('Preset을 저장하였습니다.');
					
					$('#savePresetModal').modal('hide');
	        	} else {
	        		alert('Preset 저장 중 오류가 발생했습니다.');
	        	}
	        }
	    });
		*/
	}
	
	function saveStudy() {
		$('#saveStudyForm').submit();
		/*
	    $.ajax({
	        url: "${path}/mo/visual/create_study_action.do",
	        type: "POST",
	        data: $('#saveStudyForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
				if (data.res == "ok") {
					alert('Study를 저장하였습니다.');
					
					$('#saveStudyModal').modal('hide');
	        	} else {
	        		alert('Study 저장 중 오류가 발생했습니다.');
	        	}
	        }
	    });
		*/
	}
	
	function showSaveStudyModal(std_idx, std_type) {
		$('#sm_std_idx').val(std_idx);
		$('#sm_std_title').val('');
		$('#sm_std_note').val('');
		$('#sm_std_type').val(std_type);
		
		$('#saveStudyModal .smY').prop('checked', true);
		
		$('#saveStudyModal').modal('show');
	}
	
</script>

<!-- heatmap -->
<script>	

	
	function makeExpHeatmap(smps, vars, data, group, degMin, degMax, no) {
		$('#divHeatmap').show();
		$('#divExp' + no).show();
		
		CanvasXpress.destroy('expHeatmap' + no);
		$('#wrapperExpHeatmap' + no).html("<div><canvas id='expHeatmap" + no + "' width='1000' height='600'></canvas></div>");
		
		expHeatmap[no] = new CanvasXpress({
		    "version": 37.3,
		    "renderTo": "expHeatmap" + no,
		    "data": {
		        "y": {
		            "smps": smps,
		            "vars": vars,
		            "data": data
		        },
		        "z": {
		        	"Group": group 
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
		if (degMin != degMax) {
			expHeatmap[no].updateTextColorAttribute(["setMinX"], degMin);
			expHeatmap[no].updateTextColorAttribute(["setMaxX"], degMax);	
		}

	}
	//*
	function makeMethHeatmap(smps, vars, data, group, no) {
		$('#divHeatmap').show();
		$('#divMeth' + no).show();
		
		CanvasXpress.destroy('methHeatmap' + no);
		$('#wrapperMethHeatmap' + no).html("<div><canvas id='methHeatmap" + no + "' width='1000' height='600'></canvas></div>");
		
		//var methCoefficient = data.coefficientList; // -1, 1 추가
		
		methHeatmap[no] = new CanvasXpress({
		    "version": 37.3,
		    "renderTo": "methHeatmap" + no,
		    "data": {
		    	'x': {
		    		//'coefficient': methCoefficient 
		    	},
		        "y": {
		        	"smps": smps,
		            "vars": vars,
		            "data": data
		        },
		        "z": {
		        	"Group": group 
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
	
	function makeMutHeatmap(data, no) {
		$('#divHeatmap').show();
		$('#divMut' + no).show();
		
		CanvasXpress.destroy('mutHeatmap' + no);
		$('#wrapperMutHeatmap' + no).html("<div><canvas id='mutHeatmap" + no + "' width='1000' height='600'></canvas></div>");
		
		var mutHeatmapSmps = data.geneList;
		var mutHeatmapVars = data.sampleList;
		var mutHeatmapData = data.heatmapDataList;
		var mutHeatmapData3 = data.heatmapData3List;
		var mutHeatmapData4 = data.heatmapData4List;
		var mutHeatmapGroup = data.sampleGroupList;
		
		mutHeatmap[no] = new CanvasXpress({
		    "version": 37.3,
		    "renderTo": "mutHeatmap" + no,
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


<!-- heatmap json Script -->
<script>

function showJsonList() {
	$.ajax({
        url: "${path}/mo/visual/list_json_action.do",
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
    					tbody += '<tr>';
    					tbody += '<td>' + value.hm_title + '</td>';
    					tbody += '<td>' + value.hm_note + '</td>';
    					tbody += '<td>' + value.hm_type_nm + '</td>';
    					tbody += '<td><button type="button" class="btn btn-warning" onclick="deleteJson(' + value.hm_idx + ')">Delete</button></td>';
    					jsonHeatmapArg[index] = value.hm_json;
   						tbody += '<td><button type="button" class="btn btn-success" onclick="drawHeatmapByJson(jsonHeatmapArg[' + index + '])">선택</button></td>';
   						/* tbody += '<td><button type="button" class="btn btn-success" onclick="loadJson(' + value.hm_idx + ', \'' + value.hm_type + '\')">선택</button></td>'; */
    					tbody += '</tr>';
					});
				}
        	} else {
        		tbody = '<tr><td colspan="5">An error occurred while querying.</td></tr>';
        	}
			
			$('#jsonListBody').html(tbody);
        },
        complete: function(data) {
        	$('#jsonListModal').modal('show');
		}
    });
}


function showCreateJsonModal(hm_type, no) {
	var t;
	if (hm_type == 'exp') {
		t = expHeatmap[no];
	} else if (hm_type == 'meth') {
		t = methHeatmap[no];
	} else if (hm_type == 'mut') {
		t = mutHeatmap[no];
	}
	
	var jsonString = t.prettyJSON(t.cleanDataObject(t.cloneObject(CanvasXpress.stack[t.target])));
	var tJson = JSON.parse(jsonString);
	tJson.renderTo = 'jsonHeatmap';
	var jsonString2 = JSON.stringify(tJson);
	
	$('#hm_json').val(jsonString2);
	$('#hm_type').val(hm_type);
	
	$('#jsonSaveModal').modal('show');
}

function createJson() {
	
	$.ajax({
        url: "${path}/mo/visual/create_json_action.do",
        type: "POST",
        data: $('#createJsonForm').serialize(),
        error: function() {alert('An error occurred during data reception.');},
        success: function(data) {
        	//console.log(data);
			if (data.res == "ok") {
				alert('그룹을 저장하였습니다.');
				
				$('#dtls').val();
				$('#hm_title').val();
				$('#hm_note').val();
				
				$('#jsonSaveModal').modal('hide');
        	} else {
        		alert('JSON을 저장 중 오류가 발생했습니다.');
        	}
        }
    });
}

function deleteJson(hm_idx) {
	$('#hm_idx').val(hm_idx);
	
	if (confirm('Confirm to delete this Heatmap Json')) {
		
		
		$.ajax({
	        url: "${path}/mo/visual/delete_json_action.do",
	        type: "POST",
	        data: $('#jsonForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
				if (data.res == "ok") {
					alert('Deleted.');
	        	} else {
	        		alert('An error occurred while querying.');
	        	}
	        },
	        complete: function(data) {
	        	showJsonList();
			}
	    });
	}
}

function loadJson(hm_idx, hm_type) {
	$('#hm_idx').val(hm_idx);
	
	$.ajax({
        url: "${path}/mo/visual/list_json_dtl_action.do",
        type: "POST",
        data: $('#jsonForm').serialize(),
        error: function() {alert('An error occurred during data reception.');},
        success: function(data) {
        	//console.log(data);
			if (data.res == "ok") {
				drawHeatmapByJson(data.data);
        	} else {
        		alert('An error occurred while querying.');
        	}
        },
        complete: function(data) {
        	$('#jsonListModal').modal('hide');
		}
    });
}

var jsonHeatmap;
function drawHeatmapByJson(data) {
	$('#divJsonHeatmap').show();
	
	
	CanvasXpress.destroy('jsonHeatmap');
	$('#wrapperjsonHeatmap').html("<div><canvas id='jsonHeatmap' width='1000' height='600'></canvas></div>");
	
	var jsonData = JSON.parse(data);
	jsonHeatmap = new CanvasXpress(jsonData);
	
	$('#jsonListModal').modal('hide');
}



</script>


<form:form commandName="searchVO" method="get" name="submitFormT" id="submitFormT" action="${path}/mo/visual/list.do">
	<input type="hidden" name="grp1" id="grp1" value="Normal_1,Normal_2,Normal_3,Normal_4,Normal_5" />
	<input type="hidden" name="grp2" id="grp2" value="Tumor_1,Tumor_2,Tumor_3,Tumor_4,Tumor_5" />
</form:form>

<c:forEach var="result" items="${presetVO.omicsList}" varStatus="status">
	<form:form commandName="searchVO" method="get" name="submitForm${status.index }" id="submitForm${status.index }" action="${path}/mo/visual/list.do">
		<input type="hidden" name="grp1" value="${result.grp1 }" />
		<input type="hidden" name="grp2" value="${result.grp2 }" />
		<%-- <input type="hidden" name="expType" id="expType" value="${param.expType }" /> --%>
		<input type="hidden" name="degType" value="${result.degType }" />
		<input type="hidden" name="searchLogFC" value="${result.searchLogFC }" />
		<input type="hidden" name="searchPValueType" value="${result.searchPValueType }" />
		<input type="hidden" name="searchPValue" value="${result.searchPValue }" />
		<input type="hidden" name="searchAdjPValue" value="${result.searchAdjPValue }" />
		<%-- <input type="hidden" name="methType" id="methType" value="${param.methType }" /> --%>
		<input type="hidden" name="dmpType" value="${result.dmpType }" />
		<input type="hidden" name="searchDmpLogFC" value="${result.searchDmpLogFC }" />
		<input type="hidden" name="searchDmpPValue" value="${result.searchDmpPValue }" />
		<input type="hidden" name="searchDmpPValueType" value="${result.searchDmpPValueType }" />
		<input type="hidden" name="searchDmpAdjPValue" value="${result.searchDmpAdjPValue }" />
		<input type="hidden" name="geneType" value="DEG_Genes" />
		<input type="hidden" name="ud_idx" value="${result.ud_idx }"/>
		<input type="hidden" name="ws_idx" value="${result.ws_idx }"/>
		<input type="hidden" name="wp_idx" value="${result.wp_idx }"/>
		<input type="hidden" name="ps_idx" value="${result.ps_idx }"/>
		<input type="hidden" name="std_idx" value="${result.std_idx }"/>
		<input type="hidden" name="expYN" value="${result.expYN }" id="expYN${status.index }"/>
		<input type="hidden" name="methYN" value="${result.methYN }" id="methYN${status.index }"/>
		<input type="hidden" name="mutYN" value="${result.mutYN }" id="mutYN${status.index }"/>
		<input type="hidden" name="std_title" value="${result.std_title }" id="std_title${status.index }"/>
		<input type="hidden" name="geneSetType" id="geneSetType${result.ps_idx }" value="${result.geneSetType }"/>
		<input type="hidden" name="userGeneText" value="${result.userGeneText }"/>
	</form:form>
</c:forEach>

<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="${path}/mo/visual/list.do">
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
	<input type="hidden" name="ps_idx" id="ps_idx" value="${searchVO.ps_idx }"/>
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx }"/>
	<input type="hidden" name="geneSetType" id="geneSetType" value="${searchVO.geneSetType }"/>
	<input type="hidden" name="userGeneText" id="userGeneText" value="${searchVO.userGeneText }"/>
	<input type="hidden" name="cg_idx" id="cg_idx" value="${searchVO.cg_idx }"/>

				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">GeneSet Visualization</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>Analysis<i class="fa fa-chevron-right ml-2 mr-2"></i>GeneSet Visualization</div>
					</div>
				</div>
				<!-- //title -->
				
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!--  Data Sets -->
							<div class="row">
								<div id="divHeatmap" class="col-lg-12 initHideT">
									<div class="card mt-3">
										<div class="card-header">
											<h3 class="card-title">
												<i class="ion ion-clipboard mr-1"></i>Pre-defined gene set
											</h3>
										</div>
		
										<div class="card-body">
											<div class="row justify-content-center">
												<div class="col-lg-12">
													<div class="card mt-3">
														<div class="card-body">
															<div>
																<ul>
																	<c:forEach var="result" items="${presetVO.omicsList}" varStatus="status">
																		<li>
																			study ${result.std_idx } : ${result.std_title }
																			<c:if test='${result.std_status eq "S"}'>
																				저장됨
																			</c:if>
																			<c:if test='${result.std_status ne "S"}'>
																				<button type="button" onclick="showSaveStudyModal('${result.std_idx }', '${result.std_type }')" class="btn btn-primary btn-sm mr-2">Save Study</button>
																			</c:if>
																		</li>
																			
																		
																	</c:forEach>
																</ul>
															</div>
															<div class="btn-area1">
																<div class="float-left">
																	<!-- 
																	
																	<button type="button" id="meVIL" class="btn btn-secondary mr-2">Load</button>
																	<button type="button" id="meVID" class="btn btn-secondary mr-2">Draw</button>
																	<button type="button" id="meVIR" class="btn btn-secondary mr-2">ReDraw</button>
																	 -->
																	<!--  
																	<button type="button" id="survDegSampleButton" class="btn btn-secondary mr-2">샘플 DEG 생존분석</button>
																	<button type="button" id="survButton" class="btn btn-primary mr-2">생존 분석</button>
																	<button type="button" id="correlationButton" class="btn btn-secondary mr-2">샘플 Correlation 계산</button>
																	<button type="button" id="correlation2Button" class="btn btn-primary">Correlation 계산</button>
																	 -->
																	 
																</div>
																<div class="float-right">
																	<button type="button" class="btn btn-dark" data-toggle="modal" data-target="#savePresetModal">Preset 저장</button>
																</div>
															</div>
														</div>
													</div>
												</div>
												<div class="col-lg-12">
													<div class="card mt-3">
														<div class="card-body">
															<!-- 버튼 -->
															<div class="row btn-area mb-3">
																<div class="col-lg-6 text-left">
																	<div>
																		<button type="button" onclick="undoOrderAll()" class="btn btn-secondary mr-2">undo All</button>
																		<button type="button" class="btn btn-dark" onclick="showJsonList();">json list</button>
																	</div>
																</div>
																<div class="col-lg-6 text-right">
																	<div>
																		<!-- <button type="button" class="btn btn-dark" onclick="showJsonList();">json 목록</button> -->
																	</div>
																</div>
															</div>
															<!--//  버튼 -->
															
															<div id="divJsonHeatmap" class="col-lg-12 wrso initHideT kdBlock mt-1 mb-3">
																<div class="card mt-1 mb-1">
																	<div class="card-header">
																		<h3 class="card-title">
																			<input id="switchJson" class="kendoPMToggle mr-2"/> JSON heatmap 
																			<span id="jsonTitle"></span>
																		</h3>
																	</div>
																	
																	<div class="card-body" id="cbodyJson">
																		<div class="row">
																			<div class="col-12">
															
																				<div id="wrapperjsonHeatmap" style="width: 100%; height: 100%;">
																					<div>
																						<canvas id='jsonHeatmap' width='1000' height='600'></canvas>
																					</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
															
															<div id="sortable-omics">
																<%-- 
																
																<div id="divExp1" class="col-lg-12 initHideTq wrso kdBlock">
																	<div class="card mt-1 mb-1">
																		<div class="card-header">
																			<h3 class="card-title">
																				<input id="switchExp1" class="kendoPMToggle mr-2"/> Expression 
																			</h3>
																		</div>
																		
																		<div class="card-body" id="cbodyExp1">
																			<div class="row">
																				<div class="col-12 mb-2">
																					Z-Score Log2(TPM+1)
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
																</div>
																		
																<div id="divMeth1" class="col-lg-12 initHideT wrso kdBlock">
																	<div class="card mt-1 mb-1">
																		<div class="card-header">
																			<h3 class="card-title">
																				<input id="switchMeth1" class="kendoPMToggle mr-2"/> Methylation
																			</h3>
																		</div>
										
																		<div class="card-body" id="cbodyMeth1">
																			<div id="wrapperMethHeatmap1" style="width: 100%; height: 100%;">
																				<div>
																					<canvas id='methHeatmap1' width='600' height='800'></canvas>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
																
																<div id="divMut1" class="col-lg-12 initHideT wrso kdBlock">
																	<div class="card mt-1 mb-1">
																		<div class="card-header">
																			<h3 class="card-title">
																				<input id="switchMeth1" class="kendoPMToggle mr-2"/> Variant
																			</h3>
																		</div>
										
																		<div class="card-body" id="cbodyMut1">
																			<div id="wrapperMutHeatmap1" style="width: 100%; height: 100%;">
																				<div>
																					<canvas id='mutHeatmap1' width='600' height='800'></canvas>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
															 --%>
																
																
															</div>		
															
															
														</div>
													</div>	
												</div>
												
												<div class="col-lg-12 mb_30">
													<div class="float-left" style="padding-left: 30px;">
														<button type="button" class="btn btn-dark" id="btnAddSimgleOmics">Add Single omics</button>
														<button type="button" class="btn btn-dark" id="btnAddGeneSet">Add Gene-set</button>
													</div>
													<div class="float-right" style="padding-right: 30px;">
														<button type="button" class="btn btn-success" data-toggle="modal" data-target="#geneSetSelectionModal">Next ></button>
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
	




	<!-- Modal -->
	<div class="modal fade" id="geneSetSelectionModal" tabindex="-1" role="dialog" aria-labelledby="geneSetSelectionModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="geneSetSelectionModalLabel">Select Data-set (For MultiOmics)</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<c:forEach var="result" items="${presetVO.omicsList}" varStatus="status">
						<div class="form-check">
							<input class="form-check-input" type="radio" name="searchStdIdx" id="searchStdIdx${status.index }" value="${result.std_idx }" checked>
							<label class="form-check-label" for="searchStdIdx${status.index }">study ${result.std_idx } : ${result.std_title }</label>
						</div>
					</c:forEach>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
					<!-- <button type="button" class="btn btn-success" id="btnSelectGeneset">다음 ></button> -->
					<button type="button" class="btn btn-success" id="btnSelectGeneset2">Next ></button>
				</div>
			</div>
		</div>
	</div>
	
</form:form>	
	
<!-- Modal Preset 저장 -->
<div class="modal fade" id="savePresetModal" tabindex="-1" role="dialog" aria-labelledby="savePresetModalLabel" aria-hidden="true">
	<form id="savePresetForm" name="savePresetForm" action="${path}/mo/visual/create_preset_action.do" method="post">
		<input type="hidden" name="ud_idx" id="ud_idx" value="${searchVO.ud_idx }"/>
		<input type="hidden" name="me_idx" id="me_idx" value="${searchVO.me_idx }"/>
		<input type="hidden" name="cg_idx" id="cg_idx" value="${searchVO.cg_idx }"/>
		<c:forEach var="result" items="${presetVO.omicsList}" varStatus="status">
			<input type="hidden" name="std_idx_arr" id="std_idx${status.index }" value="${result.std_idx }" />
		</c:forEach>
		
		
	
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="savePresetModalLabel">Save "your Preset"</h5>
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
									<th><span class="text-danger">*</span>Title</th>
									<td>
										<div class="row">
											<div class="col-12"><input type="text" class="form-control" name="ps_title" id="ps_title" placeholder="enter the subject." maxlength="199"></div>
										</div>
									</td>
								</tr>
								
								<tr>
									<th>comments</th>
									<td>
										<div class="row">
											<div class="col-12">
												<textarea class="form-control" name="ps_note" id="ps_note" placeholder="enter a comment." maxlength="1999" style="height:150px; resize: none;"></textarea>
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
					<button type="button" class="btn btn-success" id="savePresetButton">Save <i class="fas fa-chevron-right"></i></button>
				</div>
			</div>
		</div>
	</form>
</div>

<!-- Modal Study 저장 -->
<div class="modal fade" id="saveStudyModal" tabindex="-1" role="dialog" aria-labelledby="saveStudyModalLabel" aria-hidden="true">
	<form id="saveStudyForm" name="saveStudyForm" action="${path}/mo/visual/create_study_action.do" method="post">
		<input type="hidden" name="std_idx" id="sm_std_idx" value="0"/>
		<input type="hidden" name="std_type" id="sm_std_type" value="A"/>
		<input type="hidden" name="ud_idx" id="sm_ud_idx" value="${searchVO.ud_idx }"/>
		<input type="hidden" name="cg_idx" id="sm_cg_idx" value="${searchVO.cg_idx }"/>
	
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="saveStudyModalLabel">Save "your Study"</h5>
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
									<th><span class="text-danger">*</span>Title</th>
									<td>
										<div class="row">
											<div class="col-12"><input type="text" class="form-control" name="std_title" id="sm_std_title" placeholder="enter the subject." maxlength="199"></div>
										</div>
									</td>
								</tr>
								<tr>
									<th>Expression</th>
									<td>
										<div class="row">
											<div class="col-12">
												<input type="radio" class="form-control1 smY mr-1" name="expYN" id="sm_expYN_Y" value="Y" >
												<label for="sm_expYN_Y" class="mr-3">check</label>
												<input type="radio" class="form-control1 smN mr-1" name="expYN" id="sm_expYN_N" value="N">
												<label for="sm_expYN_N">uncheck</label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th>Methylation</th>
									<td>
										<div class="row">
											<div class="col-12">
												<input type="radio" class="form-control1 smY mr-1" name="methYN" id="sm_methYN_Y" value="Y" >
												<label for="sm_methYN_Y" class="mr-3">check</label>
												<input type="radio" class="form-control1 smN mr-1" name="methYN" id="sm_methYN_N" value="N">
												<label for="sm_methYN_N">uncheck</label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th>Variant</th>
									<td>
										<div class="row">
											<div class="col-12">
												<input type="radio" class="form-control1 smY mr-1" name="mutYN" id="sm_mutYN_Y" value="Y" >
												<label for="sm_mutYN_Y" class="mr-3">check</label>
												<input type="radio" class="form-control1 smN mr-1" name="mutYN" id="sm_mutYN_N" value="N">
												<label for="sm_mutYN_N">uncheck</label>
											</div>
										</div>
									</td>
								</tr>
								
								
								<tr>
									<th>Comments</th>
									<td>
										<div class="row">
											<div class="col-12">
												<textarea class="form-control" name="std_note" id="sm_std_note" placeholder="enter a comment." maxlength="1999" style="height:150px; resize: none;"></textarea>
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
					<button type="button" class="btn btn-success" id="saveStudyButton">Save <i class="fas fa-chevron-right"></i></button>
				</div>
			</div>
		</div>
	</form>
</div>


<!-- Modal json 저장 -->
<div class="modal fade" id="jsonSaveModal" tabindex="-1" role="dialog" aria-labelledby="jsonSaveModalLabel" aria-hidden="true">
	<form id="createJsonForm" name="createJsonForm" action="${path}/mo/clinic/create_group_action.do" method="post">
		<input type="hidden" name="ud_idx" id="hm_ud_idx" value="${searchVO.ud_idx }"/>
		<input type="hidden" name="ps_idx" id="hm_ps_idx" value="${searchVO.ps_idx }"/>
		<input type="hidden" name="std_idx" id="hm_std_idx" value=""/>
		<input type="hidden" name="hm_json" id="hm_json" value=""/>
		<input type="hidden" name="hm_type" id="hm_type" value=""/>
		<input type="hidden" name="std_idx" id="hm_std_idx" value=""/>
	
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="jsonSaveModalLabel">Save Heatmap Json</h5>
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
									<th><span class="text-danger">*</span>Title</th>
									<td>
										<div class="row">
											<div class="col-12"><input type="text" class="form-control" name="hm_title" id="hm_title" placeholder="enter the subject." maxlength="199"></div>
										</div>
									</td>
								</tr>
								
								<tr>
									<th>Comments</th>
									<td>
										<div class="row">
											<div class="col-12">
												<!-- <input type="text" class="form-control" name="cg_note" id="cg_note" placeholder="코멘트를 입력해주세요."  maxlength="1999"> -->
												<textarea class="form-control" name="hm_note" id="hm_note" placeholder="enter a comment." maxlength="1999" style="height:150px; resize: none;"></textarea>

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
					<button type="button" class="btn btn-success" id="btnJsonSave" onclick="createJson();">Save Heatmap Json <i class="fas fa-chevron-right"></i></button>
				
				</div>
			</div>
		</div>
	</form>
</div>

<!-- Modal json 목록 -->
<div class="modal fade" id="jsonListModal" tabindex="-1" role="dialog" aria-labelledby="jsonListModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="jsonListModalLabel">Heatmap Json List</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="text-left mt-3">
					<table class="table table-bordered table-block">
						<colgroup>
							<col width="30%">
							<col width="35%">
							<col width="15%">
							<col width="10%">
							<col width="10%">
						</colgroup>
						
						<thead>
							<tr>
								<th>Title</th>
								<th>Comments</th>
								<th>Type</th>
								<th>Delete</th>
								<th>Select</th>
							</tr>
						</thead>

						<tbody id="jsonListBody">
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


	
<!-- heatmap dummy -->
<div id="dummyHeatmap" style="display: none;">
	<div id="divExp###" class="col-lg-12 initHideT wrso kdBlock mt-1 mb-1">
		<div class="card mt-1 mb-1">
			<div class="card-header">
				<h3 class="card-title">
					<input id="switchExp###" class="kendoPMToggle mr-2"/> Expression | 
					<span id="expTitle###"></span>
					<div class="float-right">
						<button type="button" onclick="reOrder('exp', '###')" class="btn btn-success btn-sm mr-2">Apply order</button>
						<button type="button" onclick="undoOrder('exp', '###')" class="btn btn-secondary btn-sm mr-2">undo</button>
						<button type="button" onclick="showCreateJsonModal('exp', '###')" class="btn btn-primary btn-sm mr-2">Save JSON</button>
					</div>
				</h3>
			</div>
			
			<div class="card-body" id="cbodyExp1">
				<div class="row">
					<div class="col-12 mb-2">
						Z-Score Log2(TPM+1)
					</div>
					<div class="col-12">
	
						<div id="wrapperExpHeatmap###" style="width: 100%; height: 100%;">
							<div>
								<canvas id='expHeatmap###' width='1000' height='600'></canvas>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
			
	<div id="divMeth###" class="col-lg-12 initHideT wrso kdBlock mt-1 mb-1">
		<div class="card mt-1 mb-1">
			<div class="card-header">
				<h3 class="card-title">
					<input id="switchMeth###" class="kendoPMToggle mr-2"/> Methylation |
					<span id="methTitle###"></span> 
					<div class="float-right">
						<button type="button" onclick="reOrder('meth', '###')" class="btn btn-success btn-sm mr-2">Apply order</button>
						<button type="button" onclick="undoOrder('meth', '###')" class="btn btn-secondary btn-sm mr-2">undo</button>
						<button type="button" onclick="showCreateJsonModal('meth', '###')" class="btn btn-primary btn-sm mr-2">Save JSON</button>
					</div>
				</h3>
			</div>

			<div class="card-body" id="cbodyMeth1">
				<div id="wrapperMethHeatmap###" style="width: 100%; height: 100%;">
					<div>
						<canvas id='methHeatmap###' width='600' height='800'></canvas>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="divMut###" class="col-lg-12 initHideT wrso kdBlock mt-1 mb-1">
		<div class="card mt-1 mb-1">
			<div class="card-header">
				<h3 class="card-title">
					<input id="switchMut###" class="kendoPMToggle mr-2"/> Variant | <span id="mutTitle###"></span>
					<div class="float-right">
						<!-- <button type="button" onclick="showCreateJsonModal('mut', '###')" class="btn btn-primary btn-sm mr-2">JSON 저장</button> -->
					</div>
				</h3>
			</div>

			<div class="card-body" id="cbodyMut1">
				<div id="wrapperMutHeatmap###" style="width: 100%; height: 100%;">
					<div>
						<canvas id='mutHeatmap###' width='600' height='800'></canvas>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
	