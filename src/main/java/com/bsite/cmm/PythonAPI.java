package com.bsite.cmm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.bsite.vo.mo_pathwayVO;
import com.bsite.vo.OmicsDataVO.OmicsNewType;

import egovframework.com.cmm.EgovProperties;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public final class PythonAPI {
	private final static Logger logger = LoggerFactory.getLogger("com");

	public static final String FAST_API_URL = EgovProperties.getProperty("Globals.fastapi.url");
	
	public enum PathwayType {
		KEGG("kegg"), MsigDB("msigdb");

		private static final Map<String, PathwayType> BY_LABEL = Stream.of(values()).collect(Collectors.toMap(PathwayType::getLabel, e -> e));

		private final String label;

		PathwayType(String label) {
			this.label = label;
		}

		public String getLabel() {
			return label;
		}

		public static PathwayType valueOfLabel(String label) {
			return BY_LABEL.get(label);
		}
	}

	private PythonAPI() {

	}

	public static String callCorrList(JSONArray json) {
		String totalUrl = FAST_API_URL + "/corr/list/";
		// [{
		// "exp_data":
		// "APC\t3.522504122\t3.425982546\t3.427197195\t3.342767719\t3.175254886\t3.520109626\t3.242486605\t3.441114573\t3.154543385\t3.168437109",
		// "meth_data":
		// "APC\tcg14817997\tAPC$cg14817997\t0.521344628\t0.564555337\t0.755209314\t0.679101365\t0.640103941\t0.241332724\t0.777239869\t0.838466129\t0.539419216\t0.556099066"
		// }, {
		// "exp_data":
		// "APC2\t3.122504121\t3.125982546\t3.427197195\t3.342767719\t3.175254886\t3.520109626\t3.242486605\t3.441114573\t3.154543385\t3.168437109",
		// "meth_data":
		// "APC2\tcg14817991\tAPC2$cg14817991\t0.121344628\t0.164555337\t0.755209314\t0.679101365\t0.640103941\t0.241332724\t0.777239869\t0.838466129\t0.539419216\t0.556099066"
		// }]
		String bd = json.toString();

		// http 통신을 하기위한 객체 선언 실시
		URL url = null;
		HttpURLConnection conn = null;

		// http 통신 요청 후 응답 받은 데이터를 담기 위한 변수
		String responseData = "";
		BufferedReader br = null;
		StringBuffer sb = null;

		// 메소드 호출 결과값을 반환하기 위한 변수
		String returnData = "";

		try {
			// 파라미터로 들어온 url을 사용해 connection 실시
			url = new URL(totalUrl);
			conn = (HttpURLConnection) url.openConnection();

			// http 요청에 필요한 타입 정의 실시
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json; utf-8"); // post body json으로 던지기 위함
			conn.setRequestProperty("Accept", "application/json");
			conn.setDoOutput(true); // OutputStream을 사용해서 post body 데이터 전송
			try (OutputStream os = conn.getOutputStream()) {
				byte request_data[] = bd.getBytes("utf-8");
				os.write(request_data);
				os.close();
			} catch (Exception e) {
				logger.error("", e);
			}

			conn.connect();
			// http 요청 후 응답 받은 데이터를 버퍼에 쌓는다
			br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			sb = new StringBuffer();
			while ((responseData = br.readLine()) != null) {
				sb.append(responseData); // StringBuffer에 응답받은 데이터 순차적으로 저장 실시
			}

			returnData = sb.toString();

		} catch (IOException e) {
			logger.error("", e);
		} finally {
			try {
				if (br != null) {
					br.close();
				}
			} catch (IOException e) {
				logger.error("", e);
			}
		}

		return returnData;
	}

	public static String callCorrOneAPI(String exp_data, String meth_data) {
		String totalUrl = FAST_API_URL + "/corr/data/";
		JSONObject json = new JSONObject();
		// json.put("exp_data",
		// "APC\t3.52250412162961\t3.42598254644873\t3.42719719537129\t3.34276771900567\t3.17525488557937\t3.52010962573454\t3.24248660477962\t3.44111457288777\t3.15454338491981\t3.16843710922");
		// json.put("meth_data",
		// "APC\tcg14817997\tAPC$cg14817997\t0.521344627711071\t0.564555336514026\t0.755209313537803\t0.679101364623757\t0.640103940710636\t0.241332724407876\t0.777239869107594\t0.838466129405095\t0.539419215803932\t0.556099065894371");
		json.put("exp_data", exp_data);
		json.put("meth_data", meth_data);
		String bd = json.toString();
		// System.out.println(bd);
		// bd = "{\"exp_data\":
		// \"APC\\t3.52250412162961\\t3.42598254644873\\t3.42719719537129\\t3.34276771900567\\t3.17525488557937\\t3.52010962573454\\t3.24248660477962\\t3.44111457288777\\t3.15454338491981\\t3.16843710922\",\"meth_data\":
		// \"APC\\tcg14817997\\tAPC$cg14817997\\t0.521344627711071\\t0.564555336514026\\t0.755209313537803\\t0.679101364623757\\t0.640103940710636\\t0.241332724407876\\t0.777239869107594\\t0.838466129405095\\t0.539419215803932\\t0.556099065894371\"}";

		// http 통신을 하기위한 객체 선언 실시
		URL url = null;
		HttpURLConnection conn = null;

		// http 통신 요청 후 응답 받은 데이터를 담기 위한 변수
		String responseData = "";
		BufferedReader br = null;
		StringBuffer sb = null;

		// 메소드 호출 결과값을 반환하기 위한 변수
		String returnData = "";

		try {
			// 파라미터로 들어온 url을 사용해 connection 실시
			url = new URL(totalUrl);
			conn = (HttpURLConnection) url.openConnection();

			// http 요청에 필요한 타입 정의 실시
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json; utf-8"); // post body json으로 던지기 위함
			conn.setRequestProperty("Accept", "application/json");
			conn.setDoOutput(true); // OutputStream을 사용해서 post body 데이터 전송
			try (OutputStream os = conn.getOutputStream()) {
				byte request_data[] = bd.getBytes("utf-8");
				os.write(request_data);
				os.close();
			} catch (Exception e) {
				logger.error("", e);
			}

			conn.connect();
			// http 요청 후 응답 받은 데이터를 버퍼에 쌓는다
			br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			sb = new StringBuffer();
			while ((responseData = br.readLine()) != null) {
				sb.append(responseData); // StringBuffer에 응답받은 데이터 순차적으로 저장 실시
			}

			// 메소드 호출 완료 시 반환하는 변수에 버퍼 데이터 삽입 실시
			returnData = sb.toString();

			// http 요청 응답 코드 확인 실시
			// String responseCode = String.valueOf(conn.getResponseCode());
			// System.out.println("http 응답 코드 : " + responseCode);
			// System.out.println("http 응답 데이터 : " + returnData);

		} catch (IOException e) {
			logger.error("", e);
		} finally {
			// http 요청 및 응답 완료 후 BufferedReader를 닫아줍니다
			try {
				if (br != null) {
					br.close();
				}
			} catch (IOException e) {
				logger.error("", e);
			}
		}

		return returnData;
	}

	public static List<mo_pathwayVO> callPathwayKEGG(String bd) {
		return callPathwayGenes(PathwayType.KEGG, bd);
	}
	
	public static List<mo_pathwayVO> callPathwayMsigDB(String bd) {
		return callPathwayGenes(PathwayType.MsigDB, bd);
	}
	
	@SuppressWarnings("unchecked")
	public static List<mo_pathwayVO> callPathwayGenes(PathwayType type, String bd) {
		List<mo_pathwayVO> resList = new ArrayList<mo_pathwayVO>();
		String totalUrl = FAST_API_URL + "/pathway/" + type.getLabel() + "/?keyword=" + bd;

		// http 통신을 하기위한 객체 선언 실시
		URL url = null;
		HttpURLConnection conn = null;

		// http 통신 요청 후 응답 받은 데이터를 담기 위한 변수
		String responseData = "";
		BufferedReader br = null;
		StringBuffer sb = null;

		// 메소드 호출 결과값을 반환하기 위한 변수
		String returnData = "";

		try {
			// 파라미터로 들어온 url을 사용해 connection 실시
			url = new URL(totalUrl);
			conn = (HttpURLConnection) url.openConnection();

			// http 요청에 필요한 타입 정의 실시
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");

			conn.connect();
			// http 요청 후 응답 받은 데이터를 버퍼에 쌓는다
			br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			sb = new StringBuffer();
			while ((responseData = br.readLine()) != null) {
				sb.append(responseData); // StringBuffer에 응답받은 데이터 순차적으로 저장 실시
			}

			returnData = sb.toString();

			ObjectMapper mapper = new ObjectMapper();
			resList = (List<mo_pathwayVO>) mapper.readValue(returnData, new TypeReference<List<mo_pathwayVO>>() {
			});

		} catch (Exception e) {
			logger.error("", e);
		} finally {
			try {
				if (br != null) {
					br.close();
				}
			} catch (IOException e) {
				logger.error("", e);
			}
		}

		return resList;
	}
	
	
}
