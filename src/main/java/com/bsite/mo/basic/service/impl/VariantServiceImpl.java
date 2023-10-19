package com.bsite.mo.basic.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import com.bsite.mo.basic.service.VariantService;
import com.bsite.vo.VariantRecordVO;
import com.bsite.vo.variant.VariantBEDFileVO;
import com.bsite.vo.variant.VariantBlockerResultVO;
import com.bsite.vo.variant.VariantPrimerResultVO;
import com.bsite.vo.variant.VariantProbeResultVO;
import com.bsite.vo.VarPrimerVO;
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

@Service("VariantService")
public class VariantServiceImpl extends EgovAbstractServiceImpl implements VariantService {

	
	private final String PRIMER3_URL 	= EgovProperties.getProperty("Globals.VarPrimer.primer3");
	private final String BLOCKER_URL 	= EgovProperties.getProperty("Globals.VarPrimer.blocker");
	private final String PROBE_URL 		= EgovProperties.getProperty("Globals.VarPrimer.probe");
	
	private final String PYTHON_COMMAND 			= EgovProperties.getProperty("Globals.Python.Command");
	private final String ANNOTATION_TO_FASTA_CODE 	= EgovProperties.getProperty("Globals.Fasta.AnnotationToFastaCode");
	private final String TEMP_INPUT_FILEPATH 		= EgovProperties.getProperty("Globals.Fasta.InputFilePath");
	private final String FASTA_FILEPATH 			= EgovProperties.getProperty("Globals.Fasta.FastaFilePath");
	private final String REF_DICT_FILEPATH 			= EgovProperties.getProperty("Globals.Fasta.RefFilePath");
	
	@Resource
	private VariantDAO dao;

	@Override
	public Map<String, String> sendAnnotationForFasta(VarPrimerVO searchVO) {
		Map<String, String> results = new HashMap<String, String>();

		// Create file and get Full path
		File var_annotation_temp_file = new File(TEMP_INPUT_FILEPATH);
		
		if (searchVO.getInput_file_string()!=null && !searchVO.getInput_file_string().trim().isEmpty()) {
			try (FileOutputStream fos = new FileOutputStream(var_annotation_temp_file)) {
				fos.write(searchVO.getInput_file_string().trim().getBytes());

				// Call Python and get Response
				ProcessBuilder builder = new ProcessBuilder(PYTHON_COMMAND, 
							ANNOTATION_TO_FASTA_CODE, 
							"-i", TEMP_INPUT_FILEPATH, 
							"-r", FASTA_FILEPATH,
							"-p", REF_DICT_FILEPATH);
				Process process = builder.start();

				BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
				BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));

				String text = null;
				while ((text = errorReader.readLine()) != null) {
					System.err.println(text);
				}
				
				
				text = reader.lines().collect(Collectors.joining("\n"));
				

				if (text != null && !text.isEmpty()) {
					String lines[] = text.split(">");
					results.put("FASTA_1", ">" + lines[1].trim());
					results.put("FASTA_2", ">" + lines[2].trim());
					results.put("FASTA_3", ">" + lines[3].trim());
				}

				return results;

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;
	}

