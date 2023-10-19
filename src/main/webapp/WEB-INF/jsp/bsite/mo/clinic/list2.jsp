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

<style>
	.cchart {
		height:300px;
	}
</style>

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	
	var gCurrTab = 1;
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();
		initGrid();
		selectChart(0);
		
		initGroup();
		
	});
	
	function initControls() {
		$('#clearFilterButton').click(function(){
			$("#gridClinic").data("kendoGrid").dataSource.filter({});
		});
		
		$('#unselectButton').click(function(){
			$("#gridClinic").data("kendoGrid").clearSelection();
		});
		
		$('#removeSelectedButton').click(function(){
		    var grid = $('#grpGrid' + gCurrTab).data("kendoGrid");
		    var rows = grid.select();
			
			if (rows.length > 0) {
				$("#s_saved").val('N');
			}
			
		    rows.each(function(index, row) {
        		
		    	grid.removeRow($(this).closest("tr"));
		    	
   			});
		    
		    syncWithGroup(gCurrTab);
		});
		
		$('#clearButton').click(function(){
			$("#s_saved").val('N');
			
			$('#grpGrid' + gCurrTab).data("kendoGrid").dataSource.data([]);
			
			syncWithGroup(gCurrTab);
		});
		
		$('#clearAllButton').click(function(){
			$("#s_saved").val('N');
			
			$('#grpGrid1').data("kendoGrid").dataSource.data([]);
			$('#grpGrid2').data("kendoGrid").dataSource.data([]);
			
			syncWithGroup(1);
			syncWithGroup(2);
		});
		
		$('#btnGroupSave').click(function(){
			createGroup();
		});
		
		$('#btnGroup2Save').click(function(){
			createGroup2();
		});
		
		$('#btnNewGroupSave').click(function(){
			$('#groupDuplListModal').modal('hide');
			
			$('#cg_title').val(getGroupName());
			$('#btnGroupSave').hide();
			$('#groupSaveModal').modal('show');
		});
		
		$('#btnNext').click(function(){
			var savedYn = $('#s_saved').val();
			if (savedYn == 'Y') {
				$('#geneSetSelectionModal').modal('show');	
			} else if (savedYn == 'N') {
				checkGroupDupl();
			}
			
		});
		
		$('#btnSelectGeneset').click(function(){
			fillGroupValue();
			
			$.ajax({
	            url: "${path}/mo/basic/create_study.do",
	            type: "POST",
	            data: $('#submitForm').serialize(),
	            error: function() {alert('An error occurred during data reception.');},
	            success: function(data) {
	            	//console.log(data);
	    			if(data.res == "ok") {
	    				$('#std_idx').val(data.data.std_idx);
	    				
	    				var url = '${path }/mo/basic/list.do';
	    				var geneSetType = $('input[name="geneSetType"]:checked').val();
	    				if (geneSetType == 'Single_Omics_Analysis') {
	    					url = '${path}/mo/basic/list.do';
	    				} else if (geneSetType == 'Add_Gene_Set') {
	    					url = '${path}/mo/addgeneset/list.do';
	    				}
	    				$('#submitForm').attr('action', url).submit();
	            	}
	            },
	            complete: function(data) {
    			}
	        });
			
			
		});
		
		// 현재 tab
		$('ul#dataSetTab li a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		  	gCurrTab = $(e.target).attr("id").replace('grpTab', '');
		})
	}
	
	function checkGroupDupl() {
		make2GroupData();
		// 기존 샘플 그룹 있는지 확인
		// 있으면 new 인지 기존 목록 팝업 보여주기
		// 없으면 new Save 후 다음 팝업
		
		$.ajax({
	        url: "${path}/mo/clinic/list_group_dupl_action.do",
	        type: "POST",
	        data: $('#createGroupForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
	        	var tbody = '<tr><td colspan="3" class="text-center">저장된 동일 샘플 그룹이 없습니다.</td></tr>';
				if (data.res == "ok") {
					if (data.data.length > 0) {
						tbody = '';
						data.data.forEach(function(value, index, array) {
	    					tbody += '<tr>';
	    					tbody += '<td>' + value.cg_title + '</td>';
	    					tbody += '<td>' + value.cg_note + '</td>';
	   						tbody += '<td class="text-center"><button type="button" class="btn btn-success" onclick="selectDuplGroup(' + value.cg_idx + ')">선택</button></td>';	
	    					tbody += '</tr>';
						});
					}
	        	} else {
	        		tbody = '<tr><td colspan="3">An error occurred while querying.</td></tr>';
	        	}
				
				$('#groupDuplListBody').html(tbody);
	        },
	        complete: function(data) {
	        	$('#groupDuplListModal').modal('show');
			}
	    });
	}
	
	
	function initGroup() {
		var cg_idx = '${searchVO.cg_idx}';
		if (Number(cg_idx) > 0) {
			loadGroup(cg_idx, '2');
			$('#btnNext').focus();
			alert('Data has been loaded.');
		}
	}
	
	function syncWithGroup(grp) {
		var srcGrid = $('#gridClinic').data("kendoGrid");
	    var srcData = srcGrid.dataSource.data();
	    var grpData = $('#grpGrid' + gCurrTab).data("kendoGrid").dataSource.data();
	    
	    var grpValue = 'Group ' + grp;
	    
	    var grpIds = [];
	    grpData.forEach(function(value, index, array) {
	    	grpIds[index] = value.sample_id;
		});
	    
	    srcData.forEach(function(value, index, array) {
	    	if (value.grp == grpValue) {
	    		if (grpIds.indexOf(value.sample_id) > -1) {
		    		//console.log(value.sample_id);
		    		value.grp = "Group " + gCurrTab;
		    	} else {
		    		value.grp = '';
		    	}
	    	}
		});
	    
	    srcGrid.clearSelection();
	    srcGrid.refresh(); // html 직접 수정으로 변경

	    reDrawGroupGrid();
	    
	    $('#dataSetTab li a').eq(Number(grp) - 1).tab('show');
	    
	    selectChart(grp);
	}
	
	function hasRow_bak(rows, row, sgroup) {
		for (var i = 0; i < rows.length; i++) {
			if (rows[i].cl2_id == row.cl2_id && rows[i].sgroup == sgroup) {
				return true;
			}
		}
		return false;
	}

	function hasRow(sample_id, targetDataSource) {
		var targetData = targetDataSource.data();
	    
		var VersionIdArray = [];
	    for(var i = 0; i < targetData.length; i++) {
            var currentDataItem = targetData[i];
            //console.log(currentDataItem.sample_id);
            if (currentDataItem.sample_id == sample_id) {
            	return true;
            }
            VersionIdArray[i] = currentDataItem.sample_id;
            
        }
	    
	    return false;
	}
	
	// 동일 DataSource 사용 검토
	function addToGroup2(grp) {
		var gridSrc = $('#gridClinic').data("kendoGrid");
		var gridTarget = $('#grpGrid' + grp).data("kendoGrid");
	    var selectedRows = gridSrc.select();
	    
	    var selectedData = [];
	    
	    var targetDataSource = gridTarget.dataSource;
	    
	    //
	    selectedRows.each(function(index, row) {
	    	var dataItem = gridSrc.dataItem($(this));
	    	//targetDataSource.add(dataItem);
	    	
	    	dataItem["grp"] = "Group " + grp;
	    	var targetHasRow = hasRow(dataItem["sample_id"], targetDataSource);
	    	if (!targetHasRow) {
	    		selectedData.push(dataItem);	
	    	}
		    //console.log(targetHasRow);
		    
		});
	    
	    targetDataSource.pushCreate(selectedData);
	    targetDataSource.sync();
	    
	    gridSrc.clearSelection();
	    gridSrc.refresh();
	    gridTarget.refresh();
	    
	    $('#dataSetTab li a').eq(Number(grp) - 1).tab('show');
	}
	// 하단 삭제 시 기본 제거
	// refresh 대신 html 직접 수정
	
	
	// 동일 DataSource 사용 검토
	function addToGroup(grp) {
		var srcGrid = $('#gridClinic').data("kendoGrid");
		var srcDataSource = srcGrid.dataSource;
	    var srcData = srcDataSource.data();
	    
	    var selectedRows = srcGrid.select();
		
		if (selectedRows.length > 0) {
			$("#s_saved").val('N');
		}
	    
	    
	    var grpIdx = 0;
	    for (var i = 0; i < srcGrid.columns.length; i++) {
	    	if (srcGrid.columns[i].field == 'grp') {
	    		grpIdx = i;
	    		break;
	    	}
	    }
	    
	    var curGrp = "Group " + grp;
	    var othGrp = (grp == 1) ? "Group 2" : "Group 1";
	    
	    var duplSmps = "";
	    selectedRows.each(function(index, row) {
	    	var dataItem = srcGrid.dataItem($(this));
	    	
	    	if (dataItem["grp"] == othGrp) {
	    		duplSmps = duplSmps + dataItem["sample_id"] + " ";
	    	}
		});
	    
	    var isCancel = false;
	    if (duplSmps != "") {
	    	if(!confirm(duplSmps + '샘플이 ' + othGrp + ' 에 있습니다.\r\n' + othGrp + '에서 중복 제거 후\r\n' + curGrp + '에 추가하시겠습니까?')) {
	    		isCancel = true;
	    	}
	    	
	    }
	    
	    if (!isCancel) {
		    selectedRows.each(function(index, row) {
		    	var dataItem = srcGrid.dataItem($(this));
		    	
		    	dataItem["grp"] = "Group " + grp;
		    	
		    	var rowChildren = $(row).children('td[role="gridcell"]');
		        var cell = rowChildren.eq(grpIdx);
		    	cell.html(dataItem["grp"]);
			});
		    
		    srcGrid.clearSelection();
		    srcGrid.refresh(); 
	
		    reDrawGroupGrid();
	    }
	    
	    $('#dataSetTab li a').eq(Number(grp) - 1).tab('show');
	    
	    selectChart(grp);
	}
	
	function reDrawGroupGrid () {
		var srcGrid = $('#gridClinic').data("kendoGrid");
		var srcDataSource = srcGrid.dataSource;
	    var srcData = srcDataSource.data();
	    
		var items1 = [];
	    var items2 = [];
	    for (var i = 0; i < srcData.length; i++) {
	    	if (srcData[i].grp == "Group 1") {
	    		items1.push(srcData[i]);
	    		//console.log(srcData[i].sample_id + "\t" + srcData[i].grp);
	    	}
	    	if (srcData[i].grp == "Group 2") {
	    		items2.push(srcData[i]);
	    		//console.log(srcData[i].sample_id + "\t" + srcData[i].grp);
	    	}
		}
		
		var targetGrid1 = $('#grpGrid1').data("kendoGrid");
	    var targetDataSource1 = targetGrid1.dataSource;
		var targetGrid2 = $('#grpGrid2').data("kendoGrid");
	    var targetDataSource2 = targetGrid2.dataSource;
		
		targetDataSource1.data(items1);
	    targetGrid1.refresh();
		targetDataSource2.data(items2);
		targetGrid2.refresh();
	}
	
	function fillGroupValue() {
		var ids1 = [];
		var ids2 = [];
		var grid1 = $('#grpGrid1').data("kendoGrid");
		var grid2 = $('#grpGrid2').data("kendoGrid");
		var data1 = grid1.dataSource.view();
		var data2 = grid2.dataSource.view();

		for (i = 0; i < data1.length; i++)
			ids1.push(data1[i].sample_id);
		for (i = 0; i < data2.length; i++)
			ids2.push(data2[i].sample_id);
		
		$('#grp1').val(ids1);
		$('#grp2').val(ids2);
	}
