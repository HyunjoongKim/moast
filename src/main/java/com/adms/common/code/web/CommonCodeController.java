package com.adms.common.code.web;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.code.service.CommonCodeService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;


@Controller
public class CommonCodeController {

	private final static Logger logger = LoggerFactory.getLogger("com");
	private String LEFT_MENU_GROUP = "common_code_default"; //left select menu name


	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;

	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;


	//공통코드 메인 트리그리드 123
	@RequestMapping(value = {"/adms/common/code/list.do" ,
								"/adms/common/department/list.do" ,
								   "/adms/common/collection/list.do" ,
									 "/adms/common/resources/list.do" ,
									     "/adms/common/taxon/list.do" ,
									     "/adms/common/country/list.do"}
											, method = RequestMethod.GET)
	public String list(
			@ModelAttribute("searchVO") CommonCodeVO searchVO,
			Model model) throws Exception {
			//searchVO.setCode_cate("default"); //코드
			//maxdepth  default 4
		String re;

		// 임시 테스트용
		if(searchVO.getCode_cate().indexOf("ztree") != -1){
			re = "tiles:adms/common/code/zTree";
		}else{
			re = "tiles:adms/common/code/list";
		}
		
		
		int depth = 3;		
		if("default".equals(searchVO.getCode_cate())){
			depth = 2;
		}
		/*else if("depart".equals(tCode)){
			cIdx = 0;
		}else if("taxon".equals(tCode)){
			cIdx = 0;
		}
		*/
		
		String cIdx = commonCode2Service.getSlideCode(depth,searchVO.getCode_cate());  //depth , 카테고리
		
		
		
		model.addAttribute("cIdx", cIdx);
		model.addAttribute("LEFT_MENU_GROUP", returnLeftMenuName(searchVO.getCode_cate()));

		/*return "tiles:adms/common/code/list";*/
		return re;
	}
	
	String returnLeftMenuName(String v){
		if("default".equals(v)){
			LEFT_MENU_GROUP="common_code_default";
		}else if("depart".equals(v)){
			LEFT_MENU_GROUP="depart_manage";
		}else if("taxon".equals(v)){
			LEFT_MENU_GROUP="taxo_manage";
		}else if("collection".equals(v)){
			LEFT_MENU_GROUP="common_code_collection";
		}else if("resources".equals(v)){
			LEFT_MENU_GROUP="common_code_resources";
		}else if("country".equals(v)){
			LEFT_MENU_GROUP="common_code_country";
		}
		
		
		return LEFT_MENU_GROUP;
	}
	
	


