package com.bsite.cmm.sso;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.DatatypeConverter;

import com.bsite.vo.LoginVO;

import java.security.Key;
import java.util.Date;

public class JwtUtil {
	public static String generateToken(String signingKey, LoginVO loginvo) {
        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);
        //Json web token 방식을 사용하여 로그인 정보가 확실히 맞으면
        //사용자 주요 정보를 웹토큰으로 생성하는 부분.
        
        JwtBuilder builder = Jwts.builder()
                .setSubject(loginvo.getId())
                .setIssuedAt(now)
                .setExpiration(new Date(System.currentTimeMillis() + 1000*60*60*10))
                .claim("name", loginvo.getName())
                .claim("authCode", loginvo.getAuthCode())
                .claim("memberType", loginvo.getMe_type())
                .claim("id", loginvo.getId())          
                .claim("repoHasRight", loginvo.getRepoHasRight())    
                .setHeaderParam("typ", "JWT")
                .signWith(SignatureAlgorithm.HS512, signingKey.getBytes());

        return builder.compact();
    }

    public static String getSubject(HttpServletRequest httpServletRequest, String jwtTokenCookieName, String signingKey){
    	//Json Web 토큰의 정보를 String 타입으로 반환하는 함수
        String token = CookieUtil.getValue(httpServletRequest, jwtTokenCookieName);
        if(token == null) return null;        
        return Jwts.parser().setSigningKey(signingKey.getBytes()).parseClaimsJws(token).getBody().getSubject();
    }
    
    
    public static Claims getAll(HttpServletRequest httpServletRequest, String jwtTokenCookieName, String signingKey){
    	//Json Web 토큰의 정보를 Claims 타입으로 반환하는 함수
        String token = CookieUtil.getValue(httpServletRequest, jwtTokenCookieName);
        if(token == null) return null;            
		return Jwts.parser().setSigningKey(signingKey.getBytes()).parseClaimsJws(token).getBody();        
    }
}
