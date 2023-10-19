package egovframework.com.cmm.service.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
											//SqlSessionDaoSupport
public class MybatisManageDaoSupport extends EgovAbstractMapper {
		 @Autowired
		 public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate)
	     {
	        super.setSqlSessionTemplate(sqlSessionTemplate);
	     }
}
