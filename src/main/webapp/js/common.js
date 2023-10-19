//<![CDATA[

function alertItnMsg(propId){
	if(propId != ""){
		alert(jQuery.i18n.prop(propId));
	}
}

function gTxt(propId){
	try{
		return jQuery.i18n.prop(propId);
	}catch(e){
		return propId; 
	} 
}

function alertResMsg(msg){
	if(msg != "") alert(msg);
}

//input file 추가 삭제 작동 버튼 
function addFileInput(type,tId){	
	var fileCnt = $("#"+tId+" input[type=file]").last().attr("id").replace("userfile","");
	if(type=="M" && Number(fileCnt)==1){ 
		alert("더이상 지울 수 없습니다.");
		return false;
	}	
	var fileCntVal = Number(fileCnt)+1;	
	//alert(addInputText);
	if(type=="P"){ 
		var addInputText = "<input type='file' id='userfile"+fileCntVal+"' name='userfile"+fileCntVal+"'  onchange=\"uploadImg_Change(this.value,'userfile"+fileCntVal+"')\"/><br/>";
		$("#"+tId).append(addInputText);
		//SetContainerAutoHeight();
	}else{ 
		 $("#"+tId+" input[type=file]").last().remove();
		 $("#"+tId+" br").last().remove();
	}		
	return false;
}


//input file 추가 삭제 작동 버튼  컨텐츠 관리용 
function addFileInputContent(type,tId,dsId){	
	var fileCnt = $("#"+tId+" input[type=file]").last().attr("id").replace("userfile","");
	
	
	 
	if(type=="M" && Number(fileCnt)==1){ 
		alert("더이상 지울 수 없습니다.");
		return false;
	}	
	var fileCntVal = Number(fileCnt)+1;	
	
	var $dum = $("#"+dsId+" select").clone();
	$dum.attr("id",$dum.attr("id")+fileCntVal);
	$dum.attr("name",$dum.attr("name")+fileCntVal);
	//alert(addInputText);
	if(type=="P"){ 
		  var addInputText ="";
	      addInputText += " <div class='fileGroup'> ";
	      addInputText += "  <div class='fileinput fileinput-new mt10' data-provides='fileinput' style='display:block'> ";        
	      addInputText += "  <span class='btn btn-default btn-file'> ";
	      addInputText += "    		<span class='fileinput-new'>Select file</span> ";
	      addInputText += "    		<span class='fileinput-exists'>Change</span> ";
	      addInputText += " <input type='file' id='userfile"+fileCntVal+"' name='userfile"+fileCntVal+"'  onchange=\"uploadImg_Change(this.value,'userfile"+fileCntVal+"')\"/>";
	      addInputText += " </span> ";
	      
	      addInputText += " <span class='fileinput-filename'></span> ";
	      addInputText += " <a href='#' class='fileinput__close fileinput-exists' data-dismiss='fileinput'> ";
	      addInputText += " <i class='fa fa-times-circle'></i> ";
	      addInputText += " </a> ";
	      addInputText += " </div> ";
	        
	        
	      addInputText += "   <div class='form-inline mt10'> ";
		  addInputText += " <input type='text' id='fileid"+fileCntVal+"' name='fileid"+fileCntVal+"'  placeholder='image tag id' value='' class='form-control'  />";
		  addInputText += " "+$dum.prop('outerHTML');
				
		  addInputText += " </div>  ";
	      addInputText += " </div> ";
		$("#"+tId).append(addInputText);
		//SetContainerAutoHeight();
	}else{ 
		 //$("#"+tId+" input[type=file]").last().remove();
		 //$("#"+tId+" input[type=text]").last().remove();
		 //$("#"+tId+" br").last().remove(); 
		$("#"+tId+" div.fileGroup").last().remove(); 
		
	}		
	
	//selObj.prop('outerHTML'); 
	return false;
}

 
function setCookie (cName, cValue, cDay) {
	var expire = new Date();
    expire.setDate(expire.getDate() + cDay);
    cookies = cName + '=' + escape(cValue) + '; path=/ '; 
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
}
			
function getCookie(Name) {
    var search = Name + "=";
    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면 
        offset = document.cookie.indexOf(search);
        if (offset != -1) { // 쿠키가 존재하면 
            offset += search.length;
            // set index of beginning of value
            end = document.cookie.indexOf(";", offset);
            // 쿠키 값의 마지막 위치 인덱스 번호 설정 
            if (end == -1)
                end = document.cookie.length;
            return unescape(document.cookie.substring(offset, end));
        }
    }
    return "";
}


