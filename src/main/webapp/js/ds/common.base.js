var browser = (function() {
  var s = navigator.userAgent.toLowerCase();
  var match = /(webkit)[ \/](\w.]+)/.exec(s) ||
              /(opera)(?:.*version)?[ \/](\w.]+)/.exec(s) ||
              /(msie) ([\w.]+)/.exec(s) ||               
              /(mozilla)(?:.*? rv:([\w.]+))?/.exec(s) ||
             [];
  return { name: match[1] || "", version: match[2] || "0" };
}());
 
var latestFocus = null;
 
var _userAgent_ = navigator.userAgent;var isIe6 = (/msie 6/i).test(_userAgent_);var isIe7 = (/msie 7/i).test(_userAgent_);var isIe9 = (/msie 9/i).test(_userAgent_); var isComptMode = (/compatible/i).test(_userAgent_);
 
var docChkTimer = null;
var DOC_COMPLET = null;
function docLoading(loadFunc){
    clearTimeout(docChkTimer);
    if(document.readyState=="loaded" || document.readyState=="complete"){
        DOC_COMPLET = true;
        if(loadFunc!=undefined) loadFunc();
    }
    else{
        docChkTimer = setTimeout(function(){docLoading(loadFunc);},500);
    }
}
 
 
 
 
function getBrowsertInfo(){
    var $agent = navigator.userAgent;
    var $s = "";
    var $br = {browser:"",browserType:"",browserVer:[]};
 
        
    if ((/msie 5.0[0-9]*/i).test($agent))         { $s = "MSIE 5.0"; }
    else if((/msie 5.5[0-9]*/i).test($agent))     { $s = "MSIE 5.5"; }
    else if((/msie 6.0[0-9]*/i).test($agent))     { $s = "MSIE 6.0"; }
    else if((/msie 7.0[0-9]*/i).test($agent))     { $s = "MSIE 7.0"; }
    else if((/msie 8.0[0-9]*/i).test($agent))     { $s = "MSIE 8.0"; }
    else if((/msie 9.0[0-9]*/i).test($agent))     { $s = "MSIE 9.0"; }
    else if((/msie 10.0[0-9]*/i).test($agent))     { $s = "MSIE 10.0"; }
    else if((/windows*/i).test($agent) && (/rv:11.0[0-9]*/i).test($agent))     { $s = "MSIE 11.0"; }
    else if((/msie 4.[0-9]*/i).test($agent))      { $s = "MSIE 4.x"; }
    else if((/firefox/i).test($agent))            { $s = "FireFox"; }
    else if((/safari/i).test($agent))            { $s = "FireFox"; }
    else if((/x11/i).test($agent))                { $s = "Netscape"; }
    else if((/opera/i).test($agent))              { $s = "Opera"; }
    else if((/gec/i).test($agent))                { $s = "Gecko"; }
    else if((/bot|slurp/i).test($agent))          { $s = "Robot"; }
    else if((/internet explorer/i).test($agent))  { $s = "IE"; }
    else if((/mozilla/i).test($agent))            { $s = "Mozilla"; }
    else { $s = ""; }
 
    $br.browser = $s;
 
    if((/msie/i).test($s)){
        $br.browserType = "IE";
        $br.browserVer =  $s.replace("MSIE " ,"").split(".");
    }
    
    return $br;
 
}
 
 
 function number_format(data) 
{
    
    var tmp = '';
    var number = '';
    var cutlen = 3;
    var comma = ',';
    var i;
   if(parseInt(data)==0) return 0;
    data = String(data);
    len = data.length;
    mod = (len % cutlen);
    k = cutlen - mod;
    for (i=0; i<data.length; i++) 
    {
        number = number + data.charAt(i);
        
        if (i < data.length - 1) 
        {
            k++;
            if ((k % cutlen) == 0) 
            {
                number = number + comma;
                k = 0;
            }
        }
    }
 
    return number;
}
 
