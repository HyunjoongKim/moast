package com.adms.home.web;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class AdmsHomeController {

	@RequestMapping(value = "/adms/index.do", method = RequestMethod.GET)
	public String home(Locale locale, Model model) throws Exception {
		
		
		return "tiles:adms/home/home";
	}
	@RequestMapping(value = "/adms/homeCreate.do", method = RequestMethod.GET)
	public String homeCreate(Locale locale, Model model) throws Exception {
		
		
		return "tiles:adms/home/homeCreate";
	}
	
	@RequestMapping(value = "/adms/easyuiTree.do", method = RequestMethod.GET)
	public String easyuiTree(Locale locale, Model model) throws Exception {
		
		
		return "tiles:adms/home/esuitree";
	}
	
	@RequestMapping(value = "/adms/easyuiTreeGrid.do", method = RequestMethod.GET)
	public String easyuiTreeGrid(Locale locale, Model model) throws Exception {
		
		
		return "tiles:adms/home/esuitreegrid";
	}
	
	@RequestMapping(value = "/adms/easyuieTree.do", method = RequestMethod.GET)
	public String easyuieTree(Locale locale, Model model) throws Exception {
		
		
		return "tiles:adms/home/easyuieTree";
	}
}
