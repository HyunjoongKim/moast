<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.common.min.css"/>
<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2023.1.314/styles/kendo.default.min.css"/>
<script src="https://kendo.cdn.telerik.com/2023.1.314/js/kendo.all.min.js"></script>

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";

	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();
	});

	function initControls() {
		/*
		$("#geneInput").kendoTextBox({
            placeholder: "Enter gene symbol",
        });
		*/
		$("#geneInput").kendoAutoComplete({
            dataSource: geneData,
            filter: "startswith",
            placeholder: "Select Gene...",
            //separator: ", "
        });
		
		$("#userGeneText").kendoTextArea({
			//label: "Send invitation:",
            //rows: 10,
            //maxLength:200,
            placeholder: "Enter gene list here."
        });
		
		$('#nextButton').click(function() {
			$("#submitForm").attr("action", "${path }/mo/visual/list_pre.do");
			$('#submitForm').prop("target", "_self");
			$('#submitForm').submit();
		});
		
		$('#survButton').click(function() {
			var win = window.open("", "PopupSurvNewAnalysis", "width=1500,height=900");
			$('#submitForm').prop("action", "${path }/mo/third/survival/list.do");
			$('#submitForm').prop("target", "PopupSurvNewAnalysis");
			$('#submitForm').prop("method", "post");
			
			$('#submitForm').submit();
		});
		
		$('#enter1Button').click(function() {
			addGene();
		});
		
		$('#init1Button').click(function() {
			$("#geneInput").val();
			$('#userGeneText').val('');
		});
		
		$('#goButton').click(function() {
			var selectDB = $('#selectDB').val();
			if (selectDB == "GeneOntology") {
				publicDB_GO();	
			} else if (selectDB == "KEGG") {
				publicDB_KEGG();	
			} else if (selectDB == "MsigDB") {
				publicDB_MsigDB();	
			}
		});
		
		$("#geneInput").keypress(function (e) {
            if (e.keyCode === 13) {
            	addGene();
            }
        });
	}
	
	function addGene() {
		var gene = $("#geneInput").val();
		if (gene) {
			console.log(gene);
			$('#userGeneText').val($('#userGeneText').val() + gene + "\n");
			$("#geneInput").val('');
		}
	}
	
	function publicDB_GO() {
		
		$('#goButton').hide();
		$('#goLoding').show();
		$('#panPathway').empty();
		$('#panPathway').hide();
		$('#userGeneText').val('');
		$.ajax({
	        url: "${path}/mo/addgeneset/list_go_ajax.do",
	        type: "POST",
	        data: $('#submitForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
	        	
				if (data.res == "ok") {
					var genes = data.data;
					$('#userGeneText').val(genes.join("\n"));
	        	}
	        },
	        complete: function(data) {
	        	$('#goButton').show();
	    		$('#goLoding').hide();
			}
	    });
	}
	
	var pathwayData;
	
	function selectPathway(no) {
		var genes = pathwayData[no].pathway_genes;
		$('#userGeneText').val(genes.join("\n"));
	}
	
	function publicDB_KEGG() {
		
		$('#goButton').hide();
		$('#goLoding').show();
		$('#panPathway').empty();
		$('#panPathway').show();
		$('#userGeneText').val('');
		$.ajax({
	        url: "${path}/mo/addgeneset/list_kegg_ajax.do",
	        type: "POST",
	        data: $('#submitForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
	        	
				if (data.res == "ok") {
					pathwayData = data.data;
					if (pathwayData) {
						pathwayData.forEach(function (item, index) {
							//console.log(item, index);
							//<button type="button"   onclick="showModal('exp')">저장</button>
							var btn = $('<input type="button" class="btn btn-dark btn-xs mr-2 mt-2" value="' + item.pathway_nm + '" onclick="selectPathway(' + index + ');"/>');
					        $("#panPathway").append(btn);
						});
						
					}
					// selectPathway 추가
	        	}
	        },
	        complete: function(data) {
	        	$('#goButton').show();
	    		$('#goLoding').hide();
			}
	    });
	}
	
