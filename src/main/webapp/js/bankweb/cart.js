//<![CDATA[
	function setCart(nfp_idx, nfp_type){
		if(!confirm("장바구니에 담으시겠습니까?")){
			return false;
		}
		
		var submitObj = new Object();
		submitObj.nfp_idx = nfp_idx;
		submitObj.nfp_type = nfp_type;		//1.자원 2.배지   
		
		$.ajax({ 
	      	  url: path+"/mypage/cart/create.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(submitObj),
	      	  dataType : "json"
	      	 }) 
	      	 .done(function(resMap) {
	      		 if(resMap.res == "success"){
	      			$("#work-modal-cart").modal();
	      		 }
	      		 else if(resMap.res == "dup"){
	      			 alert("이미 장바구니에 담긴 상품입니다.");
	      			 return false;
	      		 }
	      		 else{
	      			 alert("장바구니 저장에 실패했습니다.");
	      			 return false;
	      		 }
	      		
	      	 }) 
	      	 .fail(function(e) {  
	      		 alert("로그인 후 이용해주세요.");
	      		 location.href=path+"/account/login.do";
	      	 }) 
	      	 .always(function() { 
	      	 }); 
	}

//]]>