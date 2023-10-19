package com.bsite.cmm.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.code.service.CommonCodeService;
import com.bsite.account.service.LoginService;
import com.bsite.cmm.CommonFunctions;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;
import com.bsite.vo.resJsonVO;
import com.drew.imaging.ImageMetadataReader;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.drew.metadata.exif.ExifSubIFDDirectory;
import com.drew.metadata.exif.GpsDirectory;

import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/**
 * @Class Name : CommonController.java
 * @Description : 공통으로 사용해야할 기능의 컨트롤러2
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일                      수정자               수정내용
 *  -------      --------    ---------------------------
 *   2017.07.17.   박종화              최초 생성
 *
 * </pre>
 */

@Controller
public class CommonController2 {
	
	private final static Logger logger = LoggerFactory.getLogger("com");
	
	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;

	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	@Resource(name = "EgovFileMngUtil")
    private EgovFileMngUtil fileUtil;

	@Resource(name = "EgovFileMngService")
    private EgovFileMngService fileMngService;
	
	CommonFunctions cf = new CommonFunctions();
	
	
	/**
	 * 첨부파일 id 생성 후 갖고오기111
	 */
	@RequestMapping(value = "/cmm/resources/getFileId.do", method = RequestMethod.POST)
	@ResponseBody
	public String getFileId(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		JSONObject resMap = new JSONObject();

		try{
			String atchFileId = "";
			atchFileId = fileMngService.getAtchNextFileId();
			
			FileVO vo = new FileVO();
			vo.setAtchFileId(atchFileId);
			vo.setSite_code(loginService.getSiteCode());
			fileMngService.insertAtchFileId(vo);
			
			resMap.put("res", "ok");
			resMap.put("atchFileId", atchFileId);

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}
	
	
	/**
	 * drag and drop 멀티 파일 업로드 
	 */
	@RequestMapping(value = "/cmm/resources/uploadFileDetails.do", method = { RequestMethod.POST })
	@ResponseBody
	public String uploadFileDetails(
			final MultipartHttpServletRequest multiRequest,
	        HttpServletRequest request,
	        HttpServletResponse response) throws Exception {
		
		String menuType = request.getParameter("menuType");			//첨부파일 파일의 성격
		String atchFileId = request.getParameter("atchFileId");
		String menuIdx = request.getParameter("menuIdx");
		String adms = request.getParameter("adms");
		String siteCode = loginService.getSiteCode();
		if ("Y".equals(adms)) {
			siteCode = "ADMS";
		}
		HashMap<String, String> map = getFileSaveInfo(menuType);
		JSONObject resMap = new JSONObject();
		PrintWriter out = response.getWriter();
		
		try {
			List<FileVO> result = null;
			
			
			final Map<String, MultipartFile> files = multiRequest.getFileMap();
			if (!files.isEmpty()) { 
				result = fileUtil.parseFileInf(files, map.get("fileHeader"), 0, atchFileId, map.get("fileFolder"), siteCode);
				fileMngService.insertFileInfsDetails(result, menuType, menuIdx);
			}
			
			//썸네일 생성
			cf.makeThumImage(result);	
			
			//채집지 사진일 경우 메타 정보 return 
			if("place_photo".equals(menuType)) {
				resMap = setFileMetaInfo(result.get(0));
			}
			
			 
		} catch (IOException e) {
			e.printStackTrace();
		}
		out.print(resMap);
		return null;
	}
	
	/**
	 * 첨부파일 저장에 필요한 정보 갖고오기
	 */
	public HashMap<String, String> getFileSaveInfo(String menuType){
		HashMap<String, String> map = new HashMap<String, String>();
		
		switch (menuType) {
		//채집지 사진
		case "place_photo":
			map.put("fileHeader", "PLACE_PHOTO_");
			map.put("fileFolder", "place_photo/");
			break;
		//채집지 첨부파일
		case "place_file":
			map.put("fileHeader", "PLACE_FILE_");
			map.put("fileFolder", "place_file/");
			break;
		case "res_photo":
			map.put("fileHeader", "RES_PHOTO_");
			map.put("fileFolder", "res_photo/");
			break;
		case "res_file":
			map.put("fileHeader", "RES_FILE_");
			map.put("fileFolder", "res_file/");
			break;
		case "res_ref_file":
			map.put("fileHeader", "RES_REF_FILE_");
			map.put("fileFolder", "res_ref_file/");
			break;
		case "culture_file":
			map.put("fileHeader", "CULTURE_FILE_");
			map.put("fileFolder", "culture_file/");
			break;
		default:
			map.put("fileHeader", "DEFAULT_FILE_");
			map.put("fileFolder", "default_file/");
			break;
		}
		return map;
	}
	
	
	 
	
	
	
	/**
	 * 사진의 메타 데이터 갖고오기
	 * @param fileVO
	 * @return 메타 정보 map json
	 */
	public JSONObject setFileMetaInfo(FileVO fileVO){
		JSONObject map = new JSONObject();
		String pdsDate = "";
		String pdsDatetime = "";
		String pdsLat = "";
		String pdsLon = "";
		String pdsAddr = "";
		String pdsAlt = "";

		try{
			 File file = new File(fileVO.getFileStreCours() + "/" + fileVO.getStreFileNm());
			 Metadata metadata = ImageMetadataReader.readMetadata(file);
			    for (Directory directory : metadata.getDirectories()) {
		   			for (Tag tag : directory.getTags()) {
		   			//System.out.println(tag);
		   			}
	   		    }

			 //촬영일
			 ExifIFD0Directory directory2 = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
			 Date date = directory2.getDate(ExifIFD0Directory.TAG_DATETIME, TimeZone.getTimeZone("Asia/Seoul"));
			 SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
			 SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			 if(date != null){
				 pdsDate = format1.format(date);
				 pdsDatetime = format2.format(date);
			 }else{
				 ExifSubIFDDirectory subIFD = metadata.getFirstDirectoryOfType(ExifSubIFDDirectory.class);
				 Date date2 = subIFD.getDate(ExifSubIFDDirectory.TAG_DATETIME_ORIGINAL, TimeZone.getTimeZone("Asia/Seoul"));
				 pdsDate = format1.format(date2);
				 pdsDatetime = format2.format(date2);
			 }

	     	//촬영방향
	     	/**
	     	 *  * 6: rotate 90,
				* 1: original (no change)
				* 3: rotate 180,
				* 8: rotate 270,
	     	 */
	     	int orientation = 1;
	     	try {
	     		orientation = directory2.getInt(ExifIFD0Directory.TAG_ORIENTATION);
	     	} catch (Exception me) {
	     		System. out.println("Could not get orientation" );
	     	}

	     	

			// GPS, 고도
			if (metadata.containsDirectoryOfType(GpsDirectory.class)) {

			      GpsDirectory gpsDirectory = metadata.getFirstDirectoryOfType(GpsDirectory.class);

			      //고도 갖고오기
			      if(gpsDirectory.containsTag(GpsDirectory.TAG_ALTITUDE)){
			    	  pdsAlt = String.valueOf(gpsDirectory.getRational(GpsDirectory.TAG_ALTITUDE).intValue());
			      }

			      //위도,경도 갖고오기
			      if(gpsDirectory.containsTag(GpsDirectory.TAG_LATITUDE) && gpsDirectory.containsTag(GpsDirectory.TAG_LONGITUDE)) {

			    	  pdsLat = String.valueOf(gpsDirectory.getGeoLocation().getLatitude());
			    	  pdsLon = String.valueOf(gpsDirectory.getGeoLocation().getLongitude());

			             //gps 도,분,초 계산
			             double lat = Double.parseDouble(pdsLat);
			             double lon = Double.parseDouble(pdsLon);

			             int iLatDeg = (int) lat;
			             int iLatMin = (int) ((lat - iLatDeg) * 60);
			             double iLatSec = ((((lat - iLatDeg) * 60) - iLatMin) * 60);
			             iLatSec = Math.round(iLatSec*100d) / 100d;

			             int iLonDeg = (int) lon;
			             int iLonMin = (int) ((lon - iLonDeg) * 60);
			             double iLonSec = ((((lon - iLonDeg) * 60) - iLonMin) * 60);
			             iLonSec = Math.round(iLonSec*100d) / 100d;
			             
			             //주소 
			             HashMap<String, String> addr_ko = getAddress(pdsLat, pdsLon, "ko");
			             HashMap<String, String> addr_en = getAddress(pdsLat, pdsLon, "en");

			             map.put("orien", String.valueOf(orientation));
			             map.put("date", pdsDate);
			             map.put("datetime", pdsDatetime);
			             map.put("lat", pdsLat);
			             map.put("lon", pdsLon);
			             map.put("address", pdsAddr);
			             map.put("addr_ko", addr_ko.get("addr"));
			             map.put("addr_en", addr_en.get("addr"));
			             map.put("country", addr_en.get("country"));
			             map.put("alt", pdsAlt);
			             map.put("lat_deg", String.valueOf(iLatDeg));
			             map.put("lat_min", String.valueOf(iLatMin));
			             map.put("lat_sec", String.valueOf(iLatSec));
			             map.put("lon_deg", String.valueOf(iLonDeg));
			             map.put("lon_min", String.valueOf(iLonMin));
			             map.put("lon_sec", String.valueOf(iLonSec));
			             
			      }
			      else {
			        //Show error or notification
			      }
			}

		}catch(Exception ex){
			logger.error(ex.toString());
		}

		return map;
	}
	
	/**
	 * 구글 지도 api 역지오코딩 
	 * https://developers.google.com/maps/documentation/geocoding/start?refresh=1#get-a-key
	 */
	@SuppressWarnings("unchecked")
	HashMap<String, String> getAddress(String pdsLat, String pdsLon, String lang) {
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			String googleApiKey = "AIzaSyDJTfBF_1Vee7e9XlvMgHZrbRSg1jbR6GU";

		  	//위도,경도로 주소 갖고오기
		    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+pdsLat+","+pdsLon+"&key="+googleApiKey+"&language="+lang;

	        URL obj = new URL(url);
	        HttpURLConnection conn = (HttpURLConnection) obj.openConnection();

	        conn.setRequestProperty("Content-Type", "application/json");
	        conn.setDoOutput(true);
	        conn.setRequestMethod("GET");

	        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));

