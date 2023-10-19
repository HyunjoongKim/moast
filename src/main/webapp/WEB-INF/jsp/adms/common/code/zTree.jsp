<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/treegrid-dnd.js"></script> --%>
<!-- EASY UI  -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/jquery.numberbox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/validation.js"></script>
<!-- EASY UI  --> 

<!-- Z-TREE -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/zTree/css/zTreeStyle/zTreeStyle.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adms/popup_Layer.css?ver=3">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/zTree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/zTree/js/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/zTree/js/jquery.ztree.exedit.js"></script>
<!-- Z-TREE -->



<script type="text/javascript">
	var contextRoot ="${pageContext.request.contextPath}";
	var mainTableId = "#tg";
	var editingId; 
	var maxdepth = "${searchVO.maxdepth}";
	var codeCate ="${searchVO.code_cate}";	
	var setting = {
			view : {
				nameIsHTML: true,
				showTitle : true,
				expandSpeed:"",
				addHoverDom: addHoverDom,
				removeHoverDom: removeHoverDom,				
				selectedMulti: false				
			},
			edit: {
				enable: true
			},
			data : {
				key : {
					id : "id" 
				},
				simpleData : {
					enable : true,
					idKey : "id",
					pIdKey : "_parentId",
					rootPid : null
				}
			},
			callback: {
				beforeRemove: beforeRemove,
				beforeRename: beforeRename,
				beforeDrag: beforeDrag,
				beforeDrop: beforeDrop,
				onDrop : ZTreeOnDrop 
			}
		}	
	
	    // z-Tree 불러오기(setting값과 ajax로 받은 data)
		$(function(){ 
			 var trUrl = contextRoot+"/adms/common/code/list_ajax.do";  		
			 $.ajax({
				 type : 'post',
				 dataType : "json",
				 data : {"code_cate" : codeCate},
				 url : trUrl,
				 error : function(){
					 alert("Tree Load Fail, Try again");
				 },
				 success:function(data){				 
 
					 $.fn.zTree.init($("#tg"), setting, data).expandAll(true);
				 }
			 }); // ajax end	 			 
		}); 
		
	function beforeDrag(treeId, treeNodes) {
		for (var i=0,l=treeNodes.length; i<l; i++) {
			if (treeNodes[i].drag === false) {
				return false;
			}
		}
		return true;
	}
	
	
	// 드롭 전(부모 간 이동 막음)
	function beforeDrop(treeId, treeNodes, targetNode, moveType) {
    	    	
		if(targetNode.ptrn_code == treeNodes[0].ptrn_code && moveType != "inner"){
			return true;
		}else{
			if(targetNode.ptrn_code == treeNodes[0].ptrn_code){
				alert("드래그로 자식 생성을 할 수 없습니다.");	
			}else{
				alert("부모 간 이동은 할 수 없습니다.");
			}
			return false;
		}
		
	}
	
    function ZTreeOnDrop(event, treeId, treeNodes, targetNode, moveType) {    	    
    	
    	var treeObj = $.fn.zTree.getZTreeObj("tg");
    	var node = treeNodes[0].getParentNode();

/*     	var orderReSet = [];
    	var orderReSetName = [];
    	var orderReSetNum = []; */
    	var reSetSize = node.children.length;
    	    	
    	var mainArray = new Array();
    	var subObj = new Object();
    		
    	
    	for(var i=0;i<reSetSize;i++){
    		subObj = new Object();
/*     		orderReSet.push("code_idx", node.children[i].code_idx);
    		orderReSet.push("code_name", node.children[i].code_name);
    		orderReSet.push("ptrn_code", node.children[i].ptrn_code);
    		orderReSet.push("code_cate", node.children[i].code_cate);
    		orderReSet.push(node.children[i].code_idx);
    		orderReSetName.push(node.children[i].code_name);
    		orderReSetNum.push(i+1); */
    		
    		subObj["code_idx"] = node.children[i].code_idx;
    		subObj["code_cate"] = codeCate;
    		subObj["code_order"] = i+1;
    		
    		mainArray.push(subObj);
    		
    	}
    	
/*     	var allData = {"ptrn_code" : node.children[0].ptrn_code,
    				   "code_cate" : node.children[0].code_cate,
    				   "reSetArray" : orderReSet,
    				   "reSetArrayName" : orderReSetName,
    				   "reSetArrayOrderNum" : orderReSetNum}; */

    	$.ajax({ 
    		url : contextRoot+"/adms/common/code/list_ajax_changeOrder.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(mainArray),
	      	  dataType : "json",
	      	  async: false
	      	 }) 
	      	 .done(function(resMap) {
	      		var result = JSON.parse(resMap);
	      		if(result.res=="ok"){	      			
	      		}else{
	      			alert(result.msg);
	      		}
	      	 }) 
	      	 .fail(function(e) {  
	      		 alert("변경 시도에 실패하였습니다."+e);
	      	 }) 
	      	 .always(function() {});     	   	
	}//end function
	
	// Node 삭제
	function beforeRemove(treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("tg");
		zTree.selectNode(treeNode);		
		
		if(confirm("Confirm delete node '" + treeNode.name + "' it?")){
			
			// 추가한 노드 바로 삭제
			if(treeNode.id == "undefined" || treeNode.id == null){				
				zTree.removeNode(treeNode);				
			}else{
			
			 $.ajax({
				 type : 'post',
				 data : {"code_idx" : treeNode.id,
					     "code_cate" : treeNode.code_cate,
					     "main_code" : treeNode.main_code},
				 url : contextRoot+"/adms/common/code/deleteNode.do",
				 error : function(){
					 alert("Tree Delete Node Fail, Try again");
				 },
				 success:function(data){
					 
				 var result = JSON.parse(data);
				    // 자식이 있으면 삭제 불가
 					if(result.res == "error"){ 
 						alert(result.msg);
					}else{
						window.location.reload(); 
					} 
					 	
				 }
				 
			 }); // ajax end
			 
			} 
			 			
		}				
		return false;
	}	// end function	
	
	// node 수정
	function beforeRename(treeId, treeNode, newName) {				
		var re = false;	
		
		if (newName.length == 0) { // 입력한 것이 없으면
			setTimeout(function() {
				var zTree = $.fn.zTree.getZTreeObj("tg");
				zTree.cancelEditName();
				alert("Node name can not be empty.");
			}, 0);
			re = false;
		}else if(newName.length > 0){
		
  			 $.ajax({
				 type : 'post',
				 data : {"code_idx" : treeNode.id,
					     "code_cate" : treeNode.code_cate,
					     "code_name" : newName,
					     "ptrn_code" : treeNode.ptrn_code,
					     "gran_code" : treeNode.gran_code,
					     "code_depth" : treeNode.code_depth,
					     "code_order" : treeNode.code_order,
					     "code_use" : treeNode.code_use,
					     "code_etc" : treeNode.code_etc},
				 url : contextRoot+"/adms/common/code/createAndUpdate.do",
				 error : function(){
					 alert("Tree Update Node Fail, Try again");
				 },
				 success:function(data){				  
					 	
				 }
			 });   // ajax end	  			 
			 re = true;
		}
		
		return re;
	} // end function

	
	// Node 추가 수정필요
	var newCount = 1;
	function addHoverDom(treeId, treeNode) {
  
		var sObj = $("#" + treeNode.tId + "_span");
		if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
		var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
			+ "' title='add node' onfocus='this.blur();'></span>";
		sObj.after(addStr);
		var btn = $("#addBtn_"+treeNode.tId);
		if (btn) btn.bind("click", function(){
			//var zTree = $.fn.zTree.getZTreeObj("tg");
			
			$("#newCodePtrnIdx").val(treeNode.code_idx);
			$("#newCodeCate").val(codeCate);
			$("#newCodePtrnDepth").val(treeNode.code_depth);
			popOpen();
			//zTree.addNodes(treeNode, {name:"new node" + (newCount++)});			
		});
	};
	
	function removeHoverDom(treeId, treeNode) {
		$("#addBtn_"+treeNode.tId).unbind().remove();
	};	
				
	// 새 코드등록 layer 열기
	function popOpen(){
		if($("#popupwrap").css("display") == "none"){
			$("#popupwrap").show();
			$("#newCodeName").focus();
		}
	}
	
	function popClose(){	
		$("#popupwrap").hide();
		
		// NewCode value reset
		$("#newCodeName").val("");
		$("#newMainCode").val("");
		$("#newCodeEtc").val("");
		$("#newCodePtrnIdx").val("");
		$("#newCodeCate").val("");
		$("#newCodePtrnDepth").val("");		
	}	
	
	// New add Node
	function newCodeSave(){	
		var code_name = $("#newCodeName").val();
		var main_code = $("#newMainCode").val();
		var code_etc = $("#newCodeEtc").val();		
		var ptrn_code = $("#newCodePtrnIdx").val();
		var code_cate = $("#newCodeCate").val();
		var code_depth = Number($("#newCodePtrnDepth").val()) + 1;
		
		if(code_name == "" || code_name == null){
			alert("등록할 코드명을 입력해주세요");
			$("#newCodeName").focus();
			return false;
		}else if(main_code == "" || main_code == null){
			alert("등록할 코드을 입력해주세요");
			$("#newMainCode").focus();
			return false;			
		}else{ // node Save
	    	$.ajax({ 
	    		  url : contextRoot+"/adms/common/code/createAndUpdate.do", 
		      	  type: "POST", 
		      	  data:{"code_name" : code_name,
		      		    "main_code" : main_code,
		      		    "code_etc" : code_etc,
		      		    "ptrn_code" : ptrn_code,
		      		    "code_cate" : code_cate,
		      		    "code_use" : 'Y',
		      		    "code_depth" : code_depth}
		      	 }) 
		      	 .done(function(resMap) {
		      		alert("저장하였습니다.");
		    		window.location.reload();
		      	 }) 
		      	 .fail(function(e) {  
		      		 alert("변경 시도에 실패하였습니다."+e);
		      	 }) 
		      	 .always(function() {});  //end ajax	      	 
		} // if else end
	} // function end		
 
	</script>
	<style type="text/css">
	.ztree li span.button.add {margin-left:2px; margin-right: -1px; background-position:-144px 0; vertical-align:top; *vertical-align:middle}
	</style>





