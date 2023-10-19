<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!-- EASY UI  -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/jquery.numberbox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/validation.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/treegrid-dnd.js"></script>
<!-- EASY UI  --> 
<style>
	.nav > li > a.on{color:#8258FA !important;} 
	
	.btncode {
	  border-radius: 2px;
	  padding: 7px 7px;
	}
	.btncode-xsmall {
	  padding: 2px 2px; 
	}
</style>
<script type="text/javascript">




    var site_code = "${siteCode}";
	var contextRoot ="${pageContext.request.contextPath}";
	var mainTableId = "#tg";
	var editingId; 
	var maxdepth ="${searchVO.maxdepth}";
	var actionTarget = undefined;
	
	var menuHeadCode = [{'code':'NOR','cname':'일반'},{'code':'TAB','cname':'탭'},{'code':'POP','cname':'팝업'}];
	var isboardCode  = [{'code':'N','cname':'프로그램'},{'code':'Y','cname':'게시판'},{'code':'C','cname':'컨텐츠'}];
	var menuHeadMap = new JqMap();
	var isboardMap = new JqMap();
	
	setCodeMap(menuHeadMap,menuHeadCode);
	setCodeMap(isboardMap,isboardCode);
	
	function setCodeMap(xmap,codeArr){
		for(var k in codeArr){
			var obj = codeArr[k];
			xmap.put(obj.code,obj.cname);			
		}		
	}

	
		$(function(){
			var trUrl = contextRoot+"/adms/common/menu/list_ajax.do?site_code="+site_code; 
			$(mainTableId).treegrid({
			   url : trUrl, 
			   method:'get',
		       idField:'id',		       
		       animate:false,
		       treeField:'name', 
		       dnd:true, 
		       columns:[[
		           {title:'메뉴명',field:'name',width:200,editor:'textbox',formatter: function(value,row,index){  
		        	   		        	   
		        	   if(row.menu_depth >= 4 ){ //최대 뎁스보다 크거나 같고  ..  2018-12-24 컨텐츠 관리도 권한 가능하게 조건문 삭제 && row.is_board!="C"
		        		    return '<a href=\'#\' data-toggle=\'modal\' data-target=\'#form3\' onclick=\'return openAuthDiv(\"'+row.id+'\"); return false;\' ><span style=\'color:#9A2EFE;\'>'+value+'</span></a>';    		   
			    	   }else{//#8258FA;			    		        
			    		   return '<span style=\'color:#585858;\'><strong>'+value+'</strong></span>';   
			    	   } 
				   }},   
		           {field:'menu_code',title:'메뉴코드',width:240},  
		           {field:'admField',title:'관리',width:70,align:'center',formatter: function(value,row,index){  
		        	    if(value==undefined){
		        	    	value=""; 
		        	    	value = btnType1(row.id);
		        	    }
						return value;   
		        	   //admField(row);
				   }},
				   {field:'lnk',title:'관리링크',width:90,align:'center',
	                   	  formatter: function(value,row,index){  
	                   		var imgSrc =contextRoot+'/img/icons/';
	                   		var lImg = '';
	                   		
	                   		if(row.menu_depth > 1){
	                   		
	                   			try{
	                   				if(row.is_board =='C'){
			                   			var idx =row.menu_code.split('/')[1];
			                   			var linkUrl =contextRoot+'/zboard/updateForm.do?lmCode=content1&isAdms=Y&pd_pkid='+idx;  
			                   			lImg='<a href=\"'+linkUrl+'\" target=\'_blank\' ><img src=\"'+imgSrc+'search.png\" />관리</a>';
	                   				}else if(row.is_board=='Y'){
	                   					var linkUrl =contextRoot+'/adms/board/boardManage/list.do';  
	                   					lImg='<a href=\"'+linkUrl+'\" target=\'_blank\' ><img src=\"'+imgSrc+'search.png\" />관리</a>';
	                   				}
	                   			}catch(e){console.log('관리링크 idx 추출 실패!');}
	                   		}
	                   		return lImg;
	  			   }},
		           {field:'menu_view',title:'노출',width:65,align:'center', 
		        	   editor:{
                       type:'combobox',
	                       options:{
	                           valueField:'code',
	                           textField:'cname', 
	                           data:[{'code':'Y','cname':'Y'},{'code':'N','cname':'N'}],
	                           editable:false
	                       }
                   	   }
		           },
		           {field:'menu_head',title:'노출타입',width:80,align:'center', 
		        	   editor:{
                       type:'combobox',
	                       options:{
	                           valueField:'code',
	                           textField:'cname', 
	                           data:menuHeadCode,
	                           editable:false
	                       }
                   	   },
                   	  formatter: function(value,row,index){  
	   		        	 return menuHeadMap.get(value);
 				     }
		           }, 
		           {field:'menu_target',title:'링크URL[클릭시이동]',width:380,align:'left',editor:'textbox',formatter: function(value,row,index){ 
		        	   try{
			        	    var imgSrc =contextRoot+'/img/icons/';
			        		var linkArr = value.split('/');
			        		var lImg ='';
			    			if(linkArr.length > 1 && row.menu_depth > 1){
			    				lImg='<img src=\"'+imgSrc+'search.png\" /></a>';
			    			}
			        		return '<a href=\'javascript:void(0)\'  onclick=\'return linkAction(\"'+value+'\"); return false;\' >'+value+lImg+'</a>'; 
		        	   }catch(e){
		        		   return '';
		        	   }
				   }},   
		           {field:'menu_depth',title:'단계',width:60,align:'center'}, 
		           {field:'menu_ordr',title:'순번',width:70,align:'center'},
		           {field:'_parentId',title:'부모코드',width:60,align:'center',hidden:true}, 
		           {field:'is_board',title:'메뉴타입',width:120,align:'center', 
		        	   editor:{ 
                       type:'combobox',
	                       options:{
	                           valueField:'code',
	                           textField:'cname', 
	                           data:isboardCode,
	                           editable:false,
	                           onChange:function(newValue, oldValue) { 
	                        	   if (editingId == undefined) return false;
	                        	   if (editingId != "TEMP_9999999") return false; 
	                        	   
	                        	   
    
		                   	        
	                        	   var t = $(mainTableId);	  
	                        	   //=============================== 초기  ======================================
	                        	    $(t.treegrid('getEditor',{id:editingId,field:'menu_code'}).target).textbox('setValue','TEMP_CODE');
		                   	        $(t.treegrid('getEditor',{id:editingId,field:'name'}).target).textbox('setValue','신규추가');
		                   	        $(t.treegrid('getEditor',{id:editingId,field:'menu_target'}).target).textbox('setValue','');
		                   	   	   //=============================== 초기  ======================================
	                        	   
	                        	   
                                   //2018-04-26일 작업 
								   if(newValue=="Y" || newValue=="C"){ 
									   $(t.treegrid('getEditor',{id:editingId,field:'menu_code'}).target).textbox('readonly',true);  
								   }else{
									   $(t.treegrid('getEditor',{id:editingId,field:'menu_code'}).target).textbox('readonly',false); 
								   }                                  
                               }
	                       }
                   	   },
                  	   formatter: function(value,row,index){  
   	   		        	 return isboardMap.get(value);
    				   }
		           },
		           {field:'adm',title:'게시판매칭',width:135,align:'center'}
		       ]]/* ,
		        rowStyler: function(index){ 
		    	   console.log(index.menu_depth);  
		    	   if(index.menu_depth == maxdepth){
		    		   return 'background-color:#FBEFEF;'; // return inline style		    		   
		    	   }
		        } */, 
		        onBeforeEdit:function(row){
		        	$("#RightSubDiv_R").remove();  //필수 지우기
		        	row.editing = true;
		        	var col = $(this).treegrid('getColumnOption','menu_code');		    	    
		        	if(row.id=='TEMP_9999999'){ //신규일때만 에디터 모드
		        		col.editor = 'textbox';		        		
		            } 
		        	
		        	console.log('onBeforeEdit : '+row.editing);
		        },onBeginEdit:function(row){       	
		        	if(row.id=='TEMP_9999999'){ //신규일때만 
		        		if(row.menu_depth < 4){ //1,2,3뎁스는 메뉴타입 선택 불가 
		        			var t = $(mainTableId);
		                	$(t.treegrid('getEditor',{id:row.id,field:'is_board'}).target).combobox('disable'); 
		        		}
		            } 		        	
		        	console.log('onBeginEdit : '+row.editing);
		        },
		        onAfterEdit:function(row){
		            row.editing = false;	
		            var col = $(this).treegrid('getColumnOption','menu_code');		    	    
		        	if(row.id=='TEMP_9999999'){ //신규일때만 에디터 모드
		        		col.editor = '';		        		
		            }
		            $(mainTableId).treegrid('reload');
		            console.log('onAfterEdit : '+row.editing);	
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
		        },onSelect:function(index){  
		        	//$("#RightSubDiv_R").remove();  
		        }, //-------------------- 2018-04-25 cms 기능추가 드래그앤드랍 순번 변경 -----------------------------
				onBeforeDrag:function(node){//클릭한순간
					 if (editingId != undefined){
			                $(mainTableId).treegrid('select', editingId);
			                return false;
			        }
		        },
		        onDrop:function(target,source,point){//다른노드에 떨어 뜨린 후
		        	var targetNode =getNodeByNodeTarget(target.id);  //targetNode
		            var thsNode = source;
		        	var prtId = targetNode._parentId;
		        	
		        	var prtNode = getNodeByNodeId(prtId);
		        	console.log(prtNode); 
		        	var prtDepth = Number(prtNode.menu_depth);
		        	var prtIdx = prtNode.menu_idx; //부모키
					var nextDepth = prtDepth+1;
		        	var chidrenNodes = getChildrenTarget(prtIdx);
		        	
		        	console.log("nextDepth : " +nextDepth);
		        	var pass = true;
		        	var mainData = new Object();
		        	var mainArr  = new Array();
		        	var x =0;
		        	for(var i=0; i<chidrenNodes.length; i++){
		        		var childNode = chidrenNodes[i];
		        		if(nextDepth==childNode.menu_depth){ 
			        		var tObj = new Object();		        		
		        			tObj["menu_idx"] =childNode.menu_idx;
		        			//tObj["ptrn_code"]=prtIdx;
		        			tObj["menu_ordr"] = x+1;
		        			//tObj["menu_name"]=childNode.menu_name;		        			
			        		mainArr.push(tObj);
			        		x++;
		        		}
		        	}
		        	
		        	mainData = mainArr;
		        	var jsonData = JSON.stringify(mainData);
		        	//console.log(jsonData);
		        	  
		        	$.ajax({ 
			  			  url: contextRoot+"/adms/common/menu/update_order.do",
			  			  type: "POST", 
			  			  contentType: "application/json;charset=UTF-8",
			  			  data:jsonData 
			  		 }).done(function(data) { 
			  			  //result = eval('('+data+')');
			  			  result = jQuery.parseJSON(data);	  			  
			  			  if(result.res=="error"){
			  				alert(result.msg);    
			  			  } 			  			  
			  			  actionTarget = source.menu_idx; 
			  			  console.log("source._parentId : "+actionTarget);
			  		 }).fail(function(e) {  
			  			 alert("The attempt failed."+e);  // ENG908 // 시도에 실패하였습니다. 
			  		 }).always(function() {  
			  			//init = 0;
			  			$(mainTableId).treegrid("reload");  
			  		});  
	         		
		        	
		        	//console.log("다른노드에 떨어 뜨린 후");
		        },
		        onLoadSuccess: function(row){
		        	if(actionTarget!=undefined){
						gridClose();
						expandTo(actionTarget);
					}
		        	actionTarget = undefined;
		        	
		        	$(this).treegrid('enableDnd', row?row.id:null);		        	
				},
		        onDragEnter:function(target, source){//다른 노드에 충돌 순간
		        	
		        },
		        onDragOver:function(target, source){//다른 노드에 충돌 순간 
		        	var node =getNodeByNodeTarget(target.id);
		            var depth = node.menu_depth;
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
		            var depth = node.menu_depth;
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
		            
		    	    //console.log("point :"+point + " :: depth :: " + node.menu_depth + " :: pass :"+pass);
		    	    if(msg!=""){
		    	    	alert(msg);
		    	    }
		    	    
		    	    if(!pass){
		    	    	return false;
		    	    } 
		    	    
		    	    
		        	//console.log("다른노드에 덜어뜨리기 전 ");
		        }
		        /* ,onDblClickRow:function(index,row){ 
		        	alert(index);   //
		        } */
			}); 
			 
			
			 
			//$(mainTableId).treegrid("expandAll");  //전체 열기   
			
		}); 
		
		function linkAction(val){
			var linkArr = val.split("/");
			if(linkArr.length > 1 ){
				var newWindow = window.open("about:blank");
				newWindow.location.href = contextRoot+val;
			}else{
				return false;
			}
		}
		function gridOpen(){			
			$(mainTableId).treegrid('expandAll');
		}
		
		
		
		function gridClose(){
			$(mainTableId).treegrid('collapseAll');
			expandTo(22);
			/* 
			var cIdx = "${cIdx}";
			$(mainTableId).treegrid('collapseAll');
			expandTo(cIdx);
			 */
		}
				
		function expandTo(tid){
			console.log("expandTo tid :"+tid); 
			try{
				$(mainTableId).treegrid('expandTo',tid).treegrid('select',tid);
			}catch(e){console.log("parentid not found!")}
        }
		
		
		function getNodeByNodeTarget(target){
			return $(mainTableId).treegrid('find', target);
		}
		
		function getChildrenTarget(id){
			return $(mainTableId).treegrid('getChildren', id); 
		}
		
		
		
		//--------------- 2018-04-26 cms 기능 개선 게시판 및 컨텐츠 매칭 ------------------------
        function openBoard(rowId){
        	
        	var t = $(mainTableId);                 
        	var $bd = $(t.treegrid('getEditor',{id:rowId,field:'is_board'}).target);
            var is_board=$bd.combobox('getValue');
            if(is_board!="Y"){
            	alert("메뉴타입이 게시판 상태여야 합니다.");
            	$bd.focus(); 
            	return false;
            }
            
            BoardModal.init($("div#Dummy1 table").clone());
            BoardModal.getBoard();
            $('#RightSubBoardDiv').modal('toggle'); 
            
        }
        
        function openContent(rowId){
        	var t = $(mainTableId);     
        	var $bd = $(t.treegrid('getEditor',{id:rowId,field:'is_board'}).target);
            var is_board=$bd.combobox('getValue');
            if(is_board!="C"){
            	alert("메뉴타입이 컨텐트 상태여야 합니다."); 
            	$bd.focus();
            	return false; 
            }
            BoardModal.init($("div#Dummy2 table").clone());
            BoardModal.getContents();
            $('#RightSubBoardDiv').modal('toggle'); 
            
        }
        
        
        //게시판 가져오기 모달 처리부분
        var BoardModal ={
        		init : function($cTable){ 
        			var $tb = $('#RightSubBoardDiv table');
        			//================ head init =====================
        			$tb.find("thead tr").remove();
        			$tb.find("thead").append($cTable.find("thead tr"));
        			//================ head init =====================
        				
        			//================ body init =====================
        			$tb.find("tbody tr").remove();        			
        			//================ body init =====================
        		},//------------------------ 게시판 부르기 ------------------------------
        		getBoard :function(){
        			 $.ajax({ 
       				  url: contextRoot+"/adms/common/menu/list_board.do", 
       				  type: "GET"
       				 }).done(function(data) { 
       					 var result =JSON.parse(data);        						
       			      	 if (result.res=="ok"){
       			      		makeBoardRow(result.rows);
       			      	 }
       			      	
       				 }).fail(function(e) {  
       					 alert("시도에 실패하였습니다."+e);
       				 }).always(function() { }); 
        		},
        		boardSelect :function(ths){
        			$('#RightSubBoardDiv').modal('toggle'); 
        			var $ths = $(ths);
        			var dtitle =$ths.parents("tr").find(".dtitle").html();
        			var dcode  =$ths.parents("tr").find(".dcode").html();
        			//make url sample => /zboard/list.do?lmCode=free
        			var alnkUrl = "/zboard/list.do?lmCode="+dcode;
        			
        			
        			//var row = $(mainTableId).treegrid('getSelected'); 
        			var t = $(mainTableId);     
        	        $(t.treegrid('getEditor',{id:editingId,field:'menu_code'}).target).textbox('setValue',dcode);
        	        $(t.treegrid('getEditor',{id:editingId,field:'name'}).target).textbox('setValue',dtitle);
        	        $(t.treegrid('getEditor',{id:editingId,field:'menu_target'}).target).textbox('setValue',alnkUrl); 
        		},//------------------------ 이하 컨텐츠 ------------------------------
        		getContents :function(){
        			 $.ajax({ 
       				  url: contextRoot+"/adms/common/menu/list_contents.do", 
       				  type: "GET"
       				 }).done(function(data) { 
       					 var result =JSON.parse(data);        						
       			      	 if (result.res=="ok"){
       			      		makeContentRow(result.rows);
       			      	 }
       			      	
       				 }).fail(function(e) {  
       					 alert("시도에 실패하였습니다."+e);
       				 }).always(function() { });
        		},
        		contentSelect :function(ths){
        			$('#RightSubBoardDiv').modal('toggle'); 
        			var $ths = $(ths);
        			var dtitle =$ths.parents("tr").find(".dtitle").html();
        			var dcode  =$ths.parents("tr").find(".dcode").html();
        			var pd_pkid = $ths.parents("tr").find("input[name='pd_pkid']").val();
        			//make url sample => /zboard/list.do?lmCode=free
        			var alnkUrl = "/contents/read.do?lmCode="+dcode+"&pd_pkid="+pd_pkid;
        			
        			
        			//var row = $(mainTableId).treegrid('getSelected'); 
        			var t = $(mainTableId);     
        	        $(t.treegrid('getEditor',{id:editingId,field:'menu_code'}).target).textbox('setValue',dcode+"/"+pd_pkid); 
        	        $(t.treegrid('getEditor',{id:editingId,field:'name'}).target).textbox('setValue',dtitle);
        	        $(t.treegrid('getEditor',{id:editingId,field:'menu_target'}).target).textbox('setValue',alnkUrl); 
        		}
        }
        
        
        
        
        function makeBoardRow($rows){
        	
        	var $tbody = $("#DataTbody");
        	var x = 1;
        	for(var k in $rows){
        		var $dTr= $("div#Dummy1 table tbody tr").clone();
        		var obj = $rows[k];
        		var au_title =obj.au_title;
        		var ag_code  =obj.ag_code;
        		//dnum dtitle dcode
        		$dTr.find(".dnum").html(x);
        		$dTr.find(".dtitle").html(au_title); 
        		$dTr.find(".dcode").html(ag_code);
        		
        		$tbody.append($dTr);  
        		x++;
        	}
        	
        }
        function makeContentRow($rows){
        	var $tbody = $("#DataTbody");
        	var x = 1;
        	
        	for(var k in $rows){
        		var $dTr= $("div#Dummy2 table tbody tr").clone();
        		var obj = $rows[k];
        		var pd_title =obj.pd_title;
        		var pd_code  =obj.pd_code;
        		var pd_pkid  =obj.pd_pkid;
        		//dnum dtitle dcode
        		$dTr.find(".dnum").html(x);
        		$dTr.find(".dtitle").html(pd_title); 
        		$dTr.find(".dcode").html(pd_code); 
        		$dTr.find("input[name='pd_pkid']").val(pd_pkid);
        		
        		
        		$tbody.append($dTr);  
        		x++;
        	}
        }
        //--------------- 2018-04-26 cms 기능 개선 게시판 및 컨텐츠 매칭 ------------------------
        
        
		
		
	</script>




<!-- 
    <div style="margin:20px 0;">
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit()">Edit</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()">Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancel()">Cancel</a>
    </div>
     -->
     
     


<p class="fts18 ftbold text-success">* <spring:message code="site.auth.txt" text="메뉴명 클릭시 권한 부여 세팅 시작" /></p>
<div class="navbar navbar-inverse">
	<div class="tap container-fluid"">
		<ul class="nav navbar-nav">
			<c:forEach var="svo" items="${siteList}" >
				<li id="li_1">  
					<a href="${pageContext.request.contextPath}/adms/common/menu/list.do?site_code=${svo.site_code}" 
					    <c:if test="${siteCode eq svo.site_code}"> class="on" </c:if>>
						${svo.ts_title}
					</a>
				</li>
			</c:forEach>
	    </ul> 
	</div>
</div>


<div class="mt20 mb15" >
	<a href="javascript:void(0);" class="btn btn-success btn-sm" onclick="gridOpen();"><spring:message code="btn.expandall" text="전체펼치기" /></a>
	<a href="javascript:void(0);" class="btn btn-dark btn-sm" onclick="gridClose();"><spring:message code="btn.collapseAll" text="전체접기" /></a> 
</div>

<table id="tg" style="width:100%;height:800px" ></table> 

<!--  RIGHTLIST -->
<div id="RightMainDiv" style="float:left;padding-left:15px;padding-top:30px;" >   
</div> <!-- RightMainDiv -->

<div id="RightSubDiv">
	<form id="form3" name="form3" action="" onsubmit="return _submit(this); return false;" class="modal fade"  tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none">
	<input type="hidden" name="menu_idx" value="" />
	<div class="modal-dialog" style="width:55%">
		<div class="modal-content">	
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h3 class="modal-title" id="custom-width-modalLabel">권한 행동 등록 관리</h3>
			</div>
	
			<div class="modal-body">
				<div class="table-responsive">
					<table id="datatable-scroller" class="table table-striped table-bordered text-center">
						<thead>
							<tr>
								<th>권한명</th>  
								<c:forEach var="rMap" items="${RIGHTLIST}" >
									<th><label for="VTC_${rMap.key}"> ${rMap.value} </label>
									<input type="checkbox" id="VTC_${rMap.key}" name="CHECK_ALL_VTC" value="${rMap.key}" onclick="checkVTC(this);"/>
									</th>  
								</c:forEach>
								<!-- <th>TEMP</th>  --> 
							</tr>
						</thead>
						<tbody>
						<!-- authList -->
						<c:forEach var="aList" items="${authList}" >
							<tr id="tr_${aList.auth_idx}">
							<input type="hidden" id="auth_idx_${aList.auth_idx}" name="auth_idx" value="${aList.auth_idx}"/>
							<input type="hidden" name="auth_code" value="${aList.auth_code}"/>
								<th style="text-align:right;">
									<label for="HRZ_${aList.auth_idx}">${aList.auth_title}</label> 
									<input type="checkbox" id="HRZ_${aList.auth_idx}" name="CHECK_ALL_HRZ" value="${aList.auth_idx}" onclick="checkHRZ(this);"/>
								</th> 
							<c:forEach var="rMap" items="${RIGHTLIST}" >
								<td id="td_${aList.auth_idx}" class="${rMap.key}">
									<input type="checkbox" name="${rMap.key}" value="Y" />
								</td>  
							</c:forEach>
								<!-- <td>TEMP</td>  -->
							</tr> 
						</c:forEach>	
						</tbody> 
					</table>
				</div>
			</div>
			<div class="modal-footer" style="text-align:center">
				<input type="submit" value="저장" class="btn btn-dark btn-lg" /> 
			</div>
		</div>
	</div>
	</form>
</div>







<div id="RightSubBoardDiv" class="modal fade"  tabindex="-1" role="dialog" aria-labelledby="custom-width-modalLabel" aria-hidden="true" style="display: none">
	

	<div class="modal-dialog" style="width:55%">
		<div class="modal-content">	
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h3 class="modal-title" id="custom-width-modalLabel">게시판리스트</h3>
			</div>
	
			<div class="modal-body">
				<div class="table-responsive">
					<table id="datatable-scroller" class="table table-striped table-bordered text-center">
						<thead>
							<tr>
								<th>순번</th>  
								<th>게시판명</th>  
								<th>게시판코드</th>
								<th>선택</th>
							</tr>
						</thead>
						<tbody id="DataTbody">
							<tr>
								<td class="dnum">1234</td>
								<td class="dtitle">1234</td>
								<td class="dcode">5678</td>
								<td class="dselect">
									<a ref="javascript:void(0);" class="btncode btn-primary btncode-xsmall" onclick="" >선택</a>
								</td>
							</tr>
						</tbody> 
					</table>
				</div>
			</div>
			
		</div>
	</div>

</div>

<div id="Dummy1" style="display: none">
	<table >
		<thead>
			<tr>
				<th>순번</th>  
				<th>게시판명</th>  
				<th>게시판코드</th>
				<th>선택</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="dnum">1234</td>
				<td class="dtitle">1234</td>
				<td class="dcode">5678</td>
				<td class="dselect">
					<a href="javascript:void(0);" class="btncode btn-success btncode-xsmall" onclick="BoardModal.boardSelect(this);" >선택</a>
				</td>
			</tr>
		</tbody> 
	</table>
</div>

<div id="Dummy2" style="display: none">
	<table >
		<thead>
			<tr>
				<th>순번</th>  
				<th>컨텐츠명</th>  
				<th>코드</th>
				<th>선택</th>
			</tr>
		</thead>
		<tbody>
			<tr>  
				<input type="hidden" name="pd_pkid" value="" />
				<td class="dnum">1234</td>
				<td class="dtitle">1234</td>
				<td class="dcode">5678</td>
				<td class="dselect"><a href="javascript:void(0);" class="btncode btn-primary btncode-xsmall" onclick="BoardModal.contentSelect(this);">선택</a></td>
			</tr>
		</tbody> 
	</table>
</div>



<script type="text/javascript">
    	function checkVTC(ths){   
    		$("#RightSubDiv_R").find("table").find("input[name="+ths.value+"]").each(function(){    			
    			if($(ths).is(":checked")){
    				$(this).prop("checked",true); 
    			}else{ 
    				$(this).prop("checked",false);
    			}
    		});
    	}
    	
    	
    	function checkHRZ(ths){
    		$("#RightSubDiv_R").find("table tbody").find("#tr_"+ths.value).find("td input[type='checkbox']").each(function(){
    			if($(ths).is(":checked")){
    				$(this).prop("checked",true); 
    			}else{ 
    				$(this).prop("checked",false);
    			}
    		});
    		
    	}
    	
    	
    	function _submit($ths){
    		
    		if(!confirm("권한을 등록하시겠습니까?")){
    			return false; 
    		}
    		
    		var mainObj = new Object();
    		var subArry = new Array();
    		var menu_idx = $("#RightSubDiv_R").find("input[name=menu_idx]").val();
    		$("#RightSubDiv_R").find("table tbody tr").each(function(index){ 
    			var subObj = new Object();
    			subObj["auth_idx"]= $(this).find("input[name=auth_idx]").val(); 
    			subObj["menu_idx"]= menu_idx; 
    			subObj["auth_code"]= $(this).find("input[name=auth_code]").val();
    			$(this).find("td").each(function (){
    				var inputName = $(this).find("input[type=checkbox]").attr("name");
    				if(inputName!=undefined && inputName!="CHECK_ALL_HRZ"){    					
    					
    					var tfVal = $(this).find("input[name="+inputName+"]").is(":checked");
    					if(tfVal){
    						subObj[inputName] ="Y";
    					}else{
    						subObj[inputName] ="N";
    					}
    				}
    			});
    			
    			subArry.push(subObj);
    		});
    		mainObj.rData = subArry;
    		mainObj.menuIdx = menu_idx;
    		mainObj.site_code = site_code;
    		//console.log(JSON.stringify(mainObj)); 
    		
    		
    		
    		//-----------------------------------------------------------------------
    		 $.ajax({ 
			  url: contextRoot+"/adms/common/menu/create_right.do", 
			  type: "POST", 
			  contentType: "application/json;charset=UTF-8",
			  data:JSON.stringify(mainObj)
			 }).done(function(data) { 
				 var result =JSON.parse(data); 
		      	 //if (result.res=="error"){
		      	 alert(result.msg);
		      	 //} 
		      	openAuthDiv(menu_idx); //창 갱신
			 }).fail(function(e) {  
				 alert("등록에 시도에 실패하였습니다."+e);
			 }).always(function() { 
				 pass =  false;
			 }); 
    		//-----------------------------------------------------------------------
    		return false;
    	}
    	
    	
    	function makeRightCheck($cDiv,$GresList){
  			for(var k in $GresList){
  				var trStr ="tr_";
  				var authIdx = $GresList[k].auth_idx;
  				var $tr = $cDiv.find("table tbody").find("#"+trStr+authIdx); 
  				$tr.find("td").each(function() {
  					var inputName = $(this).attr("class");
  					if(inputName !=undefined){
  						//console.log($GresList[k][inputName]);
  						if($GresList[k][inputName]=="Y"){
  							$(this).find("input[name="+inputName+"]").attr("checked",true); 
  						}
  					}
  				});  				
  			}
    	}
    	
    	
    	
		function openAuthDiv(rowId){
			
			$("#RightSubDiv_R").remove();		
			var url = contextRoot+"/adms/common/menu/list_right_ajax.do"; 
			var data = "";
			data +="menu_idx="+rowId;
			data +="&site_code="+site_code;
			
			//console.log(data);   
			var $GresList = null; 
			//-----------ajax---------------
			$.ajax({ 
               	  url:url,  
       			  type: "POST",  
       			  data:data,
       			  async:false,
			 }).done(function(result) {	
				 var result =JSON.parse(result);
		      	 if (result.res=="error"){
		      		alert(result.msg);
		      	 }
		      	 if(result.rightList!=undefined){
		      		$GresList = result.rightList;
		      	 }
			 }).fail(function(e) {  
				 alert("권한 가져오기에 실패하였습니다."+e.statusText);
			 }).always(function(e) {});  
			//-----------ajax---------------
			
				
			
			var $cDiv = $("#RightSubDiv").clone();			
			//------------set---------------
			$cDiv.attr("id","RightSubDiv_R");	
			$cDiv.find("input[name=menu_idx]").val(rowId);
			makeRightCheck($cDiv,$GresList);// 체크박스및 여타 set 이어서
			//------------set---------------
			
			
			$("#RightMainDiv").append($cDiv);
			$("#RightSubDiv_R").show(300); 
			
		}    
    
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
     	    	//console.log( Number(getNodeByNodeId(rowId).menu_depth)); 
     	    	if(Number(maxdepth) > Number(getNodeByNodeId(rowId).menu_depth)){ //한계 뎁스보다 작으면 +표현
        	    	value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return addNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'add.png\" /></a>';
     	    	}
     	    	if(Number(getNodeByNodeId(rowId).menu_depth) > 1) {
        	   	 value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return editNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'edit.png\" /></a>';
     	    	}
    	    }else{
    	    	value += 's'; 
    	    }
     	   var dNode = getNodeByNodeId(rowId);
     	   if(dNode.children==undefined && Number(getNodeByNodeId(rowId).menu_depth) > 1){
    	    	value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return deleteNode(\"'+rowId+'\"); return false;\'><img src=\"'+imgSrc+'delete.png\" /></a>';
     	   } 
    	    value += '</span>';
    	    return value; 
        }
        
        
        function btnType2(rowId){
        	
        	console.log(rowId);
        	var value = "";
    	    var imgSrc =contextRoot+"/img/tree/";
    	    	value += '<span class=\'treeBtnDiv\'>';
	        	value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return save(); return false;\'><img src=\"'+imgSrc+'ok.png\" /></a>'; 
	    	    value += '&nbsp;<a href=\'javascript:void(0);\' onclick=\'return cancel(); return false;\'><img src=\"'+imgSrc+'no.png\" /></a>';
    	    	value += '</span>';
    	    var value2 ="";
    	    var row = getNodeByNodeId(rowId);
    	    	if(rowId=="TEMP_9999999" && (row.menu_depth >= 4)){//등록때만 필요  
    	    		//return '<a href=\'#\' data-toggle=\'modal\' data-target=\'#form3\' onclick=\'return openAuthDiv(\"'+row.id+'\"); return false;\' ><span style=\'color:#8258FA;\'>'+value+'</span></a>';
	    	    	value2 += '<span class=\'treeBtnDiv\'>';
		        	value2 += '&nbsp;<a href=\'javascript:void(0);\'   class=\'btncode btn-success\' onclick=\'openBoard(\"'+rowId+'\");\'>게시판</a>';
		        	value2 += '&nbsp;<a href=\'javascript:void(0);\'   class=\'btncode btn-primary\' onclick=\'openContent(\"'+rowId+'\");\'>컨텐츠</a>'; 
	    	    	value2 += '</span>';
	    	    }
    	    	
        	  $(mainTableId).treegrid('update',{
              	id: rowId,
              	row: {
              		admField: value,
              		adm:value2
              	}       
              });
        	  
        	  
        	  //console.log(getNodeByNodeId(rowId)); 
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
                var menu_idx = 0;   
               	 	if(edNode.menu_idx!=undefined){menu_idx = edNode.menu_idx;}                
                var menu_view=$(t.treegrid('getEditor',{id:editingId,field:'menu_view'}).target).combobox('getValue');                 
  				var menu_code = edNode.menu_code;  
  				if(menu_idx==0){
  					menu_code = $(t.treegrid('getEditor',{id:editingId,field:'menu_code'}).target).textbox('getValue');
  				}  				
  				var menu_name = $(t.treegrid('getEditor',{id:editingId,field:'name'}).target).textbox('getValue');
  				var ptrn_code = edNode._parentId;
  				var menu_depth = edNode.menu_depth; 	
  				var menu_ordr =edNode.menu_ordr;
  				//var menu_ordr =$(t.treegrid('getEditor',{id:editingId,field:'menu_ordr'}).target).numberbox('getValue');  
  				var is_board = $(t.treegrid('getEditor',{id:editingId,field:'is_board'}).target).numberbox('getValue');
  				
  				var menu_head = $(t.treegrid('getEditor',{id:editingId,field:'menu_head'}).target).combobox('getValue');  
  				var menu_target = $(t.treegrid('getEditor',{id:editingId,field:'menu_target'}).target).textbox('getValue');
  				
  				//========================== DATA 추출 ====================================  				
  				if(menu_code=="TEMP_CODE"){
  					alert("코드를 변경해 주세요. 필수사항입니다."); 
  					$(t.treegrid('getEditor',{id:editingId,field:'menu_code'}).target).focus();
  					return false;
  				}
  				 
  				//========================== DATA 주입 ====================================
  				/* 	
  				var data = "";
  				data +="menu_idx="+menu_idx;
  				data +="&menu_view="+menu_view;
  				data +="&menu_code="+menu_code.trim();
  				data +="&menu_name="+menu_name;
  				data +="&ptrn_code="+ptrn_code;
  				data +="&menu_depth="+menu_depth;  
  				data +="&menu_ordr="+menu_ordr; 
  				data +="&menu_head="+menu_head; 
  				data +="&menu_target="+menu_target; 
  				data +="&is_board="+is_board; 
  				data +="&site_code="+site_code; 
  				 */ 
  				
  				
  				var mainData = new Object();
  				mainData.menu_idx=menu_idx;
  				mainData.menu_view=menu_view;
  				mainData.menu_code=menu_code.trim();
  				mainData.menu_name=menu_name;
  				mainData.ptrn_code=ptrn_code;
  				mainData.menu_depth=menu_depth;  
  				mainData.menu_ordr=menu_ordr; 
  				mainData.menu_head=menu_head; 
  				mainData.menu_target=menu_target; 
  				mainData.is_board=is_board; 
  				mainData.site_code=site_code; 
  				var jsonData = JSON.stringify(mainData);
  				//========================== DATA 주입 ====================================
  				console.log(jsonData); 
  				//return false; 
  				var url =contextRoot+"/adms/common/menu/createAndUpdate.do";	
  				 
  				//========================== Ajax    ==================================== 	
                 $.ajax({ 
                	  url:url,  
	       			  type: "POST",  
	       			  contentType: "application/json;charset=UTF-8",
	       		  	  data:jsonData
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
        	var nextDepth =  Number(rnode.menu_depth)+1;  
        	
        	//console.log("nextDepth : "+nextDepth);
        	//console.log("maxdepth : "+maxdepth); 
        	if(Number(maxdepth) < nextDepth){
        		alert("더이상 하위로 추가하실 수 없습니다.");
        		return false;
        	}
        	//console.log("addNode");
        	var $childNode = getChildrenTarget(rowId);
        	var menuOrder =1;
        	if($childNode.length>0){
        		for(var k in $childNode){
        			if(nextDepth==$childNode[k].menu_depth){
        				menuOrder= $childNode[k].menu_ordr;  //마지막 오더값이 담김
        			}
        		}
        		menuOrder+=1;
        	}
        	
        	
        	$(mainTableId).treegrid('append',{ 
        		parent: rowId,
        		data: [{'id':'TEMP_9999999',
        			   'menu_code':'TEMP_CODE',
        			   'name':'신규추가',
        			   'menu_depth':nextDepth,
        			   'menu_view':'Y',
        			   'menu_ordr':menuOrder,
        			   'menu_head':'NOR',
        			   'is_board':'N'
        			   }]
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
        		var menu_idx = dNode.menu_idx; 
        		var menu_code = dNode.menu_code;
        		
        		var url =contextRoot+"/adms/common/menu/deleteNode.do";	
        		var data = "";
 				 data +="menu_idx="+menu_idx;
 				 data +="&menu_code="+menu_code;
 				 data +="&site_code="+site_code; 
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
        	
        	$(mainTableId).treegrid('select', rowId);
        	edit(); 
        	
        	//수정일때 메뉴타입2번 수정 불가
        	var t = $(mainTableId);
        	$(t.treegrid('getEditor',{id:editingId,field:'is_board'}).target).combobox('disable'); 
        }
         
        function getNodeByNodeId(nodeId){
        	return $(mainTableId).treegrid('find', nodeId);
        }

        
    </script>