function publicDB_MsigDB() {
		
		$('#goButton').hide();
		$('#goLoding').show();
		$('#panPathway').empty();
		$('#panPathway').show();
		$('#userGeneText').val('');
		$.ajax({
	        url: "${path}/mo/addgeneset/list_msigdb_ajax.do",
	        type: "POST",
	        data: $('#submitForm').serialize(),
	        error: function() {alert('An error occurred during data reception.');},
	        success: function(data) {
	        	//console.log(data);
	        	
				if (data.res == "ok") {
					pathwayData = data.data;
					if (pathwayData) {
						pathwayData.forEach(function (item, index) {
							//console.log(item, index);
							//<button type="button"   onclick="showModal('exp')">저장</button>
							var btn = $('<input type="button" class="btn btn-secondary btn-xs mr-2 mt-2" value="' + item.pathway_nm + '" onclick="selectPathway(' + index + ');"/>');
					        $("#panPathway").append(btn);
						});
						
					}
					// selectPathway 추가
	        	}
	        },
	        complete: function(data) {
	        	$('#goButton').show();
	    		$('#goLoding').hide();
			}
	    });
	}
	
	var geneData = ${jsonArray};
	
</script>




<form:form commandName="searchVO" method="post" name="submitForm" id="submitForm" action="${path }/mo/visual/list.do">
	<input type="hidden" name="grp1" id="grp1" value="${searchVO.grp1 }" />
	<input type="hidden" name="grp2" id="grp2" value="${searchVO.grp2 }" />
	<%-- <input type="hidden" name="expType" id="expType" value="${param.expType }" /> --%>
	<input type="hidden" name="degType" id="degType" value="${searchVO.degType }" />
	<input type="hidden" name="searchLogFC" id="searchLogFC" value="${searchVO.searchLogFC }" />
	<input type="hidden" name="searchPValueType" id="searchPValueType" value="${searchVO.searchPValueType }" />
	<input type="hidden" name="searchPValue" id="searchPValue" value="${searchVO.searchPValue }" />
	<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${searchVO.searchAdjPValue }" />
	<%-- <input type="hidden" name="methType" id="methType" value="${param.methType }" /> --%>
	<input type="hidden" name="dmpType" id="dmpType" value="${searchVO.dmpType }" />
	<input type="hidden" name="searchDmpLogFC" id="searchDmpLogFC" value="${searchVO.searchDmpLogFC }" />
	<input type="hidden" name="searchDmpPValue" id="searchDmpPValue" value="${searchVO.searchDmpPValue }" />
	<input type="hidden" name="searchDmpPValueType" id="searchDmpPValueType" value="${searchVO.searchDmpPValueType }" />
	<input type="hidden" name="searchDmpAdjPValue" id="searchDmpAdjPValue" value="${searchVO.searchDmpAdjPValue }" />
	<input type="hidden" name="geneType" id="geneType" value="DEG_Genes" />
	<input type="hidden" name="ud_idx" id="ud_idx" value="${searchVO.ud_idx }"/>
	<input type="hidden" name="ws_idx" id="ws_idx" value="${searchVO.ws_idx }"/>
	<input type="hidden" name="wp_idx" id="wp_idx" value="${searchVO.wp_idx }"/>
	<input type="hidden" name="ps_idx" id="ps_idx" value="${searchVO.ps_idx }" />
	<input type="hidden" name="std_idx" id="std_idx" value="${searchVO.std_idx }" />
	<input type="hidden" name="geneSetType" id="geneSetType" value="${searchVO.geneSetType }"/>
	<input type="hidden" name="std_type" id="std_type" value="G"/>
	<input type="hidden" name="std_title" id="std_title" value="noname gene set"/>
	<input type="hidden" name="std_status" id="std_status" value="W"/>
	<input type="hidden" name="cg_idx" id="cg_idx" value="${searchVO.cg_idx }"/>
	<input hidden="hidden" />
	

	<!-- title -->
	<div class="card-header ui-sortable-handle pl-1 pr-1 pt-0">
		<div class="row">
			<div class="col-lg-6">
				<h3 class="card-title h3icn">Data selection</h3>
			</div>
			<div class="col-lg-6 text-right mt-2 location"><i class="fa fa-home"></i><i class="fa fa-chevron-right ml-2 mr-2"></i>Analysis<i class="fa fa-chevron-right ml-2 mr-2"></i>Data selection </div>
		</div>
	</div>
	<!-- //title -->
	
	<!-- 컨텐츠 영역 -->
	<div class="row">
		<section class="col-lg-12 ui-sortable">
			<div class="mt-3">
				<!-- contents start -->
				<div class="card">
					<div class="card-header">
						<h3 class="card-title">
							<i class="ion ion-clipboard mr-1"></i>User Gene-set of interested
						</h3>
					</div>

					<div class="card-body">
						<div>
							<ul class="nav nav-tabs" id="geneSetTab" role="tablist">
								<li class="nav-item" role="presentation">
									<a class="nav-link active" id="geneSetTab1" data-toggle="tab" href="#geneSetPanel1" role="tab">Custom</a>
								</li>
								<li class="nav-item" role="presentation">
									<a class="nav-link " id="geneSetTab2" data-toggle="tab" href="#geneSetPanel2" role="tab">Public DB</a>
								</li>
							</ul>
							<div class="tab-content" id="myTabContent">
								<div class="tab-pane fade show active" id="geneSetPanel1" role="tabpanel">
									<div class="row mt-2">
										<div class="col-lg-3 col-md-6">
											<input id="geneInput"/>
										</div>
										<div class="col-lg-9 col-md-6">
											<button type="button" id="enter1Button" class="btn btn-primary ">input</button>
										</div>
									</div>
								</div>
								<div class="tab-pane fade" id="geneSetPanel2" role="tabpanel">
									<div class="row mt-2">
										<div class="col-lg-2 col-md-2">
											<select id="selectDB" class="form-control">
												<option value="GeneOntology">Gene Ontology</option>
												<option value="KEGG">KEGG</option>
												<option value="MsigDB">MsigDB</option>
											</select>
										</div>
										<div class="col-lg-3 col-md-3">
											<input id="publicInput" name="PublicInput" class="form-control"/>
										</div>
										<div class="col-lg-7 col-md-7">
											<button type="button" id="goButton" class="btn btn-primary">input</button>
											<button id="goLoding" class="btn btn-primary initHide" type="button" disabled="">
												<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...
											</button>
										</div>
									</div>
									<div class="row mt-2">
										<div id="panPathway" class="col-12">
										</div>
									</div>
									<!-- 
									<textarea id="publicDbTxt" name="publicDbTxt" style="width: 100%; height:150px;" required data-required-msg="Please enter a text." data-max-msg="Enter value between 1 and 200" ></textarea>
									<div class="mt_20 mb_20">
										<button type="button" id="msigdbButton" class="btn btn-primary mr_20">MSigDB</button>
										<button type="button" id="goButton" class="btn btn-primary mr_20">Gene_Ontology</button>
										<button type="button" id="keggButton" class="btn btn-primary mr_20">KEGG</button>
										<div class="float-right">
											<button type="button" id="init2Button" class="btn btn-secondary mr_20">초기화</button>
											<button type="button" id="enter2Button" class="btn btn-success">입력</button>
										</div>
									</div>
									 -->
								</div>
							</div>
	                    
						</div>
					</div>
				</div>
				<div class="card mt-3">
					<div class="card-header">
						<h3 class="card-title">
							<i class="ion ion-clipboard mr-1"></i>Geneset List
						</h3>
					</div>

					<div class="card-body">
						<div>
							<textarea id="userGeneText" name="userGeneText" style="width: 100%; height:250px;">APC
TP53
TAOK1
MUC5AC
INTS5
PRAMEF19
SYNE1
PAPLN
PTPRZ1
LMOD1
ZNF257
ABCA13
TTN
FLG
KRAS
ANKHD1-EIF4EBP3
CENPC
ATM
MUC3A
NRG3
PER3
JMJD1C
TCF7L2
FCGRT
MAD1L1
KCNG1
FLG2
TFR2
LATS2
</textarea>
						</div>
						<div class="mt-2">
							<div class="float-right">
								<button type="button" id="init1Button" class="btn btn-secondary mr-2">Reset</button>
								<button type="button" id="survButton" class="btn btn-primary mr-2">Survival analysis</button>
								<button type="button" id="nextButton" class="btn btn-success">Next ></button>
							</div>
						</div>
					</div>
				
				</div>
			</div>
		</section>
	</div>
			
</form:form>