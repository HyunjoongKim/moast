package com.bsite.cmm;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;





import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import egovframework.com.cmm.EgovProperties;
import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

/**
 * request객체를 컨트롤
 *
 *
 */


public class ExcelRequestManager {
	
	 public static final int BUFF_SIZE = 2048;


    @Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;

    private static final Logger LOG = LoggerFactory.getLogger("com");
   
    public ExcelRequestManager() {
        // TODO Auto-generated constructor stub
    }
   
    /**
     * @param HttpServletRequest request
     * @param String path 저장경로
     * @return HashMap
     */
    public HashMap<String, Object> getFileRequest(HttpServletRequest request,String path){


        HashMap<String, Object> hm = new HashMap<String, Object>();
        if(path == null) return null;
        File dir = new File(path);
        if(!dir.exists()) dir.mkdirs();
        try{
        	MultipartRequest multi=new MultipartRequest(request, path, 250*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
        	Enumeration files = multi.getFileNames();
        	String file = "";
        	File tempFile;
//        	업로드가 가능한 파일 유형을 설정함
//        	String[] canUploadExt = {"doc","docx","xls","xlsx","ppt","pptx","jpg","gif","png","bmp","jpeg","txt","zip","war","iso","hwp","pdf","exe"};
        	
        	int k = 0; //파일시작번호
        	while (files.hasMoreElements()) {
        		file = files.nextElement().toString();
        		if(multi.getFilesystemName(file)!=null){
        			tempFile = multi.getFile(file);
        			String fileName =  multi.getFilesystemName(file);
        			String ext = "";//확장자
        			if(fileName.lastIndexOf(".")>-1){
        				ext = fileName.substring(fileName.lastIndexOf(".")+1).toLowerCase();
        			}
        			boolean pass = true;
//        			if(!ext.isEmpty()){
//        				int size = canUploadExt.length;
//        				for(int i=0;i<size;i++){
//        					if(ext.equals(canUploadExt[i])){
//        						pass = true;
//        						break;
//        					}
//        				}
//        			}
        			if(pass){
        				k++; //파일번호 증가
        				hm.put("originFile_"+k, multi.getOriginalFileName(file));//원본파일
        				hm.put("uploadFile_"+k, fileName);                       //파일이 중복될 경우 변경된 파일명
        				hm.put("fileSize_"+k, tempFile.length());                //파일 사이즈
        				hm.put("path_"+k, tempFile.getParent());                 //파일이 저장된 경로
        			}else{
        				tempFile.delete();
        			}
        		}
        	}
        	//파일의 수를 저장
        	hm.put("totalFile",k);
        }catch (IOException e){
            e.printStackTrace();
        }catch (Exception e){
            e.printStackTrace();
        }
        System.out.println(hm);
        return hm;
    }
    
    /**
     * 파라미터로 넘어오는 엑셀파일 처리
     * @param request
     * @param path
     * @return
     * @throws Exception 
     */
    public List<HashMap<String, String>> parseExcel(HttpServletRequest request,String path) throws Exception{
    	List<HashMap<String, String>> list = null;
    	
    	File tempFile = null;
    	MultipartRequest multi=new MultipartRequest(request, path, 250*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
    	Enumeration files = multi.getFileNames();
    	String file = "";
    	while (files.hasMoreElements()) {
    		file = files.nextElement().toString();
    		tempFile = multi.getFile(file);
    		//list = ExcelManager.getInstance().getListExcel(tempFile);
    	}
    	return list;
    }
    
    public List<HashMap<String, String>> parseExcelSpringMultiPart
    (Map<String, MultipartFile> files , String KeyStr, int fileKeyParam,String atchFileId ,String storePath) throws Exception{
    	List<HashMap<String, String>> list = null;
    	int fileKey = fileKeyParam;
    	
    	
    	System.out.println("-----------------------Excel fileManager1-----------------------");
    	String storePathString = "";
    	String atchFileIdString = "";

    	if ("".equals(storePath) || storePath == null) {
    	    storePathString = EgovProperties.getProperty("Globals.fileStorePath.LINUX");
    	} else {
    	    storePathString = EgovProperties.getProperty("Globals.fileStorePath.LINUX")+storePath;
    	}

    	if ("".equals(atchFileId) || atchFileId == null) {
    	    //atchFileIdString = idgenService.getNextStringId();
    	} else {
    	    atchFileIdString = atchFileId;
    	}

    	File saveFolder = new File(EgovWebUtil.filePathBlackList(storePathString));

    	if (!saveFolder.exists() || saveFolder.isFile()) {
    	    saveFolder.mkdirs();
    	}

    	Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
    	MultipartFile file;
    	String filePath = "";
    	
    	

    	while (itr.hasNext()) {
    	    Entry<String, MultipartFile> entry = itr.next();
    	    
    	    file = entry.getValue();
    	    String orginFileName = file.getOriginalFilename();

    	    //--------------------------------------
    	    // 원 파일명이 없는 경우 처리
    	    // (첨부가 되지 않은 input file type)
    	    //--------------------------------------
    	    if ("".equals(orginFileName)) {
    		continue;
    	    }
    	    ////------------------------------------

    	    int index = orginFileName.lastIndexOf(".");
    	    //String fileName = orginFileName.substring(0, index);
    	    String fileExt = orginFileName.substring(index + 1);
    	    String newName = KeyStr + getTimeStamp() + fileKey;
    	    long _size = file.getSize();
    	    
    	    //_______________ 확장자 엑셀 검사 ______________________//
    	    
    	    
    	    //_______________ 확장자 엑셀 검사 ______________________//

    	    if (!"".equals(orginFileName)) {
    		filePath = storePathString + File.separator + newName+"."+fileExt;
    		file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
    	    }
    	    
    	        	    
    	    System.out.println("-----------------------Excel filePath-----------------------"+filePath);
    	    if(fileExt.equals("xls")){
    	    	list = ExcelManager.getInstance().getListExcelRead(filePath);
    	    }else{
    	    	list = ExcelManagerXlsx.getInstance().getListXlsxRead(filePath);
    	    }
    	   
    	    
    	    
    	    fileKey++;
    	}
    	
    	
    	
    	return list;
    }
    
    
    
    
    
    
    
    
    
    
    public List<HashMap<String, String>> parseExcelAlreadyUploadType(List<FileVO> result) throws Exception{
    	List<HashMap<String, String>> list = null;
    	FileVO v = result.get(0);  //여긴 파일 한개만 온다는 가정이 필요
    	String filePath = v.getFileStreCours()+"/"+v.getStreFileNm();
    	    System.out.println("-----------------------Excel Already filePath-----------------------"+filePath+"."+v.getFileExtsn());
    	    if(v.getFileExtsn().equals("xls")){
    	    	list = ExcelManager.getInstance().getListExcelRead(filePath+"."+v.getFileExtsn());
    	    }else{
    	    	list = ExcelManagerXlsx.getInstance().getListXlsxRead(filePath+"."+v.getFileExtsn()); 
    	    }

    	return list;
    }
    
    
    public List<HashMap<String, String>> parseExcelAlreadyUploadTypeByFileVO(FileVO v) throws Exception{
    	List<HashMap<String, String>> list = null;
    	String filePath = v.getFileStreCours()+"/"+v.getStreFileNm();
    	    System.out.println("-----------------------Excel Already filePath FileVO -----------------------"+filePath+"."+v.getFileExtsn());
    	    if(v.getFileExtsn().equals("xls")){
    	    	list = ExcelManager.getInstance().getListExcelRead(filePath+"."+v.getFileExtsn());
    	    }else{
    	    	list = ExcelManagerXlsx.getInstance().getListXlsxRead(filePath+"."+v.getFileExtsn()); 
    	    }

    	return list;
    }
    
    
    public Map <String,Object> parseExcelAlreadyUploadTypeMultiInfoXlsx(List<FileVO> result) throws Exception{
    	Map <String,Object> list = null;
    	FileVO v = result.get(0);  //여긴 파일 한개만 온다는 가정이 필요
    	String filePath = v.getFileStreCours()+"/"+v.getStreFileNm();
    	    System.out.println("-----------------------Excel Already filePath-----------------------"+filePath+"."+v.getFileExtsn());    	   
    	    	list = ExcelManagerXlsx.getInstance().getListXlsxReadMultiInfo(filePath+"."+v.getFileExtsn()); 
    	return list;
    }
    
    
    private static String getTimeStamp() {

    	String rtnStr = null;

    	// 문자열로 변환하기 위한 패턴 설정(년도-월-일 시:분:초:초(자정이후 초))
    	String pattern = "yyyyMMddhhmmssSSS";

    	try {
    	    SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
    	    Timestamp ts = new Timestamp(System.currentTimeMillis());

    	    rtnStr = sdfCurrent.format(ts.getTime());
    	} catch (Exception e) {
    	    //e.printStackTrace();
    		
    	    //throw new RuntimeException(e);	// 보안점검 후속조치
    	    LOG.debug("IGNORED: " + e.getMessage());
    	}

    	return rtnStr;
        }

	
    
    
    

}