	//트리 그리드 가져오기
	@RequestMapping(value="/adms/common/code/list_ajax.do",method = RequestMethod.POST)
	@ResponseBody
	public String  list_ajax(CommonCodeVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		JSONObject obj = new JSONObject();
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		try{

			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드
			//searchVO.setCode_cate("default"); //카테고리 (외부에서 받기)
			List<CommonCodeVO> gridData = commonCode2Service.getMainList(searchVO);

			if(searchVO.getCode_cate().indexOf("ztree") != -1){
				String treeNodsJson = JSONArray.fromObject(gridData).toString();
				out.print(treeNodsJson);
				out.close();
			}else{
				JSONArray list = JSONArray.fromObject(gridData);
				for(int i=0; i<list.size();i++){
					JSONObject vobj = list.getJSONObject(i);
					if(StringUtils.isEmpty(vobj.get("_parentId").toString())){
						vobj.remove("_parentId");
					}
					//logger.debug(i+" : "+vobj);
				}
				obj.put("rows", list);
				obj.put("total", gridData.size());
				out.print(obj);
			}
		}catch(Exception e){
			logger.debug("공통코드 ajax 부르기 Error");
    	}
		return null;

	}
	
	
	
	
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/adms/common/code/update_order.do" ,method = RequestMethod.POST)
	@ResponseBody
	public String  update_order(
			@RequestBody String filterJSON,
			CommonCodeVO searchVO,
			ModelMap model,
			HttpServletResponse res
			) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();
		JSONObject resMap = new JSONObject();
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드
		searchVO.setCret_id(loginVO.getId());				//내아이디
		searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
		try{

			org.json.simple.parser.JSONParser jsonParser = new JSONParser();
			ObjectMapper mapper = new ObjectMapper();
            //org.json.simple.JSONObject jsonObject = (org.json.simple.JSONObject) jsonParser.parse(filterJSON);

			/*
            org.json.simple.JSONObject mainObj= (org.json.simple.JSONObject) jsonObject.get("mainData");
            QC_PROCS_WD_VO wv = (QC_PROCS_WD_VO)mapper.readValue( mainObj.toJSONString(),new TypeReference<QC_PROCS_WD_VO>(){ });

            org.json.simple.JSONArray colObj= (org.json.simple.JSONArray) jsonObject.get("colData");
            List<String> cols =  (List<String>)mapper.readValue( colObj.toJSONString(),new TypeReference<List<String>>(){ });
			 */
            //org.json.simple.JSONArray chkObj= (org.json.simple.JSONArray) jsonObject.get("listD");
            org.json.simple.JSONArray jarr= (org.json.simple.JSONArray) jsonParser.parse(filterJSON);
            List<CommonCodeVO> updateArr =(List<CommonCodeVO>)mapper.readValue( jarr.toJSONString(),new TypeReference<List<CommonCodeVO>>(){ });

            
            commonCode2Service.updateOrder(updateArr,searchVO);
            //gnb01lnb02service.updateOrder(updateArr,searchVO); 
            
            
            resMap.put("res", "ok");
			resMap.put("msg", "Save complete."); // ENG141 // 저장하였습니다.
            
		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "An error occurred during execution."); // ENG142 // 실행 도중 오류가 발생하였습니다.
			if(!StringUtils.isEmpty(e.getMessage())) resMap.put("msg",e.getMessage());
    	}

		out.print(resMap);
		return null;
	}
	
	
	
	
	@RequestMapping(value="/adms/common/code/createAndUpdate.do",method = RequestMethod.POST)
	@ResponseBody
	public String  createAndUpdate(CommonCodeVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		JSONObject resMap = new JSONObject();
		searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드
		LoginVO loginVO = loginService.getLoginInfo();
		if(loginVO==null) loginVO = new LoginVO();
		if(StringUtils.isEmpty(loginVO.getId())) loginVO.setId("NOTLOGIN");
		try{
			int cdidx = 0;
			if(searchVO.getCode_idx()==0){//INSERT
				searchVO.setCret_id(loginVO.getId());
				searchVO.setCret_ip(InetAddress.getLocalHost().getHostAddress());
				cdidx = commonCode2Service.create(searchVO);
			}else{//UPDATE
				cdidx = searchVO.getCode_idx();
				searchVO.setModi_id(loginVO.getId());
				searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());
				commonCode2Service.update(searchVO);
			}

			//commonCodeService.createAndUpdate(searchVO);
			resMap.put("res", "ok");
			resMap.put("cdidx", cdidx);
			resMap.put("msg", "저장하였습니다.");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
			if(!StringUtils.isEmpty(e.getMessage())) resMap.put("msg",e.getMessage());
    	}

		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(resMap);
		return null;

	}


	@RequestMapping(value="/adms/common/code/deleteNode.do",method = RequestMethod.POST)
	@ResponseBody
	public String  deleteNode(CommonCodeVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		JSONObject resMap = new JSONObject();
		searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드
		LoginVO loginVO = loginService.getLoginInfo();
		if(loginVO==null) loginVO = new LoginVO();
		if(StringUtils.isEmpty(loginVO.getId())) loginVO.setId("NOTLOGIN");
		try{
			if(searchVO.getCode_idx()==0 || StringUtils.isEmpty(searchVO.getCode_cate())){
				//ERROR
				resMap.put("res", "error");
				resMap.put("msg", "알수없는 오류가 발생하여 삭제가 실패 하였습니다.");
			}else{//DELETE
				commonCode2Service.deleteNode(searchVO);
				resMap.put("res", "ok");
				resMap.put("msg", "삭제하였습니다.");
			}
		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
			if(!StringUtils.isEmpty(e.getMessage())) resMap.put("msg",e.getMessage());
    	}

		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(resMap);
		return null;

	}


	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/adms/common/code/list_ajax_changeOrder.do",method = RequestMethod.POST)
	@ResponseBody
    public String create_getCodeCnt(
    		@RequestBody String filterJSON,
    		HttpServletResponse response,
			ModelMap model ) throws Exception {

		LoginVO loginVO = loginService.getLoginInfo();

		JSONObject resMap = new JSONObject();

		try{
			ObjectMapper mapper = new ObjectMapper();
			List<CommonCodeVO> _list = (List<CommonCodeVO>)mapper.readValue(filterJSON,new TypeReference<List<CommonCodeVO>>(){ });

			commonCodeService.orderUpdate(_list,loginVO);

			resMap.put("res", "ok");
			resMap.put("msg", "순서를 변경하였습니다.");
		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
    	}

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print(resMap);

		return null;
	}


	   /******************
	   *
	   *  순번 변경(현재 미사용)
	   *
	   *******************/
/*
	@RequestMapping(value="/adms/common/code/list_ajax_changeOrder.do",method = RequestMethod.POST)
	@ResponseBody
	public String  changeOrder(CommonCodeVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		JSONObject resMap = new JSONObject();
		searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드
		LoginVO loginVO = loginService.getLoginInfo();
		if(loginVO==null) loginVO = new LoginVO();
		if(StringUtils.isNullOrEmpty(loginVO.getId())) loginVO.setId("NOTLOGIN");
		try{

			searchVO.setModi_id(loginVO.getId());
			searchVO.setModi_ip(InetAddress.getLocalHost().getHostAddress());

			commonCodeService.changeOrderOther(searchVO); // 바꾸려는 order 보다 큰 데이터
			commonCodeService.changeOrderOwn(searchVO); // 바꾸려는 order

			resMap.put("res", "ok");
			resMap.put("msg", "저장하였습니다.");

		}catch(Exception e){
			System.out.println(e.toString());
			resMap.put("res", "error");
			resMap.put("msg", "실행 도중 오류가 발생하였습니다.");
			if(!StringUtils.isNullOrEmpty(e.getMessage())) resMap.put("msg",e.getMessage());
    	}

		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(resMap);
		return null;

	}
*/



	   /******************
	   *
	   *      샘플 트리
	   *
	   *******************/
	/*
		@RequestMapping(value = "/adms/common/code/list_sample.do", method = RequestMethod.GET)
		public String easyuiTree(@ModelAttribute("searchVO") CommonCodeVO searchVO, Model model) throws Exception {
			searchVO.setMaxdepth(3);


			model.addAttribute("LEFT_MENU_GROUP", "common_code_sample1");
			return "tiles:adms/home/esuitree";
		}
		*/

		@RequestMapping(value = "/adms/common/code/list_sample.do", method = RequestMethod.GET)
		public String easyuiTree(@ModelAttribute("searchVO") CommonCodeVO searchVO, Model model) throws Exception {
			searchVO.setMaxdepth(3);


			model.addAttribute("LEFT_MENU_GROUP", "common_code_sample1");
			return "tiles:adms/home/esuitree";
		}

}//end main class
