<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<style> 
<!--
input{border:1px solid red;}  
div.datagrid-cell table tr td sapn.textbox input.textbox-text{border:1px solid red;} 
-->
</style>

<!-- EASY UI  -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/jquery.numberbox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/validation.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/treegrid-dnd.js"></script>
<!-- EASY UI  --> 
<script type="text/javascript">
	var contextRoot ="${pageContext.request.contextPath}";
	var mainTableId = "#tg";
	var editingId; 
	var actionTarget = undefined;
	var maxdepth = "${searchVO.maxdepth}";
	var codeCate ="${searchVO.code_cate}"; 
		$(function(){ 
			var trUrl = contextRoot+"/adms/common/code/list_ajax.do"; 
			$(mainTableId).treegrid({
			   url : trUrl, 
			   method:'post', 
			   queryParams:{code_cate:codeCate},
		       idField:'id',
		       animate:false,
		       dnd:true, 
		     /* lines:true, */ 
		       treeField:'name', 
		       columns:[[
		           {title:'Task Name',field:'name',width:350,editor:'textbox'}, 
		           {field:'main_code',title:'현재코드',width:200,align:'center'}, 
		           {field:'admField',title:'관리',width:100,align:'right',formatter: function(value,row,index){ 
		        	    if(value==undefined){
		        	    	value=""; 
		        	    	value = btnType1(row.id);
		        	    } 
						return value;   
		        	   //admField(row);
				   }},		           
		           {field:'code_etc',title:'비고',width:120,align:'center',editor:'textbox'},
		           {field:'code_use',title:'사용여부',width:80, align:'center',
		        	   editor:{
                       type:'combobox',
	                       options:{
	                           valueField:'code',
	                           textField:'cname', 
	                           data:[{'code':'Y','cname':'Y'},{'code':'N','cname':'N'}],
	                           editable:false
	                           /* , 
		                           onChange:function(newValue, oldValue) {                                        
		                               ede = $("#tt").datagrid("getEditor", {index: 0, field:"kota"});
		                            //   alert(ede.toSource());
		                               $(ede.target).combobox("setValue", newValue-1);
		                               // getEditor
		                           } 
		           				*/
	                       }
                   	   }
		           }, 
		           {field:'code_depth',title:'단계',width:80,align:'center'},
		           {field:'code_order',title:'순번',width:80,align:'center',editor:'numberbox'}, 
		           {field:'_parentId',title:'부모코드',width:80,align:'center'},
		           {field:'code_idx',title:'idx',hidden:true} 
		       ]],
		        onBeforeEdit:function(row){
		        	row.editing = true;
		        	var col = $(this).treegrid('getColumnOption','main_code');		        	
		        	if(row.id=='TEMP_9999999'){ //신규일때만 에디터 모드
		        		col.editor = 'textbox';
		            }
		        	
		        	console.log('onBeforeEdit : '+row.editing);
		        },
		        onAfterEdit:function(row){
		            row.editing = false;		 
		            var col = $(this).treegrid('getColumnOption','main_code');		    	    
		        	if(row.id=='TEMP_9999999'){ //신규일때만 에디터 모드
		        		col.editor = '';		        		
		            }
		            $(mainTableId).treegrid('reload');		            
		            //console.log('onAfterEdit : '+row.editing);	
		        },
		        onCancelEdit:function(row){ 
		            row.editing = false;
		            console.log('onCancelEdit : '+row.editing);	
		            if(row.id=='TEMP_9999999'){
		            	$(mainTableId).treegrid('remove','TEMP_9999999');
		            }else{
		            	$(mainTableId).treegrid('update',{ 
		                  	id: row.id,
		                  	row: {
		                  		admField: btnType1(row.id)
		                  	}
		                 });
		            }
		        } ,
		        onLoadSuccess: function(row){
					//$(this).treegrid('enableDnd', row?row.id:null);
					if(actionTarget!=undefined){
						gridClose();
						expandTo(actionTarget);
					}
		        	actionTarget = undefined;
		        	
		        	$(this).treegrid('enableDnd', row?row.id:null);
		        	
				}, //-------------------- 2018-04-23 cms 기능추가 드래그앤드랍 순번 변경 -----------------------------
				onBeforeDrag:function(node){//클릭한순간
					
					if (editingId != undefined){//수정모드 시 드래그 막는다.
		                $(mainTableId).treegrid('select', editingId);
		                return false;
		            }
		        	//console.log("클릭한순간");
		        },
		        onDrop:function(target,source,point){//다른노드에 떨어 뜨린 후
		        	var targetNode =getNodeByNodeTarget(target.id);  //targetNode
		            var thsNode = source;
		        	var prtId = targetNode._parentId;
		        	
		        	var prtNode = getNodeByNodeId(prtId);
		        	var prtDepth = Number(prtNode.code_depth);
		        	var prtIdx = prtNode.code_idx; //부모키
					var nextDepth = prtDepth+1;
		        	var chidrenNodes = getChildrenTarget(prtIdx);
		        	
		        	console.log("nextDepth : " +nextDepth);
		        	var pass = true;
		        	var mainData = new Object();
		        	var mainArr  = new Array();
		        	var x =0;
		        	for(var i=0; i<chidrenNodes.length; i++){
		        		var childNode = chidrenNodes[i];
		        		if(nextDepth==childNode.code_depth){ 
			        		var tObj = new Object();		        		
		        			tObj["code_idx"] =childNode.code_idx;
		        			tObj["ptrn_code"]=prtIdx;
		        			tObj["code_order"] = x+1;
		        			tObj["code_cate"]=codeCate;		        			
			        		mainArr.push(tObj);
			        		x++;
		        		}
		        	}
		        	
		        	mainData = mainArr;
		        	var jsonData = JSON.stringify(mainData);
		        	
		        	
		        	 $.ajax({ 
			  			  url: contextRoot+"/adms/common/code/update_order.do",
			  			  type: "POST", 
			  			  contentType: "application/json;charset=UTF-8",
			  			  data:jsonData 
			  		 }).done(function(data) { 
			  			  //result = eval('('+data+')');
			  			  result = jQuery.parseJSON(data);	  			  
			  			  if(result.res=="error"){
			  				alert(result.msg);    
			  			  } 
			  		 }).fail(function(e) {  
			  			 alert("The attempt failed."+e);  // ENG908 // 시도에 실패하였습니다. 
			  		 }).always(function() {  
			  			//init = 0;
			  			$(mainTableId).treegrid("reload");  
			  		 });  
	        
		        	
		        	//console.log("다른노드에 떨어 뜨린 후");
		        },
		        onDragEnter:function(target, source){//다른 노드에 충돌 순간
		        	//console.log("다른 노드에 충돌 순간1");
		        },
		        onDragOver:function(target, source){//다른 노드에 충돌 순간 
		        	var node =getNodeByNodeTarget(target.id);
		            var depth = node.code_depth;
		            var ptrnTarget = node._parentId;
		            var ptrnSource = source._parentId;
		            var pass = true;
		            
		            //부모가 달라지면 막고
		            if(ptrnTarget!=ptrnSource){
		            	pass=false;
		            }
 		            
		    	    if(!pass){
		    	    	return false; 
		    	    } 
		            //console.log("다른 노드에 충돌 순간2");
		        },
		        onDragLeave:function(target, source){//다른 노드와 충돌후 나간순간
		        	//console.log("다른 노드와 충돌후 나간순간");
		        },
		        onBeforeDrop:function(target,source,point){//다른노드에 덜어뜨리기 전 
		        	if(!confirm("현재의 위치로 순번을 바꾸겠습니까?")){
		        		return false;
		        	}
		            
		        	if(target==null) return false;
		        	var node =getNodeByNodeTarget(target.id);
		            var depth = node.code_depth;
		            var ptrnTarget = node._parentId;
		            var ptrnSource = source._parentId;
		            var pass = true;
		            var msg = "";
		            
		           
		            
		            //하위 자식만들어지는거 막고
	            	if(point=="append"){
	            		msg = "드래그앤드랍으로 하위노드로 이동은 불가능합니다. 같은노드의 순서만 변경가능합니다.";
	            		pass=false;
	            	}
		            //부모가 달라지면 막고
		            if(ptrnTarget!=ptrnSource){
		            	msg = "드래그앤드랍으로 같은노드를 벗어나는것은 불가능합니다.";
		            	pass=false;
		            }
		            
		    	    //console.log("point :"+point + " :: depth :: " + node.code_depth + " :: pass :"+pass);
		    	    if(msg!=""){
		    	    	alert(msg);
		    	    }
		    	    
		    	    if(!pass){
		    	    	return false;
		    	    } 
		    	    
		    	    
		        	//console.log("다른노드에 덜어뜨리기 전 ");
		        }
			});
			
			//$(mainTableId).treegrid("expandAll");  //전체 열기   
			
			//span.textbox input.textbox-text
			//$(mainTableId).find("div.datagrid-cell table tr td sapn.textbox").css("background","green");
		}); 
				
		
		function getNodeByNodeTarget(target){
			return $(mainTableId).treegrid('find', target);
		}
		
		function getChildrenTarget(id){
			return $(mainTableId).treegrid('getChildren', id); 
		}
		
	</script>
