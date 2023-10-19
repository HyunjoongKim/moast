package com.bsite.vo;

import java.io.Serializable;

import com.bsite.vo.variant.BlockerVO;
import com.bsite.vo.variant.PrimerVO;
import com.bsite.vo.variant.ProbeVO;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VarPrimerVO extends PageSearchVO implements Serializable {

	private static final long serialVersionUID = 3232038502526627397L;
	
	private String input_file_string;
	
	private String variantID;
	
	private int std_idx;

	@JsonProperty("PrimerVO")
	private PrimerVO primerVO;

	@JsonProperty("BlockerVO")
	private BlockerVO blockerVO;

	@JsonProperty("ProbeVO")
	private ProbeVO probeVO;

}


	