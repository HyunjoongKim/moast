package com.adms.common.log.web;


import java.net.URLEncoder;
import java.util.List;
import java.util.Date;
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
import com.adms.common.log.service.AdminLogService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.tbl_adminLogVO;




import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


@Controller
public class AdminLogController {
	private final static Logger logger = LoggerFactory.getLogger("com");
	private String LEFT_MENU_GROUP = "adminlog_list"; //left select menu name
	
	@Resource(name = "LoginService")
    private LoginService loginService;
	
	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;
	
	@Resource(name = "AdminLogService")
    private AdminLogService adminLogService;
	
	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	@RequestMapping(value = "/adms/common/adminlog/list.do")
	public String list(
			@ModelAttribute("searchVO") tbl_adminLogVO searchVO,
			Model model) throws Exception {			

		try{


			/* 페이징 시작 */
	    	PaginationInfo paginationInfo = new PaginationInfo();

	    	paginationInfo.setCurrentPageNo(searchVO.getPageIndex());		//현재 페이지 번호
	    	paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());	//한 페이지에 게시되는 게시물 건수
	    	paginationInfo.setPageSize(searchVO.getPageSize());				//페이징 리스트의 사이즈

	    	searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
	    	searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
	    	searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
	    		   	    
	    	int totCnt = adminLogService.getAdminLogCnt(searchVO);

	    	paginationInfo.setTotalRecordCount(totCnt);
	    	
	    	model.addAttribute("resultList",  adminLogService.getAdminLogList(searchVO));
	    	model.addAttribute("resultCnt",  totCnt);
	    	model.addAttribute("totalPageCnt", (int)Math.ceil(totCnt / (double)searchVO.getPageUnit()));
	    	model.addAttribute("paginationInfo", paginationInfo);
	    	/* 페이징 끝 */
	    		    	
	    	
			List<CommonCodeVO> menuCodeList = loginService.getDefaultCodeList("457");	 //접근컨텐츠
	    	model.addAttribute("menuCodeList", menuCodeList);
	    	
			List<CommonCodeVO> gubunList = loginService.getDefaultCodeList("446");		//구분
	    	model.addAttribute("gubunList", gubunList);
	    	
	    	model.addAttribute("ipList",  adminLogService.getAdminLogIpList()); 
	    	
		}catch(Exception e){
			System.out.println(e.toString());
    	}

		model.addAttribute("LEFT_MENU_GROUP", LEFT_MENU_GROUP);
		
		return "tiles:adms/common/adminLog/list";
				
	}
	
	
	@RequestMapping(value = "/adms/common/adminlog/excelDown.do", method=RequestMethod.GET)
	public void timeExcelDown (
			@ModelAttribute("searchVO") tbl_adminLogVO searchVO,
			 HttpServletRequest request, HttpServletResponse response,
			Model model) throws Exception {			
				
			    	 
		        List<tbl_adminLogVO> adminLogList = adminLogService.getAdminLogExcelList(searchVO);     
									   	   	    
			    XSSFWorkbook wb = new XSSFWorkbook();
			    XSSFSheet sheet = wb.createSheet("sheet");
		   	    int rownum = 0;
		   	    int colidx = 0;
		   
		   	    Date today = new Date();
		   	    SimpleDateFormat sdate = new SimpleDateFormat("yyyy-MM-dd");
		   	    XSSFRow header = sheet.createRow(rownum++);;
			   	        	   	    	   				           	   	
			    header.createCell(colidx++).setCellValue("번호");
			    header.createCell(colidx++).setCellValue("아이디");
			    header.createCell(colidx++).setCellValue("접근컨텐츠");
			    header.createCell(colidx++).setCellValue("구분");
			    header.createCell(colidx++).setCellValue("내용");
			    header.createCell(colidx++).setCellValue("아이피");
			    header.createCell(colidx++).setCellValue("등록날짜");	
			        // Create data cells		      
			      int idx = 1;	      
			      
			      List<CommonCodeVO> menuCodeList = loginService.getDefaultCodeList("457");		//접근컨텐츠
			   
				  List<CommonCodeVO> gubunList = loginService.getDefaultCodeList("446");		//구분
		
				  String MenuName ="";
				  String gubunName ="";
				  
				  
			      for (int t=0; t<adminLogList.size(); t++)
			      {
			    	  colidx = 0;
			          XSSFRow rowed = sheet.createRow(rownum++);	          	                             
			          rowed.createCell(colidx++).setCellValue(idx++);
			          rowed.createCell(colidx++).setCellValue(adminLogList.get(t).getCret_id());

				      for(CommonCodeVO menucode : menuCodeList ) {
				    	  if(adminLogList.get(t).getMenu_code().equals(menucode.getMain_code())) { 
				    		  MenuName = menucode.getCode_name();	    	  
				    	  }
				      }
					  					  
					  rowed.createCell(colidx++).setCellValue(MenuName);
						
				      
				      for(CommonCodeVO menucode : gubunList ) {
				    	  
				    	  if(adminLogList.get(t).getGubun().equals(menucode.getMain_code())) { 
				    		  gubunName = menucode.getCode_name();	    	  
				    	  }
				      }
				      					  
					  rowed.createCell(colidx++).setCellValue(gubunName);					  
				      rowed.createCell(colidx++).setCellValue(adminLogList.get(t).getInfor());
			          rowed.createCell(colidx++).setCellValue(adminLogList.get(t).getCret_ip());			          

			          CellStyle cellStyle = wb.createCellStyle();
			          CreationHelper createHelper = wb.getCreationHelper();
			          cellStyle.setDataFormat(createHelper.createDataFormat().getFormat("m/d/yy h:mm"));			          
			          Cell cell  =  rowed.createCell(colidx++);
			          cell.setCellValue(adminLogList.get(t).getCret_date());
			          cell.setCellStyle(cellStyle);
			      }
			      
				  for(int i=0; i<adminLogList.size(); i++){
						 sheet.autoSizeColumn(i);
						 sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+600);  
				  }
				  
			      response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("관리자 로그"+sdate.format(today)+".xlsx", "UTF-8") + ";");
			      response.setContentType("application/octet-stream; charset=UTF-8");
			      wb.write(response.getOutputStream());  	    	            	                            	    		                          
				
	}	
	
	
	
}
