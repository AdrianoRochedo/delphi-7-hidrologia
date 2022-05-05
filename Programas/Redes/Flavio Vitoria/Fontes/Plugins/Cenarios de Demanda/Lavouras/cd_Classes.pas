unit cd_Classes;

{
  Informacoes sobre versoes:
    - Quando houver mudanca, adicao ou remocao de dados, ajustar: ihc_getXMLVersion()
    - Para testar a versao do arquivo, utilize Lavoura.FxmlVersion

  Indices:
    - Todos os indices referentes a valores percentuais (%) possuem valoes
      inteiros entre (0 e 100). Sao eles:
      - Prob_Level
      - Sys_Efficiency
      - Sys_PumpEffic
      - Sys_AnualIR
      - NetIncome
}


interface
uses classes,
     Math,
     ComCtrls,
     Contnrs,
     Windows,
     SysUtils,
     Dialogs,
     Forms,
     Controls,
     Menus,
     IniFiles,
     ExtCtrls,
     ActnList,
     MSXML4,
     XML_Utils,
     pr_Interfaces,
     SysUtilsEx,
     ObjectListEx,
     FileUtils,
     TreeViewUtils,
     MessageManager,
     MessagesForm,
     wsFuncoesDeEscalares,
     wsConstTypes,
     wsVec,
     wsMatrix,
     BaseSpreadSheetBook,
     SpreadSheetBook,
     Debug,
     cd_ClassesBase;