</script>


<!-- 데이터 세트 구성 Script -->
<script>

function getGroupName() {
	var today = new Date();

	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);
	var hours = ('0' + today.getHours()).slice(-2); 
	var minutes = ('0' + today.getMinutes()).slice(-2);
	var seconds = ('0' + today.getSeconds()).slice(-2);

	var dateString = year + '-' + month  + '-' + day;
	var timeString = hours + ':' + minutes  + ':' + seconds;
	
	var groupName = '샘플 그룹 ' + dateString + ' ' + timeString;
	
	return groupName;
}

function showGroupSave() {
	
	$('#cg_title').val('');
	$('#btnGroupSave').show();
	$('#groupSaveModal').modal('show');
}

function selectDuplGroup(cg_idx) {
	$('#groupDuplListModal').modal('hide');
	
	$('#cg_idx').val(cg_idx);
	$('#s_cg_idx').val(cg_idx);
	$("#s_saved").val('Y');
	
	$('#geneSetSelectionModal').modal('show');
}

function showGroupList() {

	$.ajax({
        url: "${path}/mo/clinic/list_group_action.do",
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
    					tbody += '<td>' + value.cg_title + '</td>';
    					tbody += '<td>' + value.cg_note + '</td>';
    					tbody += '<td>' + value.cg_type_nm + '</td>';
    					tbody += '<td><button type="button" class="btn btn-warning" onclick="deleteGroup(' + value.cg_idx + ')">Delete</button></td>';
   						tbody += '<td><button type="button" class="btn btn-success" onclick="loadGroup(' + value.cg_idx + ', \'' + value.cg_type + '\')">Select</button></td>';	
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

function deleteGroup(cg_idx) {
	$('#cg_idx').val(cg_idx);
	
	if (confirm('해당 그룹을 삭제하시겠습니까 ?')) {
		
		
		$.ajax({
	        url: "${path}/mo/clinic/delete_group_action.do",
	        type: "POST",
	        data: $('#groupForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
				if (data.res == "ok") {
					alert('삭제되었습니다.');
	        	} else {
	        		alert('An error occurred while querying.');
	        	}
	        },
	        complete: function(data) {
	        	showGroupList();
			}
	    });
	}
}

function loadGroup(cg_idx, cg_type) {
	$('#cg_idx').val(cg_idx);
	$('#s_cg_idx').val(cg_idx);
	$("#s_saved").val('N');
	/* 전체 갱신
	if (cg_type == '2') {
		if (!confirm('Group 1, Group 2의 전체 데이터가 갱신 됩니다.')) {
			return false;
		}
	}
	*/
	
	$.ajax({
        url: "${path}/mo/clinic/list_group_dtl_action.do",
        type: "POST",
        data: $('#groupForm').serialize(),
        error: function() {alert('An error occurred during data reception.');},
        success: function(data) {
        	//console.log(data);
			if (data.res == "ok") {
				if (cg_type == '2') {
					addToGroup2WithSample(data.data);
				} else {
					addToGroupWithSample(data.data);	
				}
				
        	} else {
        		alert('An error occurred while querying.');
        	}
        },
        complete: function(data) {
        	$('#groupListModal').modal('hide');
		}
    });
}

function addToGroupWithSample(data) {
	var samples = data.samples;
	var grp = gCurrTab;
	var srcGrid = $('#gridClinic').data("kendoGrid");
	var srcDataSource = srcGrid.dataSource;
    var srcData = srcDataSource.data();
    
    var curGrp = "Group " + grp;
	var othGrp = (grp == 1) ? "Group 2" : "Group 1";
	
    srcData.forEach(function(value, index, array) {
    	
    	if (samples.indexOf(value.sample_id) > -1) {
    		if (value.grp == othGrp) {
    			if(confirm('[ ' +value.sample_id + ' ] 샘플이 ' + othGrp + ' 에 있습니다.\r\n' + othGrp + '에서 중복 제거 후\r\n' + curGrp + '에 추가하시겠습니까?')) {
    				value.grp = "Group " + gCurrTab;
    			}
    		} else {
    			value.grp = "Group " + gCurrTab;	
    		}
    	}
	});
    
    srcGrid.clearSelection();
    srcGrid.refresh(); // html 직접 수정으로 변경

    reDrawGroupGrid();
    
    $('#dataSetTab li a').eq(Number(grp) - 1).tab('show');
    
    selectChart(grp);

}

function addToGroup2WithSample(data) {
	
	/* 전체 갱신
	$('#grpGrid1').data("kendoGrid").dataSource.data([]);
	$('#grpGrid2').data("kendoGrid").dataSource.data([]);
	syncWithGroup(1);
	syncWithGroup(2);
	*/
	
	var samples = data.samples;
	var dtls = data.dtls;
	
	var srcGrid = $('#gridClinic').data("kendoGrid");
	var srcDataSource = srcGrid.dataSource;
    var srcData = srcDataSource.data();
    
	var curGrp = "Group ";
	var othGrp = "Group ";
	
    srcData.forEach(function(value, index, array) {
    	
    	var sampleIndex = samples.indexOf(value.sample_id)
    	if (samples.indexOf(value.sample_id) > -1) {
			group = "Group " + dtls[sampleIndex].cg_no;
			
			curGrp = "Group " + dtls[sampleIndex].cg_no;
			othGrp = (dtls[sampleIndex].cg_no == 1) ? "Group 2" : "Group 1";
			
    		if (value.grp == othGrp) {
    			if(confirm('[ ' +value.sample_id + ' ] 샘플이 ' + othGrp + ' 에 있습니다.\r\n' + othGrp + '에서 중복 제거 후\r\n' + curGrp + '에 추가하시겠습니까?')) {
    				value.grp = curGrp;
    			}
    		} else {
    			value.grp = curGrp;	
    		}
    	} else {
			value.grp = "";
		}
	});
    
    srcGrid.clearSelection();
    srcGrid.refresh(); // html 직접 수정으로 변경

    reDrawGroupGrid();
    
    $('#dataSetTab li a').eq(0).tab('show');
    
    selectChart(1);

	$("#s_saved").val('Y');
}

function createGroup() {
	var grpData = $('#grpGrid' + gCurrTab).data("kendoGrid").dataSource.data();
	var grpIds = [];
	var grpCgNos = [];
	
    grpData.forEach(function(value, index, array) {
    	grpIds[index] = value.sample_id;
    	grpCgNos[index] = '0';
	});
    
    $('#dtls').val(grpIds.toString());
    $('#cgNos').val(grpCgNos.toString());
    $('#cg_type').val(1);
    
    
    $.ajax({
        url: "${path}/mo/clinic/create_group_action.do",
        type: "POST",
        data: $('#createGroupForm').serialize(),
        error: function() {alert('An error occurred during data reception.');},
        success: function(data) {
        	//console.log(data);
			if (data.res == "ok") {
				alert('그룹을 저장하였습니다.');
				
				$('#dtls').val();
				$('#cgNos').val();
				$('#cg_title').val();
				$('#cg_note').val();
				
				$('#groupSaveModal').modal('hide');
        	} else {
        		alert('그룹을 저장 중 오류가 발생했습니다.');
        	}
        }
    });
}

function createGroup2() {
	make2GroupData();
	
    $.ajax({
        url: "${path}/mo/clinic/create_group_action.do",
        type: "POST",
        data: $('#createGroupForm').serialize(),
        error: function() {alert('An error occurred during data reception.');},
        success: function(data) {
        	//console.log(data);
			if (data.res == "ok") {
				alert('Save is complete.');
				
				$('#dtls').val();
				$('#cgNos').val();
				$('#cg_title').val();
				$('#cg_note').val();
				$('#s_cg_idx').val(data.data.cg_idx);
				
				$('#s_saved').val('Y');
				
				$('#groupSaveModal').modal('hide');
				$('#geneSetSelectionModal').modal('show');
        	} else {
        		alert('An error occurred while save.');
        	}
        }
    });
}

function make2GroupData() {
	var grpData1 = $('#grpGrid1').data("kendoGrid").dataSource.data();
	var grpData2 = $('#grpGrid2').data("kendoGrid").dataSource.data();
	var grpIds = [];
	var grpCgNos = [];
    
	var i = 0;
	grpData1.forEach(function(value, index, array) {
    	grpIds[i] = value.sample_id;
		grpCgNos[i] = '1';
		i++;
	});
	
	grpData2.forEach(function(value, index, array) {
    	grpIds[i] = value.sample_id;
		grpCgNos[i] = '2';
		i++;
	});
    
    $('#dtls').val(grpIds.toString());
	$('#cgNos').val(grpCgNos.toString());
	$('#cg_type').val(2);
}

</script>


<!-- Grid Script -->
<script>
<c:if test="${searchVO.ud_idx ne 2}">
var clinicFields = {
	ud_idx: {type: "number"},
	cd_idx: {type: "number"},
	spm_idx: {type: "number"},
	grp: {type: "string"},
	patient_id: {type: "string"},
	sample_id: {type: "string"},
	sample_type: {type: "string"},
	cohort: {type: "string"},
	sex: {type: "string"},
	age_diag: {type: "number"},
	pri_location: {type: "string"},
	pri_location_side: {type: "string"},
	pathology: {type: "string"},
	differentiation: {type: "string"},
	msi: {type: "string"},
	stage: {type: "string"},
	substage: {type: "string"},
	t_diag: {type: "string"},
	n_diag: {type: "string"},
	lymphatic_invasion: {type: "string"},
	venous_invasion: {type: "string"},
	perineural_invasion: {type: "string"},
	m_diag: {type: "string"},
	meta_organs: {type: "string"},
	dfs: {type: "number"},
	recur: {type: "number"},
	lvp: {type: "string"}
};

var clinicColumns = [
	//{title: "#", template: "#= ++ordersGridRecord #", width: 50},
	{field: "ud_idx", title: "ud_idx", hidden: true}, 
	{field: "cd_idx", title: "cd_idx", hidden: true}, 
	{field: "spm_idx", title: "spm_idx", hidden: true},
	//{field: "grp", title: "group", width: 80}, 
	{field: "patient_id", title: "Patient_ID", width: 120}, 
	{field: "sample_id", title: "Sample_ID", width: 120},
	{field: "sample_type", title: "Sample_Type", width: 100, filterable: {multi: true}}, 
	{field: "cohort", title: "Cohort", width: 80, filterable: {multi: true}}, 
	{field: "sex", title: "Sex", width: 80, filterable: {multi: true}}, 
	{field: "age_diag", title: "Age_Diag", width: 80}, 
	{field: "pri_location", title: "Pri_Location", width: 120, filterable: {multi: true}}, 
	{field: "pri_location_side", title: "Pri_Location_Side", width: 140, filterable: {multi: true}}, 
	{field: "pathology", title: "Pathology", width: 130, filterable: {multi: true}}, 
	{field: "differentiation", title: "Differentiation", width: 80, filterable: {multi: true}}, 
	{field: "msi", title: "MSI", width: 80, filterable: {multi: true}}, 
	{field: "stage", title: "Stage", width: 80, filterable: {multi: true}}, 
	{field: "substage", title: "Substage", width: 80, filterable: {multi: true}}, 
	{field: "t_diag", title: "T_Diag", width: 80, filterable: {multi: true}}, 
	{field: "n_diag", title: "N_Diag", width: 80, filterable: {multi: true}}, 
	{field: "lymphatic_invasion", title: "Lymphatic_Invasion", width: 80, filterable: {multi: true}}, 
	{field: "venous_invasion", title: "Venous_Invasion", width: 80, filterable: {multi: true}}, 
	{field: "perineural_invasion", title: "Perineural_Invasion", width: 80, filterable: {multi: true}}, 
	{field: "m_diag", title: "M_Diag", width: 80, filterable: {multi: true}}, 
	{field: "meta_organs", title: "Meta_Organs", width: 80, filterable: {multi: true}}, 
	{field: "dfs", title: "DFS", width: 80, filterable: {search: true}}, 
	{field: "recur", title: "Recur", width: 80, filterable: {multi: true, search: true}}, 
	{field: "lvp", title: "LVP", width: 80, filterable: {multi: true}}
];
</c:if>

<c:if test="${searchVO.ud_idx eq 2}">
var clinicFields = {
	ud_idx: {type: "number"},
	cd_idx: {type: "number"},
	sample_id: {type: "string"},
	tumor_tissue_site: {type: "string"},
	histological_type: {type: "string"},
	gender: {type: "string"},
	vital_status_x: {type: "string"},
	days_to_birth: {type: "number"},
	days_to_death_x: {type: "number"},
	days_to_last_followup_x: {type: "string"},
	tissue_source_site: {type: "string"},
	patient_id: {type: "string"},
	bcr_patient_uuid: {type: "string"},
	informed_consent_verified: {type: "string"},
	icd_o_3_site: {type: "string"},
	icd_10: {type: "string"},
	tissue_prospective_collection_indicator: {type: "string"},
	tissue_retrospective_collection_indicator: {type: "string"},
	age_at_initial_pathologic_diagnosis: {type: "number"},
	year_of_initial_pathologic_diagnosis: {type: "number"},
	ethnicity: {type: "string"},
	weight: {type: "number"},
	height: {type: "number"}
};
var clinicColumns = [	
	{field: "ud_idx", title: "ud_idx", hidden: true}, 
	{field: "cd_idx", title: "ud_idx", hidden: true}, 
	{field: "sample_id", title: "sample_id", width: 120},
	{field: "tumor_tissue_site", title: "tumor_tissue_site", width: 120, filterable: {multi: true}},
	{field: "histological_type", title: "histological_type", width: 240, filterable: {multi: true}},
	{field: "gender", title: "gender", width: 120, filterable: {multi: true}},
	{field: "vital_status_x", title: "vital_status_x", width: 120, filterable: {multi: true}},
	{field: "days_to_birth", title: "days_to_birth", width: 120},
	{field: "days_to_death_x", title: "days_to_death_x", width: 120},
	{field: "days_to_last_followup_x", title: "days_to_last_followup_x", width: 120},
	{field: "tissue_source_site", title: "tissue_source_site", width: 120, filterable: {multi: true}},
	{field: "patient_id", title: "patient_id", width: 120},
	{field: "bcr_patient_uuid", title: "bcr_patient_uuid", width: 300},
	{field: "informed_consent_verified", title: "informed_consent_verified", width: 100, filterable: {multi: true}},
	{field: "icd_o_3_site", title: "icd_o_3_site", width: 100, filterable: {multi: true}},
	{field: "icd_10", title: "icd_10", width: 100, filterable: {multi: true}},
	{field: "tissue_prospective_collection_indicator", title: "tissue_prospective_collection_indicator", width: 100, filterable: {multi: true}},
	{field: "tissue_retrospective_collection_indicator", title: "tissue_retrospective_collection_indicator", width: 100, filterable: {multi: true}},
	{field: "age_at_initial_pathologic_diagnosis", title: "age_at_initial_pathologic_diagnosis", width: 100},
	{field: "year_of_initial_pathologic_diagnosis", title: "year_of_initial_pathologic_diagnosis", width: 100},
	{field: "ethnicity", title: "ethnicity", width: 240, filterable: {multi: true}},
	{field: "weight", title: "weight", width: 100},
	{field: "height", title: "height", width: 100}
];
</c:if>


var ordersGridRecord = 0;
var ordersGridRecord1 = 0;
var ordersGridRecord2 = 0;

var orderData = ${jsonBody};

var orderData1 = [
	/*
	{"age_diag":"58","atch_file_id":"","cd_idx":1,"ck":"","cohort":"A","cret_date":null,"cret_id":"","cret_ip":"","cret_name":"","del_yn":"","dfs":"1342","differentiation":"NA","firstIndex":1,"insertId":0,"isExcel":"N","isMypage":"N","isPop":"N","lastIndex":1,"lvp":"NA","lymphatic_invasion":"NA","m_diag":"M0","meta_organs":"None","modi_date":null,"modi_id":"","modi_ip":"","msi":"MSS","n_diag":"N2a","pageIndex":1,"pageIndex2":1,"pageSize":10,"pageUnit":20,"pathology":"Adenocarcinoma","patient_id":"PM-AA-0051","perineural_invasion":"NA","pri_location":"Multiple","pri_location_side":"Left-Sided","queryString":"","qustr":"","qustrTab":"","recordCountPerPage":10,"recur":"1","retId":"","retTitleId":"","rowNo":0,"sOption":"N","sample_id":"PM-AA-0051-N","sample_type":"Normal","searchWrd":"","sex":"M","site_code":"","spm_idx":1,"stage":"3","substage":"IIIc","t_diag":"T3","ud_idx":1,"venous_invasion":"NA"},
	{"age_diag":"58","atch_file_id":"","cd_idx":2,"ck":"","cohort":"A","cret_date":null,"cret_id":"","cret_ip":"","cret_name":"","del_yn":"","dfs":"1342","differentiation":"NA","firstIndex":1,"insertId":0,"isExcel":"N","isMypage":"N","isPop":"N","lastIndex":1,"lvp":"NA","lymphatic_invasion":"NA","m_diag":"M0","meta_organs":"None","modi_date":null,"modi_id":"","modi_ip":"","msi":"MSS","n_diag":"N2a","pageIndex":1,"pageIndex2":1,"pageSize":10,"pageUnit":20,"pathology":"Adenocarcinoma","patient_id":"PM-AA-0051","perineural_invasion":"NA","pri_location":"Multiple","pri_location_side":"Left-Sided","queryString":"","qustr":"","qustrTab":"","recordCountPerPage":10,"recur":"1","retId":"","retTitleId":"","rowNo":0,"sOption":"N","sample_id":"PM-AA-0051-T","sample_type":"Tumor","searchWrd":"","sex":"M","site_code":"","spm_idx":2,"stage":"3","substage":"IIIc","t_diag":"T3","ud_idx":1,"venous_invasion":"NA"},
	{"age_diag":"49","atch_file_id":"","cd_idx":3,"ck":"","cohort":"A","cret_date":null,"cret_id":"","cret_ip":"","cret_name":"","del_yn":"","dfs":"238","differentiation":"NA","firstIndex":1,"insertId":0,"isExcel":"N","isMypage":"N","isPop":"N","lastIndex":1,"lvp":"NA","lymphatic_invasion":"NA","m_diag":"M0","meta_organs":"None","modi_date":null,"modi_id":"","modi_ip":"","msi":"MSS","n_diag":"N1a","pageIndex":1,"pageIndex2":1,"pageSize":10,"pageUnit":20,"pathology":"Adenocarcinoma","patient_id":"PM-AA-0056","perineural_invasion":"NA","pri_location":"Rectal","pri_location_side":"Left-Sided","queryString":"","qustr":"","qustrTab":"","recordCountPerPage":10,"recur":"1","retId":"","retTitleId":"","rowNo":0,"sOption":"N","sample_id":"PM-AA-0056-N","sample_type":"Normal","searchWrd":"","sex":"M","site_code":"","spm_idx":11,"stage":"3","substage":"IIIb","t_diag":"T3","ud_idx":1,"venous_invasion":"NA"},
	{"age_diag":"49","atch_file_id":"","cd_idx":4,"ck":"","cohort":"A","cret_date":null,"cret_id":"","cret_ip":"","cret_name":"","del_yn":"","dfs":"238","differentiation":"NA","firstIndex":1,"insertId":0,"isExcel":"N","isMypage":"N","isPop":"N","lastIndex":1,"lvp":"NA","lymphatic_invasion":"NA","m_diag":"M0","meta_organs":"None","modi_date":null,"modi_id":"","modi_ip":"","msi":"MSS","n_diag":"N1a","pageIndex":1,"pageIndex2":1,"pageSize":10,"pageUnit":20,"pathology":"Adenocarcinoma","patient_id":"PM-AA-0056","perineural_invasion":"NA","pri_location":"Rectal","pri_location_side":"Left-Sided","queryString":"","qustr":"","qustrTab":"","recordCountPerPage":10,"recur":"1","retId":"","retTitleId":"","rowNo":0,"sOption":"N","sample_id":"PM-AA-0056-T","sample_type":"Tumor","searchWrd":"","sex":"M","site_code":"","spm_idx":12,"stage":"3","substage":"IIIb","t_diag":"T3","ud_idx":1,"venous_invasion":"NA"},
	{"age_diag":"58","atch_file_id":"","cd_idx":5,"ck":"","cohort":"A","cret_date":null,"cret_id":"","cret_ip":"","cret_name":"","del_yn":"","dfs":"243","differentiation":"NA","firstIndex":1,"insertId":0,"isExcel":"N","isMypage":"N","isPop":"N","lastIndex":1,"lvp":"NA","lymphatic_invasion":"NA","m_diag":"M0","meta_organs":"None","modi_date":null,"modi_id":"","modi_ip":"","msi":"MSI-H","n_diag":"N0","pageIndex":1,"pageIndex2":1,"pageSize":10,"pageUnit":20,"pathology":"Adenocarcinoma","patient_id":"PM-AA-0057","perineural_invasion":"NA","pri_location":"Multiple","pri_location_side":"Left-Sided","queryString":"","qustr":"","qustrTab":"","recordCountPerPage":10,"recur":"1","retId":"","retTitleId":"","rowNo":0,"sOption":"N","sample_id":"PM-AA-0057-N","sample_type":"Normal","searchWrd":"","sex":"F","site_code":"","spm_idx":13,"stage":"2","substage":"IIb","t_diag":"T4a","ud_idx":1,"venous_invasion":"NA"},
	{"age_diag":"58","atch_file_id":"","cd_idx":6,"ck":"","cohort":"A","cret_date":null,"cret_id":"","cret_ip":"","cret_name":"","del_yn":"","dfs":"243","differentiation":"NA","firstIndex":1,"insertId":0,"isExcel":"N","isMypage":"N","isPop":"N","lastIndex":1,"lvp":"NA","lymphatic_invasion":"NA","m_diag":"M0","meta_organs":"None","modi_date":null,"modi_id":"","modi_ip":"","msi":"MSI-H","n_diag":"N0","pageIndex":1,"pageIndex2":1,"pageSize":10,"pageUnit":20,"pathology":"Adenocarcinoma","patient_id":"PM-AA-0057","perineural_invasion":"NA","pri_location":"Multiple","pri_location_side":"Left-Sided","queryString":"","qustr":"","qustrTab":"","recordCountPerPage":10,"recur":"1","retId":"","retTitleId":"","rowNo":0,"sOption":"N","sample_id":"PM-AA-0057-T","sample_type":"Tumor","searchWrd":"","sex":"F","site_code":"","spm_idx":14,"stage":"2","substage":"IIb","t_diag":"T4a","ud_idx":1,"venous_invasion":"NA"},
	//*/
];

var orderData2 = [
	/*
	{"age_diag":"59","atch_file_id":"","cd_idx":2,"ck":"","cohort":"A","cret_date":null,"cret_id":"","cret_ip":"","cret_name":"","del_yn":"","dfs":"577","differentiation":"NA","firstIndex":1,"insertId":0,"isExcel":"N","isMypage":"N","isPop":"N","lastIndex":1,"lvp":"NA","lymphatic_invasion":"NA","m_diag":"M0","meta_organs":"None","modi_date":null,"modi_id":"","modi_ip":"","msi":"MSS","n_diag":"N2b","pageIndex":1,"pageIndex2":1,"pageSize":10,"pageUnit":20,"pathology":"Adenocarcinoma","patient_id":"PM-AA-0052","perineural_invasion":"NA","pri_location":"Multiple","pri_location_side":"Left-Sided","queryString":"","qustr":"","qustrTab":"","recordCountPerPage":10,"recur":"1","retId":"","retTitleId":"","rowNo":0,"sOption":"N","sample_id":"PM-AA-0052-N","sample_type":"Normal","searchWrd":"","sex":"F","site_code":"","spm_idx":3,"stage":"3","substage":"IIIc","t_diag":"T4a","ud_idx":1,"venous_invasion":"NA"},
	//*/
	
];

function initGrid() {
	// clinic Grid
	var gridDataSource = new kendo.data.DataSource({
		data: orderData,
		//pageSize: 100,
		schema: {
			model: {
				fields: clinicFields
			}
		},
		/*
		group: {
			field: "stage",
        },
        filter: {
        	field: "sample_type",
            operator: "eq",
            value: "Tumor"
        }
        */
	});
	
	$("#gridClinic").kendoGrid({
		dataSource: gridDataSource,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 400,
		pageable: true,
		selectable: "multiple",
		resizable: true,
		sortable: true,
		groupable: true,
		filterable: {
			mode: "menu"
        },
		columns: clinicColumns,
		//toolbar: ["excel"],
        excelExport: function(e) {
			e.workbook.fileName = "ClinicData.xlsx";
		}
	});
	//var grid = $("#gridClinic").data("kendoGrid");
	//grid.saveAsExcel();
	
	
	// group1 Grid
	var gridDataSource1 = new kendo.data.DataSource({
		data: orderData1,
		schema: {
			model: {
				fields: clinicFields
			}
		},

	});
	
	$("#grpGrid1").kendoGrid({
		dataSource: gridDataSource1,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 300,
		pageable: true,
		selectable: "multiple",
		resizable: true,
		sortable: true,
		/*
		scrollable: {
	        virtual: true
	    },
	    */
		/*
		filterable: {
			mode: "menu"
        },
        */
		columns: clinicColumns
	});
	
	
	// group2 Grid
	var gridDataSource2 = new kendo.data.DataSource({
		data: orderData2,
		schema: {
			model: {
				fields: clinicFields
			}
		},
	});
	
	$("#grpGrid2").kendoGrid({
		dataSource: gridDataSource2,
		dataBound: function(e) {
			var grid = e.sender;
			grid.unbind("dataBound");
		},
		height: 300,
		pageable: true,
		selectable: "multiple",
		resizable: true,
		sortable: true,
		/*
		filterable: {
			mode: "menu"
        },
        */
		columns: clinicColumns
	});
	
	$('#grpPanel2').removeClass('active');
	$('#grpPanel2').removeClass('show');
}

</script>


<!-- chart script -->
<c:if test="${searchVO.ud_idx ne 2}">
	<script>
		var dataType, dataSex, dataStage, dataMsi, dataRecur, dataAge, dataDFS, dataPathology;
		
		var valTypeN, valTypeT;
		var valSexM, valSexF;
		var valStage2, valStage3, valStage4, valStageNA; 
		var valMsiH, valMsiL, valMsiS, valMsiN;
		var valRecur0, valRecur1, valRecur9, valRecurNA;
		var valAge;
		var valDFS;
		var valPath;
		var valCnt;
		
		function selectChart(grp) {
			if (grp > 0) {
				$('#chartName').text('Group ' + grp);	
			} else {
				$('#chartName').text('All');
			}
			
			chartValue(grp);
			makeSeriesData();
			drawChart();
		}
		
		
		function initChartValue() {
			valTypeN = 0;	valTypeT = 0;
			valSexM = 0;	valSexF = 0;
			valStage2 = 0;	valStage3 = 0;	valStage4 = 0;	valStageNA = 0;	
			valMsiH = 0;	valMsiL = 0;	valMsiS = 0;	valMsiN = 0;
			valRecur0 = 0;	valRecur1 = 0;	valRecur9 = 0;	valRecurNA = 0;	
			valAge = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
			valDFS = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
			valPath = new Map();
		}
	
		function chartValue(grp) {
	
			var gridG;
			if (grp == 1) {
				gridG = $('#grpGrid1').data("kendoGrid");
			} else if (grp == 2) {
				gridG = $('#grpGrid2').data("kendoGrid");
			} else {
				gridG = $('#gridClinic').data("kendoGrid");
			}
			var dataG = gridG.dataSource.data();
			valCnt = dataG.length;
			initChartValue();
			
			for (i = 0; i < dataG.length; i++) {
				//console.log(dataG[i].sample_id);
				
				if (dataG[i].sample_type == 'Normal') {
					valTypeN++;
				} else if (dataG[i].sample_type == 'Tumor') {
					valTypeT++;
				}
				
				if (dataG[i].sex == 'M') {
					valSexM++;
				} else if (dataG[i].sex == 'F') {
					valSexF++;
				}
	 
				if (dataG[i].stage == '2') {
					valStage2++;
				} else if (dataG[i].stage == '3') {
					valStage3++;
				} else if (dataG[i].stage == '4') {
					valStage4++;
				} else if (dataG[i].stage == 'NA') {
					valStageNA++;
				}
				
				if (dataG[i].msi == 'MSI-H') {
					valMsiH++;
				} else if (dataG[i].msi == 'MSI-L') {
					valMsiL++;
				} else if (dataG[i].msi == 'MSS') {
					valMsiS++;
				} else if (dataG[i].msi == 'NA') {
					valMsiN++;
				}
				
				if (dataG[i].recur == '0') {
					valRecur0++;
				} else if (dataG[i].recur == '1') {
					valRecur1++;
				} else if (dataG[i].recur == '9') {
					valRecur9++;
				} else if (dataG[i].recur == 'NA') {
					valRecurNA++;
				}
	
				if (dataG[i].age_diag == null) {
					valAge[10]++;
				} else if (dataG[i].age_diag < 10) {
					valAge[0]++;
				} else if (10 <= dataG[i].age_diag && dataG[i].age_diag < 20) {
					valAge[1]++;
				} else if (20 <= dataG[i].age_diag && dataG[i].age_diag < 30) {
					valAge[2]++;
				} else if (30 <= dataG[i].age_diag && dataG[i].age_diag < 40) {
					valAge[3]++;
				} else if (40 <= dataG[i].age_diag && dataG[i].age_diag < 50) {
					valAge[4]++;
				} else if (50 <= dataG[i].age_diag && dataG[i].age_diag < 60) {
					valAge[5]++;
				} else if (60 <= dataG[i].age_diag && dataG[i].age_diag < 70) {
					valAge[6]++;
				} else if (70 <= dataG[i].age_diag && dataG[i].age_diag < 80) {
					valAge[7]++;
				} else if (80 <= dataG[i].age_diag && dataG[i].age_diag < 90) {
					valAge[8]++;
				} else if (90 <= dataG[i].age_diag) {
					valAge[9]++;
				} else {
					valAge[10]++;
				}
				
				if (dataG[i].dfs == null) {
					valDFS[11]++;
				} else if (dataG[i].dfs < 300) {
					valDFS[0]++;
				} else if (300 <= dataG[i].dfs && dataG[i].dfs < 600) {
					valDFS[1]++;
				} else if (600 <= dataG[i].dfs && dataG[i].dfs < 900) {
					valDFS[2]++;
				} else if (900 <= dataG[i].dfs && dataG[i].dfs < 1200) {
					valDFS[3]++;
				} else if (1200 <= dataG[i].dfs && dataG[i].dfs < 1500) {
					valDFS[4]++;
				} else if (1500 <= dataG[i].dfs && dataG[i].dfs < 1800) {
					valDFS[5]++;
				} else if (1800 <= dataG[i].dfs && dataG[i].dfs < 2100) {
					valDFS[6]++;
				} else if (2100 <= dataG[i].dfs && dataG[i].dfs < 2400) {
					valDFS[7]++;
				} else if (2400 <= dataG[i].dfs && dataG[i].dfs < 2700) {
					valDFS[8]++;
				} else if (2700 <= dataG[i].dfs && dataG[i].dfs < 3000) {
					valDFS[9]++;
				} else if (3000 <= dataG[i].dfs) {
					valDFS[10]++;
				} else {
					valDFS[11]++;
				}
				
				// Pathology
				var pathCnt = valPath.get(dataG[i].pathology);
				pathCnt = (pathCnt === undefined) ? 0 : pathCnt;
				valPath.set(dataG[i].pathology, ++pathCnt);
			}
		}
		
		function makeSeriesData() {
			dataType = [ {
				category : "Normal",
				value : valTypeN
			}, {
				category : "Tumor",
				value : valTypeT
			} ];
			
			dataSex = [ {
				category : "Male",
				value : valSexM
			}, {
				category : "Female",
				value : valSexF
			} ];
			
			dataStage = [ {
				category : "Stage 2",
				value : valStage2
			}, {
				category : "Stage 3",
				value : valStage3
			}, {
				category : "Stage 4",
				value : valStage4
			}, {
				category : "NA",
				value : valStageNA
			} ];
			
			dataMsi = [ {
				category : "MSI-H",
				value : valMsiH
			}, {
				category : "MSI-L",
				value : valMsiL
			}, {
				category : "MSS",
				value : valMsiS
			}, {
				category : "NA",
				value : valMsiN
			} ];
			
			dataRecur = [ {
				category : "0",
				value : valRecur0
			}, {
				category : "1",
				value : valRecur1
			}, {
				category : "9",
				value : valRecur9
			}, {
				category : "NA",
				value : valRecurNA
			} ];
			
			dataAge = valAge;
			
			dataDFS = valDFS;
			
			dataPathology = new Array();
			
			var pathItem;
			for (let [key, value] of valPath) {
				//console.log(key + ' = ' + value);
				var q1 = ((value/valCnt) * 100).toFixed(2) + '%';
				pathItem = {
					pathology : key,
					count : value,
					ratio : ((value/valCnt) * 100)
					
				}
				dataPathology.push(pathItem);
			}
		}
		
	
		function drawChart() {
			var seriesDefaults = {
		        labels: {
		            visible: false,
		            background: "transparent",
		            template: "#= category #: \n #= value#%"
		        }
		    };
			
			var chartLegend = {
				visible : true,
				position : 'bottom'
			};
			
			var chartTooltip = {
	            visible: true,
	            format: "{0}"
	        }
			
			$("#chartType").kendoChart({
				title: {
	                position: "bottom",
	                text: "Sample Type"
	            },
				series : [ {
					type : "pie",
					data : dataType
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
	
			$("#chartSex").kendoChart({
				title: {
	                position: "bottom",
	                text: "Sex"
	            },
				series : [ {
					type : "pie",
					data : dataSex
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartStage").kendoChart({
				title: {
	                position: "bottom",
	                text: "Stage"
	            },
				series : [ {
					type : "pie",
					data : dataStage
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartMsi").kendoChart({
				title: {
	                position: "bottom",
	                text: "Msi"
	            },
				series : [ {
					type : "pie",
					data : dataMsi
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartRecur").kendoChart({
				title: {
	                position: "bottom",
	                text: "Recur"
	            },
				series : [ {
					type : "pie",
					data : dataRecur
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartAge").kendoChart({
				title: {
	                position: "bottom",
	                text: "Age"
	            },
				series : [ {
					data : dataAge
				} ],
				categoryAxis : {
					categories : [ '~9', '10~', '20~', '30~', '40~', '50~',
							'60~', '70~', '80~', '90~', 'NA' ]
				}
			});
			
			$("#chartDFS").kendoChart({
				title: {
	                position: "bottom",
	                text: "DFS"
	            },
				series : [ {
					data : dataDFS
				} ],
				categoryAxis : {
					categories : [ '~300', '~600', '~900', '~1200', '~1500', '~1800',
							'~2100', '~2400', '~2700', '~3000', '3000~', 'NA' ]
				}
			});
			
			$("#chartPathology").kendoGrid({
	            dataSource: {
	                data: dataPathology,
	                schema: {
	                    model: {
	                        fields: {
	                        	pathology: { type: "string" },
	                        	count: { type: "number" },
	                        	ratio: { type: "number" },
	                        }
	                    }
	                }
	            },
	            height: 550,
	            scrollable: true,
	            sortable: true,
	            filterable: true,
	            /*
	            pageable: {
	                input: true,
	                numeric: false
	            },
	            */
	            columns: [
	            	{field: "pathology", title: "pathology", width: 220},
	        		{field: "count", title: "#", width: 70},
	        		{field: "ratio", title: "Freq", width: 80, format: "{0:0.00}%"},
	            ]
	        });
			
			var grid = $("#chartPathology").data("kendoGrid");
			grid.dataSource.sort({field: "ratio", dir: "desc"});
		}
		
	</script>
</c:if>
<c:if test="${searchVO.ud_idx eq 2}">
	<script>
		var dataTumor_tissue_site, dataHistological_type, dataGender, dataTissue_prospective, dataTissue_retrospective, dataAge_diagnosis;
		
		var valTumor_tissue_siteC, valTumor_tissue_siteR;
		var valHistological_typeCA, valHistological_typeCMA, valHistological_typeRA, valHistological_typeRMA;
		var valGenderM, valGenderF; 
		var valTissue_prospectiveY, valTissue_prospectiveN, valTissue_prospectiveNA;
		var valTissue_retrospectiveY, valTissue_retrospectiveN, valTissue_retrospectiveNA;
		var valAge_diagnosis;
		
		function selectChart(grp) {
			if (grp > 0) {
				$('#chartName').text('Group ' + grp);	
			} else {
				$('#chartName').text('전체');
			}
			
			chartValue(grp);
			makeSeriesData();
			drawChart();
		}
		
		
		function initChartValue() {
			valTumor_tissue_siteC = 0;	valTumor_tissue_siteR = 0;
			valHistological_typeCA = 0;	valHistological_typeCMA = 0;	valHistological_typeRA = 0;	valHistological_typeRMA = 0;
			valGenderM = 0;	valGenderF = 0; 
			valTissue_prospectiveY = 0;	valTissue_prospectiveN = 0;	valTissue_prospectiveNA = 0;
			valTissue_retrospectiveY = 0;	valTissue_retrospectiveN = 0;	valTissue_retrospectiveNA = 0;
			valAge_diagnosis = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
		}
	
		function chartValue(grp) {
	
			var gridG;
			if (grp == 1) {
				gridG = $('#grpGrid1').data("kendoGrid");
			} else if (grp == 2) {
				gridG = $('#grpGrid2').data("kendoGrid");
			} else {
				gridG = $('#gridClinic').data("kendoGrid");
			}
			var dataG = gridG.dataSource.data();
			valCnt = dataG.length;
			initChartValue();
			
			for (i = 0; i < dataG.length; i++) {
				//console.log(dataG[i].sample_id);
				
				if (dataG[i].tumor_tissue_site == 'Colon') {
					valTumor_tissue_siteC++;
				} else if (dataG[i].tumor_tissue_site == 'Rectum') {
					valTumor_tissue_siteR++;
				}
				
				if (dataG[i].histological_type == 'Colon Adenocarcinoma') {
					valHistological_typeCA++;
				} else if (dataG[i].histological_type == 'Colon Mucinous Adenocarcinoma') {
					valHistological_typeCMA++;
				} else if (dataG[i].histological_type == 'Rectal Adenocarcinoma') {
					valHistological_typeRA++;
				} else if (dataG[i].histological_type == 'Rectal Mucinous Adenocarcinoma') {
					valHistological_typeRMA++;
				}
	 
				if (dataG[i].gender == 'MALE') {
					valGenderM++;
				} else if (dataG[i].gender == 'FEMALE') {
					valGenderF++;
				}
				
				if (dataG[i].tissue_prospective_collection_indicator == 'YES') {
					valTissue_prospectiveY++;
				} else if (dataG[i].tissue_prospective_collection_indicator == 'NO') {
					valTissue_prospectiveN++;
				} else {
					valTissue_prospectiveNA++;
				}
				
				if (dataG[i].tissue_retrospective_collection_indicator == 'YES') {
					valTissue_retrospectiveY++;
				} else if (dataG[i].tissue_retrospective_collection_indicator == 'NO') {
					valTissue_retrospectiveN++;
				} else {
					valTissue_retrospectiveNA++;
				}
	
				if (dataG[i].age_at_initial_pathologic_diagnosis == null) {
					valAge_diagnosis[10]++;
				} else if (dataG[i].age_at_initial_pathologic_diagnosis < 10) {
					valAge_diagnosis[0]++;
				} else if (10 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 20) {
					valAge_diagnosis[1]++;
				} else if (20 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 30) {
					valAge_diagnosis[2]++;
				} else if (30 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 40) {
					valAge_diagnosis[3]++;
				} else if (40 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 50) {
					valAge_diagnosis[4]++;
				} else if (50 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 60) {
					valAge_diagnosis[5]++;
				} else if (60 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 70) {
					valAge_diagnosis[6]++;
				} else if (70 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 80) {
					valAge_diagnosis[7]++;
				} else if (80 <= dataG[i].age_at_initial_pathologic_diagnosis && dataG[i].age_at_initial_pathologic_diagnosis < 90) {
					valAge_diagnosis[8]++;
				} else if (90 <= dataG[i].age_at_initial_pathologic_diagnosis) {
					valAge_diagnosis[9]++;
				} else {
					valAge_diagnosis[10]++;
				}
				
				
			}
		}
		
		function makeSeriesData() {
			dataTumor_tissue_site = [ {
				category : "Colon",
				value : valTumor_tissue_siteC
			}, {
				category : "Rectum",
				value : valTumor_tissue_siteR
			} ];
			
			dataHistological_type = [ {
				category : "Colon Adenocarcinoma",
				value : valHistological_typeCA
			}, {
				category : "Colon Mucinous Adenocarcinoma",
				value : valHistological_typeCMA
			}, {
				category : "Rectal Adenocarcinoma",
				value : valHistological_typeRA
			}, {
				category : "Rectal Mucinous Adenocarcinoma",
				value : valHistological_typeRMA
			} ];
			
			dataGender = [ {
				category : "MALE",
				value : valGenderM
			}, {
				category : "FEMALE",
				value : valGenderF
			} ];
			
			dataTissue_prospective = [ {
				category : "YES",
				value : valTissue_prospectiveY
			}, {
				category : "NO",
				value : valTissue_prospectiveN
			}, {
				category : "NA",
				value : valTissue_prospectiveNA
			} ];
			
			dataTissue_retrospective = [ {
				category : "YES",
				value : valTissue_retrospectiveY
			}, {
				category : "NO",
				value : valTissue_retrospectiveN
			}, {
				category : "NA",
				value : valTissue_retrospectiveNA
			} ];
			
			dataAge_diagnosis = valAge_diagnosis;
			
			
		}
		
	
		function drawChart() {
			var seriesDefaults = {
		        labels: {
		            visible: false,
		            background: "transparent",
		            template: "#= category #: \n #= value#%"
		        }
		    };
			
			var chartLegend = {
				visible : true,
				position : 'bottom'
			};
			
			var chartTooltip = {
	            visible: true,
	            format: "{0}"
	        }
			
			$("#chartTumor_tissue_site").kendoChart({
				title: {
	                position: "bottom",
	                text: "Tumor tissue site"
	            },
				series : [ {
					type : "pie",
					data : dataTumor_tissue_site
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartHistological_type").kendoChart({
				title: {
	                position: "bottom",
	                text: "Histological type"
	            },
				series : [ {
					type : "pie",
					data : dataHistological_type
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartGender").kendoChart({
				title: {
	                position: "bottom",
	                text: "Gender"
	            },
				series : [ {
					type : "pie",
					data : dataGender
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartTissue_prospective").kendoChart({
				title: {
	                position: "bottom",
	                text: "Tissue prospective collection indicator"
	            },
				series : [ {
					type : "pie",
					data : dataTissue_prospective
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
			
			$("#chartTissue_retrospective").kendoChart({
				title: {
	                position: "bottom",
	                text: "Tissue retrospective collection indicator"
	            },
				series : [ {
					type : "pie",
					data : dataTissue_retrospective
				} ],
				seriesDefaults : seriesDefaults,
				tooltip : chartTooltip,
				legend : chartLegend
			});
	
			
			
			$("#chartAge_diagnosis").kendoChart({
				title: {
	                position: "bottom",
	                text: "Age at initial pathologic diagnosis"
	            },
				series : [ {
					data : dataAge_diagnosis
				} ],
				categoryAxis : {
					categories : [ '~9', '10~', '20~', '30~', '40~', '50~',
							'60~', '70~', '80~', '90~', 'NA' ]
				}
			});
			
			
		}
		
	</script>

</c:if>



<form id="groupForm" name="groupForm" action="${path}/mo/clinic/list_group_dtl_action.do" method="post">
	<input type="hidden" name="cg_idx" id="cg_idx" />
</form>

<form:form commandName="searchVO" method="get" name="submitForm" id="submitForm" action="${path}/mo/basic/list.do">
	<input type="hidden" name="grp1" id="grp1" />
	<input type="hidden" name="grp2" id="grp2" />
	<input type="hidden" name="newWs" id="newWs" value="Y"/>
	<input type="hidden" name="newWp" id="newWp" value="Y"/>
	<input type="hidden" name="std_idx" id="std_idx" value="0"/>
	<input type="hidden" name="cg_idx" id="s_cg_idx" value='0'/>
	<input type="hidden" id="s_saved" value='N'/>
	<input type="hidden" name="ud_idx" id="ud_idx" value="${searchVO.ud_idx }"/>
	
	
	

				<!-- title -->
				<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
					<div class="row">
						<div class="col-lg-6">
							<h3 class="card-title h3icn">Data selection</h3>
						</div>
						<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>Analysis<i class="fa fa-chevron-right ml-2 mr-2"></i>Data selection</div>
					</div>
				</div>
				<!-- //title -->
				
				<!-- 컨텐츠 영역 -->
				<div class="row">
					<section class="col-lg-12 ui-sortable">
						<div class="mt-3">
							<!-- contents start -->

							<!--  select group graph-->
							<div class="card">
								<div class="card-body">
									<div class="mb-2 ">
										<div class="btn-group ">
											<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Selet Group</button>
											<div class="dropdown-menu" x-placement="bottom-start" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(0px, 38px, 0px);">
												<a class="dropdown-item" href="#" onclick="selectChart(0); return false;">All Group</a>
												<a class="dropdown-item" href="#" onclick="selectChart(1); return false;">Group 1</a>
												<a class="dropdown-item" href="#" onclick="selectChart(2); return false;">Group 2</a>
											</div>
											
										</div>
										<span id="chartName" class="badge badge-secondary ml-2" style="width:80px; padding:0.6em; font-size: 100%; vertical-align: middle;">All</span>
									</div>
									
									<div id="chartWrapper">
										<div class="row mt-3 text-center">
											<c:if test="${searchVO.ud_idx ne 2}">
												<div class="col-lg-8 col-md-6">
													<div class="row text-center">
														<div class="col-lg-3 col-md-6">
															<div id="chartType" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
														</div>
														<div class="col-lg-3 col-md-6">
															<div id="chartSex" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
														</div>
														<div class="col-lg-3 col-md-6">
															<div id="chartStage" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
														</div>
														<div class="col-lg-3 col-md-6">
															<div id="chartMsi" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
														</div>
														<div class="col-lg-3 col-md-6">
															<div id="chartRecur" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
														</div>
														<div class="col-lg-4 col-md-12">
															<div id="chartAge" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
														</div>
														<div class="col-lg-5 col-md-12">
															<div id="chartDFS" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
														</div>
													</div>
												</div>
												<div class="col-lg-4 col-md-6">
													<div style="height: 600px; /*border: 1px solid #d9d9dc;*/">
														<div id="chartPathology">
														</div>
													</div>
												</div>
											</c:if>
											<c:if test="${searchVO.ud_idx eq 2}">
												<div class="col-lg-4 col-md-6">
													<div id="chartTumor_tissue_site" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
												</div>
												<div class="col-lg-4 col-md-6">
													<div id="chartHistological_type" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
												</div>
												<div class="col-lg-4 col-md-6">
													<div id="chartGender" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
												</div>
												<div class="col-lg-4 col-md-6">
													<div id="chartTissue_prospective" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
												</div>
												<div class="col-lg-4 col-md-6">
													<div id="chartTissue_retrospective" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
												</div>
												<div class="col-lg-4 col-md-6">
													<div id="chartAge_diagnosis" class="cchart k-chart" data-role="chart" style="position: relative;"></div>
												</div>
											</c:if>
													
										</div>
									</div>
								</div>
							</div>
							<!-- // select group graph-->
							
							<!--  Data Sets -->
							<div class="card">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i>Data Sets
									</h3>
								</div>
								
								<div class="card-body">
									<div id="gridWrapper" class="dataTables_wrapper dt-bootstrap4 mb-3">
										<div id="gridClinic"></div>
									</div>
									<!-- 버튼 -->
									<div class="row btn-area">
										<div class="col-lg-12 text-right">
											<div>
												<button type="button" id="clearFilterButton" class="btn btn-danger btn-sm"><i class="fas fa-redo-alt"></i>Reset filter</button>
												<button type="button" id="unselectButton" class="btn btn-danger btn-sm"><i class=" fas fa-redo-alt"></i>Reset selection</button>
												<button type="button" class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Add selection</button>
												<div class="dropdown-menu" x-placement="bottom-start" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(0px, 38px, 0px);">
													<a class="dropdown-item" href="#" onclick="addToGroup('1'); return false;">Group 1</a>
													<a class="dropdown-item" href="#" onclick="addToGroup('2'); return false;">Group 2</a>
												</div>
											</div>
										</div>
									</div>
									<!--//  버튼 -->
								</div>
							</div>
							<!--  // Data Sets -->
							
							<!--  데이터 세트 구성 -->
							<div id="groupPan" class="card mt-3">
								<div class="card-header">
									<h3 class="card-title">
										<i class="ion ion-clipboard mr-1"></i>Group List (dataset)
									</h3>
								</div>
								
								<div class="card-body">
									<!-- 
									<ul class="nav nav-tabs ">
										<li class="nav-item"><a class="nav-link active" href="#tab_1" data-toggle="tab">GROUP 1</a></li>
										<li class="nav-item"><a class="nav-link " href="#tab_2" data-toggle="tab">GROUP 2</a></li>
									</ul>
									 -->
									<ul class="nav nav-tabs" id="dataSetTab" role="tablist">
										<li class="nav-item" role="presentation">
											<a class="nav-link active" id="grpTab1" data-toggle="tab" href="#grpPanel1" role="tab">Group1</a>
										</li>
										<li class="nav-item" role="presentation">
											<a class="nav-link " id="grpTab2" data-toggle="tab" href="#grpPanel2" role="tab">Group2</a>
										</li>
									</ul>
									
									<div class="tab-content mt-3 mb-3" id="myTabContent">
										<div class="tab-pane active show" id="grpPanel1" role="tabpanel">
											<div id="gridWrapper1" class="dataTables_wrapper dt-bootstrap4">
												<div id="grpGrid1"></div>
											</div>
										</div>

										<div class="tab-pane active" id="grpPanel2" role="tabpanel">
											<div id="gridWrapper2" class="dataTables_wrapper dt-bootstrap4">
												<div id="grpGrid2"></div>
											</div>
										</div>
									</div>
									
									<!-- 버튼 -->
									<div class="row btn-area">
										<div class="col-lg-6 text-left">
											<div>
											
												<button type="button" class="btn btn-dark" onclick="showGroupSave();">Save Group</button>
												<button type="button" class="btn btn-dark" onclick="showGroupList();">Group List</button>
											</div>
										</div>
										<div class="col-lg-6 text-right">
											<div>
												<button type="button" class="btn btn-danger btn-sm" id="clearAllButton"><i class="fas fa-times"></i>Delete (All Group)</button>
												<button type="button" class="btn btn-danger btn-sm" id="clearButton"><i class="fas fa-times"></i>Delete (Selected Group)</button>
												<button type="button" class="btn btn-danger btn-sm" id="removeSelectedButton"><i class=" fas fa-times"></i>Delete (Selected)</button>
											</div>
										</div>
									</div>
									<!--//  버튼 -->
								</div>
							</div>
							<!--  // 데이터 세트 구성 -->
							
							<!-- 버튼 -->
							<div class="row btn-area">
								<div class="col-lg-12 text-right">
									<div>
										<!-- <button type="button" class="btn btn-dark" id="btnTest">TEST <i class="fas fa-chevron-right"></i></button> -->
										<button type="button" class="btn btn-dark" id="btnNext">Next <i class="fas fa-chevron-right"></i></button>
									</div>
								</div>
							</div>
							<!--//  버튼 -->
						<!-- // contents end -->
					
						</div>
					</section>
				</div>
			
						
						
				<!-- Modal -->
				<div class="modal fade" id="geneSetSelectionModal" tabindex="-1" role="dialog" aria-labelledby="geneSetSelectionModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="geneSetSelectionModalLabel">Select "Gene-Set"</h5>
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">×</span>
								</button>
							</div>
							<div class="modal-body">
								<div class="form-check">
									<input class="form-check-input" type="radio" name="geneSetType" id="selectGeneSet1" value="Single_Omics_Analysis" checked>
									<label class="form-check-label" for="selectGeneSet1">Single Omics analysis</label>
								</div>
								<div class="form-check mt-3">
									<input class="form-check-input" type="radio" name="geneSetType" id="selectGeneSet2" value="Add_Gene_Set">
									<label class="form-check-label" for="selectGeneSet2">Add gene Set</label>
								</div>
							
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Close</button>
								<button type="button" class="btn btn-success" id="btnSelectGeneset">Next <i class="fas fa-chevron-right"></i></button>
							</div>
						</div>
					</div>
				</div>						
			</form:form>	
	

<!-- Modal group 저장 -->
<div class="modal fade" id="groupSaveModal" tabindex="-1" role="dialog" aria-labelledby="groupSaveModalLabel" aria-hidden="true">
	<form id="createGroupForm" name="createGroupForm" action="${path}/mo/clinic/create_group_action.do" method="post">
		<input type="hidden" name="dtls" id="dtls" />
		<input type="hidden" name="cgNos" id="cgNos" />
		<input type="hidden" name="cg_type" id="cg_type" />
		<input type="hidden" name="ud_idx" id="cg_ud_idx" value="${searchVO.ud_idx }"/>
		
	
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="groupSaveModalLabel">Save Group</h5>
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
											<div class="col-12"><input type="text" class="form-control" name="cg_title" id="cg_title" placeholder="please enter the subject." maxlength="199"></div>
										</div>
									</td>
								</tr>
								
								<tr>
									<th>Comments</th>
									<td>
										<div class="row">
											<div class="col-12">
												<!-- <input type="text" class="form-control" name="cg_note" id="cg_note" placeholder="코멘트를 입력해주세요."  maxlength="1999"> -->
												<textarea class="form-control" name="cg_note" id="cg_note" placeholder="please enter a comment." maxlength="1999" style="height:150px; resize: none;"></textarea>

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
					<button type="button" class="btn btn-success" id="btnGroupSave">Save (Selected group) <i class="fas fa-chevron-right"></i></button>
					<button type="button" class="btn btn-success" id="btnGroup2Save">Save (All group) <i class="fas fa-chevron-right"></i></button>
				</div>
			</div>
		</div>
	</form>
</div>

<!-- Modal group 목록 -->
<div class="modal fade" id="groupListModal" tabindex="-1" role="dialog" aria-labelledby="groupListModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="groupListModalLabel">Group List</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="text-left mt-3">
					<table class="table table-bordered table-block">
						<colgroup>
							<col width="35%">
							<col width="35%">
							<col width="10%">
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

<!-- Modal group 중복 목록 -->
<div class="modal fade" id="groupDuplListModal" tabindex="-1" role="dialog" aria-labelledby="groupDuplListModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="groupDuplListModalLabel">Duplicated Group List</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="text-left mt-3">
					<table class="table table-bordered table-block">
						<colgroup>
							<col width="40%">
							<col width="45%">
							<col width="15%">
						</colgroup>
						
						<thead>
							<tr>
								<th>Title</th>
								<th>Comments</th>
								<th>Select</th>
							</tr>
						</thead>

						<tbody id="groupDuplListBody">
							<tr>
								<td colspan="3">No search results found.</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="clearfix"></div>
			
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Close</button>
				<button type="button" class="btn btn-success" id="btnNewGroupSave">Save (New Group) <i class="fas fa-chevron-right"></i></button>
			</div>
		</div>
	</div>
</div>

