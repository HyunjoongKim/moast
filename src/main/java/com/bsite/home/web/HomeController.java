package com.bsite.home.web;

import java.io.IOException;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
//import org.jsoup.Jsoup;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {

	private final static Logger logger = LoggerFactory.getLogger("com");

	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getMapFromJsonObject(String jsonObj) {
		Map<String, Object> map = null;

		try {

			map = new ObjectMapper().readValue(jsonObj, Map.class);

		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return map;
	}

	
	@RequestMapping(value = "/home/index/index.do", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpServletRequest request) throws Exception {

		return "redirect:/mo/analysisdata/list.do";
	}

	public String removeTag(String html) throws Exception {
		return html.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	}

	

}