function uploadImg_Change(value,gId){
	  //alert(value.slice(value.toLowerCase()));
	   var str_loc  = value.lastIndexOf(".");
	   var file_ext = value.substring(str_loc+1); 
	   file_ext = file_ext.toLowerCase();
	   if(value == null || value =="") return;
	   existExt ="exe,asp,aspx,php,jsp,cs,js,bat,css,htm,html,htm,eml,xml,msi,dll";
		 existExtArray =existExt.split(",");
	    for(var i=0; i<existExtArray.length; i++){
	      if(file_ext ==existExtArray[i]){
	        alert("허용되지 않은 확장자 입니다. 그림및 문서파일만 가능합니다.");
	        //alert(document.form1.gId.value);
	        document.getElementById(gId).value = "";
	        document.getElementById(gId).focus();
	        document.getElementById(gId).select();
	        document.selection.clear();
	        
	        return false;
	    }		          
		}		 
} 


function uploadChangeOnlyOne(value,gId,extention){
	  //alert(value.slice(value.toLowerCase()));
	   var str_loc  = value.lastIndexOf(".");
	   var file_ext = value.substring(str_loc+1); 
	   file_ext = file_ext.toLowerCase();
	   if(value == null || value =="") return;
	   if(extention!=file_ext){
		   
		   alert("오직 "+extention+" 파일만 가능합니다.");
		   document.getElementById(gId).value = "";
	       document.getElementById(gId).focus();
	       document.getElementById(gId).select();
	       document.selection.clear();
	       return false;
	   } 
}

function confirmDeleteFile(){
		if(!confirm(gTxt("confirm.delete.file"))){
			return false;
		} 
	}
//file 지우기 모듈 사용시 
function fileDelCheck(ctpx ,thisForm){
    	if(!confirm(gTxt("confirm.delete.file2"))){
    		return false;
    	} 
    	var tForm = $("#"+thisForm);
    	tForm.attr("action",ctpx+"/common/deleteFile.do");
    	tForm.submit(); 
    	return false; 
    }




//hash Map //
/* HashMap 객체 생성 */
var JqMap = function(){
    this.map = new Object();
}
 
JqMap.prototype = {
    /* key, value 값으로 구성된 데이터를 추가 */
    put: function (key, value) {
        this.map[key] = value;
    },
    /* 지정한 key값의 value값 반환 */
    get: function (key) {
        return this.map[key];
    },
    /* 구성된 key 값 존재여부 반환 */
    containsKey: function (key) {
        return key in this.map;
    },
    /* 구성된 value 값 존재여부 반환 */
    containsValue: function (value) {
        for (var prop in this.map) {
            if (this.map[prop] == value) {
                return true;
            }
        }
        return false;
    },
    /* 구성된 데이터 초기화 */
    clear: function () {
        for (var prop in this.map) {
            delete this.map[prop];
        }
    },
    /*  key에 해당하는 데이터 삭제 */
    remove: function (key) {
        delete this.map[key];
    },
    /* 배열로 key 반환 */
    keys: function () {
        var arKey = new Array();
        for (var prop in this.map) {
            arKey.push(prop);
        }
        return arKey;
    },
    /* 배열로 value 반환 */
    values: function () {
        var arVal = new Array();
        for (var prop in this.map) {
            arVal.push(this.map[prop]);
        }
        return arVal;
    },
    /* Map에 구성된 개수 반환 */
    size: function () {
        var count = 0;
        for (var prop in this.map) {
            count++;
        }
        return count;
    }
}


//window.open 시 데이터 전송
function openWindowWithPost(url, windowoption, targetName, params,inputName)
{
	var form = document.createElement("form");
	form.method = "post";
	form.action = url;
	form.target = targetName;
	
	for(var i=0; i<params.length; i++){
		var input = document.createElement('input');
		input.type = 'hidden';
		//input.name = "chk_box"; 
		input.name = inputName;
		console.log("params[i] : "+params[i]); 
		input.value = params[i];
		form.appendChild(input);
	}

	document.body.appendChild(form);
	window.open("about:blank", targetName, windowoption);	
	form.submit();	
	document.body.removeChild(form);
}



function openSubmitWithPost(url, params,inputName)
{
	var form = document.createElement("form");
	form.method = "post";
	form.action = url;
	
	
	var input = document.createElement('input');
	input.type = 'hidden'; 
	input.name = inputName;
	input.value = params;

	form.appendChild(input);
	

	document.body.appendChild(form);
	form.submit();	
	document.body.removeChild(form);
}

//window.open 시 데이터 전송
function openWindowWithPostJson(url, windowoption, targetName, jsonStr,inputName)
{
	var form = document.createElement("form");
	form.method = "post";
	form.action = url;
	form.target = targetName;
	
	var input = document.createElement('input');
	input.type = 'hidden';
	input.name = inputName;
	input.value = jsonStr;
	form.appendChild(input);

	document.body.appendChild(form);
	window.open("about:blank", targetName, windowoption);	
	form.submit();	
	document.body.removeChild(form);
}



