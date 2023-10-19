package egovframework.com.cmm.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Metadata;
import com.drew.metadata.MetadataException;
import com.drew.metadata.exif.ExifIFD0Directory;

import egovframework.com.cmm.service.FileVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

/**
 * @Class Name : EgovFileMngDAO.java
 * @Description : 파일정보 관리를 위한 데이터 처리 클래스
 * @Modification Information
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *    2009. 3. 25.     이삼섭    최초생성
 *
 * @author 공통 서비스 개발팀 이삼섭
 * @since 2009. 3. 25.
 * @version
 * @see
 *
 */

/**
 * 
 * MYBATIS
 *
 */
@Repository("FileManageDAO")
public class FileManageDAO extends EgovAbstractMapper {

    //private static final Logger LOG = Logger.getLogger(this.getClass());

    /**
     * 여러 개의 파일에 대한 정보(속성 및 상세)를 등록한다.
     * 
     * @param fileList
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public String insertFileInfs(List fileList) throws Exception {
	FileVO vo = (FileVO)fileList.get(0);
	String atchFileId = vo.getAtchFileId();
	
	insert("FileManageDAOinsertFileMaster", vo);

	Iterator iter = fileList.iterator();
	while (iter.hasNext()) {
	    vo = (FileVO)iter.next();
	    
	    insert("FileManageDAOinsertFileDetail", vo);
	}
	
	return atchFileId;
    }

    /**
     * 하나의 파일에 대한 정보(속성 및 상세)를 등록한다.
     * 
     * @param vo
     * @throws Exception
     */
    public void insertFileInf(FileVO vo) throws Exception {
	insert("FileManageDAOinsertFileMaster", vo);
	insert("FileManageDAOinsertFileDetail", vo);
    }

    /**
     * 여러 개의 파일에 대한 정보(속성 및 상세)를 수정한다.
     * 
     * @param fileList
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public void updateFileInfs(List fileList) throws Exception {
	FileVO vo;
	Iterator iter = fileList.iterator();
	while (iter.hasNext()) {
	    vo = (FileVO)iter.next();
	    
	    insert("FileManageDAOinsertFileDetail", vo);
	}
    }

    /**
     * 여러 개의 파일을 삭제한다.
     * 
     * @param fileList
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public void deleteFileInfs(List fileList) throws Exception {
	Iterator iter = fileList.iterator();
	FileVO vo;
	while (iter.hasNext()) {
	    vo = (FileVO)iter.next();
	    
	    delete("FileManageDAOdeleteFileDetail", vo);
	}
    }

    /**
     * 하나의 파일을 삭제한다.
     * 
     * @param fvo
     * @throws Exception
     */
    public void deleteFileInf(FileVO fvo) throws Exception {
	delete("FileManageDAOdeleteFileDetail", fvo);
    }
    
    public void deleteInstFile(FileVO fvo) throws Exception {
	update("FileManageDAOdeleteInstFile", fvo);
	update("FileManageDAOdeleteInstDetailsFile", fvo);
    }

    /**
     * 파일에 대한 목록을 조회한다.
     * 
     * @param vo
     * @return
     * @throws Exception
     */
    public List<FileVO> selectFileInfs(FileVO vo) throws Exception {
	return selectList("FileManageDAOselectFileList", vo);
    }
    
    public List<FileVO> selectFileInfsByFileName(FileVO vo) throws Exception {
	return selectList("FileManageDAOselectFileInfsByFileName", vo);
    }

    /**
     * 파일 구분자에 대한 최대값을 구한다.
     * 
     * @param fvo
     * @return
     * @throws Exception
     */
    public int getMaxFileSN(FileVO fvo) throws Exception {
	return selectOne("FileManageDAOgetMaxFileSN", fvo);
    }

    /**
     * 파일에 대한 상세정보를 조회한다.
     * 
     * @param fvo
     * @return
     * @throws Exception
     */
    public FileVO selectFileInf(FileVO fvo) throws Exception {
	return selectOne("FileManageDAOselectFileInf", fvo);
    }

