package com.bsite.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.bsite.vo.survival.SurvivalAdditionalRow;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/* Methylation */

@Getter
@Setter
@ToString

public class OmicsDataVO extends SampleBaseVO implements Serializable {

	public enum SelectGeneSetType {
		Single_Omics_Analysis("A"), Add_Gene_Set("G"), None("N");
		
		private static final Map<String, SelectGeneSetType> BY_LABEL = Stream.of(values()).collect(Collectors.toMap(SelectGeneSetType::label, e -> e));

		private final String label;

		SelectGeneSetType(String label) {
			this.label = label;
		}

		public String label() {
			return label;
		}

		public static SelectGeneSetType valueOfLabel(String label) {
			return BY_LABEL.get(label);
		}
	}

	public enum ExpDegTools {
		EdgeR, DESeq2
	}

	public enum MethDmpTools {
		ChAMP, DmpFinder
	}

	public enum OmicsNewType {
		Expression("exp"), Methylation("meth"), Mutation("mut");

		private static final Map<String, OmicsNewType> BY_LABEL = Stream.of(values()).collect(Collectors.toMap(OmicsNewType::label, e -> e));

		private final String label;

		OmicsNewType(String label) {
			this.label = label;
		}

		public String label() {
			return label;
		}

		public static OmicsNewType valueOfLabel(String label) {
			return BY_LABEL.get(label);
		}
	}

	private static final long serialVersionUID = -6863536758530301669L;

	// 설청 필요
	// private Double[] dmpLog2FC = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8 }; //
	// ge
	// private Double[] dmpAdjPValue = { 0.001, 0.002, 0.004, 0.008, 0.016, 0.032,
	// 0.064, 0.128}; // lt

	private String newWs = "N";
	private String newWp = "N";

	private OmicsType type = OmicsType.Expression;
	private KaplanMeierType kmType = KaplanMeierType.ClinicSingleGroup;
	private SurviveGeneType geneType = SurviveGeneType.DEG_Genes;
	private SelectGeneSetType geneSetType = SelectGeneSetType.None;
	private ExpDegTools degType = ExpDegTools.DESeq2;
	private MethDmpTools dmpType = MethDmpTools.ChAMP;

	private List<mo_expVO> expList = new ArrayList<mo_expVO>();
	private List<DegResultVO> degList = new ArrayList<DegResultVO>();
	private List<PcaResultVO> pcaList = new ArrayList<PcaResultVO>();
	// private List<PcaResultVO> pcaMethList = new ArrayList<PcaResultVO>();

	private List<mo_methVO> methList = new ArrayList<mo_methVO>();
	private List<DmpResultVO> dmpList = new ArrayList<DmpResultVO>();
	private List<String> probeList = new ArrayList<String>();
	private List<String> geneProbeList = new ArrayList<String>();
	private List<mo_infiniumVO> infiniumList = new ArrayList<mo_infiniumVO>();

	private List<mo_mutationVO> mutList = new ArrayList<mo_mutationVO>();

	private List<List<Double>> heatmapDataList = new ArrayList<List<Double>>();
	private List<List<String>> heatmapData3List = new ArrayList<List<String>>();
	private List<List<String>> heatmapData4List = new ArrayList<List<String>>();
	private List<List<Double>> pcaPlotDataList = new ArrayList<List<Double>>();
	private List<List<String>> survDataList = new ArrayList<List<String>>();

	private List<String> survSampleList = new ArrayList<String>();
	private List<String> survGroupList = new ArrayList<String>();
	
	private JSONObject multiEmJson = new JSONObject();
	private List<MultiEmRow> multiEmCorrList = new ArrayList<MultiEmRow>();
	private List<List<String>> multiEmVarList = new ArrayList<List<String>>();
	
	private JSONObject multiEmmJson = new JSONObject();
	private List<MultiEmmRow> multiEmmCorrList = new ArrayList<MultiEmmRow>();
	private List<List<String>> multiEmmMethList = new ArrayList<List<String>>();
	private List<List<String>> multiEmmVarList = new ArrayList<List<String>>();
	

