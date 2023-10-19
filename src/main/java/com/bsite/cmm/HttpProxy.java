package com.bsite.cmm;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.params.ConnManagerParams;
import org.apache.http.conn.params.ConnPerRouteBean;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;





public class HttpProxy {

	public static HttpClient client = getThreadSafeClient();
	public static final int MAX_TOTAL_CONNECTION = 50;
	public static final int MAX_CONNECTIONS_PER_ROUTE = 50;

	
	@SuppressWarnings("deprecation")
	public static DefaultHttpClient getThreadSafeClient()  {

        DefaultHttpClient client = new DefaultHttpClient();
        ClientConnectionManager mgr = client.getConnectionManager();
        HttpParams params = client.getParams();
        
        ConnManagerParams.setMaxTotalConnections(params, MAX_TOTAL_CONNECTION);
        ConnManagerParams.setMaxConnectionsPerRoute( params, new ConnPerRouteBean(MAX_CONNECTIONS_PER_ROUTE) );  


        client = new DefaultHttpClient(new ThreadSafeClientConnManager( params,mgr.getSchemeRegistry()), params);
        return client;
	}
	
	/*
	public static HttpClient getConn(){
		
		if(client==null){
			client = new DefaultHttpClient();
		}		
		return client;
	}
	*/
	//

	public String post(String url, Map params, String encoding){
		HttpPost post = new HttpPost(url);
		ResponseHandler<String> rh = new BasicResponseHandler();
        try{
            
            System.out.println("POST : " + post.getURI());

            if(params!=null){
	            List<NameValuePair> paramList = convertParam(params);
	            post.setEntity(new UrlEncodedFormEntity(paramList, encoding));
            }
            
            return client.execute(post, rh);
        }catch(Exception e){
            e.printStackTrace();
        }finally{
        	post.releaseConnection();
        	rh = null;
        	
        }

        return "error";
    }




	public String postUserAgent(String url, Map params, String encoding,String uagent){
		HttpPost post = new HttpPost(url);
		ResponseHandler<String> rh = new BasicResponseHandler();
        try{
            
            System.out.println("POST ua: " + post.getURI());
            post.setHeader("User-Agent", uagent);
            if(params!=null){
	            List<NameValuePair> paramList = convertParam(params);
	            post.setEntity(new UrlEncodedFormEntity(paramList, encoding));
            }
            return client.execute(post, rh);
        }catch(Exception e){
            e.printStackTrace();
        }finally{
        	post.releaseConnection();
        	rh = null;
        }

        return "error";
    }

    public String post(String url, Map params){
        return post(url, params, "UTF-8");
    }




    /**
     * GET 요청
     * POST 와 동일
     */
    public String get(String url, Map params, String encoding){
    	List<NameValuePair> paramList = convertParam(params);            
    	HttpGet get = new HttpGet(url+"?"+URLEncodedUtils.format(paramList, encoding));
    	ResponseHandler<String> rh = new BasicResponseHandler();
        try{            
            System.out.println("GET : " + get.getURI());
            return client.execute(get, rh);
        }catch(Exception e){
            e.printStackTrace();
        }finally{
        	get.releaseConnection();
        	rh = null;
        }

        return "error";
    }

    public String getUserAgent(String url, Map params, String encoding ,String uagent){

    	List<NameValuePair> paramList = convertParam(params);
        HttpGet get = new HttpGet(url+"?"+URLEncodedUtils.format(paramList, encoding));
        ResponseHandler<String> rh = new BasicResponseHandler();
        try{
            
            get.setHeader("User-Agent", uagent);
            System.out.println("GET : " + get.getURI());
            return client.execute(get, rh);
        }catch(Exception e){
            e.printStackTrace();
        }finally{
        	get.releaseConnection();
        	rh = null;
        }

        return "error";
    }

    public String get(String url, Map params){
        return get(url, params, "UTF-8");
    }

    public String multi(String url , Map params , String encoding) throws ClientProtocolException, IOException{

    	String requestUrl =  url;
		HttpPost postRequest = new HttpPost(requestUrl);
		postRequest.setHeader("User-Agent", "android-mobile");
		//HttpClient client = new DefaultHttpClient();


		if(params != null){
            String urlParams = "?";
            MultipartEntity fileEntity = new MultipartEntity(HttpMultipartMode.STRICT);
            Iterator<String> iterator = params.keySet().iterator();
            System.out.println("Multipart Params ----------------------------------------- start");
            while(iterator.hasNext()){
                String key = iterator.next();
                Object value = params.get(key);
                System.out.println("Query Params - key : "+key+", value : "+value);
                /*
                if(key.equals(ParamRef.Photo)){
                    String filePath = (String) value;
                    if(filePath != null){
                        File file = new File(filePath);
                        FileBody fileBin = new FileBody(file);
                        fileEntity.addPart(key, fileBin);
                    }
                }else{
                    urlParams += key + "=" + value + "&";
                    fileEntity.addPart(key, new StringBody(String.valueOf(value), Charset.forName(StrUtil.ENCODING)));
                }
                */

            }
            requestUrl = requestUrl + urlParams;
            System.out.println("Request Full URL : "+ requestUrl);
            System.out.println("Multipart Params ----------------------------------------- end");
            postRequest.setEntity(fileEntity);
        }

		String returnStr = "";
		try{
		    HttpResponse getResponse = client.execute(postRequest);
		    boolean isXml = true;
		    final int statusCode = getResponse.getStatusLine().getStatusCode();
		    
		    if (statusCode == HttpStatus.SC_OK) {
		    	 HttpEntity getResponseEntity = getResponse.getEntity();
	             if(isXml){
	                 returnStr = EntityUtils.toString(getResponseEntity).trim();
	             }
		    }else{
	
		    }
		    
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			postRequest.releaseConnection();
        }

	    return returnStr;
    }




    @SuppressWarnings("unchecked")
	private List<NameValuePair> convertParam(Map params){
        List<NameValuePair> paramList = new ArrayList<NameValuePair>();
        Iterator<String> keys = params.keySet().iterator();
        while(keys.hasNext()){
            String key = keys.next();
            paramList.add(new BasicNameValuePair(key, params.get(key).toString()));
        }

        return paramList;
    }




}
