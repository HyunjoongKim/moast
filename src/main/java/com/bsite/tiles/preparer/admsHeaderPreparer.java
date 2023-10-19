package com.bsite.tiles.preparer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.tiles.Attribute;
import org.apache.tiles.AttributeContext;
import org.apache.tiles.context.TilesRequestContext;
import org.apache.tiles.preparer.PreparerException;
import org.apache.tiles.preparer.ViewPreparer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.bsite.account.service.LoginService;
import com.bsite.vo.CommonCodeVO;
import com.bsite.vo.LoginVO;

public class admsHeaderPreparer implements ViewPreparer {

	@Resource(name = "LoginService")
	private LoginService loginService;

	@Autowired
	SessionLocaleResolver localeResolver;

	@Override
	public void execute(TilesRequestContext context, AttributeContext attributeContext) throws PreparerException {

		LoginVO loginVO = null;
		try {
			loginVO = loginService.getLoginInfo();
			if ("99".equals(loginVO.getAuthCode())) {
				// 
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		context.getRequestScope().put("loginVO", loginVO);

	}

}
