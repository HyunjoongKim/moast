// Family Site
$(document).ready(function(){
	$(".dep").click(function() {
	  $(this).children(".depLay").toggle();
	  $(this).toggleClass("on");	  
	});	
	$(".dep").mouseleave(function() {
	  $(this).children(".depLay").hide();
	  $(this).removeClass("on");	
	});		
	$(".family").click(function() {
	  $(".family ul").toggle();
	});	
	$(".family").mouseleave(function() {
	  $(".family ul").hide();
	});	
});


// Main Tab List
$(function(){
	var mainBdLi = $('.main_bd > ul > li');
	mainBdLi.mouseover(function(){
		var $this = $(this);
		mainBdLi.removeClass('on');
		mainBdLi.find('> ol').hide();
		$this.addClass('on');
		$this.find('> ol').show();
	});

	var tabLi = $('.tab1 > ul > li');
	mainBdLi.mouseover(function(){
		var $this = $(this);
		mainBdLi.removeClass('on');
		mainBdLi.find('> ol').hide();
		$this.addClass('on');
		$this.find('> ol').show();
	});
	$('.main_bd > ul > li:eq(0) > a').trigger('mouseover');

	$('.fam_area .in ul').bxSlider({
		autoDelay:500,
		minSlides: 1,
		maxSlides: 7,
		moveSlides: 1,
		pager:false
	});


}); //function


//gnb
$(function(){
	$(document).ready(function(){

		$('#gnb nav.gnb_area').on({
			mouseenter:function(){
				$(this).addClass('on');
				$('#gnb nav.gnb_area').append('<div class="nav_bg"><span></span></div>')
				$('#gnb div').show();
				$('html').css('overflow-x','hidden')
			}
		});
		$('#gnb nav.gnb_area > ul > li > div').each(function(i, e){
			$(e).mouseenter(function(){
				$(this).prev().addClass('on');
				$(this).parent().siblings().children('a').removeClass('on');
			});
			$(e).prev().mouseleave(function(){
				$(this).removeClass('on');
			});
		});

		$('#gnb').mouseleave(function(){
			$('#gnb nav.gnb_area div').hide();
			$('#gnb nav.gnb_area a').removeClass('on');
				$('html').css('overflow-x','auto')
		});

	});
});

function fn_webtoon_go(val)
{
	var windowHeight=document.all?document.body.clientHeight:window.innerHeight; 
	var height = windowHeight - 90;
	window.open("/info/webtoon_view.php?no=" +val, "webtoon_01", "width=720,height="+height+",scrollbars=1,top=90");
}

//banner
$(document).ready(function(){
	var galleryAuto=null;
	var galleryDirect="left"; 

	function rightGallery(){
		$(".bn_img").stop().animate(   
			{left:"-130px"},0,function(){
				var $galleryObj=$(".bn_img li:first").clone(true);
				$(".bn_img li:first").remove(); 
				$(".bn_img").css("left","0"); 
				$(".bn_img").append($galleryObj);
			} 
		)
		if(galleryAuto)clearTimeout(galleryAuto);
		galleryAuto=setTimeout(rightGallery,5000)
	}

	function leftGallery(){
		$(".bn_img").stop().animate(
			{left:"0px"},0,function(){
				var $galleryObj=$(".bn_img li:last").clone(true);
				$(".bn_img li:last").remove(); 
				$(".bn_img").css("left","0"); 
				$(".bn_img").prepend($galleryObj);
			} 
		)
		if(galleryAuto)clearTimeout(galleryAuto);
		galleryAuto=setTimeout(rightGallery,5000); 
	}
	
	galleryAuto=setTimeout(rightGallery,5000); 

	$leftG=$(".bn_ctrl .bn_prev a");
	$rightG=$(".bn_ctrl .bn_next a");
	$pauseG=$(".bn_ctrl .bn_pause a");
	$galleryP_btn=$(".bn_ctrl .bn_pause a img");
	var bPlay = false;

	$leftG.click(function(){
		if(bPlay == true){	
			clearTimeout(galleryAuto); 
		}else{			
			galleryDirect="left";
			clearTimeout(galleryAuto);
			leftGallery();
			return false;
		}
	});

	$rightG.click(function(){
		if(bPlay == true){	
			clearTimeout(galleryAuto); 
		}else{			
			galleryDirect="right";
			clearTimeout(galleryAuto);
			rightGallery();
			return false;
		}
	});

	$pauseG.click(function(){	
		if(bPlay == false){	
			clearTimeout(galleryAuto); 
			$galleryP_btn.attr("src","../img/main/mBn_ctrl_play.png");
			$galleryP_btn.attr("alt","재생");
			bPlay = true;
		}else{			
			bPlay = false;
			$galleryP_btn.attr("src","../img/main/mBn_ctrl_stop.gif");
			$galleryP_btn.attr("alt","일시정지");
			galleryAuto=setTimeout(rightGallery,1500); 
		}
	});

	$(".bn_img li a").bind("mouseover focusin", function(){
		clearTimeout(galleryAuto);
		$galleryP_btn.attr("src","../img/main/mBn_ctrl_play.gif");
		$galleryP_btn.attr("alt","재생");
	});
	$(".bn_img li a").bind("mouseleave focusout", function(){
		bPlay = false;
		galleryAuto=setTimeout(rightGallery,1500);
		$galleryP_btn.attr("src","../img/main/mBn_ctrl_stop.gif");
		$galleryP_btn.attr("alt","일시정지");
	});

});

