package com.bsite.cmm.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @Class Name : CommonPopUpController.java
 * @Description : 공통으로 사용해야할 팝업 컨트롤러 2
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
public class CommonPopUpController2 {
	
	private final static Logger logger = LoggerFactory.getLogger("com");
	
	@Resource(name = "LoginService")
    private LoginService loginService;

	//  /cmm/ 의 주소로 시작

}