	@Override
	public List<VariantPrimerResultVO> sendForBatchPrimer3(VarPrimerVO searchVO) {

		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, String> inputData = objectMapper.convertValue(searchVO.getPrimerVO(),
				new TypeReference<Map<String, String>>() {
				});

		OkHttpClient client = new OkHttpClient().newBuilder()
//				.connectTimeout(10, TimeUnit.SECONDS)
//			    .writeTimeout(60, TimeUnit.SECONDS)
//			    .readTimeout(60, TimeUnit.SECONDS)
			    .build();
		Builder bodyBuilder = new MultipartBody.Builder().setType(MultipartBody.FORM);

		for (String key : inputData.keySet()) {
			bodyBuilder.addFormDataPart(key, inputData.get(key));
		}

		RequestBody body = bodyBuilder.build();
		Request request = new Request.Builder()
				.url(PRIMER3_URL)
				.method("POST", body).build();
		
		Response primerResponse = null, primerRedirectedResponse = null;
		try {
			primerResponse = client.newCall(request).execute();

			Document doc = Jsoup.parse(primerResponse.body().string());
			String resultPageLink = doc.select("a").first().attr("abs:href");
			
			Request redirectedRequest = new Request.Builder().url(resultPageLink).build();
			primerRedirectedResponse = client.newCall(redirectedRequest).execute();
			
			
			List<VariantPrimerResultVO> data = new ArrayList<VariantPrimerResultVO>();
			
			doc = Jsoup.parse(primerRedirectedResponse.body().string());
			
			String lastChar = doc.select("b a").text().trim().split(";")[0].trim();
			
			
			Elements specificPrimersRows = doc.select("table:nth-of-type(2) tbody tr");
			if (specificPrimersRows!=null) {
				for (Element tr : specificPrimersRows) {
					if (tr.select("td:nth-of-type(10)").text().equals(lastChar)) {
						
						VariantPrimerResultVO item = new VariantPrimerResultVO();
						item.setSpecificOrientation(tr.select("td:nth-of-type(2)").text().equals("FORWARD") ? "FORWARD" : "REVERSE");
						item.setSpecificStart(Integer.parseInt(tr.select("td:nth-of-type(3)").text()));
						item.setSpecificLen(Integer.parseInt(tr.select("td:nth-of-type(4)").text()));
						item.setSpecificTm(Double.parseDouble(tr.select("td:nth-of-type(5)").text()));
						item.setSpecificGc(Double.parseDouble(tr.select("td:nth-of-type(6)").text()));
						item.setSpecificAnyCompl(Double.parseDouble(tr.select("td:nth-of-type(7)").text()));
						item.setSpecificThreeCompl(Double.parseDouble(tr.select("td:nth-of-type(8)").text()));
						item.setSpecificScore(Double.parseDouble(tr.select("td:nth-of-type(9)").text()));
						item.setSpecificSnp(tr.select("td:nth-of-type(10)").text());
						item.setSpecificPos(Integer.parseInt(tr.select("td:nth-of-type(11)").text()));
						item.setSpecificPrimerSeq(tr.select("td:nth-of-type(12)").text());
						
						Elements flankingPrimersRows = doc.select("td table:nth-of-type(1) tbody tr");
						for (Element flankingTr : flankingPrimersRows) {
							String orientation = flankingTr.select("td:nth-of-type(2)").text().trim();
							if (!orientation.equals(tr.select("td:nth-of-type(2)").text())) {
								item.setFlankingOrientation(flankingTr.select("td:nth-of-type(2)").text().equals("FORWARD") ? "FORWARD" : "REVERSE");
								item.setFlankingStart(Integer.parseInt(flankingTr.select("td:nth-of-type(3)").text()));
								item.setFlankingLen(Integer.parseInt(flankingTr.select("td:nth-of-type(4)").text()));
								item.setFlankingTm(Double.parseDouble(flankingTr.select("td:nth-of-type(5)").text()));
								item.setFlankingGc(Double.parseDouble(flankingTr.select("td:nth-of-type(6)").text()));
								item.setFlankingAnyCompl(Double.parseDouble(flankingTr.select("td:nth-of-type(7)").text()));
								item.setFlankingThreeCompl(Double.parseDouble(flankingTr.select("td:nth-of-type(8)").text()));
								item.setFlankingPrimerSeq(flankingTr.select("td:nth-of-type(9)").text());
								break;
							}
						}
						
						data.add(item);
						
					}
				}
			}
			
			return data;

		} catch (Exception e1) {
			e1.printStackTrace();
		} finally {
			if (primerRedirectedResponse!=null) {
				primerRedirectedResponse.close();
			}
			if (primerResponse!=null) {
				primerResponse.close();
			}
		}

		return null;
	}

