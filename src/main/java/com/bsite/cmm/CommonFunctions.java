package com.bsite.cmm;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.imageio.ImageIO;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.DVConstraint;
import org.apache.poi.hssf.usermodel.HSSFDataValidation;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.Comment;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.usermodel.XSSFDataValidation;
import org.apache.poi.xssf.usermodel.XSSFDataValidationConstraint;
import org.apache.poi.xssf.usermodel.XSSFDataValidationHelper;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.jsoup.Jsoup;
import org.springframework.util.FileCopyUtils;

import com.bsite.vo.CommonCodeVO;

import egovframework.com.cmm.EgovProperties;
import egovframework.com.cmm.service.FileVO;

public class CommonFunctions {
	
	//이미지 불러와base64 변환후 다시 셋팅
	public List<FileVO> setImageFile(List<FileVO> fileList) {
		if(fileList.size() > 0){
			for(int i=0; i < fileList.size(); i++){
				String extention = fileList.get(i).getFileExtsn().toLowerCase();
		    	if(extention.equals("jpeg") || extention.equals("jpg") || extention.equals("bmp") || extention.equals("png") || extention.equals("gif") ){
		    		try {
		    			String filePath = fileList.get(i).getFileStreCours()+"/"+fileList.get(i).getStreFileNm();
		    			File file = new File(filePath);
		    			boolean isExists = file.exists();

						if(isExists) fileList.get(i).setBase64Img("data:image/gif;base64,"+fileToBase64Encoding(filePath));
					} catch (IOException e) {
						System.out.println(e.toString());
						e.printStackTrace();
					}
		    	}
			}
		}
		return fileList;
	}

	public void makeThumImage(List<FileVO> result) throws IOException{

		for(FileVO file : result ){
	    	String extention = file.getFileExtsn().toLowerCase();
	    	if(extention.equals("jpeg") || extention.equals("jpg") || extention.equals("bmp") ||
	    			extention.equals("png") || extention.equals("gif") ){
	    		//썸네일 처리
	    		ThumImage thum = new ThumImage();
	    		String rPath = file.getFileStreCours()+"/"+file.getStreFileNm();

	    		//------ 스몰 -------
	    		String dPathSmall = file.getFileStreCours()+"/"+"Thum_"+file.getStreFileNm();
	    		BufferedImage originalImageSmall = ImageIO.read(new File(rPath));
	    		try{
		    		if(thum.scale(originalImageSmall, dPathSmall, file.getFileExtsn(), 140, 105)){
		    			System.out.println("썸네일 등록 성공" );
		    		}else{
		    			System.out.println("썸네일 등록 실패" );
		    		}
	    		}catch(Exception e){
	    			System.out.println("썸네일 등록 실패 Exception : "+e.toString());
	    		}finally{
	    			thum=null;
	    			originalImageSmall = null;
	    		}

	    		//------ 중간 -------
	    	}
		}//end for

	}//end function

	public void setImgId(HttpServletRequest request, List<FileVO> result) {
		for(FileVO file : result ){
			String fcnt = file.getEntryKey().replaceAll("userfile","");
			String fiName = "fileid"+fcnt;
			String ftName = "ftype"+fcnt;

			String fiVal = request.getParameter(fiName);
			String ftVal = request.getParameter(ftName);

			file.setFileCn(fiVal);
			file.setFile_content_type(ftVal);
		}//end for
	}//end function

	public void makeThumNail(FileVO file, int width, int height) throws IOException {
		String extention = file.getFileExtsn().toLowerCase();
    	if(extention.equals("jpeg") ||
    			extention.equals("jpg") ||
    			extention.equals("bmp") ||
    			extention.equals("png") ||
    			extention.equals("gif")
    			){
    		//대표 이미지 이면 1번 파일 set
    		//썸네일 처리
    		ThumImage thum = new ThumImage();
    		String rPath = file.getFileStreCours()+"/"+file.getStreFileNm();

    		//------ 스몰 -------
    		String dPathSmall = file.getFileStreCours()+"/"+"Thum_"+file.getStreFileNm();
    		BufferedImage originalImageSmall = ImageIO.read(new File(rPath));

    		if(thum.scale(originalImageSmall, dPathSmall, file.getFileExtsn(), width, height)){
    			System.out.println("썸네일 등록 성공" );
    		}else{
    			System.out.println("썸네일 등록 실패" );
    		}

    		originalImageSmall = null;
    		thum = null;
    		//------ 중간 -------
    	}
    	//추후에 파일이 하나 더생기면 여기서 set
	}