function sprintf2(zero,text){
    len = zero.length;
    r_txt = zero + text;
    f_len = r_txt.length;
    s_len = f_len - len;
    r_txt = r_txt.slice(s_len,f_len);
    return r_txt;
}
 
 
var $wbr =getBrowsertInfo();
var wsize = null;    //윈도우 사이즈 정보
var psize = null;    //컨텐츠 사이즈 정보
var lowIeChk = {    old_w:0,old_h:0 }
function getWindowSizeObj(){
        var sizeObj = {
        scr : {w:screen.width,h:screen.height},
        availscr : {w:screen.availWidth,h:screen.availHeight},
        win : (_isLowBr_)? {w:$(window).width(),h:$(window).height()}    : {w:window.innerWidth,h:window.innerHeight}    //스크롤사이즈 제외(윈도우 8부터 아래버전에서 확인안됨.ㅠㅠ)
        
    }
    return sizeObj;
}
function getPageSizeObj(){
    var sizeObj = {
        doc : {w:document.documentElement.scrollWidth,h:document.documentElement.scrollHeight},
        scroll : {x:document.documentElement.scrollLeft,y:document.documentElement.scrollTop,top:$(window).scrollTop(),left:$(window).scrollLeft()}    ////모바일에서는 안잡힘..
        , header:{h:$("#header-wrap").height()}        , footer:{h:$("#footer-wrap").height() + 1}
    };
    return sizeObj;
}
function getWindowSize(){
    wsize =getWindowSizeObj();
}
function getPageSize(){
    psize = getPageSizeObj();
 
    printWinSizeInfo();
}
 
function printWinSizeInfo(){
    var str = "";
//    str +="screen [w : "+wsize.scr.w+", h:"+wsize.scr.h+"]<br/>";
//    str +="availscr [w : "+wsize.availscr.w+", h:"+wsize.availscr.h+"]<br/>";
    str +="window [w : "+wsize.win.w+", h:"+wsize.win.h+"] ";        //스크롤바 포함한 브라우저 윈도우  높이
    str +="doc [w : "+psize.doc.w+", h:"+psize.doc.h+"]<br/>";
//    str +="scrollpos [w : "+psize.scroll.x+", h:"+psize.scroll.y+"]<br/>";    
//    str +="scrollpos2 [left : "+psize.scroll.x+", top:"+psize.scroll.y+"]<br/>";    
    $("#testBox").html("[" + $wbr.browser +"]" + str +" /" + $(".div-conts").width());
}
 
 
function setLowBrowser(){
    
    $("body").removeClass("isIE7");
    try{
        if($wbr.browserType=="IE" && $wbr.browserVer[0]<=8){
            _isLowBr_ = true;
            $("body").addClass("isIE7");
 
            $("li").each(function(){
                if($(this).index() ==0) $(this).addClass("is-first");
                if($(this).index() ==($(" > li",$(this).parent()).length -1)) $(this).addClass("is-last");
            });
        
        }
    }catch(e){
    }
 
}
 
function MobileCheck(){
    var $agent = navigator.userAgent;
    var MobileArray  = ["iphone","lgtelecom","skt","mobile","samsung","nokia","blackberry","android","android","sony","phone"];
 
 
    var checkCount = 0;
    for(var i=0; i<MobileArray.length; i++){
        var checkStr = $agent.toLowerCase().match(MobileArray[i]);
        if(checkStr!=null && checkStr==MobileArray[i]) {checkCount++; break; }
        //if(preg_match("/$MobileArray[$i]/", strtolower($_SERVER["HTTP_USER_AGENT"]))){ $checkCount++; break; }
    }
   return (checkCount >= 1) ? true : false;
}
 