type
  TYear = class;
  TCrop = class;
  TManagement = class;

  TYearZoom = class(TBase)
  private
    FYear: TYear;
    FMonth: integer;
    FIndicator: integer;
    FTitle: string;

    FSoilVolume_List : TSoilVolume_List; // Volumes do solo
    FFC_OYP_List     : TFC_OYP_List;     // Cap. de Campo e Pontos Otimos
    F5C_List         : T5C_List;         // 1. bloco de DHU

    // Para controle dos itens Criados
    //FResults: TObjectList;

    // ITreeNode interface
    function getImageIndex(): integer; override;
    function canEdit(): boolean; override;
    function getNodeText(): string; override;
    procedure setEditedText(var Text: string); override;
    procedure executeDefaultAction(); override;
    procedure getActions(Actions: TActionList); override;

    destructor Destroy(); override;

    // eventos
    procedure ShowDataEvent(Sender: TObject);

    function ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
    procedure GenerateIsaregFiles();
    procedure LoadIsaregResults();
    procedure Load_DBL(const Filename: string);
    procedure Load_DHU(const Filename: string);
    procedure Simulate();
  public
    constructor Create(Year: TYear);

    property Title : string read FTitle write FTitle;
  end;

  // Dados sobre um ano de Management
  TYear = class(TBase)
  private
    // Manejo que gerou este ano
    FManagement: TManagement;

    // Fases de irrigação
    FFases: TFases;

    // Zoom Temporal
    FZoom: TYearZoom;

    // Dados gerais e indices calculados
    FScheme     : integer;
    FYear       : integer;
    FIrrigate   : boolean;

    FRPcul      : real;
    FETa        : real;
    FYieldLoss  : real;
    FPrec       : real;
    FII_P       : real;
    FETm        : real;
    FIrrDepth   : real;

    // ITreeNode interface
    function getImageIndex(): integer; override;
    function canEdit(): boolean; override;
    function getNodeText(): string; override;
    procedure executeDefaultAction(); override;
    procedure getActions(Actions: TActionList); override;

    // Eventos
    procedure ZoomEvent(Sender: TObject);

    procedure LoadFases(Arquivo: TStrings; var PosicaoArquivo: integer);
    function ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;

    function getPropValue(const Prop: string): real;
    function getDemanda(Mes: integer): real;

    // Obtem a propriedade do Manejo nao irrigado
    // Se nao existir uma manejo nao irrogado, a funcao retornara "0"
    function getRMProp(const Prop: string): real;

    function getCLPY(): real;
    function getFPV(): real;
    function getMPV(): real;
    function getRWP(): real;
    function getRACC(): real;
    function getRPCC(): real;
    function getRC(): real;
    function getRCPY(): real;
    function getICPY(): real;
    function getNWP(): real;
    function getHorasOper(): real;
    function getRawIrrDepth(): real;
    function getRawMarginOfProfit(): real;
    function getTP(): real;
    function getTotalWaterVol(): real;
    function getLP(): real;
    function getRevenue(): real;
    function getTotalRevenue(): real;
    function getLPFR(): real;
    function getMP(): real;
    function getPP(): real;
    function getCropYield(): real;
    function getRIWP(): real;
    function getEWP(): real;
    function getIrrRainWaterProd(): real;
    function getIrrRainWaterNutProd(): real;
    function getIrrDepthProd(): real;
    function getRawIrrDepthProd(): real;
    function getFIC(): real;
    function getIrrCost(): real;
    function getTIC(): real;
    function getVIC(): real;
    function getCapRetFac(): real;
    function getEnergyCost(): real;
    function getWaterCost(): real;
    function getLaborCost(): real;
    function getIrrCropCost(): real;
    function getTICC(): real;
    function getTotalRawRevenue: real;
    function getIrrWaterProd: real;
    function getIrrWaterNutProd: real;
    function getIrrGrossDepthNutProd: real;
    function getIrrWaterProd_ID: real;
  public
    constructor Create(Irrigado: boolean; Management: TManagement);
    destructor Destroy(); override;

    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDomNode);

    // Manejo a que este ano pertence
    property Management: TManagement read FManagement;

    // Ano da Cultura
    // Lido de Arquivo
    property Year : integer read FYear write FYear;          // ok

    // Esquema de rega utilizado
    // Lido de Arquivo
    property Scheme : integer read FScheme write FScheme;    // ok

    // Evapotranspiração Real da Cultura no Ciclo (mm)
    // Lido de Arquivo
    property ETa : real read FETa write FETa;          // ok

    // Evapotranspiração Potencial da Cultura
    // Dado ligado ao clima, independendo se é ou não irrigada
    // Lido de Arquivo
    property ETm : real read FETm write FETm;          // ok

    // Quebra Estimada da Producao (%)
    // Yield Loss
    // Lido de Arquivo
    property YieldLoss {Q} : real read FYieldLoss write FYieldLoss;   // ok

    // Chuva no Ciclo da cultura (mm)
    // Lido de Arquivo
    property Precipitation {Chuva} : real read FPrec write FPrec;       // ok

    // Lamina de Irrigacao no Ciclo (mm) (CULTURAS IRRIGADAS)
    // Lido de Arquivo
    property IrrDepth {LIC} : real read FIrrDepth write FIrrDepth;      // ok

    // Intervalos de Irrigacao de Pico (dias) (CULTURAS IRRIGADAS)
    // Com um valor de pico em cada ano daquele manejo de simulação,
    // na forma de DISTRIBUIÇÃO DE PROBABILIDADE EMPÍRICA. Cada valor é
    // associado ao valor respectivo da Vazão Unitaria (V_U)
    // Lido de Arquivo
    property PeakIntervals {II_P} : real read FII_P write FII_P;   // ok

    // Obtem a demanda de um mes (mm) (CULTURAS IRRIGADAS)
    // Lido de Arquivo
    property Demanda[Mes: integer] : real read getDemanda;   // ok

    // Rendimento Potencial Local Calculado ($/ha)
    // Valor Entrado pelo Usuario
    // RPLC = Crop.RendimentoPotencialCalculado(Ano)
    property CLPY {RPLC} : real read getCLPY;                // ok

    // Rendimento Potencial da cultura nao irrigada ($/ha)
    // Valor Entrado pelo Usuario
    // RCPY = Crop.RendimentoPotDaCultura(Ano);
    property RCPY {RPCul} : real read getRCPY;               // ok

    // Rendimento Potencial da cultura Irrigada ($/ha)
    // Valor Entrado pelo Usuario
    // ICPY = Crop.RendimentoPotDaCulturaIrrigada(Ano)
    property ICPY {RPCulI} : real read getICPY;              // ok

    // Valor do Produto no Mercado ($/ha)
    // Valor Entrado pelo Usuario
    // MPV = Crop.ValorProdutoMercado(Ano)
    property MPV {VPM} : real read getMPV;                   // ok

    // Valor da Produção Agropecuária ($)
    // Valor Entrado pelo Usuario
    // FPV = Crop.ValorProducaoAgropecuaria(Ano)
    property FPV {VPA} : real read getFPV;                   // ok

    // Rendimento da cultura (kg/ha)
    // CropYield = (ICPY|RCPY) * (1 - YieldLoss)
    property CropYield {RCul} : real read getCropYield;      // ok

    // Produtividade da Chuva (Kg/m3)
    // Rain Water Productivity
    // RainProductivity = CropYield / ETa / 10
    property RainProductivity {PR_CHU} : real read getRWP;   // ok

    // Produtividade Economica da Agua  ($/m3)
    // Economical Water Productivity
    // EWP = CropYield * MPV / (Eta * 10)
    property EWP {PR_ECON_CHU} : real read getEWP;    // ok

    // Produtividade da Irrigação (kg/m3)
    // IrrRainWaterProductivity = CropYield / (Eta * 10)
    property IrrRainWaterProductivity {PR_Irr} : real read getIrrRainWaterProd;

    // Prod. Da Lâmina de Irrigação no Ciclo - Efeito da Extração (kg/m3)
    // IrrGrossDepthProd = (CropYield - RM.CropYield) / RawIrrDepth
    property IrrGrossDepthProd {PR_LIC_Irr} : real read getIrrDepthProd;

    // Efeito da Extração (Kcal/m3)
    property IrrGrossDepthNutProd: real read getIrrGrossDepthNutProd;

    // Prod. Bruta da Lâmina de Irrigação no Ciclo (kg/m3)
    // RawIrrGrossDepthProd = (CropYield - RM.Rcul) / (LIC_b * 10)
    property RawIrrGrossDepthProd {PR_LICB_Irr} : real read getRawIrrDepthProd;

    // Efeito do ETa
    // Produtividade da agua da irrigacao
    // IrrWaterProd = (CropYield - RM.CropYield) / ((ETa - RM.Eta) * 10)
    property IrrWaterProd : real read getIrrWaterProd;

    // Produtividade da agua de irricacao utilizando IrrDepth (kg/m3)
    property IrrWaterProd_IrrDepth : real read getIrrWaterProd_ID;

    // Produtividade Nutricional da Agua (Kcal/m3)
    // Nutritional Water Productivity
    // NWP = CropYield * Crop.Calorias() / (Eta * 10)
    property NWP {PR_NU_CHU} : real read getNWP;             // ok

    // Efeito do ETa [IWNP]
    // Produtividade Nutricional da agua da irrigacao
    // IrrWaterNutProd = IrrWaterProd * Crop.Calories
    property IrrWaterNutProd : real read getIrrWaterNutProd;

    // Produtividade Nutricional da Irrigação (Kcal/m3) [IRWNP]
    // IrrRainWaterNutProd = CropYield * Caloria
    property IrrRainWaterNutProd {PR_NU_IRR} : real read getIrrRainWaterNutProd;

    // Coeficiente de Conversao de Chuva
    // Rainfall Actual Conversion Coefficient
    // Nos Manejos não Irrigados Caracteriza a Distribuição e
    // efeito da Chuva no Cenário Agrícola não irrigado
    // RACC = ETa / Preciptation
    property RACC {CCC} : real read getRACC;  // ok

    // Coeficiente de Conversao de Chuva Potencial
    // Rainfall Potential Conversion Coefficient
    // Nos Manejos Não Irrigados - Caracteriza o Potencial Necessário para Cultura,
    // Distribuição e efeito da Chuva no Cenário Agrícola não irrigado.
    // Etm referente Às demandas Potenciais da cultura, no Clima da região.
    // RPCC = ETm / Preciptation
    property RPCC {CCCP} : real read getRPCC;  // ok

    // Coeficiente de Chuva para Fluxo de Vapor de Água (CC_FVA)
    // Rainfall Coefficient ...
    // Nos Manejos não irrigados caracteriza a Distribuição e efeito da Chuva
    // sobre o Consumo da cultura no Cenário Agrícola Não Irrigado.
    // RC = 1 - (RPCC - RACC);
    property RC {CC} : real read getRC;   // ok

    // Lâmina de Irrigação Bruta no Ciclo,
    // considerando Eficiência da Irrigação (m3/ha)
    // RawIrrDepth = (IrrDepth / Crop.Sys_Efficiency) * 10
    property RawIrrDepth {LIC_B} : real read getRawIrrDepth;  // ok

    // Horas de Operacao do Sistema na Safra (h)
    // Hours of System Operation
    // HoursOfOperation = RawIrrDepth / Crop.Sys_FlowRate
    property HoursOfOperation {NHT_OS} : real read getHorasOper;  // ok

    // CUSTOS DE IRRIGACAO ------------------------------------------------

    // Custo da Água ($/ha)
    // WaterCost = RawIrrDepth * Crop.WaterPrice
    property WaterCost {C_Ag} : real read getWaterCost;   // ok

    // Custo da Energia ($/ha)
    // EnergyCost =  ((0.736/270) * ((Crop.Sys_FlowRate * HoursOfOperation *
    //               Crop.Sys_PressureHead * Crop.WaterPrice) / Crop.Sys_PumpEffic))
    property EnergyCost {C_En} : real read getEnergyCost;   // ok

    // Custo de Mão de Obra ($/ha)
    // LaborCost = HoursOfOperation * Crop.Labor_Persons * Crop.Labor_CostHourly
    property LaborCost {C_MO} : real read getLaborCost;    // ok

    // Custo Fixo de Irrigação Anual ($/ha)
    // FixedIrrCost =  (Crop.Sys_IrrInstCost - Crop.Sys_IrrResVal) * CapRetFactor
    property FixedIrrCost {C_F} : real read getFIC;   // ok

    // Custo Variável de Irrigação ($/ha)
    // VariableIrrCost = EnergyCost + WaterCost + LaborCost + Crop.Sys_IrrMainCost
    property VariableIrrCost {C_V} : real read getVIC;   // ok

    // Custo da Irrigacao ($/ha)
    // IrrCost = FixedIrrCost + VariableIrrCost
    property IrrCost {CustoIrr} : real read getIrrCost;    // ok

    // Custo Total de Irrigacao ($)
    // TotalIrrCost = IrrCost * Crop.CultivatedArea
    property TotalIrrCost {CustoIrrTot} : real read getTIC;   // ok

    // Custo da Lavoura Irrigada ($/ha)
    // IrrCropCost = Crop.Cost + IrrCost
    property IrrCropCost {CustoLavIrr} : real read getIrrCropCost;   // ok

    // Custo Total da Lavoura Irrigada ($)
    // TotalIrrCropCost =  IrrCropCost * Crop.CultivatedArea
    property TotalIrrCropCost {CustoLavIrrTot} : real read getTICC;   // ok

    // FIM CUSTOS DE IRRIGACAO --------------------------------------------

    // Margem Bruta de Lucro ($/ha)
    // RawGrossMarginOfProfit = YieldLoss * MPV
    property RawGrossMarginOfProfit {MarBruta} : real read getRawMarginOfProfit;   // ok

    // Lucro Liquido ($/ha)
    // LiquidNetProfit =
    //   (R) RawGrossMarginOfProfit - Crop.Cost
    //   (I) RawGrossMarginOfProfit - (Crop.Cost + IrrCost)
    property LiquidNetProfit {LL} : real read getLP;   // ok

    // Fator de Recuperação Capital
    // Capital Return Factor
    // x = (Crop.Sys_AnualIR + 1) ^ Crop.Sys_Life
    // CapRetFactor = (Crop.Sys_AnualIR * x) / (x - 1)
    property CapRetFactor {FatRecCap} : real read getCapRetFac;   // ok

    // Renda (%)
    // NetProfit =
    //   (R) (LiquidNetProfit / Crop.Cost) * 100
    //   (I) (LiquidNetProfit / (Crop.Cost + IrrCost)) * 100
    property NetProfit {RendaLiq} : real read getRevenue;   // ok

    // Renda Bruta Total ($)
    // TotalRawGrossRevenue = RawGrossMarginOfProfit * Crop.CultivatedArea
    property TotalRawGrossRevenue {RendaBrutaTotal} : real read getTotalRawRevenue;   // ok

    // Renda Liquida Total ($)
    // Profit = LiquidNetProfit * Crop.CultivatedArea
    property Profit {RendaLiquidaTotal} : real read getTotalRevenue;   // ok

    // Volume Total de Agua (m3)
    // Gross Water Volume
    // TotalWaterVol = RawIrrDepth * Crop.CultivatedArea
    property TotalWaterVol {VolAgTot} : real read getTotalWaterVol;  // ok

    // Producao Total (kg)
    // TotalProduction = CropYield * Crop.CultivatedArea
    property TotalProduction {ProducaoTotal} : real read getTP;  // ok

    // Produtividade Limite para Obtenção de Lucro (Kg/ha)
    // LimProdForRevenue =
    //   (R)  Crop.Cost / MPV
    //   (I) (Crop.Cost + IrrCost) / MPV
    property LimProdForRevenue {PLIOL} : real read getLPFR;  // ok

    // Produtividade Marginal que Viabiliza o Sistema de Irrigação (%)
    // MarginalProductivity = (( ((FixedIrrCost / 2) + IrrCost) / (Crop.BaseYield * Crop.NetIncome * MPV) )) * 100
    property MarginalProductivity {PMVSI} : real read getMP;  // ok

    // Produtividade Viavel (kg/ha)
    // PracticableProductivity = (MarginalProductivity / 100 * Crop.BaseYield)
    property PracticableProductivity {ProdViavel} : real read getPP;  // ok
  end;

  // Dados sobre os anos de um manejo
  TYearList = class
  private
    FCrop: TCrop;
    FManagement: TManagement;
    FList: TObjectList;
    function getCount: integer;
    function getItem(i: integer): TYear;
  public
    constructor Create(Crop: TCrop);
    destructor Destroy(); override;

    procedure Add(Item: TYear);
    function NewYear(Irrigado: boolean; Management: TManagement): TYear;
    function GetYear(Ano: integer): TYear;

    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDomNode);

    function Sum      (const Prop: string): real;
    function Mean     (const Prop: string): real;
    function StdDev   (const Prop: string): real;

    property Count : integer read getCount;
    property Item[i: integer] : TYear read getItem;
  end;

  TManagement = class(TBase)
  private
    FCrop       : TCrop;
    FActive     : boolean;
    FIrrigate   : boolean;
    FLA         : TYearList;

    FManagement_File  : string;
    FRestriction_File : string;

    FReqs       : TwsDataset;
    FReqs_MI    : byte;     // mes Inicial
    FReqs_MF    : byte;     // mes Final
    FReqs_CMA   : boolean;  // o ciclo esta em um mesmo ano

    FVB_18 : real;
    FVB_SI : real;

    // Analise frequencial
    FAF_Prob : Array of real;
    FAF_Val  : Array of real;

    destructor Destroy(); override;

    // ITreeNode interface
    function getNodeText(): string; override;
    function getImageIndex(): integer; override;
    function canEdit(): boolean; override;
    procedure executeDefaultAction(); override;
    procedure getActions(Actions: TActionList); override;

    procedure MostrarIndicadoresMedios(p: TSpreadSheetBook; Row: Integer);
    procedure MostrarTotaisMedios(p: TSpreadSheetBook; Row: Integer);

    // Eventos
    procedure RemoveEvent(Sender: TObject);
    procedure AtivarEvent(Sender: TObject);
    procedure ShowGeralDataEvent(Sender: TObject);
    procedure VisGraficoDasDemandasEvent(Sender: TObject);

    function ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
    function getDesc(): string;
    function getVB(): real;
    function getUnitaryOutlet(const Prob: real): real;
    function getVBRio(): real;
  public
    constructor Create(const ManagementFile, RestrictionFile: string;
                       const Crop: TCrop);

    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDomNode);

    // Arquivos de saida
    // Verificar estes métodos para saber quais propriedades são
    // lidas de arquivo.
    procedure Load_IRR(const Name: string);
    procedure Load_FAS(const Name: string);

    // Graficos
    procedure ShowDemandGraph();

    // Planilhas
    procedure ShowGeralData();

    // Cultura a que pertence este menejo
    property Crop : TCrop read FCrop;

    // Descrição do manejo
    property Description : string  read getDesc;

    // Indica se o manejo está ativo
    // Esta indicação é feita do usuário
    property Active : boolean read FActive write FActive;

    // Indica se o manejo é irrigado
    // <<< Verificar este esquema
    property Irrigate : boolean read FIrrigate write FIrrigate;

    // Representa os anos de simulação
    property Years : TYearList read FLA;

    // Necessidades de Demanda
    property Reqs : TwsDataSet read FReqs;

    // Mes inicial da cultura
    property FirstMonth : byte read FReqs_MI;

    // Mes final da cultura
    property LastMonth : byte read FReqs_MF;

    // Retorna se o intervalo da cultura esta dentro de um mesmo ano covil
    property OneCivilYear : boolean read FReqs_CMA;

    // Arquivos
    property Management_File  : string read FManagement_File;
    property Restriction_File : string read FRestriction_File;

    // Vazao Unitaria
    // Valor calculado atraves da Tabela de freq. Lida de arquivo
    // Realiza uma interpolacao quando o valor da prob nao for disponivel
    // Retorna 0 se nao existir tabela de frequencia
    property UnitaryOutlet[const Prob: real] : real read getUnitaryOutlet;

    // Vazao da Bomba a n_horas/dia
    property BombOutlet : real read getVB;

    // Vazão Mínima Necessária no Rio, Sem Armazenamento.
    // Calcularemos a Vazão Mínima do Rio, com base nas Necessidades de Pico da
    // Cultura e na Área a Irrigar por dia
    property MinBombOutlet : real read getVBRio;
  end;

  TTipoGrafico = ({Indices Lineares Anuais}
                  tiProdChuva,
                  tiIrrRainWaterProductivity,
                  tiIrrWaterProductivity_ETA,
                  tiIrrWaterProductivity_ID,
                  tiRendPotCultNI,
                  tiRendPotCultI,
                  tiRendSimCult,
                  tiCoefConvReal,
                  tiCoefConvPot,
                  tiCoefChuvas,
                  tiQ,
                  tiChuva,
                  tiLIC,
                  tiHorasOper,
                  tiMargemBruta,
                  tiVolTotAgua,
                  tiProdTotal,
                  tiCropYield,
                  tiNWP,
                  tiEWP,
                  tiWaterCost,
                  tiEnergyCost,
                  tiLiquidProfit,
                  tiRevenue,
                  tiTotalRawRevenue,
                  tiMarginalProductivity,
                  tiPracticableProductivity,

                  {Indices estatisticos}
                  ti_STD_NetReturn,
                  ti_Med_PLIOL,
                  ti_Med_LL
                  );

  TManagementList = class
  private
    FCrop: TCrop;
    FList: TObjectList;
    function getCount: Integer;
    function getItem(i: integer): TManagement;
  public
    constructor Create(Crop: TCrop);
    destructor Destroy(); override;

    procedure Add(Management: TManagement);
    procedure Remove(Management: TManagement);
    procedure Activate(Management: TManagement);

    procedure Clear();

    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDOMNode);

    // Visualizacao de resultados
    procedure Plot(Tipo: TTipoGrafico);

    // Se nao existe resultado ativado entao retorna o primeiro
    function Active(): TManagement;

    property Count: Integer read getCount;
    property Item[i: integer] : TManagement read getItem;
  end;

  TCrop = class(TBase, ICenarioDemanda, IMessageReceptor)
  private
    // Mensagens de aviso ou de erros
    FMessages    : TfoMessages;
    FErrorsCount : integer;

    FName        : string;
    FModified    : boolean;
    FxmlVersion  : integer;

    // Janelas criadas por esta instância
    FForms: TObjectListEx;

    // Quando diferente de nil indica que o gerenciador esta ativo
    FTree: TTreeView;

    // Nodes - Somente ativos enquanto o gerenciador visual estiver ativo
    FManNode: TTreeNode;

    // Diretorios
    FWorkDir : ShortString;
    FExeDir  : ShortString;

    // Arquivos
    FCul : string;
    FSol : string;
    FPre : string;
    FEto : string;
    FAsc : string;
    FMan : string;
    FRes : string;

    // Geral
    FInterval  : string;  // 1987 ou 2000-2003
    FFirstYear : integer;
    FLastYear  : integer;

    // Localização
    FLat : Integer;
    FLon : Integer;
    FAlt : Integer;
    FAn  : Integer;

    // Tempo e Clima
    FSemChuva : Boolean;
    FComChuva : Boolean;
    FSeco     : Boolean;
    FMedio    : Boolean;
    FUmido    : Boolean;

    // Conteúdo Nutricional dos Alimentos
    FAlimento : integer;

    // Tecnologia de Irrigacao
    FTipoSistema : integer;
    FNatureza    : boolean;
    FProdMax     : boolean;
    FComDeficit  : boolean;

    // Projeto
    FNivelProb       : real;
    FArea            : real;
    FDiasDeIntervalo : integer;
    FHorasOper       : integer;

    // Tabelas anuais

    FRendPotCultNI : TRendimentosAnuais; // Nao irrigada
    FRendPotCultI  : TRendimentosAnuais; // Irrigada
    FVPM           : TRendimentosAnuais;
    FVPA           : TRendimentosAnuais;
    FRPLC          : TRendimentosAnuais;

    // Estimativas Economicas da Cultura
    FVariableCost : real;
    FFixedCost    : real;
    Fc_BY         : real;
    Fc_PP         : real;
    Fc_NI         : real;
    Fc_CA         : real;

    // Estimativas Economicas do Sistema
    Fs_ICost : real;
    Fs_MCost : real;
    Fs_PH    : real;
    Fs_RV    : real;
    Fs_PE    : real;
    Fs_Life  : real;
    Fs_FR    : real;
    Fs_IR    : real;
    Fs_Effic : real; // Eficiencia do Sistema de Irrigacao

    // Outras Estimativas Economicas
    Fs_WP   : real;
    Fo_L_PN : real;
    Fo_EP   : real;
    Fo_L_CH : real;

    // Manejos simulados
    FManagements : TManagementList;

    function ReceiveMessage(const MSG: TadvMessage): Boolean;

    // ITreeNode interface
    function getNodeText(): string; override;
    function getImageIndex(): integer; override;
    function canEdit(): boolean; override;
    procedure executeDefaultAction(); override;
    procedure setEditedText(var Text: string); override;
    procedure getActions(Actions: TActionList); override;

    // eventos chamados externamente
    procedure AcaoNaoImplementada(Sender: TObject);

    procedure NewManagementEvent(Sender: TObject);
    procedure ShowDataDialogEvent(Sender: TObject);
    procedure SimulateEE_Event(Sender: TObject);
    procedure Plan_IM_Event(Sender: TObject);
    procedure Plan_Totais_Event(Sender: TObject);
    procedure Plan_AS_Event(Sender: TObject);

    procedure MenuShowVisualManager(Sender: TObject);
    procedure MenuRemoverManejos(Sender: TObject);
    procedure MenuRemoverRes(Sender: TObject);
    procedure MenuPlotarProdChuva(Sender: TObject);
    procedure MenuPlotarIrrRainWaterProductivity(Sender: TObject);
    procedure MenuPlotarIWP_ETA(Sender: TObject);
    procedure MenuPlotarIWP_ID(Sender: TObject);
    procedure MenuPlotarRendPotCultNI(Sender: TObject);
    procedure MenuPlotarRendPotCultI(Sender: TObject);
    procedure MenuPlotarCoefConvReal(Sender: TObject);
    procedure MenuPlotarCoefConvPot(Sender: TObject);
    procedure MenuPlotarCoefChuvas(Sender: TObject);
    procedure MenuPlotarQPI(Sender: TObject);
    procedure MenuPlotarCCC(Sender: TObject);
    procedure MenuPlotarLIC(Sender: TObject);
    procedure MenuPlotarRScul(Sender: TObject);
    procedure MenuPlotarMarBruta(Sender: TObject);
    procedure MenuPlotarVTA(Sender: TObject);
    procedure MenuPlotarProdTot(Sender: TObject);
    procedure MenuPlotarPLIOL_Medio(Sender: TObject);
    procedure MenuPlotarLL_Medio(Sender: TObject);
    procedure MenuPlotarNWP(Sender: TObject);
    procedure MenuPlotarEWP(Sender: TObject);
    procedure MenuPlotarEC(Sender: TObject);
    procedure MenuPlotarWC(Sender: TObject);
    procedure MenuPlotarMP(Sender: TObject);
    procedure MenuPlotarPP(Sender: TObject);
    procedure MenuPlotarTRR(Sender: TObject);
    procedure MenuPlotarRev(Sender: TObject);
    procedure MenuPlotarLP(Sender: TObject);
    procedure MenuPlotarSTDNR(Sender: TObject);

    // Separa os anos em ano Inicial e Final
    procedure ProcessInterval();

    // Obtem a lista de anos. Ex: 1990|1991|1992...
    function  getYearsAsString(): string;

    function  YieldToString(const r: TRendimentosAnuais): string;
    procedure StringToYield(const s: string; var r: TRendimentosAnuais; const Years: TIntArray);
    function  getVecValue(const vetor: TRendimentosAnuais; ano: Integer): real;

    // Copia e obtem o nome curto do arquivo
    function getFile(const Name: string; DelExt: boolean = true): string;

    procedure showException(const Error: string);
    procedure GenerateIsaregFiles();
    procedure LoadIsaregResults();

    function getTCC(): real;
    function getCC(): real;
  protected
     // IInterface
    function ToString(): wideString;
    procedure Release();

    // IPropagar
    procedure ipr_setExePath(const ExePath: string);
    procedure ipr_setObjectName(const Name: string);
    procedure ipr_setProjectPath(const ProjectPath: string);

    // IHidroComponente
    function  ihc_TemErros(): boolean;
    procedure ihc_ObterErros(var Erros: TStrings);
    procedure ihc_ObterAcoesDeMenu(Acoes: TActionList);
    procedure ihc_Simular();
    procedure ihc_toXML(Buffer: TStrings; Ident: integer);
    procedure ihc_fromXML(no: IXMLDOMNode);
    function  ihc_getXMLVersion(): integer;

    // ICenarioDeDemanda
    function icd_ObterValoresUnitarios(): TObject;
    function icd_ObterValorFloat(const Propriedade: string): real;
    function icd_ObterValorString(const Propriedade: string): string;
 public
    constructor Create();
    destructor Destroy(); override;

    procedure AddResult(Result: TObject);

    procedure Edit();
    procedure ShowVisualManager();
    procedure ShowInTree(Tree: TTreeView);
    function  TestIsaregDir(): boolean;
    procedure Simulate();

    procedure PorDadosNoDialogo(d: TForm);
    procedure PegarDadosDoDialogo(d: TForm);

    // Gerenciamento de mensagens
    procedure AddError(const aMessage: string);
    procedure AddWarning(const aMessage: string);
    procedure ClearMessages();

    // Planilhas
    procedure MostrarIndicadoresMedios();
    procedure MostrarAnaliseDeSensibilidade();
    procedure MostrarTotaisMedios();

    // TABELAS

    // Retorna os valores anuais entrados pelo usuário
    function RendimentoPotencialCalculado    (ano: Integer): real; // (Kg/ha)
    function RendimentoPotDaCultura          (ano: Integer): real; // (Kg/ha)
    function RendimentoPotDaCulturaIrrigada  (ano: Integer): real; // (Kg/ha)
    function ValorProdutoMercado             (ano: Integer): real; // ($/Kg)
    function ValorProducaoAgropecuaria       (ano: Integer): real; // ($)

    // ALIMENTOS

    // Retornas as informações nutricionais do alimento selecionado por kilo
    function Calorias  (): integer;
    function Proteinas (): integer;
    function Gorduras  (): integer;
    function Calcio    (): real;

    // SISTEMA

    // Retorna a eficiencia do sistema dependendo do
    // sistema de irrigação empregado (usuário)
    function EficienciaMinimaDoSistema(): real;
    function EficienciaMaximaDoSistema(): real;

    // Retorna o custo de produção em dolares dependento do
    // sistema de irrigação empregado (usuário)
    function CustoMinimoDeInstalacaoPorHectar(): integer;
    function CustoMaximoDeInstalacaoPorHectar(): integer;
    function CustoMinimoDeManutencaoPorHectar(): integer;
    function CustoMaximoDeManutencaoPorHectar(): integer;

    // PROPRIEDADES -------------------------------------------------------

    // Nome dados ao objeto no Propagar
    property Name : string read FName;

    // Diretorios
    property WorkDir : ShortString read FWorkDir write FWorkDir;
    property ExeDir  : ShortString read FExeDir;

    // Verifica a existencia de erros
    property HasErrors : Boolean read ihc_TemErros;

    // Arquivos
    property Cul_File : string read FCul;
    property Sol_File : string read FSol;
    property Pre_File : string read FPre;
    property ETo_File : string read FETo;
    property Asc_File : string read FAsc;

    // DADOS GERAIS - CENÁRIO AGRÍCOLA -------------------------------------

    // Número de Horas Diárias de Operação (h)
    // Valor entrado
    property OperationHoursPerDay {NHD_OP} : integer
        read FHorasOper
       write FHorasOper;  // ok

    // Nível de Probabilidade a adotar no Cálculo da Vazão de Projeto (%)
    // Indicará o valor de % associado à Vazão Unitária que será então
    // selecionada para os cálculos de Vazão do Sistema que atende às
    // necessidades de Pico com  X % de probabilidade.
    // Valor entrado
    property Prob_Level {NP_P} : real read FNivelProb write FNivelProb;  // ok

    // Área a Irrigar por dia (ha/dia)
    // Utilizada no Cálculo da Vazão do Projeto
    // Valor entrado
    property IrrigatedArea_perDay {AID_P } : real read FArea write FArea;  // ok

    // Intervalo de Irrigação de Projeto ( Dias)
    // Utilizado no Cálculo da Vazão do Projeto
    // Valor entrado
    property IrrigationFrequency {II_P} : integer   // Ok
        read FDiasDeIntervalo
       write FDiasDeIntervalo;

    // ESTIMATIVAS ECONOMICAS - CULTURA ------------------------------------

    // Produtividade Base (kg/ha)
    property BaseYield {c_PB}: real read Fc_BY write Fc_BY;         // ok

    // Area Cultivada - Cultivated Area (ha)
    property CultivatedArea {c_AC} : real read Fc_CA write Fc_CA;        // ok

    // Lucratividade - Net Incoming (%)
    property NetIncome {c_L} : real read Fc_NI write Fc_NI;     // ok

    // Custo Fixo da Lavoura - Fixed Crop Cost ($/ha)
    property FixedCost {CustoFixLav } : real read FFixedCost write FFixedCost;      // ok

    // Custo Variavel da Lavoura - Variable Crop Cost ($/ha)
    property VariableCost {CustoVarLav } : real read FVariableCost write FVariableCost;    // ok

    // Custo da Lavoura - Crop Cost ($/ha)
    // CropCost = FixedCost + VariableCost
    property Cost {CustoLav} : real read getCC;   // ok

    // Custo Total da Lavoura ($)
    // TotalCost = CropCost * CultivatedArea
    property TotalCost {CustoLavTot} : real read getTCC;   // ok

    // ESTIMATIVAS ECONOMICAS - SISTEMA ------------------------------------

    // Vazao - Flow Rate (m3/s)
    property Sys_FlowRate {s_V} : real read Fs_FR write Fs_FR;         // ok

    // Altura Manometrica - Pressure Height (mca)
    property Sys_PressureHead {s_AM} : real read Fs_PH write Fs_PH;  // ok

    // Eficiencia do Sistema de Irrigacao (%)
    // Valor entrado com base nos valores minimos e maximos indicados
    // na escolha do sistema de irrigacao
    property Sys_Efficiency {EfiSistIrr} : real read Fs_Effic write Fs_Effic;  // ok

    // Rendimento -  Pumping Efficiency (%)
    property Sys_PumpEffic {s_R} : real read Fs_PE write Fs_PE;         // ok

    // Vida util (anos)
    property Sys_Life {s_VU} : real read Fs_Life write Fs_Life;      // ok

    // Custo de Instalação do Equipamento de Irrigacao ($/ha)
    property Sys_IrrInstCost {s_I} : real read Fs_ICost write Fs_ICost;      // ok

    // Custo de Manutencao do Equipamento de Irrigacao ($/ha)
    property Sys_IrrMainCost {s_M} : real read Fs_MCost write Fs_MCost;      // ok

    // Valor Residual - Residual Value ($/ha)
    property Sys_IrrResVal {s_VR} : real read Fs_RV write Fs_RV;        // ok

    // Taxa de Juros Anual - Interest Rate (%)
    property Sys_AnualIR {o_TJA} : real read Fs_IR write Fs_IR;       // ok

    // ESTIMATIVAS ECONOMICAS - OUTRAS ------------------------------------

    // Preco da Agua ($/m3)
    property WaterPrice {o_PA} : real read Fs_WP write Fs_WP;        // ok

    // Preco da Energya ($/kwh)
    property EnergyPrice {o_PE} : real read Fo_EP write Fo_EP;        // ok

    // Mao de Obra (Labor) - Numero de Pessoas - Persons (pessoas/ha)
    property Labor_Persons {o_MO_NP} : real read Fo_L_PN write Fo_L_PN;         // ok

    // Mao de Obra (Labor) - Custo por hora - Cost Hourly ($/h/pessoa)
    property Labor_CostHourly {o_MO_C} : real read Fo_L_CH write Fo_L_CH;          // ok

    // Lista dos Manejos
    property Managements : TManagementList read FManagements;
  end;

  // Sistema de Irrigação
  procedure SistemasDeIrrigacao(SL: TStrings);
  function EficienciaMinimaDoSistema (TipoSistema: integer): real;
  function EficienciaMaximaDoSistema (TipoSistema: integer): real;
  function CustoMinimoDeInstalacaoPorHectar(TipoSistema: integer): integer;
  function CustoMaximoDeInstalacaoPorHectar(TipoSistema: integer): integer;
  function CustoMinimoDeManutencaoPorHectar(TipoSistema: integer): integer;
  function CustoMaximoDeManutencaoPorHectar(TipoSistema: integer): integer;

  // Conteúdo Nutricional
  procedure AlimentosToStrings (SL: TStrings);
  function Calorias  (TipoAlimento: integer): integer;
  function Proteinas (TipoAlimento: integer): integer;
  function Gorduras  (TipoAlimento: integer): integer;
  function Calcio    (TipoAlimento: integer): real;

