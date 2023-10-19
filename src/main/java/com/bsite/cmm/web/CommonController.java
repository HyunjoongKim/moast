package com.bsite.cmm.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adms.common.code.service.CommonCode2Service;
import com.adms.common.code.service.CommonCodeService;
import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class CommonController {
	
	@Resource(name = "LoginService")
    private LoginService loginService;

	@Resource(name = "CommonCodeService")
    private CommonCodeService commonCodeService;

	@Resource(name = "CommonCode2Service")
    private CommonCode2Service commonCode2Service;
	
	 /**
	 * @Class Name : CommonController.java
	 * @Description : 공통으로 사용해야할 기능의 컨트롤러
	 * <pre>
	 * << 개정이력(Modification Information) >>
	 *   
	 *   수정일                      수정자               수정내용
	 *  -------      --------    ---------------------------
	 *   2017.07.17.   박종화              최초 생성
	 * 
	 * </pre>
	 */
	
//========================= site 1 start ===================================================	
	//트리 콤보용  리스트 가져오기 (공통코드 table 내)
	@RequestMapping(value="/cmm/code/list_ajax_combo.do")
	@ResponseBody
	public String  list_ajax_combo(CommonCodeVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		JSONObject obj = new JSONObject();
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		try{

			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드
			
			
			
			 /** 불릴 파라미터 get 방식 허용 **
			 * @parameger
			 *  code_cate
			 *  code_depth
			 **************************/
			
			//1. 최종 불러야할 depth -1번째의 리스트부르기
			//2. 최종 뎁스의 리스트 부르기
			//3. 부모별 자식 맵 만들기
			//4. 맵 을 돌려서 json object 만들기		
			int codeDepth = searchVO.getCode_depth();
			List<CommonCodeVO> getChildList = commonCode2Service.getComboList(searchVO);
			
			searchVO.setCode_depth(codeDepth-1);
			List<CommonCodeVO> getparentList = commonCode2Service.getComboList(searchVO);
			
			
			Map<String,List<CommonCodeVO>> cMap = new LinkedHashMap<String,List<CommonCodeVO>>();			
			for(CommonCodeVO v :getparentList){//초기화
				cMap.put(String.valueOf(v.getCode_idx()), new ArrayList<CommonCodeVO>());
			}
			
			for(CommonCodeVO v :getChildList){//set
				cMap.get(v.getPtrn_code()).add(v);
			}
			
			//================= json 만들기 ========================
			JSONArray pJsonArr = new JSONArray();
			for(CommonCodeVO v :getparentList){ //make jason
					//json parent
				JSONObject pJsonObj = new JSONObject();
				pJsonObj.put("id", v.getCode_idx());
				pJsonObj.put("code", v.getMain_code());
				pJsonObj.put("text",v.getCode_name());
				pJsonObj.put("selectable","false");
				
				JSONArray cJsonArr = new JSONArray();
				for(CommonCodeVO cv : cMap.get(String.valueOf(v.getCode_idx()))){
					//json childs
					JSONObject cJsonObj = new JSONObject();
					cJsonObj.put("id", cv.getCode_idx());
					cJsonObj.put("code", cv.getMain_code());
					cJsonObj.put("text",cv.getCode_name());
					cJsonObj.put("selectable","true");
					cJsonArr.add(cJsonObj);
				}			
				pJsonObj.put("children", cJsonArr);
				pJsonArr.add(pJsonObj);
			}
			//================= json 만들기 ========================
			out.print(pJsonArr);
			
		}catch(Exception e){
			System.out.println("ajax call Error 1"+e.toString());
    	}
		return null;

	}
	
	
	//공통 코드류 특정  리스트 가져오기 (공통코드 table 내)
	@RequestMapping(value="/cmm/code/list_ajax_code.do")
	@ResponseBody
	public String  list_ajax_code(CommonCodeVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		try{
			System.out.println(searchVO.getCode_cate() +" :: " +searchVO.getPtrn_code()); 
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드			
			List<CommonCodeVO> cList = loginService.getDefaultCodeList(searchVO.getCode_cate(),searchVO.getPtrn_code()); //1차 분류군
			//================= json 만들기 ========================
			JSONArray pJsonArr = JSONArray.fromObject(cList);			
			out.print(pJsonArr);
			//================= json 만들기 ========================
		}catch(Exception e){
			System.out.println("ajax call Error 2"+e.toString());
    	}
		return null;

	}
	
	
	//공통 코드류 일반  리스트 가져오기 (공통코드 table 내)
	@RequestMapping(value="/cmm/code/list_ajax_cmmcode.do")
	@ResponseBody
	public String  list_ajax_cmmcode(CommonCodeVO searchVO,
							ModelMap model,
							HttpServletResponse res) throws Exception {
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		try{
			//System.out.println(searchVO.getCode_cate() +" :: " +searchVO.getPtrn_code()); 
			searchVO.setSite_code(loginService.getSiteCode());  //로그인 사이트 코드			
			List<CommonCodeVO> cList = loginService.getDefaultCodeList(searchVO.getCode_cate(),searchVO.getPtrn_code()); //1차 분류군
			//================= json 만들기 ========================
			JSONArray pJsonArr = JSONArray.fromObject(cList);			
			out.print(pJsonArr);
			//================= json 만들기 ========================
		}catch(Exception e){
			System.out.println("ajax call Error 3"+e.toString());
    	}
		return null;

	}
	
	


	
//========================= site 1 end ===================================================
		
	
	
	
}
