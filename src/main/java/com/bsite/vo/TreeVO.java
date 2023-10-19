package com.bsite.vo;


/*****************************
*  		트리 만들기용 VO
******************************/
public class TreeVO {
	public String id;
	public String text;
	public String children;
	public String selectable = "N";
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getChildren() {
		return children;
	}
	public void setChildren(String children) {
		this.children = children;
	}
	public String getSelectable() {
		return selectable;
	}
	public void setSelectable(String selectable) {
		this.selectable = selectable;
	}
	
	
}