	public String fileToBase64Encoding(String filePath) throws IOException {
	    String fileString = new String();
	    FileInputStream inputStream =  null;
	    ByteArrayOutputStream byteOutStream = null;
	    System.out.println("filePath  : "+filePath);
	    File file = new File(filePath);
	    try {

	        inputStream = new FileInputStream(file);
	        byteOutStream = new ByteArrayOutputStream();

		int len = 0;
		byte[] buf = new byte[1024];
	        while ((len = inputStream.read(buf)) != -1) {
	             byteOutStream.write(buf, 0, len);
	        }

	        byte[] fileArray = byteOutStream.toByteArray();
	        fileString = new String(Base64.encodeBase64(fileArray));

	    } catch (IOException e) {
	        e.printStackTrace();
	    } finally {
	    	inputStream.close();
	        byteOutStream.close();
	    }
	    return fileString;
	}//end function



	//파일 확장자 제한 더있을때마다 추가
	public static boolean denyfileExtention(String ext){
		boolean rValue = false;

			try{
				List<String> l = new ArrayList<String>();
				l.add("exe");
				l.add("asp");
				l.add("aspx");
				l.add("ascx");
				l.add("php");
				l.add("jsp");
				l.add("cs");
				l.add("js");
				l.add("bat");
				l.add("css");
				l.add("htm");
				l.add("html");
				l.add("htm");
				l.add("eml");
				l.add("xml");
				l.add("cfm");
				l.add("cfc");
				l.add("dll");
				l.add("pl");
				l.add("reg");
				l.add("cgi");
				l.add("conf");
				l.add("ca");
				l.add("msi");
				l.add("dll");



				for(String ll : l){
					if(ll.equals(ext)){
                        System.out.println("list ll : "+ll + "|| ext : "+ext);
                        rValue=true;
                        break;
                    }
				}
		}catch(Exception e){
			rValue = true; // 이상있음 판단
		}

			return rValue;
	}

	//right string
	public String getStrRight(String str, int size) {
		if(str == null || str.trim().length() == 0 || str.trim().length() < size) {
			return str;
		}

		int len = str.length();

		return str.substring(len-size, len);
	} /* end getStrRight() */


	public String replaceHtmlTag(String contents) {
		contents = contents.replace("&amp;", "&");
		contents =  contents.replace("&quot;", "\"");
		contents =  contents.replace("&apos;", "'");
		contents =  contents.replace("&lt;", "<");
		contents = contents.replace("&gt;", ">");
		contents = contents.replace("&nbsp;"," ");
		//contents.replaceAll("<br>", "\r\n");
		String result =  contents;
		System.out.println("replaceAll  : "+result);
		return result;
	}

	public String removeHtmlTag(String contents) {
		String textWithoutTag = contents.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		return textWithoutTag;
	}


	public static boolean isMobilePhoneNo(String p) {
		return Pattern.matches("^01(?:0|1|[6-9])-(?:\\d{3}|\\d{4})-\\d{4}$", p);
	}

	public static boolean isValidEmail(String email)

	{

		Pattern p = Pattern.compile("^(?:\\w+\\.?)*\\w+@(?:\\w+\\.)+\\w+$");
		Matcher m = p.matcher(email);
		return m.matches();

	}

    public boolean datePatterns(String val , String type){

    	try{
	    	String anni_date = val.replace(" ","");
	    	Pattern pattern = null;
	    	if(type.equals("-")){
	    		 pattern =  Pattern.compile("^((19|20)\\d\\d)?([- /.])?(0[1-9]|1[012])([- /.])?(0[1-9]|[12][0-9]|3[01])$");
	    	}else if(type.equals(".")){
	    		 pattern =  Pattern.compile("^((19|20)\\d\\d)?([. /.])?(0[1-9]|1[012])([. /.])?(0[1-9]|[12][0-9]|3[01])$");
	    	}
	    	Matcher matcher = pattern.matcher(anni_date);


	    	return matcher.find();
    	}catch(Exception e){
    		return false;
    	}



    }


