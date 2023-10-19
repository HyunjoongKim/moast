package com.adms.common.right.web;

import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.common.code.service.CommonCodeService;
import com.adms.common.menu.service.MenuAuth2Service;
import com.adms.common.menu.service.MenuAuthService;
import com.adms.member.service.AuthManage2Service;
import com.adms.member.service.AuthManageService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.LoginVO;
import com.bsite.vo.tbl_menu_subVO;



@Controller
public class RightManageControll {

	private final static Logger logger = LoggerFactory.getLogger("com");
	private final String LEFT_MENU_GROUP = "menu_manage"; //left select menu name

	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;

	@Resource(name = "MenuAuthService")
    private MenuAuthService menuauthservice;

	@Resource(name = "AuthManageService")
    private AuthManageService authManageService;

	@Resource(name = "MenuAuth2Service")
    private MenuAuth2Service menuauth2service;

	@Resource(name = "AuthManage2Service")
    private AuthManage2Service authManage2Service;


	//권한을 하나로 쓰기위해 menu url에 포함시킨다.
	//권한가져오기
	@RequestMapping(value="/adms/common/menu/list_right_ajax.do",method = RequestMethod.POST)
	@ResponseBody
	public String  list_right_ajax(tbl_menu_subVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		JSONObject resMap = new JSONObject();
		try{

			//searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드
			List<tbl_menu_subVO> list = menuauth2service.getRightList(searchVO);
			resMap.put("res", "ok");
			resMap.put("msg", "성공");
			resMap.put("rightList", list);

		}catch(Exception e){
			logger.debug("ajax 부르기 Error");
			resMap.put("res", "error");
			resMap.put("msg", "알수없는 오류가 발생하였습니다.");
    	}

		out.print(resMap);
		return null;

	}

	//


	@SuppressWarnings("unchecked")
	@RequestMapping(value="/adms/common/menu/create_right.do",method = RequestMethod.POST)
	@ResponseBody
	public String  create_right(
			@RequestBody String filterJSON,
			ModelMap model,
			HttpServletResponse res
			) throws Exception {
		JSONObject resMap = new JSONObject();
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		LoginVO loginVO = loginService.getLoginInfo();
		//loginVO.setSite_code(loginService.getSiteCode());
		//logger.debug("filterJSON : "+filterJSON);
		try{
			org.json.simple.parser.JSONParser jsonParser = new JSONParser();
			ObjectMapper mapper = new ObjectMapper();
			org.json.simple.JSONObject jsonObject = (org.json.simple.JSONObject) jsonParser.parse(filterJSON);


			org.json.simple.JSONArray rdata= (org.json.simple.JSONArray) jsonObject.get("rData");
	        List<tbl_menu_subVO> rdataList =(List<tbl_menu_subVO>)mapper.readValue( rdata.toJSONString(),new TypeReference<List<tbl_menu_subVO>>(){ });

	        String menuIdx = (String) jsonObject.get("menuIdx");
	        String site_code = (String) jsonObject.get("site_code");
	        
	        loginVO.setSite_code(site_code);  //사이트코드 
	        menuauth2service.createRight(rdataList,loginVO,menuIdx);

	        
	        
	        resMap.put("res", "ok");
			resMap.put("msg", "등록하였습니다.");

		}catch(Exception e){
			logger.debug(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}
		out.print(resMap);
		return null;

	}

}