	private String[] pcaSmps;

	private JSONObject gridFields;
	private JSONArray gridColumns;
	private JSONArray gridData;

	private JSONArray surSheet;
	
	private String zscoreStatus = "P"; // P 변환진행 , D 파일 생성 완료, N 사용 안함

	private String userGeneText = "";
	private List<String> userGeneList = new ArrayList<String>();
	private String cluster = "";

	private Integer ps_idx = 0;
	private Integer std_idx = 0;
	private Integer std_idx1 = 0;
	private Integer std_idx2 = 0;
	private Integer ud_idx = 1;
	private boolean isSavedStudy = false;
	private Integer cg_idx = 0;
	private String cg_type = "";
	private String cg_edit = "";
	
	private String std_title = "";
	private String Std_note = "";
	private String std_status = "W";
	private String std_type = "A";
	
	private String expYN = "Y";
	private String methYN = "Y";
	private String mutYN = "Y";

	private Integer degMin = 1;
	private Integer degMax = 1;
	private Integer ht_idx;
	private Integer ht_idx2;
	private String omicsType = "";
	private String survTool1 = "";
	private String survTool2 = "";
	private String survCutOff1 = "";
	private String survCutOff2 = "";
	private String survGroup12 = "";
	private String survSGsymbol1 = "";
	private String survSGsymbol2 = "";
	private String survSGvalue1 = "";
	private String survSGvalue2 = "";
	private String survUFsymbol1 = "";
	private String survUFsymbol2 = "";
	private String survUFvalue1 = "";
	private String survUFvalue2 = "";
	private String survOmicsType1 = "";
	private String survOmicsType2 = "";

	private String survSGcheck1 = "";
	private String survSGcheck2 = "";
	private String survPValue = "";
	private SurvExtData survExtData;

	private String publicInput = "";
	
	private String be_Chr_name = "";
	private String be_start = "";
	private String be_end = "";
	
	private String toolsDir = "";
	private String toolsInputFile = "";
	private String toolsExtractFile = "";
	private String toolsOutputFile = "";
	private String inputSamFile = "";
	private String inputSamFormat = "";
	private String outputSamFormat = "";
	private String outputSamFile = "";
	private String inputBedFile = "";
	private String inputBedFormat = "";
	private String outputBedFormat = "";
	private String outputBedFile = "";
	private String inputVcfFile = "";
	private String inputVcfFormat = "";
	private String outputVcfFormat = "";
	private String outputVcfFile = "";
	private String genomeFormat = "";
	private String genomeVersion = "";

	private String searchLogFC;
	private String searchPValue;
	private String searchAdjPValue;
	private String searchPValueType;
	private String searchDmpLogFC;
	//private String searchDmpIntercept;
	private String searchDmpPValue;
	private String searchDmpAdjPValue;
	private String searchDmpPValueType;
	private String searchTmp = "";
	private String searchStdIdx = "0";
	private String searchGene = "";
	private String searchCluster = "";

	// private Double volcanoLogFC;
	// private Double volcanoLog10PV;

	public Double getVolcanoY() {
		try {
			return -Math.log10(Double.parseDouble("P".equals(searchPValueType) ? searchPValue : searchAdjPValue));
		} catch (Exception e) {
			return 0d;
		}
	}

	public String getVolcanoYAxis() {
		return "P".equals(searchPValueType) ? "-log10PValue" : "-log10FDR";
	}

	private List<String> searchSampleList = new ArrayList<String>();

	private String searchProbeId = "cg14817997";
	private String searchGeneSymbol = "APC";

	private int searchLimit = 30;

	private int[][] degAdjPValueCount;
	private int[][] degPValueCount;
	private int[][] dmpAdjPValueCount;
	private int[][] dmpPValueCount;

	public OmicsDataVO() {

	}

	public OmicsDataVO(OmicsType type) {
		this();
		this.type = type;
	}
	
	private List<SurvivalAdditionalRow> functions = new ArrayList<SurvivalAdditionalRow>();

}
