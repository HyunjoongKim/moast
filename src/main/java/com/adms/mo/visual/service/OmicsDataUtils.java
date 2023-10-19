package com.adms.mo.visual.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import com.bsite.cmm.CommonFunctions;
import com.bsite.vo.DegResultVO;
import com.bsite.vo.DmpResultVO;
import com.bsite.vo.MultiEmRow;
import com.bsite.vo.MultiEmmRow;
import com.bsite.vo.OmicsDataVO;
import com.bsite.vo.OmicsType;
import com.bsite.vo.PcaResultVO;
import com.bsite.vo.SurvExtData;
import com.bsite.vo.SurviveGeneType;
import com.bsite.vo.mo_clinicalD2VO;
import com.bsite.vo.mo_clinicalVO;
import com.bsite.vo.mo_expVO;
import com.bsite.vo.mo_historyVO;
import com.bsite.vo.mo_infiniumVO;
import com.bsite.vo.mo_methVO;
import com.bsite.vo.mo_mutationVO;
import com.bsite.vo.mo_studyVO;
import com.bsite.vo.mo_work_presetVO;
import com.bsite.vo.survival.SurvivalAdditionalRow;
import com.bsite.vo.survival.SurvivalAdditionalRowValue;
import com.mysql.cj.x.protobuf.MysqlxDatatypes.Array;

import egovframework.com.cmm.EgovProperties;
import egovframework.com.cmm.EgovWebUtil;