    /*******************************  오늘날짜 yyyy-MM-dd ***********************************/
	public String GetTodayDate(){
		Calendar cal = Calendar.getInstance();
		cal.setTime( new Date(System.currentTimeMillis()));
		String today = new SimpleDateFormat("yyyy-MM-dd").format( cal.getTime()); // 오늘날짜


		return today.toString();
	}

	public String GetTodayDateTime(){
		Calendar cal = Calendar.getInstance();
		cal.setTime( new Date(System.currentTimeMillis()));
		String today = new SimpleDateFormat("yyyy-MM-dd HH:mm").format( cal.getTime()); // 오늘날짜


		return today.toString();
	}

	//어제
	public String GetYesterdayDate(){
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String yesterday = new SimpleDateFormat("yyyy-MM-dd").format( cal.getTime()); // 오늘날짜
		return yesterday.toString();
	}

	//올해 년도
	public String getThisYear(){
		java.util.Calendar cal = java.util.Calendar.getInstance();
    	String thisYear = String.valueOf(cal.get (cal.YEAR));
    	return thisYear;
	}
	
	//현재 달
	public String getThisMonth(){
		java.util.Calendar cal = java.util.Calendar.getInstance();
    	String thisMonth = String.valueOf(cal.get (cal.MONTH) + 1);
    	return thisMonth;
	}
	
	//현재 날짜
	public String getThisDay(){
		java.util.Calendar cal = java.util.Calendar.getInstance();
    	String thisDay = String.valueOf(cal.get (cal.DAY_OF_MONTH));
    	return thisDay;
	}
	
	public String getYear(String ymd){
		java.util.Calendar cal = this.getCalendar(ymd);
    	String thisYear = String.valueOf(cal.get (cal.YEAR));
    	return thisYear;
	}
	
	public String getMonth(String ymd){
		java.util.Calendar cal = this.getCalendar(ymd);
    	String thisMonth = String.valueOf(cal.get (cal.MONTH) + 1);
    	return thisMonth;
	}
	
	public String getDay(String ymd){
		java.util.Calendar cal = this.getCalendar(ymd);
    	String thisDay = String.valueOf(cal.get (cal.DAY_OF_MONTH));
    	return thisDay;
	}
	
	public Calendar getCalendar(String ymd) {
		Date datetime = Date.valueOf(ymd);
		Calendar cal = Calendar.getInstance();
        cal.setTime(datetime);
		return cal;
	}
	


	/*******************************  원하는 년도 범위 리스트 ************************************/
	public List<SelectVO> MakeYearList(int _topMaxYear ,int _lowMinYear){
		List<SelectVO> yList = new ArrayList<SelectVO>();
		String[] todayArr = GetTodayDate().split("-", -1);
		int today = Integer.parseInt(todayArr[0]);

		for(int k=today+_topMaxYear; k>=today-_lowMinYear; k--){
			SelectVO vo = new SelectVO();
			vo.setLabel(k+"");
			vo.setValue(k+"");
			yList.add(vo);
		}
		return yList;
	}




	/*******************************  sql 인젝션 처리  수동으로 할때나 유동 컬럼 사용시      ************************************/
	public static String sqlInjectionStringType(String v){
		String[] blackList ={"\'","'","\"","--",";--",";","\\*","@@","@","char","nchar","varchar","int","alter","begin","cast",
				"create","declare","delete","drop","exec","execute","fetch","insert","kill","open","select","table","update","sys","union","or",
				"CREATE","DECLARE","DELETE","DROP","EXEC","EXECUTE","FETCH","INSERT","KILL","OPEN","SELECT","TABLE","UPDATE","SYS","UNION","OR"
				};

		try{
			for(String s : blackList){
				if(v !=null) v = v.replaceAll(s, "");
			}
		}catch(Exception e){
			System.out.println("sqlInjection Exception : "+e.toString());
		}
		return v;
	}