	@Override
	public List<VariantBlockerResultVO> sendForBlocker(VarPrimerVO searchVO) {
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, String> inputData = objectMapper.convertValue(searchVO.getBlockerVO(),
				new TypeReference<Map<String, String>>() {
				});

		OkHttpClient client = new OkHttpClient().newBuilder()
			    .build();
		Builder bodyBuilder = new MultipartBody.Builder().setType(MultipartBody.FORM);

		for (String key : inputData.keySet()) {
			bodyBuilder.addFormDataPart(key, inputData.get(key));
		}

		RequestBody body = bodyBuilder.build();
		Request request = new Request.Builder()
				.url(BLOCKER_URL)
				.method("POST", body).build();
		
		Response blockerResponse = null;
		try {
			
			blockerResponse = client.newCall(request).execute();

			Document doc = Jsoup.parse(blockerResponse.body().string());
			Element pre = doc.select("pre").first();
			String preText = pre.text();
			
			List<VariantBlockerResultVO> data = new ArrayList<VariantBlockerResultVO>();
			
			Matcher matcher = Pattern.compile("(LEFT|RIGHT)\\ PRIMER[^\n]+").matcher(preText);
			
			List<String[]> rows = new ArrayList<String[]>();
			while ( matcher.find() ) {
				rows.add(matcher.group().trim().split("\\s+"));
			}
			
			int j = 1;
			for (int i=0; i<rows.size(); i+=2) {
				String[] left = rows.get(i);
				String[] right = rows.get(i+1);
				VariantBlockerResultVO item = new VariantBlockerResultVO();
				item.setOrientation1(left[0]);
				item.setOligo1(left[1]);
				item.setStart1(Integer.parseInt(left[2]));
				item.setLen1(Integer.parseInt(left[3]));
				item.setTm1(Double.parseDouble(left[4]));
				item.setGc1(Double.parseDouble(left[5]));
				item.setAnyCompl1(Double.parseDouble(left[6]));
				item.setThreeCompl1(Double.parseDouble(left[7]));
				item.setSeq1(left[8]);
				item.setOrientation2(right[0]);
				item.setOligo2(right[1]);
				item.setStart2(Integer.parseInt(right[2]));
				item.setLen2(Integer.parseInt(right[3]));
				item.setTm2(Double.parseDouble(right[4]));
				item.setGc2(Double.parseDouble(right[5]));
				item.setAnyCompl2(Double.parseDouble(right[6]));
				item.setThreeCompl2(Double.parseDouble(right[7]));
				item.setSeq2(right[8]);
				
				data.add(item);
			}
			
			return data;

		} catch (Exception e1) {
			e1.printStackTrace();
		} finally {
			if (blockerResponse!=null) {
				blockerResponse.close();
			}
		}

		return null;
	}

	@Override
	public List<VariantProbeResultVO> sendForProbe(VarPrimerVO searchVO) {
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, String> inputData = objectMapper.convertValue(searchVO.getProbeVO(),
				new TypeReference<Map<String, String>>() {
				});

		OkHttpClient client = new OkHttpClient().newBuilder()
				.connectTimeout(10, TimeUnit.SECONDS)
			    .writeTimeout(120, TimeUnit.SECONDS)
			    .readTimeout(120, TimeUnit.SECONDS)
			    .build();
		Builder bodyBuilder = new MultipartBody.Builder().setType(MultipartBody.FORM);

		for (String key : inputData.keySet()) {
			bodyBuilder.addFormDataPart(key, inputData.get(key));
		}

		RequestBody body = bodyBuilder.build();
		Request request = new Request.Builder()
				.url(PROBE_URL)
				.method("POST", body).build();
		
		Response probeResponse = null;
		try {
			probeResponse = client.newCall(request).execute();

			Document doc = Jsoup.parse(probeResponse.body().string());;
			
			Element pre = doc.select("pre").first();
			String preText = pre.text();
			
			List<VariantProbeResultVO> data = new ArrayList<VariantProbeResultVO>();
			
			Matcher matcher = Pattern.compile("INTERNAL\\ Eprobe\\ \\(Forward\\)[^\n]+").matcher(preText);
			
			List<String[]> rows = new ArrayList<String[]>();
			while ( matcher.find() ) {
				rows.add(matcher.group().trim().split("(?<!INTERNAL|Eprobe)\\s+"));
			}
			
			for (int i=0; i<rows.size(); i++) {
				String[] record = rows.get(i);
				VariantProbeResultVO item = new VariantProbeResultVO();
				item.setOligo(record[0]);
				item.setStart(Integer.parseInt(record[1]));
				item.setLen(Integer.parseInt(record[2]));
				item.setTm(Double.parseDouble(record[3]));
				item.setGc(Double.parseDouble(record[4]));
				item.setAnyCompl(Double.parseDouble(record[5]));
				item.setThreeCompl(Double.parseDouble(record[6]));
				item.setHairpin(Double.parseDouble(record[7]));
				item.setSeq(record[8]);
				
				data.add(item);
			}
			
			return data;

		} catch (Exception e1) {
			e1.printStackTrace();
		} finally {
			if (probeResponse!=null) {
				probeResponse.close();
			}
		}

		return null;
	}
	
	@Override
	public void save(VariantRecordVO vo) {
		dao.save(vo);
	}
	
	@Override
	public List<VariantRecordVO> selectVariantRecordList(VariantRecordVO searchVO) {
		List<VariantRecordVO> result = dao.selectVariantRecordList(searchVO);
		return result;
	}
	
