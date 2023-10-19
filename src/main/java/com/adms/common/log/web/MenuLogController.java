package com.adms.common.log.web;


import java.net.URLEncoder;
import java.util.List;
import java.util.Date;
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

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.code.service.CommonCodeService;
import com.adms.common.log.service.MenuLogService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.tbl_menuLogVO;
import com.bsite.vo.tbl_menu_manageVO;
import com.bsite.vo.tbl_siteVO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


@Controller
public class MenuLogController {
	private final static Logger logger = LoggerFactory.getLogger("com");
	private String LEFT_MENU_GROUP = "menulog_list"; //left select menu name
	
	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;
	
	@Resource(name = "MenuLogService")
    private MenuLogService menuLogService;
	
	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	@RequestMapping(value = "/adms/common/menulog/list.do")
	public String list(
			@ModelAttribute("searchVO") tbl_menuLogVO searchVO,
			Model model) throws Exception {			

		try{
					
			//메뉴 sitecode 리스트 불러옴
			List<tbl_siteVO> siteCodeList = menuLogService.getSiteList();			
			model.addAttribute("siteCodeList", siteCodeList);
			
			if(searchVO.getSearch_siteCode() == null) {				
				searchVO.setSearch_siteCode(siteCodeList.get(0).getSite_code());				
			}
						
			
	    	List<tbl_menuLogVO> menuLogVO =   menuLogService.getMenuLogList(searchVO);	    	    	    	
	        Integer totalNum = menuLogService.getMenuLogListCnt(searchVO);
	    	 	               	        
	        
			DecimalFormat format = new DecimalFormat("0.00");
			
			for(int i=0; i<menuLogVO.size(); i++){
				double ratio = (double)menuLogVO.get(i).getTotal() / (double)totalNum * (double)100;
				menuLogVO.get(i).setRatio(format.format(ratio));										
			}
	        
	    	model.addAttribute("resultList", menuLogVO);
	    	model.addAttribute("resultCnt", totalNum);
	    		
			model.addAttribute("LEFT_MENU_GROUP", "menulog_list");
			
	    	
		}catch(Exception e){
			System.out.println(e.toString());
    	}

		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		
		return "tiles:adms/common/menuLog/list";
				
	}
	
	
	@RequestMapping(value = "/adms/common/menulog/excelDown.do",method=RequestMethod.GET)
	public void menuExcelDown (
			@ModelAttribute("searchVO") tbl_menuLogVO searchVO,
			 HttpServletRequest request, HttpServletResponse response,
			Model model) throws Exception {			

		
			List<tbl_siteVO> siteCodeList = menuLogService.getSiteList();			
			model.addAttribute("siteCodeList", siteCodeList);
		
			if(searchVO.getSearch_siteCode() == null) {				
				searchVO.setSearch_siteCode(siteCodeList.get(0).getSite_code());				
			}
					
		
    		List<tbl_menuLogVO> menuLogVO =   menuLogService.getMenuLogList(searchVO);	
	        Integer totalNum = menuLogService.getMenuLogListCnt(searchVO);
	    	 	               	        
	        
			DecimalFormat format = new DecimalFormat("0.00");
			
			for(int i=0; i<menuLogVO.size(); i++){
				double ratio = (double)menuLogVO.get(i).getTotal() / (double)totalNum * (double)100;
				menuLogVO.get(i).setRatio(format.format(ratio));										
			}
   	    
		    XSSFWorkbook wb = new XSSFWorkbook();
		    XSSFSheet sheet = wb.createSheet("sheet");
	   	    int rownum = 0;
	   	    int colidx = 0;
	   
	   	    Date today = new Date();
	   	    SimpleDateFormat sdate = new SimpleDateFormat("yyyy-MM-dd");
	   	    XSSFRow header = sheet.createRow(rownum++);;
		   	        	   	    	   				           	   	
		    header.createCell(colidx++).setCellValue("번호");
		    header.createCell(colidx++).setCellValue("사이트명");
		    header.createCell(colidx++).setCellValue("메뉴명");
		    header.createCell(colidx++).setCellValue("링크");
		    header.createCell(colidx++).setCellValue("조회수");
		    header.createCell(colidx++).setCellValue("비율");


		        // Create data cells		      
		      int idx = 1;	      
		      for (tbl_menuLogVO siteLog : menuLogVO)
		      {
		    	  colidx = 0;
		          XSSFRow rowed = sheet.createRow(rownum++);	          	                             
		          rowed.createCell(colidx++).setCellValue(idx++);
		          rowed.createCell(colidx++).setCellValue(siteLog.getSite_name());
		          rowed.createCell(colidx++).setCellValue(siteLog.getMenu_name());
		          rowed.createCell(colidx++).setCellValue(siteLog.getMenu_target());
		          rowed.createCell(colidx++).setCellValue(siteLog.getTotal());
		          rowed.createCell(colidx++).setCellValue(siteLog.getRatio());
		                    
		      }
		      
			  for(int i=0; i<menuLogVO.size(); i++){
					 sheet.autoSizeColumn(i);
					 sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+600);  
			  }
		      response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("메뉴별_통계_"+sdate.format(today)+".xlsx", "UTF-8") + ";");
		      response.setContentType("application/octet-stream; charset=UTF-8");
		      wb.write(response.getOutputStream());  	    	            	                            	    		                          
				
	}
	
	
	
}