import com.bsite.vo.OmicsDataVO.ExpDegTools;
import com.bsite.vo.OmicsDataVO.MethDmpTools;
import com.bsite.vo.OmicsDataVO.SelectGeneSetType;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class OmicsDataUtils extends SampleBaseUtils {
	
	private final static Logger logger = LoggerFactory.getLogger("com");
	
	public static final String ROOT_PATH =			EgovProperties.getProperty("Globals.home");
	public static final String USER_DATA_PATH = 	ROOT_PATH+ "upload/user_data/";
	
	public static final String WORKSPACE_TEMP = 	USER_DATA_PATH + "1/workspace/";
	
	public static String getWorkspacePath(Integer ud_idx) {
		return 	USER_DATA_PATH + ud_idx + "/workspace/";
	}
	
	public static final String DEG_PATH = 			ROOT_PATH+ "DEG/";
	public static final String DESEQ2_PATH = 		ROOT_PATH+ "DEG.DESeq2/";
	public static final String DEG_ZSCORE_PATH = 	ROOT_PATH+ "Convert_Zscore/";
	public static final String PCA_PATH = 			ROOT_PATH+ "PCA/";
	public static final String PCA_METH_PATH = 		ROOT_PATH+ "METHYL.PCA/";
	public static final String DMP_PATH = 			ROOT_PATH+ "DMP/";
	public static final String DMP_FINDER_PATH = 	ROOT_PATH+ "DMP/DMP_finder/";
	public static final String SURV_PATH = 			ROOT_PATH+ "Survival/from_geneSet/";
	public static final String SURV_NEW_PATH =		ROOT_PATH+ "Survival/NEW_survival_module/";
	public static final String SURV_NEW_PATH_01_PC = SURV_NEW_PATH + "01.PC_value/add_table/";
	public static final String SURV_NEW_PATH_02_RS = SURV_NEW_PATH + "02.RScore/add_table/";
	public static final String SURV_NEW_PATH_03_SG = SURV_NEW_PATH + "03.Specific_gene/add_table/";
	public static final String SURV_NEW_PATH_04_TD = SURV_NEW_PATH + "04.Two_DATASET/";
	public static final String SURV_NEW_PATH_05_UF = SURV_NEW_PATH + "05.User_SCORE/";
	public static final String MULTI_EM_PATH = 		ROOT_PATH+ "MultiOmics/02.EXP_MUT/";
	public static final String MULTI_EMM_PATH = 	ROOT_PATH+ "MultiOmics/03.EXP_MUT_MET/";
	public final static String SCRNA_PATH = 		ROOT_PATH+ "scRNA/";
	public final static String SCRNA_UPLOAD_PATH = 	USER_DATA_PATH + "0/scrna/";
	
	public final static String THIRD_TOOLS_PATH = 		ROOT_PATH+ "third_party/";
	public final static String THIRD_WORK_PATH = 		USER_DATA_PATH + "0/samtools/";
	public static final String THIRD_EXTRACT_SCRIPT = 		"job_Running_extract_bam.sh";
	public static final String SAMTOOLS_BAM_SAM_SCRIPT = 	"bamToSam.sh";
	public static final String SAMTOOLS_BAM_FASTA_SCRIPT = 	"bamToFasta.sh";
	public static final String SAMTOOLS_BAM_FASTQ_SCRIPT = 	"bamToFastq.sh";
	public static final String SAMTOOLS_SAM_BAM_SCRIPT = 	"samToBam.sh";
	public static final String BEDTOOLS_BED_BAM_SCRIPT = 	"bedToBam.sh";
	public static final String BEDTOOLS_BAM_BED_SCRIPT = 	"bamToBed.sh";
	public static final String VCFTOOLS_VCF_BAM_SCRIPT = 	"vcfToBam.sh";
	public static final String VCFTOOLS_VCF_BED_SCRIPT = 	"vcfToBed.sh";
	
	public static final String DEG_RESULT_FILE = 		"DEGs_Tumor_vs_Normal.txt";
	public static final String DESEQ2_RESULT_FILE = 	"DEGs_Tumor_vs_Normal2.txt";
	public static final String PCA_RESULT_FILE = 		"PCA_matrix_TPM.txt";
	public static final String PCA_METH_RESULT_FILE = 	"PCA_matrix_BETA.txt";
	public static final String DMP_RESULT_FILE = 		"DMP_table.txt";
	public static final String DMP_FINDER_RESULT_FILE = "DMP_table2.txt";
	public static final String SURV_RESULT_DATA_FILE = 	"surv_data.txt";
	public static final String SURV_RESULT_DATZ_FILE = 	"surv_datz.txt";
	public static final String SURV_RESULT_STABLE_FILE = 	"s_table.txt";
	public static final String SURV_RESULT_DATZ_FILE_2G = 	"two_dataset.surv_datz.txt";
	public static final String MULTI_EM_RESULT_CORR = 	"EXP_MUT.corr_table.txt";
	public static final String MULTI_EM_RESULT_VAR = 	"binary.var_data.txt";
	public static final String MULTI_EMM_RESULT_CORR = 	"EXP_VAR_MET.corr_table.txt";
	public static final String MULTI_EMM_RESULT_METH = 	"binary.met_data.txt";
	public static final String MULTI_EMM_RESULT_VAR = 	"binary.var_data.txt";
	
	public static final String SURV_NORMALIZED_FILE = 	"surv_input_TPM_normalized.txt";
	
	public static final String DEG_MERGE_PATH = 		USER_DATA_PATH + "1/Ecnt_all_rmERCC_Dedup_SYMBOLDupSum/";
	public static final String DESEQ2_MERGE_PATH = 		USER_DATA_PATH + "1/Ecnt_all_rmERCC_Dedup_SYMBOLDupSum/";
	public static final String PCA_MERGE_PATH = 		USER_DATA_PATH + "1/TPM_all_rmERCC_Dedup_SYMBOLDupSum/";
	public static final String SURV_DEG_MERGE_PATH = 	USER_DATA_PATH + "1/TPM_all_rmERCC_Dedup_SYMBOLDupSum/";
	public static final String PCA_METH_MERGE_PATH = 	USER_DATA_PATH + "1/EPIC_850K_tsv/";
	public static final String DMP_MERGE_PATH = 		USER_DATA_PATH + "1/EPIC_850K_tsv/";
	public static final String DMP_FINDER_MERGE_PATH = 	USER_DATA_PATH + "1/EPIC_850K_tsv/";
	public static final String DEG_MERGE_PATH2 = 		USER_DATA_PATH + "2/TEST_50sample_read_count/";
	public static final String DESEQ2_MERGE_PATH2 = 		USER_DATA_PATH + "2/TEST_50sample_read_count/";
	public static final String PCA_MERGE_PATH2 = 		USER_DATA_PATH + "2/TEST_50sample_TPM/";
	public static final String SURV_DEG_MERGE_PATH2 = 	USER_DATA_PATH + "2/TEST_50sample_TPM/";
	public static final String PCA_METH_MERGE_PATH2 = 	USER_DATA_PATH + "2/TEST_50sample_beta/";
	public static final String DMP_MERGE_PATH2 = 		USER_DATA_PATH + "2/TEST_50sample_beta/";
	public static final String DMP_FINDER_MERGE_PATH2 = 	USER_DATA_PATH + "2/TEST_50sample_beta/";
	

	
	public static final String DEG_MERGE_FILE_PRE = 	"deg_input.txt";
	public static final String DESEQ2_MERGE_FILE_PRE = 	"deg_input2.txt";
	public static final String DEG_ZSCORE_INPUT_FILE = 	"deg_zscore_input.txt";
	public static final String DEG_ZSCORE_OUTPUT_FILE = "ZSCORE_data.txt";
	public static final String PCA_MERGE_FILE_PRE = 	"pca_input.txt";
	public static final String PCA_METH_MERGE_FILE_PRE = 	"pca_meth_input.txt";
	public static final String DMP_MERGE_FILE_PRE = 	"dmp_input.txt";
	public static final String DMP_FINDER_MERGE_FILE_PRE = 	"dmp_input2.txt";
	public static final String SURV_MERGE_FILE_PRE = 	"surv_input.txt";
	public static final String SURV_MERGE_FILE_PRE2 = 	"surv_input2.txt";
	public static final String SURV_NEW_INPUT_FILE = 	"surv_input_data.txt";
	public static final String SURV_NEW_INPUT_FILE2 = 	"surv_input_data2.txt";
	public static final String SURV_NEW_INPUT_USER = 	"surv_input_user.txt";
	public static final String SURV_NEW_INPUT_USER2 = 	"surv_input_user2.txt";
	public static final String SURV_GENE_FILE_PRE = 	"surv_input_gene.txt";
	public static final String SURV_CLINIC_FILE_PRE =	"surv_input_clinic.txt";
	public static final String MULTI_EM_INPUT_EXP = 	"multi_input_exp.txt";
	public static final String MULTI_EM_INPUT_MUT = 	"multi_input_mut.txt";
	public static final String MULTI_EMM_INPUT_EXP = 	"multi_input_exp2.txt";
	public static final String MULTI_EMM_INPUT_METH = 	"multi_input_meth2.txt";
	public static final String MULTI_EMM_INPUT_MUT = 	"multi_input_mut2.txt";
	
	public static final String DEG_EXCUTE_SCRIPT = 		"job_Running_DEG.sh";
	public static final String DESEQ2_EXCUTE_SCRIPT = 	"job_Running_DEG.sh";
	public static final String DEG_ZSCORE_SCRIPT = 		"job_Running_zscore.sh";
	public static final String DMP_CHAMP_SCRIPT = 		"job_Running_DMP.sh";
	public static final String DMP_FINDER_SCRIPT = 		"job_Running_DMP.sh";
	public static final String PCA_EXCUTE_SCRIPT = 		"job_Running_PCA.sh";
	public static final String PCA_METH_EXCUTE_SCRIPT = "job_Running_PCA.sh";
	public static final String SURV_EXCUTE_1_SCRIPT =	"step01.Normalize_TPM.R";
	public static final String SURV_EXCUTE_2_SCRIPT =	"step02.Make_surv_data_datz.R";
	public static final String SURV_NEW_01_SCRIPT =		"job_Running_Surv_PC_value.update";
	public static final String SURV_NEW_02_SCRIPT =		"job_Running_Surv_RScore";
	public static final String SURV_NEW_03_SCRIPT =		"job_Running_Surv_Specific_gene";
	public static final String SURV_NEW_04_SCRIPT =		"job_Running_Two_dataset";
	public static final String SURV_NEW_05_SCRIPT =		"job_Running_Surv_User_SCORE";
	public static final String MULTI_EM_SCRIPT = 		"job_Running_Corr_EXP_MUT";
	public static final String MULTI_EMM_SCRIPT = 		"job_Running_Corr_EXP_VAR_MET";
	public final static String SCRNA_SCRIPT = 			"job_Running_scRNA";
	
	public static final String SURV_COLORS[] = {"sColor0", "sColor1", "sColor2", "sColor3", "sColor4"};

	private final static String GRID_FIELD_NAME = "C_";
	private final static String GRID_GENE_NAME = "Gene_name";
	private final static String GRID_CHR_NAME = "CHR";
	private final static String GRID_POS_NAME = "POS";
	private final static String GRID_REF_NAME = "REF";
	private final static String GRID_ALT_NAME = "ALT";
	private final static String GRID_VARIANT_RATE_NAME = "VARIANT_RATE";
	private final static String GRID_MUTATION_TYPE_NAME = "Mutation_type";
	
	private final static String MUTATION_GRID_COLUMN_DETAIL_FILEDS[] = {GRID_GENE_NAME, GRID_CHR_NAME, GRID_POS_NAME, GRID_REF_NAME, GRID_ALT_NAME, GRID_MUTATION_TYPE_NAME, GRID_VARIANT_RATE_NAME};
	
	private static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
	
	public final static Double[] DEG_LOG2FC = { 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0 }; // ge
	public final static Double[] DEG_ADJ_PVALUE = { 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1.0 }; // lt
	public final static Double[] DEG_PVALUE = { 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1.0 }; // lt
	
	public final static Double[] DMP_LOG2FC = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8 }; // ge
	public final static Double[] DMP_ADJ_PVALUE = { 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1.0 }; // lt
	public final static Double[] DMP_PVALUE = { 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1.0 }; // lt
	
	private final static CommonFunctions cf = new CommonFunctions();

	public static void makeGridProperties(OmicsDataVO vo) throws Exception {
		
		if (OmicsType.MutationSnv == vo.getType() || OmicsType.MutationIndel == vo.getType()) {
			vo.setGridFields(createMutGridField(vo));
			vo.setGridColumns(createGridColumns(vo));
			vo.setGridData(createMutGridDataArray(vo));
		} else {
			vo.setGridFields(createGridField(vo));
			vo.setGridColumns(createGridColumns(vo));
			vo.setGridData(createGridDataArray(vo));
		}
	}
	
	public static JSONObject createGridField(OmicsDataVO vo) {
		JSONObject fields = new JSONObject();

		JSONObject stringType = new JSONObject();
		stringType.put("type", "string");
		JSONObject numberType = new JSONObject();
		numberType.put("type", "number");

		fields.put(GRID_GENE_NAME, stringType);
		for (int i = 0; i < vo.getSampleList().size(); i++) {
			fields.put(GRID_FIELD_NAME + i, numberType);
		}

		return fields;
	}
	
	public static JSONObject createMutGridField(OmicsDataVO vo) {
		JSONObject fields = new JSONObject();

		JSONObject stringType = new JSONObject();
		stringType.put("type", "string");
		JSONObject numberType = new JSONObject();
		numberType.put("type", "string");

		fields.put(GRID_GENE_NAME, stringType);
		for (int i = 0; i < vo.getSampleList().size(); i++) {
			fields.put(GRID_FIELD_NAME + i, numberType);
		}

		return fields;
	}

	public static JSONArray createGridColumns(OmicsDataVO vo) {
		JSONArray columns = new JSONArray();

		JSONObject geneColumn = new JSONObject();
		geneColumn.put("field", GRID_GENE_NAME);
		geneColumn.put("title", GRID_GENE_NAME);
		geneColumn.put("width", 160);

		columns.add(geneColumn);
		int i = 0;
		
		JSONArray group1Columns = new JSONArray();
		for (String sample : vo.getSample1List()) {
			JSONObject item = new JSONObject();
			item.put("field", GRID_FIELD_NAME + i++);
			item.put("title", sample);
			item.put("width", 130);
			item.put("headerTemplate", "<label class=\"grp1Header\">" + sample + "</label>");
			group1Columns.add(item);
		}
		JSONObject group1 = new JSONObject();
		group1.put("title", "Group1");
		group1.put("headerTemplate", "<label class=\"grp1Header\">Group1</label>");
		group1.put("columns", group1Columns);
		columns.add(group1);
		
		JSONArray group2Columns = new JSONArray();
		for (String sample : vo.getSample2List()) {
			JSONObject item = new JSONObject();
			item.put("field", GRID_FIELD_NAME + i++);
			item.put("title", sample);
			item.put("width", 130);
			item.put("headerTemplate", "<label class=\"grp2Header\">" + sample + "</label>");
			group2Columns.add(item);
		}
		JSONObject group2 = new JSONObject();
		group2.put("title", "Group2");
		group2.put("headerTemplate", "<label class=\"grp2Header\">Group2</label>");
		group2.put("columns", group2Columns);
		columns.add(group2);

		return columns;
	}

	public static JSONArray createGridDataArray(OmicsDataVO vo) throws Exception {
		Map<String, Map<String, Double>> map = createDataMap(vo);

		JSONArray data = new JSONArray();

		List<String> rowList = null;
		switch (vo.getType()) {
		case Expression:
			rowList = vo.getGeneList();
			break;
		case Methylation:
			rowList = vo.getGeneProbeList();
			break;
		case MutationSnv:
			rowList = vo.getGeneList();
			break;
		case MutationIndel:
			rowList = vo.getGeneList();
			break;
		default:
			rowList = new ArrayList<String>();
			break;
		}
			
		for (String gene : rowList) {
			JSONObject row = new JSONObject();
			row.put(GRID_GENE_NAME, gene);

			int i = 0;
			for (String sample : vo.getSampleList()) {
				if (map.get(sample) != null) {
					row.put(GRID_FIELD_NAME + i++, map.get(sample).get(gene));
				}
			}
			data.add(row);
		}

		return data;
	}
	
	public static JSONArray createMutGridDataArray(OmicsDataVO vo) throws Exception {
		Map<String, Map<String, mo_mutationVO>> map = createMutDataMapObject(vo);

		JSONArray data = new JSONArray();
		
		List<String> rowList = null;
		rowList = vo.getGeneList();
			
		for (String gene : rowList) {
			JSONObject row = new JSONObject();
			row.put(GRID_GENE_NAME, gene);

			int i = 0;
			for (String sample : vo.getSampleList()) {
				if (map.get(sample) != null) {
//					if (StringUtils.isNotBlank(map.get(sample).get(gene))) {
//						row.put(GRID_FIELD_NAME + i++, map.get(sample).get(gene));
//					} else {
//						row.put(GRID_FIELD_NAME + i++, "");
//					}
					if (map.get(sample).get(gene)!=null) {
						row.put(GRID_FIELD_NAME + i++, map.get(sample).get(gene).getDisplayString());
					} else {
						row.put(GRID_FIELD_NAME + i++, "");
					}
					
				}
			}
			data.add(row);
		}

		return data;
	}

	public static Map<String, Map<String, Double>> createDataMap(OmicsDataVO vo) {
		return createDataMap(vo, false);
	}

	public static Map<String, Map<String, Double>> createDataMap(OmicsDataVO vo, boolean logarithm) {
		Map<String, Map<String, Double>> map = new HashMap<String, Map<String, Double>>();
		for (String i : vo.getSampleList()) {
			Map<String, Double> valueMap = new HashMap<String, Double>();
			map.put(i, valueMap);
		}
		
 		switch (vo.getType()) {
		case Expression:
			if (logarithm) {
				for (mo_expVO i : vo.getExpList()) {
					if (map.containsKey(i.getSample_id()))
						map.get(i.getSample_id()).put(i.getGene_symbol(), i.getValPlus1Log2());
				}
			} else {
				for (mo_expVO i : vo.getExpList()) {
					if (map.containsKey(i.getSample_id()))
						map.get(i.getSample_id()).put(i.getGene_symbol(), i.getVal());
				}
			}
			break;
		case Methylation:
			for (mo_methVO i : vo.getMethList()) {
				if (map.containsKey(i.getSample_id()))
					map.get(i.getSample_id()).put(i.getGene_probe(), i.getBeta_value());
			}
			break;
		default:
			break;

		}

		return map;
	}
	
	public static Map<String, Map<String, String>> createMutDataMap(OmicsDataVO vo) {
		Map<String, Map<String, String>> map = new HashMap<String, Map<String, String>>();
		for (String i : vo.getSampleList()) {
			Map<String, String> valueMap = new HashMap<String, String>();
			map.put(i, valueMap);
		}
		
 		if (vo.getType() == OmicsType.MutationSnv) {
 			for (mo_mutationVO i : vo.getMutList()) {
 				if (map.containsKey(i.getSample_id()))
 					map.get(i.getSample_id()).put(i.getHugo_symbol(), i.getVariant_classification());
 			}
 		} else if (vo.getType() == OmicsType.MutationIndel) {
 			for (mo_mutationVO i : vo.getMutList()) {
 				if (map.containsKey(i.getSample_id()))
 					map.get(i.getSample_id()).put(i.getHugo_symbol(), i.getVariant_type());
 			}
 		}
		
		return map;
	}

	public static Map<String, Map<String, mo_mutationVO>> createMutDataMapObject(OmicsDataVO vo) {
		Map<String, Map<String, mo_mutationVO>> map = new HashMap<String, Map<String, mo_mutationVO>>();
		for (String i : vo.getSampleList()) {
			Map<String, mo_mutationVO> valueMap = new HashMap<String, mo_mutationVO>();
			map.put(i, valueMap);
		}
		
		for (mo_mutationVO i : vo.getMutList()) {
			if (map.containsKey(i.getSample_id()))
				map.get(i.getSample_id()).put(i.getHugo_symbol(), i);
 		}
		
		return map;
	}
	
	public static List<List<Double>> createHeatmapData(OmicsDataVO vo) throws Exception {
		Map<String, Map<String, Double>> map = createDataMap(vo, true);

		List<List<Double>> dataList = new ArrayList<List<Double>>();
		for (String sampleId : vo.getSampleList()) {
			List<Double> valueList = new ArrayList<Double>();
			
			// 정리
			switch (vo.getType()) {
			case Expression:
				for (String gene : vo.getGeneList()) {
					valueList.add(map.get(sampleId).get(gene));
				}
				break;
			case Methylation:
				for (String gene : vo.getGeneProbeList()) {
					valueList.add(map.get(sampleId).get(gene));
				}
				break;
			default:
				break;

			}
			
			dataList.add(valueList);
		}

		return dataList;
	}
	
	public static List<List<String>> createHeatmapData4(OmicsDataVO vo) throws Exception {
		//vo.setType(OmicsType.MutationSnv);
		
		Map<String, Map<String, String>> map = createMutDataMap(vo);

		List<List<String>> dataList = new ArrayList<List<String>>();
		for (String sampleId : vo.getSampleList()) {
			List<String> valueList = new ArrayList<String>();
			
			for (String gene : vo.getGeneList()) {
				valueList.add(map.get(sampleId).get(gene));
			}
			
			dataList.add(valueList);
		}

		return dataList;
	}

	public static List<String> createPcaPlotVars(List<PcaResultVO> pcaList) throws Exception {
		return pcaList.stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList());
	}

	public static void makePcaPlotData(OmicsDataVO vo) throws Exception {
		List<List<Double>> dataList = new ArrayList<List<Double>>();
		for (PcaResultVO i : vo.getPcaList()) {
			List<Double> valueList = new ArrayList<Double>();
			valueList.add(i.getPc1());
			valueList.add(i.getPc2());
			valueList.add(i.getPc3());
			valueList.add(i.getPc4());
			valueList.add(i.getPc5());

			dataList.add(valueList);
		}
		
		vo.setPcaPlotDataList(dataList);
	}
	
	public static void uploadScRna(MultipartFile uploadFile, String newFileName) {
		if (uploadFile != null && !uploadFile.isEmpty()) {
			try {
				File saveFolder = new File(EgovWebUtil.filePathBlackList(SCRNA_UPLOAD_PATH));

				if (!saveFolder.exists() || saveFolder.isFile()) {
					saveFolder.mkdirs();
				}

				String filePath = SCRNA_UPLOAD_PATH + File.separator + newFileName;

				uploadFile.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
			} catch (Exception e) {
				logger.error("", e);
			}
		}
	}
	
	public static List<String> getScRnaBase64ImageList() throws Exception {
		List<String> base64ImageList = new ArrayList<String>();
		
		base64ImageList.add(getBase64Image(SCRNA_PATH + "01.VlnPlot.png"));
		base64ImageList.add(getBase64Image(SCRNA_PATH + "02.VariableFeaturePlot.png"));
		base64ImageList.add(getBase64Image(SCRNA_PATH + "03.JackStrawPlot.png"));
		base64ImageList.add(getBase64Image(SCRNA_PATH + "04.UMAP.png"));
		
		return base64ImageList;
	}
	
	private static String getBase64Image(String filePath) throws Exception {
		File imageFile = new File(filePath);
		
		if (imageFile.exists() && imageFile.isFile()) {
			return new String("data:image/jpg;base64," + cf.fileToBase64Encoding(imageFile.getPath()));
		}
		return null;
	}
	
	public static void excuteExtractBam(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = THIRD_WORK_PATH + vo.getToolsDir() + "/";
		String inputFile = dir + vo.getToolsInputFile();

		xcmd.add("bash");
		xcmd.add(THIRD_EXTRACT_SCRIPT);
		xcmd.add(inputFile);
		xcmd.add(vo.getBe_Chr_name());
		xcmd.add(vo.getBe_start());
		xcmd.add(vo.getBe_end());
		xcmd.add(dir);

		linuxExecutePath(xcmd, THIRD_TOOLS_PATH);
	}
	
	public static void excuteSamTools(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = THIRD_WORK_PATH + vo.getToolsDir() + "/";
		String inputFile = dir + vo.getInputSamFile();
		String outputFile = dir + vo.getInputSamFile() + "." + vo.getOutputSamFormat().toLowerCase();
		String script = SAMTOOLS_BAM_SAM_SCRIPT;
		
		if ("BAM".equals(vo.getInputSamFormat())) {
			if ("SAM".equals(vo.getOutputSamFormat())) {
				script = SAMTOOLS_BAM_SAM_SCRIPT;
			} else if ("FASTA".equals(vo.getOutputSamFormat())) {
				script = SAMTOOLS_BAM_FASTA_SCRIPT;
			} else if ("FASTQ".equals(vo.getOutputSamFormat())) {
				script = SAMTOOLS_BAM_FASTQ_SCRIPT;
			}
		} else if ("SAM".equals(vo.getInputSamFormat())) {
			if ("BAM".equals(vo.getOutputSamFormat())) {
				script = SAMTOOLS_SAM_BAM_SCRIPT;
			}
		}
		
		xcmd.add("bash");
		xcmd.add(script);
		xcmd.add(inputFile);
		xcmd.add(outputFile);

		linuxExecutePath(xcmd, THIRD_TOOLS_PATH);
	}
	
	public static void excuteBedTools(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = THIRD_WORK_PATH + vo.getToolsDir() + "/";
		String inputFile = dir + vo.getInputBedFile();
		String outputFile = dir + vo.getInputBedFile() + "." + vo.getOutputBedFormat().toLowerCase();
		
		xcmd.add("bash");
		
		if ("BED".equals(vo.getInputBedFormat())) {
			if ("BAM".equals(vo.getOutputBedFormat())) {
				xcmd.add(BEDTOOLS_BED_BAM_SCRIPT);
				xcmd.add(inputFile);
				xcmd.add(vo.getGenomeVersion() + "." + vo.getGenomeFormat() + ".chrom.sizes");
				
			}
		} else if ("BAM".equals(vo.getInputBedFormat())) {
			if ("BED".equals(vo.getOutputBedFormat())) {
				xcmd.add(BEDTOOLS_BAM_BED_SCRIPT);
				xcmd.add(inputFile);
			}
		}
		xcmd.add(outputFile);

		linuxExecutePath(xcmd, THIRD_TOOLS_PATH);
	}
	
	public static void excuteVcfTools(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = THIRD_WORK_PATH + vo.getToolsDir() + "/";
		String inputFile = dir + vo.getInputVcfFile();
		String outputFile = dir + vo.getInputVcfFile() + "." + vo.getOutputVcfFormat().toLowerCase();
		
		xcmd.add("bash");
		if ("VCF".equals(vo.getInputVcfFormat())) {
			if ("BAM".equals(vo.getOutputVcfFormat())) {
				//xcmd.add(VCFTOOLS_VCF_BAM_SCRIPT);
			} else if ("BED".equals(vo.getOutputVcfFormat())) {
				xcmd.add(VCFTOOLS_VCF_BED_SCRIPT);
			}
		} 
		
		xcmd.add(inputFile);
		xcmd.add(outputFile);

		linuxExecutePath(xcmd, THIRD_TOOLS_PATH);
	}
	
	public static void excuteScRna(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String inputPath = SCRNA_UPLOAD_PATH;

		xcmd.add("bash");
		xcmd.add(SCRNA_SCRIPT);
		xcmd.add(inputPath);

		linuxExecutePath(xcmd, SCRNA_PATH);
	}
	
	public static void excuteDmp(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String dmpInputFile = dir + DMP_MERGE_FILE_PRE;
		String dmpOutputFile = dir + DMP_RESULT_FILE;
		

		xcmd.add("bash");
		xcmd.add(DMP_CHAMP_SCRIPT);
		xcmd.add(dmpInputFile);
		xcmd.add(Integer.toString(vo.getDmpSampleCnt1()));
		xcmd.add(Integer.toString(vo.getDmpSampleCnt2()));
		xcmd.add(dmpOutputFile);

		linuxExecutePath(xcmd, DMP_PATH);
	}

	public static void excuteDeg(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degInputFile = dir + DEG_MERGE_FILE_PRE;
		String degOutputFile = dir + DEG_RESULT_FILE;

		xcmd.add("bash");
		xcmd.add(DEG_EXCUTE_SCRIPT);
		xcmd.add(degInputFile);
		xcmd.add(Integer.toString(vo.getSample1List().size()));
		xcmd.add(Integer.toString(vo.getSample2List().size()));
		xcmd.add(degOutputFile);

		linuxExecutePath(xcmd, DEG_PATH);
	}
	
	public static void excuteDeSeq2(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degInputFile = dir + DESEQ2_MERGE_FILE_PRE;
		String degOutputFile = dir + DESEQ2_RESULT_FILE;

		xcmd.add("bash");
		xcmd.add(DESEQ2_EXCUTE_SCRIPT);
		xcmd.add(degInputFile);
		xcmd.add(Integer.toString(vo.getSample1List().size()));
		xcmd.add(Integer.toString(vo.getSample2List().size()));
		xcmd.add(degOutputFile);

		linuxExecutePath(xcmd, DESEQ2_PATH);
	}

	public static void excutePca(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String pcaInputFile = dir + PCA_MERGE_FILE_PRE;
		String pcaOutputFile = dir + PCA_RESULT_FILE;

		xcmd.add("bash");
		xcmd.add(PCA_EXCUTE_SCRIPT);
		xcmd.add(pcaInputFile);
		xcmd.add(Integer.toString(vo.getSample1List().size()));
		xcmd.add(Integer.toString(vo.getSample2List().size()));
		xcmd.add(pcaOutputFile);

		linuxExecutePath(xcmd, PCA_PATH);
	}

	public static String mergeExpCnt(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("paste");
		xcmd.add("Gene_Symbol.txt");

		for (String s : vo.getSampleList()) {
			xcmd.add(s + ".txt");
		}

		String outFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + DEG_MERGE_FILE_PRE;

		if (vo.getUd_idx() == 2) {
			linuxExecutePath(xcmd, DEG_MERGE_PATH2, outFile);
		} else {
			linuxExecutePath(xcmd, DEG_MERGE_PATH, outFile);
		}
		
		return outFile;
	}
	
	public static String mergeExpCntDeSeq2(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("paste");
		xcmd.add("Gene_Symbol.txt");

		for (String s : vo.getSampleList()) {
			xcmd.add(s + ".txt");
		}

		String outFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + DESEQ2_MERGE_FILE_PRE;

		if (vo.getUd_idx() == 2) {
			linuxExecutePath(xcmd, DESEQ2_MERGE_PATH2, outFile);
		} else {
			linuxExecutePath(xcmd, DESEQ2_MERGE_PATH, outFile);
		}
		
		return outFile;
	}

	public static String mergeExpTpmForPca(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("paste");
		xcmd.add("Gene_Symbol.txt");

		for (String s : vo.getSampleList()) {
			xcmd.add(s + ".txt");
		}

		String outFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + PCA_MERGE_FILE_PRE;

		if (vo.getUd_idx() == 2) {
			linuxExecutePath(xcmd, PCA_MERGE_PATH2, outFile);
		} else {
			linuxExecutePath(xcmd, PCA_MERGE_PATH, outFile);
		}
		
		return outFile;
	}
	
	// 1 tpm 생성
	public static void mergeExpTpmSurvDeg(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("paste");
		xcmd.add("Gene_Symbol.txt");

		for (String s : vo.getSampleList()) {
			xcmd.add(s + ".txt");
		}

		String outFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_MERGE_FILE_PRE;

		if (vo.getUd_idx() == 2) {
			linuxExecutePath(xcmd, SURV_DEG_MERGE_PATH2, outFile);
		} else {
			linuxExecutePath(xcmd, SURV_DEG_MERGE_PATH, outFile);
		}
	}
	
	// 2E normalize
	public static void excuteSurvDegNormalize(OmicsDataVO vo) throws Exception {
		String degInputFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_MERGE_FILE_PRE;
		
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("Rscript");
		xcmd.add(SURV_EXCUTE_1_SCRIPT);
		xcmd.add(degInputFile);

		linuxExecutePath(xcmd, SURV_PATH);
	}

	// 3 gene set 파일 생성
	public static void makeSurvGeneFile(OmicsDataVO vo) {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_GENE_FILE_PRE;
		
		
		File file = null;
		//BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		try {
			file = new File(filePath);
			try(BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
				bw.write("Gene");
				bw.write(NEWLINE);
				for(String gene : vo.getGeneList()) {
					bw.write(gene);
					bw.write(NEWLINE);
				}
				bw.flush();
				bw.close();
			} catch (Exception e) {
				logger.error("", e);
			}
		} catch (Exception e) {
			logger.error("", e);
		}
	}

	// 4 clinic file 생성
	public static void makeClinicFile(OmicsDataVO vo, List<mo_clinicalVO> list) {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_CLINIC_FILE_PRE;
		
		
		File file = null;
		//BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			try(BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
				bw.write("Sample_ID\tDFS\tRecur");
				bw.write(NEWLINE);
				for(mo_clinicalVO i : list) {
					bw.write(i.getSample_id() + "\t");
					bw.write(i.getDfs() + "\t");
					bw.write(i.getRecur());
					bw.write(NEWLINE);
				}
				bw.flush();
				bw.close();
			} catch (Exception e) {
				logger.error("", e);
			}
		} catch (Exception e) {
			logger.error("", e);
		}
	}
	
	// 4 clinic file 생성
	public static void makeClinicFileD2(OmicsDataVO vo, List<mo_clinicalD2VO> list) {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_CLINIC_FILE_PRE;
		
		
		File file = null;
		//BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			try(BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
				bw.write("Sample_ID\tDFS\tRecur");
				bw.write(NEWLINE);
				for(mo_clinicalD2VO i : list) {
					double dfs = Math.round(((CommonFunctions.parseDouble(i.getDays_to_birth()) * -1) / 30.417) * 100) / 100.0;
					
					String recur = "0";
					if ("Dead".equals(i.getVital_status_x()) || !"NA".equals(i.getDays_to_death_x())) {
						recur = "1";
					}
					bw.write(i.getSample_id() + "\t");
					bw.write(dfs + "\t");
					bw.write(recur);
					bw.write(NEWLINE);
				}
				bw.flush();
				bw.close();
			} catch (Exception e) {
				logger.error("", e);
			}
		} catch (Exception e) {
			logger.error("", e);
		}
	}
	
	

	// 5E 실행 excute 데이터 파일 생성
	public static void excuteRMakeData(OmicsDataVO vo) throws Exception {
		String tpmFile = SURV_PATH + SURV_NORMALIZED_FILE;
		String geneFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_GENE_FILE_PRE;
		String clinicFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_CLINIC_FILE_PRE;
		
		switch(vo.getGeneType()) {
		case DEG_Genes:
			geneFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_GENE_FILE_PRE;
			break;
		case TGFb_Core_Genes:
			geneFile = "TGFb_Core_Genes.txt";
			break;
		case TGFb_Regul_Targets:
			geneFile = "TGFb_Regul_Targets.txt";
			break;
		case UserGeneSet:
			geneFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_GENE_FILE_PRE;
			break;
		}
		
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("Rscript");
		xcmd.add(SURV_EXCUTE_2_SCRIPT);
		xcmd.add(tpmFile);
		xcmd.add(geneFile);
		xcmd.add(clinicFile);

		linuxExecutePath(xcmd, SURV_PATH);
	}
	
	public static void makeZscoreInputFile(OmicsDataVO vo) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + DEG_ZSCORE_INPUT_FILE;
		System.out.println(filePath);
		
		vo.setType(OmicsType.Expression);
		Map<String, Map<String, Double>> map = createDataMap(vo);
		
		List<String> geneList = vo.getGeneList();
		List<String> sampleList = vo.getSampleList();
		

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			for(String gene : geneList) {
				sb.append(gene);
				for(String sample : sampleList) {
					sb.append("\t" + map.get(sample).get(gene));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void excuteZscore(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degInputFile = dir + DEG_ZSCORE_INPUT_FILE;
		String degOutputFile = dir + DEG_ZSCORE_OUTPUT_FILE;

		xcmd.add("bash");
		xcmd.add(DEG_ZSCORE_SCRIPT);
		xcmd.add(degInputFile);
		xcmd.add(degOutputFile);

		linuxExecutePath(xcmd, DEG_ZSCORE_PATH);
	}
	
	public static void parseZscore(OmicsDataVO searchVO) {
		
		List<mo_expVO> list = new ArrayList<mo_expVO>();
		String line;
		String inputFile = getWorkspacePath(searchVO.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + DEG_ZSCORE_OUTPUT_FILE;
		try (BufferedReader br = new BufferedReader(new FileReader(inputFile))) {
			line = br.readLine();
			String[] sampleIds = StringUtils.splitPreserveAllTokens(line, "\t");

			String geneSymbol = null;
			mo_expVO vo = null;
			Integer intVal = 0;
			Integer degMin = 0;
			Integer degMax = 0;
			Integer absMin = 0;
			Double tmp = 0d;
			
			while ((line = br.readLine()) != null) {
				
				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {
					geneSymbol = values[0];
					
					//System.out.println(geneSymbol);
					
					for (int i = 1; i < values.length; i++) {
						
						vo = new mo_expVO();
						vo.setUd_id(1);
						vo.setSample_id(StringUtils.replace(sampleIds[i], ".", "-"));
						vo.setGene_symbol(geneSymbol);
						vo.setVal(CommonFunctions.parseDouble(values[i]));
						
						if (vo.getVal() > tmp) tmp = vo.getVal();
						if (vo.getVal() > 0) {
							intVal = (int) Math.floor(vo.getVal());
							if (degMax < intVal) 
								degMax = intVal;
						} else {
							intVal = (int) Math.ceil(vo.getVal());
							if (degMin > intVal) 
								degMin = intVal;
						}
						
						list.add(vo);
						
						
					}
				}
			}
			if (Math.abs(degMin) < Math.abs(degMax)) {
				absMin = degMin;
			} else {
				absMin = degMax;
			}
			searchVO.setDegMin(-absMin);
			searchVO.setDegMax(absMin);

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		searchVO.setExpList(list);
	}
	
	public static boolean isExistsZscore(OmicsDataVO searchVO) {
		String filePath = getWorkspacePath(searchVO.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + DEG_ZSCORE_OUTPUT_FILE;
		
		File file = new File(filePath);
		
		System.out.println("filePath : " + filePath);
		System.out.println("file.exists() : " + file.exists());
		
		return file.exists();
	}	
	
	public static void excuteMultiEm(OmicsDataVO vo) throws Exception {
		String inputExpFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EM_INPUT_EXP;
		String inputMutFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EM_INPUT_MUT;
		
		List<String> xcmd = new ArrayList<String>();

		xcmd.add("bash");
		xcmd.add(MULTI_EM_SCRIPT);
		xcmd.add(inputExpFile);
		xcmd.add(inputMutFile);

		linuxExecutePath(xcmd, MULTI_EM_PATH);
	}
	
	public static void excuteMultiEmm(OmicsDataVO vo) throws Exception {
		String inputExpFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EMM_INPUT_EXP;
		String inputMutFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EMM_INPUT_MUT;
		String inputMethFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EMM_INPUT_METH;
		
		List<String> xcmd = new ArrayList<String>();

		xcmd.add("bash");
		xcmd.add(MULTI_EMM_SCRIPT);
		xcmd.add(inputExpFile);
		xcmd.add(inputMutFile);
		xcmd.add(inputMethFile);

		linuxExecutePath(xcmd, MULTI_EMM_PATH);
	}
	
	public static void parseMultiEmCorr(OmicsDataVO searchVO) {
		int total = 0;
		JSONArray jsonRows = new JSONArray();
		JSONObject jsonRow;
		
		List<MultiEmRow> multiEmCorrList = new ArrayList<MultiEmRow>();
		List<String> sampleList = searchVO.getSampleList();

		String line;
		// 결과 파일 폴더
		//String dataFile =WORKSPACE_PATH + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = MULTI_EM_PATH + MULTI_EM_RESULT_CORR;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			if ((line = br.readLine()) != null) {

				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {
					MultiEmRow row = new MultiEmRow();

					List<String> cellList = new ArrayList<String>();
					for(String o : values) {
						cellList.add(StringUtils.replace(o, ".", "-"));
					}
					row.setCellList(cellList);
					multiEmCorrList.add(row);
					
				}
			}
			while ((line = br.readLine()) != null) {
				
				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {
					List<String> cellList = new ArrayList<String>();
					for(String c : values) {
						cellList.add(c);
					}
					
					List<String> varList = cellList.subList(sampleList.size() + 1, sampleList.size() * 2 + 1);
					List<String> expInnerList = cellList.subList(1, sampleList.size() + 1);
					
					//varList.forEach(System.out::println);
					//expInnerList.forEach(System.out::println);
					
					List<List<String>> expList = new ArrayList<List<String>>();
					expList.add(expInnerList);
					
					MultiEmRow row = new MultiEmRow();
					row.setGeneSymbol(values[0]);
					row.setCellList(cellList);
					row.setSampleList(sampleList);
					row.setVarList(varList);
					row.setExpList(expList);
					row.setSample(JSONArray.fromObject(sampleList).toString());
					multiEmCorrList.add(row);
					
					if (!StringUtils.equals("NA", values[sampleList.size() * 2 + 2])) {
						total++;
						jsonRow = new JSONObject();
						jsonRow.put("no", total);
						jsonRow.put("gene_symbol", row.getGeneSymbol());
						jsonRow.put("coefficient", values[sampleList.size() * 2 + 1]);
						jsonRow.put("p_value", values[sampleList.size() * 2 + 2]);
						jsonRows.add(jsonRow);
					}
					
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		JSONObject xbody2 = new JSONObject();
		xbody2.put("total", total);
		xbody2.put("rows", jsonRows);

		searchVO.setMultiEmCorrList(multiEmCorrList);
		searchVO.setMultiEmJson(xbody2);
	}
	
	public static void parseMultiEmmCorr(OmicsDataVO searchVO) {
		int total = 0;
		JSONArray jsonRows = new JSONArray();
		JSONObject jsonRow;
		
		List<MultiEmmRow> multiEmmCorrList = new ArrayList<MultiEmmRow>();
		List<String> sampleList = searchVO.getSampleList();
		
		String line;
		// 결과 파일 폴더
		//String dataFile =WORKSPACE_PATH + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = MULTI_EMM_PATH + MULTI_EMM_RESULT_CORR;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			
			if ((line = br.readLine()) != null) {

				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {
					MultiEmmRow row = new MultiEmmRow();

					List<String> cellList = new ArrayList<String>();
					for(String o : values) {
						cellList.add(StringUtils.replace(o, ".", "-"));
					}
					row.setCellList(cellList);
					multiEmmCorrList.add(row);
					
				}
			}

			
			while ((line = br.readLine()) != null) {
				
				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {

					List<String> cellList = new ArrayList<String>();
					for(String o : values) {
						cellList.add(o);
					}
					
					List<String> methList = cellList.subList(sampleList.size() * 2 + 6, sampleList.size() * 3 + 6); 
					List<String> varList = cellList.subList(sampleList.size() + 6, sampleList.size() * 2 + 6);
					List<String> expInnerList = cellList.subList(6, sampleList.size() + 6);
					 
					/*
					List<String> methList = cellList.subList(10 * 2 + 1, 10 * 3 + 1);
					List<String> varList = cellList.subList(10 + 1, 10 * 2 + 1);
					List<String> expInnerList = cellList.subList(1, 10 + 1);
					*/
					
					methList.forEach(System.out::println);
					varList.forEach(System.out::println);
					expInnerList.forEach(System.out::println);
					
					List<List<String>> expList = new ArrayList<List<String>>();
					expList.add(expInnerList);
					
					MultiEmmRow row = new MultiEmmRow();
					row.setGeneSymbol(values[0]);
					row.setCellList(cellList);
					row.setSampleList(sampleList);
					row.setVarList(varList);
					row.setExpList(expList);
					row.setMethList(methList);
					row.setSample(JSONArray.fromObject(sampleList).toString());
					row.setMeth(JSONArray.fromObject(methList).toString());
					multiEmmCorrList.add(row);
					
					if (!StringUtils.equals("NA", values[sampleList.size() * 2 + 2])) {
						total++;
						jsonRow = new JSONObject();
						jsonRow.put("no", total);
						jsonRow.put("gene_symbol", values[0]);
						jsonRow.put("probe_id", values[3]);
						jsonRow.put("coefficient", values[4]);
						jsonRow.put("p_value", values[5]);
						jsonRows.add(jsonRow);
					}
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		JSONObject xbody3 = new JSONObject();
		xbody3.put("total", total);
		xbody3.put("rows", jsonRows);

		searchVO.setMultiEmmCorrList(multiEmmCorrList);
		searchVO.setMultiEmmJson(xbody3);
	}
	
	public static void parseMultiEmVar(OmicsDataVO searchVO) {
		List<List<String>> multiEmVarList = new ArrayList<List<String>>();

		String line;
		// 결과 파일 폴더
		//String dataFile =WORKSPACE_PATH + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = MULTI_EM_PATH + MULTI_EM_RESULT_VAR;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			while ((line = br.readLine()) != null) {
				
				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {

					List<String> cellList = new ArrayList<String>();
					for(String o : values) {
						cellList.add(o);
					}
					multiEmVarList.add(cellList);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setMultiEmVarList(multiEmVarList);
	}
	
	public static void parseMultiEmmMeth(OmicsDataVO searchVO) {
		List<List<String>> multiEmmMethList = new ArrayList<List<String>>();

		String line;
		// 결과 파일 폴더
		//String dataFile =WORKSPACE_PATH + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = MULTI_EMM_PATH + MULTI_EMM_RESULT_METH;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			while ((line = br.readLine()) != null) {
				
				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {

					List<String> cellList = new ArrayList<String>();
					for(String o : values) {
						cellList.add(o);
					}
					multiEmmMethList.add(cellList);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setMultiEmmMethList(multiEmmMethList);
	}
	
	public static void parseMultiEmmVar(OmicsDataVO searchVO) {
		List<List<String>> multiEmmVarList = new ArrayList<List<String>>();

		String line;
		// 결과 파일 폴더
		//String dataFile =WORKSPACE_PATH + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = MULTI_EMM_PATH + MULTI_EMM_RESULT_VAR;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			while ((line = br.readLine()) != null) {
				
				String[] values = StringUtils.splitPreserveAllTokens(line, "\t");
				if (values != null) {

					List<String> cellList = new ArrayList<String>();
					for(String o : values) {
						cellList.add(o);
					}
					multiEmmVarList.add(cellList);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setMultiEmmVarList(multiEmmVarList);
	}
	
	public static void makeDirectory(OmicsDataVO vo) {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		
		File dir = new File(filePath);
		if (!dir.exists())
			dir.mkdirs();
	}
	
	public static void makeMultiEmExpInputFile(OmicsDataVO vo) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EM_INPUT_EXP;
		
		System.out.println("======makeMultiEmExpInputFile======");
		System.out.println(filePath);
		
		vo.setType(OmicsType.Expression);
		Map<String, Map<String, Double>> map = createDataMap(vo);
		
		List<String> geneList = vo.getGeneList();
		List<String> sampleList = vo.getSampleList();

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		Double val = 0d;
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			for(String gene : geneList) {
				sb.append(gene);
				for(String sample : sampleList) {
					val = map.get(sample).get(gene);
					sb.append("\t");
					if (val != null) {
						sb.append(val);
					}
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void makeMultiEmmExpInputFile(OmicsDataVO vo) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EMM_INPUT_EXP;
		
		System.out.println("======makeMultiEmExpInputFile======");
		System.out.println(filePath);
		
		vo.setType(OmicsType.Expression);
		Map<String, Map<String, Double>> map = createDataMap(vo);
		
		List<String> geneList = vo.getGeneList();
		List<String> sampleList = vo.getSampleList();

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			for(String gene : geneList) {
				sb.append(gene);
				for(String sample : sampleList) {
					sb.append("\t" + map.get(sample).get(gene));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void makeMultiEmMutInputFile(OmicsDataVO vo) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EM_INPUT_MUT;
		
		System.out.println("======makeMultiEmMutInputFile======");
		System.out.println(filePath);
		
		vo.setType(OmicsType.MutationSnv);
		Map<String, Map<String, String>> map = createMutDataMap(vo);
		
		List<String> geneList = vo.getGeneList();
		List<String> sampleList = vo.getSampleList();

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			String val;
			for(String gene : geneList) {
				sb.append(gene);
				for(String sample : sampleList) {
					val = map.get(sample).get(gene);

					sb.append("\t" + (val == null ? "" : val));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void makeMultiEmmMutInputFile(OmicsDataVO vo) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EMM_INPUT_MUT;
		
		System.out.println("======makeMultiEmMutInputFile======");
		System.out.println(filePath);
		
		vo.setType(OmicsType.MutationSnv);
		Map<String, Map<String, String>> map = createMutDataMap(vo);
		
		List<String> geneList = vo.getGeneList();
		List<String> sampleList = vo.getSampleList();

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			String val;
			for(String gene : geneList) {
				sb.append(gene);
				for(String sample : sampleList) {
					val = map.get(sample).get(gene);

					sb.append("\t" + (val == null ? "" : val));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void makeMultiEmmMethInputFile(OmicsDataVO vo) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + MULTI_EMM_INPUT_METH;
		
		System.out.println("======makeMultiEmmMethInputFile======");
		System.out.println(filePath);
		
		vo.setType(OmicsType.Methylation);
		Map<String, Map<String, Double>> map = createDataMap(vo);
		
		List<String> geneProbeList = vo.getGeneProbeList();
		List<String> sampleList = vo.getSampleList();

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			Double val;
			for(String geneProbe : geneProbeList) {
				sb.append(geneProbe);
				for(String sample : sampleList) {
					val = map.get(sample).get(geneProbe);

					sb.append("\t" + (val == null ? "" : val));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 6 그래프 데이터 생성
	public static void makeSurvDegData(OmicsDataVO vo) {
		parseSurvDegDataFile(vo);
		parseSurvDegDatzFile(vo);
	}
	
	public static void makeSurvNewExpInputFile(OmicsDataVO vo) throws Exception {
		makeSurvNewExpInputFile(vo, false);
	}
		
	public static void makeSurvNewExpInputFile(OmicsDataVO vo, boolean isTwoGroup) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE;
		if (isTwoGroup) {
			filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE2;
		}
		System.out.println("======makeSurvNewExpInputFile======");
		System.out.println(filePath);
		
		vo.setType(OmicsType.Expression);
		Map<String, Map<String, Double>> map = createDataMap(vo);
		
		List<String> geneList = vo.getGeneList();
		List<String> sampleList = vo.getSampleList();
		

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			for(String gene : geneList) {
				sb.append(gene);
				for(String sample : sampleList) {
					sb.append("\t" + map.get(sample).get(gene));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void makeSurvNewMethInputFile(OmicsDataVO vo) throws Exception {
		makeSurvNewMethInputFile(vo, false);
	}
		
	public static void makeSurvNewMethInputFile(OmicsDataVO vo, boolean isTwoGroup) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE;
		if (isTwoGroup) {
			filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE2;
		}
		
		vo.setType(OmicsType.Methylation);
		Map<String, Map<String, Double>> map = createDataMap(vo);
		
		List<String> geneProbeList = vo.getGeneProbeList();
		List<String> sampleList = vo.getSampleList();
		

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			for(String geneProbe : geneProbeList) {
				sb.append(geneProbe);
				for(String sample : sampleList) {
					sb.append("\t" + map.get(sample).get(geneProbe));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void makeSurvNewMutInputFile(OmicsDataVO vo) throws Exception {
		makeSurvNewMutInputFile(vo, false);
	}
		
	public static void makeSurvNewMutInputFile(OmicsDataVO vo, boolean isTwoGroup) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE;
		if (isTwoGroup) {
			filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE2;
		}
		
		
		vo.setType(OmicsType.MutationSnv);
		Map<String, Map<String, String>> map = createMutDataMap(vo);
		
		List<String> geneList = vo.getGeneList();
		List<String> sampleList = vo.getSampleList();
		

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("Gene_Symbol");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			for(String gene : geneList) {
				sb.append(gene);
				for(String sample : sampleList) {
					sb.append("\t" + map.get(sample).get(gene));
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void makeSurvNewUserInputFile(OmicsDataVO vo, List<SurvivalAdditionalRow> vos, Integer group) throws Exception {
		String filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_USER;
		if (group == 2) {
			filePath = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_USER2;
		}
		System.out.println("======makeSurvNewExpInputFile======");
		System.out.println(filePath);
		
		List<String> sampleList = vo.getSampleList();

		File file = null;
		BufferedWriter bw = null;
		String NEWLINE = System.lineSeparator();
		// 줄바꿈(\n)
		try {
			file = new File(filePath);
			bw = new BufferedWriter(new FileWriter(file));
			StringBuffer sb = new StringBuffer();
			sb.append("");
			for(String sample : sampleList) {
				sb.append("\t" + sample);
			}
			sb.append(NEWLINE);
			
			for(SurvivalAdditionalRow row : vos) {
				sb.append(row.getRowTitle());
				
				List<SurvivalAdditionalRowValue> cells = row.getSurvivalAdditionalRowValues();
				
				int sampleSize = vo.getSampleList().size();
				int cellSize = cells.size();
				int dataSize = (cellSize < sampleSize ? cellSize : sampleSize);
				int nullSise = sampleSize - dataSize;
				
				for(int i = 0; i < dataSize; i++) {
					sb.append("\t" + cells.get(i).getCellValue());
				}
				for(int i = 0; i < nullSise; i++) {
					sb.append("\t");
				}
				sb.append(NEWLINE);
			}
			
			bw.write(sb.toString());

			bw.flush();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// surv new 01
	public static void excuteSurvNew01PC(OmicsDataVO vo) throws Exception {
		String inputFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE;
		String clinicFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_CLINIC_FILE_PRE;
		
		List<String> xcmd = new ArrayList<String>();

		xcmd.add("bash");
		xcmd.add(SURV_NEW_01_SCRIPT);
		xcmd.add(inputFile);
		xcmd.add(clinicFile);
		xcmd.add(vo.getSurvCutOff1());

		linuxExecutePath(xcmd, SURV_NEW_PATH_01_PC);
	}
	
	// surv new 02 RS
	public static void excuteSurvNew02RS(OmicsDataVO vo) throws Exception {
		String inputFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE;
		String clinicFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_CLINIC_FILE_PRE;
		
		List<String> xcmd = new ArrayList<String>();

		xcmd.add("bash");
		xcmd.add(SURV_NEW_02_SCRIPT);
		xcmd.add(inputFile);
		xcmd.add(clinicFile);
		xcmd.add(vo.getSurvCutOff1());

		linuxExecutePath(xcmd, SURV_NEW_PATH_02_RS);
	}
	
	// surv new 03 SG
	public static void excuteSurvNew03SG(OmicsDataVO vo) throws Exception {
		String inputFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_FILE;
		String clinicFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_CLINIC_FILE_PRE;
		
		List<String> xcmd = new ArrayList<String>();

		xcmd.add("bash");
		xcmd.add(SURV_NEW_03_SCRIPT);
		xcmd.add(inputFile);
		xcmd.add(clinicFile);
		xcmd.add(vo.getSurvCutOff1());
		xcmd.add(vo.getSurvSGsymbol1());
		if ("value".equals(vo.getSurvCutOff1())) {
			if ("mut".equals(vo.getSurvOmicsType1())) {
				xcmd.add(vo.getSurvSGcheck1());
			} else {
				xcmd.add(vo.getSurvSGvalue1());
			}
		} else {
			xcmd.add("0");
		}
		

		linuxExecutePath(xcmd, SURV_NEW_PATH_03_SG);
	}
	
	// surv new 04 TD
	public static void excuteSurvNew04TD(OmicsDataVO vo) throws Exception {
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String clinicFile = dir + SURV_CLINIC_FILE_PRE;
		String inputFile1 = dir + SURV_NEW_INPUT_FILE;
		String inputFile2 = dir + SURV_NEW_INPUT_FILE2;
		
		if ("UF".equals(vo.getSurvTool1())) {
			inputFile1 = dir + SURV_NEW_INPUT_USER;
		}
		
		if ("UF".equals(vo.getSurvTool2())) {
			inputFile2 = dir + SURV_NEW_INPUT_USER2;
		}
		
		List<String> xcmd = new ArrayList<String>();

		xcmd.add("bash");
		xcmd.add(SURV_NEW_04_SCRIPT);
		xcmd.add(clinicFile);
		
		xcmd.add(inputFile1);
		if ("SG".equals(vo.getSurvTool1())) {
			xcmd.add(vo.getSurvSGsymbol1());
			xcmd.add(vo.getSurvCutOff1());
			if ("mut".equals(vo.getSurvOmicsType1())) {
				xcmd.add(vo.getSurvSGcheck1());
			} else {
				xcmd.add(vo.getSurvSGvalue1());
			}
		} else if ("UF".equals(vo.getSurvTool1())) {
			xcmd.add(vo.getSurvUFsymbol1());
			xcmd.add(vo.getSurvCutOff1());
			if ("mut".equals(vo.getSurvOmicsType1())) {
				xcmd.add(vo.getSurvUFvalue1());
			} else {
				xcmd.add(vo.getSurvUFvalue1());
			}
		} else {
			xcmd.add(vo.getSurvTool1());
			xcmd.add(vo.getSurvCutOff1());	
			xcmd.add("0");
		}
		
		xcmd.add(inputFile2);
		if ("SG".equals(vo.getSurvTool2())) {
			xcmd.add(vo.getSurvSGsymbol2());
			xcmd.add(vo.getSurvCutOff2());
			if ("mut".equals(vo.getSurvOmicsType2())) {
				xcmd.add(vo.getSurvSGcheck2());
			} else {
				xcmd.add(vo.getSurvSGvalue2());
			}
		} else if ("UF".equals(vo.getSurvTool2())) {
			xcmd.add(vo.getSurvUFsymbol2());
			xcmd.add(vo.getSurvCutOff2());
			if ("mut".equals(vo.getSurvOmicsType2())) {
				xcmd.add(vo.getSurvUFvalue2());
			} else {
				xcmd.add(vo.getSurvUFvalue2());
			}
		} else {
			xcmd.add(vo.getSurvTool2());
			xcmd.add(vo.getSurvCutOff2());	
			xcmd.add("0");
		}

		linuxExecutePath(xcmd, SURV_NEW_PATH_04_TD);
	}
	
	// surv new 05 UF
	public static void excuteSurvNew05UF(OmicsDataVO vo) throws Exception {
		String inputFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_NEW_INPUT_USER;
		String clinicFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + SURV_CLINIC_FILE_PRE;
		
		List<String> xcmd = new ArrayList<String>();

		xcmd.add("bash");
		xcmd.add(SURV_NEW_05_SCRIPT);
		xcmd.add(inputFile);
		xcmd.add(clinicFile);
		xcmd.add(vo.getSurvCutOff1());
		xcmd.add(vo.getSurvUFsymbol1());
		
		if ("value".equals(vo.getSurvCutOff1())) {
			if ("mut".equals(vo.getSurvOmicsType1())) {
				xcmd.add(vo.getSurvUFvalue1());
			} else {
				xcmd.add(vo.getSurvUFvalue1());
			}
		} else {
			xcmd.add("0");
		}

		linuxExecutePath(xcmd, SURV_NEW_PATH_05_UF);
	}
	
	// surv new parse dataz
	public static void makeSurvNewData(OmicsDataVO searchVO, List<mo_clinicalVO> list) {
		List<String> survSampleList = new ArrayList<String>();
		List<List<String>> survDataList = new ArrayList<List<String>>();
		
		for(mo_clinicalVO i : list) {
			survSampleList.add(i.getSample_id());
			
			List<String> sList = new ArrayList<String>();
			sList.add(i.getDfs());
			sList.add(i.getRecur());
			survDataList.add(sList);
		}
		

		searchVO.setSurvSampleList(survSampleList);
		searchVO.setSurvDataList(survDataList);
		
	}
	
	// surv new parse dataz
	public static void makeSurvNewDataD2(OmicsDataVO searchVO, List<mo_clinicalD2VO> list) {
		List<String> survSampleList = new ArrayList<String>();
		List<List<String>> survDataList = new ArrayList<List<String>>();
		
		for(mo_clinicalD2VO i : list) {
			survSampleList.add(i.getSample_id());
			
			List<String> sList = new ArrayList<String>();
			double dfs = Math.round(((CommonFunctions.parseDouble(i.getDays_to_birth()) * -1) / 30.417) * 100) / 100.0;
			
			String recur = "0";
			if ("Dead".equals(i.getVital_status_x()) || !"NA".equals(i.getDays_to_death_x())) {
				recur = "1";
			}
			
			sList.add(Double.toString(dfs));
			sList.add(recur);
			survDataList.add(sList);
		}
		

		searchVO.setSurvSampleList(survSampleList);
		searchVO.setSurvDataList(survDataList);
		
	}
	
	// surv new 01 parse dataz
	public static void parseSurvNew01PCDatzFile(OmicsDataVO searchVO) {
		List<String> survGroupList = new ArrayList<String>();

		String line;
		// 결과 파일 폴더
		//String dataFile =getWorkspacePath(vo.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = SURV_NEW_PATH_01_PC + SURV_RESULT_DATZ_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			line = br.readLine();
			searchVO.setSurvPValue(line.replace("p = ", ""));
			
			line = br.readLine();
			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					survGroupList.add(values[1]);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvGroupList(survGroupList);
	}
	
	// surv new  parse s_table
	public static void parseSurvNewSTableFile(OmicsDataVO searchVO, int no) {
		SurvExtData survExtData = new SurvExtData();

		//String dataFile =getWorkspacePath(vo.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = SURV_NEW_PATH_01_PC + SURV_RESULT_STABLE_FILE;
		
		if(no == 1) {
			dataFile = SURV_NEW_PATH_01_PC + SURV_RESULT_STABLE_FILE;
		} else if(no == 2) {
			dataFile = SURV_NEW_PATH_02_RS + SURV_RESULT_STABLE_FILE;
		} else if(no == 3) {
			dataFile = SURV_NEW_PATH_03_SG + SURV_RESULT_STABLE_FILE;
		} else if(no == 4) {
			dataFile = SURV_NEW_PATH_04_TD + SURV_RESULT_STABLE_FILE;
		}

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			String[] cTitle;
			String[] time;
			String[] nRisk;
			String[] nEvent;
			String[] nSurvival;
			String[] stdErr;
			String[] color;
			
			cTitle  = StringUtils.splitPreserveAllTokens(br.readLine(), "\t");
			time = StringUtils.splitPreserveAllTokens(br.readLine(), "\t");
			color = new String[time.length];
			int cIdx = 0;
			for(int i = 0; i < time.length; i++) {
				if ("0".equals(time[i])) {
					cIdx++;
				}
				if (cIdx > SURV_COLORS.length - 1) {
					cIdx = 1;
				}
				
				color[i] = SURV_COLORS[cIdx];
				
			}
			nRisk = StringUtils.splitPreserveAllTokens(br.readLine(), "\t");
			nEvent = StringUtils.splitPreserveAllTokens(br.readLine(), "\t");
			nSurvival = StringUtils.splitPreserveAllTokens(br.readLine(), "\t");
			stdErr = StringUtils.splitPreserveAllTokens(br.readLine(), "\t");
			
			for(int i = 0; i < nSurvival.length; i++) {
				nSurvival[i] = CommonFunctions.round3(nSurvival[i]);
			}
			
			for(int i = 0; i < stdErr.length; i++) {
				stdErr[i] = CommonFunctions.round3(stdErr[i]);
			}
			
			survExtData.setColor(color);
			survExtData.setCTitle(cTitle);
			survExtData.setTime(time);
			survExtData.setNRisk(nRisk);
			survExtData.setNEvent(nEvent);
			survExtData.setNSurvival(nSurvival);
			survExtData.setStdErr(stdErr);
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvExtData(survExtData);
	}
	
	// surv new 02 parse dataz
	public static void parseSurvNew02RSDatzFile(OmicsDataVO searchVO) {
		List<String> survGroupList = new ArrayList<String>();

		String line;
		// 결과 파일 폴더
		//String dataFile =getWorkspacePath(vo.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = SURV_NEW_PATH_02_RS + SURV_RESULT_DATZ_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			line = br.readLine();
			searchVO.setSurvPValue(line.replace("p = ", ""));
			
			line = br.readLine();
			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					survGroupList.add(values[1]);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvGroupList(survGroupList);
	}
	
	// surv new 03 parse dataz
	public static void parseSurvNew03SGDatzFile(OmicsDataVO searchVO) {
		List<String> survGroupList = new ArrayList<String>();

		String line;
		// 결과 파일 폴더
		//String dataFile =getWorkspacePath(vo.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = SURV_NEW_PATH_03_SG + SURV_RESULT_DATZ_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			line = br.readLine();
			searchVO.setSurvPValue(line.replace("p = ", ""));
			
			line = br.readLine();
			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					survGroupList.add(values[1]);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvGroupList(survGroupList);
	}
	
	// surv new 04 parse dataz
	public static void parseSurvNew04TGDatzFile(OmicsDataVO searchVO) {
		List<String> survGroupList = new ArrayList<String>();

		String line;
		// 결과 파일 폴더
		//String dataFile =getWorkspacePath(vo.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = SURV_NEW_PATH_04_TD + SURV_RESULT_DATZ_FILE_2G;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			line = br.readLine();
			searchVO.setSurvPValue(line.replace("p = ", ""));
			
			line = br.readLine();
			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					survGroupList.add(values[1]);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvGroupList(survGroupList);
	}
	
	// surv new 05 parse dataz
	public static void parseSurvNew05UFDatzFile(OmicsDataVO searchVO) {
		List<String> survGroupList = new ArrayList<String>();

		String line;
		// 결과 파일 폴더
		//String dataFile =getWorkspacePath(vo.getUd_idx()) + "s" + searchVO.getStd_idx() + "/" + SURV_RESULT_DATZ_FILE;
		String dataFile = SURV_NEW_PATH_05_UF + SURV_RESULT_DATZ_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			line = br.readLine();
			searchVO.setSurvPValue(line.replace("p = ", ""));
			
			line = br.readLine();
			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					survGroupList.add(values[1]);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvGroupList(survGroupList);
	}
	
	private static void parseSurvDegDataFile(OmicsDataVO searchVO) {
		List<String> survSampleList = new ArrayList<String>();
		List<List<String>> survDataList = new ArrayList<List<String>>();

		String line;
		String dataFile = SURV_PATH + SURV_RESULT_DATA_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			line = br.readLine();
			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					survSampleList.add(StringUtils.replace(values[0], ".", "-"));
					
					List<String> sList = new ArrayList<String>();
					sList.add(values[1]);
					sList.add(values[2]);
					survDataList.add(sList);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvSampleList(survSampleList);
		searchVO.setSurvDataList(survDataList);
	}
	
	private static void parseSurvDegDatzFile(OmicsDataVO searchVO) {
		List<String> survGroupList = new ArrayList<String>();

		String line;
		String dataFile = SURV_PATH + SURV_RESULT_DATZ_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dataFile))) {
			line = br.readLine();
			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					survGroupList.add(values[1]);
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		searchVO.setSurvGroupList(survGroupList);
	}
	
	public static String mergeDmp(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("paste");
		xcmd.add("ID.txt");

		File file;
		String sampleFile;
		int existsCnt1 = 0;
		int existsCnt2 = 0;
		for (String s : vo.getSample1List()) {
			sampleFile = s + ".txt";
			file = new File(((vo.getUd_idx() == 2) ? DMP_MERGE_PATH2 : DMP_MERGE_PATH) + sampleFile);
			if (file.exists()) {
				existsCnt1++;
				xcmd.add(sampleFile);
			}
		}
		for (String s : vo.getSample2List()) {
			sampleFile = s + ".txt";
			file = new File(((vo.getUd_idx() == 2) ? DMP_MERGE_PATH2 : DMP_MERGE_PATH) + sampleFile);
			if (file.exists()) {
				existsCnt2++;
				xcmd.add(sampleFile);
			}
		}
		vo.setDmpSampleCnt1(existsCnt1);
		vo.setDmpSampleCnt2(existsCnt2);

		String outFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + DMP_MERGE_FILE_PRE;
		
		if (vo.getUd_idx() == 2) {
			linuxExecutePath(xcmd, DMP_MERGE_PATH2, outFile);
		} else {
			linuxExecutePath(xcmd, DMP_MERGE_PATH, outFile);
		}
		
		return outFile;
	}
	
	public static String mergePcaMeth(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("paste");
		xcmd.add("ID.txt");

		File file;
		String sampleFile;
		int existsCnt1 = 0;
		int existsCnt2 = 0;
		for (String s : vo.getSample1List()) {
			sampleFile = s + ".txt";
			
			file = new File(((vo.getUd_idx() == 2) ? PCA_METH_MERGE_PATH2 : PCA_METH_MERGE_PATH) + sampleFile);
			if (file.exists()) {
				existsCnt1++;
				xcmd.add(sampleFile);
			}
		}
		for (String s : vo.getSample2List()) {
			sampleFile = s + ".txt";
			file = new File(((vo.getUd_idx() == 2) ? PCA_METH_MERGE_PATH2 : PCA_METH_MERGE_PATH) + sampleFile);
			if (file.exists()) {
				existsCnt2++;
				xcmd.add(sampleFile);
			}
		}
		vo.setDmpSampleCnt1(existsCnt1);
		vo.setDmpSampleCnt2(existsCnt2);

		String outFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + PCA_METH_MERGE_FILE_PRE;

		if (vo.getUd_idx() == 2) {
			linuxExecutePath(xcmd, PCA_METH_MERGE_PATH2, outFile);
		} else {
			linuxExecutePath(xcmd, PCA_METH_MERGE_PATH, outFile);
		}
		
		return outFile;
	}
	
	public static void excutePcaMeth(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String pcaInputFile = dir + PCA_METH_MERGE_FILE_PRE;
		String pcaOutputFile = dir + PCA_METH_RESULT_FILE;

		xcmd.add("bash");
		xcmd.add(PCA_METH_EXCUTE_SCRIPT);
		xcmd.add(pcaInputFile);
		xcmd.add(Integer.toString(vo.getSample1List().size()));
		xcmd.add(Integer.toString(vo.getSample2List().size()));
		xcmd.add(pcaOutputFile);

		linuxExecutePath(xcmd, PCA_METH_PATH);
	}
	
	public static void parsePcaMethResult(OmicsDataVO vo) {

		List<PcaResultVO> list = new ArrayList<PcaResultVO>();

		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String pcaResultFile = dir + PCA_METH_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(pcaResultFile))) {
			line = br.readLine();
			String[] columnsID = StringUtils.split(line, "\t");
			vo.setPcaSmps(columnsID);

			PcaResultVO pcaVo = null;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					pcaVo = new PcaResultVO();
					pcaVo.setGeneSymbol(StringUtils.replace(values[0], ".", "-"));
					pcaVo.setPc1(CommonFunctions.parseDouble(values[1]));
					pcaVo.setPc2(CommonFunctions.parseDouble(values[2]));
					pcaVo.setPc3(CommonFunctions.parseDouble(values[3]));
					pcaVo.setPc4(CommonFunctions.parseDouble(values[4]));
					pcaVo.setPc5(CommonFunctions.parseDouble(values[5]));
					list.add(pcaVo);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		vo.setPcaList(list);
	}

	public static void splitExpCntSample(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("bash");
		xcmd.add("awk_split.sh");
		xcmd.add("sample2.txt");

		String exePath = ROOT_PATH+ "upload/test/";

		linuxExecutePath(xcmd, exePath);
	}

	public static void linuxExecutePath(List<String> cmm, String exePath) throws IOException, InterruptedException {
		linuxExecutePath(cmm, exePath, null);
	}

	public static void linuxExecutePath(List<String> cmm, String exePath, String outFile) throws IOException, InterruptedException {
		System.out.println("exePath : " + exePath);
		System.out.println("outFile : " + outFile);
		System.out.println(String.join(" ", cmm));

		ProcessBuilder runBuilder = null;
		Process prun = null;
		String str1 = null;

		long t1 = System.currentTimeMillis();		
		
		runBuilder = new ProcessBuilder(cmm);
		runBuilder.directory(new File(exePath));
		if (StringUtils.isNotBlank(outFile)) {
			runBuilder.redirectOutput(new File(outFile));
		}

		prun = runBuilder.start();
		prun.waitFor();
		
		BufferedReader stdOut = new BufferedReader(new InputStreamReader(prun.getInputStream()));

		while ((str1 = stdOut.readLine()) != null) {
			System.out.println(simpleDateFormat.format(new Date()) + " : " + str1);
		}
		
		long t2 = System.currentTimeMillis();
		
		
		System.out.println("t1 : " + t1);
		System.out.println("t2 : " + t2);
		System.out.println("ti : " + (t2 - t1));
	}
	
	public static void linuxExecutePath2(List<String> cmm, String exePath, String outFile) throws IOException, InterruptedException {
		System.out.println("exePath : " + exePath);
		System.out.println("outFile : " + outFile);
		System.out.println(String.join(" ", cmm));

		ProcessBuilder runBuilder = null;
		Process prun = null;
		String str1 = null;

		long t1 = System.currentTimeMillis();		
		
		runBuilder = new ProcessBuilder(cmm);
		runBuilder.directory(new File(exePath));
		if (StringUtils.isNotBlank(outFile)) {
			runBuilder.redirectOutput(new File(outFile));
		}

		prun = runBuilder.start();
		prun.waitFor();
		BufferedReader stdOut = new BufferedReader(new InputStreamReader(prun.getInputStream()));

		while ((str1 = stdOut.readLine()) != null) {
			System.out.println(simpleDateFormat.format(new Date()) + " : " + str1);
		}
		
		long t2 = System.currentTimeMillis();
		
		
		
		long t3 = System.currentTimeMillis();
		
		System.out.println("t1 : " + t1);
		System.out.println("t2 : " + t2);
		System.out.println("t3 : " + t3);
		System.out.println(t3 - t1);
	}
	
	public static JSONArray getDegEdgeRJson(OmicsDataVO searchVO) {
		JSONArray cJsonArr = new JSONArray();
		
		List<mo_expVO> tpmList = searchVO.getExpList();
		List<String> sampleList = searchVO.getSampleList();
		List<DegResultVO> degList = searchVO.getDegList();
		
		Double tpmValue = null;
		
		for(DegResultVO vo : degList) {
			JSONObject cJsonObj = new JSONObject();
			cJsonObj.put("geneSymbol", vo.getGeneSymbol());
			cJsonObj.put("logFC", vo.getLogFC());
			cJsonObj.put("logCPM", vo.getLogCPM());
			cJsonObj.put("LR", vo.getLR());
			cJsonObj.put("pValue", vo.getPValue());
			cJsonObj.put("FDR", vo.getFDR());
			
			for(String i : sampleList) {
				tpmValue = tpmList.stream()
						.filter(x -> StringUtils.equals(x.getSample_id(), i) 
								&& StringUtils.equals(x.getGene_symbol(), vo.getGeneSymbol()))
						.findAny().get().getVal();
				cJsonObj.put(StringUtils.replace(i, "-", "_"), tpmValue);
			}
			
			cJsonArr.add(cJsonObj);
		}
		
		return cJsonArr;
	}
	
	public static JSONArray getDegSeq2Json(OmicsDataVO searchVO) {
		JSONArray cJsonArr = new JSONArray();
		
		List<mo_expVO> tpmList = searchVO.getExpList();
		List<String> sampleList = searchVO.getSampleList();
		List<DegResultVO> degList = searchVO.getDegList();
		
		Double tpmValue = null;
		
		for(DegResultVO vo : degList) {
			JSONObject cJsonObj = new JSONObject();
			cJsonObj.put("geneSymbol", vo.getGeneSymbol());
			cJsonObj.put("baseMean", vo.getBaseMean());
			cJsonObj.put("log2FoldChange", vo.getLog2FoldChange());
			cJsonObj.put("lfcSE", vo.getLfcSE());
			cJsonObj.put("stat", vo.getStat());
			cJsonObj.put("pValue", vo.getPValue());
			cJsonObj.put("padj", vo.getPadj());
			
			for(String i : sampleList) {
				tpmValue = tpmList.stream()
						.filter(x -> StringUtils.equals(x.getSample_id(), i) 
								&& StringUtils.equals(x.getGene_symbol(), vo.getGeneSymbol()))
						.findAny().get().getVal();
				cJsonObj.put(StringUtils.replace(i, "-", "_"), tpmValue);
			}
			
			cJsonArr.add(cJsonObj);
		}
		
		return cJsonArr;
	}

	public static void parseDegResult(OmicsDataVO vo) {

		List<DegResultVO> list = new ArrayList<DegResultVO>();
		
		Double logFCCutOff = CommonFunctions.parseDouble(vo.getSearchLogFC());
		Double pValueCutOff = 0d;
		int idxId = 0;
		int idxLogFC = 1;
		int idxPValue = 4;
		
		int idxLogCPM = 2;
		int idxLR = 3;
		int idxFDR = 5;

		if ("P".equals(vo.getSearchPValueType())) {
			pValueCutOff = CommonFunctions.parseDoubleOrNull(vo.getSearchPValue());
		} else if ("A".equals(vo.getSearchPValueType())) {
			pValueCutOff = CommonFunctions.parseDoubleOrNull(vo.getSearchAdjPValue());
			idxPValue = 5;
		} 

		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degResultFile = dir + DEG_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(degResultFile))) {
			line = br.readLine();
			// String[] columnsID = StringUtils.split(line, "\t");

			DegResultVO resultVo = null;
			Double logFC;
			Double pValue;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					logFC = CommonFunctions.parseDoubleOrNull(values[idxLogFC]);
					pValue = CommonFunctions.parseDoubleOrNull(values[idxPValue]);
					if (logFC != null && pValue != null) {
						if (Math.abs(logFC) >= logFCCutOff 
								&& pValue <= pValueCutOff) {
							resultVo = new DegResultVO();
							resultVo.setGeneSymbol(values[idxId]);
							resultVo.setLogFC(logFC);
							resultVo.setPValue(pValue);
							
							resultVo.setLogCPM(CommonFunctions.parseDoubleOrNull(values[idxLogCPM]));
							resultVo.setLR(CommonFunctions.parseDoubleOrNull(values[idxLR]));
							resultVo.setFDR(CommonFunctions.parseDoubleOrNull(values[idxFDR]));
							list.add(resultVo);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//list.forEach(i -> System.out.println(String.format("%20s\t%13.5f\t%13.5f", i.getGeneSymbol(), i.getLogFC(), i.getPValue())));

		vo.setDegList(list);
	}
	
	public static void parseDeSeq2Result(OmicsDataVO vo) {

		List<DegResultVO> list = new ArrayList<DegResultVO>();
		
		Double logFCCutOff = CommonFunctions.parseDouble(vo.getSearchLogFC());
		Double pValueCutOff = 0d;
		int idxId = 0;
		int idxLogFC = 2;
		int idxPValue = 5;
		
		int idxBaseMean = 1;
		int idxLfcSE = 3;
		int idxStat = 4;
		int idxPadj = 6;
		
		if ("P".equals(vo.getSearchPValueType())) {
			pValueCutOff = CommonFunctions.parseDoubleOrNull(vo.getSearchPValue());
		} else if ("A".equals(vo.getSearchPValueType())) {
			pValueCutOff = CommonFunctions.parseDoubleOrNull(vo.getSearchAdjPValue());
			idxPValue = 5;
		} 

		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degResultFile = dir + DESEQ2_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(degResultFile))) {
			line = br.readLine();
			// String[] columnsID = StringUtils.split(line, "\t");

			DegResultVO resultVo = null;
			Double logFC;
			Double pValue;
			
			int i = 0;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					logFC = CommonFunctions.parseDoubleOrNull(values[idxLogFC]);
					pValue = CommonFunctions.parseDoubleOrNull(values[idxPValue]);
					if (logFC != null && pValue != null) {
						if (Math.abs(logFC) >= logFCCutOff 
								&& pValue <= pValueCutOff) {
							resultVo = new DegResultVO();
							resultVo.setGeneSymbol(values[idxId]);
							resultVo.setLogFC(logFC);
							resultVo.setPValue(pValue);
							
							resultVo.setBaseMean(CommonFunctions.parseDoubleOrNull(values[idxBaseMean]));
							resultVo.setLog2FoldChange(logFC);
							resultVo.setLfcSE(CommonFunctions.parseDoubleOrNull(values[idxLfcSE]));
							resultVo.setStat(CommonFunctions.parseDoubleOrNull(values[idxStat]));
							resultVo.setPadj(CommonFunctions.parseDoubleOrNull(values[idxPadj]));
							
							list.add(resultVo);
						}
					}
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//list.forEach(i -> System.out.println(String.format("%20s\t%13.5f\t%13.5f", i.getGeneSymbol(), i.getLogFC(), i.getPValue())));

		vo.setDegList(list);
	}
	
	public static List<DegResultVO> parseDegResultVolcano(OmicsDataVO vo) {

		List<DegResultVO> list = new ArrayList<DegResultVO>();
		
		Double logFCCutOff = CommonFunctions.parseDouble(vo.getSearchLogFC());
		Double pValueCutOff = CommonFunctions.parseDouble(vo.getSearchPValue());

		String line;
		String degResultFile = DEG_PATH + DEG_RESULT_FILE;
		
		int idxLogFC = 1;
		int idxPValue = 4;
		
		switch(vo.getDegType()) {
		case EdgeR:
			idxLogFC = 1;
			idxPValue = 4;
			degResultFile = DEG_PATH + DEG_RESULT_FILE;
			
			break;
		case DESeq2:
			idxLogFC = 2;
			idxPValue = 5;
			degResultFile = DESEQ2_PATH + DESEQ2_RESULT_FILE;
			
			break;
		}

		try (BufferedReader br = new BufferedReader(new FileReader(degResultFile))) {
			line = br.readLine();
			// String[] columnsID = StringUtils.split(line, "\t");

			DegResultVO resultVo = null;
			Double logFC;
			Double pValue;
			String group1 = "Significant";
			String group2 = "Not significant";
			
			

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					logFC = CommonFunctions.parseDoubleOrNull(values[idxLogFC]);
					pValue = CommonFunctions.parseDoubleOrNull(values[idxPValue]);
					
					//if (Math.abs(logFC) > 0.05) {
					
					resultVo = new DegResultVO();
					resultVo.setGeneSymbol(values[0]);
					resultVo.setLogFC(CommonFunctions.parseDoubleOrNull(values[idxLogFC]));
					resultVo.setLogFcAbs(
							Math.floor(
									Math.abs(
											CommonFunctions.parseDoubleOrNull(values[idxLogFC])) * 10
							) / 10
					);
					resultVo.setPValue(CommonFunctions.parseDoubleOrNull(values[idxPValue]));
					
					if (Math.abs(logFC) > logFCCutOff 
							/*&& pValue < pValueCutOff*/) {
						resultVo.setGroup(group1);
					} else {
						resultVo.setGroup(group2);
					}
					list.add(resultVo);
					
					//}
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public static void parsePcaResult(OmicsDataVO vo) {

		List<PcaResultVO> list = new ArrayList<PcaResultVO>();

		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String pcaResultFile = dir + PCA_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(pcaResultFile))) {
			line = br.readLine();
			String[] columnsID = StringUtils.split(line, "\t");
			vo.setPcaSmps(columnsID);

			PcaResultVO resultVo = null;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					resultVo = new PcaResultVO();
					resultVo.setGeneSymbol(StringUtils.replace(values[0], ".", "-"));
					resultVo.setPc1(CommonFunctions.parseDouble(values[1]));
					resultVo.setPc2(CommonFunctions.parseDouble(values[2]));
					resultVo.setPc3(CommonFunctions.parseDouble(values[3]));
					resultVo.setPc4(CommonFunctions.parseDouble(values[4]));
					resultVo.setPc5(CommonFunctions.parseDouble(values[5]));
					list.add(resultVo);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		vo.setPcaList(list);
	}
	
	public static void countDmpResult(OmicsDataVO searchVO) {

		int iStart = 0;
		int iEnd = 0;
		int jStart = 0;
		int jEnd = DMP_ADJ_PVALUE.length;
		int[][] dmpAdjPValueCount = new int[DMP_LOG2FC.length][DMP_ADJ_PVALUE.length];
		int[][] dmpPValueCount = new int[DMP_LOG2FC.length][DMP_PVALUE.length];
		List<DmpResultVO> list = searchVO.getDmpList();
		for (DmpResultVO o : list) {
			iEnd = getEndIndexLog2FC(o.getLogFC());
			jStart = getStartIndexAdjPValue(o.getAdjPValue());
			
			for (int i = iStart; i < iEnd; i++) {
				for (int j = jStart; j < jEnd; j++) {
					dmpAdjPValueCount[i][j]++;
				}
			}
			
			jStart = getStartIndexPValue(o.getPValue());
			jEnd = DMP_PVALUE.length;
			for (int i = iStart; i < iEnd; i++) {
				for (int j = jStart; j < jEnd; j++) {
					dmpPValueCount[i][j]++;
				}
			}
		}
		
		searchVO.setDmpAdjPValueCount(dmpAdjPValueCount);
		searchVO.setDmpPValueCount(dmpPValueCount);
	}
	
	public static void countDegResult(OmicsDataVO searchVO) {

		int iStart = 0;
		int iEnd = 0;
		int jStart = 0;
		int jEnd = DMP_ADJ_PVALUE.length;
		int[][] degAdjPValueCount = new int[DEG_LOG2FC.length][DEG_ADJ_PVALUE.length];
		int[][] degPValueCount = new int[DEG_LOG2FC.length][DEG_PVALUE.length];
		List<DegResultVO> list = searchVO.getDegList();
		for (DegResultVO o : list) {
			iEnd = getDegEndIndexLog2FC(o.getLogFC());
			
			if (o.getPadj() != null) {
				jStart = getDegStartIndexAdjPValue(o.getPadj());
				
				for (int i = iStart; i < iEnd; i++) {
					for (int j = jStart; j < jEnd; j++) {
						degAdjPValueCount[i][j]++;
					}
				}
			}
			
			if (o.getPValue() != null) {
				jStart = getDegStartIndexPValue(o.getPValue());
				
				for (int i = iStart; i < iEnd; i++) {
					for (int j = jStart; j < jEnd; j++) {
						degPValueCount[i][j]++;
					}
				}
			}
		}
		
		searchVO.setDegAdjPValueCount(degAdjPValueCount);
		searchVO.setDegPValueCount(degPValueCount);
	}
	
	public static void countDeSeq2Result(OmicsDataVO searchVO) {

		int iStart = 0;
		int iEnd = 0;
		int jStart = 0;
		int jEnd = DMP_ADJ_PVALUE.length;
		int[][] degAdjPValueCount = new int[DEG_LOG2FC.length][DEG_ADJ_PVALUE.length];
		int[][] degPValueCount = new int[DEG_LOG2FC.length][DEG_PVALUE.length];
		List<DegResultVO> list = searchVO.getDegList();
		for (DegResultVO o : list) {
			iEnd = getDegEndIndexLog2FC(o.getLogFC());
			
			if (o.getPadj() != null) {
				jStart = getDegStartIndexAdjPValue(o.getPadj());
				
				for (int i = iStart; i < iEnd; i++) {
					for (int j = jStart; j < jEnd; j++) {
						degAdjPValueCount[i][j]++;
					}
				}
			}
			
			if (o.getPValue() != null) {
				jStart = getDegStartIndexPValue(o.getPValue());
				
				for (int i = iStart; i < iEnd; i++) {
					for (int j = jStart; j < jEnd; j++) {
						degPValueCount[i][j]++;
					}
				}
			}
		}
		
		searchVO.setDegAdjPValueCount(degAdjPValueCount);
		searchVO.setDegPValueCount(degPValueCount);
	}
	
	public static List<DegResultVO> parseDegResultAll(OmicsDataVO vo) throws Exception {

		List<DegResultVO> list = new ArrayList<DegResultVO>();
		
		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degResultFile = dir + DEG_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(degResultFile))) {
			line = br.readLine();

			DegResultVO resultVo = null;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					resultVo = new DegResultVO();
					resultVo.setGeneSymbol(values[0]);
					resultVo.setLogFC(CommonFunctions.parseDoubleOrNull(values[1]));
					resultVo.setPValue(CommonFunctions.parseDoubleOrNull(values[4]));
					resultVo.setPadj(CommonFunctions.parseDoubleOrNull(values[5]));
					resultVo.setLogCPM(CommonFunctions.parseDoubleOrNull(values[2]));
					resultVo.setLR(CommonFunctions.parseDoubleOrNull(values[3]));
					resultVo.setFDR(CommonFunctions.parseDoubleOrNull(values[5]));
					
					list.add(resultVo);
				}
			}
		} catch (Exception e) {
			throw e;
		}

		vo.setDegList(list);
		return list;
	}
	
	public static List<DegResultVO> parseDeSeq2ResultAll(OmicsDataVO vo) throws Exception {

		List<DegResultVO> list = new ArrayList<DegResultVO>();
		
		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degResultFile = dir + DESEQ2_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(degResultFile))) {
			line = br.readLine();

			DegResultVO resultVo = null;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					resultVo = new DegResultVO();
					resultVo.setGeneSymbol(values[0]);
					resultVo.setLogFC(CommonFunctions.parseDoubleOrNull(values[2]));
					resultVo.setPValue(CommonFunctions.parseDoubleOrNull(values[5]));
					resultVo.setPadj(CommonFunctions.parseDoubleOrNull(values[6]));
					
					resultVo.setBaseMean(CommonFunctions.parseDoubleOrNull(values[1]));
					resultVo.setLfcSE(CommonFunctions.parseDoubleOrNull(values[3]));
					resultVo.setStat(CommonFunctions.parseDoubleOrNull(values[4]));
					
					list.add(resultVo);
				}
			}
		} catch (Exception e) {
			throw e;
		}

		vo.setDegList(list);
		return list;
	}
	
	private static int getEndIndexLog2FC(Double logFC) {
		int i = 0;
		Double val = Math.abs(logFC);
		for (; i < DMP_LOG2FC.length; i++) {
			if (DMP_LOG2FC[i] >= val)
				break;
		}
		return i;
	}
	
	private static int getStartIndexAdjPValue(Double adjPValue) {
		int i = 0;
		for (; i < DMP_ADJ_PVALUE.length; i++) {
			if (DMP_ADJ_PVALUE[i] >= adjPValue) 
				break;
		}
		return i;
	}
	
	private static int getStartIndexPValue(Double pValue) {
		int i = 0;
		for (; i < DMP_PVALUE.length; i++) {
			if (DMP_PVALUE[i] >= pValue) 
				break;
		}
		return i;
	}
	
	private static int getDegEndIndexLog2FC(Double logFC) {
		int i = 0;
		Double val = Math.abs(logFC);
		for (; i < DEG_LOG2FC.length; i++) {
			if (DEG_LOG2FC[i] >= val)
				break;
		}
		return i;
	}
	
	private static int getDegStartIndexAdjPValue(Double adjPValue) {
		int i = 0;
		for (; i < DEG_ADJ_PVALUE.length; i++) {
			if (DEG_ADJ_PVALUE[i] >= adjPValue) 
				break;
		}
		return i;
	}
	
	private static int getDegStartIndexPValue(Double pValue) {
		int i = 0;
		for (; i < DEG_PVALUE.length; i++) {
			if (DEG_PVALUE[i] >= pValue) 
				break;
		}
		return i;
	}
	
	// 필터 적용 미적용 처리 필요
	public static void parseDmpResult(OmicsDataVO vo) {

		List<DmpResultVO> list = new ArrayList<DmpResultVO>();
		
		Double logFCCutOff = CommonFunctions.parseDouble(vo.getSearchDmpLogFC());
		Double pValueCutOff = 0d;
		int columnId = 0;
		int columnLogFC = 1;
		int columnPValue = 4;
		
		int colChr = 10;
		int colMapInfo = 11;
		int colStrand = 12;
		
		
		if ("P".equals(vo.getSearchDmpPValueType())) {
			pValueCutOff = CommonFunctions.parseDouble(vo.getSearchDmpPValue());
		} else if ("A".equals(vo.getSearchDmpPValueType())) {
			pValueCutOff = CommonFunctions.parseDouble(vo.getSearchDmpAdjPValue());
			columnPValue = 5;
		} 

		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degResultFile = dir + DMP_RESULT_FILE;
		

		try (BufferedReader br = new BufferedReader(new FileReader(degResultFile))) {
			line = br.readLine();
			// String[] columnsID = StringUtils.split(line, "\t");

			DmpResultVO resultVo = null;
			Double logFC;
			Double pValue;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					logFC = CommonFunctions.parseDoubleOrNull(values[columnLogFC]);
					pValue = CommonFunctions.parseDoubleOrNull(values[columnPValue]);
					
					if (logFC != null && pValue != null) {
						if (Math.abs(logFC) >= logFCCutOff 
								&& pValue <= pValueCutOff) {
							resultVo = new DmpResultVO();
							resultVo.setProbe_id(values[columnId]);
							resultVo.setLogFC(logFC);
							resultVo.setAdjPValue(pValue);

							resultVo.setChr(CommonFunctions.parseIntegerOrNull(values[colChr]));
							resultVo.setMapInfo(values[colMapInfo]);
							resultVo.setStrand(values[colStrand]);
							
							list.add(resultVo);
						}
						
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		//list.forEach(i -> System.out.println(String.format("%20s\t%13.5f\t%13.5f", i.getProbe_id(), i.getLogFC(), i.getAdjPValue())));

		vo.setDmpList(list);
	}
	
	public static List<DmpResultVO> parseDmpResultAll(OmicsDataVO vo) throws Exception {

		List<DmpResultVO> list = new ArrayList<DmpResultVO>();
		
		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String dmpResultFile = dir + DMP_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dmpResultFile))) {
			line = br.readLine();

			DmpResultVO resultVo = null;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					resultVo = new DmpResultVO();
					resultVo.setProbe_id(values[0]);
					resultVo.setLogFC(CommonFunctions.parseDouble(values[1]));
					resultVo.setPValue(CommonFunctions.parseDouble(values[4]));
					resultVo.setAdjPValue(CommonFunctions.parseDouble(values[5]));
					list.add(resultVo);
				}
			}
		} catch (Exception e) {
			throw e;
		}

		vo.setDmpList(list);
		return list;
	}
	
	public static void makeGeneProbeList(OmicsDataVO vo) {
		List<String> geneProbeList = new ArrayList<String>();
		for(mo_methVO i : vo.getMethList()) {
			geneProbeList.add(i.getGene_probe());
		}
	
		vo.setGeneProbeList(geneProbeList.stream().distinct().collect(Collectors.toList()));
	}
	
	public static void makeGeneListByGeneProbe(OmicsDataVO vo) {
		List<String> geneProbeList = vo.getGeneProbeList();
		List<String> geneList = geneProbeList.stream()
				.filter(x -> x.contains("$"))
				.map(x -> x.split("[$]")[0])
				.distinct()
				.collect(Collectors.toList());
		
		vo.setGeneList(geneList);
	}
	
	private static Map<String, mo_clinicalVO> createClinicMapBySample(List<mo_clinicalVO> list) {
		Map<String, mo_clinicalVO> allMap = new HashMap<String, mo_clinicalVO>();
		for (mo_clinicalVO i : list) {
			allMap.put(i.getSample_id(), i);
		}
		return allMap;
	}
	
	private static Map<String, mo_clinicalD2VO> createClinicMapBySampleD2(List<mo_clinicalD2VO> list) {
		Map<String, mo_clinicalD2VO> allMap = new HashMap<String, mo_clinicalD2VO>();
		for (mo_clinicalD2VO i : list) {
			allMap.put(i.getSample_id(), i);
		}
		return allMap;
	}
	
	private static List<mo_clinicalVO> getSurvClinicList(List<String> sampleList, List<mo_clinicalVO> list) {
		Map<String, mo_clinicalVO> allMap = createClinicMapBySample(list);
		List<mo_clinicalVO> kmList = new ArrayList<mo_clinicalVO>();
		
		for (String i : sampleList) {
			kmList.add(allMap.get(i));
		}
		
		return kmList;
	}
	
	private static List<mo_clinicalD2VO> getSurvClinicListD2(List<String> sampleList, List<mo_clinicalD2VO> list) {
		Map<String, mo_clinicalD2VO> allMap = createClinicMapBySampleD2(list);
		List<mo_clinicalD2VO> kmList = new ArrayList<mo_clinicalD2VO>();
		
		for (String i : sampleList) {
			kmList.add(allMap.get(i));
		}
		
		return kmList;
	}
	
	public static void makeSurvClinicData(OmicsDataVO vo, List<mo_clinicalVO> list) {
		List<mo_clinicalVO> clinicList = getSurvClinicList(vo.getSampleList(), list);
		
		List<List<String>> survDataList = new ArrayList<List<String>>();
		for(mo_clinicalVO i : clinicList) {
			List<String> subList = new ArrayList<String>();
			subList.add(i.getDfs());
			subList.add(i.getRecur());
			survDataList.add(subList);
		}
		vo.setSurvDataList(survDataList);
	}
	
	public static void makeSurvClinicDataD2(OmicsDataVO vo, List<mo_clinicalD2VO> list) {
		List<mo_clinicalD2VO> clinicList = getSurvClinicListD2(vo.getSampleList(), list);
		 
		List<List<String>> survDataList = new ArrayList<List<String>>();
		for(mo_clinicalD2VO i : clinicList) {
			List<String> subList = new ArrayList<String>();
			
			double dfs = Math.round(((CommonFunctions.parseDouble(i.getDays_to_birth()) * -1) / 30.417) * 100) / 100.0;
			
			String recur = "0";
			if ("Dead".equals(i.getVital_status_x()) || !"NA".equals(i.getDays_to_death_x())) {
				recur = "1";
			}
			
			subList.add(Double.toString(dfs));
			subList.add(recur);
			survDataList.add(subList);
		}
		vo.setSurvDataList(survDataList);
	}

	public static void makeGeneListByDeg(OmicsDataVO searchVO) {
		List<String> geneList = searchVO.getDegList().stream().map(x -> x.getGeneSymbol()).collect(Collectors.toList());
		searchVO.setGeneList(geneList);
	}
	
	public static void splitUserGenes(OmicsDataVO searchVO) {
		String geneTxt = searchVO.getGenesTxt();
		List<String> list = new ArrayList<String>();
		
		String[] genes = geneTxt.split("[\\r\\n]+");
		String gene = null;
		for(String i : genes) {
			gene = StringUtils.trimToNull(i);
			if (gene != null) {
				list.add(gene);
			}
		}
		searchVO.setGeneList(list);
		searchVO.setGenesTxt(list.stream().collect(Collectors.joining("\r\n")));
	}
	public static void downToolsFile(HttpServletRequest request, HttpServletResponse response, HttpSession session, String filePath, String fileName) throws Exception {
		downloadFile(request, response, session, THIRD_WORK_PATH + filePath + File.separator + fileName, fileName);
	}
	
	public static void downloadFile(HttpServletRequest request, HttpServletResponse response, HttpSession session, String filePath, String fileName) throws Exception {
		
		String mimetype = "application/x-msdownload";

        //response.setBufferSize(fSize);    // OutOfMemeory 발생
        response.setContentType(mimetype);
        //response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fvo.getOrignlFileNm(), "utf-8") + "\"");
        setDisposition(fileName, request, response);


System.out.println("filePath : " + filePath);        
        File uFile = new File(filePath);
        int fSize = (int)uFile.length();
        
System.out.println("size : " + uFile.length());
System.out.println("exists : " + uFile.exists());
System.out.println("isFile : " + uFile.isFile());
System.out.println("getPath : " + uFile.getPath());


        
        //response.setContentLength(fSize);
//        response.setHeader("Content-Length", Long.toString(uFile.length()));

        /*
         * FileCopyUtils.copy(in, response.getOutputStream());
         * in.close();
         * response.getOutputStream().flush();
         * response.getOutputStream().close();
         */
        BufferedInputStream in = null;
        BufferedOutputStream out = null;

        try {
            in = new BufferedInputStream(new FileInputStream(uFile));
            out = new BufferedOutputStream(response.getOutputStream());

            FileCopyUtils.copy(in, out);
            out.flush();
        } catch (Exception ex) {
            System.out.println("IGNORED: " + ex.getMessage());
        } finally {
            if (in != null) {
            try {
                in.close();
            } catch (Exception ignore) {
            	System.out.println("IGNORED: " + ignore.getMessage());
            }
            }
            if (out != null) {
            try {
                out.close();
            } catch (Exception ignore) {
            	System.out.println("IGNORED: " + ignore.getMessage());
            }
            }
        }
	}
	
	/**
     * Disposition 지정하기.
     *
     * @param filename
     * @param request
     * @param response
     * @throws Exception
     */
	private static void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = getBrowser(request);
System.out.println(browser);
		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();

		} else if (browser.equals("Trident")) { // IE11 문자열 깨짐 방지
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");

		} else {
			// throw new RuntimeException("Not supported browser");
			throw new IOException("Not supported browser");
		}

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}
	
	private static String getBrowser(HttpServletRequest request) throws Exception {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        } else if (header.indexOf("Trident") > -1) {    // IE11 문자열 깨짐 방지
            return "Trident";
        }
        return "Firefox";
    }
	
	public static JSONObject createGridFieldsBySample(OmicsDataVO vo) {
		JSONObject fields = new JSONObject();

//		JSONObject stringType = new JSONObject();
//		stringType.put("type", "string");
		JSONObject numberType = new JSONObject();
		numberType.put("type", "number");

//		fields.put("geneSymbol", stringType);
//		fields.put("baseMean", numberType);
//		fields.put("log2FoldChange", numberType);
//		fields.put("lfcSE", numberType);
//		fields.put("stat", numberType);
//		fields.put("pValue", numberType);
		
		for(String i : vo.getSampleList()) {
			fields.put(StringUtils.replace(i, "-", "_"), numberType);
		}

		return fields;
	}
	
	public static JSONArray createGridColumnsBySample(OmicsDataVO vo) {
		JSONArray returnColumns = new JSONArray();
		
		
		JSONObject filterable = new JSONObject();
		filterable.put("multi", true);
		
		for(String i : vo.getSampleList()) {
			JSONObject column = new JSONObject();
			column.put("field", StringUtils.replace(i, "-", "_"));
			column.put("title", i);
			column.put("width", 150);
			//column.put("filterable", filterable);
			
			returnColumns.add(column);
		}


		return returnColumns;
	}
	
	public static void qwe(OmicsDataVO searchVO) {
		
		
		
		
	}

	public static JSONArray getDmpChAMPJson(OmicsDataVO searchVO) {
		JSONArray cJsonArr = new JSONArray();
		
		List<mo_methVO> methList = searchVO.getMethList();
		List<String> sampleList = searchVO.getSampleList();
		List<DmpResultVO> dmpList = searchVO.getDmpList();
		List<mo_infiniumVO> infiniList = searchVO.getInfiniumList();
		Map<String, mo_infiniumVO> infinMap = infiniList.stream().collect(Collectors.toMap(mo_infiniumVO::getIlmnID, x -> x));
		
		
		mo_infiniumVO infinVO = null;
		Double methValue = null;
		
		for(DmpResultVO vo : dmpList) {
			infinVO = infinMap.get(vo.getProbe_id());
			
			JSONObject cJsonObj = new JSONObject();
			cJsonObj.put("IlmnID", vo.getProbe_id());
			cJsonObj.put("Genome_Build", infinVO.getGenome_Build());
			cJsonObj.put("CHR", vo.getChr());
			cJsonObj.put("MAPINFO", vo.getMapInfo());
			cJsonObj.put("Strand", vo.getStrand());
			cJsonObj.put("UCSC_RefGene_Name", infinVO.getUCSC_RefGene_Name());
			cJsonObj.put("UCSC_RefGene_Accession", infinVO.getUCSC_RefGene_Accession());
			cJsonObj.put("UCSC_RefGene_Group", infinVO.getUCSC_RefGene_Group());
			cJsonObj.put("UCSC_CpG_Islands_Name", infinVO.getUCSC_CpG_Islands_Name());
			cJsonObj.put("Relation_to_UCSC_CpG_Island", infinVO.getRelation_to_UCSC_CpG_Island());
			cJsonObj.put("CHR_hg38", infinVO.getCHR_hg38());
			cJsonObj.put("Start_hg38", infinVO.getStart_hg38());
			cJsonObj.put("End_hg38", infinVO.getEnd_hg38());
			cJsonObj.put("Strand_hg38", infinVO.getStrand_hg38());
			
			// infinuim 진행
			
			/*
			for(String i : sampleList) {
				methValue = methList.stream()
						.filter(x -> StringUtils.equals(x.getSample_id(), i) 
								&& StringUtils.equals(x.getProbe_id(), vo.getProbe_id()))
						.findAny().get().getBeta_value();
				cJsonObj.put(StringUtils.replace(i, "-", "_"), methValue);
			}
			*/
			
			cJsonArr.add(cJsonObj);
		}
		
		return cJsonArr;
	}
	
	public static JSONObject createDmpAnnoFieldsBySample(OmicsDataVO vo) {
		JSONObject fields = new JSONObject();

		JSONObject stringType = new JSONObject();
		stringType.put("type", "string");
		JSONObject numberType = new JSONObject();
		numberType.put("type", "number");

//		fields.put("geneSymbol", stringType);
//		fields.put("baseMean", numberType);
//		fields.put("log2FoldChange", numberType);
//		fields.put("lfcSE", numberType);
//		fields.put("stat", numberType);
//		fields.put("pValue", numberType);
		
		for(String i : vo.getSampleList()) {
			fields.put(StringUtils.replace(i, "-", "_"), numberType);
		}

		return fields;
	}
	
	public static JSONArray createDmpAnnoColumnsBySample(OmicsDataVO vo) {
		JSONArray returnColumns = new JSONArray();
		
		
		JSONObject filterable = new JSONObject();
		filterable.put("multi", true);
		
		for(String i : vo.getSampleList()) {
			JSONObject column = new JSONObject();
			column.put("field", StringUtils.replace(i, "-", "_"));
			column.put("title", i);
			column.put("width", 150);
			//column.put("filterable", filterable);
			
			returnColumns.add(column);
		}


		return returnColumns;
	}
	
	public static void makeUserGeneList(OmicsDataVO searchVO) {
		List<String> userGeneList = new ArrayList<String>();
		String geneText = searchVO.getUserGeneText();
		if (StringUtils.isNotBlank(geneText)) {
			
			String[] geneArray = StringUtils.split(geneText.replaceAll("\\r|\\n", ","), ",");
			for (String i : geneArray) {
				if (StringUtils.isNotBlank(i)) {
					userGeneList.add(i.trim());
				}
			}
		}
		
		searchVO.setUserGeneList(userGeneList);
	}

	public static mo_work_presetVO toPreset_old(OmicsDataVO searchVO) {
		mo_work_presetVO vo = new mo_work_presetVO();
		vo.setWp_idx(searchVO.getWp_idx());
		vo.setWs_idx(searchVO.getWs_idx());
		vo.setUd_idx(searchVO.getUd_idx());
		vo.setMe_idx(searchVO.getMe_idx());
		
		vo.setGroup1(searchVO.getGrp1());
		vo.setGroup2(searchVO.getGrp2());
		vo.setDegType(searchVO.getDegType().name());
		vo.setDegLogFC(searchVO.getSearchLogFC());
		vo.setDegPValueType(searchVO.getSearchPValueType());
		vo.setDegPValue(searchVO.getSearchPValue());
		vo.setDegAdjPValue(searchVO.getSearchAdjPValue());

		vo.setDmpType(searchVO.getDmpType().name());
		vo.setDmpLogFC(searchVO.getSearchDmpLogFC());
		vo.setDmpPValueType(searchVO.getSearchDmpPValueType());
		vo.setDmpPValue(searchVO.getSearchDmpPValue());
		vo.setDmpAdjPValue(searchVO.getSearchDmpAdjPValue());
		
		return vo;
	}
	
	public static OmicsDataVO parseSaved_old(mo_work_presetVO pVO) {
		OmicsDataVO vo = new OmicsDataVO();

		vo.setWp_idx(pVO.getWp_idx());
		vo.setWs_idx(pVO.getWs_idx());
		vo.setUd_idx(pVO.getUd_idx());
		vo.setMe_idx(pVO.getMe_idx());
		
		vo.setGrp1(pVO.getGroup1());
		vo.setGrp2(pVO.getGroup2());

		vo.setDegType(ExpDegTools.valueOf(pVO.getDegType()));
		vo.setSearchLogFC(pVO.getDegLogFC());
		vo.setSearchPValueType(pVO.getDegPValueType());
		vo.setSearchPValue(pVO.getDegPValue());
		vo.setSearchAdjPValue(pVO.getDegAdjPValue());

		vo.setDmpType(MethDmpTools.valueOf(pVO.getDmpType()));
		vo.setSearchDmpLogFC(pVO.getDmpLogFC());
		vo.setSearchDmpPValueType(pVO.getDmpPValueType());
		vo.setSearchDmpPValue(pVO.getDmpPValue());
		vo.setSearchDmpAdjPValue(pVO.getDmpAdjPValue());
		
		// sample list
		vo.setSample1List(Arrays.asList(StringUtils.split(pVO.getGroup1(), ",")));
		vo.setSample2List(Arrays.asList(StringUtils.split(pVO.getGroup2(), ",")));

		List<String> sampleList = new ArrayList<String>();
		sampleList.addAll(vo.getSample1List());
		sampleList.addAll(vo.getSample2List());
		vo.setSampleList(sampleList);
		
		List<String> groupList = new ArrayList<String>();
		vo.getSample1List().forEach(x -> groupList.add("Group1"));
		vo.getSample2List().forEach(x -> groupList.add("Group2"));
		vo.setSampleGroupList(groupList);
		
		return vo;
	}
	
	public static mo_studyVO toStudyVO(OmicsDataVO searchVO) {
		mo_studyVO stdVO = new mo_studyVO();
		stdVO.setPs_idx(searchVO.getPs_idx());
		stdVO.setStd_idx(searchVO.getStd_idx());
		stdVO.setUd_idx(searchVO.getUd_idx());
		stdVO.setMe_idx(searchVO.getMe_idx());
		
		stdVO.setStd_title(searchVO.getStd_title());
		stdVO.setStd_status(searchVO.getStd_status());
		stdVO.setStd_type(searchVO.getGeneSetType().label());
		stdVO.setGenes(searchVO.getUserGeneText());
		//stdVO.setOmicsType(searchVO.getSurvOmicsType1());
		
		stdVO.setExpYN(searchVO.getExpYN());
		stdVO.setMethYN(searchVO.getMethYN());
		stdVO.setMutYN(searchVO.getMutYN());
		
		stdVO.setGrp1(searchVO.getGrp1());
		stdVO.setGrp2(searchVO.getGrp2());
		stdVO.setDegType(searchVO.getDegType().name());
		stdVO.setDegLogFC(searchVO.getSearchLogFC());
		stdVO.setDegPValueType(searchVO.getSearchPValueType());
		stdVO.setDegPValue(searchVO.getSearchPValue());
		stdVO.setDegAdjPValue(searchVO.getSearchAdjPValue());

		stdVO.setDmpType(searchVO.getDmpType().name());
		stdVO.setDmpLogFC(searchVO.getSearchDmpLogFC());
		stdVO.setDmpPValueType(searchVO.getSearchDmpPValueType());
		stdVO.setDmpPValue(searchVO.getSearchDmpPValue());
		stdVO.setDmpAdjPValue(searchVO.getSearchDmpAdjPValue());
		
		return stdVO;
	}
	
	public static OmicsDataVO parseSaved(mo_studyVO stdVO) {
		OmicsDataVO vo = new OmicsDataVO();

		vo.setPs_idx(stdVO.getPs_idx());
		vo.setStd_idx(stdVO.getStd_idx());
		vo.setUd_idx(stdVO.getUd_idx());
		vo.setMe_idx(stdVO.getMe_idx());
		vo.setStd_title(stdVO.getStd_title());
		vo.setStd_status(stdVO.getStd_status());
		if(StringUtils.isNotBlank(stdVO.getStd_type()))
			vo.setGeneSetType(SelectGeneSetType.valueOfLabel(stdVO.getStd_type()));
		vo.setStd_type(stdVO.getStd_type());
		vo.setUserGeneText(stdVO.getGenes());
		
		vo.setExpYN(stdVO.getExpYN());
		vo.setMethYN(stdVO.getMethYN());
		vo.setMutYN(stdVO.getMutYN());
		
		vo.setGrp1(stdVO.getGrp1());
		vo.setGrp2(stdVO.getGrp2());

		if(StringUtils.isNotBlank(stdVO.getDegType()))	
			vo.setDegType(ExpDegTools.valueOf(stdVO.getDegType()));
		vo.setSearchLogFC(stdVO.getDegLogFC());
		vo.setSearchPValueType(stdVO.getDegPValueType());
		vo.setSearchPValue(stdVO.getDegPValue());
		vo.setSearchAdjPValue(stdVO.getDegAdjPValue());

		if(StringUtils.isNotBlank(stdVO.getDmpType()))
			vo.setDmpType(MethDmpTools.valueOf(stdVO.getDmpType()));
		vo.setSearchDmpLogFC(stdVO.getDmpLogFC());
		vo.setSearchDmpPValueType(stdVO.getDmpPValueType());
		vo.setSearchDmpPValue(stdVO.getDmpPValue());
		vo.setSearchDmpAdjPValue(stdVO.getDmpAdjPValue());
		
		// sample list
		vo.setSample1List(Arrays.asList(StringUtils.split(stdVO.getGrp1(), ",")));
		vo.setSample2List(Arrays.asList(StringUtils.split(stdVO.getGrp2(), ",")));

		List<String> sampleList = new ArrayList<String>();
		sampleList.addAll(vo.getSample1List());
		sampleList.addAll(vo.getSample2List());
		vo.setSampleList(sampleList);
		
		List<String> groupList = new ArrayList<String>();
		vo.getSample1List().forEach(x -> groupList.add("Group1"));
		vo.getSample2List().forEach(x -> groupList.add("Group2"));
		vo.setSampleGroupList(groupList);
		
		return vo;
	}

	public static void makeSheetExp(OmicsDataVO omicsVO, String title, List<SurvivalAdditionalRow> additionalRows) {
		JSONArray jsonArry = new JSONArray();
			JSONObject sheet = new JSONObject();
				sheet.put("name", title);
				
				JSONArray rows = new JSONArray();
					JSONObject groupRow = new JSONObject();
						JSONArray groupCells = new JSONArray();
							JSONObject groupCell1 = new JSONObject();
								groupCell1.put("value", "");
								groupCell1.put("enable", false);
							groupCells.add(groupCell1);
							
							JSONObject groupCell2 = new JSONObject();
								groupCell2.put("value", "");
								groupCell2.put("enable", false);
							groupCells.add(groupCell2);
							
							for(String i : omicsVO.getSampleGroupList()) {
								JSONObject cell = new JSONObject();
								cell.put("value", i);
								cell.put("enable", false);
								cell.put("color", "Group1".equals(i) ? "rgb(255,0,0)" : "rgb(0,0,255)");
								groupCells.add(cell);
							}
						
						groupRow.put("cells", groupCells);
					rows.add(groupRow);
					
					JSONObject nameRow = new JSONObject();
						JSONArray nameCells = new JSONArray();
							JSONObject nameCell1 = new JSONObject();
								nameCell1.put("value", "gene_name");
								nameCell1.put("background", "rgb(25,25,255)");
								nameCell1.put("enable", false);
							nameCells.add(nameCell1);
							
							JSONObject nameCell2 = new JSONObject();
								nameCell2.put("value", "사용자 입력");
								nameCell2.put("background", "rgb(255,14,55)");
								nameCell2.put("enable", false);
							nameCells.add(nameCell2);
							
							for(String i : omicsVO.getSampleList()) {
								JSONObject cell = new JSONObject();
								cell.put("value", i);
								cell.put("enable", false);
								cell.put("background", "rgb(25,25,255)");
								nameCells.add(cell);
							}
						
						nameRow.put("cells", nameCells);
					rows.add(nameRow);
					
					//loop
					omicsVO.setType(OmicsType.Expression);
					Map<String, Map<String, Double>> map = createDataMap(omicsVO);
					
					List<String> geneList = omicsVO.getGeneList();
					List<String> sampleList = omicsVO.getSampleList();
					
					for(String gene : geneList) {
						JSONObject row = new JSONObject();
							JSONArray cells = new JSONArray();
							
								JSONObject cell1 = new JSONObject();
									cell1.put("value", gene);
									cell1.put("background", "rgb(167,214,255)");
									cell1.put("color", "rgb(0,62,117)");
									cell1.put("enable", false);
								cells.add(cell1);
								
								JSONObject cell2 = new JSONObject();
									cell2.put("value", "");
								cells.add(cell2);
								
								for(String sample : sampleList) {
									JSONObject cell = new JSONObject();
										cell.put("value", map.get(sample).get(gene));
										cell.put("format", "#,###0.000");
										cell.put("enable", false);
									cells.add(cell);
								}
							row.put("cells", cells);
															
						rows.add(row);
					}
					
					//Additional Rows
					for (SurvivalAdditionalRow additionalRow : additionalRows) {
						JSONObject row = new JSONObject();
						JSONArray cells = new JSONArray();

						JSONObject titleCell = new JSONObject();
						titleCell.put("value", additionalRow.getRowTitle());
						titleCell.put("background", "rgb(255,251,227)");
						cells.add(titleCell);
						
						JSONObject emptyCell = new JSONObject();
						emptyCell.put("value", "");
						cells.add(emptyCell);
						
						for (int i=2; i<=additionalRow.getLastColumnId(); i++) {
							//System.out.println("I: "  + i);
							JSONObject cell = new JSONObject();
							cell.put("value", "");
							for (SurvivalAdditionalRowValue additionalCell : additionalRow.getSurvivalAdditionalRowValues()) {
								if (additionalCell.getColumnId().charAt(0)-65==i) {
									cell.put("formula", additionalCell.getCellFormula());
									cell.put("value", CommonFunctions.parseIntegerOrNull(additionalCell.getCellValue()));
								}
							}
							cells.add(cell);
						}
						
						row.put("cells", cells);
						row.put("remark", "function");
						rows.add(row);
					}
					
					int tempSize = (additionalRows.size() < 30) ? tempSize = 30 - additionalRows.size() : 5;
					
					for(int i = 0; i < tempSize; i++) {
						JSONObject row = new JSONObject();
						JSONArray cells = new JSONArray();
						JSONObject emptyCell = new JSONObject();
						emptyCell.put("value", "");
						emptyCell.put("background", "rgb(255,251,227)");
						cells.add(emptyCell);
						row.put("cells", cells);
						row.put("remark", "function");
						rows.add(row);
					}
					
					sheet.put("rows", rows);
				
				JSONArray columns = new JSONArray();
				
					JSONObject column1 = new JSONObject();
						column1.put("width", 120);
					columns.add(column1);
					
					JSONObject column2 = new JSONObject();
						column2.put("width", 100);
					columns.add(column2);
					
					for(String sample : sampleList) {
						JSONObject column = new JSONObject();
						column.put("width", 100);
						columns.add(column);
					}
					
				sheet.put("columns", columns);
		
		jsonArry.add(sheet);
		
		omicsVO.setSurSheet(jsonArry);
	}
	
	public static void makeSheetMeth(OmicsDataVO omicsVO, String title, List<SurvivalAdditionalRow> additionalRows) {
		JSONArray jsonArry = new JSONArray();
			JSONObject sheet = new JSONObject();
				sheet.put("name", title);
				
				JSONArray rows = new JSONArray();
					JSONObject groupRow = new JSONObject();
						JSONArray groupCells = new JSONArray();
							JSONObject groupCell1 = new JSONObject();
								groupCell1.put("value", "");
								groupCell1.put("enable", false);
							groupCells.add(groupCell1);
							
							JSONObject groupCell2 = new JSONObject();
								groupCell2.put("value", "");
								groupCell2.put("enable", false);
							groupCells.add(groupCell2);
							
							for(String i : omicsVO.getSampleGroupList()) {
								JSONObject cell = new JSONObject();
								cell.put("value", i);
								cell.put("enable", false);
								cell.put("color", "Group1".equals(i) ? "rgb(255,0,0)" : "rgb(0,0,255)");
								groupCells.add(cell);
							}
						
						groupRow.put("cells", groupCells);
					rows.add(groupRow);
					
					JSONObject nameRow = new JSONObject();
						JSONArray nameCells = new JSONArray();
							JSONObject nameCell1 = new JSONObject();
								nameCell1.put("value", "gene_name");
								nameCell1.put("background", "rgb(25,25,255)");
								nameCell1.put("enable", false);
							nameCells.add(nameCell1);
							
							JSONObject nameCell2 = new JSONObject();
								nameCell2.put("value", "사용자 입력");
								nameCell2.put("background", "rgb(255,14,55)");
								nameCell2.put("enable", false);
							nameCells.add(nameCell2);
							
							for(String i : omicsVO.getSampleList()) {
								JSONObject cell = new JSONObject();
								cell.put("value", i);
								cell.put("enable", false);
								cell.put("background", "rgb(25,25,255)");
								nameCells.add(cell);
							}
						
						nameRow.put("cells", nameCells);
					rows.add(nameRow);
					
					//loop
					// sample // gene
					omicsVO.setType(OmicsType.Methylation);
					Map<String, Map<String, Double>> map = createDataMap(omicsVO);
					
					List<String> geneProbeList = omicsVO.getGeneProbeList();
					List<String> sampleList = omicsVO.getSampleList();
					
					for(String gene : geneProbeList) {
						JSONObject row = new JSONObject();
							JSONArray cells = new JSONArray();
							
								JSONObject cell1 = new JSONObject();
									cell1.put("value", gene);
									cell1.put("background", "rgb(167,214,255)");
									cell1.put("color", "rgb(0,62,117)");
									cell1.put("enable", false);
								cells.add(cell1);
								
								JSONObject cell2 = new JSONObject();
									cell2.put("value", "");
								cells.add(cell2);
								
								for(String sample : sampleList) {
									JSONObject cell = new JSONObject();
										cell.put("value", map.get(sample).get(gene));
										cell.put("format", "#,###0.000");
										cell.put("enable", false);
									cells.add(cell);
								}
							row.put("cells", cells);
															
						rows.add(row);
					}
					
					//Additional Rows
					for (SurvivalAdditionalRow additionalRow : additionalRows) {
						JSONObject row = new JSONObject();
						JSONArray cells = new JSONArray();

						JSONObject titleCell = new JSONObject();
						titleCell.put("value", additionalRow.getRowTitle());
						titleCell.put("background", "rgb(255,251,227)");
						cells.add(titleCell);
						
						JSONObject emptyCell = new JSONObject();
						emptyCell.put("value", "");
						cells.add(emptyCell);
						
						for (int i=2; i<=additionalRow.getLastColumnId(); i++) {
							//System.out.println("I: "  + i);
							JSONObject cell = new JSONObject();
							cell.put("value", "");
							for (SurvivalAdditionalRowValue additionalCell : additionalRow.getSurvivalAdditionalRowValues()) {
								if (additionalCell.getColumnId().charAt(0)-65==i) {
									cell.put("formula", additionalCell.getCellFormula());
									cell.put("value", CommonFunctions.parseIntegerOrNull(additionalCell.getCellValue()));
								}
							}
							cells.add(cell);
						}
						
						row.put("cells", cells);
						row.put("remark", "function");
						rows.add(row);
					}
					
					int tempSize = (additionalRows.size() < 30) ? tempSize = 30 - additionalRows.size() : 5;
					
					for(int i = 0; i < tempSize; i++) {
						JSONObject row = new JSONObject();
						JSONArray cells = new JSONArray();
						JSONObject emptyCell = new JSONObject();
						emptyCell.put("value", "");
						emptyCell.put("background", "rgb(255,251,227)");
						cells.add(emptyCell);
						row.put("cells", cells);
						row.put("remark", "function");
						rows.add(row);
					}
					
					sheet.put("rows", rows);
				
				JSONArray columns = new JSONArray();
				
					JSONObject column1 = new JSONObject();
						column1.put("width", 150);
					columns.add(column1);
					
					JSONObject column2 = new JSONObject();
						column2.put("width", 100);
					columns.add(column2);
					
					for(String sample : sampleList) {
						JSONObject column = new JSONObject();
						column.put("width", 100);
						columns.add(column);
					}
					
				sheet.put("columns", columns);
		
		jsonArry.add(sheet);
		
		omicsVO.setSurSheet(jsonArry);
	}
	
	public static void makeSheetMut(OmicsDataVO omicsVO, String title, List<SurvivalAdditionalRow> additionalRows) {
		JSONArray jsonArry = new JSONArray();
			JSONObject sheet = new JSONObject();
				sheet.put("name", title);
				
				JSONArray rows = new JSONArray();
					JSONObject groupRow = new JSONObject();
						JSONArray groupCells = new JSONArray();
							JSONObject groupCell1 = new JSONObject();
								groupCell1.put("value", "");
								groupCell1.put("enable", false);
							groupCells.add(groupCell1);
							
							JSONObject groupCell2 = new JSONObject();
								groupCell2.put("value", "");
								groupCell2.put("enable", false);
							groupCells.add(groupCell2);
							
							for(String i : omicsVO.getSampleGroupList()) {
								JSONObject cell = new JSONObject();
								cell.put("value", i);
								cell.put("enable", false);
								cell.put("color", "Group1".equals(i) ? "rgb(255,0,0)" : "rgb(0,0,255)");
								groupCells.add(cell);
							}
						
						groupRow.put("cells", groupCells);
					rows.add(groupRow);
					
					JSONObject nameRow = new JSONObject();
						JSONArray nameCells = new JSONArray();
							JSONObject nameCell1 = new JSONObject();
								nameCell1.put("value", "gene_name");
								nameCell1.put("background", "rgb(25,25,255)");
								nameCell1.put("enable", false);
							nameCells.add(nameCell1);
							
							JSONObject nameCell2 = new JSONObject();
								nameCell2.put("value", "사용자 입력");
								nameCell2.put("background", "rgb(255,14,55)");
								nameCell2.put("enable", false);
							nameCells.add(nameCell2);
							
							for(String i : omicsVO.getSampleList()) {
								JSONObject cell = new JSONObject();
								cell.put("value", i);
								cell.put("enable", false);
								cell.put("background", "rgb(25,25,255)");
								nameCells.add(cell);
							}
						
						nameRow.put("cells", nameCells);
					rows.add(nameRow);
					
					//loop
					// sample // gene
					omicsVO.setType(OmicsType.MutationSnv);
					Map<String, Map<String, String>> map = createMutDataMap(omicsVO);
					
					List<String> geneList = omicsVO.getGeneList();
					List<String> sampleList = omicsVO.getSampleList();
					
					for(String gene : geneList) {
						JSONObject row = new JSONObject();
							JSONArray cells = new JSONArray();
							
								JSONObject cell1 = new JSONObject();
									cell1.put("value", gene);
									cell1.put("background", "rgb(167,214,255)");
									cell1.put("color", "rgb(0,62,117)");
									cell1.put("enable", false);
								cells.add(cell1);
								
								JSONObject cell2 = new JSONObject();
									cell2.put("value", "");
								cells.add(cell2);
								
								for(String sample : sampleList) {
									JSONObject cell = new JSONObject();
										cell.put("value", map.get(sample).get(gene));
										//cell.put("format", "#,###0.000");
										cell.put("enable", false);
									cells.add(cell);
								}
							row.put("cells", cells);
															
						rows.add(row);
					}
					
					//Additional Rows
					for (SurvivalAdditionalRow additionalRow : additionalRows) {
						JSONObject row = new JSONObject();
						JSONArray cells = new JSONArray();

						JSONObject titleCell = new JSONObject();
						titleCell.put("value", additionalRow.getRowTitle());
						titleCell.put("background", "rgb(255,251,227)");
						cells.add(titleCell);
						
						JSONObject emptyCell = new JSONObject();
						emptyCell.put("value", "");
						cells.add(emptyCell);
						
						for (int i=2; i<=additionalRow.getLastColumnId(); i++) {
							//System.out.println("I: "  + i);
							JSONObject cell = new JSONObject();
							cell.put("value", "");
							for (SurvivalAdditionalRowValue additionalCell : additionalRow.getSurvivalAdditionalRowValues()) {
								if (additionalCell.getColumnId().charAt(0)-65==i) {
									cell.put("formula", additionalCell.getCellFormula());
									cell.put("value", CommonFunctions.parseIntegerOrNull(additionalCell.getCellValue()));
								}
							}
							cells.add(cell);
						}
						
						row.put("cells", cells);
						row.put("remark", "function");
						rows.add(row);
					}
					
					int tempSize = (additionalRows.size() < 30) ? tempSize = 30 - additionalRows.size() : 5;
					
					for(int i = 0; i < tempSize; i++) {
						JSONObject row = new JSONObject();
						JSONArray cells = new JSONArray();
						JSONObject emptyCell = new JSONObject();
						emptyCell.put("value", "");
						emptyCell.put("background", "rgb(255,251,227)");
						cells.add(emptyCell);
						row.put("cells", cells);
						row.put("remark", "function");
						rows.add(row);
					}
					
					sheet.put("rows", rows);
				
				JSONArray columns = new JSONArray();
				
					JSONObject column1 = new JSONObject();
						column1.put("width", 120);
					columns.add(column1);
					
					JSONObject column2 = new JSONObject();
						column2.put("width", 100);
					columns.add(column2);
					
					for(String sample : sampleList) {
						JSONObject column = new JSONObject();
						column.put("width", 100);
						columns.add(column);
					}
					
				sheet.put("columns", columns);
		
		jsonArry.add(sheet);
		
		omicsVO.setSurSheet(jsonArry);
	}
	
	public static void makeGridPropertiesDetail(OmicsDataVO vo) throws Exception {
		if (OmicsType.MutationSnv == vo.getType() || OmicsType.MutationIndel == vo.getType()) {
			vo.setGridFields(createMutGridFieldsDetail(vo));
			vo.setGridColumns(createGridColumnsDetail(vo));
			vo.setGridData(createMutGridDataArrayDetail(vo));
		} else {
			vo.setGridFields(createGridField(vo));
			vo.setGridColumns(createGridColumns(vo));
			vo.setGridData(createGridDataArray(vo));
		}
	}
	
	public static JSONObject createMutGridFieldsDetail(OmicsDataVO vo) {
		JSONObject fields = new JSONObject();

		JSONObject stringType = new JSONObject();
		stringType.put("type", "string");
		JSONObject numberType = new JSONObject();
		numberType.put("type", "string");

		for (String field : MUTATION_GRID_COLUMN_DETAIL_FILEDS) {
			fields.put(field, stringType);
		}
		
		for (int i = 0; i < vo.getSampleList().size(); i++) {
			fields.put(GRID_FIELD_NAME + i, numberType);
		}

		return fields;
	}

	public static JSONArray createGridColumnsDetail(OmicsDataVO vo) {
		JSONArray columns = new JSONArray();

		for (String field : MUTATION_GRID_COLUMN_DETAIL_FILEDS) {
			JSONObject geneColumn = new JSONObject();
			geneColumn.put("field", field);
			geneColumn.put("title", field);
			geneColumn.put("width", 120);
			columns.add(geneColumn);
		}

		int i = 0;
		
		JSONArray group1Columns = new JSONArray();
		for (String sample : vo.getSample1List()) {
			JSONObject item = new JSONObject();
			item.put("field", GRID_FIELD_NAME + i++);
			item.put("title", sample);
			item.put("width", 130);
			item.put("headerTemplate", "<label class=\"grp1Header\">" + sample + "</label>");
			group1Columns.add(item);
		}
		JSONObject group1 = new JSONObject();
		group1.put("title", "Group1");
		group1.put("headerTemplate", "<label class=\"grp1Header\">Group1</label>");
		group1.put("columns", group1Columns);
		columns.add(group1);
		
		JSONArray group2Columns = new JSONArray();
		for (String sample : vo.getSample2List()) {
			JSONObject item = new JSONObject();
			item.put("field", GRID_FIELD_NAME + i++);
			item.put("title", sample);
			item.put("width", 130);
			item.put("headerTemplate", "<label class=\"grp2Header\">" + sample + "</label>");
			group2Columns.add(item);
		}
		JSONObject group2 = new JSONObject();
		group2.put("title", "Group2");
		group2.put("headerTemplate", "<label class=\"grp2Header\">Group2</label>");
		group2.put("columns", group2Columns);
		columns.add(group2);

		return columns;
	}
	
	public static JSONArray createMutGridDataArrayDetail(OmicsDataVO vo) throws Exception {
		Map<String, List<mo_mutationVO>> grouped = vo.getMutList().stream().collect(Collectors.groupingBy(mo_mutationVO::getDisplayString));
		JSONArray data = new JSONArray();
		
		
		for (String displayString : grouped.keySet()) {
			Map<String, mo_mutationVO> muts = grouped.get(displayString).stream().collect(Collectors.toMap(mo_mutationVO::getSample_id, Function.identity()));
			for (mo_mutationVO mut : muts.values()) {
				JSONObject row = new JSONObject();
				row.put(GRID_GENE_NAME, mut.getHugo_symbol());
				row.put(GRID_CHR_NAME, mut.getChromosome());
				row.put(GRID_POS_NAME, mut.getStart_position());
				row.put(GRID_REF_NAME, mut.getReference_allele());
				row.put(GRID_ALT_NAME, mut.getTumor_seq_allele2());
				row.put(GRID_MUTATION_TYPE_NAME, mut.getVariant_classification());
				int i = 0;
				double count = 0;
				for (String sample : vo.getSampleList()) {
					if (mut.getSample_id().equals(sample)) {
						row.put(GRID_FIELD_NAME + i++, muts.get(sample).getDisplayString());
						count++;
					} else {
						row.put(GRID_FIELD_NAME + i++, "");
					}
				}
				row.put(GRID_VARIANT_RATE_NAME, String.format("%.2f" , count / vo.getSampleList().size()) );
				data.add(row);
			}
		}
		

		return data;
	}
	
	public static String mergeDmpFinder(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();
		xcmd.add("paste");
		xcmd.add("ID.txt");

		File file;
		String sampleFile;
		int existsCnt1 = 0;
		int existsCnt2 = 0;
		for (String s : vo.getSample1List()) {
			sampleFile = s + ".txt";
			file = new File(((vo.getUd_idx() == 2) ? DMP_FINDER_MERGE_PATH2 : DMP_FINDER_MERGE_PATH) + sampleFile);
			if (file.exists()) {
				existsCnt1++;
				xcmd.add(sampleFile);
			}
		}
		for (String s : vo.getSample2List()) {
			sampleFile = s + ".txt";
			file = new File(((vo.getUd_idx() == 2) ? DMP_FINDER_MERGE_PATH2 : DMP_FINDER_MERGE_PATH) + sampleFile);
			if (file.exists()) {
				existsCnt2++;
				xcmd.add(sampleFile);
			}
		}
		vo.setDmpSampleCnt1(existsCnt1);
		vo.setDmpSampleCnt2(existsCnt2);

		String outFile = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/" + DMP_FINDER_MERGE_FILE_PRE;
		
		if (vo.getUd_idx() == 2) {
			linuxExecutePath(xcmd, DMP_FINDER_MERGE_PATH2, outFile);
		} else {
			linuxExecutePath(xcmd, DMP_FINDER_MERGE_PATH, outFile);
		}
		
		
		return outFile;
	}
	
	public static void excuteDmpFinder(OmicsDataVO vo) throws Exception {
		List<String> xcmd = new ArrayList<String>();

		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String dmpInputFile = dir + DMP_FINDER_MERGE_FILE_PRE;
		String dmpOutputFile = dir + DMP_FINDER_RESULT_FILE;
		

		xcmd.add("bash");
		xcmd.add(DMP_FINDER_SCRIPT);
		xcmd.add(dmpInputFile);
		xcmd.add(Integer.toString(vo.getDmpSampleCnt1()));
		xcmd.add(Integer.toString(vo.getDmpSampleCnt2()));
		xcmd.add(dmpOutputFile);

		linuxExecutePath(xcmd, DMP_FINDER_PATH);
	}
	
	// 필터 적용 미적용 처리 필요
	public static void parseDmpFinderResult(OmicsDataVO vo) {

		List<DmpResultVO> list = new ArrayList<DmpResultVO>();
		
		Double logFCCutOff = CommonFunctions.parseDouble(vo.getSearchDmpLogFC());
		Double pValueCutOff = 0d;
		int columnId = 0;
		int columnLogFC = 1;
		int columnPValue = 4;
		
		int colChr = 10;
		int colMapInfo = 11;
		int colStrand = 12;
		
		
		if ("P".equals(vo.getSearchDmpPValueType())) {
			pValueCutOff = CommonFunctions.parseDouble(vo.getSearchDmpPValue());
		} else if ("A".equals(vo.getSearchDmpPValueType())) {
			pValueCutOff = CommonFunctions.parseDouble(vo.getSearchDmpAdjPValue());
			columnPValue = 5;
		} 

		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String degResultFile = dir + DMP_FINDER_RESULT_FILE;
		

		try (BufferedReader br = new BufferedReader(new FileReader(degResultFile))) {
			line = br.readLine();
			// String[] columnsID = StringUtils.split(line, "\t");

			DmpResultVO resultVo = null;
			Double logFC;
			Double pValue;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					logFC = CommonFunctions.parseDoubleOrNull(values[columnLogFC]);
					pValue = CommonFunctions.parseDoubleOrNull(values[columnPValue]);
					
					if (logFC != null && pValue != null) {
						if (Math.abs(logFC) >= logFCCutOff 
								&& pValue <= pValueCutOff) {
							resultVo = new DmpResultVO();
							resultVo.setProbe_id(values[columnId]);
							resultVo.setLogFC(logFC);
							resultVo.setAdjPValue(pValue);

							resultVo.setChr(CommonFunctions.parseIntegerOrNull(values[colChr]));
							resultVo.setMapInfo(values[colMapInfo]);
							resultVo.setStrand(values[colStrand]);
							
							list.add(resultVo);
						}
						
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		//list.forEach(i -> System.out.println(String.format("%20s\t%13.5f\t%13.5f", i.getProbe_id(), i.getLogFC(), i.getAdjPValue())));

		vo.setDmpList(list);
	}
	
	public static List<DmpResultVO> parseDmpFinderResultAll(OmicsDataVO vo) throws Exception {

		List<DmpResultVO> list = new ArrayList<DmpResultVO>();
		
		String line;
		String dir = getWorkspacePath(vo.getUd_idx()) + "s" + vo.getStd_idx() + "/";
		String dmpResultFile = dir + DMP_FINDER_RESULT_FILE;

		try (BufferedReader br = new BufferedReader(new FileReader(dmpResultFile))) {
			line = br.readLine();

			DmpResultVO resultVo = null;

			while ((line = br.readLine()) != null) {
				String[] values = StringUtils.split(line, "\t");
				if (values != null) {
					resultVo = new DmpResultVO();
					resultVo.setProbe_id(values[0]);
					resultVo.setLogFC(CommonFunctions.parseDouble(values[1]));
					//vo.setIntercept(CommonFunctions.parseDouble(values[1]));
					resultVo.setPValue(CommonFunctions.parseDouble(values[3]));
					resultVo.setAdjPValue(CommonFunctions.parseDouble(values[4]));
					list.add(resultVo);
				}
			}
		} catch (Exception e) {
			throw e;
		}

		vo.setDmpList(list);
		return list;
	}
	
	public static void countDmpFinderResult(OmicsDataVO searchVO) {

		int iStart = 0;
		int iEnd = 0;
		int jStart = 0;
		int jEnd = DMP_ADJ_PVALUE.length;
		int[][] dmpAdjPValueCount = new int[DMP_LOG2FC.length][DMP_ADJ_PVALUE.length];
		int[][] dmpPValueCount = new int[DMP_LOG2FC.length][DMP_PVALUE.length];
		List<DmpResultVO> list = searchVO.getDmpList();
		for (DmpResultVO o : list) {
			iEnd = getEndIndexLog2FC(o.getLogFC());
			jStart = getStartIndexAdjPValue(o.getAdjPValue());
			
			for (int i = iStart; i < iEnd; i++) {
				for (int j = jStart; j < jEnd; j++) {
					dmpAdjPValueCount[i][j]++;
				}
			}
			
			jStart = getStartIndexPValue(o.getPValue());
			jEnd = DMP_PVALUE.length;
			for (int i = iStart; i < iEnd; i++) {
				for (int j = jStart; j < jEnd; j++) {
					dmpPValueCount[i][j]++;
				}
			}
		}
		
		searchVO.setDmpAdjPValueCount(dmpAdjPValueCount);
		searchVO.setDmpPValueCount(dmpPValueCount);
	}

	public static String uploadToolsFile(MultipartFile inputFile, OmicsDataVO searchVO) {
		
		String dirName = searchVO.getToolsDir();
		String originFilename = "";
		
		if (inputFile != null && !inputFile.isEmpty()) {
			try {
				String dir = THIRD_WORK_PATH + dirName;
				File saveFolder = new File(EgovWebUtil.filePathBlackList(dir));

				if (!saveFolder.exists() || saveFolder.isFile()) {
					saveFolder.mkdirs();
				}

				System.out.println("inputFile.getOriginalFilename : "  + inputFile.getOriginalFilename());
				
				originFilename = Normalizer.normalize(inputFile.getOriginalFilename(), Normalizer.Form.NFC);
				System.out.println("originFilename : " + originFilename);
				
				String filePath = dir + File.separator + originFilename;

				inputFile.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
			} catch (Exception e) {
				logger.error("", e);
			}
		}
		
		searchVO.setToolsInputFile(originFilename);
		
		return originFilename;
		
	}

	public static JSONObject makeScRnaViolin(OmicsDataVO searchVO) {
		JSONObject jsonData = new JSONObject();
		//jsonData.put("rows", JSONArray.fromObject(list));
		
		jsonData.put("vars", searchVO.getUserGeneList());
		//jsonData.put("smps", searchVO.getUserGeneList());
		//jsonData.put("data", searchVO.getUserGeneList());
		jsonData.put("rows2", JSONArray.fromObject(searchVO.getUserGeneList()));
		
		return jsonData;
	}

	
	
	
}
