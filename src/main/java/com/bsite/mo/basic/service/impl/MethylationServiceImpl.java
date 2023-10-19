package com.bsite.mo.basic.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.bsite.mo.basic.service.MethylationService;
import com.bsite.vo.HtPrimerResultVO;
import com.bsite.vo.HtPrimerVO;
import com.bsite.vo.MethylationRecordVO;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.EgovProperties;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import okhttp3.MultipartBody;
import okhttp3.MultipartBody.Builder;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;


@Service("MethylationService")
public class MethylationServiceImpl extends EgovAbstractServiceImpl implements MethylationService {
	
	@Resource
	private MethylationDAO dao;
	
	private ObjectMapper objectMapper = new ObjectMapper();
	
	
	private final String HOST = EgovProperties.getProperty("Globals.HTPrimer.host");
	private final String PORT = EgovProperties.getProperty("Globals.HTPrimer.port");
	private final String BASE_URL = "http://" + HOST + ":" + PORT;
	
	public String sendToHtPrimer(HtPrimerVO htPrimerVO) {
		try {
			
			OkHttpClient client = new OkHttpClient().newBuilder().build();
			
			File temp_target_file = new File ("/home/target_file_temp.txt");
			try(FileOutputStream fos = new FileOutputStream(temp_target_file)) {fos.write(htPrimerVO.getTarget_file_string().trim().getBytes());}
			
			File pcr_primer3_param_file = new File ("/home/pcr_primer3_param_file_temp.txt");
			try(FileOutputStream fos = new FileOutputStream(pcr_primer3_param_file)) {fos.write(htPrimerVO.getPcr_primer3_param_file_string().trim().getBytes());}
			
			File restriction_enzyme_file = new File ("/home/restriction_enzyme_file_temp.txt");
			try(FileOutputStream fos = new FileOutputStream(restriction_enzyme_file)) {fos.write(htPrimerVO.getRestriction_enzyme_file_string().trim().getBytes());}
			
			File quality_matrix_file = new File ("/home/quality_matrix_file_temp.txt");
			try(FileOutputStream fos = new FileOutputStream(quality_matrix_file)) {fos.write(htPrimerVO.getQuality_matrix_file_string().trim().getBytes());}
			
			Builder bodyBuilder = new MultipartBody.Builder().setType(MultipartBody.FORM)

					.addFormDataPart("genome", htPrimerVO.getGenome())
					.addFormDataPart("genome_assembly", htPrimerVO.getGenome_assembly())
					.addFormDataPart("dbsnp_build", htPrimerVO.getDbsnp_build())
					.addFormDataPart("primer_type", htPrimerVO.getPrimer_type())
					.addFormDataPart("restriction_enzyme", htPrimerVO.getRestriction_enzyme())
					.addFormDataPart("max_primer_to_return", htPrimerVO.getMax_primer_to_return())
					.addFormDataPart("target_regions", htPrimerVO.getTarget_regions())
					.addFormDataPart("included_regions", htPrimerVO.getIncluded_regions())
					.addFormDataPart("min_product_size", htPrimerVO.getMin_product_size())
					.addFormDataPart("opt_product_size", htPrimerVO.getOpt_product_size())
					.addFormDataPart("max_product_size", htPrimerVO.getMax_product_size())
					.addFormDataPart("min_primer_tm", htPrimerVO.getMin_primer_tm())
					.addFormDataPart("opt_primer_tm", htPrimerVO.getOpt_primer_tm())
					.addFormDataPart("max_primer_tm", htPrimerVO.getMax_primer_tm())
					.addFormDataPart("min_primer_size", htPrimerVO.getMin_primer_size())
					.addFormDataPart("opt_primer_size", htPrimerVO.getOpt_primer_size())
					.addFormDataPart("max_primer_size", htPrimerVO.getMax_primer_size())
					.addFormDataPart("cpg_product", htPrimerVO.getCpg_product())
					.addFormDataPart("cpg_in_primer", htPrimerVO.getCpg_in_primer())
					.addFormDataPart("primer_non_cpg_c", htPrimerVO.getPrimer_non_cpg_c())
					.addFormDataPart("primer_polyt", htPrimerVO.getPrimer_polyt())
					.addFormDataPart("primer_polyx", htPrimerVO.getPrimer_polyx())
					.addFormDataPart("min_hyb_size", htPrimerVO.getMin_hyb_size())
					.addFormDataPart("opt_hyb_size", htPrimerVO.getOpt_hyb_size())
					.addFormDataPart("max_hyb_size", htPrimerVO.getMax_hyb_size())
					.addFormDataPart("min_hyb_tm", htPrimerVO.getMin_hyb_tm())
					.addFormDataPart("opt_hyb_tm", htPrimerVO.getOpt_hyb_tm())
					.addFormDataPart("max_hyb_tm", htPrimerVO.getMax_hyb_tm())
					.addFormDataPart("min_hyb_gc", htPrimerVO.getMin_hyb_gc())
					.addFormDataPart("opt_hyb_gc", htPrimerVO.getOpt_hyb_gc())
					.addFormDataPart("max_hyb_gc", htPrimerVO.getMax_hyb_gc())
					.addFormDataPart("submit", htPrimerVO.getSubmit().toString())
					;
			
			if(htPrimerVO.getTarget_file_string()!= null && !htPrimerVO.getTarget_file_string().trim().isEmpty()) {
				bodyBuilder.addFormDataPart("target_file", "target_file.txt", RequestBody.create(okhttp3.MediaType.parse("application/octet-stream"), temp_target_file));
			}
			if(htPrimerVO.getPcr_primer3_param_file_string()!= null && !htPrimerVO.getPcr_primer3_param_file_string().trim().isEmpty()) {
				bodyBuilder.addFormDataPart("pcr_primer3_param_file", "pcr_primer3_param_file.txt", RequestBody.create(okhttp3.MediaType.parse("application/octet-stream"), pcr_primer3_param_file));
			}
			if(htPrimerVO.getRestriction_enzyme_file_string()!= null && !htPrimerVO.getRestriction_enzyme_file_string().trim().isEmpty()) {
				bodyBuilder.addFormDataPart("restriction_enzyme_file", "restriction_enzyme_file.txt", RequestBody.create(okhttp3.MediaType.parse("application/octet-stream"), restriction_enzyme_file));
			}
			if(htPrimerVO.getQuality_matrix_file_string()!= null && !htPrimerVO.getQuality_matrix_file_string().trim().isEmpty()) {
				bodyBuilder.addFormDataPart("quality_matrix_file", "quality_matrix_file.txt", RequestBody.create(okhttp3.MediaType.parse("application/octet-stream"), quality_matrix_file));
			}
			
			RequestBody body = bodyBuilder.build();
			
			Request request = new Request.Builder().url(BASE_URL + "/cgi-bin/msp-htprimer/design_primer.cgi")
					.method("POST", body).addHeader("Content-Type", "multipart/form-data").build();
			Response primerResponse = client.newCall(request).execute();
	        
			
			Document doc = Jsoup.parse(primerResponse.body().string());
	        
			try {
	        	doc.setBaseUri(BASE_URL);
	        	doc.select("body>table>tbody>tr:nth-child(1)").remove();
				
				
				for (Element e : doc.select("[href],[src]")) {
					String href = e.attr("href");
					if (href.startsWith("/")) {
						e.attr("href", BASE_URL + href);
					}
					
					if (href.contains("127.0.1.1") || href.contains("127.0.0.1")) {
						e.attr("href", href.replace("127.0.1.1", HOST + ":" + PORT).replace("127.0.0.1", HOST + ":" + PORT));
					}
				}
				
	        	List<HtPrimerResultVO> htPrimerResults = new ArrayList<HtPrimerResultVO>();
				for (Element tr : doc.select("#results tr:not(:first-child)")) {
					HtPrimerResultVO htPrimerResultVo = new HtPrimerResultVO();
					htPrimerResultVo.setTsId(tr.select("td:nth-child(1)").text());
					htPrimerResultVo.setFpSeq(tr.select("td:nth-child(2)").text());
					htPrimerResultVo.setRpSeq(tr.select("td:nth-child(3)").text());
					htPrimerResultVo.setAmpId(tr.select("td:nth-child(4)").text());
					htPrimerResultVo.setAmpBed(tr.select("td:nth-child(5)").text());
					htPrimerResultVo.setHybProbe(tr.select("td:nth-child(6)").text());
					htPrimerResultVo.setUcscGenomeBrowserViewLink(tr.select("td:nth-child(7)>a:nth-child(1)").attr("abs:href"));
					htPrimerResultVo.setUcscGenomeBrowserDownloadLink(tr.select("td:nth-child(7)>a:nth-child(2)").attr("abs:href"));
					htPrimerResultVo.setUcscInsilicoPrimerViewLink(tr.select("td:nth-child(8)>a:nth-child(1)").attr("abs:href"));
					htPrimerResultVo.setSite_code(htPrimerVO.getSite_code());
					htPrimerResultVo.setCret_id(htPrimerVO.getCret_id());
					htPrimerResultVo.setCret_ip(htPrimerVO.getCret_ip());
					htPrimerResults.add(htPrimerResultVo);
				}
				
				Map<String, List<HtPrimerResultVO>> htPrimerResultGroups = htPrimerResults.stream().collect(Collectors.groupingBy(HtPrimerResultVO::getTsId));
				for (Map.Entry<String, List<HtPrimerResultVO>> entry : htPrimerResultGroups.entrySet()) {
					MethylationRecordVO methylationRecordvo = new MethylationRecordVO();
					methylationRecordvo.setIlmnID(entry.getKey() );
					methylationRecordvo.setSite_code(htPrimerVO.getSite_code());
					methylationRecordvo.setCret_id(htPrimerVO.getCret_id());
					methylationRecordvo.setCret_ip(htPrimerVO.getCret_ip());
					methylationRecordvo.setHtPrimerResults(entry.getValue());
					methylationRecordvo.setResultHtml(doc.html());
					methylationRecordvo.setStd_idx(htPrimerVO.getStd_idx());
					dao.save(methylationRecordvo);
				}
				
				if (htPrimerResults.size()==0) {
					return "<h5 style='text-align:center;'>선택한 영역에서의 프라이머 예측이 되지 않습니다.</h3>";
				}
	        	return doc.html();
	        } catch(Exception e) {
	        	System.err.println(e.getMessage());
	        } finally {
		        primerResponse.close();
	        }
			return primerResponse.body().string();

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public void save(MethylationRecordVO vo) {
		dao.save(vo);
	}
	
	@Override
	public List<MethylationRecordVO> selectMethylationRecordList(MethylationRecordVO searchVO) {
		List<MethylationRecordVO> result = dao.selectMethylationRecordList(searchVO);
		return result;
	}
	
	@Override
	public int countMethylationRecordList(MethylationRecordVO searchVO) {
		return dao.countMethylationRecordList(searchVO);
	}
	
	@Override
	public MethylationRecordVO selectMethylationRecord(int recordIdx) {
		return dao.selectMethylationRecord(recordIdx);
	}

}
