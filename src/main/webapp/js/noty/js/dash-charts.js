/*** First Chart in Dashboard page ***/
	var browserData=null; 
	var osData=null;
	var todayInfo = null;
	var monthInfo = null;
	
	$(document).ready(function() {
		var browserinfo = new Highcharts.Chart({
		    chart: {
		    	renderTo: 'xbrowser',
		    	margin: [10,10, 10, 10],
				backgroundColor: null,
                plotBackgroundColor: 'none',
		    },
		    title: {
		        text: '브라우져 이용률',
		        align: 'center',
		        verticalAlign: 'top', 
		        y: 10,
		        style: {
                	textShadow: false,
                    //fontWeight: 'bold',
                    color: 'white'
                }
		    },
		    tooltip: {
		        pointFormat: '{point.percentage:.1f}%</b>'
		    },plotOptions: {
		        pie: {
		            dataLabels: {
		                enabled: true,
		                distance: -50,
		                borderWidth: 0,
		                //format: '{point.name} {point.percentage:.1f}%', 
		                style: {
		                	textShadow: false,
		                    //fontWeight: 'bold',
		                    color: 'white'
		                }
		            },
		            size: '90%' 
		        }
		    },
		    series: [{
		        type: 'pie',
		        name: 'Browser share',
		        innerSize: '65%', 
		        data: browserinfoData()
		    }]
		});
	});
	
	
	function browserinfoData(){
		
		/*
		[
            ['Chrome', 58.9],
            ['Firefox', 13.29],
            ['IE', 13],
            ['Edge', 3.78],
            ['Safari', 3.42],
            {
                name: 'Other',
                y: 7.61,
                dataLabels: {
                    enabled: false
                }
            }
        ]
		*/
		
		var result;
		var data = "";
		
		$.ajax({ 
			  url: path+"/cmm/log/browserinfo.do", 
			  type: "POST", 
			  async: false,
			  data : data
		 }).done(function(resMap) { 
			 if(resMap != ''){
				 result =JSON.parse(resMap); 
				 browserData = result;
				 browserInfoPanel();
			 } 
		 }).fail(function(e) {
			 
		 }).always(function() {
			
		 }); 
		return result;
	}
	
	function browserInfoPanel(){
		if(browserData!=null){
			var i=0;
			for(var k in browserData){
				if(i==4) break;  
				var $obj =browserData[k];
				var $span = $("div#brsMainDummy span.brsMainSpan").clone(); 
				//brsMainDummy
				//brsMainP  / brsTitle  /brsCnt
				$span.find("span.brsTitle").html($obj.name);
				$span.find("span.brsCnt").html($obj.y+" 건<br/>");
				$("p.brsMainP").append($span); 
				//console.log($span);
				i++;
			}
		}
	}
	
	
	
	
	
	
	
	
	