	@Override
	public int countVariantRecordList(VariantRecordVO searchVO) {
		return dao.countVariantRecordList(searchVO);
	}
	
	@Override
	public VariantRecordVO selectVariantRecord(int recordIdx) {
		return dao.selectVariantRecord(recordIdx);
	}

	@Override
	public List<VariantBEDFileVO> generateBedFiles(VariantRecordVO searchVO, int positionPadding) {
		
		
		List<VariantPrimerResultVO> primerList = searchVO.getVariantPrimerResults();
		List<VariantBlockerResultVO> blockerList = searchVO.getVariantBlockerResults();
		List<VariantProbeResultVO> probeList = searchVO.getVariantProbeResults();
		
		List<VariantBEDFileVO> lists = new ArrayList<VariantBEDFileVO>();
		
		String content = String.format("browser	position	%s:%s-%s\r\nbrowser	hide	none\r\n", searchVO.getChr(), searchVO.getStartPosition()-positionPadding, searchVO.getMaxPosition()+positionPadding);
		String primerContentTemplate = "track	name=\"ARMS_primer\"	description=\"ARMS_primer\"	visibility=2	colorByStrand=\"255,0,0	0,0,255\"\r\n%s	%s	%s	ARMS_primer	0	+\r\n%s	%s	%s	Reverse_Primer	0	-\r\n";
		String blockerContentTemplate = "track	name=\"Blocker\"	description=\"Blocker\"	visibility=2	colorByStrand=\"255,0,0	0,0,255\"\r\n%s	%s	%s	blocker	0	+\r\n";
		String probeContentTemplate = "track	name=\"TaqMan_Probe\"	description=\"TaqMan_Probe\"	visibility=2	colorByStrand=\"255,0,0	0,0,255\"\r\n%s	%s	%s	Probe	0	+\r\n";

		
		int i = 0;
		do {
			String contentA = content;
			VariantPrimerResultVO primer = null;
			if (primerList!=null && primerList.size()>0) {
				primer = primerList.get(i);
				contentA += String.format(primerContentTemplate, 
							searchVO.getChr(), 
							searchVO.getStartPosition()+primer.getSpecificStart(), 
							searchVO.getStartPosition()+primer.getSpecificStart()+primer.getSpecificLen(), 
							searchVO.getChr(), 
							searchVO.getStartPosition()+primer.getFlankingStart(), 
							searchVO.getStartPosition()+primer.getFlankingStart()+primer.getFlankingLen());
			}
			i++;
			
			int j = 0;
			do {
				String contentB = contentA;
				VariantBlockerResultVO blocker = null;
				if (blockerList!=null && blockerList.size()>0) {
					blocker = blockerList.get(j);
					contentB += String.format(blockerContentTemplate, 
							searchVO.getChr(), 
							searchVO.getStartPosition()+blocker.getStart1(), 
							searchVO.getStartPosition()+blocker.getStart1()+blocker.getLen1());
				}
				j++;
				
				int k = 0;
				do {
					VariantBEDFileVO bedFile = new VariantBEDFileVO();
					
					String contentC = contentB;
					VariantProbeResultVO probe;
					if (probeList!=null && probeList.size()>0) {
						probe = probeList.get(k);
						contentC += String.format(probeContentTemplate, 
								searchVO.getChr(), 
								searchVO.getStartPosition()+probe.getStart(), 
								searchVO.getStartPosition()+probe.getStart()+probe.getLen());
						bedFile.setVariantProbeResult(probe);
						bedFile.setVariantBlockerResult(blocker);
						bedFile.setVariantPrimerResult(primer);
					}
					k++;
					bedFile.setBedContent(contentC);
					lists.add(bedFile);
					
				} while(probeList!=null && k<probeList.size());
				
				
			} while(blockerList!=null && j<blockerList.size());
			
			
		} while(primerList!=null && i<primerList.size());
		
		
		
//		String primerContent = String.format(primerContentTemplate, "PRIMER_FWD_START", "PRIMER_FWD_START+LEN", "PRIMER_REV_START", "PRIMER_REV_START+LEN");
//		
//		String blockerContent = String.format(blockerContentTemplate, "BLOCKER_START", "BLOCKER_START+LEN");
//		
//		String probeContent = String.format(probeContentTemplate, "PROBE_START", "PROBE_START+LEN");
		
		
		
		return lists;
	}

}
