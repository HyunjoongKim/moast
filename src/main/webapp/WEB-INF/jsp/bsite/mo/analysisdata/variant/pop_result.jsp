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

<style>
	table tr td {
		font-size: 8pt !important;
	}
</style>

<script type="text/javascript">
	var path = "${path }";
	
	$(function() {
		alertResMsg(gTxt("${resMap.msg}"));
		
		initControls();

	});
	
	function initControls() {
		
	}
	
	$(document).on("click", "#browse-button", function() {
		var primerIdx = $("[name='primer-radio']:checked").val()
		var blockerIdx = $("[name='blocker-radio']:checked").val()
		var probeIdx = $("[name='probe-radio']:checked").val()
		
		var url = new URL("http://genome.ucsc.edu/cgi-bin/hgTracks?org=H.+sapiens&db=hg38&pix=1000&&hgt.oligoMatch=CG&oligoMatch=dense")
		
		var dataUrl = new URL("${path}/mo/analysisdata/variant/bed/read.do", window.location.origin)
		if (primerIdx){
			dataUrl.searchParams.append("primerRecordIdx", primerIdx);
		}
			
		if (blockerIdx){
			dataUrl.searchParams.append("blockerRecordIdx", blockerIdx);
		}
			
		if (probeIdx) {
			dataUrl.searchParams.append("probeRecordIdx", probeIdx);
		}
		
		
		
		if ($("[name='primer-radio']").length>0 && $("[name='primer-radio']:checked").length==0) {
			alert("Please select an ARMS-Primer")
		} else if ($("[name='blocker-radio']").length>0 && $("[name='blocker-radio']:checked").length==0) {
			alert("Please select a Blocker")
		} else if ($("[name='probe-radio']").length>0 && $("[name='probe-radio']:checked").length==0) {
			alert("Please select a TaqMan Probe")
		} else {
			url.searchParams.append("position", "${variantRecord.chr}:${variantRecord.startPosition}-${variantRecord.maxPosition}")
			url.searchParams.append("hgt.customText", dataUrl.href)
			document.getElementsByName('ucsc-browser')[0].src = url;
		}
		

	})
	
	
	
	
	
</script>
<form id="submitForm" action="${path}/mo/basic/popup/degAnnotation.do" method="post">
	<input type="hidden" name="grp1" id="grp1" value="${param.grp1 }"/>
	<input type="hidden" name="grp2" id="grp2" value="${param.grp2 }"/>
	
	<input type="hidden" name="degType" id="degType" value="${param.degType }"/>
	<input type="hidden" name="searchLogFC" id="searchLogFC" value="${param.searchLogFC }"/>
	<input type="hidden" name="searchPValue" id="searchPValue" value="${param.searchPValue }"/>
	<input type="hidden" name="searchAdjPValue" id="searchAdjPValue" value="${param.searchAdjPValue }"/>