<!-- 
<h1>Editable Tree</h1>
<p>Select one node and click edit button to perform editing.</p>
 -->
<!-- 
    <div style="margin:20px 0;">
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit()">Edit</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()">Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancel()">Cancel</a>
    </div>
 -->
 
 <div class="mb20" style="margin-top:15px">
	<a href="javascript:void(0);" class="btn btn-success btn-sm" onclick="gridOpen();"><spring:message code="btn.expandall" text="전체펼치기" /></a>
	<a href="javascript:void(0);" class="btn btn-dark btn-sm" onclick="gridClose();"><spring:message code="btn.collapseAll" text="전체접기" /></a> 
 </div>

<table id="tg" style="width:100%;height:800px" ></table> 
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
        	    if(Number(getNodeByNodeId(rowId).code_depth) > 0) {
        	    	value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return editNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'edit.png\" /></a>';
        	    }
    	    }else{
    	    	value += 's'; 
    	    }
     	   if(Number(getNodeByNodeId(rowId).code_depth) > 0) value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return deleteNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'delete.png\" /></a>';
    	    value += '</span>'; 
    	    return value;
        }
        
        
        function btnType2(rowId){
        	
        	var value = "";
    	    var imgSrc =contextRoot+"/img/tree/";
    	    value += '<span class=\'treeBtnDiv\'>';
        	value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return save(); return false;\'><img src=\"'+imgSrc+'ok.png\" /></a>'; 
    	    value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return cancel(); return false;\'><img src=\"'+imgSrc+'no.png\" /></a>';
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
  				var cdidx;
  				//========================== Ajax    ==================================== 	
                $.ajax({ 
                	  url:url,  
	       			  type: "POST",  
	       			  data:data,
	       			  async: false, 
				 }).done(function(result) {	
					 var result =JSON.parse(result);
			      	 if (result.res=="error"){
			      		alert(result.msg);
			      	 } 
			      	 
			      	actionTarget = result.cdidx;
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
        	
        	//console.log("nextDepth : "+nextDepth);
        	//console.log("maxdepth : "+maxdepth); 
        	if(Number(maxdepth) < nextDepth){
        		alert("더이상 하위로 추가하실 수 없습니다.");
        		return false;
        	}
        	//console.log("addNode");
        	
        	$childNode = getChildrenTarget(rowId);
        	//console.log($childNode);
        	var codeOrder =1;
        	if($childNode.length>0){
        		for(var k in $childNode){
        			
        			if(nextDepth==$childNode[k].code_depth){
        				codeOrder= $childNode[k].code_order;  //마지막 오더값이 담김
        			}
        		}
        		codeOrder+=1;
        	}
        	
        	$(mainTableId).treegrid('append',{ 
        		parent: rowId,
        		data: [{'id':'TEMP_9999999',main_code:'TEMP_CODE','name':'신규추가','code_depth':nextDepth,'code_use':'Y','code_order':codeOrder}]
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
        //=======================================================
        function gridOpen(){			
			$(mainTableId).treegrid('expandAll');
		}
		
		
		function gridClose(){
			var cIdx = "${cIdx}";
			$(mainTableId).treegrid('collapseAll');
			expandTo(cIdx);
		}
				
		function expandTo(tid){
			try{
				$(mainTableId).treegrid('expandTo',tid).treegrid('select',tid);
			}catch(e){console.log("parentid not found!")}
        }
    </script>