    /**
     * 전체 파일을 삭제한다.
     * 
     * @param fvo
     * @throws Exception
     */
    public void deleteAllFileInf(FileVO fvo) throws Exception {
	update("FileManageDAOdeleteCOMTNFILE", fvo);
    }

    /**
     * 파일명 검색에 대한 목록을 조회한다.
     * 
     * @param vo
     * @return
     * @throws Exception
     */
    public List<FileVO> selectFileListByFileNm(FileVO fvo) throws Exception {
	return selectList("FileManageDAOselectFileListByFileNm", fvo);
    }

    /**
     * 파일명 검색에 대한 목록 전체 건수를 조회한다.
     * 
     * @param fvo
     * @return
     * @throws Exception
     */
	public int selectFileListCntByFileNm(FileVO fvo) throws Exception {
	return selectOne("FileManageDAOselectFileListCntByFileNm", fvo);
    }

    /**
     * 이미지 파일에 대한 목록을 조회한다.
     * 
     * @param vo
     * @return
     * @throws Exception
     */
    public List<FileVO> selectImageFileList(FileVO vo) throws Exception {
	return selectList("FileManageDAOselectImageFileList", vo);
    }
    

	public String getAtchNextFileId() {
		return selectOne("FileManageDAOgetAtchNextFileId");
	}

	public int getSubFileTableRow(String atchFileId) {
		return selectOne("FileManageDAOgetSubFileTableRow", atchFileId);
	}

	public void deleteSubTable(FileVO fvo) {
		delete("FileManageDAOdeleteFileDetail",fvo);
	}

	public void deleteMainTable(FileVO fvo) {
		update("FileManageDAOdeleteCOMTNFILE",fvo);
	}

	public int isMainFileTableRow(String ATCH_FILE_ID, String SITE_CODE) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("atch_file_id", ATCH_FILE_ID);
		map.put("site_code", SITE_CODE);
		return selectOne("FileManageDAOisMainFileTableRow", map);
	}

	public void insertAtchFileId(FileVO vo) {
		insert("FileManageDAOinsertFileMaster", vo);
	}

	public void insertFileInfsDetails(List<FileVO> result, String menuType, String menuIdx) {
		Iterator iter = result.iterator();
		while (iter.hasNext()) {
			FileVO vo = new FileVO();
		    vo = (FileVO)iter.next();
		    
		    int fileSn = getFileSn(vo);
		    vo.setFileSn(String.valueOf(fileSn));
		    vo.setMenu_type(menuType);
		    if(StringUtils.isNotEmpty(menuIdx)) {
		    	if(Integer.parseInt(menuIdx) > 0) {
			    	vo.setMenu_idx(Integer.parseInt(menuIdx));
			    }
		    }
		    
		    
		   if("place_photo".equals(menuType) || "res_photo".equals(menuType)) {
		    	int orientation = getOrientation(vo);
		    	vo.setOrientation(orientation);
		    }
		    
		    insert("FileManageDAOinsertFileDetail", vo);
		}
	}
	
	//촬영방향
	public int getOrientation(FileVO fileVO) {
		int orientation = 1;
		File file = new File(fileVO.getFileStreCours() + "/" + fileVO.getStreFileNm());
		
		try {
			Metadata metadata = ImageMetadataReader.readMetadata(file);
			ExifIFD0Directory directory2 = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
			orientation = directory2.getInt(ExifIFD0Directory.TAG_ORIENTATION);
     	} catch (Exception me) {
     		System. out.println("Could not get orientation" );
     	}
		
		return orientation;
	}

	private int getFileSn(FileVO vo) {
		return selectOne("FileManageDAOgetAtchFilesn", vo);
	}

	public List<FileVO> selectFileInfsBySn(FileVO searchVO) {
		return selectList("FileManageDAOselectFileInfsBySn", searchVO);
	}

	
}
