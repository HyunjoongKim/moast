package egovframework.com.cmm.service;

import org.apache.commons.lang.builder.ToStringBuilder;

public class FileVO {
	public String returnUrl = "";  //돌아갈 주소
	public String base64Img ="";
	
	public String site_code = "";
    /**
     * 첨부파일 아이디
     */
    public String atchFileId = "";
    /**
     * 생성일자
     */
    public String creatDt = "";
    /**
     * 파일내용
     */
    public String fileCn = "";
    /**
     * 파일확장자
     */
    public String fileExtsn = "";
    /**
     * 파일크기
     */
    public String fileMg = "";
    /**
     * 파일연번
     */
    public String fileSn = "";
    /**
     * 파일저장경로
     */
    public String fileStreCours = "";
    /**
     * 원파일명
     */
    public String orignlFileNm = "";
    /**
     * 저장파일명
     */
    public String streFileNm = "";
    
    /**
     * 컨텐츠 관리용 파일타입 img , a 링크
     */
    public String file_content_type = "";
    
    /**
     * file Id
     */
    public String entryKey = "";
    
    /**
     * 첨부파일의 해당 메뉴 
     */
    public String menu_type = "";
    
    public int menu_idx = 0;
    
    /**
     * 촬영방향
     */
    public int orientation = 1;
    
    
    

    public String getFile_content_type() {
		return file_content_type;
	}

	public void setFile_content_type(String file_content_type) {
		this.file_content_type = file_content_type;
	}

	public String getReturnUrl() {
		return returnUrl;
	}

	public void setReturnUrl(String returnUrl) {
		this.returnUrl = returnUrl;
	}

	public String getBase64Img() {
		return base64Img;
	}

	public void setBase64Img(String base64Img) {
		this.base64Img = base64Img;
	}

	

	public String getSite_code() {
		return site_code;
	}

	public void setSite_code(String site_code) {
		this.site_code = site_code;
	}

	/**
     * atchFileId attribute를 리턴한다.
     * 
     * @return the atchFileId
     */
    public String getAtchFileId() {
	return atchFileId;
    }

    /**
     * atchFileId attribute 값을 설정한다.
     * 
     * @param atchFileId
     *            the atchFileId to set
     */
    public void setAtchFileId(String atchFileId) {
	this.atchFileId = atchFileId;
    }

    /**
     * creatDt attribute를 리턴한다.
     * 
     * @return the creatDt
     */
    public String getCreatDt() {
	return creatDt;
    }

    /**
     * creatDt attribute 값을 설정한다.
     * 
     * @param creatDt
     *            the creatDt to set
     */
    public void setCreatDt(String creatDt) {
	this.creatDt = creatDt;
    }

    /**
     * fileCn attribute를 리턴한다.
     * 
     * @return the fileCn
     */
    public String getFileCn() {
	return fileCn;
    }

    /**
     * fileCn attribute 값을 설정한다.
     * 
     * @param fileCn
     *            the fileCn to set
     */
    public void setFileCn(String fileCn) {
	this.fileCn = fileCn;
    }

    /**
     * fileExtsn attribute를 리턴한다.
     * 
     * @return the fileExtsn
     */
    public String getFileExtsn() {
	return fileExtsn;
    }

    /**
     * fileExtsn attribute 값을 설정한다.
     * 
     * @param fileExtsn
     *            the fileExtsn to set
     */
    public void setFileExtsn(String fileExtsn) {
	this.fileExtsn = fileExtsn;
    }

    /**
     * fileMg attribute를 리턴한다.
     * 
     * @return the fileMg
     */
    public String getFileMg() {
	return fileMg;
    }

    /**
     * fileMg attribute 값을 설정한다.
     * 
     * @param fileMg
     *            the fileMg to set
     */
    public void setFileMg(String fileMg) {
	this.fileMg = fileMg;
    }

    /**
     * fileSn attribute를 리턴한다.
     * 
     * @return the fileSn
     */
    public String getFileSn() {
	return fileSn;
    }

    /**
     * fileSn attribute 값을 설정한다.
     * 
     * @param fileSn
     *            the fileSn to set
     */
    public void setFileSn(String fileSn) {
	this.fileSn = fileSn;
    }

    /**
     * fileStreCours attribute를 리턴한다.
     * 
     * @return the fileStreCours
     */
    public String getFileStreCours() {
	return fileStreCours;
    }

    /**
     * fileStreCours attribute 값을 설정한다.
     * 
     * @param fileStreCours
     *            the fileStreCours to set
     */
    public void setFileStreCours(String fileStreCours) {
	this.fileStreCours = fileStreCours;
    }

    /**
     * orignlFileNm attribute를 리턴한다.
     * 
     * @return the orignlFileNm
     */
    public String getOrignlFileNm() {
	return orignlFileNm;
    }

    /**
     * orignlFileNm attribute 값을 설정한다.
     * 
     * @param orignlFileNm
     *            the orignlFileNm to set
     */
    public void setOrignlFileNm(String orignlFileNm) {
	this.orignlFileNm = orignlFileNm;
    }

    /**
     * streFileNm attribute를 리턴한다.
     * 
     * @return the streFileNm
     */
    public String getStreFileNm() {
	return streFileNm;
    }

    /**
     * streFileNm attribute 값을 설정한다.
     * 
     * @param streFileNm
     *            the streFileNm to set
     */
    public void setStreFileNm(String streFileNm) {
	this.streFileNm = streFileNm;
    }

    /**
     * toString 메소드를 대치한다.
     */
    public String toString() {
	return ToStringBuilder.reflectionToString(this);
    }

	public String getEntryKey() {
		return entryKey;
	}

	public void setEntryKey(String entryKey) {
		this.entryKey = entryKey;
	}

	public String getMenu_type() {
		return menu_type;
	}

	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}

	public int getOrientation() {
		return orientation;
	}

	public void setOrientation(int orientation) {
		this.orientation = orientation;
	}

	public int getMenu_idx() {
		return menu_idx;
	}

	public void setMenu_idx(int menu_idx) {
		this.menu_idx = menu_idx;
	}


}