</form>
<div class="card">
	<div class="card-header">
		<h3 class="card-title">
			<i class="ion ion-clipboard mr-1"></i>Result
		</h3>
	</div>

	<div class="card-body">
		<c:if test="${variantRecord !=null && ((variantRecord.variantPrimerResults!=null && variantRecord.variantPrimerResults.size()>0) || (variantRecord.variantBlockerResults!=null && variantRecord.variantBlockerResults.size()>0) || (variantRecord.variantProbeResults!=null && variantRecord.variantProbeResults.size()>0))}">
		<div class="row">
			<c:if test="${variantRecord.variantPrimerResults != null && variantRecord.variantPrimerResults.size() > 0}">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-header">
						<h5 class="card-title">ARMS-Primer & Reverse Primer</h5>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-lg-12">
								<div class="table-responsive">
									<table class="table table-sm table-bordered table-striped text-center">
		                                <thead>
											<tr>
												<td style="width:22px"></td>
												<td>Orientation</td>
												<td>Start</td>
												<td>Len</td>
												<td>Tm</td>
												<td>GC%</td>
												<td>Any Compl</td>
												<td>3' Compl</td>
												<td>Score</td>
												<td>SNP</td>
												<td>POS</td>
												<td>Primer Seq</td>
												<td>Orientation</td>
												<td>Start</td>
												<td>Len</td>
												<td>Tm</td>
												<td>GC%</td>
												<td>Any Compl</td>
												<td>3' Compl</td>
												<td>Primer Seq</td>
											</tr>
		                                </thead>
		                                <tbody>
											<c:forEach var="item" items="${variantRecord.variantPrimerResults}">
											<tr>
												<td><input type="radio" name="primer-radio" value="${item.recordIdx}"></td>
												<td>${item.specificOrientation}</td>
												<td>${item.specificStart}</td>
												<td>${item.specificLen}</td>
												<td>${item.specificTm}</td>
												<td>${item.specificGc}</td>
												<td>${item.specificAnyCompl}</td>
												<td>${item.specificThreeCompl}</td>
												<td>${item.specificScore}</td>
												<td>${item.specificSnp}</td>
												<td>${item.specificPos}</td>
												<td>${item.specificPrimerSeq}</td>
												<td>${item.flankingOrientation}</td>
												<td>${item.flankingStart}</td>
												<td>${item.flankingLen}</td>
												<td>${item.flankingTm}</td>
												<td>${item.flankingGc}</td>
												<td>${item.flankingAnyCompl}</td>
												<td>${item.flankingThreeCompl}</td>
												<td>${item.flankingPrimerSeq}</td>
											</tr>
											</c:forEach>
											
		                                </tbody>
		                            </table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			
			<c:if test="${variantRecord.variantBlockerResults != null && variantRecord.variantBlockerResults.size() > 0}">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-header">
						<h5 class="card-title">Blocker</h5>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-lg-12">
								<div class="table-responsive">
									<table class="table table-sm table-bordered table-striped text-center">
		                                <thead>
											<tr>
												<td style="width:22px"></td>
												<td>Orientation</td>
												<td>OLIGO</td>
												<td>Start</td>
												<td>Len</td>
												<td>TM</td>
												<td>GC%</td>
												<td>ANY</td>
												<td>3'</td>
												<td>SEQ</td>
												<td>Orientation</td>
												<td>OLIGO</td>
												<td>Start</td>
												<td>Len</td>
												<td>TM</td>
												<td>GC%</td>
												<td>ANY</td>
												<td>3'</td>
												<td>SEQ</td>
											</tr>
		                                </thead>
		                                <tbody>
											<c:forEach var="item" items="${variantRecord.variantBlockerResults}">
											<tr>
												<td><input type="radio" name="blocker-radio" value="${item.recordIdx}"></td>
												<td>${item.orientation1}</td>
												<td>${item.oligo1}</td>
												<td>${item.start1}</td>
												<td>${item.len1}</td>
												<td>${item.tm1}</td>
												<td>${item.gc1}</td>
												<td>${item.anyCompl1}</td>
												<td>${item.threeCompl1}</td>
												<td>${item.seq1}</td>
												<td>${item.orientation2}</td>
												<td>${item.oligo2}</td>
												<td>${item.start2}</td>
												<td>${item.len2}</td>
												<td>${item.tm2}</td>
												<td>${item.gc2}</td>
												<td>${item.anyCompl2}</td>
												<td>${item.threeCompl2}</td>
												<td>${item.seq2}</td>
											</tr>
											</c:forEach>
											
		                                </tbody>
		                            </table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			
			
			<c:if test="${variantRecord.variantProbeResults != null && variantRecord.variantProbeResults.size() > 0}">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-header">
						<h5 class="card-title">TaqMan Probe</h5>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-lg-12">
								<div class="table-responsive">
									<table class="table table-sm table-bordered table-striped text-center">
		                                <thead>
											<tr>
												<td style="width:22px"></td>
												<td>OLIGO</td>
												<td>Start</td>
												<td>Len</td>
												<td>TM*</td>
												<td>GC%</td>
												<td>ANY</td>
												<td>3'</td>
												<td>Hairpin</td>
												<td>Seq</td>
											</tr>
		                                </thead>
		                                <tbody>
											<c:forEach var="item" items="${variantRecord.variantProbeResults}">
											<tr>
												<td><input type="radio" name="probe-radio" value="${item.recordIdx}"></td>
												<td>${item.oligo}</td>
												<td>${item.start}</td>
												<td>${item.len}</td>
												<td>${item.tm}</td>
												<td>${item.gc}</td>
												<td>${item.anyCompl}</td>
												<td>${item.threeCompl}</td>
												<td>${item.hairpin}</td>
												<td>${item.seq}</td>
											</tr>
											</c:forEach>
											
		                                </tbody>
		                            </table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-sm-5">
							
							</div>
							
							<div class="col-sm-2">
								<div class="form-group">
									<button type="button" class="btn btn-block btn-success" id="browse-button"><i class="fas fa-search"></i></button>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<iframe align="left" class="style16" name="ucsc-browser" frameborder="0" scrolling="auto" scroll="no" width="100%" height="900" style="overflow-x: false" id="ucsc-browser" src=""></iframe>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		</c:if>
		
		<c:if test="${variantRecord !=null || ((variantRecord.variantPrimerResults!=null || variantRecord.variantPrimerResults.size()>0) && (variantRecord.variantBlockerResults!=null || variantRecord.variantBlockerResults.size()>0) && (variantRecord.variantProbeResults!=null || variantRecord.variantProbeResults.size()>0))}">
		<div class="row">
			<div class="col-lg-12">
				<h5>결과 찾을 수 없습니다.</h5>
			</div>
		</div>
		</c:if>
	</div>
		
</div>

<script>




</script>
