package egovframework.com.cmm.service.impl;

import javax.annotation.Resource;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

public class EgovComAbstractDAO_backup extends EgovAbstractDAO{
										//EgovAbstractMapper
	@Resource(name="egov.sqlMapClient")
	public void setSuperSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSuperSqlMapClient(sqlMapClient);
    }
}
