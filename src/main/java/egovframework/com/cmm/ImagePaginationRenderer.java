package egovframework.com.cmm;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;
/**
 * ImagePaginationRenderer.java 클래스
 *
 * @author 서준식
 * @since 2011. 9. 16.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2011. 9. 16.   서준식       이미지 경로에 ContextPath추가
 * </pre>
 *
 *
 * public void initVariables(){
		firstPageLabel    = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/egovframework/com/cmm/mod/icon/icon_prevend.gif\" alt=\"처음\"   border=\"0\"/></a>&#160;";
        previousPageLabel = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/egovframework/com/cmm/mod/icon/icon_prev.gif\"    alt=\"이전\"   border=\"0\"/></a>&#160;";
        currentPageLabel  = "<strong>{0}</strong>&#160;";
        otherPageLabel    = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \">{2}</a>&#160;";
        nextPageLabel     = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/egovframework/com/cmm/mod/icon/icon_next.gif\"    alt=\"다음\"   border=\"0\"/></a>&#160;";
        lastPageLabel     = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/egovframework/com/cmm/mod/icon/icon_nextend.gif\" alt=\"마지막\" border=\"0\"/></a>&#160;";
	}


 */
public class ImagePaginationRenderer extends AbstractPaginationRenderer implements ServletContextAware{

	private ServletContext servletContext;

	public ImagePaginationRenderer() {

	}


	public void initVariables(){
		/*
		firstPageLabel    = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/adms/table/paging_far_left.gif\" alt=\"처음\"   border=\"0\"/></a>";
        previousPageLabel = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/adms/table/paging_left.gif\" alt=\"이전\"   border=\"0\"/></a>";
        currentPageLabel  = "<strong class=\"current\">{0}</strong>&#160;";
        otherPageLabel    = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \">{2}</a>&#160;";
        nextPageLabel     = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/adms/table/paging_right.gif\" alt=\"다음\"   border=\"0\"/></a>";
        lastPageLabel     = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \"><img src=\"" + servletContext.getContextPath() +  "/images/adms/table/paging_far_right.gif\" alt=\"마지막\"   border=\"0\"/></a>";
        */

        String strWebDir = "/img/";
		firstPageLabel = "<li class=\"direction\" style=\"width:35px\"><a href=\"#\" onclick=\"{0}({1}); return false;\"><img src=\""+servletContext.getContextPath() +"/img/paging/btn_first.gif\" alt=\"처음으로\" /></a></li>";
		previousPageLabel = "<li class=\"direction\" style=\"width:52px\"><a href=\"#\" onclick=\"{0}({1}); return false;\"><img src=\""+servletContext.getContextPath() +"/img/paging/btn_prev.gif\" alt=\"이전\" /></a></li>	";
        currentPageLabel = "<li><a href=\"#\" class=\"num on\">{0}</a></li>	 ";
        otherPageLabel = "<li><a href=\"#\" onclick=\"{0}({1}); return false;\" class=\"num\">{2}</a></li>";
        nextPageLabel = "<li class=\"irection\" style=\"width:35px\"><a href=\"#\" onclick=\"{0}({1}); return false;\" ><img src=\""+servletContext.getContextPath() +"/img/paging/btn_next.gif\" alt=\"다음\" /></a></li>";
        lastPageLabel = "<li class=\"direction\" style=\"width:34px\"><a href=\"#\" onclick=\"{0}({1}); return false;\"><img src=\""+servletContext.getContextPath() +"/img/paging/btn_last.gif\" alt=\"마지막\" /></a></li>";
	}



	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
		initVariables();
	}

}