	        String inputLine;
	        StringBuffer response = new StringBuffer();

	        while ((inputLine = in.readLine()) != null) {
	            response.append(inputLine);
	        }
	        in.close(); 
	        
	        JSONObject apiObj = JSONObject.fromObject(response.toString());
	        net.sf.json.JSONArray apiArr = net.sf.json.JSONArray.fromObject(apiObj.get("results"));
	        JSONObject apiResult = (JSONObject) apiArr.get(0);
	        net.sf.json.JSONArray apiArr2 = (net.sf.json.JSONArray) apiResult.get("address_components");
	        
	        
	        String country = "";
	        String countryName = "";
	        String addr = "";
	        String spl = ", ";
	        List<String> addrList = new ArrayList<String>();
	        for (int i=0; i < apiArr2.size(); i++) {
	        	JSONObject addrObj = apiArr2.getJSONObject(i);
	        	String long_name = (String) addrObj.get("long_name");
	        	List<String> types = (List<String>) addrObj.get("types");
	        	if(!types.contains("country") && !types.contains("postal_code")) addrList.add(long_name);
	        	if(types.contains("country")) {
	        		country=(String) addrObj.get("short_name");
	        		countryName=(String) addrObj.get("long_name");
	        	}
	        }
	        if(lang.equals("ko")) {
	        	Collections.reverse(addrList);
	        	spl = " ";
	        }
	        
