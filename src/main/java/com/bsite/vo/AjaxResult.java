package com.bsite.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation */

@Getter
@Setter
@ToString

public class AjaxResult implements Serializable {
	private static final long serialVersionUID = 2434558732942628587L;

	private String res = "error";
	private String msg = "실행 도중 오류가 발생하였습니다.";
	private Object data = null;
	private Object data2 = null;

}
