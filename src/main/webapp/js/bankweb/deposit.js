//<![CDATA[

function attach_file_init(inputId){
	var placeFile = $("#atchFile").plupload({
	    // General settings
	    runtimes : 'html5,html4',
	    url : path+'/cmm/resources/uploadFileDetails.do',
	
	    // User can upload no more then 20 files in one go (sets multiple_queues to false)
	    //max_file_count : 2,
	
	    //chunk_size : '1mb',
	
	    // Resize images on clientside if we can
	    resize : {
	      //width : 200,
	      //height : 200,
	      quality : 90,
	      crop : false
	    // crop to exact dimensions
	    },
	
	    filters : {
	      // Maximum file size
	      max_file_size : '100mb',
	      // Specify what files to browse for
	      mime_types : [ 
	    	  //{title : "Image Files", extensions : "jpg,gif,png,jpeg"},
	    	  //{title : "Zip Files", extensions : "zip"},
	    	  //{title : "Video Files", extensions : "avi,mp4"},
	    	  //{title : "Audio Files", extensions : "mp3,wav,wma"},
	    	  {title : "Document Files", extensions : "pdf,xls,xlsx,doc,docx,ppt,pptx,jpg,jpeg,gif,png,JPG,JPEG,GIF,PNG"}
	      ]
	    },
	
	    // Rename files by clicking on their titles
	    rename : true,
	
	    // Sort files
	    sortable : true,
	
	    // Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
	    dragdrop : true,
	
	    // Views to activate
	    views : {
	      list : true,
	      thumbs : true, // Show thumbs
	      active : 'thumbs'
	    },
	    
	    preinit : {
	    	//Start Upload 실행 전 
	        UploadFile: function(up, file) {
	        	var fileId = "";
	        	if($("#"+inputId).val() == ""){
	        		fileId = getFileId()
	            	$("#"+inputId).val(fileId);
	        	}else{
	        		fileId = $("#"+inputId).val();
	        	}
	        	
	            // You can override settings before the file is uploaded
	             up.setOption('multipart_params', {menuType : 'deposit_file', atchFileId : fileId });
	        }
	    },
	    
	    init: {
	    	//Start Upload 실행 후
	    	FileUploaded: function(up, file, result) {

	    	},
	    	//파일을 첨부했을 때
	    	FilesAdded: function (up, files) {

	    	}
	    }
	  });
}


//]]>