<h1>Editable Z-Tree [Z-Tree 테스트]</h1>
    <div style="margin:20px 0;">

    </div>

<!-- <table id="tg" class="ztree" style="width:800px;height:600px" ></table> -->

	<div style="width:300px;height:600px; overflow-x: scroll; overflow-y: scroll; background-color: white">
		<ui id="tg" class="ztree" ></ui>
	</div>	   

						
	<div id="popup">
	
	<div id="popupwrap" class="pop_wrap">	
	<div class="popconts" style="margin-top:15%;margin-left:25%;width:50%;">
    <div class="popupbak" style="text-align:center">    
    <div style="margin-bottom:20px;">
   	<a href="#" class="btn_close" onclick="javascript:popClose(); return false;">
		<img src="<c:url value='/img/btn_close.gif'/>" alt="팝업닫기"> 
	</a>
	</div>
	
	<input type="hidden" id="newCodePtrnIdx" >
	<input type="hidden" id="newCodeCate" >
	<input type="hidden" id="newCodePtrnDepth" >
	
    * Code_name : <input type="text" id="newCodeName" style="margin-right:20px;">
    * Main_code : <input type="text" id="newMainCode" style="margin-right:20px;">
    * Code_etc : <input type="text" id="newCodeEtc" style="margin-right:20px;">
    <input type="button" value="저장" onclick="javascript:newCodeSave(); return false;">
    <input type="button" value="취소" onclick="javascript:popClose(); return false;">        
    </div> 
    </div>
    </div>
    </div>			
			
    <script type="text/javascript">
        function formatProgress(value){
            if (value){
                var s = '<div style="width:100%;border:1px solid #ccc">' +
                        '<div style="width:' + value + '%;background:#cc0000;color:#fff">' + value + '%' + '</div>'
                        '</div>';
                return s;
            } else {
                return '';
            }
        }
        function admButtons(value){
                var s = '<a href=\'javascript:void(0);\'>수정</a> &nbsp; <a href=\'javascript:void(0);\'>삭제</a> ';
                return s;            
        } 
        
        function btnType1(rowId){
        	
        	//maxdepth
        	var value = "";
    	    var imgSrc =contextRoot+"/img/tree/";
    	    value += '<span class=\'treeBtnDiv\'>';
     	    if(rowId!='TEMP_9999999'){
     	    	//console.log( Number(getNodeByNodeId(rowId).code_depth)); 
     	    	if(Number(maxdepth) > Number(getNodeByNodeId(rowId).code_depth)){ //한계 뎁스보다 작으면 +표현
        	    	value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return addNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'add.png\" /></a>';
     	    	}
        	    value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return editNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'edit.png\" /></a>';
    	    }else{
    	    	value += 's'; 
    	    }
    	    //value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return deleteNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'delete.png\" /></a>';
    	    value += '</span>';
    	    return value; 
        }
        
        
        function btnType2(rowId){
        	
        	var value = "";
    	    var imgSrc =contextRoot+"/img/tree/";
    	    value += '<span class=\'treeBtnDiv\'>';
	        	value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return save(); return false;\'><img src=\"'+imgSrc+'S_BTN.png\" /></a>'; 
	    	    value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return cancel(); return false;\'><img src=\"'+imgSrc+'C_BTN.gif\" /></a>';
    	    value += '</span>';
    	    
    	    
        	  $(mainTableId).treegrid('update',{
              	id: rowId,
              	row: {
              		admField: value
              	}       
              });
        	  
        	  console.log(getNodeByNodeId(rowId)); 
        }
        
        function edit(){        	
            if (editingId != undefined){
                $(mainTableId).treegrid('select', editingId);
                return;
            }
            var row = $(mainTableId).treegrid('getSelected');
            
            btnType2(row.id); //버튼변환     
            
            if (row){
                editingId = row.id;
                $(mainTableId).treegrid('beginEdit', editingId);
            } 
              
        }
        
        function getRowIndex(target){
            var tr = $(target).closest('tr.datagrid-row');
            return parseInt(tr.attr('datagrid-row-index'));
        }
        
        function save(){
            if (editingId != undefined){
                var t = $(mainTableId);                        
                //========================== DATA 추출 ====================================
                var edNode = getNodeByNodeId(editingId);
                var code_idx = 0;   
               	 	if(edNode.code_idx!=undefined){code_idx = edNode.code_idx;}                
                var code_use=$(t.treegrid('getEditor',{id:editingId,field:'code_use'}).target).combobox('getValue');  
                
  				var main_code = edNode.main_code; 
  				if(code_idx==0){
  					main_code = $(t.treegrid('getEditor',{id:editingId,field:'main_code'}).target).textbox('getValue');
  				}
  				
  				var code_name = $(t.treegrid('getEditor',{id:editingId,field:'name'}).target).textbox('getValue');
  				var ptrn_code = edNode._parentId;
  				var code_depth = edNode.code_depth; 					
  				var code_order =$(t.treegrid('getEditor',{id:editingId,field:'code_order'}).target).numberbox('getValue');  
  				var code_etc = $(t.treegrid('getEditor',{id:editingId,field:'code_etc'}).target).textbox('getValue');  
  				//========================== DATA 추출 ====================================  				
  				if(main_code=="TEMP_CODE"){
  					alert("코드를 변경해 주세요. 필수사항입니다."); 
  					$(t.treegrid('getEditor',{id:editingId,field:'main_code'}).target).focus();
  					return false;
  				}
  				 
  				//========================== DATA 주입 ====================================
  				var data = "";
  				 data +="code_idx="+code_idx;
  				data +="&code_use="+code_use;
  				data +="&main_code="+main_code;
  				data +="&code_name="+code_name;
  				data +="&ptrn_code="+ptrn_code;
  				data +="&code_depth="+code_depth;  
  				data +="&code_order="+code_order;  	
  				data +="&code_etc="+code_etc;
  				data +="&code_cate="+codeCate;
  				//========================== DATA 주입 ====================================
  				//console.log(data); 
  				//return false; 
  				var url =contextRoot+"/adms/common/code/createAndUpdate.do";	
  				 
  				//========================== Ajax    ==================================== 	
                $.ajax({ 
                	  url:url,  
	       			  type: "POST",  
	       			  data:data,
				 }).done(function(result) {	
					 var result =JSON.parse(result);
			      	 if (result.res=="error"){
			      		alert(result.msg);
			      	 } 
				 }).fail(function(e) {  
					 alert("등록 시도에 실패하였습니다."+e.statusText);
				 }).always(function(e) { 
					 t.treegrid('endEdit', editingId);
		             editingId = undefined;
		      	 });  
  				 //========================== Ajax    ====================================
  			    
                
                
            }
        }
        function cancel(){
        	if(!confirm("현재 데이터수정작업을 취소 하시겠습니까?")){
        		return false;
        	} 
            if (editingId != undefined){
                $(mainTableId).treegrid('cancelEdit', editingId);
                editingId = undefined;
            }
        }
        function admField(row){ 
        	console.log(row.id);        
        }
        function addNode(rowId){
        	if (editingId != undefined){
        		return false;
        	}
        	var rnode = getNodeByNodeId(rowId);
        	var nextDepth =  Number(rnode.code_depth)+1;  
        	
        	console.log("nextDepth : "+nextDepth);
        	console.log("maxdepth : "+maxdepth); 
        	if(Number(maxdepth) < nextDepth){
        		alert("더이상 하위로 추가하실 수 없습니다.");
        		return false;
        	}
        	console.log("addNode");
        	$(mainTableId).treegrid('append',{ 
        		parent: rowId,
        		data: [{'id':'TEMP_9999999',main_code:'TEMP_CODE','name':'신규추가','code_depth':nextDepth,'code_use':'Y','code_order':100}]
        	}); 
        	$(mainTableId).treegrid('select', 'TEMP_9999999');
        	edit(); 
        } 
        
         function deleteNode(rowId){
        	if(!confirm("정말로 삭제하시겠습니까? 되돌릴 수 없습니다.")){
        		return false;
        	} 
        	 
        	var dNode = getNodeByNodeId(rowId);
        	if(dNode.children==undefined){
        		var code_idx = dNode.code_idx; 
        		var main_code = dNode.main_code;
        		
        		var url =contextRoot+"/adms/common/code/deleteNode.do";	
        		var data = "";
 				 data +="code_idx="+code_idx;
 				data +="&main_code="+main_code;
 				data +="&code_cate="+codeCate;
  				//========================== Ajax    ==================================== 	
                $.ajax({ 
                	  url:url,  
	       			  type: "POST",  
	       			  data:data,
				 }).done(function(result) {	
					 var result =JSON.parse(result);
			      	 if (result.res=="error"){
			      		alert(result.msg);
			      	 } 
				 }).fail(function(e) {  
					 alert("삭제시도에 실패하였습니다."+e.statusText);
				 }).always(function(e) { 
					 $(mainTableId).treegrid('reload'); //리로드
		      	 });  
  				 //========================== Ajax    ====================================
        		
        	}else{
        		alert("하위 자식이 있어 삭제할 수 없습니다.");
        		return false;
        	} 
        
        }
        
        function editNode(rowId){
        	if (editingId != undefined){
        		return false;
        	}
        	console.log("editNode");
        	$(mainTableId).treegrid('select', rowId);
        	edit(); 
        }
         
        function getNodeByNodeId(nodeId){
        	return $(mainTableId).treegrid('find', nodeId);
        }

    </script>