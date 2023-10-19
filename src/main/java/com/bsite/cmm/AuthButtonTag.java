package com.bsite.cmm;

import org.apache.commons.lang.StringUtils;

public class AuthButtonTag {
	public static String alink( boolean auth ,String JSP_SELF ,String where , String qureyString ,String type ,String className ){// 등록권한
		String res = "";
		String classN = "";
		if(!StringUtils.isEmpty(className)){
			classN = " class='"+className+"'" ;
		}
		if(auth){
			res += "<a href='"+makeUrl(JSP_SELF,where,qureyString)+"' "+classN+">"+type+"</a>";
		}
		return res;
	}



	public static String submit( boolean auth ,String type , String className ){// 등록권한
		String res = "";
		String classN = "";
		if(!StringUtils.isEmpty(className)){
			classN = " class='"+className+"'" ;
		}
		if(auth){
			res += "<input type='submit' "+classN+"  value='"+type+"'  "+"/>";
		}
		return res;
	}

	public static String alink_esui( boolean auth ,String className ,String iconCls ,String plain, String onclick ,String style ,String alinkName ){
		String res    = "";
		String classN = "";
		String icon   = "";
		String pl     = "";
		String onc    = "";
		String sty    = "";
		String aName  = "";


		if(!StringUtils.isEmpty(className)){
			classN = " class=\""+className+"\" " ;
		}else{
			classN = " class=\"easyui-linkbutton\" " ;
		}

		if(!StringUtils.isEmpty(iconCls)){
			icon = " iconCls=\""+iconCls+"\" " ;
		}else{
			icon = " iconCls=\"icon-ok\" " ;
		}

		if(!StringUtils.isEmpty(plain)){
			pl = " plain=\""+plain+"\" " ;
		}else{
			pl = " plain=\"true\" " ;
		}


		//{index:i,field:\'"+tmp+"\'}
		if(!StringUtils.isEmpty(onclick)){
			onc = " onclick=\""+onclick+"\" " ;
		}

		if(!StringUtils.isEmpty(style)){
			sty = " style=\""+style+"\" " ;
		}

		if(!StringUtils.isEmpty(alinkName)){
			aName = alinkName ;
		}else{
			aName = "OK" ;
		}

		System.out.println("auth : "+auth);

		if(auth){
			res += "<a href=\"javascript:void(0)\" "+classN+icon+pl+onc+sty+">"+aName+"</a>";
		}
		System.out.println("res : "+res);
		return res;
	}







	//////////////////////////////////////////////////////////////////////////////////////////////
	public static String makeUrl(String JSP_SELF ,String where, String qureyString){
		String res = "";
		res += JSP_SELF+where;
		if(!StringUtils.isEmpty(qureyString)){
			res += "?"+qureyString;
		}

		return res;
	}



	public static String floorZero( Double fullNumber ){

		String result = "";
		try{
			String tmpNumber = fullNumber.toString().replace(".","/" );

			String[] tmp = tmpNumber.split("/");

			if(Long.parseLong(tmp[1]) == 0){
				result = tmp[0];
			}else{
				result = fullNumber.toString();
			}
		}catch(Exception e){
			System.out.println("AuthButtonTag floorZero Error : " + e.toString());
		}

		return result;
	}
}
