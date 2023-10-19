package com.bsite.cmm;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;




@Controller
@RequestMapping("/common/error")
public class CommonErrorController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	@RequestMapping(value = "/throwable.do")
    public String throwable( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		model.addAttribute("errorMsg","예외가 발생하였습니다.");
		return "tiles:bsite/common/error";
	}

	@RequestMapping(value = "/exception.do")
    public String exception( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		model.addAttribute("errorMsg","예외가 발생하였습니다.");
		return "tiles:bsite/common/error";
	}

	@RequestMapping(value = "/400.do")
    public String pageError400( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		pageErrorLog(request);
		model.addAttribute("errorMsg","잘못된 요청입니다.");
		return "tiles:bsite/common/error";
	}

	@RequestMapping(value = "/403.do")
    public String pageError403( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		model.addAttribute("errorMsg","접근이 금지되었습니다.");
		return "tiles:bsite/common/error";
	}

	@RequestMapping(value = "/404.do")
    public String pageError404( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		model.addAttribute("errorMsg","요청하신 페이지는 존재하지 않습니다.");
		return "tiles:bsite/common/error";
	}

	@RequestMapping(value = "/405.do")
    public String pageError405( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		model.addAttribute("errorMsg","요청된 메소드가 허용되지 않습니다.");
		return "tiles:bsite/common/error";
	}

	@RequestMapping(value = "/500.do")
    public String pageError500( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		model.addAttribute("errorMsg","서버에 오류가 발생하였습니다.");
		return "tiles:bsite/common/error";
	}

	@RequestMapping(value = "/503.do")
    public String pageError503( HttpServletRequest request, ModelMap model) {
		pageErrorLog(request);
		model.addAttribute("errorMsg","서비스를 사용할 수 없습니다.");
		return "tiles:bsite/common/error";
	}

	private void pageErrorLog(HttpServletRequest request){
		logger.info("status_code : " + request.getAttribute("javax.servlet.error.status_code"));
		logger.info("exception_type : " + request.getAttribute("javax.servlet.error.exception_type"));
		logger.info("message : " + request.getAttribute("javax.servlet.error.message"));
		logger.info("request_uri : " + request.getAttribute("javax.servlet.error.request_uri"));
		logger.info("exception : " + request.getAttribute("javax.servlet.error.exception"));
		logger.info("servlet_name : " + request.getAttribute("javax.servlet.error.servlet_name"));
	}

}