implementation
uses WinUtils,
     cd_Form_Arvore,
     cd_MolduraDosDados,
     cd_Form_DadosGerais,
     cd_Form_EstimativasEconomicas,
     cd_Form_AnaliseDeSensibilidade,
     cd_GR_Demandas,
     cd_GR_Indices,
     cd_GR_IndicesMedios,
     cd_Form_Selecionar_Man_Res;

const
  cInfoNutri = 24;

  cAlimentos: array[0..cInfoNutri] of string = ('Abacaxi',                      // 0
                                                'Amendoim',                     // 1
                                                'Arroz',                        // 2
                                                'Banana',                       // 3
                                                'Batata',                       // 4
                                                'Cana de Açucar',               // 5
                                                'Carne Bovina',                 // 6
                                                'Carne Frango',                 // 7
                                                'Carne Suína',                  // 8
                                                'Cebola',                       // 9
                                                'Feijão',                       // 10
                                                'Laranja',                      // 11
                                                'Leite',                        // 12
                                                'Limão',                        // 13
                                                'Maça',                         // 14
                                                'Manteiga',                     // 15
                                                'Milho',                        // 16
                                                'Óleo de Soja',                 // 17
                                                'Óleo de Semente de Algodão',   // 18
                                                'Ovos',                         // 19
                                                'Tâmara',                       // 20
                                                'Tomate',                       // 21
                                                'Toranja',                      // 22
                                                'Trigo',                        // 23
                                                'Uva');                         // 24


  cCalorias: array[0..cInfoNutri] of integer = ( 471, 6067, 2800,  216,  591, 3548, 1376, 1354,
                                                1879,  331, 3397,  250,  521,  173,  441, 7280,
                                                2738, 8337, 8320, 1402, 1213,  184,  158, 2641, 617);

  cProteinas: array[0..cInfoNutri] of integer = ( 0, 283, 69, 6, 16, 0, 135, 135, 97, 12, 218, 5,
                                                 32, 0, 2, 13, 55, 0, 0, 110, 0, 8, 0, 86, 6);

  cGorduras: array[0..cInfoNutri] of integer = (0, 526, 7, 0, 1, 0, 89, 86, 162, 0, 12, 0, 30, 0,
                                                2, 816, 12, 939, 936, 98, 0, 1, 0, 10, 0);

  cCalcio: array[0..cInfoNutri] of real = (0.07 , 0.753, 0.186, 0.014, 0.057, 0.808, 0.039, 0.059, 0.033,
                                           0.245, 1.353, 0.21 , 0.974, 0.145, 0.054, 0.191, 0.044, 0.007,
                                           0.000, 0.448, 0.144, 0.026, 0.058, 0.324, 0.092);



// rotinas gerais

procedure AlimentosToStrings(SL: TStrings);
var i: integer;
begin
  SL.Clear();
  for i := 0 to cInfoNutri do
    SL.Add(cAlimentos[i]);
end;

function Calorias(TipoAlimento: integer): integer;
begin
  if TipoAlimento > -1 then
     Result := cCalorias[TipoAlimento]
  else
     Result := 0;
end;

function Proteinas(TipoAlimento: integer): integer;
begin
  if TipoAlimento > -1 then
     Result := cProteinas[TipoAlimento]
  else
     Result := 0;
end;

function Gorduras(TipoAlimento: integer): integer;
begin
  if TipoAlimento > -1 then
     Result := cGorduras[TipoAlimento]
  else
     Result := 0;
end;

function Calcio(TipoAlimento: integer): real;
begin
  if TipoAlimento > -1 then
     Result := cCalcio[TipoAlimento]
  else
     Result := 0;
end;

procedure SistemasDeIrrigacao(SL: TStrings);
begin
  SL.Clear();
  {0} SL.Add('Sulco Gravidade Nivelamento Precisão');
  {1} SL.Add('Faixa Gravidade Nivelamento Precisão');
  {2} SL.Add('Canteiro Gravidade Nivelamento Precisão');
  {3} SL.Add('Sulco Gravidade Tradicional');
  {4} SL.Add('Faixa Gravidade Tradicional');
  {5} SL.Add('Canteiro Gravidade Tradicional');
  {6} SL.Add('Arroz Canteiro Alaga Permanente');
  {7} SL.Add('Aspersão Estacionário Cobertura Total');
  {8} SL.Add('Aspersão Estacionário Laterais Móveis');
  {9} SL.Add('Aspersão Canhão com Enrolador ou Cabo');
  {10} SL.Add('Lateral com Rodas');
  {11} SL.Add('Pivot Central');
  {12} SL.Add('Localizada Gotejadores >= 3 Emissores/Planta');
  {13} SL.Add('Localizada Gotejadores < 3 Emissores/Planta');
  {14} SL.Add('Localizada Micro-Aspersores e "Bubblers"');
  {15} SL.Add('Localizada Linha Contínua Emissor gota-gota');
end;

function EficienciaMinimaDoSistema (TipoSistema: integer): real;
begin
  case TipoSistema of
    0 : result := 0.65;
    1 : result := 0.70;
    2 : result := 0.70;
    3 : result := 0.40;
    4 : result := 0.45;
    5 : result := 0.45;
    6 : result := 0.25;
    7 : result := 0.65;
    8 : result := 0.65;
    9 : result := 0.55;
    10: result := 0.65;
    11: result := 0.65;
    12: result := 0.85;
    13: result := 0.80;
    14: result := 0.85;
    15: result := 0.70;
    else
       result := 0.0;
  end;
end;

function EficienciaMaximaDoSistema (TipoSistema: integer): real;
begin
  case TipoSistema of
    0 : result := 0.85;
    1 : result := 0.85;
    2 : result := 0.90;
    3 : result := 0.70;
    4 : result := 0.70;
    5 : result := 0.70;
    6 : result := 0.70;
    7 : result := 0.85;
    8 : result := 0.80;
    9 : result := 0.70;
    10: result := 0.80;
    11: result := 0.85;
    12: result := 0.95;
    13: result := 0.90;
    14: result := 0.95;
    15: result := 0.90;
    else
       result := 0.0;
  end;
end;

function CustoMinimoDeManutencaoPorHectar(TipoSistema: integer): integer;
begin
  case TipoSistema of
    00..06: result := 200;
    07..11: result := 300;
    12..15: result := 450;
    else
       result := 0;
  end;
end;

function CustoMaximoDeManutencaoPorHectar(TipoSistema: integer): integer;
begin
  case TipoSistema of
    00..06: result := 250;
    07..11: result := 400;
    12..15: result := 550;
    else
       result := 0;
  end;
end;

function CustoMinimoDeInstalacaoPorHectar(TipoSistema: integer): integer;
begin
  case TipoSistema of
    00..06: result := 4000;
    07..11: result := 6000;
    12..15: result := 9000;
    else
       result := 0;
  end;
end;

function CustoMaximoDeInstalacaoPorHectar(TipoSistema: integer): integer;
begin
  case TipoSistema of
    00..06: result := 5000;
    07..11: result := 8000;
    12..15: result := 11000;
    else
       result := 0;
  end;
end;

{ TManagement }

constructor TManagement.Create(const ManagementFile, RestrictionFile: string;
                               const Crop: TCrop);
begin
  inherited Create();
  FCrop := Crop;
  FManagement_File := ManagementFile;
  FRestriction_File := RestrictionFile;
  FLA := TYearList.Create(FCrop);
  FLA.FManagement := self;
end;

destructor TManagement.Destroy();
begin
  DeleteTreeNode();
  FLA.Free();
  inherited;
end;

function TManagement.getDesc(): string;
begin
  Result := FManagement_File;

  if FRestriction_File <> '' then
     Result := Result + ' x ' + FRestriction_File;

  if not FIrrigate then
     Result := Result + ' (Rainfed)';
end;

procedure TManagement.Load_IRR(const Name: string);
var SL: TStrings;

   procedure LerNecessidadesDeRega(L: integer);

      // Funcionará se os valores estiverem no intervalo de no máximo 12 meses.
      // Ex. Dados de:  NOV .. APR   ,(JAN   FEB   MAR   APR) estão no outro ano
      // Ex. Dados de:  NOV .. NOV   ,(JAN .. NOV) estão no outro ano
    var
      // Conterá os valores do arquivo a ser importado
      Meses: TStrings;

      // Auxiliares
      var anoIni, anoFim, Ano: Integer;

      // Indica as posicoes dos meses ja no formato String
      indMeses: Array of byte;

      // Indica se o mes pertence ao ano anterior, senao pertence ao ano atual
      // Ex:
      //     1<=11  2<=12  3<=01  4<=02  5<=03  6<=04
      //      NOV    DEC    JAN    FEB    MAR    APR
      //       V      V      F      F      F      F      (V = Verdadeiro  F = Falso)
      //
      // Teste: anoAnterior[PosMes] <-- PosMes <= Mes
      //
      // Teremos:
      //          anoAnterior[1] = true    NOV (ano atual)
      //          anoAnterior[2] = true    DEC (ano atual)
      //          anoAnterior[3] = false   JAN (ano seguinte)
      //          anoAnterior[4] = false   FEB (ano seguinte)
      //          anoAnterior[5] = false   MAR (ano seguinte)
      //          anoAnterior[6] = false   APR (ano seguinte)
      anoAnterior: Array of Boolean;

      procedure Add(Mes, Ano: integer; Valor: single);
      begin
        //dialogs.ShowMessage(format('%d  %d  %f', [mes, ano, valor]));
        FReqs[Ano - (anoIni - byte(not FReqs_CMA)) + 1, Mes] := Valor;
      end;

      procedure Read_Years();
      var i, k: Integer;
          s: String;
      begin
        inc(L); s := SL[L];

        // Anos
        anoIni := toInt(s, 3, 4, false, -1);
        anoFim := toInt(s, 9, 4, false, -1);

        // Meses
        FReqs_MI := toInt(s, 17, 2, true, -1);
        FReqs_MF := toInt(s, 24, 2, true, -1);

        // Número de meses
        i := 0;
        if FReqs_MI <= FReqs_MF then
           begin
           // Ex:  3    8   -->    6 meses
           k := FReqs_MF - FReqs_MI + 1;
           setLength(indMeses, k);
           setLength(anoAnterior, k);
           FReqs_CMA := true;
           for k := FReqs_MI to FReqs_MF do
             begin
             indMeses[i] := k;
             anoAnterior[i] := false;
             inc(i);
             end;
           end
        else
           begin
           // Ex:  11   4   -->    6 meses
           k := (12 - FReqs_MI + 1) + FReqs_MF;
           setLength(indMeses, k);
           setLength(anoAnterior, k);
           FReqs_CMA := false;
           for k := FReqs_MI to 12 do
             begin
             indMeses[i] := k;
             anoAnterior[i] := true;
             inc(i);
             end;
           for k := 1 to FReqs_MF do
             begin
             indMeses[i] := k;
             anoAnterior[i] := false;
             inc(i);
             end;
           end;

        // Cria a estrutura que ira armazenar os dados na instancia
        FReqs := TwsDataset.CreateNumeric('Requerimentos', 0, 12);
        for i := anoIni - byte(not FReqs_CMA) to anoFim do
          FReqs.AddRow(toString(i));

        inc(L);

        // Lê as necessidades anuais
        for i := anoIni to anoFim do
          if Locate(toString(i), SL, L) then
             begin
             Split(SL[L+4], Meses, [' ']);

             // Lê as necessidades mensais
             for k := 2 to Meses.Count-1 do
               begin
               if anoAnterior[k-2] then ano := i - 1 else ano := i;

               // Mes, Ano, Valor
               Add(indMeses[k-2], ano, StrToFloatDef(Meses[k], -1));
               end;
             end;
      end; // Read_Years

   begin
     if Locate('NECESSIDADES DECENDIAIS DE REGA', SL, L) then
        begin
        Meses := TStringList.Create; // Conterá as necessidades mensais
        Read_Years();
        Meses.Free;
        end;
   end;

   procedure LerB1(var L: integer; ano: TYear);
   begin
     if ano.Scheme <> 5 then
        begin
        Locate('B2:', SL, L);
        Dec(L, 2);
        ano.IrrDepth := strToFloatDef(AllTrim(SL[L]), wscMissValue);
        end;
   end;

   procedure LerB2(var L: integer; ano: TYear);
   begin
     inc(L, 7);
     ano.Precipitation := strToFloatDef(AllTrim(SL[L]), wscMissValue);
   end;

   procedure LerB3(var L: integer; ano: TYear);
   begin
     inc(L);
     ano.ETm := strToFloatDef(AllTrim(SL[L]), wscMissValue);

     inc(L);
     ano.ETa := strToFloatDef(AllTrim(SL[L]), wscMissValue);

     inc(L, 2);
     ano.YieldLoss := strToFloatDef(AllTrim(SL[L]), wscMissValue) / 100;
   end;

   procedure LerB4(var L: integer; ano: TYear);
   begin
     inc(L, 3);
     ano.PeakIntervals := strToFloatDef(AllTrim(SL[L]), wscMissValue);
   end;

   procedure LerAnaliseFrequencial(L: integer);
   var i: integer;
   begin
     if Locate('ANÁLISE FREQUENCIAL', SL, L) then
        begin
        i := SL.Count - L - 1; // numero de elementos
        system.SetLength(FAF_Prob, i);
        system.SetLength(FAF_Val , i);
        i := 0;
        for L := L+1 to SL.Count-1 do
          begin
          FAF_Prob[i] := SysUtilsEx.toFloat(SL[L], 06, 4, true, 0);
          FAF_Val [i] := SysUtilsEx.toFloat(SL[L], 13, 6, true, 0);
          inc(i);
          end;
        end;
   end;

   procedure LerSimulacao(LI, LF: integer);
   var L: Integer;
       s: shortString;
       ano: TYear;
   begin
     L := LI + 1;

     ano := self.Years.NewYear(FIrrigate, self);

         ano.Year   := toInt(SL[L], 6, 4, false, -1);
         ano.Scheme := toInt(SL[L], 2, 1, false, -1);

     inc(L);

     // Em cada bloco deverá ser retornado a linha do último dado ou anterior.
     // Se algum bloco nao for encontrado, o avanço será realizado
     // dentro do laço principal automaticamente.
     while L < LF do
       begin
       s := SysUtilsEx.Alltrim(SL[L]);

       // Formato: [Xxxx]
       if s[2] = 'B' then
          case s[3] of
            '1': LerB1({out} L, ano);
            '2': LerB2({out} L, ano);
            '3': LerB3({out} L, ano);
            '4': LerB4({out} L, ano);
          end;

       inc(L);
       end; // while
   end;

var i, k: integer;
    Blocos: array of record LI, LF: integer; end;