	        for(String s : addrList) {
	        	addr += s + spl;
	        }
	        addr = addr + countryName;
	        map.put("country", country);
	        map.put("addr", addr);
	        
		}catch(Exception e) {
			System.out.println(e.toString());
		}
		return map;
	}
	
	
	@RequestMapping(value = "/cmm/place/getAddr.do", method = RequestMethod.POST)
	@ResponseBody
    public String getAddr(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			ObjectMapper mapper = new ObjectMapper();
			resJsonVO vo = (resJsonVO)mapper.readValue(filterJSON,new TypeReference<resJsonVO>(){ });
			
			String lat = vo.getFormStr1();
			String lon = vo.getFormStr2();
			String lang = vo.getFormStr3();

			HashMap<String, String> map = getAddress(lat, lon, lang);
			
			resMap.put("res", "success");
			resMap.put("country", map.get("country"));
			resMap.put("addr", map.get("addr"));
			

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "fail");
			resMap.put("msg", "txt.fail");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}
	
	
	/**
	 * 자원 엑셀 - 사진 첨부
	 */
	@RequestMapping(value="/cmm/res/addPhoto.do")
    public String addPhoto(
    		HttpServletRequest request,
    		ModelMap model) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		try{
			String trIdx = request.getParameter("trIdx");
			model.addAttribute("trIdx", trIdx);

		      
		}catch(Exception e){
			System.out.println(e.toString());
    	}

		return "tilespopup:bsite/nproject/res/resExcel/addPhoto";
	}
	
}