//banner
$(document).ready(function(){
	var galleryAuto=null;
	var galleryDirect="left"; 

	function rightGallery(){
		$(".bn_img2").stop().animate(   
			{left:"-130px"},0,function(){
				var $galleryObj=$(".bn_img2 li:first").clone(true);
				$(".bn_img2 li:first").remove(); 
				$(".bn_img2").css("left","0"); 
				$(".bn_img2").append($galleryObj);
			} 
		)
		if(galleryAuto)clearTimeout(galleryAuto);
		galleryAuto=setTimeout(rightGallery,5000)
	}

	function leftGallery(){
		$(".bn_img2").stop().animate(
			{left:"0px"},0,function(){
				var $galleryObj=$(".bn_img2 li:last").clone(true);
				$(".bn_img2 li:last").remove(); 
				$(".bn_img2").css("left","0"); 
				$(".bn_img2").prepend($galleryObj);
			} 
		)
		if(galleryAuto)clearTimeout(galleryAuto);
		galleryAuto=setTimeout(rightGallery,5000); 
	}
	
	galleryAuto=setTimeout(rightGallery,5000); 

	$leftG=$(".bn_ctrl2 .bn_prev a");
	$rightG=$(".bn_ctrl2 .bn_next a");
	$pauseG=$(".bn_ctrl2 .bn_pause a");
	$galleryP_btn=$(".bn_ctrl2 .bn_pause a img");
	var bPlay = false;

	$leftG.click(function(){
		if(bPlay == true){	
			clearTimeout(galleryAuto); 
		}else{			
			galleryDirect="left";
			clearTimeout(galleryAuto);
			leftGallery();
			return false;
		}
	});

	$rightG.click(function(){
		if(bPlay == true){	
			clearTimeout(galleryAuto); 
		}else{			
			galleryDirect="right";
			clearTimeout(galleryAuto);
			rightGallery();
			return false;
		}
	});

	$pauseG.click(function(){	
		if(bPlay == false){	
			clearTimeout(galleryAuto); 
			$galleryP_btn.attr("src","../img/main/mBn_ctrl_play.gif");
			$galleryP_btn.attr("alt","재생");
			bPlay = true;
		}else{			
			bPlay = false;
			$galleryP_btn.attr("src","../img/main/mBn_ctrl_stop.gif");
			$galleryP_btn.attr("alt","일시정지");
			galleryAuto=setTimeout(rightGallery,1500); 
		}
	});

	$(".bn_img2 li a").bind("mouseover focusin", function(){
		clearTimeout(galleryAuto);
		$galleryP_btn.attr("src","../img/main/mBn_ctrl_play.gif");
		$galleryP_btn.attr("alt","재생");
	});
	$(".bn_img2 li a").bind("mouseleave focusout", function(){
		bPlay = false;
		galleryAuto=setTimeout(rightGallery,1500);
		$galleryP_btn.attr("src","../img/main/mBn_ctrl_stop.gif");
		$galleryP_btn.attr("alt","일시정지");
	});

});