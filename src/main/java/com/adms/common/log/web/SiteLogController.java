package com.adms.common.log.web;


import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.ModelAttribute;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.code.service.CommonCodeService;
import com.adms.common.log.service.MenuLogService;
import com.adms.common.log.service.SiteLogService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_siteLogVO;
import com.bsite.vo.tbl_siteVO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


@Controller
public class SiteLogController {
	private final static Logger logger = LoggerFactory.getLogger("com");	
	
	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;
	
	@Resource(name = "MenuLogService")
    private MenuLogService menuLogService;

	@Resource(name = "SiteLogService")
    private SiteLogService siteLogService;
	
	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	
	
	
	@RequestMapping(value = "/adms/common/sitelog/month/list.do")
	public String sitelog_month(
			@ModelAttribute("searchVO") tbl_siteLogVO searchVO,
			Model model) throws Exception {			

		Map<String, Object> searchMap = new HashMap<String, Object>();			
		Calendar cal = Calendar.getInstance();
		int year =  cal.get(Calendar.YEAR);
		
		model.addAttribute("year", year);
		 
		//메뉴 sitecode 리스트 불러옴
		List<tbl_siteVO> siteCodeList = menuLogService.getSiteList();			
		model.addAttribute("siteCodeList", siteCodeList);
		
		if(searchVO.getSearch_siteCode() == null) {				
			searchVO.setSearch_siteCode(siteCodeList.get(0).getSite_code());				
		}
							
		
		String cretDate="";
		
		searchMap.put("site_code",  searchVO.getSearch_siteCode());
		
		searchMap.put("size", 7);
		
		if(searchVO.getSearch_date() == null){			 						 			
			cretDate = Integer.toString(year);
		}else{
			cretDate = searchVO.getSearch_date();
		
		}
		
		searchMap.put("cret_date", cretDate);
		searchVO.setSearch_date(cretDate);
		
		
    	List<tbl_siteLogVO> siteLogVO = siteLogService.getSiteLogList(searchMap);
    	    	    	
        Integer totalNum = siteLogService.getlogTotalNum(siteLogVO);
    	                        
        List<tbl_siteLogVO> siteLogList = siteLogService.getRatioList(siteLogVO, totalNum);  
        
    	model.addAttribute("resultList", siteLogList);
    	
    	model.addAttribute("resultCnt", totalNum);
    		
		model.addAttribute("LEFT_MENU_GROUP", "sitelog_month");
		return "tiles:adms/common/siteLog/monthList";
				
	}
	
	
	