/*** second Chart in Dashboard page ***/
	
	
	
	
	
	function osinfoData(){
		
		/*
		[
        	{
                name: 'Window10',
                y: 38.9,
                color: '#F3F781'
            },
            ['Window7', 33.29],
            ['Window Vista', 18],
            ['Linux', 3.78],
            ['Window xp', 3.42],
            {
                name: 'Other',
                y: 2.61,
                color: '#fa1d2d',
                dataLabels: {
                    enabled: false
                }
            }
        ]
		*/
		
		var result;
		var data = "";
		
		$.ajax({ 
			  url: path+"/cmm/log/osinfo.do", 
			  type: "POST", 
			  async: false,
			  data : data
		 }).done(function(resMap) { 
			 if(resMap != ''){ 
				 result =JSON.parse(resMap); 
				 osData = result;
				 osDataInfoPanel();
			 } 
		 }).fail(function(e) {
			 
		 }).always(function() {
			
		 }); 
		return result;
	}
	
	function osDataInfoPanel(){
		if(osData!=null){
			var i=0;
			for(var k in osData){
				if(i==4) break;
				var $obj =osData[k];
				var $span = $("div#osMainDummy span.osMainSpan").clone(); 
				//brsMainDummy
				//brsMainP  / brsTitle  /brsCnt
				$span.find("span.osTitle").html($obj.name);
				$span.find("span.osCnt").html($obj.y+" 건<br/>");
				$("p.osMainP").append($span); 
				
				i++;
			}
			
			//console.log(osData); 
		}
	}
	

	$(document).ready(function() {
		
		var osinfo = new Highcharts.Chart({
		    chart: {
		    	renderTo: 'xos',
		    	margin: [10, 10, 10, 10],
				backgroundColor: null,
                plotBackgroundColor: 'none',
		    },
		    title: {
		        text: 'OS 이용률',
		        align: 'center',
		        verticalAlign: 'top', 
		        y: 10,
		        style: {
                	textShadow: false,
                    //fontWeight: 'bold',
                    color: 'white'
                }
		    },
		    tooltip: {
		        pointFormat: '{point.percentage:.1f}%</b>'
		    },plotOptions: {
		        pie: {
		            dataLabels: {
		                enabled: true,
		                distance: -50,
		                borderWidth: 0,
		                //format: '{point.name} {point.percentage:.1f}%', 
		                style: {
		                	textShadow: false,
		                    //fontWeight: 'bold',
		                    color: 'white'
		                }
		            },
		            size: '90%' 
		        }
		    },
		    series: [{
		        type: 'pie',
		        name: 'OS',
		        innerSize: '65%', 
		        data: osinfoData()
		    }]
		});
		
		
		
		
		
		
		//---------------------------------------------------------
		
		
		var xtoday = null;
		
			xtoday = new Highcharts.Chart({
				chart: {
			    	renderTo: 'xtoday',
			    	type: 'line',
			    	margin: [30, 30, 30,70], 
					backgroundColor: null,  
	                plotBackgroundColor: 'none',  
			    },		    
			    title: {
			        text: '일주일 방문자 추이',
			        align: 'center',
			        verticalAlign: 'top', 
			        y: 10,  
			        style: {
	                	textShadow: false,
	                    //fontWeight: 'bold',
	                    color: 'white'
	                }
			    },
			    subtitle: {
			        //text: 'Source: WorldClimate.com'
			    },
			    xAxis: {
			        categories: getPersonCnt("cateArr"),
			        labels :{
			        	formatter :function(){
			    			return this.value +' 일'
			    		},		        
			        	style: {
		                	textShadow: false,
		                    //fontWeight: 'bold',
		                    color: 'white'
		                } 
			        }
			    },
			    yAxis: {
			        title: {
			            //text: '방문자 수(명)'
			        },
			        labels :{
			        	formatter :function(){
			    			return this.value +' 명'
			    		},		        
			        	style: {
		                	textShadow: false,
		                    //fontWeight: 'bold',
		                    color: 'white'
		                } 
			        }
			    },
			    plotOptions: {
			        line: {
			            dataLabels: {
			                enabled: true,
			                distance: -50,
			                borderWidth: 0,
			                //format: '{point.name} {point.percentage:.1f}%', 
			                style: {
			                	textShadow: false,
			                    //fontWeight: 'bold',
			                    color: '#F3E2A9' 
			                }
			            },
			            color:'#FF8000',
			            enableMouseTracking: true
			        }
			    },
			    series: getPersonCnt("data")
	
			});
		
		
		var monthInfo = monthInfoData(); 
		var xmonth = new Highcharts.Chart({
			chart: {
		    	renderTo: 'xmonth',
		    	type: 'line',
		    	margin: [30, 30,30, 70],
				backgroundColor: null, 
                plotBackgroundColor: 'none',  
		    },		    
		    title: {
		        text: '월별 방문자 추이',
		        align: 'center',
		        verticalAlign: 'top', 
		        y: 10,  
		        style: {
                	textShadow: false,
                    //fontWeight: 'bold',
                    color: 'white'
                }
		    },
		    subtitle: {
		        //text: 'Source: WorldClimate.com'
		    },
		    xAxis: {
		        categories: getPersonMonthCnt("cateArr"),
		        labels :{
		        	formatter :function(){
		    			return this.value +' 월'
		    		},		        
		        	style: {
	                	textShadow: false,
	                    //fontWeight: 'bold',
	                    color: 'white'
	                } 
		        }
		    },
		    yAxis: {
		        title: {
		            //text: '방문자 수(명)'
		        },
		        labels :{
		        	formatter :function(){
		    			return this.value +' 명'
		    		},		        
		        	style: {
	                	textShadow: false,
	                    //fontWeight: 'bold',
	                    color: 'white'
	                } 
		        }
		    },
		    plotOptions: {
		        line: {
		            dataLabels: {
		                enabled: true,
		                distance: -50,
		                borderWidth: 0,
		                //format: '{point.name} {point.percentage:.1f}%', 
		                style: {
		                	textShadow: false,
		                    //fontWeight: 'bold',
		                    color: '#F3E2A9' 
		                }
		            },
		            color:'#FF0080',
		            enableMouseTracking: true
		        }
		    },
		    series: getPersonMonthCnt("data")

		});
		
		/*
		info = new Highcharts.Chart({
			chart: {
				renderTo: 'space',
				margin: [0, 0, 0, 0],
				backgroundColor: null,
                plotBackgroundColor: 'none',
							
			},
			
			title: {
				text: null
			},

			tooltip: {
				formatter: function() { 
					return this.point.name +': '+ this.y +' %';
						
				} 	
			},
		    series: [
				{
				borderWidth: 2,
				borderColor: '#F1F3EB',
				shadow: false,	
				type: 'pie',
				name: 'SiteInfo',
				innerSize: '65%',
				data: [
					{ name: 'Used', y: 65.0, color: '#fa1d2d' },
					{ name: 'Rest', y: 35.0, color: '#3d3d3d' }
				],
				dataLabels: {
					enabled: false,
					color: '#000000',
					connectorColor: '#000000'
				}
			}]
		});
		*/
		
		
		
		
		
		
		/*
		var ranges = [
	        [8, 22, 27],
	        [9, 14, 33],
	        [10, 4, 44],
	        [11, 22, 55],
	        [12, 24, 44],
	        [13, 12, 55],
	       
	    ],
	    averages = [
	    	[8, 24],
	        [9, 22],
	        [10, 15],
	        [11, 33],
	        [12, 35],
	        [13, 27],
	    ];
		 */
		var ctimeMap = connectTimeInfoData();
		
		var xconnect = null;		
		xconnect = new Highcharts.Chart({
			chart: {
		    	renderTo: 'xconnect',
		    	margin: [50,30,30,30], 
				backgroundColor: null, 
                plotBackgroundColor: 'none',  
		    },		    
		    title: {
		        text: '시간별 접속정보',	        		        
	        	style: {
                	textShadow: false,
                    //fontWeight: 'bold',
                    color: 'white'
                } 
		    },

		    xAxis: {
		    	labels :{
		    		formatter :function(){
		    			return this.value +' 시'
		    		},		    	     
		        	style: {		        		 
	                	textShadow: false,
	                    //fontWeight: 'bold',
	                    color: 'white'
	                } 
		        }
		    },

		    yAxis: {
		        title: {
		            text: '건수' 
		        },
		        labels :{
		        	formatter :function(){
		    			return this.value +' 건'
		    		},		        
		        	style: {
	                	textShadow: false,
	                    //fontWeight: 'bold',
	                    color: 'white'
	                } 
		        }
		        
		    },

		    tooltip: {
		        crosshairs: true,
		        shared: true,
		        valueSuffix: '건'
		    },

		    legend: {
		    },

		    series: [{
		        name: '평균 건수',
		        color : 'white',
		        data: ctimeMap.get("averages"),
		        zIndex: 1,
		        marker: {
		            fillColor: 'red',
		            lineWidth: 2,
		            lineColor: Highcharts.getOptions().colors[0]
		        }
		    }, {
		        name: 'Range',
		        data: ctimeMap.get("ranges"), 
		        type: 'arearange',
		        lineWidth: 0,
		        linkedTo: ':previous',
		        color: Highcharts.getOptions().colors[0],
		        fillOpacity: 0.3,
		        zIndex: 0,
		        marker: {
		            enabled: true 
		        }
		    }] 
		});
	});//end document function
	
	
	

	function connectTimeInfoData(){
		
		var result = null;
		var data = "";
		var resMap = new JqMap();
		$.ajax({ 
			  url: path+"/cmm/log/connecttimeinfo.do", 
			  type: "POST", 
			  async: false,
			  data : data
		 }).done(function(resMap) { 
			 if(resMap != ''){ 
				 result =JSON.parse(resMap); 
			 } 
		 }).fail(function(e) {
			 
		 }).always(function() {
			
		 }); 
		
		
		 var rangesArr = new Array();
		 var averagesArr = new Array();
		 //console.log(result); 
		if(result!=null){
			for(var k in result){
				var obj = result[k];
				var rArr = new Array();
				var aArr = new Array();
				
				rArr.push(obj.name);
				rArr.push(obj.min);
				rArr.push(obj.max);
				aArr.push(obj.name);
				aArr.push(obj.avg);
				
				rangesArr.push(rArr);
				averagesArr.push(aArr);
			}
			resMap.put("ranges",rangesArr);
			resMap.put("averages",averagesArr); 
		}
		
		return resMap;
	}
	
	
	
	
	
	
	
	
	
	function todayInfoData(){
		
		var result = null;
		var data = "";
		
		$.ajax({ 
			  url: path+"/cmm/log/todayinfo.do", 
			  type: "POST", 
			  async: false,
			  data : data
		 }).done(function(resMap) { 
			 if(resMap != ''){ 
				 result =JSON.parse(resMap); 
			 } 
		 }).fail(function(e) {
			 
		 }).always(function() {
			
		 }); 
		return result;
	}
	
	function getPersonCnt(type){
		if(todayInfo==null) todayInfo=todayInfoData();
		var todayInfoMap = resultProcLineChart(todayInfo);
		if(todayInfoMap==null) return null;
		if(type=="data"){
			return todayInfoMap.get("data");
		}else{
			return todayInfoMap.get("cateArr");
		}
	}
	
	
	function getPersonMonthCnt(type){
		if(monthInfo==null) monthInfo=monthInfoData();
		var monthInfoMap = resultProcLineChart(monthInfo); 
		if(monthInfoMap==null) return null;
		if(type=="data"){
			return monthInfoMap.get("data");
		}else{
			return monthInfoMap.get("cateArr");
		}
	}
	
	function resultProcLineChart($obj){
		if($obj==null) return null;		
		var resMap = new JqMap();
		
		var cateArr = new Array();
		var dataArr = new Array();
		var dobj = new Object();
		
		dobj.name='방문자 (명)';
		var subDataArr = new Array();
		
		for(var k in $obj){
			var xobj =$obj[k];
			
			
			cateArr.push(xobj.d);	
			subDataArr.push(xobj.y); 			
		}
		dobj.data = subDataArr;
		dataArr.push(dobj);
		
		resMap.put("cateArr",cateArr);
		resMap.put("data",dataArr);
		
		return resMap;
	}
	
	
	
	
	function monthInfoData(){
		
		var result= null;
		var data = "";
		
		$.ajax({ 
			  url: path+"/cmm/log/monthinfo.do", 
			  type: "POST", 
			  async: false,
			  data : data
		 }).done(function(resMap) { 
			 if(resMap != ''){ 
				 result =JSON.parse(resMap); 
			 } 
		 }).fail(function(e) {
			 
		 }).always(function() {
			
		 }); 
		return result;
	}
	
	
	//방문자수, 어제 오늘
	function getTotalCounts(){
		
		var result= null;
		var data = "";
		
		$.ajax({ 
			  url: path+"/cmm/log/totalCnt.do", 
			  type: "POST", 
			  async: false,
			  data : data
		 }).done(function(resMap) { 
			 if(resMap != ''){ 
				 result =JSON.parse(resMap); 
			 } 
		 }).fail(function(e) {
			 
		 }).always(function() {
			
		 }); 
		
		if(result!=null){
			//todayCnt
			//yesterCnt
			for(var k in result){
				var obj = result[k];
				if(obj.cdate=="today"){
					$("span.todayCnt").html(obj.y +"명");
				}else{
					$("span.yesterCnt").html(obj.y +"명");
				}
			}			
		}
		
		return result;
	}
	
	
	//======================================================= chart end ====================================================
	