	/*******************************  메일 발송 ************************************/
	public void sendMail(String recipient, String subject, String body ){
		try{
			// 메일 관련 정보
	        String host = EgovProperties.getProperty("Globals.mail.host");
	        final String username = EgovProperties.getProperty("Globals.mail.id");
	        final String password = EgovProperties.getProperty("Globals.mail.password");
	        int port = Integer.parseInt(EgovProperties.getProperty("Globals.mail.port"));
	        String senderName = EgovProperties.getProperty("Globals.mail.senderName");

	        // 메일 내용
	        //String recipient = "7015@coreit.co.kr";
	        //String subject = "메일 발송 확인입니다.";
	        //String body = "내용을 입력해주세요.";

	        Properties props = System.getProperties();
	        props.put("mail.smtp.host", host);
	        props.put("mail.smtp.port", port);
	        props.put("mail.smtp.auth", "true");
	        props.put("mail.smtp.ssl.enable", "true");
	        props.put("mail.smtp.ssl.trust", host);

	        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
	            String un=username;
	            String pw=password;
	            @Override
				protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(un, pw);
	            }
	        });
	        session.setDebug(true); //for debug

	        Message mimeMessage = new MimeMessage(session);
	        mimeMessage.setFrom(new InternetAddress(EgovProperties.getProperty("Globals.mail.emailAddress"), senderName));
	        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
	        mimeMessage.setSubject(subject);
	        //mimeMessage.setText(body);
	        mimeMessage.setContent(body, "text/html; charset=utf-8");
	        Transport.send(mimeMessage);
		}catch(Exception e){
			System.out.println(e.toString());
    	}
	}


	//===========================================설문 파트 ===========================================
		/*******************************  현재시간                        ************************************/
		public String getNow(){
			String res="";
			Calendar calendar = Calendar.getInstance();
			SimpleDateFormat dateFormat = new SimpleDateFormat("HHmm");
			res = dateFormat.format(calendar.getTime());
			return res;
		}
		public static Map<String,String> questionChoice(){
			Map<String,String> map = new  HashMap<String,String>();
			map.put("1", "필수");
			map.put("2", "선택");
			map.put("3", "조건");

			return map;
		}

		public static String fillZero(String r){
			String res  = r;
			if(r.length()==1){
				res = "0"+res;
			}
			return res;
		}



		public static List<SelectVO> getHourCode(){ //시간 코드
			List<SelectVO> resL = new ArrayList<SelectVO>();
			for(int i =1; i<=23; i++){
				String r = fillZero(i+"");
				SelectVO v = new SelectVO();
				v.setLabel(r);
				v.setValue(r);
				resL.add(v);
			}
			return resL;
		}


		public static List<SelectVO> getMinCode(){ //분 코드
			List<SelectVO> resL = new ArrayList<SelectVO>();
			for(int i =0; i<=55; i++){
				if(i%5==0){
					String r = fillZero(i+"");
					SelectVO v = new SelectVO();
					v.setLabel(r);
					v.setValue(r);
					resL.add(v);
				}
			}
			return resL;
		}

		public static  List<SelectVO> getSuvTargetCode(){ //
			List<SelectVO> resL = new ArrayList<SelectVO>();

			SelectVO v = new SelectVO();
			v.setValue("1");
			v.setLabel("어린이");
			resL.add(v);


			v = new SelectVO();
			v.setValue("2");
			v.setLabel("노약자");
			resL.add(v);

			v = new SelectVO();
			v.setValue("3");
			v.setLabel("성인");
			resL.add(v);


			return resL;
		}

		public static  List<SelectVO> getSuvGrantCode(){ //
			List<SelectVO> resL = new ArrayList<SelectVO>();

			SelectVO v = new SelectVO();
			v.setValue("a");
			v.setLabel("관리자");
			resL.add(v);


			v = new SelectVO();
			v.setValue("u");
			v.setLabel("일반");
			resL.add(v);


			v = new SelectVO();
			v.setValue("e");
			v.setLabel("누구나");
			resL.add(v);


			return resL;
		}
		//===========================================설문 파트 ===========================================


		/*******************************  쿠키 갖고오기 ***********************************/
		public String getCookie(String cookieName, HttpServletRequest request){
			String cookieValue = "";
			Cookie[] cookies = request.getCookies() ;
	        if(cookies != null){
	            for(int i=0; i < cookies.length; i++){
	                Cookie c = cookies[i] ;
	                if(c.getName().equals(cookieName)){
	                	cookieValue = c.getValue();
	                }

	            }
	        }
	        return cookieValue;
		}
		
		/*******************************  엑셀 코멘트  달기 ***********************************/
		public Comment makeComment(int width, int height, String contents, Cell cell, Row row, Sheet sheet1, Workbook xlsWb) {
			Drawing drawing = sheet1.createDrawingPatriarch();
			CreationHelper factory = xlsWb.getCreationHelper();
			
			ClientAnchor anchor = factory.createClientAnchor();
			anchor.setCol1(cell.getColumnIndex());
			anchor.setCol2(cell.getColumnIndex() + width);
			anchor.setRow1(row.getRowNum());
			anchor.setRow2(row.getRowNum() + height);

			Comment comment = drawing.createCellComment(anchor);
			RichTextString str = factory.createRichTextString(contents);
			comment.setString(str);
			
			return comment;
		}
		
		/*******************************  엑셀 drop down ***********************************/
		public void makeDropDown(Sheet sheet1, int colNum, List<CommonCodeVO> codeList) {
			String[] codeArr = new String[codeList.size()];
			for(int i=0; i<codeList.size(); i++) {
				codeArr[i] = codeList.get(i).getCode_name();
			}
			
			//CellRangeAddressList(int firstRow, int lastRow, int firstCol, int lastCol)
			/* HSSFWorkbook 일 경우 */
			CellRangeAddressList addressList = new CellRangeAddressList(1, 1000, colNum, colNum);	
	        DVConstraint dvConstraint = DVConstraint.createExplicitListConstraint(codeArr);
	        DataValidation dataValidation = new HSSFDataValidation(addressList, dvConstraint);
	        dataValidation.setSuppressDropDownArrow(false);
	        sheet1.addValidationData(dataValidation);
			
			/*XSSFDataValidationHelper dvHelper = new XSSFDataValidationHelper((XSSFSheet) sheet1);
			XSSFDataValidationConstraint dvConstraint = (XSSFDataValidationConstraint)
			dvHelper.createExplicitListConstraint(codeArr);
			CellRangeAddressList addressList = new CellRangeAddressList(1, 1000, colNum, colNum);
			XSSFDataValidation validation = (XSSFDataValidation)dvHelper.createValidation(dvConstraint, addressList);
			validation.setShowErrorBox(true);
			sheet1.addValidationData(validation);*/
			
		}

		/*******************************  엑셀 다중 선택 입력 항목일 경우 코드 명  return ***********************************/
		public String makeMultiCodeStr(List<CommonCodeVO> list) {
			String str = "";
			String code = "";
			for(CommonCodeVO vo : list) {
				code += ","+vo.getCode_name();
			}
			code = code.substring(1);
			str = "다중입력항목입니다.\r\n아래의 항목 중에서 콤마(,)로 구분하여 입력해주세요.\r\n"+"["+code+"]";
			return str;
		}
		
		
		/*******************************  Interceptor 관련 ***********************************/
		public String stripContextPath(String url,String contextPath){
			if(contextPath.equals("/")|| StringUtils.isEmpty(contextPath)){
				//처리 없음
			}else{
				url = url.replace(contextPath, "");
			}

			return url;
		}
		
		public String makeForlderUrl(String url, String contextPath){ //폴더url 만들기
			String mkUrl = "";
			try{
					String[] UrlArr =  url.split("/");
					if(UrlArr.length > 0){// for문
						for(int k=0;k<UrlArr.length-1;k++){
							//logger.debug("k==: "+k +" : "+ UrlArr[k]);
							if(UrlArr.length > 2 && k==1){// /test.do 형태가 아니고 두번째 로테이션에는 / 안붙임

							}else{
								mkUrl+="/";
							}



							if(UrlArr.length > 2 && k==UrlArr.length-2){ // /test.do 형태가 아니고 마지막일때는 / 붙임
								mkUrl+=UrlArr[k]+"/";
							}else{
								mkUrl+=UrlArr[k];
							}
						}
					}

					//contextPath 처리
					if(contextPath.equals("/")|| StringUtils.isEmpty(contextPath)){
						//처리 없음
					}else{
						mkUrl = mkUrl.replace(contextPath, "");
					}
			}catch(Exception e){
				System.out.print(e.toString());
			}
			return mkUrl;
		}

	public String toStringNull(Object obj) {
		return (obj == null) ? null : obj.toString();
	}
	
	public static boolean isLong(String str) {
		try {
			long l = Long.parseLong(str);
		} catch (NumberFormatException nfe) {
			return false;
		}
		return true;
	}
	
	
	 public static Map<String, Object>  broswserInfo(HttpServletRequest request){
			
			String agent = request.getHeader("USER-AGENT");


			
			/*
			String[] headerList = header.split(";");
			String broswser = "";		
			
			if( header.indexOf("iPhone") != -1 ) {
				broswser = "IPHONE";
			} else if( header.indexOf("Android") != -1 && header.indexOf("Mobile") > -1) {
				broswser = "ANDROID";
			} else if( header.indexOf("Opera") != -1 ) {
				broswser = "OPERA";
			} else if( header.indexOf("Navigator") != -1 ) {
				broswser = "NETSCAPE";
			} else if( header.indexOf("Firefox") != -1 ) {
				broswser = "FIREFOX";
			} else if( header.indexOf("Chrome") != -1 ) {
				broswser = "CHROME";
			} else if(  header.indexOf("Trident") != -1) {
				broswser = "EXPLORER";
			} else if(  header.indexOf("MSIE") != -1 ) {
				if( headerList.length > 1 ) {
					broswser = headerList[1].trim();
				}
			} else {
				broswser = "OTHER";
			}
					
			String os = "";
			
			if( broswser.equals("OTHER") ) {
				if( headerList.length > 1 ) {
					os = headerList[1].trim().replace(")",""); 
				}
			} else {
				if( headerList.length > 2 ) {
					os = headerList[2].trim().replace(")","");
				}
			}
			
			if( os.equals("U") ) {
				if( headerList.length > 2 ) {
					os = headerList[2].trim().replace(")","");
				}
			}
			
			if( broswser.equals("OPERA") ) {
				if( os.equals("U") ) {
					if( headerList.length > 1 ) {
						os = headerList[1].trim().replace(")",""); 
					}
				} else {
					if( headerList.length > 1 ) {
						os = headerList[0].trim().replace(")","");
						os = os.substring(os.indexOf("Windows"),os.length());
					}
				}
			}
			
			if( broswser.equals("FIREFOX") ) {
				if( os.equals("U") ) {
					if( headerList.length > 1 ) {
						os = headerList[1].trim().replace(")",""); 
					}
				} else {
					if( headerList.length > 1 ) {
						os = headerList[0].trim().replace(")","");
						os = os.substring(os.indexOf("Windows"),os.length());
					}
				}
			}
			
			if( broswser.equals("CHROME") ) {
				if( os.equals("U") ) {
					if( headerList.length > 1 ) {
						os = headerList[1].trim().replace(")",""); 
					}
				} else {
					if( headerList.length > 1 ) {
						os = headerList[0].trim().replace(")","");
						os = os.substring(os.indexOf("Windows"),os.length());
					}
				}
			}

			*/
			
			String os = getClientOS(agent);
			String broswser = getClientBrowser(agent);
			String ip = (String)request.getHeader("X-Forwarded-For");
			if(ip == null || ip.length() == 0 || ip.toLowerCase().equals("unknown")) ip = (String)request.getRemoteAddr();
			
			Map<String, Object> map = new HashMap<String, Object>();

			map.put("ip", ip);
			map.put("header", agent);
			map.put("os", os);
			map.put("broswser", broswser);
			return map;
		}
	 

	 public static String getClientOS(String userAgent) {	    	
	    	String os = "";	    	
			userAgent = userAgent.toLowerCase();
			if (userAgent.indexOf("windows nt 10.0") > -1) {
				os = "Windows10";
			}else if (userAgent.indexOf("windows nt 6.1") > -1) {
				os = "Windows7";
			}else if (userAgent.indexOf("windows nt 6.2") > -1 || userAgent.indexOf("windows nt 6.3") > -1 ) {
				os = "Windows8";
			}else if (userAgent.indexOf("windows nt 6.0") > -1) {
				os = "WindowsVista";
			}else if (userAgent.indexOf("windows nt 5.1") > -1) {
				os = "WindowsXP";
			}else if (userAgent.indexOf("windows nt 5.0") > -1) {
				os = "Windows2000";
			}else if (userAgent.indexOf("windows nt 4.0") > -1) {
				os = "WindowsNT";
			}else if (userAgent.indexOf("windows 98") > -1) {
				os = "Windows98";
			}else if (userAgent.indexOf("windows 95") > -1) {
				os = "Windows95";
			}else if (userAgent.indexOf("iphone") > -1) {
				os = "iPhone";
			}else if (userAgent.indexOf("ipad") > -1) {
				os = "iPad";
			}else if (userAgent.indexOf("android") > -1) {
				os = "android";
			}else if (userAgent.indexOf("mac") > -1) {
				os = "mac";
			}else if (userAgent.indexOf("linux") > -1) {
				os = "Linux";
			}else{
				os = "Other";
			}	    	
	    	return os;
	    }


	 
   public static String getClientBrowser(String userAgent) {
    	String browser = "";
    	
    	if (userAgent.indexOf("Trident/7.0") > -1) {
			browser = "ie11";
		}
    	else if (userAgent.indexOf("MSIE 10") > -1) {
			browser = "ie10";
		}
		else if (userAgent.indexOf("MSIE 9") > -1) {
			browser = "ie9";
		}
		else if (userAgent.indexOf("MSIE 8") > -1) {
			browser = "ie8";
		}
		else if (userAgent.indexOf("Chrome/") > -1) {
			browser = "Chrome";
		}
		else if (userAgent.indexOf("Chrome/") == -1 && userAgent.indexOf("Safari/") >= -1) {
			browser = "Safari";
		}
		else if (userAgent.indexOf("Firefox/") >= -1) {
			browser = "Firefox";
		}
		else {
			browser ="Other";
		}
    	return browser;
    }
	 
	 //=================================Excel Down load function========================================
	 public boolean fileDownNormal(String url , String fileName ,String Extention ,
				HttpServletResponse response,HttpServletRequest request) throws Exception{
				boolean res = true;
				File uFile = new File(url,fileName);
				int fSize = (int)uFile.length();
				boolean denyFile = CommonFunctions.denyfileExtention(Extention);
				if (fSize > 0 && denyFile==false ){
				String mimetype = "application/x-msdownload";
				
				response.setContentType(mimetype);
				setDisposition(fileName.replace(","," "), request, response);
				response.setContentLength(fSize);
				
				BufferedInputStream in = null;
				BufferedOutputStream out = null;
				
				try {
					in = new BufferedInputStream(new FileInputStream(uFile));
					out = new BufferedOutputStream(response.getOutputStream());
					
					FileCopyUtils.copy(in, out);
					out.flush();
				} catch (Exception ex) {
					System.out.println("IGNORED: " + ex.getMessage());
					res = false;
				} finally {
						if (in != null) {
						try {
							
						} catch (Exception ignore) {
							System.out.println("IGNORED: " + ignore.getMessage());
						}
					}
					if (out != null) {
						try {
							out.close();
						} catch (Exception ignore) {
							System.out.println("IGNORED: " + ignore.getMessage());
						}
					}
				}
				
				}else{
					res = false;
				}
				
					return res;
				}

	 
	 	
	 
	 
	 private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		    String browser = getBrowser(request);

		    String dispositionPrefix = "attachment; filename=";
		    String encodedFilename = null;

		    if (browser.equals("MSIE")) {
		        encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		    } else if (browser.equals("Firefox")) {
		        encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		    } else if (browser.equals("Opera")) {
		        encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		    } else if (browser.equals("Chrome")) {
		        StringBuffer sb = new StringBuffer();
		        for (int i = 0; i < filename.length(); i++) {
		        char c = filename.charAt(i);
		        if (c > '~') {
		            sb.append(URLEncoder.encode("" + c, "UTF-8"));
		        } else {
		            sb.append(c);
		        }
		        }
		        encodedFilename = sb.toString();

		    } else if (browser.equals("Trident")) {        // IE11 문자열 깨짐 방지
		        encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");

		    } else {
		        //throw new RuntimeException("Not supported browser");
		        throw new IOException("Not supported browser");
		    }

		    response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		    if ("Opera".equals(browser)){
		        response.setContentType("application/octet-stream;charset=UTF-8");
		    }
	}
	 
	 private String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        } else if (header.indexOf("Trident") > -1) {    // IE11 문자열 깨짐 방지
            return "Trident";
        }
        return "Firefox";
    }
	 
    public String html2text(String html) {
    	return Jsoup.parse(html).text();
    }
    
	public int str2int(String num) {
		try {
			return Integer.parseInt(num);
		} catch (NumberFormatException e) {
			System.out.println("parse Error : [ " + num + " ] does not contain a parsable integer");
			return 0;
		}

	}
	 
	 public void fileDeleteInDir(String path){
		 File file = new File(path);         
	        if( file.exists() ){ //파일존재여부확인	             
	            if(file.isDirectory()){ //파일이 디렉토리인지 확인	                 
	                File[] files = file.listFiles();	                 
	                for( int i=0; i<files.length; i++){
	                    if( files[i].delete() ){
	                        System.out.println(files[i].getName()+": 삭제성공");
	                    }else{
	                        System.out.println(files[i].getName()+": 삭제실패");
	                    }
	                }	                 
	            }
	            if(file.delete()){
	                System.out.println("파일삭제 성공");
	            }else{
	                System.out.println("파일삭제 실패");
	            }	             
	        }else{
	            System.out.println("파일이 존재하지 않습니다.");
	        }

	 }
	//=================================Excel Down load function========================================

	public static void printParameter(HttpServletRequest request) {
		Enumeration<?> enumeration = request.getParameterNames();
		while (enumeration.hasMoreElements()) {
			String parameterName = (String) enumeration.nextElement();
			System.out.print(parameterName + " : ");
			System.out.println(request.getParameter(parameterName));
		}
	}
	
	public static int parseInt(String value) {
		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return 0;
		}
	}
	
	public static Integer parseIntegerOrNull(String value) {
		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return null;
		}
	}
	
	public static long parseLong(String value) {
		try {
			return Long.parseLong(value);
		} catch (NumberFormatException e) {
			return 0l;
		}
	}
	
	public static double parseDouble(String value) {
		try {
			return Double.parseDouble(value);
		} catch (NumberFormatException e) {
			return 0d;
		}
	}
	
	public static Double parseDoubleOrNull(String value) {
		try {
			return Double.parseDouble(value);
		} catch (NumberFormatException e) {
			return null;
		}
	}
	
	public static String round3(String value) {
		try {
			return String.format("%.3f", Double.parseDouble(value));
		} catch (Exception e) {
			return value;
		}
	}
	
	public static String getCommaSeperatedWithDoubleQuotes(List<String> list) {
		//return list.stream().map(x -> "\"" + x + "\"").collect(Collectors.joining(","));
		return "\"" + String.join("\",\"", list) + "\"";
	}
	
	public static String getTimestamp() {
	     return new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date(System.currentTimeMillis()));
	}
	
	public static <T> List<List<T>> splitList(List<T> srcList, int count) {
		if (srcList == null || count < 1)
			return null;
		List<List<T>> ret = new ArrayList<List<T>>();
		int size = srcList.size();
		if (size <= count) {
			// 데이터 부족 count 지정 크기
			ret.add(srcList);
		} else {
			int pre = size / count;
			int last = size % count;
			// 앞 pre 개 집합, 모든 크기 다 count 가지 요소
			for (int i = 0; i < pre; i++) {
				List<T> itemList = new ArrayList<T>();
				for (int j = 0; j < count; j++) {
					itemList.add(srcList.get(i * count + j));
				}
				ret.add(itemList);
			}
			// last 처리
			if (last > 0) {
				List<T> itemList = new ArrayList<T>();
				for (int i = 0; i < last; i++) {
					itemList.add(srcList.get(pre * count + i));
				}
				ret.add(itemList);
			}
		}
		return ret;
	}
	 
}
