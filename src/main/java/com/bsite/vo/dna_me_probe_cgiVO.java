package com.bsite.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/* Methylation Probe CGI */

@Getter
@Setter
@ToString

public class dna_me_probe_cgiVO implements Serializable {

	private static final long serialVersionUID = 4374031179043114926L;
	private String probe_id;
	private String cgi;

	

}