	@RequestMapping(value = "/adms/common/sitelog/days/list.do")
	public String sitelog_days(
			@ModelAttribute("searchVO") tbl_siteLogVO searchVO,
			Model model) throws Exception {			

    	
		Map<String, Object> searchMap = new HashMap<String, Object>();			
		 
		Calendar cal = Calendar.getInstance();
		int year =  cal.get(Calendar.YEAR);	
		int month = cal.get(Calendar.MONTH)+1;			
		
		model.addAttribute("year", year);
		 
		//메뉴 sitecode 리스트 불러옴
		List<tbl_siteVO> siteCodeList = menuLogService.getSiteList();			
		model.addAttribute("siteCodeList", siteCodeList);
		
		if(searchVO.getSearch_siteCode() == null) {				
			searchVO.setSearch_siteCode(siteCodeList.get(0).getSite_code());				
		}
						
		searchMap.put("site_code",  searchVO.getSearch_siteCode());
		    	
		searchMap.put("size", 10);
		String cretDate="";
		
		if(searchVO.getSearch_date() == null){			
			searchVO.setLog_year(Integer.toString(year));
			searchVO.setLog_month(Integer.toString(month));
			cretDate = Integer.toString(year)+"-"+String.format("%02d", month);	
		}else{			
			String[] date = searchVO.getSearch_date().split("-");
			searchVO.setLog_year(date[0]);
			searchVO.setLog_month(date[1]);		
			cretDate = date[0]+"-"+String.format("%02d", Integer.parseInt(date[1]));			
		}
		
		searchMap.put("cret_date", cretDate);
		
    	List<tbl_siteLogVO> siteLogVO = siteLogService.getSiteLogList(searchMap);
    	    	    	
        Integer totalNum = siteLogService.getlogTotalNum(siteLogVO);
    	 
        List<tbl_siteLogVO> siteLogList = siteLogService.getRatioList(siteLogVO, totalNum);        
        
    	model.addAttribute("resultList", siteLogList);
    	model.addAttribute("resultCnt", totalNum);
    		
		model.addAttribute("LEFT_MENU_GROUP", "sitelog_days");
		return "tiles:adms/common/siteLog/daysList";
				
	}
	
	
	@RequestMapping(value = "/adms/common/sitelog/time/list.do")
	public String sitelog_time(
			@ModelAttribute("searchVO") tbl_siteLogVO searchVO,
			Model model) throws Exception {			

    	
		Map<String, Object> searchMap = new HashMap<String, Object>();
				
		//메뉴 sitecode 리스트 불러옴
		List<tbl_siteVO> siteCodeList = menuLogService.getSiteList();			
		model.addAttribute("siteCodeList", siteCodeList);
		
		if(searchVO.getSearch_siteCode() == null) {				
			searchVO.setSearch_siteCode(siteCodeList.get(0).getSite_code());				
		}
						
		searchMap.put("site_code",  searchVO.getSearch_siteCode());
		    	
		
		String cretDate="";

		
		searchMap.put("size", 13);
		
		
		if(searchVO.getSearch_date()==null){
			 Calendar cal = Calendar.getInstance();
			 int year =  cal.get(Calendar.YEAR);	
			 int month = cal.get(Calendar.MONTH)+1;
			 int date  = cal.get(Calendar.DATE);
			 cretDate = Integer.toString(year)+"-"+String.format("%02d", month)+"-"+String.format("%02d", date);
			 searchVO.setSearch_date(cretDate);
			 			 
		}else{
			cretDate = searchVO.getSearch_date();
		}
		
		
		searchMap.put("cret_date", cretDate);
		
    	List<tbl_siteLogVO> siteLogVO = siteLogService.getSiteLogList(searchMap);
    	    	    	
        Integer totalNum = siteLogService.getlogTotalNum(siteLogVO);
    	 
        List<tbl_siteLogVO> siteLogList = siteLogService.getRatioList(siteLogVO, totalNum);        
		
        model.addAttribute("siteCodeList", siteCodeList);
    	model.addAttribute("resultList", siteLogList);
    	model.addAttribute("resultCnt", totalNum);
    		
		model.addAttribute("LEFT_MENU_GROUP", "sitelog_time");
		return "tiles:adms/common/siteLog/timeList";
				
	}	
	
	
	@RequestMapping(value = {"/adms/common/sitelog/month/excelDown.do"
								,"/adms/common/sitelog/days/excelDown.do"
								  ,"/adms/common/sitelog/time/excelDown.do"},method=RequestMethod.GET)
	public void daysExcelDown (
			@ModelAttribute("searchVO") tbl_siteLogVO searchVO,
			@RequestParam("dateType") String  dateType,
			 HttpServletRequest request, HttpServletResponse response,
			Model model) throws Exception {			

			Map<String, Object> searchMap = new HashMap<String, Object>();			
			
		
			 Calendar cal = Calendar.getInstance();
			 int year =  cal.get(Calendar.YEAR);	
			 int month = cal.get(Calendar.MONTH)+1;
			 int date  = cal.get(Calendar.DATE);
			 								
			
			model.addAttribute("year", year);
			 
			
			//메뉴 sitecode 리스트 불러옴
			List<tbl_siteVO> siteCodeList = menuLogService.getSiteList();			
			model.addAttribute("siteCodeList", siteCodeList);
			
			if(searchVO.getSearch_siteCode() == null) {				
				searchVO.setSearch_siteCode(siteCodeList.get(0).getSite_code());				
			}
							
			searchMap.put("site_code",  searchVO.getSearch_siteCode());
			
			String cretDate="";
			String xml_name="";
			int sizeNum=0;			
				
			if(dateType.equals("month")) {
				
				sizeNum =7;
				xml_name="월별통계";
				
				if(searchVO.getSearch_date() == null  || searchVO.getSearch_date().equals("")){			 						 			
					cretDate = Integer.toString(year);
				}else{
					cretDate = searchVO.getSearch_date();					
				}
				
			}else if(dateType.equals("days")){
				
				sizeNum =10;
				xml_name="일별통계";
				
				if(searchVO.getSearch_date() == null || searchVO.getSearch_date().equals("")){
					
					searchVO.setLog_year(Integer.toString(year));
					searchVO.setLog_month(Integer.toString(month));
					cretDate = Integer.toString(year)+"-"+String.format("%02d", month);
					
				}else{			
					String[] dateSplit = searchVO.getSearch_date().split("-");
					searchVO.setLog_year(dateSplit[0]);
					searchVO.setLog_month(dateSplit[1]);		
					cretDate = dateSplit[0]+"-"+String.format("%02d", Integer.parseInt(dateSplit[1]));			
				}
				
			}else if(dateType.equals("times")){
				
				sizeNum =13;
				xml_name="시간별통계";
								
				if(searchVO.getSearch_date()==null  || searchVO.getSearch_date().equals("")){
					 cretDate = Integer.toString(year)+"-"+String.format("%02d", month)+"-"+String.format("%02d", date);
					 searchVO.setSearch_date(cretDate);
					 			 
				}else{
					cretDate = searchVO.getSearch_date();
				}
				
			}
					
			
			searchMap.put("size", sizeNum);
			searchMap.put("cret_date", cretDate);
			
	    	List<tbl_siteLogVO> siteLogVO = siteLogService.getSiteLogList(searchMap);
	    	    	    	
	        Integer totalNum = siteLogService.getlogTotalNum(siteLogVO);
	    	 
	        List<tbl_siteLogVO> siteLogList = siteLogService.getRatioList(siteLogVO, totalNum);  
								   
   	    
		    XSSFWorkbook wb = new XSSFWorkbook();
		    XSSFSheet sheet = wb.createSheet("sheet");
	   	    int rownum = 0;
	   	    int colidx = 0;
	   
	   	    Date today = new Date();
	   	    SimpleDateFormat sdate = new SimpleDateFormat("yyyy-MM-dd");
	   	    XSSFRow header = sheet.createRow(rownum++);;
		   	        	   	    	   				           	   	
		    header.createCell(colidx++).setCellValue("번호");
		    header.createCell(colidx++).setCellValue("사이트");
		    header.createCell(colidx++).setCellValue("일별");
		    header.createCell(colidx++).setCellValue("접속수");
		    header.createCell(colidx++).setCellValue("비율");


		        // Create data cells		      
		      int idx = 1;	      
		      for (tbl_siteLogVO siteLog : siteLogList)
		      {
		    	  colidx = 0;
		          XSSFRow rowed = sheet.createRow(rownum++);	          	                             
		          rowed.createCell(colidx++).setCellValue(idx++);
		          rowed.createCell(colidx++).setCellValue(siteLog.getSite_name());	
		          rowed.createCell(colidx++).setCellValue(siteLog.getCdate());		          
		          rowed.createCell(colidx++).setCellValue(siteLog.getTotal());
		          rowed.createCell(colidx++).setCellValue(siteLog.getRatio());		                    
		      }
		      
			  for(int i=0; i<siteLogVO.size(); i++){
					 sheet.autoSizeColumn(i);
					 sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+600);  
			  }
			  
		      response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(xml_name+sdate.format(today)+".xlsx", "UTF-8") + ";");
		      response.setContentType("application/octet-stream; charset=UTF-8");
		      wb.write(response.getOutputStream());  	    	            	                            	    		                          
				
	}		
	
}