function isEmailCheck( email ) {
    
    var regex=/([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    
    return (email != '' && email != 'undefined' && regex.test(email));
}

//이미지 사이즈 정보 초기화
function initImgSizeInfo(){
    $("img").each(function(){
        
        var attr_w = $(this).width();
        var attr_h = $(this).height();
 
        if($(this).get(0).getAttribute("org_width")!=null) attr_w = $(this).get(0).getAttribute("org_width") ;
        else if($(this).get(0).org_width!=undefined) attr_w = $(this).get(0).org_width;
 
        if($(this).get(0).getAttribute("org_height")!=null) attr_h = $(this).get(0).getAttribute("org_height") ;
        else if($(this).get(0).org_height!=undefined) attr_h = $(this).get(0).org_height;
 
        $(this).attr("org_width",attr_w);
        $(this).attr("org_height",attr_h);
 
 
//        if($(this).attr("org_width")!=undefined || $(this).attr("org_width")>0   ) $(this).attr("org_width",$(this).width());
//        if($(this).attr("org_height")==undefined || $(this).attr("org_height")>0)  $(this).attr("org_height",$(this).height());
 
        $(this).data("org_width",attr_w);
        $(this).data("org_height",attr_h);
        $(this).attr("isInit","true");
    });
}
 
//지정한 가로폭만큼 리사이징
function contImgResize(imgs,limitSize){
 
    for (i=0;i<imgs.length ;i++ )
    {
        var im = imgs[i];
        var rSize = getImgReSize(limitSize,{"w":$(im).width(),"h":$(im).height()});
        
        $(im).width(rSize.w);
        $(im).height(rSize.h);
 
    }
}
//상위객체 가로 크기 구하기
function boundBoxWidth(obj){
    var w = parseInt($(obj).width());
    if(w<1){
        if($($(obj).parent().get(0)).lennth>0){
        w = boundBoxWidth($($(obj).parent().get(0)));
        }else{
            w = 0;
        }
    }
    return w;
}
//상위 객체를 기준으로 크기값 다시 계산
function AutoImgResize(iobj,maxSize){
 
    if(maxSize==undefined){
        var pObj = $(iobj).parent().get(0);
        //var maxWidth = parseInt($(pObj).width());
        var maxWidth = boundBoxWidth(pObj);
    }else{
        var maxWidth = maxSize;
    }
 
 
 
    var sizeW = $(iobj).attr("w");
    var sizeH =  $(iobj).attr("h");
 
    if($(iobj).attr("isInit")=="true"){
        sizeW = $(iobj).data("org_width") ;
        sizeH = $(iobj).data("org_height") ;
         $(iobj).attr("w",sizeW);
         $(iobj).attr("h",sizeH);
    }
 
 
    if($(iobj).attr("w")==undefined || $(iobj).attr("h")==undefined || $(iobj).attr("w")<1 || $(iobj).attr("h")<1){
        
        var iw = parseInt($(iobj).width());
        var ih = parseInt($(iobj).height());
 
        if($(iobj).attr("w")==undefined || $(iobj).attr("w")<1){                $(iobj).attr("w",iw);            } 
        if($(iobj).attr("h")==undefined || $(iobj).attr("h")<1){                $(iobj).attr("h",ih);            } 
    }else{
        var iw = parseInt($(iobj).attr("w"));
        var ih = parseInt($(iobj).attr("h"));
    }
 
    //alert(iw);
    if(maxWidth>0){
        //if(maxWidth<iw){
            var rSize = getImgReSize2(maxWidth,{"w":iw,"h":ih});
//            alert(rSize.w +":" + rSize.h)
            //if(rSize.w<=iw || rSize.h<=ih){
            $(iobj).width(rSize.w);
            $(iobj).height(rSize.h);
            //}
        //}
    }
}
//전체 이미지에 대한 이미지 가로폭 제한
function resizeImgsMaxWidth(notObj){
    
    var imgs = $("img:not(.noResize)");
    for (var i=0;i<imgs.length ;i++ )
    {
        AutoImgResize(imgs[i]);
    }
 
}
//이미지 사이즈 계산
function getImgReSize2(w,imgSize){
    var rSize = {"w":imgSize.w,"h":imgSize.h};
 
    if(imgSize.w>w){
        rSize.w = w;
        rSize.h = Math.ceil(imgSize.h * (rSize.w /imgSize.w));
 
    }
 
    return rSize;
}
 
 
 
function initRollOverImg(){
$(".isRollOver").mouseover(function(){
    var obj = $("img",this);
 
    obj.attr("orgSrc",$(obj).attr("src"));
    if(!obj.attr("ovImg")){
        var fileExt = obj.attr("orgSrc").substr(obj.attr("orgSrc").lastIndexOf("."));
        obj.attr("ovImg", obj.attr("orgSrc").replace(fileExt,"_o"+fileExt));
    }
    //$(obj).animate({opacity:0.5},200);
 
    $(obj).attr("src",obj.attr("ovImg"));
    try{
    var fileExt = $(obj).attr("ovImg").substr($(obj).attr("ovImg").toString().lastIndexOf("."));
 
    if(fileExt.toLowerCase()!=".png" || isIe9){
        $(obj).stop().animate({opacity:0},20);
        $(obj).animate({opacity:1},500);
    }
    }catch(e){ alert(e);} 
 
 
    //$(obj).fadeIn(500);
});
$(".isRollOver").mouseout(function(){    var obj = $("img",this);    $(obj).attr("src",obj.attr("orgSrc"));});
}
function getImgReSize(w,imgSize){
    var rSize = {"w":imgSize.w,"h":imgSize.h};
 
    if(imgSize.w>w){
        rSize.w = w;
        rSize.h = Math.ceil(imgSize.h * (rSize.w /imgSize.w));
 
    }
 
    return rSize;
}



///////////////////////////////////////////////////////////
 
function image_window(img)
{
    var _charset = "UTF-8";
    var imgsrc    = ($(img).attr("orgSrc"))? $(img).attr("orgSrc") : img.getAttribute("tmp_src");
    
    var w = img.getAttribute("tmp_width"); 
    var h = img.getAttribute("tmp_height"); 
    var winl = (screen.width-w)/2; 
    var wint = (screen.height-h)/3; 
 
    if (w >= screen.width) { 
        winl = 0; 
        h = (parseInt)(w * (h / w)); 
    } 
 
    if (h >= screen.height) { 
        wint = 0; 
        w = (parseInt)(h * (w / h)); 
    } 
 
    var js_url = "<script language='JavaScript1.2'> \n"; 
        js_url += "<!-- \n"; 
        js_url += "var ie=document.all; \n"; 
        js_url += "var nn6=document.getElementById&&!document.all; \n"; 
        js_url += "var isdrag=false; \n"; 
        js_url += "var x,y; \n"; 
        js_url += "var dobj; \n"; 
        js_url += "function movemouse(e) \n"; 
        js_url += "{ \n"; 
        js_url += "  if (isdrag) \n"; 
        js_url += "  { \n"; 
        js_url += "    dobj.style.left = nn6 ? tx + e.clientX - x : tx + event.clientX - x; \n"; 
        js_url += "    dobj.style.top  = nn6 ? ty + e.clientY - y : ty + event.clientY - y; \n"; 
        js_url += "    return false; \n"; 
        js_url += "  } \n"; 
        js_url += "} \n"; 
        js_url += "function selectmouse(e) \n"; 
        js_url += "{ \n"; 
        js_url += "  var fobj      = nn6 ? e.target : event.srcElement; \n"; 
        js_url += "  var topelement = nn6 ? 'HTML' : 'BODY'; \n"; 
        js_url += "  while (fobj.tagName != topelement && fobj.className != 'dragme') \n"; 
        js_url += "  { \n"; 
        js_url += "    fobj = nn6 ? fobj.parentNode : fobj.parentElement; \n"; 
        js_url += "  } \n"; 
        js_url += "  if (fobj.className=='dragme') \n"; 
        js_url += "  { \n"; 
        js_url += "    isdrag = true; \n"; 
        js_url += "    dobj = fobj; \n"; 
        js_url += "    tx = parseInt(dobj.style.left+0); \n"; 
        js_url += "    ty = parseInt(dobj.style.top+0); \n"; 
        js_url += "    x = nn6 ? e.clientX : event.clientX; \n"; 
        js_url += "    y = nn6 ? e.clientY : event.clientY; \n"; 
        js_url += "    document.onmousemove=movemouse; \n"; 
        js_url += "    return false; \n"; 
        js_url += "  } \n"; 
        js_url += "} \n"; 
        js_url += "document.onmousedown=selectmouse; \n"; 
        js_url += "document.onmouseup=new Function('isdrag=false'); \n"; 
        js_url += "//--> \n"; 
        js_url += "</"+"script> \n"; 
 
    var settings;
 
   // if (g4_is_gecko) {
   //     settings  ='width='+(w+10)+','; 
  //  } else {
        settings  ='width='+w+','; 
        settings +='height='+h+','; 
  //  }
    settings +='top='+wint+','; 
    settings +='left='+winl+','; 
    settings +='scrollbars=no,'; 
    settings +='resizable=yes,'; 
    settings +='status=no'; 
 
 
    win=window.open("","image_window",settings); 
    win.document.open(); 
    win.document.write ("<html><head> \n<meta http-equiv='imagetoolbar' CONTENT='no'> \n<meta http-equiv='content-type' content='text/html; charset="+_charset+"'>\n"); 
    var size = "이미지 사이즈 : "+w+" x "+h;
    win.document.write ("<title>"+size+"</title> \n"); 
    if(w >= screen.width || h >= screen.height) { 
        win.document.write (js_url); 
        var click = "ondblclick='window.close();' style='cursor:move' title=' "+size+" \n\n 이미지 사이즈가 화면보다 큽니다. \n 왼쪽 버튼을 클릭한 후 마우스를 움직여서 보세요. \n\n 더블 클릭하면 닫혀요. '"; 
    } 
    else 
        var click = "onclick='window.close();' style='cursor:pointer' title=' "+size+" \n\n 클릭하면 닫혀요. '"; 
    win.document.write ("<style>.dragme{position:relative;}</style> \n"); 
    win.document.write ("</head> \n\n"); 
    win.document.write ("<body leftmargin=0 topmargin=0 bgcolor=#dddddd style='cursor:arrow;'> \n"); 
    win.document.write ("<table width=100% height=100% cellpadding=0 cellspacing=0><tr><td align=center valign=middle><img src='"+imgsrc+"' width='"+w+"' height='"+h+"' border=0 class='dragme' "+click+"></td></tr></table>");
    win.document.write ("</body></html>"); 
    win.document.close(); 
 
    if(parseInt(navigator.appVersion) >= 4){win.window.focus();} 
 
}

 
function imgPreview(etarget,src){
    if($(".imgPreviewArea").length>0){
        $(".imgPreviewArea").remove();
    }else{
        $("body").append("<div class='imgPreviewArea'><img src='"+src+"' width=200/></div>");
        $(".imgPreviewArea").css({"position":"absolute","border":"1px solid #DDD","z-index":"6000","left":($(etarget).offset().left+50) +"px","top":$(etarget).offset().top+"px"});
    }
}
function imgPreviewClose(){
 
}
 
 
//탭메뉴 설정
function setTabMenu(tab_id,n){
        $("li[id^='" + tab_id + "_tab'] a").click(function(){
            var tabStr = $(this).attr("href");
            var n  = tabStr.replace("#"+tab_id + "_sub","");
            setTabContents(tab_id,n);
            return false;
        });    
 
        if(n>0) setTabContents(tab_id,n);
}
 
//탭메뉴 컨텐츠 활성
function setTabContents(tab_id,n){
    if(n==undefined || n<1) n = 1;
    
    //메뉴 활성
    $("[id^='" + tab_id + "_tab']:not(#"+tab_id+"_tab"+n+")").removeClass("over");
    $("#"+tab_id+"_tab"+n).addClass("over");
 
    //컨텐츠 활성
    $("[id^='" + tab_id + "_sub']:not(#"+tab_id+"_sub"+n+")").hide();
    $("#"+tab_id+"_sub"+n).show();
 
}
 
 
function setBoardTab(obj_id,num,evt){
 
    var obj = document.getElementById(obj_id);
    var seq = 0;
 
    var tabs = Array();
    for (i=0; i<obj.childNodes.length; i++){
        if (obj.childNodes[i].tagName=="DL"){
            seq++;
            tabs[seq] = obj.childNodes[i];
        }
    }
 
    for (i=1; i<tabs.length; i++){
        var titImg = $("dt img",$(tabs[i]));
        if(titImg.length>0){
            var ovImg = $(titImg).attr("ovImg");
            var orgSrc = $(titImg).attr("orgSrc");
        }
 
        if (i==num){ 
            if($(tabs[i]).hasClass("isOn")){
                if(evt=="c") {
                    if($(".btnmore a",$(tabs[i])).attr("onclick")=="" || $(".btnmore a",$(tabs[i])).attr("onclick")==undefined){
                    document.location.href=$(".btnmore a",$(tabs[i])).attr("href");
                    }else{
                    $(".btnmore a",$(tabs[i])).click();                    
                    }
                }
            }else{
                $(tabs[i]).addClass("isOn");
            }
            //이미지
            if(ovImg!=undefined && orgSrc!=undefined){
                $(titImg).attr("src",ovImg);
            }
 
        }
        else{
            $(tabs[i]).removeClass("isOn");
            //이미지
            if(ovImg!=undefined && orgSrc!=undefined){
                $(titImg).attr("src",orgSrc);
            }
        }
    }
}
 
function setSubTab(obj_id,maxNum,num){
    
    for(var i=1; i<=maxNum;i++){
        var tab = document.getElementById(obj_id+"_tab"+i);
        var cont =document.getElementById(obj_id+"_cont"+i);
        if(num==i){
            $(tab).addClass("isOver");
            $(cont).show();
        }else{
            $(tab).removeClass("isOver");
            $(cont).hide();
        }
    }
}

 
//탭메뉴 초기화
function initTabMenu(){
    var tabObj = $("[isTab]");
    if(tabObj.length>0){
        for(i=0; i<tabObj.length;i++){
            if($(tabObj[i]).attr("initTab")>0) var initTab = $(tabObj[i]).attr("initTab");
            else var initTab = 1;
            setTabMenu(    $(tabObj[i]).attr("isTab"),initTab);
        }
    }
}
 
//탭메뉴 클릭 액션 설정
function setTabMenu(tab_id,n){
 
        $("li[id^='" + tab_id + "_btn'] a").click(function(){
            var tabStr = $(this).attr("href");
            var n  = tabStr.replace("#"+tab_id + "_cont","");
            setTabContents(tab_id,n);
            return false;
        });    
 
        if(n>0) setTabContents(tab_id,n);
}
 
//탭메뉴 컨텐츠 활성
function setTabContents(tab_id,n){
    if(n==undefined || n<1) n = 1;
    
    //메뉴 버튼 활성
    var btns = $("#"+tab_id+" li a");
    
    for (var i=0;i<btns.length ;i++ )
    {
        var thisNum = $($(btns[i]).parent("li").get(0)).attr("id").replace(tab_id + "_btn","");
        var imgObj = $("img",$(btns[i]));
        
        if(imgObj.length>0){
            var ovImg = $(imgObj).attr("ovImg");        
 
            if(thisNum==n){
                $(imgObj).attr("src",$(imgObj).attr("ovImg"));
                var outImg = ovImg;
            }else{
                $(imgObj).attr("src",$(imgObj).attr("orgSrc"));
                var outImg = $(imgObj).attr("orgSrc");
                }
 
            $(imgObj).attr("ovImg",ovImg);
            $(imgObj).attr("outImg",outImg);
            
            $(imgObj).unbind("mouseover");
            $(imgObj).unbind("mouseout");
            
            if(thisNum!=n){
            $(imgObj).bind("mouseover",function (){
                    $(this).attr("src",$(this).attr("ovImg"));
                    $(this).stop();
                    $(this).animate({opacity:0},20);
                    $(this).animate({opacity:1},500);
            });
            $(imgObj).bind("mouseout",function (){
                    $(this).attr("src",$(this).attr("outImg"));
 
            });
            }
        }else{
            //이미지 버튼 없을경우 li에 over 속성
            if(thisNum!=n){
                $(btns[i]).removeClass("over");
            }
            else{
                $(btns[i]).addClass("over");
 
            }
            
        }
    }
 
 
   
 
    var wrapObj = $("[isTabSub='"+tab_id+"']");
    $("[id^='" + tab_id + "_cont']:not(#"+tab_id+"_cont"+n+")",$(wrapObj)).hide();
    $("#"+tab_id+"_cont"+n,$(wrapObj)).show();
 
}