//숫자만 입력하도록 제한
function numkeyCheck(e) { 
	var keyValue = event.keyCode; 
	if( ((keyValue >= 48) && (keyValue <= 57)) ){
		return true; 
	}else{
		return false;
	}
}
/* 
function hanReplaceValue(val){
	return val.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
}
*/

function hanReplaceValueOnBlur(ths){	
	//alert(ths.value); 
	var v = ths.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');			
	ths.value=v;
}     

function hanReplaceValue(val){
	return val.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
}

//3자리 마다 콤마 찍기
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

//배열 중복값 제거
function makeUniqArr(arr){
	var uniqueArr = [];
	$.each(arr, function(i, el){
		if($.inArray(el, uniqueArr) === -1) uniqueArr.push(el);
	});
	return uniqueArr;
}


function commonGetCode(path,codeCate,ptrnCode){
	var vdata  = "code_cate="+codeCate;
	    vdata += "&ptrn_code="+ptrnCode;
	var result = null;
	$.ajax({ 
	  url: path+"/cmm/code/list_ajax_code.do", 
	  type: "POST", 
	  data:vdata,
	  async: false
	 }) 
	 .done(function(resMap) {		
		 result=resMap;
	 }) 
	 .fail(function(e) {  
		 alert("FAIL - "+e);
	 }) 
	 .always(function() { }); 
	
	return result;
}


//소숫점 포함한 숫자 입력
function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){
    	alert(gTxt("tpl.validate.number"));
    	return false;
    }   

    // Textbox value       
    var _value = event.srcElement.value;       

    // 소수점(.)이 두번 이상 나오지 못하게
    var _pattern0 = /^\d*[.]\d*$/; // 현재 value값에 소수점(.) 이 있으면 . 입력불가
    if (_pattern0.test(_value)) {
        if (charCode == 46) {
            return false;
        }
    }  

    return true;
}

//drag&drop plupload 사용 시 atchFileId 생성 및 저장 후 return
function getFileId(){
	var atchFileId = "";
	var submitObj = new Object();
	
	$.ajax({ 
      	  url: path+"/cmm/resources/getFileId.do", 
      	  type: "POST", 
      	  contentType: "application/json;charset=UTF-8",
      	  data:JSON.stringify(submitObj),
      	  dataType : "json",
      	  async: false
      	 }) 
      	 .done(function(resMap) {
      		if(resMap.res == "ok"){
      			atchFileId = resMap.atchFileId;
      		}
      	 }) 
      	 .fail(function(e) {  
      		 alert("FAIL - "+e);
      	 });
	return atchFileId;
}

//다국어 속성 이름 만들기 (db column name-> 다국어 속성이름)
function makei18nName(str){
	try{
		var strArr = str.split("_");
		console.log(strArr.length); 
		var firstStr = strArr[1].substring(0,1).toUpperCase();
		var secStr = strArr[1].substring(1, strArr[1].length);
		var thrdStr  ="";
		if(strArr.length > 2){
			var fstr = strArr[2].substring(0,1).toUpperCase();
			thrdStr = strArr[2].substring(1, strArr[2].length);
			thrdStr = fstr+thrdStr;
		}	
		var col = strArr[0]+firstStr+secStr+thrdStr;
	}catch(e){
		console.log("다국어 split 실패!");
	}
	console.log(col);
	return col;
}

//공통코드 자바스크립트로 부르기 (contextpath,"default" ,"433");
function getCodeDefaultMake(path,cate,ptrCode){  //return json
	var returnObj = null;
    var data = "";
    data +="code_cate="+cate;
    data +="&ptrn_code="+ptrCode;
	$.ajax({ 
      	  url: path+"/cmm/code/list_ajax_cmmcode.do", 
      	  type: "POST",
      	  data:data,
      	  async: false
      	 }) 
      	 .done(function(resMap) {
      		returnObj = resMap;
      	 }) 
      	 .fail(function(e) {  
      		 alert("FAIL - "+e);
      	 }) 
      	 .always(function() { }); 
	return returnObj;
}

//입력 필드 초기화
function clearInput(form) {
	if (typeof form !== 'undefined' || form !== null) {
		$('[name='+form+'] input:radio').prop('checked', false);
		$('[name='+form+'] input:checkbox').prop('checked', false);
		$('[name='+form+'] input:text').val('');
		$('[name='+form+'] select').each(function(){
			$(this).find('option:first').attr('selected','true');
		});
	}
}


//============================================================================================

//]]>