begin
  try
    if FileExists(Name) then
       try
         SL := TStringList.Create();
         SL.LoadFromFile(Name);

         // Marca o inicio e o final de cada simulacao
         k := toInt(SL[1], 11, 2, true, -1);
         SetLength(Blocos, k);
         Blocos[0].LI := 2;
         Blocos[k-1].LF := SL.Count-1;
         i := 5;
         for k := 1 to k-1 do // Bloco 2 em diante
           if Locate('SIMULACAO', SL, i) then
              begin
              Blocos[k].LI := i;     // Linha Inicial do bloco corrente
              Blocos[k-1].LF := i-1; // Linha final do bloco anterior
              inc(i);
              end
           else
              {Número de blocos de simulação inválido};

         i := High(Blocos);

         // Faz a leitura dos blocos de simulacao
         for k := 0 to i do
           LerSimulacao(Blocos[k].LI, Blocos[k].LF);

         // Le a partir do inicio do ultimo bloco ...
         LerNecessidadesDeRega(Blocos[i].LI);
         LerAnaliseFrequencial(Blocos[i].LI);
       finally
         SL.Free();
       end;
  except
    on E: Exception do
       Dialogs.ShowMessage('Plugin cd_Lavouras:'#13 + E.Message);
  end;
end;

procedure TManagement.ShowDemandGraph();
var d: TfoGR_Demandas;
begin
  d := TfoGR_Demandas.Create(self);
  d.Show();
  FCrop.AddResult(d);
end;

procedure TManagement.Load_FAS(const Name: string);
var SL : TStrings;
    i, PosicaoArquivo : integer;
begin
  if FileExists(Name) then
     try
       PosicaoArquivo := 0;
       SL := SysUtilsEx.LoadTextFile(Name);
       for i := 0 to Years.Count-1 do
         Years.Item[i].LoadFases(SL, {var} PosicaoArquivo);
     finally
       SL.Free();
     end;
end;

function TManagement.getVB(): real;
begin
  try
     Result := (getUnitaryOutlet(FCrop.FNivelProb) / (FCrop.Sys_Efficiency / 100)) *
               (3.6 * (24 / FCrop.FHorasOper) *
               (FCrop.IrrigationFrequency / (FCrop.IrrigationFrequency - 1))) *
                FCrop.IrrigatedArea_perDay;
  except
     on E: exception do
        raise Exception.Create(E.Message + #13 +
                               'in Bomb`s Outlet calculation');
  end;
end;

procedure TManagement.toXML(x: TXML_Writer);
var i: Integer;
begin
  x.beginTag('management');
    x.beginIdent();

    x.Write('management_File', FManagement_File);
    x.Write('Restriction_File', FRestriction_File);
    x.Write('Activate', FActive);
    x.Write('Irrigate', Irrigate);

    x.Write('Reqs_MI', FReqs_MI);
    x.Write('Reqs_MF', FReqs_MF);
    x.Write('Reqs_CMA', FReqs_CMA);

    x.beginTag('FrequencyTable');
      x.beginIdent();
      for i := 0 to High(FAF_Prob)-1 do
        x.Write('item', ['prob', 'val'], [FAF_Prob[i], FAF_Val[i]]);
      x.endIdent();
    x.endTag('FrequencyTable');

    FLA.toXML(x);
    FReqs.ToXML(x.Buffer, x.IdentSize);

    x.endIdent();
  x.endTag('management');
end;

procedure TManagement.fromXML(no: IXMLDomNode);
var i : Integer;
    cn: IXMLDOMNodeList;
    n : IXMLDOMNode;
    n2: IXMLDOMNode;
begin
  cn := no.childNodes;

  FManagement_File  := cn.nextNode().text;
  FRestriction_File := cn.nextNode().text;

  FActive := toBoolean(cn.nextNode().text);

  if FCrop.FxmlVersion < 12 then
     cn.nextNode(); // Pula a vazao unitaria

  Irrigate := toBoolean(cn.nextNode().text);

  if FCrop.FxmlVersion >= 3 then
     begin
     FReqs_MI   := toInt(cn.nextNode().text);
     FReqs_MF   := toInt(cn.nextNode().text);
     FReqs_CMA  := toBoolean(cn.nextNode().text);
     end
  else
     begin
     FReqs_MI := 1;
     FReqs_MF := 12;
     FReqs_CMA := true;
     end;

  // Tabela de Frequencias
  if FCrop.FxmlVersion >= 12 then
     begin
     n := cn.nextNode();
     i := n.childNodes.length;
     if i > 0 then
        begin
        system.SetLength(FAF_Prob, i);
        system.SetLength(FAF_Val, i);
        for i := 0 to i-1 do
          begin
          n2 := n.childNodes.item[i];
          FAF_Prob[i] := n2.attributes.item[0].nodeValue;
          FAF_Val [i] := n2.attributes.item[1].nodeValue;
          end;
        end;
     end;

  FLA.fromXML( cn.nextNode() );

  FReqs := TwsDataSet.Create();
  FReqs.fromXML(cn.nextNode());
end;

function TManagement.canEdit(): boolean;
begin
  result := false;
end;

procedure TManagement.executeDefaultAction();
begin

end;

procedure TManagement.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Activate', false, AtivarEvent, nil);
  CreateAction(Actions, nil, 'Remove', false, RemoveEvent, nil);
  CreateAction(Actions, nil, '-', false, nil, nil);
  CreateAction(Actions, nil, 'Show Geral Data ...', false, ShowGeralDataEvent, nil);
  if FIrrigate then
     CreateAction(Actions, nil, 'Visualize Demand Graphics ...', false,
                  VisGraficoDasDemandasEvent, nil);
end;

function TManagement.getImageIndex(): integer;
begin
  if FActive then
     result := ciRB_Checked
  else
     result := ciRB_Unchecked;
end;

function TManagement.getNodeText(): string;
begin
  result := getDesc()
end;

procedure TManagement.RemoveEvent(Sender: TObject);
begin
  if Dialogs.MessageDLG('Are you sure ?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     FCrop.Managements.Remove(Self);
end;

procedure TManagement.AtivarEvent(Sender: TObject);
begin
  FCrop.Managements.Activate(self);
  TreeNode.TreeView.Refresh();
end;

procedure TManagement.VisGraficoDasDemandasEvent(Sender: TObject);
begin
  ShowDemandGraph();
end;

function TManagement.ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
var k: Integer;
begin
  result := AddNode(Tree, ParentNode, '', -1, self);
  TreeNode := result;

  // Years
  for k := 0 to FLA.Count-1 do
    FLA.Item[k].ShowInTree(Tree, result);
end;

procedure TManagement.MostrarIndicadoresMedios(p: TSpreadSheetBook; Row: Integer);
begin
  p.ActiveSheet.WriteCenter(Row, 02, Years.Mean  ('RawIrrDepth'));
  p.ActiveSheet.WriteCenter(Row, 03, Years.Mean  ('YieldLoss'));
  p.ActiveSheet.WriteCenter(Row, 04, Years.Mean  ('TotalIrrCropCost'));
  p.ActiveSheet.WriteCenter(Row, 05, Years.Mean  ('RawGrossMarginOfProfit'));
  p.ActiveSheet.WriteCenter(Row, 06, Years.Mean  ('LiquidNetProfit'));
  p.ActiveSheet.WriteCenter(Row, 07, Years.StdDev('LiquidNetProfit'));
  p.ActiveSheet.WriteCenter(Row, 08, Years.Mean  ('LimProdForRevenue'));
  p.ActiveSheet.WriteCenter(Row, 09, Years.Mean  ('MarginalProductivity'));
end;

procedure TManagement.MostrarTotaisMedios(p: TSpreadSheetBook; Row: Integer);
begin
  p.ActiveSheet.WriteCenter(Row, 02, FCrop.TotalCost);
  p.ActiveSheet.WriteCenter(Row, 03, Years.Mean('TotalIrrCost'));
  p.ActiveSheet.WriteCenter(Row, 04, Years.Mean('TotalProduction'));
  p.ActiveSheet.WriteCenter(Row, 05, Years.Mean('TotalWaterVol'));
  p.ActiveSheet.WriteCenter(Row, 06, Years.Mean('Profit'));
end;

function TManagement.getUnitaryOutlet(const Prob: real): real;
var L, H: integer;

  function Interpolate(): real;
  var i: Integer;
  begin
    for i := L+1 to H do
      if Prob < FAF_Prob[i] then
         begin
         result := Prob * FAF_Val[i] / FAF_Prob[i];
         break;
         end;
  end;

begin
  if FAF_Prob <> nil then
     begin
     L := Low(FAF_Prob);
     H := High(FAF_Prob);

     if Prob <= FAF_Prob[L] then
        result := FAF_Val[L]
     else
        if Prob >= FAF_Prob[H] then
           result := FAF_Val[H]
        else
           result := Interpolate()
     end
  else
     result := 0;
end;

procedure TManagement.ShowGeralData();
var p: TSpreadSheetBook;
    x: real;
    i: integer;
    y: TYear;
begin
  p := TSpreadSheetBook.Create('', 'Geral Data');
  FCrop.AddResult(p);

  // Folha 1 - Propriedades gerais do manejo
  with p.ActiveSheet do
    begin
    ColWidth[1] := 200;

    // Linha 1
    i := 1;
    boldCell(i, 1);
    write(i, 1, 'Bomb`s outlet in ' + toString(FCrop.OperationHoursPerDay) + ' hours/day (m3/s)');
    write(i, 2, getVB());

    // Linha 2
    i := 2;
    boldCell(i, 1);
    write(i, 1, 'Minimal Bomb`s outlet of River');
    write(i, 2, getVBRio());

    // Linha 4
    i := 4;
    write(i, 1, 'Unitary Outlet');
    write(i, 2, 'Prob.');
    write(i, 3, 'Value');
    boldRow(i);

    // Linha 5 em diante
    x := 5;
    i := 5;
    repeat
      write(i, 2, x);
      write(i, 3, getUnitaryOutlet(x));
      x := x + 5;
      i := i + 1;
      until x > 100
    end;

  // Folha 2 - Anos
  p.NewSheet('Years');
  with p.ActiveSheet do
    begin
    ColWidth[1] := 300;

    ActiveRow := 2;
    ActiveCol := 1;

    write('ETa', true, false);
    write('ETm', true, false);
    write('YieldLoss (%)', true, false);
    write('Precipitation [Prec] (mm)', true, false);
    write('IrrDepth (mm)', true, false);
    write('PeakIntervals (days)', true, false);
    write('Calc.Local.Pot.Yield [CLPY] ($/ha)', true, false);
    write('Rainfeld Pot. Yield [RCPY] ($/ha)', true, false);
    write('Irr.Pot.Yield [ICPY] ($/ha)', true, false);
    write('Market Prod. Value [MPV] ($/ha)', true, false);
    write('Production Value [FPV] ($)', true, false);
    write('CropYield (kg/ha)', true, false);
    write('RainProductivity [RWP] (Kg/m3)', true, false);
    write('Econ.Water Prod. [EWP] ($/m3)', true, false);
    write('IrrRainWaterProductivity [IRWP] (kg/m3)', true, false);

    // Nut. Prod
    write('', true, false);
    write('Nutritional Production', true, false);
    write('Nut. Water Prod. [NWP] (Kcal/m3)', true, false);
    write('Irr. Water Nut. Prod. [IWNP]', true, false);
    write('Irr. Rain Water Nut. Prod. [IRWNP] (Kcal/m3)', true, false);
    write('IrrGrossDepthNutProd [IGDNP] (Kcal/m3)', true, false);
    write('', true, false);

    write('IrrWaterProd [IWP] (kg/m3)', true, false);
    write('IrrWaterProd_IrrDepth [IWP_ID] (kg/m3)', true, false);
    write('IrrGrossDepthProd [x] (kg/m3)', true, false);
    write('RawIrrDepth (m3/ha)', true, false);
    write('RawIrrGrossDepthProd [x] (kg/m3)', true, false);
    write('Rainfall Act.Conv.Coef. [RACC]', true, false);
    write('Rainfall Pot.Conv.Coef. [RPCC]', true, false);
    write('Rainfall Coefficient [RC]', true, false);
    write('HoursOfOperation [x] (h)', true, false);
    write('WaterCost [x] ($/ha)', true, false);
    write('EnergyCost ($/ha)', true, false);
    write('LaborCost [x] ($/ha)', true, false);
    write('FixedIrrCost [x] ($/ha)', true, false);
    write('VariableIrrCost [x] ($/ha)', true, false);
    write('IrrCost [x] ($/ha)', true, false);
    write('TotalIrrCost ($)', true, false);
    write('IrrCropCost [x] ($/ha)', true, false);
    write('TotalIrrCropCost ($)', true, false);
    write('RawGrossMarginOfProfit ($/ha)', true, false);
    write('LiquidNetProfit ($/ha)', true, false);
    write('CapRetFactor [x]', true, false);
    write('NetProfit (%)', true, false);
    write('TotalRawGrossRevenue [x] ($)', true, false);
    write('Profit ($)', true, false);
    write('TotalWaterVol (m3)', true, false);
    write('TotalProduction (kg)', true, false);
    write('LimProdForRevenue (kg/ha)', true, false);
    write('MarginalProductivity (%)', true, false);
    write('PracticableProductivity [x] (kg/ha)', true, false);

    for i := 0 to FLA.Count-1 do
      begin
      y := FLA.Item[i];

      ActiveRow := 1;
      ActiveCol := i + 2;

      write(y.Year, true, false);
      write(y.ETa, true, false);
      write(y.ETm, true, false);
      write(y.YieldLoss, true, false, 4);
      write(y.Precipitation, true, false);
      write(y.IrrDepth, true, false);
      write(y.PeakIntervals, true, false);
      write(y.CLPY, true, false);
      write(y.RCPY, true, false);
      write(y.ICPY, true, false);
      write(y.MPV, true, false);
      write(y.FPV, true, false);
      write(y.CropYield, true, false);
      write(y.RainProductivity, true, false, 4);
      write(y.EWP, true, false, 4);
      write(y.IrrRainWaterProductivity, true, false);

      // Nut. Prod
      write('', true, false);
      write('', true, false);
      write(y.NWP, true, false, 4);
      write(y.IrrWaterNutProd, true, false);
      write(y.IrrRainWaterNutProd, true, false);
      write(y.IrrGrossDepthNutProd, true, false);
      write('', true, false);
      
      write(y.IrrWaterProd, true, false);
      write(y.IrrWaterProd_IrrDepth, true, false);
      write(y.IrrGrossDepthProd, true, false);
      write(y.RawIrrDepth, true, false);
      write(y.RawIrrGrossDepthProd, true, false);
      write(y.RACC, true, false, 4);
      write(y.RPCC, true, false, 4);
      write(y.RC, true, false, 4);
      write(y.HoursOfOperation, true, false);
      write(y.WaterCost, true, false);
      write(y.EnergyCost, true, false);
      write(y.LaborCost, true, false);
      write(y.FixedIrrCost, true, false);
      write(y.VariableIrrCost, true, false);
      write(y.IrrCost, true, false);
      write(y.TotalIrrCost, true, false);
      write(y.IrrCropCost, true, false);
      write(y.TotalIrrCropCost, true, false);
      write(y.RawGrossMarginOfProfit, true, false);
      write(y.LiquidNetProfit, true, false);
      write(y.CapRetFactor, true, false);
      write(y.NetProfit, true, false);
      write(y.TotalRawGrossRevenue, true, false);
      write(y.Profit, true, false);
      write(y.TotalWaterVol, true, false);
      write(y.TotalProduction, true, false);
      write(y.LimProdForRevenue, true, false);
      write(y.MarginalProductivity, true, false);
      write(y.PracticableProductivity, true, false);
      end;

    boldRow(1);
    boldCol(1);
    end;

  // Folha 3 - Demandas
  if FReqs <> nil then
     begin
     p.NewSheet('Demands');
     FReqs.ShowInSheet(p);
     end;

  p.Caption := FCrop.Name + ' - ' + getDesc;
  if self.FIrrigate then
     p.Caption := p.Caption + ' (Irrigated)'
  else
     p.Caption := p.Caption + ' (Rainfed)';

  p.Show();
end;

procedure TManagement.ShowGeralDataEvent(Sender: TObject);
begin
  ShowGeralData();
end;

function TManagement.getVBRio(): real;
begin
  result := ((getUnitaryOutlet(FCrop.Prob_Level) / (FCrop.Sys_Efficiency / 100))) *
            FCrop.IrrigatedArea_perDay;
end;

{ TManagementList }

constructor TManagementList.Create(Crop: TCrop);
begin
  inherited Create();
  FCrop := Crop;
  FList := TObjectList.Create(true);
end;

destructor TManagementList.Destroy();
begin
  getMessageManager.SendMessage(UM_ObjectDestroy, [self]);
  FList.Free();
  inherited Destroy();
end;

procedure TManagementList.Add(Management: TManagement);
begin
  Management.Irrigate := (FList.Count > 0);
  FList.Add(Management);
end;

function TManagementList.getCount(): Integer;
begin
  Result := FList.Count;
end;

function TManagementList.getItem(i: integer): TManagement;
begin
  Result := TManagement(FList[i]);
end;

procedure TManagementList.Activate(Management: TManagement);
var i: Integer;
    r: TManagement;
begin
  for i := 0 to getCount()-1 do
    begin
    r := getItem(i);
    r.Active := (r = Management);
    end;
end;

// Se nao existe resultado ativado entao retorna o primeiro
function TManagementList.Active(): TManagement;
var i: Integer;
begin
  Result := nil;
  for i := 0 to getCount()-1 do
    if getItem(i).Active then
       begin
       Result := getItem(i);
       break;
       end;

  if (Result = nil) and (getCount() > 0) then
     begin
     Result := getItem(0);
     Result.Active := true;
     end;
end;

procedure TManagementList.Remove(Management: TManagement);
begin
  FList.Remove(Management);
end;

procedure TManagementList.Plot(Tipo: TTipoGrafico);
begin
  case Tipo of
    // Indices Estatisticos
    ti_STD_NetReturn .. ti_Med_LL:
      TfoGR_IndicesMedios.Create(self, Tipo).Show();

    // Indices Lineares Anuais
    tiProdChuva .. tiPracticableProductivity:
      TfoGR_Indices.Create(self, Tipo).Show();
  end;
end;

procedure TManagementList.toXML(x: TXML_Writer);
var i: Integer;
begin
  x.beginTag('managements');
    x.beginIdent();
    for i := 0 to getCount()-1 do getItem(i).toXML(x);
    x.endIdent();
  x.endTag('managements');
end;

procedure TManagementList.fromXML(no: IXMLDOMNode);
var i: Integer;
    Management: TManagement;
begin
  for i := 0 to no.childNodes.length - 1 do
    begin
    Management := TManagement.Create('xx', 'yy', FCrop);
    Management.fromXML(no.childNodes.item[i]);
    Add(Management);
    end;
end;

procedure TManagementList.Clear();
begin
  FList.Clear();
end;

{ TYearList }

constructor TYearList.Create(Crop: TCrop);
begin
  inherited Create();
  FCrop := Crop;
  FList := TObjectList.Create(true);
end;

destructor TYearList.Destroy();
begin
  FList.Free();
  inherited Destroy();
end;

procedure TYearList.Add(Item: TYear);
begin
  FList.Add(Item);
end;

function TYearList.getCount(): integer;
begin
  Result := FList.Count;
end;

function TYearList.getItem(i: integer): TYear;
begin
  Result := TYear(FList[i]);
end;

function TYearList.NewYear(Irrigado: boolean; Management: TManagement): TYear;
begin
  Result := TYear.Create(Irrigado, Management);
  self.Add(Result);
end;

function TYearList.GetYear(Ano: integer): TYear;
var i: Integer;
begin
  for i := 0 to getCount()-1 do
    begin
    result := getItem(i);
    if result.FYear = Ano then exit;
    end;
  result := nil;
end;

procedure TYearList.toXML(x: TXML_Writer);
var i: Integer;
begin
  x.beginTag('years');
    x.beginIdent();
    for i := 0 to getCount()-1 do
      getItem(i).toXML(x);
    x.endIdent();
  x.endTag('years');
end;

procedure TYearList.fromXML(no: IXMLDomNode);
var i: Integer;
    ano: TYear;
begin
  for i := 0 to no.childNodes.length-1 do
    begin
    ano := self.NewYear(false, FManagement);
    ano.fromXML(no.childNodes.item[i]);
    ano.FIrrigate := FManagement.Irrigate;
    end;
end;

function TYearList.Mean(const Prop: string): real;
begin
  result := 0;
  if getCount() > 0 then
     result := Sum(Prop) / getCount();
end;

function TYearList.Sum(const Prop: string): real;
var i: integer;
begin
  result := 0;
  for i := 0 to getCount()-1 do
    result := result + getItem(i).getPropValue(Prop);
end;

function TYearList.StdDev(const Prop: string): real;
var m: real;
    n: integer;
    i: integer;
begin
  m := Mean(Prop);
  n := getCount();
  result := 0;

  for i := 0 to n-1 do
    result := result + SQR(getItem(i).getPropValue(Prop) - m);

  if n > 1 then
     result := SQRT(result / (n - 1))
  else
     result := -1;
end;

{ TYear }

constructor TYear.Create(Irrigado: boolean; Management: TManagement);
begin
  inherited Create();
  FIrrigate := Irrigado;
  FManagement := Management;
end;

procedure TYear.LoadFases(Arquivo: TStrings; var PosicaoArquivo: integer);
var s: string;
    i, k, ini, fim: integer;
begin
  s := ' ' + toString(FYear) + '  ';
  if Locate(s, Arquivo, PosicaoArquivo) then
     begin
     inc(PosicaoArquivo, 3);
     ini := PosicaoArquivo;
     if Locate('Crop period', Arquivo, PosicaoArquivo) then
        fim := PosicaoArquivo - 1
     else
        EXIT; // erro !!! somente se o arquivo estiver corrompido

     // leitura dos dados
     k := 0;
     for i := ini to fim do
       begin
       s := Arquivo[i];
       setLength(FFases, fim-ini+1);
       {
        2       10    16     23     30     37     44     51     58
            Períods   Irrig Excess    SETa   SETm   SPre  R(DR)   Sasc
        15/11 a  5/12   49.1   95.7   57.5   63.4  112.6   66.1    0.0
         5/12 a 29/ 1   41.0  203.4  209.8  213.8  365.8   59.7    0.0
        29/ 1 a 19/ 3   47.8    0.0  237.6  246.7  152.3   22.2    0.0
        19/ 3 a 23/ 4   47.2    9.9   87.8   96.1   86.2   57.8    0.0
       }
       FFases[k].Inicio    :=    Copy(s, 02, 5, true);
       FFases[k].Fim       :=    Copy(s, 10, 5, true);
       FFases[k].Irrigacao := toFloat(s, 16, 6, true, -1);
       FFases[k].Excesso   := toFloat(s, 23, 6, true, -1);
       FFases[k].ETa       := toFloat(s, 30, 6, true, -1);
       FFases[k].ETm       := toFloat(s, 37, 6, true, -1);
       FFases[k].PRE       := toFloat(s, 44, 6, true, -1);
       FFases[k].R         := toFloat(s, 51, 6, true, -1);
       FFases[k].ASC       := toFloat(s, 58, 6, true, -1);
       inc(k);
       end;

     // Para possibilitar o encontro do proximo bloco
     dec(PosicaoArquivo, 2);
     end;
end;

function TYear.getCLPY(): real;
begin
  result := FManagement.Crop.RendimentoPotencialCalculado(FYear);
end;

function TYear.getFPV(): real;
begin
  result := FManagement.Crop.ValorProducaoAgropecuaria(FYear);
end;

function TYear.getMPV(): real;
begin
  result := FManagement.Crop.ValorProdutoMercado(FYear);
end;

function TYear.getDemanda(Mes: integer): real;
begin
  if (Mes > 0) and (Mes < 13) then
     try
       result := FManagement.Reqs[FYear - FManagement.Crop.FFirstYear + 1, Mes];
     except
       result := -1
     end
  else
     Result := -1;
end;

procedure TYear.toXML(x: TXML_Writer);
var s, s2: string;
    k: integer;
begin
  x.beginTag('data', ['year', 'manType'], [FYear, FScheme]);
    x.beginIdent();

    x.Write('Irr'      , FIrrigate);
    x.Write('ETa'      , FETa);
    x.Write('ETm'      , FETm);
    x.Write('YieldLoss', FYieldLoss);
    x.Write('ChT'      , FPrec);
    x.Write('IrrDepth' , FIrrDepth);
    x.Write('II_P'     , FII_P);

    // Fases
    x.beginTag('fases');
      x.beginIdent();
      for k := 0 to High(FFases) do
        begin
        x.beginTag('fase');
          x.beginIdent();

          x.Write('Irrigation', FFases[k].Irrigacao);
          x.Write('Excess'    , FFases[k].Excesso);
          x.Write('start'     , FFases[k].Inicio);
          x.Write('end'       , FFases[k].Fim);
          x.Write('ETm'       , FFases[k].ETm);
          x.Write('ETa'       , FFases[k].ETa);
          x.Write('PRE'       , FFases[k].PRE);
          x.Write('R'         , FFases[k].R);
          x.Write('ASC'       , FFases[k].ASC);

          x.endIdent();
        x.endTag('fase');
        end;
      x.endIdent();
    x.endTag('fases');

    x.endIdent();
  x.endTag('data');
end;

procedure TYear.fromXML(no: IXMLDomNode);
var cn : IXMLDomNodeList;
    cn2: IXMLDomNodeList;
     n : IXMLDomNode;
     i : integer;
begin
  cn := no.childNodes;

  FYear   := toInt(no.attributes.item[0].text);
  FScheme := toInt(no.attributes.item[1].text);

  FIrrigate   := toBoolean(cn.nextNode.text);
  FETa        := toFloat(cn.nextNode.text);
  FETm        := toFloat(cn.nextNode.text);
  FYieldLoss  := toFloat(cn.nextNode.text);
  FPrec       := toFloat(cn.nextNode.text);
  FIrrDepth   := toFloat(cn.nextNode.text);
  FII_P       := toFloat(cn.nextNode.text);

  // Fases
  cn := cn.nextNode.childNodes;
  setLength(FFases, cn.length);
  for i := 0 to cn.length-1 do
    begin
    cn2 := cn.item[i].childNodes;

    FFases[i].Irrigacao := toFloat(cn2.nextNode.text);
    FFases[i].Excesso   := toFloat(cn2.nextNode.text);
    FFases[i].Inicio    := cn2.nextNode.text;
    FFases[i].Fim       := cn2.nextNode.text;
    FFases[i].ETm       := toFloat(cn2.nextNode.text);
    FFases[i].ETa       := toFloat(cn2.nextNode.text);

    if FManagement.Crop.FxmlVersion >= 4 then
       begin
       FFases[i].PRE := toFloat(cn2.nextNode.text);
       FFases[i].R   := toFloat(cn2.nextNode.text);
       FFases[i].ASC := toFloat(cn2.nextNode.text);
       end;
    end;

  //CalculateIndexes();
end;

procedure TYear.ZoomEvent(Sender: TObject);
begin
  FZoom := TYearZoom.Create(self);
  AddNode(TTreeView(TreeNode.TreeView), TreeNode, '', -1, FZoom);
end;

function TYear.canEdit(): boolean;
begin
  result := false;
end;

procedure TYear.executeDefaultAction();
begin

end;

procedure TYear.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Simulate Temporal Zoom', false, ZoomEvent, nil);
end;

function TYear.getImageIndex(): integer;
begin
  result := ciYear;
end;

function TYear.getNodeText(): string;
begin
  result := toString(FYear);
end;

destructor TYear.Destroy();
begin
  FZoom.Free();
  inherited;
end;

function TYear.ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
var k: integer;
    n1, n2: TTreeNode;
begin
  result := AddNode(Tree, ParentNode, '', -1, self);
  self.TreeNode := result;

  // Fases
  n1 := AddNode(Tree, result, 'Phases', ciFolder);
  for k := 0 to High(FFases) do
    begin
    n2 := AddNode(Tree, n1, 'Phase ' + intToStr(k), ciClock);

    AddNode(Tree, n2, 'Interval: '                + FFases[k].Inicio + ' - ' + FFases[k].Fim     , ciItem);
    AddNode(Tree, n2, 'Irrigation: '              + SysUtilsEx.toString(FFases[k].Irrigacao), ciItem);
    AddNode(Tree, n2, 'Excess: '                  + SysUtilsEx.toString(FFases[k].Excesso)  , ciItem);
    AddNode(Tree, n2, 'ETm: '                     + SysUtilsEx.toString(FFases[k].ETm)      , ciItem);
    AddNode(Tree, n2, 'ETa: '                     + SysUtilsEx.toString(FFases[k].ETa)      , ciItem);
    AddNode(Tree, n2, 'Precipitation: '           + SysUtilsEx.toString(FFases[k].PRE)      , ciItem);
    AddNode(Tree, n2, 'Soil Moisture Variation: ' + SysUtilsEx.toString(FFases[k].R)        , ciItem);
    AddNode(Tree, n2, 'Capillary Rise: '          + SysUtilsEx.toString(FFases[k].ASC)      , ciItem);
    end;

  if FZoom <> nil then
     FZoom.ShowInTree(Tree, result);
end;

function TYear.getRWP(): real;
begin
  if FETa <> 0 then
     result := getCropYield() / FETa / 10
  else
     result := 0;
end;

function TYear.getIrrRainWaterProd(): real;
begin
  result := getRWP();
end;

function TYear.getRACC(): real;
begin
  if FPrec <> 0 then
     result := FETa / FPrec
  else
     result := 0;
end;

function TYear.getRPCC(): real;
begin
  if FPrec <> 0 then
     result := FETm / FPrec
  else
     result := 0;
end;

function TYear.getRC(): real;
begin
  result := 1 - ( getRPCC() - getRACC() );
end;

function TYear.getRIWP(): real;
begin
  if FETa <> 0 then
     result := getICPY() / FETa / 10
  else
     result := 0;
end;

function TYear.getRCPY(): real;
begin
  result := FManagement.Crop.RendimentoPotDaCultura(FYear);
end;

function TYear.getICPY(): real;
begin
  result := FManagement.Crop.RendimentoPotDaCulturaIrrigada(FYear)
end;

function TYear.getNWP(): real;
begin
  if FEta <> 0 then
     result := getCropYield() * FManagement.Crop.Calorias() / (FEta * 10)
  else
     result := 0;
end;

function TYear.getPropValue(const Prop: string): real;
begin
  if CompareText(Prop, 'Irrigate'              ) = 0 then result := byte(FIrrigate)            else
  if CompareText(Prop, 'ETa'                   ) = 0 then result := FETa                       else
  if CompareText(Prop, 'ETm'                   ) = 0 then result := FETm                       else
  if CompareText(Prop, 'RACC'                  ) = 0 then result := getRACC()                  else
  if CompareText(Prop, 'YieldLoss'             ) = 0 then result := FYieldLoss                 else
  if CompareText(Prop, 'CropYield'             ) = 0 then result := getCropYield()             else
  if CompareText(Prop, 'MPV'                   ) = 0 then result := getMPV()                   else
  if CompareText(Prop, 'FPV'                   ) = 0 then result := getFPV()                   else
  if CompareText(Prop, 'CLPY'                  ) = 0 then result := getCLPY()                  else
  if CompareText(Prop, 'RPCC'                  ) = 0 then result := getRPCC()                  else
  if CompareText(Prop, 'RCPY'                  ) = 0 then result := getRCPY()                  else
  if CompareText(Prop, 'RWP'                   ) = 0 then result := getRWP()                   else
  if CompareText(Prop, 'IRWP'                  ) = 0 then result := getIrrRainWaterProd()      else
  if CompareText(Prop, 'IWP'                   ) = 0 then result := getIrrWaterProd()          else
  if CompareText(Prop, 'IWP_ID'                ) = 0 then result := getIrrWaterProd_ID()       else
  if CompareText(Prop, 'NWP'                   ) = 0 then result := getNWP()                   else
  if CompareText(Prop, 'IWNP'                  ) = 0 then result := getIrrWaterNutProd()       else
  if CompareText(Prop, 'IRWNP'                 ) = 0 then result := getIrrRainWaterNutProd()   else
  if CompareText(Prop, 'EWP'                   ) = 0 then result := getEWP()                   else
  if CompareText(Prop, 'Prec'                  ) = 0 then result := FPrec                      else
  if CompareText(Prop, 'RC'                    ) = 0 then result := getRC()                    else
  if CompareText(Prop, 'PeakIntervals'         ) = 0 then result := FII_P                      else
  if CompareText(Prop, 'IrrDepth'              ) = 0 then result := FIrrDepth                  else
  if CompareText(Prop, 'RawIrrDepth'           ) = 0 then result := getRawIrrDepth()           else
  if CompareText(Prop, 'TotalWaterVol'         ) = 0 then result := getTotalWaterVol()         else
  if CompareText(Prop, 'TotalProduction'       ) = 0 then result := getTP()                    else
  if CompareText(Prop, 'LiquidNetProfit'       ) = 0 then result := getLP()                    else
  if CompareText(Prop, 'NetProfit'             ) = 0 then result := getRevenue()               else
  if CompareText(Prop, 'Profit'                ) = 0 then result := getTotalRevenue()          else
  if CompareText(Prop, 'LimProdForRevenue'     ) = 0 then result := getLPFR()                  else
  if CompareText(Prop, 'RawGrossMarginOfProfit') = 0 then result := getRawMarginOfProfit()     else
  if CompareText(Prop, 'IGDNP'                 ) = 0 then result := getIrrGrossDepthNutProd()  else
  if CompareText(Prop, 'TotalIrrCost'          ) = 0 then result := getTIC()                   else
  if CompareText(Prop, 'TotalIrrCropCost'      ) = 0 then result := getTICC()                  else
  if CompareText(Prop, 'EnergyCost'            ) = 0 then result := getEnergyCost()            else
  if CompareText(Prop, 'MarginalProductivity'  ) = 0 then result := getMP()
  else
     raise Exception.Create('TYear.getPropValue'#13 +
                            'Unknown Property: ' + Prop);
end;

function TYear.getRawIrrDepth(): real;
begin
  if FManagement.Crop.Sys_Efficiency <> 0 then
     result := (FIrrDepth / (FManagement.Crop.Sys_Efficiency / 100)) * 10
  else
     result := 0;
end;

function TYear.getHorasOper(): real;
begin
  if FManagement.Crop.Sys_FlowRate <> 0 then
     result := getRawIrrDepth() / FManagement.Crop.Sys_FlowRate
  else
     result := 0;
end;

function TYear.getRawMarginOfProfit(): real;
begin
  result := getCropYield() * getMPV();
end;

function TYear.getTP(): real;
begin
  result := getCropYield() * FManagement.Crop.CultivatedArea;
end;

function TYear.getTotalWaterVol(): real;
begin
  result := getRawIrrDepth() * FManagement.Crop.CultivatedArea;
end;

function TYear.getRevenue(): real;
var x: real;
begin
  if FManagement.Irrigate then
     x := FManagement.Crop.Cost + getIrrCost()
  else
     x := FManagement.Crop.Cost;

  if x <> 0 then
     result := (getLP() / x) * 100
  else
     result := 0;
end;

function TYear.getLP(): real;
begin
  if FManagement.Irrigate then
     result := getRawMarginOfProfit() - (FManagement.Crop.Cost + getIrrCost())
  else
     result := getRawMarginOfProfit() - FManagement.Crop.Cost;
end;

function TYear.getTotalRevenue(): real;
begin
  result := getLP() * FManagement.Crop.CultivatedArea;
end;

function TYear.getLPFR(): real;
var x: real;
begin
  if FManagement.Irrigate then
     x := FManagement.Crop.Cost + getIrrCost()
  else
     x := FManagement.Crop.Cost;

  if getMPV() <> 0 then
     result := x / getMPV()
  else
     result := 0;
end;

function TYear.getMP(): real;
var a, b: real;
begin
  with FManagement do
    begin
    a := (getFIC() / 2);
    if FManagement.Irrigate then a := a + getIrrCost();
    b := Crop.BaseYield * (Crop.NetIncome / 100) * getMPV();
    if b <> 0 then
       result := (a / b) * 100
    else
       result := 0;
    end;
end;

function TYear.getPP(): real;
begin
  with FManagement do
    result := getMP() / 100 * Crop.BaseYield;
end;

function TYear.getCropYield(): real;
begin
  if FIrrigate then
     result := getICPY() * (1 - FYieldLoss)
  else
     result := getRCPY() * (1 - FYieldLoss);
end;

function TYear.getEWP(): real;
begin
  if FEta <> 0 then
     result := getCropYield() * getMPV() / (FEta * 10)
  else
     result := 0;
end;

function TYear.getIrrRainWaterNutProd(): real;
var x: real;
begin
  result := getIrrRainWaterProd() * FManagement.Crop.Calorias;
end;

function TYear.getIrrDepthProd(): real;
var x: real;
begin
  x := getRawIrrDepth();
  if x <> 0 then
     result := (getCropYield() - getRMProp('CropYield')) / x
  else
     result := 0;
end;

function TYear.getRawIrrDepthProd(): real;
var x: real;
begin
  x := getRawIrrDepth() * 10;
  if x <> 0 then
     result := (getCropYield() - getRMProp('CropYield')) / x
  else
     result := 0;
end;

function TYear.getFIC(): real;
begin
  with FManagement do
    result := (Crop.Sys_IrrInstCost - Crop.Sys_IrrResVal) * getCapRetFac();
end;

function TYear.getTIC(): real;
begin
  result := getIrrCost() * FManagement.Crop.CultivatedArea;
end;

function TYear.getVIC(): real;
begin
  result := getEnergyCost() + getWaterCost() + getLaborCost() +
            FManagement.Crop.Sys_IrrMainCost;
end;

function TYear.getIrrCost(): real;
begin
  result := getVIC() + getFIC();
end;

function TYear.getCapRetFac(): real;
var x: real;
begin
  with FManagement do
    begin
    x := Math.Power((Crop.Sys_AnualIR / 100) + 1, Crop.Sys_Life);
    if x <> 1 then
       result := ((Crop.Sys_AnualIR / 100) * x) / (x - 1)
    else
       result := 0;
    end;
end;

function TYear.getEnergyCost(): real;
begin
  with FManagement do
    if Crop.Sys_PumpEffic <> 0 then
       result := (0.736 / 270) *
                 ( (Crop.Sys_FlowRate * getHorasOper() * Crop.Sys_PressureHead * Crop.EnergyPrice) /
                   ((Crop.Sys_PumpEffic / 100)) )
    else
       result := 0;
end;

function TYear.getWaterCost(): real;
begin
  result := getRawIrrDepth() * FManagement.Crop.WaterPrice;
end;

function TYear.getLaborCost(): real;
begin
  with FManagement do
    result := getHorasOper() * Crop.Labor_Persons * Crop.Labor_CostHourly;
end;

function TYear.getIrrCropCost(): real;
begin
  result := FManagement.Crop.Cost; 
  if FIrrigate then
     result := result + getIrrCost();
end;

function TYear.getTICC(): real;
begin
  result := getIrrCropCost() * FManagement.Crop.CultivatedArea;
end;

function TYear.getTotalRawRevenue(): real;
begin
  result := getRawMarginOfProfit() * FManagement.Crop.CultivatedArea;
end;

function TYear.getRMProp(const Prop: string): real;
var M: TManagement;
    A: TYear;
begin
  if FManagement.Crop.Managements.Count = 0 then
     result := 0
  else
     begin
     // Por enquanto o 1. manejo eh o nao irrigado
     M := FManagement.Crop.Managements.Item[0];
     A := M.Years.getYear(FYear);
     if A <> nil then
        result := A.getPropValue(Prop)
     else
        result := 0;
     end;
end;

function TYear.getIrrWaterProd(): real;
var x: real;
begin
  x := (FEta - getRMProp('ETa')) * 10;
  if x <> 0 then
     result := (getCropYield() - getRMProp('CropYield')) / x
  else
     result := 0;
end;

function TYear.getIrrWaterNutProd(): real;
begin
  result := getIrrWaterProd() * FManagement.Crop.Calorias;
end;

function TYear.getIrrGrossDepthNutProd(): real;
begin
  result := getIrrDepthProd() * FManagement.Crop.Calorias;
end;

function TYear.getIrrWaterProd_ID(): real;
begin
  if FIrrDepth <> 0 then
     result := (getCropYield() - getRMProp('CropYield')) / FIrrDepth
  else
     result := 0;
end;

{ TCrop }

procedure TCrop.GenerateIsaregFiles();
var sl: TStrings;
begin
  if not TestIsaregDir() then Exit;

  SysUtils.DeleteFile(FExeDir + 'erros.txt');
  SysUtils.DeleteFile(IsaregDir + 'sai.mes');
  SysUtils.DeleteFile(IsaregDir + 'sai.sai');
  SysUtils.DeleteFile(IsaregDir + 'sai.fas');
  SysUtils.DeleteFile(IsaregDir + 'sai.irr');

  SetCurrentDir(FWorkDir);

  sl := TStringList.Create();
  sl.Add('');
  sl.Add(getFile(FCul));
  sl.Add(getFile(FSol));
  sl.Add(getFile(FEto));
  sl.Add(getFile(FPre));
  sl.Add('sai');
  sl.Add(FInterval);
  sl.Add(getFile(FMan));
  if FRes = '' then sl.Add('N') else sl.Add(getFile(FRes));
  if FAsc = '' then sl.Add('N') else sl.Add(getFile(FAsc));
  sl.SaveToFile(IsaregDir + '\Batch.reg');
  sl.Free();
end;

procedure TCrop.LoadIsaregResults();
var sl: TStrings;
    M: TManagement;
begin
  sl := TStringList.Create();

  if FileExists(FExeDir + 'erros.txt') then
     begin
     sl.LoadFromFile(FExeDir + 'erros.txt');
     if sl.Count > 0 then
        AddError(sl.Text)
     else
        begin
        M := TManagement.Create(FMan, FRes, self);
        M.Load_IRR(IsaregDir + '\SAI.IRR');
        M.Load_FAS(IsaregDir + '\SAI.FAS');
        FManagements.Add(M);
        if FTree <> nil then M.ShowInTree(FTree, FManNode);
        FModified := false;
        ClearMessages();
        end;
     end
  else
     AddError('Errors File not found.'#13 +
              'Unknown Error !');

  sl.Free();
end;
(*
procedure TCrop.Simulate();
var ExecIsareg: TIsaregProc;
    h: THandle;
    s1: TIsaregDataType1;
    s2: TIsaregDataType2;
begin
  fillChar(s1, sizeof(s1), #0);
  s1 := 'c:\temp\isareg';
  s2 := '0';

  ClearMessages()
  h := LoadLibrary(pChar(FExeDir + sIsaregDLL));
  if h <> 0 then
     try
     @ExecIsareg := windows.GetProcAddress(h, 'isareg');
     if @ExecIsareg <> nil then
        begin
        GenerateIsaregFiles();
        SysUtils.SetCurrentDir(FExeDir);
        if not FHasError then
           begin
           ExecIsareg(s1, s2);
           LoadIsaregResults();
           end;
        end
     else
        AddError('Ponto de entrada da Isareg.dll não encontrado.')
     finally
        FreeLibrary(h);
     end
  else
     AddError('Isareg.dll não encontrada.');
end;
*)
procedure TCrop.Simulate();
var p: TIsaregProcess;
begin
  ClearMessages();
  GenerateIsaregFiles();
  if not HasErrors then
     begin
     p := TIsaregProcess.Create(FExeDir);
     try
       p.Execute();
       LoadIsaregResults();
     finally
       p.Free();
       end;
     end;
end;

procedure TCrop.PegarDadosDoDialogo(d: TForm);
var b: boolean;
    i: integer;
begin
  with TfoDadosGerais(d) do
    begin
    FWorkDir := edPasta.Text;

    FCul := edC.Text;
    FSol := edS.Text;
    FPre := edP.Text;
    FEto := edE.Text;
    FAsc := edA.Text;

    FInterval := Alltrim(edAnos.Text);
    if FInterval = '' then FInterval := '0';

    FLat := edLat.AsInteger;
    FLon := edLon.AsInteger;
    FAlt := edAlt.AsInteger;
    FAn  := edAn.AsInteger;

    FSemChuva := rbSemChuva.Checked;
    FComChuva := rbComChuva.Checked;
    FSeco     := rbSeco.Checked;
    FMedio    := rbMedio.Checked;
    FUmido    := rbUmido.Checked;

    FAlimento := cbAlimentos.ItemIndex;

    FTipoSistema := cbSistema.ItemIndex;

    FNatureza   := rbNatureza.Checked;
    FProdMax    := rbProdMax.Checked;
    FComDeficit := rbComDef.Checked;

    FNivelProb       := edProb.AsFloat;
    FArea            := edArea.AsFloat;
    FDiasDeIntervalo := edInt.AsInteger;
    FHorasOper       := edHorasOper.AsInteger;

    setLength(FRPLC, sgRPLC.ColCount);
    for i := 0 to sgRPLC.ColCount-1 do
      begin
      FRPLC[i].Ano := strToIntDef(sgRPLC.Cells[i, 0], 0);
      FRPLC[i].Val := sgRPLC.CellToReal(i, 1, b);
      end;

    setLength(FVPM, sgVPM.ColCount);
    for i := 0 to sgVPM.ColCount-1 do
      begin
      FVPM[i].Ano := strToIntDef(sgVPM.Cells[i, 0], 0);
      FVPM[i].Val := sgVPM.CellToReal(i, 1, b);
      end;

    setLength(FVPA, sgVPA.ColCount);
    for i := 0 to sgVPA.ColCount-1 do
      begin
      FVPA[i].Ano := strToIntDef(sgVPA.Cells[i, 0], 0);
      FVPA[i].Val := sgVPA.CellToReal(i, 1, b);
      end;
{
    setLength(FRendCultNI, sgRCNI.ColCount);
    for i := 0 to sgRCNI.ColCount-1 do
      begin
      FRendCultNI[i].Ano := strToIntDef(sgRCNI.Cells[i, 0], 0);
      FRendCultNI[i].Val := sgRCNI.CellToReal(i, 1, b);
      end;

    setLength(FRendCultI, sgRCI.ColCount);
    for i := 0 to sgRCI.ColCount-1 do
      begin
      FRendCultI[i].Ano := strToIntDef(sgRCI.Cells[i, 0], 0);
      FRendCultI[i].Val := sgRCI.CellToReal(i, 1, b);
      end;
}
    setLength(FRendPotCultNI, sgRPCNI.ColCount);
    for i := 0 to sgRPCNI.ColCount-1 do
      begin
      FRendPotCultNI[i].Ano := strToIntDef(sgRPCNI.Cells[i, 0], 0);
      FRendPotCultNI[i].Val := sgRPCNI.CellToReal(i, 1, b);
      end;

    setLength(FRendPotCultI, sgRPCI.ColCount);
    for i := 0 to sgRPCI.ColCount-1 do
      begin
      FRendPotCultI[i].Ano := strToIntDef(sgRPCI.Cells[i, 0], 0);
      FRendPotCultI[i].Val := sgRPCI.CellToReal(i, 1, b);
      end;
    end; // with TfoDadosGerais(d)

  ProcessInterval();
  FModified := true;
end;

procedure TCrop.PorDadosNoDialogo(d: TForm);
var i: Integer;
begin
  with TfoDadosGerais(d) do
    begin
    edPasta.Text := FWorkDir;
    edC.Text := FCul;
    edS.Text := FSol;
    edP.Text := FPre;
    edE.Text := FEto;
    edA.Text := FAsc;

    edAnos.Text := FInterval;
    edAnosExit(nil);

    edLat.AsInteger := FLat;
    edLon.AsInteger := FLon;
    edAlt.AsInteger := FAlt;
    edAn.AsInteger  := FAn;

    rbSemChuva.Checked := FSemChuva;
    rbComChuva.Checked := FComChuva;
    rbSeco.Checked     := FSeco;
    rbMedio.Checked    := FMedio;
    rbUmido.Checked    := FUmido;

    cbAlimentos.ItemIndex := FAlimento;
    cbAlimentosChange(nil);

    cbSistema.ItemIndex := FTipoSistema;
    cbSistemaChange(nil);

    rbNatureza.Checked := FNatureza;
    rbProdMax.Checked  := FProdMax;
    rbComDef.Checked   := FComDeficit;

    edProb.AsFloat        := FNivelProb;
    edArea.AsFloat        := FArea;
    edInt.AsInteger       := FDiasDeIntervalo;
    edHorasOper.AsInteger := FHorasOper;

    for i := 0 to High(FRPLC) do
      sgRPLC.Cells[i, 1] := SysUtilsEx.toString(FRPLC[i].Val, 2);

    for i := 0 to High(FVPM) do
      sgVPM.Cells[i, 1] := SysUtilsEx.toString(FVPM[i].Val, 2);

    for i := 0 to High(FVPA) do
      sgVPA.Cells[i, 1] := SysUtilsEx.toString(FVPA[i].Val, 2);
{
    for i := 0 to High(FRendCultNI) do
      sgRCNI.Cells[i, 1] := SysUtilsEx.toString(FRendCultNI[i].Val, 2);

    for i := 0 to High(FRendCultI) do
      sgRCI.Cells[i, 1] := SysUtilsEx.toString(FRendCultI[i].Val, 2);
}
    for i := 0 to High(FRendPotCultNI) do
      sgRPCNI.Cells[i, 1] := SysUtilsEx.toString(FRendPotCultNI[i].Val, 2);

    for i := 0 to High(FRendPotCultI) do
      sgRPCI.Cells[i, 1] := SysUtilsEx.toString(FRendPotCultI[i].Val, 2);
    end; // with foSimular
end;

procedure TCrop.ihc_Simular();
begin
  if FModified then Simulate();
end;

procedure TCrop.Release;
begin
  self.Free;
end;

procedure TCrop.ipr_setExePath(const ExePath: string);
begin
  FExeDir := ExePath;
end;

function TCrop.ToString(): wideString;
begin
  Result := 'Scenario of Demand: Isareg - Crop';
end;

constructor TCrop.Create();
begin
  inherited Create();
  FModified := true;
  FMessages := TfoMessages.Create();
  FManagements := TManagementList.Create(self);
  FAlimento := -1;
  getMessageManager.RegisterMessage(UM_Get_Lavouras, self);
  FForms := TObjectListEx.Create();
end;

destructor TCrop.Destroy();
begin
  getMessageManager.UnregisterMessage(UM_Get_Lavouras, self);
  FForms.Free();
  FMessages.Free();
  FManagements.Free();
  inherited;
end;

procedure TCrop.ihc_ObterErros(var Erros: TStrings);
begin
//  if Erros = nil then Erros := TStringList.Create();
//  Erros.AddStrings(FMessages);
end;

function TCrop.ihc_TemErros: boolean;
begin
  Result := (FErrorsCount > 0)
end;

procedure TCrop.ihc_ObterAcoesDeMenu(Acoes: TActionList);
begin
  CreateAction(Acoes, nil, 'Crop Manager ...', false, MenuShowVisualManager, self);
end;

procedure TCrop.ShowDataDialogEvent(Sender: TObject);
begin
  Edit();
end;

function TCrop.getFile(const Name: string; DelExt: boolean = true): string;
var ext: string;
begin
  Result := ExpandFileName(Name);
  ext := ExtractFileExt(Result);
  delete(ext, 1, 1);

  if FileExists(Result) then
     CopyFile(pChar(Result), pChar(IsaregDir + '\' + ext + '.' + ext), false)
  else
     AddError('File not found: '#13 + Result);

  if DelExt then
     Result := ext
  else
     Result := ext + '.' + ext;
end;

procedure TCrop.MenuRemoverRes(Sender: TObject);
begin
  Managements.Remove(TManagement(TComponent(Sender).Tag));
end;

function TCrop.icd_ObterValoresUnitarios(): TObject;
var r: TManagement;
begin
  r := Managements.Active();
  if r <> nil then
     Result := r.Reqs
  else
     Result := nil;
end;

procedure TCrop.MenuPlotarProdChuva(Sender: TObject);
begin
  Managements.Plot(tiProdChuva);
end;

procedure TCrop.MenuPlotarCoefChuvas(Sender: TObject);
begin
  Managements.Plot(tiCoefChuvas);
end;

procedure TCrop.MenuPlotarCoefConvPot(Sender: TObject);
begin
  Managements.Plot(tiCoefConvPot);
end;

procedure TCrop.MenuPlotarCoefConvReal(Sender: TObject);
begin
  Managements.Plot(tiCoefConvReal);
end;

procedure TCrop.MenuPlotarRendPotCultI(Sender: TObject);
begin
  Managements.Plot(tiRendPotCultI);
end;

procedure TCrop.MenuPlotarRendPotCultNI(Sender: TObject);
begin
  Managements.Plot(tiRendPotCultNI);
end;

function TCrop.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_Get_Lavouras then
     if self <> MSG.ParamAsObject(0) then
        TList(MSG.ParamAsObject(1)).Add(self);
end;

procedure TCrop.ipr_setObjectName(const Name: string);
begin
  FName := Name;
end;

const
  cErro0 = 'Invalid number of parameters';
  cErro1 = 'Invalid reference to management';
  cErro2 = 'Invalid management index';
  cErro3 = 'Invalid year';
  cErro4 = 'Property not defined';

function TCrop.icd_ObterValorFloat(const Propriedade: string): real;

    function ObterManejo(const Name: string): TManagement;
    var s: String;
        i: integer;
    begin
      s := SysUtilsEx.RigthStringOf(Name, '_');
      if s = '' then
         showException(cErro1 + ' <' + Name + '>')
      else
         begin
         i := strToIntDef(s, -1);
         if i = -1 then
            showException(cErro1 + ' <' + Name + '>')
         else
            begin
            if (i > -1) and (i < Managements.Count) then
               result := Managements.Item[i]
            else
               showException(cErro2 + ' <' + SysUtilsEx.toString(i) + '>')
            end;
         end;
    end;

    function getCropProp(const PropName: string): real;
    begin
      if CompareText(PropName, 'Area'                ) = 0 then result := self.FArea                              else
      if CompareText(PropName, 'Managements'         ) = 0 then result := self.Managements.Count                  else
      if CompareText(PropName, 'MinSysEff'           ) = 0 then result := self.EficienciaMinimaDoSistema()        else
      if CompareText(PropName, 'MaxSysEff'           ) = 0 then result := self.EficienciaMaximaDoSistema()        else
      if CompareText(PropName, 'MinInstCost'         ) = 0 then result := self.CustoMinimoDeInstalacaoPorHectar() else
      if CompareText(PropName, 'MaxInstCost'         ) = 0 then result := self.CustoMaximoDeInstalacaoPorHectar() else
      if CompareText(PropName, 'MinMainCost'         ) = 0 then result := self.CustoMinimoDeManutencaoPorHectar() else
      if CompareText(PropName, 'MaxMainCost'         ) = 0 then result := self.CustoMaximoDeManutencaoPorHectar() else
      if CompareText(PropName, 'FirstYear'           ) = 0 then result := self.FFirstYear                         else
      if CompareText(PropName, 'LastYear'            ) = 0 then result := self.FLastYear                          else
      if CompareText(PropName, 'Protein'             ) = 0 then result := self.Proteinas()                        else
      if CompareText(PropName, 'Fat'                 ) = 0 then result := self.Gorduras()                         else
      if CompareText(PropName, 'Calories'            ) = 0 then result := self.Calorias()                         else
      if CompareText(PropName, 'Calcium'             ) = 0 then result := self.Calcio()                           else
      if CompareText(PropName, 'OperationHoursPerDay') = 0 then result := self.OperationHoursPerDay               else
      if CompareText(PropName, 'Prob_Level'          ) = 0 then result := self.Prob_Level                         else
      if CompareText(PropName, 'IrrigatedArea_perDay') = 0 then result := self.IrrigatedArea_perDay               else
      if CompareText(PropName, 'IrrigationFrequency' ) = 0 then result := self.IrrigationFrequency                else
      if CompareText(PropName, 'BaseYield'           ) = 0 then result := self.BaseYield                          else
      if CompareText(PropName, 'CultivatedArea'      ) = 0 then result := self.CultivatedArea                     else
      if CompareText(PropName, 'NetIncome'           ) = 0 then result := self.NetIncome                          else
      if CompareText(PropName, 'FixedCost'           ) = 0 then result := self.FixedCost                          else
      if CompareText(PropName, 'VariableCost'        ) = 0 then result := self.VariableCost                       else
      if CompareText(PropName, 'Cost'                ) = 0 then result := self.Cost                               else
      if CompareText(PropName, 'TotalCost'           ) = 0 then result := self.TotalCost                          else
      if CompareText(PropName, 'Sys_FlowRate'        ) = 0 then result := self.Sys_FlowRate                       else
      if CompareText(PropName, 'Sys_PressureHead'    ) = 0 then result := self.Sys_PressureHead                   else
      if CompareText(PropName, 'Sys_Efficiency'      ) = 0 then result := self.Sys_Efficiency                     else
      if CompareText(PropName, 'Sys_PumpEffic'       ) = 0 then result := self.Sys_PumpEffic                      else
      if CompareText(PropName, 'Sys_Life'            ) = 0 then result := self.Sys_Life                           else
      if CompareText(PropName, 'Sys_IrrInstCost'     ) = 0 then result := self.Sys_IrrInstCost                    else
      if CompareText(PropName, 'Sys_IrrMainCost'     ) = 0 then result := self.Sys_IrrMainCost                    else
      if CompareText(PropName, 'Sys_IrrResVal'       ) = 0 then result := self.Sys_IrrResVal                      else
      if CompareText(PropName, 'Sys_AnualIR'         ) = 0 then result := self.Sys_AnualIR                        else
      if CompareText(PropName, 'WaterPrice'          ) = 0 then result := self.WaterPrice                         else
      if CompareText(PropName, 'EnergyPrice'         ) = 0 then result := self.EnergyPrice                        else
      if CompareText(PropName, 'Labor_Persons'       ) = 0 then result := self.Labor_Persons                      else
      if CompareText(PropName, 'Labor_CostHourly'    ) = 0 then result := self.Labor_CostHourly
      else
         showException(cErro4 + ' <' + PropName + '>');
    end;

    function getYearProp(Y: TYear; const PropName: string): real;
    var s: String;
    begin
      if System.Pos('demand', LowerCase(PropName)) > 0 then
         begin
         s := SysUtilsEx.SubString(PropName, '(', ')');
         if s = '' then
            showException('Error in Parameter: <' + PropName + '>')
         else
            result := Y.Demanda[strToIntDef(s, 0)];
         end
      else
         try
           result := Y.getPropValue(PropName);
         except
           showException(cErro4 + ' <' + PropName + '>');
         end;
    end;

var SL: TStrings;
    M: TManagement;
    A: TYear;
    i: integer;
    s1, s2, s3: string;
begin
  // Regra: Manejo_n.ano.Propriedade

  SL := nil;
  Split(Propriedade, SL, ['.']);

  // Erro
  if SL.Count = 0 then
     showException(cErro0 + ' <' + Propriedade + '>')
  else

  // 1 Parametro: Crop (propriedades da cultura)
  if SL.Count = 1 then
     result := getCropProp(SL[0])
  else

  // 2 Parametros: Manejo.Indice
  if SL.Count = 2 then
     begin
     M := ObterManejo(SL[0]);
     if CompareText(SL[1], 'BombOutlet'   ) = 0 then result := M.BombOutlet     else
     if CompareText(SL[1], 'MinBombOutlet') = 0 then result := M.MinBombOutlet
     else
        showException(cErro4 + ' <' + SL[1] + '>');
     end
  else

  // 3 Parametros: Manejo.Ano.Propriedade
  if SL.Count = 3 then
     begin
     s1 := SL[0];
     s2 := SL[1];
     s3 := SL[2];

     M := ObterManejo(s1);

     // Obtem o Ano
     i := strToIntDef(s2, -1);
     if i = -1 then
        showException(cErro3 + ' <' + s2 + '>')
     else
        begin
        A := M.Years.getYear(i);
        if A = nil then
           showException(cErro3 + ' <' + s2 + '>');
        end;

     result := getYearProp(A, s3);
     end

  else
     showException(cErro0 + ' <' + Propriedade + '>');
end;

function TCrop.icd_ObterValorString(const Propriedade: string): string;
begin
  // Nao ha propriedades String
  Result := '';
end;

procedure TCrop.showException(const Error: string);
begin
  raise Exception.Create(#13 +
                         'Objeto: ' + FName + #13 +
                         'Erro: ' + Error +
                         #13);
end;

procedure TCrop.ipr_setProjectPath(const ProjectPath: string);
begin
  FWorkDir := ProjectPath;
  if LastChar(FWorkDir) <> '\' then
     FWorkDir := FWorkDir + '\';
end;

function TCrop.getYearsAsString(): string;
var i: Integer;
begin
  for i := 0 to High(FVPA) do
    if i = 0 then
       result := SysUtilsEx.toString(FVPA[i].Ano)
    else
       result := result + '|' + SysUtilsEx.toString(FVPA[i].Ano);
end;

function TCrop.YieldToString(const r: TRendimentosAnuais): string;
var i: Integer;
begin
  for i := 0 to High(r) do
    if i = 0 then
       result := SysUtilsEx.toString(r[i].Val)
    else
       result := result + '|' + SysUtilsEx.toString(r[i].Val);
end;

procedure TCrop.StringToYield(const s: string; var r: TRendimentosAnuais; const Years: TIntArray);
var ar: TFloatArray;
     i: integer;
begin
  if Length(Years) > 0 then
     begin
     ar := StringToFloatArray(s, ['|']);
     if Length(ar) = Length(Years) then
        begin
        setLength(r, Length(ar));
        for i := 0 to High(r) do
          begin
          r[i].Ano := Years[i];
          r[i].Val := ar[i];
          end;
        end;
     end;
end;

function TCrop.getVecValue(const vetor: TRendimentosAnuais; ano: Integer): real;
var i: Integer;
begin
  result := 0;
  for i := 0 to High(vetor) do
    if vetor[i].Ano = ano then
       begin
       result := vetor[i].Val;
       break;
       end;
end;

{
function TCrop.RendimentoDaCultura(ano: Integer): real;
begin
  result := getVecValue(FRendCultNI, ano);
end;

function TCrop.RendimentoDaCulturaIrrigada(ano: Integer): real;
begin
  result := getVecValue(FRendCultI, ano);
end;
}

function TCrop.RendimentoPotDaCultura(ano: Integer): real;
begin
  result := getVecValue(FRendPotCultNI, ano);
end;

function TCrop.RendimentoPotDaCulturaIrrigada(ano: Integer): real;
begin
  result := getVecValue(FRendPotCultI, ano);
end;

function TCrop.RendimentoPotencialCalculado(ano: Integer): real;
begin
  result := getVecValue(FRPLC, ano);
end;

function TCrop.ValorProducaoAgropecuaria(ano: Integer): real;
begin
  result := getVecValue(FVPA, ano);
end;

function TCrop.ValorProdutoMercado(ano: Integer): real;
begin
  result := getVecValue(FVPM, ano);
end;

function TCrop.EficienciaMinimaDoSistema(): real;
begin
  result := cd_Classes.EficienciaMinimaDoSistema(FTipoSistema);
end;

function TCrop.EficienciaMaximaDoSistema(): real;
begin
  result := cd_Classes.EficienciaMaximaDoSistema(FTipoSistema);
end;

procedure TCrop.ProcessInterval();
var s1, s2: string;
begin
  if System.Pos('-', FInterval) > 0 then
     begin
     SysUtilsEx.SubStrings('-', s1, s2, FInterval, true);
     FFirstYear := strToIntDef(s1, -1);
     FLastYear := strToIntDef(s2, -1);
     end
  else
     begin
     FFirstYear := strToIntDef(FInterval, -1);
     FLastYear := strToIntDef(FInterval, -1);
     end;
end;

procedure TCrop.ihc_toXML(Buffer: TStrings; Ident: integer);
var x: TXML_Writer;
    i: Integer;
    s: string;
begin
  x := TXML_Writer.Create(Buffer, Ident);

  x.Write('interval', FInterval);

  x.Write('culFile', FCul);
  x.Write('solFile', FSol);
  x.Write('preFile', FPre);
  x.Write('etoFile', FEto);
  x.Write('ascFile', FAsc);

  x.Write('lat', FLat);
  x.Write('lon', FLon);
  x.Write('alt', FAlt);
  x.Write('ane', FAn);

  x.Write('withoutRain', FSemChuva);
  x.Write('withRain', FComChuva);

  x.Write('dry', FSeco);
  x.Write('mid', FMedio);
  x.Write('humid', FUmido);

  x.Write('foodType', FAlimento);
  x.Write('systemType', FTipoSistema);

  x.Write('nature', FNatureza);
  x.Write('maxProd', FProdMax);
  x.Write('withDeficit', FComDeficit);

  x.Write('ProbLevel', FNivelProb);
  x.Write('area', FArea);
  x.Write('irrigationInterval', FDiasDeIntervalo);
  x.Write('operationTime', FHorasOper);

  // Tabelas
  x.Write('years', getYearsAsString());
  x.Write('CCE',   YieldToString(FRPLC));
  x.Write('APV',   YieldToString(FVPA));
  x.Write('MPV',   YieldToString(FVPM));
  x.Write('NICP',  YieldToString(FRendPotCultNI));
  x.Write('ICP',   YieldToString(FRendPotCultI));

  // Estimativas Economicas da Cultura
  x.Write('ec_V' , FVariableCost);
  x.Write('ec_PB', Fc_BY);
  x.Write('ec_L' , Fc_NI );
  x.Write('ec_AC', Fc_CA);
  x.Write('ec_F' , FFixedCost);

  // Estimativas Economicas do Sistema
  x.Write('es_M' , Fs_MCost);
  x.Write('es_AM', Fs_PH);
  x.Write('es_VR', Fs_RV);
  x.Write('es_R' , Fs_PE);
  x.Write('es_VU', Fs_Life);
  x.Write('es_I' , Fs_ICost);
  x.Write('es_V' , Fs_FR);
  x.Write('es_E' , Fs_Effic);

  // Outras Estimativas Economicas
  x.Write('eo_PA' , Fs_WP);
  x.Write('eo_NP' , Fo_L_PN);
  x.Write('eo_PE' , Fo_EP);
  x.Write('eo_C'  , Fo_L_CH );
  x.Write('es_TJA', Fs_IR);

  Managements.toXML(x);

  x.Free();
end;

procedure TCrop.ihc_fromXML(no: IXMLDOMNode);
var i : Integer;
    cn: IXMLDOMNodeList;
    n : IXMLDOMNode;
    ia: TIntArray;
begin
  if no.attributes.length = 0 then
     FxmlVersion := 1
  else
     if no.attributes.length = 1 then
        FxmlVersion := toInt(no.attributes.item[0].text);

  cn := no.childNodes;

  FInterval := allTrim(cn.nextNode().text);
  if FInterval = '' then FInterval := '0';

  FCul  := cn.nextNode().text;
  FSol  := cn.nextNode().text;
  FPre  := cn.nextNode().text;
  FEto  := cn.nextNode().text;
  FAsc  := cn.nextNode().text;

  if FxmlVersion < 5 then
     begin
     // jump managements node
     n := cn.nextNode();

     // jump restrictions node
     n := cn.nextNode();
     end;

  FLat := toInt(cn.nextNode().text);
  FLon := toInt(cn.nextNode().text);
  FAlt := toInt(cn.nextNode().text);
  FAn  := toInt(cn.nextNode().text);

  FSemChuva := toBoolean(cn.nextNode().text);
  FComChuva := toBoolean(cn.nextNode().text);

  FSeco  := toBoolean(cn.nextNode().text);
  FMedio := toBoolean(cn.nextNode().text);
  FUmido := toBoolean(cn.nextNode().text);

  if FxmlVersion >= 2 then
     FAlimento := toInt(cn.nextNode().text)
  else
     FAlimento := -1;

  FTipoSistema := toInt(cn.nextNode().text);

  FNatureza   := toBoolean(cn.nextNode().text);
  FProdMax    := toBoolean(cn.nextNode().text);
  FComDeficit := toBoolean(cn.nextNode().text);

  if FxmlVersion >= 8 then
     FNivelProb := toFloat(cn.nextNode().text);

  FArea            := toFloat(cn.nextNode().text);
  FDiasDeIntervalo := toInt(cn.nextNode().text);
  FHorasOper       := toInt(cn.nextNode().text);

  // Tabelas
  ia := StringToIntArray (cn.nextNode().text, ['|']);
  StringToYield (cn.nextNode().text, FRPLC, ia);
  StringToYield (cn.nextNode().text, FVPA, ia);
  StringToYield (cn.nextNode().text, FVPM, ia);

  if FxmlVersion < 10 then
     begin
     // pula 2 sub-nos (Rendimento Irrigado e nao Irrigado da cultura)
     cn.nextNode();
     cn.nextNode();
     end;

  if FxmlVersion >= 6 then
     begin
     StringToYield (cn.nextNode().text, FRendPotCultNI, ia);
     StringToYield (cn.nextNode().text, FRendPotCultI, ia);
     end;

  if FxmlVersion = 9 then
     cn.nextNode();  // Pula o custo da Lavoura

  if FxmlVersion >= 7 then
     begin
     // Estimativas Economicas da Cultura
     FVariableCost := toFloat(cn.nextNode().text);
     Fc_BY         := toFloat(cn.nextNode().text);

     if FxmlVersion < 10 then
        begin
        cn.nextNode(); // pula 1 no (Valor de Mercado)
        cn.nextNode(); // pula 1 no (Rendimento da Cultura)
        end;

     Fc_NI      := toFloat(cn.nextNode().text);
     Fc_CA      := toFloat(cn.nextNode().text);
     FFixedCost := toFloat(cn.nextNode().text);

     // Estimativas Economicas do Sistema
     Fs_MCost := toFloat(cn.nextNode().text);
     Fs_PH    := toFloat(cn.nextNode().text);
     Fs_RV    := toFloat(cn.nextNode().text);
     Fs_PE    := toFloat(cn.nextNode().text);
     Fs_Life  := toFloat(cn.nextNode().text);
     Fs_ICost := toFloat(cn.nextNode().text);
     Fs_FR    := toFloat(cn.nextNode().text);

     if FxmlVersion >= 11 then
        Fs_Effic := toFloat(cn.nextNode().text);

     // Outras Estimativas Economicas
     Fs_WP   := toFloat(cn.nextNode().text);
     Fo_L_PN := toFloat(cn.nextNode().text);
     Fo_EP   := toFloat(cn.nextNode().text);
     Fo_L_CH := toFloat(cn.nextNode().text);

     // Interent Rate - Passou para sistema
     Fs_IR := toFloat(cn.nextNode().text);
     end;

  // Managements
  Managements.FromXML( cn.nextNode() );

  ProcessInterval();
  FModified := true;
end;

procedure TCrop.MenuRemoverManejos(Sender: TObject);
begin
  if MessageDLG('Are you sure ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     FManagements.Clear();
end;

procedure TCrop.MenuPlotarCCC(Sender: TObject);
begin
  FManagements.Plot(tiChuva);
end;

procedure TCrop.MenuPlotarLIC(Sender: TObject);
begin
  FManagements.Plot(tiLIC);
end;

procedure TCrop.MenuPlotarQPI(Sender: TObject);
begin
  FManagements.Plot(tiQ);
end;

function TCrop.Calcio(): real;
begin
  result := cd_Classes.Calcio(FAlimento);
end;

function TCrop.Calorias(): integer;
begin
  result := cd_Classes.Calorias(FAlimento);
end;

function TCrop.Gorduras(): integer;
begin
  result := cd_Classes.Gorduras(FAlimento);
end;

function TCrop.Proteinas(): integer;
begin
  result := cd_Classes.Proteinas(FAlimento);
end;

{
Versao  1: Primeira Versao
Versao  2: Adicao do tipo de Alimento Produzido (FAlimento)
Versao  3: Nao Lembro !!!
Versao  4: Mais info. sobre as fases de culturas
Versao  5: Desconsideracao dos arquivos de manejo e restricao
Versao  6: Inclusao dos valores potencias para as culturas Irr. e nao Irr.
Versao  7: Estimadores Economicos
Versao  8: Nivel de Probabilidade
Versao  9: Custo da Lavoura
Versao 10: Eliminacao dos rendimentos das culturas
Versao 11: Insercao da Eficiencia do Sistema
Versao 12: Leitura completa da tabela de frequencias
}
function TCrop.ihc_getXMLVersion(): integer;
begin
  result := 12;
end;

procedure TCrop.ShowVisualManager();
begin
  with TfoMain.Create(self) do
    begin
    FTree := frTree.Tree;
    ShowModal();
    Release();
    FTree := nil;
    end;
end;

procedure TCrop.MenuShowVisualManager(Sender: TObject);
begin
  ShowVisualManager();
end;

procedure TCrop.ShowInTree(Tree: TTreeView);
var i: Integer;
    n1: TTreeNode;
begin
  n1 := AddNode(Tree, nil, '', -1, self);

  // Managements
  FManNode := AddNode(Tree, n1, 'Managements', ciFolder);
  for i := 0 to FManagements.Count-1 do
    FManagements.Item[i].ShowInTree(Tree, FManNode);

  FManNode.Expand(false);
end;

function TCrop.getNodeText(): string;
begin
  result := FName;
end;

function TCrop.canEdit(): boolean;
begin
  result := true;
end;

procedure TCrop.executeDefaultAction();
begin
  Edit();
end;

procedure TCrop.getActions(Actions: TActionList);
var Act1, Act2, Act3 : TAction;
    i: integer;
    Management: TManagement;
begin
  Act1 := CreateAction(Actions, nil, 'Edit', false, nil, self);
          CreateAction(Actions, Act1, 'General Data ...', false, ShowDataDialogEvent, self);
          CreateAction(Actions, Act1, 'Economical Data ...', false, SimulateEE_Event, nil);

  CreateAction(Actions, nil, 'Simulate New Management ...', false, NewManagementEvent, self);

  if FManagements.Count > 0 then
     begin
     CreateAction(Actions, nil, '-', false, nil, nil);
     CreateAction(Actions, nil, 'Remove All Managements ...', false, MenuRemoverManejos, nil);
     CreateAction(Actions, nil, '-', false, nil, nil);

     Act1 := CreateAction(Actions, nil, 'Analysis', false, nil, nil);
       Act2 := CreateAction(Actions, Act1, 'Graphics', false, nil, nil);

          Act3 := CreateAction(Actions, Act2, 'Productivity', false, nil, nil);

             // Somente acessivel no manejo nao irrigado
             CreateAction(Actions, Act3, 'Rain Water Productivity ...', false, MenuPlotarProdChuva, nil);

             if FManagements.Count > 1 then
                // Somente acessivel nos manejos irrigados
                begin
                CreateAction(Actions, Act3, 'Rain + Irrigation Water Productivity ...', false, MenuPlotarIrrRainWaterProductivity, nil);
                CreateAction(Actions, Act3, 'Irrigation Water Productivity using ETa ...', false, MenuPlotarIWP_ETA, nil);
                CreateAction(Actions, Act3, 'Irrigation Water Productivity using IrrDepth ...', false, MenuPlotarIWP_ID, nil);
                end;

             CreateAction(Actions, Act3, 'Nutritional Water Productivity ...', false, MenuPlotarNWP, nil);
             CreateAction(Actions, Act3, 'Economical Water Productivity ...', false, MenuPlotarEWP, nil);
             CreateAction(Actions, Act3, 'Marginal Productivity ...', false, MenuPlotarMP, nil);
             CreateAction(Actions, Act3, 'Practicable Productivity ...', false, MenuPlotarPP, nil);

          Act3 := CreateAction(Actions, Act2, 'Costs', false, nil, nil);
             CreateAction(Actions, Act3, 'Energy Cost ...', false, MenuPlotarEC, nil);
             CreateAction(Actions, Act3, 'Water Cost ...', false, MenuPlotarWC, nil);

          Act3 := CreateAction(Actions, Act2, 'Yields', false, nil, nil);
             CreateAction(Actions, Act3, 'Potential Rainfed Crop Yield ...', false, MenuPlotarRendPotCultNI, nil);
             CreateAction(Actions, Act3, 'Potential Irrigated Crop Yield  ...', false, MenuPlotarRendPotCultI, nil);

          Act3 := CreateAction(Actions, Act2, 'Rainfall Coefficient', false, nil, nil);
             CreateAction(Actions, Act3, 'Rainfall Actual Conversion Coefficient ...', false, MenuPlotarCoefConvReal, nil);
             CreateAction(Actions, Act3, 'Rainfall Potential Conversion Coefficient ...', false, MenuPlotarCoefConvPot, nil);
             CreateAction(Actions, Act3, 'Rainfall Distribution Coefficient ...', false, MenuPlotarCoefChuvas, nil);

          Act3 := CreateAction(Actions, Act2, 'Others', false, nil, nil);
             CreateAction(Actions, Act3, 'Rainfall During the Crop Cycle ...', false, MenuPlotarCCC, nil);
             CreateAction(Actions, Act3, 'Yield Loss ...', false, MenuPlotarQPI, nil);
             CreateAction(Actions, Act3, 'Irrigation Depth ...', false, MenuPlotarLIC, nil);
             CreateAction(Actions, Act3, 'Gross Water Volume ...', false, MenuPlotarVTA, nil);
             CreateAction(Actions, Act3, 'Raw Margin of Profit ...', false, MenuPlotarMarBruta, nil);
             CreateAction(Actions, Act3, 'Liquid Profit ...', false, MenuPlotarLP, nil);
             CreateAction(Actions, Act3, 'Net Profit ...', false, MenuPlotarRev, nil);
             CreateAction(Actions, Act3, 'Total Raw Revenue ...', false, MenuPlotarTRR, nil);

       Act2 := CreateAction(Actions, Act1, 'Economical Viability', false, nil, nil);
          Act3 := CreateAction(Actions, Act2, 'Spreadsheets', false, nil, nil);
             CreateAction(Actions, Act3, 'Average Indicators', false, Plan_IM_Event, nil);
             CreateAction(Actions, Act3, 'Global Indicators in the Area', false, Plan_Totais_Event, nil);
             CreateAction(Actions, Act3, 'Sensibility Analysis', false, Plan_AS_Event, nil);

          Act3 := CreateAction(Actions, Act2, 'Graphics', false, nil, nil);
             CreateAction(Actions, Act3, 'Average Net Return per Management', false, MenuPlotarLL_Medio, nil);
             CreateAction(Actions, Act3, 'Standard Deviation of Net Return per Management', false, MenuPlotarSTDNR, nil);
             CreateAction(Actions, Act3, 'Critical Land Productivity per Management', false, MenuPlotarPLIOL_Medio, nil);
     end;
end;

function TCrop.getImageIndex(): integer;
begin
  result := ciFarming;
end;

procedure TCrop.setEditedText(var Text: string);
begin
  Text := SysUtilsEx.getValidID(Text);
  FName := Text;
end;

procedure TCrop.NewManagementEvent(Sender: TObject);
var d: TfoSel_Man_Res;
begin
  d := TfoSel_Man_Res.Create(self);
  try
    if d.ShowModal() = mrOk then
       begin
       FMan := d.edMan.Text;
       FRes := d.edRes.Text;
       Simulate();
       end;
  finally
    d.Free();
  end;  
end;

procedure TCrop.Edit();
var d: TfoDadosGerais;
begin
  d := TfoDadosGerais.Create(nil);
  try
    PorDadosNoDialogo(d);
    if d.ShowModal() = mrOk then
       PegarDadosDoDialogo(d);
  finally
    d.Release();
  end;
end;

function TCrop.TestIsaregDir(): boolean;
begin
  result := true;
  if not DirectoryExists(IsaregDir) then
     if not ForceDirectories(IsaregDir) then
        begin
        result := false;
        AddError('Directory "' + IsaregDir + '" can not be create.'#13 +
                 'Verify your rights or create manualy this directory.');
        end;
end;

procedure TCrop.AddError(const aMessage: string);
begin
  inc(FErrorsCount);
  FMessages.Add(etError, aMessage);
  FMessages.Show();
end;

procedure TCrop.AddWarning(const aMessage: string);
begin
  FMessages.Add(etWarning, aMessage);
  FMessages.Show();
end;

procedure TCrop.ClearMessages();
begin
  FErrorsCount := 0;
  FMessages.Clear();
end;

function TCrop.CustoMaximoDeInstalacaoPorHectar(): integer;
begin
  result := cd_Classes.CustoMaximoDeInstalacaoPorHectar(FTipoSistema);
end;

function TCrop.CustoMaximoDeManutencaoPorHectar(): integer;
begin
  result := cd_Classes.CustoMaximoDeManutencaoPorHectar(FTipoSistema);
end;

function TCrop.CustoMinimoDeInstalacaoPorHectar(): integer;
begin
  result := cd_Classes.CustoMinimoDeInstalacaoPorHectar(FTipoSistema);
end;

function TCrop.CustoMinimoDeManutencaoPorHectar(): integer;
begin
  result := cd_Classes.CustoMinimoDeManutencaoPorHectar(FTipoSistema);
end;

procedure TCrop.SimulateEE_Event(Sender: TObject);
var d: TfoEstimativasEconomicas;
begin
  d := TfoEstimativasEconomicas.Create(self);
  d.ShowModal();
  d.Free;
end;

procedure TCrop.Plan_IM_Event(Sender: TObject);
begin
  MostrarIndicadoresMedios();
end;

procedure TCrop.Plan_AS_Event(Sender: TObject);
begin
  MostrarAnaliseDeSensibilidade();
end;

procedure TCrop.Plan_Totais_Event(Sender: TObject);
begin
  MostrarTotaisMedios();
end;

procedure TCrop.MostrarIndicadoresMedios();
var p: TSpreadSheetBook;
    i: integer;
begin
  p := TSpreadSheetBook.Create('Average Indicators', 'Managements');
  AddResult(p);

  p.ActiveSheet.Merge(1,  1, 3,  1);
  p.ActiveSheet.Merge(1,  2, 3,  2);
  p.ActiveSheet.Merge(1,  3, 3,  3);
  p.ActiveSheet.Merge(1,  4, 3,  4);
  p.ActiveSheet.Merge(1,  5, 3,  5);
  p.ActiveSheet.Merge(1,  6, 2,  7);
  p.ActiveSheet.Merge(1,  8, 3,  8);
  p.ActiveSheet.Merge(1,  9, 3,  9);
  p.ActiveSheet.Merge(1, 10, 3, 10);

  // Primeira Linha
  p.ActiveSheet.WriteCenter(1, 01, 'Management');
  p.ActiveSheet.WriteCenter(1, 02, 'Raw Irr. Depth (m3/ha)');
  p.ActiveSheet.WriteCenter(1, 03, 'Yield Loss (%)');
  p.ActiveSheet.WriteCenter(1, 04, 'Total Cost ($/ha)');
  p.ActiveSheet.WriteCenter(1, 05, 'Raw Margin of Profit ($/ha)');
  p.ActiveSheet.WriteCenter(1, 06, 'Liquid Net Profit ($/ha)');
  p.ActiveSheet.WriteCenter(1, 08, 'Lim. Prod. f/ Net Profit (kg/ha)');
  p.ActiveSheet.WriteCenter(1, 09, 'Marginal Productivity (%)');

  // Liquid Net Profit
  p.ActiveSheet.WriteCenter(3, 06, 'Normal');
  p.ActiveSheet.WriteCenter(3, 07, 'StdDev');

  p.ActiveSheet.WordWrap(1, 02);
  p.ActiveSheet.WordWrap(1, 03);
  p.ActiveSheet.WordWrap(1, 04);
  p.ActiveSheet.WordWrap(1, 05);
  p.ActiveSheet.WordWrap(1, 06);
  p.ActiveSheet.WordWrap(1, 07);
  p.ActiveSheet.WordWrap(1, 08);
  p.ActiveSheet.WordWrap(1, 09);
  p.ActiveSheet.WordWrap(1, 10);

  p.ActiveSheet.BoldRow(1);
  p.ActiveSheet.BoldRow(2);
  p.ActiveSheet.BoldRow(3);

  for i := 0 to Managements.Count-1 do
    begin
    p.ActiveSheet.WriteCenter(i+4, 1, i+1); // Indice do Manejo
    Managements.Item[i].MostrarIndicadoresMedios(p, i+4);
    end;

  p.Show();
end;

procedure TCrop.MostrarAnaliseDeSensibilidade();
begin
  with TfoAnaliseDeSens.Create(self) do
     ShowModal();
end;

procedure TCrop.MostrarTotaisMedios();
var p: TSpreadSheetBook;
    i: integer;
begin
  p := TSpreadSheetBook.Create('Totals Indicators in the Area', 'Managements');
  AddResult(p);

  p.ActiveSheet.Merge(1,  1, 2,  1);
  p.ActiveSheet.Merge(1,  2, 1,  3);
  p.ActiveSheet.Merge(1,  4, 2,  4);
  p.ActiveSheet.Merge(1,  5, 2,  5);
  p.ActiveSheet.Merge(1,  6, 2,  6);

  // Primeira Linha
  p.ActiveSheet.WriteCenter(1, 01, 'Management');
  p.ActiveSheet.WriteCenter(1, 02, 'Total Cost');
  p.ActiveSheet.WriteCenter(1, 04, 'Total Production (kg)');
  p.ActiveSheet.WriteCenter(1, 05, 'Total Volume (m3)');
  p.ActiveSheet.WriteCenter(1, 06, 'Total Net Profit ($)');

  p.ActiveSheet.WordWrap(1, 04);
  p.ActiveSheet.WordWrap(1, 05);
  p.ActiveSheet.WordWrap(1, 06);

  // Segunda Linha
  p.ActiveSheet.RowHeight[2] := 40;
  p.ActiveSheet.WriteCenter(2, 02, 'Crop ($)');
  p.ActiveSheet.WriteCenter(2, 03, 'Irrigation ($)');

  p.ActiveSheet.BoldRow(1);
  p.ActiveSheet.BoldRow(2);

  for i := 0 to Managements.Count-1 do
    begin
    p.ActiveSheet.WriteCenter(i+3, 1, i+1); // Indice do Manejo
    Managements.Item[i].MostrarTotaisMedios(p, i+3);
    end;

  p.Show();
end;

procedure TCrop.MenuPlotarMarBruta(Sender: TObject);
begin
  FManagements.Plot(tiMargemBruta);
end;

procedure TCrop.MenuPlotarProdTot(Sender: TObject);
begin
  FManagements.Plot(tiProdTotal);
end;

procedure TCrop.MenuPlotarRScul(Sender: TObject);
begin
  FManagements.Plot(tiRendSimCult);
end;

procedure TCrop.MenuPlotarVTA(Sender: TObject);
begin
  FManagements.Plot(tiVolTotAgua);
end;

procedure TCrop.MenuPlotarLL_Medio(Sender: TObject);
begin
  FManagements.Plot(ti_Med_LL);
end;

procedure TCrop.MenuPlotarPLIOL_Medio(Sender: TObject);
begin
  FManagements.Plot(ti_Med_PLIOL);
end;

procedure TCrop.AcaoNaoImplementada(Sender: TObject);
begin
  //
end;

function TCrop.getCC(): real;
begin
  result := FFixedCost + FVariableCost;
end;

function TCrop.getTCC(): real;
begin
  result := getCC() * Fc_CA;
end;

procedure TCrop.AddResult(Result: TObject);
begin
  FForms.Add(Result);
end;

procedure TCrop.MenuPlotarEC(Sender: TObject);
begin
  FManagements.Plot(tiEnergyCost);
end;

procedure TCrop.MenuPlotarEWP(Sender: TObject);
begin
  FManagements.Plot(tiEWP);
end;

procedure TCrop.MenuPlotarLP(Sender: TObject);
begin
  FManagements.Plot(tiLiquidProfit);
end;

procedure TCrop.MenuPlotarMP(Sender: TObject);
begin
  FManagements.Plot(tiMarginalProductivity);
end;

procedure TCrop.MenuPlotarNWP(Sender: TObject);
begin
  FManagements.Plot(tiNWP);
end;

procedure TCrop.MenuPlotarPP(Sender: TObject);
begin
  FManagements.Plot(tiPracticableProductivity);
end;

procedure TCrop.MenuPlotarRev(Sender: TObject);
begin
  FManagements.Plot(tiRevenue);
end;

procedure TCrop.MenuPlotarTRR(Sender: TObject);
begin
  FManagements.Plot(tiTotalRawRevenue);
end;

procedure TCrop.MenuPlotarWC(Sender: TObject);
begin
  FManagements.Plot(tiWaterCost);
end;

procedure TCrop.MenuPlotarSTDNR(Sender: TObject);
begin
  FManagements.Plot(ti_STD_NetReturn);
end;

procedure TCrop.MenuPlotarIrrRainWaterProductivity(Sender: TObject);
begin
  FManagements.Plot(tiIrrRainWaterProductivity);
end;

procedure TCrop.MenuPlotarIWP_ETA(Sender: TObject);
begin
  FManagements.Plot(tiIrrWaterProductivity_ETA);
end;

procedure TCrop.MenuPlotarIWP_ID(Sender: TObject);
begin
  FManagements.Plot(tiIrrWaterProductivity_ID);
end;

{ TYearZoom }

procedure TYearZoom.GenerateIsaregFiles();
var sl: TStrings;
     c: TCrop;
     m: TManagement;
begin
  c := FYear.Management.Crop;
  m := FYear.Management;

  if not c.TestIsaregDir() then Exit;

  SysUtils.DeleteFile(c.ExeDir + 'erros.txt');
  SysUtils.DeleteFile(IsaregDir + 'sai.mes');
  SysUtils.DeleteFile(IsaregDir + 'sai.sai');
  SysUtils.DeleteFile(IsaregDir + 'sai.fas');
  SysUtils.DeleteFile(IsaregDir + 'sai.irr');
  SysUtils.DeleteFile(IsaregDir + 'sai.dbl');
  SysUtils.DeleteFile(IsaregDir + 'sai.dhu');

  SetCurrentDir(c.WorkDir);

  sl := TStringList.Create();
  sl.Add('');
  sl.Add(c.getFile(c.Cul_File));
  sl.Add(c.getFile(c.Sol_File));
  sl.Add(c.getFile(c.Eto_File));
  sl.Add(c.getFile(c.Pre_File));
  sl.Add('sai');
  sl.Add(toString(FYear.Year));
  sl.Add(c.getFile(m.Management_File));

  if m.Restriction_File = '' then
     sl.Add('N')
  else
     sl.Add(c.getFile(m.Restriction_File));

  if c.FAsc = '' then
     sl.Add('N')
  else
     sl.Add(c.getFile(c.Asc_File));

  sl.SaveToFile(IsaregDir + '\Batch.reg');
  sl.Free();
end;

procedure TYearZoom.LoadIsaregResults();
begin
  Load_DBL(IsaregDir + '\SAI.DBL');
  Load_DHU(IsaregDir + '\SAI.DHU');
end;

procedure TYearZoom.Simulate();
var p: TIsaregProcess;
begin
  FYear.Management.Crop.ClearMessages();
  GenerateIsaregFiles();
  if not FYear.Management.Crop.HasErrors then
     begin
     p := TIsaregProcess.Create(FYear.Management.Crop.FExeDir);
     try
       p.Execute();
       LoadIsaregResults();
     finally
       p.Free();
       end;
     end;
end;

constructor TYearZoom.Create(Year: TYear);
begin
  inherited Create();
  FYear := Year;
  FTitle := 'Zoom';
  Simulate();
end;

function TYearZoom.canEdit(): boolean;
begin
  Result := true;
end;

procedure TYearZoom.executeDefaultAction();
begin
  ShowDataEvent(self);
end;

procedure TYearZoom.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Show Results', false, ShowDataEvent, nil);
end;

function TYearZoom.getImageIndex(): integer;
begin
  result := ciZoom;
end;

function TYearZoom.getNodeText(): string;
begin
  result := FTitle;
end;

procedure TYearZoom.setEditedText(var Text: string);
begin
  FTitle := Text;
end;

function TYearZoom.ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
begin
  result := AddNode(Tree, ParentNode, '', -1, self);
  // ... campos
end;

// Faz a leitura dos Volumes do solo e das
// Capacides de Campo e Pontos de Rendimento Otimos
procedure TYearZoom.Load_DBL(const Filename: string);
var DBL: TStrings;

    procedure ProcessFile();
    var L: TStrings;
        i: integer;
        x: TSoilVolume;
        y: TFC_OYP;
    begin
      L := nil;
      if DBL.Count = 0 then Exit;

      // Cabecalho
      Split(DBL[0], L, [' ']);
      FMonth := toInt(L[1]);
      FIndicator := toInt(L[2]);

      // Volumes do Solo
      i := 1;
      while true do
        begin
        Split(DBL[i], L, [' ']);
        if L.Count = 3 then
           begin
           x := TSoilVolume.Create();
           x.Day := toFloat(L[0], -1);
           x.Volume := toFloat(L[1], -1);
           x.Indicator := toInt(L[2], -1);
           if (x.Day > -1) then
              FSoilVolume_List.Add(x)
           else
              begin
              x.Free();
              Break;
              end;
           end;
        inc(i);
        if i = DBL.Count then Exit;
        end; // while

      // Cap. de campo e Linha de rendimento otimo
      inc(i, 2);
      while i < DBL.Count do
        begin
        Split(DBL[i], L, [' ']);
        if L.Count = 3 then
           begin
           y := TFC_OYP.Create();
           y.Day := toFloat(L[0], -1);
           y.FC := toFloat(L[1], -1);
           y.OYP := toFloat(L[2], -1);
           FFC_OYP_List.Add(y);
           end;
        inc(i);
        end; // while
    end; // ProcessFile

begin
  if FileExists(Filename) then
     begin
     FSoilVolume_List := TSoilVolume_List.Create();
     FFC_OYP_List     := TFC_OYP_List.Create();

     DBL := LoadTextFile(Filename);
     ProcessFile();
     end
  else
     FYear.Management.Crop.AddError(
       'File <' + Filename + '> not found');
end;

procedure TYearZoom.Load_DHU(const Filename: string);
var DHU: TStrings;

    procedure ProcessFile();
    var L: TStrings;
        i: integer;
        x: T5C;
    begin
      L := nil;
      if DHU.Count = 0 then Exit;

      // 1. Bloco
      i := 1;
      while true do
        begin
        Split(DHU[i], L, [' ']);
        if L.Count = 5 then
           begin
           x := T5C.Create();
           x.c1 := toFloat(L[0], -1);
           x.c2 := toFloat(L[1], -1);
           x.c3 := toFloat(L[2], -1);
           x.c4 := toFloat(L[3], -1);
           x.c5 := toFloat(L[4], -1);
           if (x.c1 > -1) then
              F5C_List.Add(x)
           else
              begin
              x.Free();
              Break;
              end;
           end;
        inc(i);
        if i = DHU.Count then Exit;
        end; // while
    end; // ProcessFile

begin
  if FileExists(Filename) then
     begin
     F5C_List := T5C_List.Create();
     DHU := LoadTextFile(Filename);
     ProcessFile();
     end
  else
     FYear.Management.Crop.AddError(
       'File <' + Filename + '> not found');
end;

destructor TYearZoom.Destroy();
begin
  FSoilVolume_List.Free();
  FFC_OYP_List.Free();
  F5C_List.Free();
  inherited;
end;

procedure TYearZoom.ShowDataEvent(Sender: TObject);
var p: TSpreadSheetBook;
begin
  p := TSpreadSheetBook.Create(FTitle + ' - Zoom Data', 'Soil Volume');
  FYear.FManagement.FCrop.AddResult(p);

  if FSoilVolume_List <> nil then
     FSoilVolume_List.ShowInSheet(p.ActiveSheet);

  p.NewSheet('FC - OYL');
  if FFC_OYP_List <> nil then
     FFC_OYP_List.ShowInSheet(p.ActiveSheet);

  p.NewSheet('1.Block of DHU file');
  if F5C_List <> nil then
     F5C_List.ShowInSheet(p.ActiveSheet);

  p.Show();
end;

end.
