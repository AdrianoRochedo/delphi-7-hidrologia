unit cd_Classes;

{
  Informacoes sobre versoes:
    - Quando houver mudanca, adicao ou remocao de dados, ajustar: ihc_getXMLVersion()
    - Para testar a versao do arquivo, utilize Lavoura.FxmlVersion
}


interface
uses classes,
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
     FileUtils,
     TreeViewUtils,
     MessageManager,
     wsFuncoesDeEscalares,
     wsConstTypes,
     wsVec,
     wsMatrix,
     cd_ClassesBase;

type
  TYear = class;
  TCulture = class;
  TManagement = class;

  TYearZoom = class(TBase)
  private
    FYear: TYear;
    FTitle: string;

    // ITreeNode interface
    function getImageIndex(): integer; override;
    function canEdit(): boolean; override;
    function getNodeText(): string; override;
    procedure setEditedText(var Text: string); override;
    procedure executeDefaultAction(); override;
    procedure getActions(Actions: TActionList); override;

    function ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
  public
    constructor Create(Year: TYear);

    property Title : string read FTitle write FTitle;
  end;

  // Dados sobre um ano de Management
  TYear = class(TBase)
  private
    // Lavoura que gerou estes dados
    FCulture: TCulture;

    // Manejo que gerou este ano
    FManagement: TManagement;

    // Fases de irrigação
    FFases: TFases;

    // Zoom Temporal
    FZoom: TYearZoom;

    // Dados gerais e indices calculados
    FEsq        : integer;
    FYear       : integer;
    FIrrigado   : boolean;

    FCCCP       : real;
    FRPcul      : real;
    FETa        : real;
    FCCC        : real;
    FQ          : real;
    FPR_CHU     : real;
    FChuva      : real;
    FCC         : real;
    FII_P       : real;
    FETm        : real;
    FPR_CHU_IRR : real;
    FLIC        : real;

    // ITreeNode interface
    function getImageIndex(): integer; override;
    function canEdit(): boolean; override;
    function getNodeText(): string; override;
    procedure executeDefaultAction(); override;
    procedure getActions(Actions: TActionList); override;

    // Eventos
    procedure ZoomEvent(Sender: TObject);

    procedure LerFases(Arquivo: TStrings; var PosicaoArquivo: integer);
    function ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;

    function getRCul(): real;
    function getRCulI(): real;
    function getRPLC: real;
    function getVPA: real;
    function getVPM: real;
    function getDemanda(Mes: integer): real;
  public
    constructor Create(Irrigado: boolean; Culture: TCulture);
    destructor Destroy(); override;

    procedure CalcularIndices();
    procedure MostrarDados(Saida: TStrings);

    procedure SaveToFile(Ini: TMemIniFile; const Section: string; varIndex: Integer);
    procedure LoadFromFile(Ini: TMemIniFile; const Section: string; varIndex: Integer);
    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDomNode);

    // -- PROPRIEDADES CALCULADAS -----------------------------------------

    // Ano da Cultura
    property Year : integer read FYear write FYear;

    // Esquema de rega utilizado
    property Esquema : integer read FEsq write FEsq;

    // Rendimento Potencial Local Calculado
    // RPLC = Culture.RendimentoPotencialCalculado(Ano)
    property RPLC : real read getRPLC;

    // Valor do Produto no Mercado
    // VPM = Culture.ValorProdutoMercado(Ano)
    property VPM : real read getVPM;

    // Valor da Produção Agropecuária
    // VPA = Culture.ValorProducaoAgropecuaria(Ano)
    property VPA : real read getVPA;

    // Rendimento da cultura nao irrigada
    // Rcul = Culture.RendimentoDaCultura(Ano);
    property Rcul : real read getRcul;

    // Rendimento da cultura Irrigada
    // RCulI = Culture.RendimentoDaCulturaIrrigada(Ano)
    property RculI : real read getRculI;

    // Produtividade da Chuva
    // PR_CHU = Rcul / ETa / 10
    property PR_CHU : real read FPR_CHU;

    // Rendimento Potencial da Cultura
    // RPcul = RculI / (1-FQ)  --> para culturas irrigadas
    // RPcul = Rcul  / (1-FQ)  --> para culturas não irrigadas
    property RPcul : real read FRPcul;

    // Coeficiente de Conversao de Chuva
    // CCC = ETa / Chuva
    property CCC : real read FCCC;

    // Coeficiente de Conversao de Chuva Potencial
    // CCCP = ETm / Chuva
    property CCCP : real read FCCCP;

    // Coeficiente de Chuva
    // CC = CCCP - CCC;
    property CC : real read FCC;

    // Evapotranspiracao Real da Cultura nao Irrigada
    property ETa : real read FETa write FETa;

    // Evapotranspiracao Potencial da Cultura
    property ETm : real read FETm write FETm;

    // Quebra de Producao Estimada
    property Q : real read FQ write FQ;

    // Chuva no Ciclo da cultura
    property Chuva : real read FChuva write FChuva;

    // -- SOMENTE CULTURAS IRRIGADAS --------------------------------------

    // Lamina de Irrigacao no Ciclo
    property LIC : real read FLIC write FLIC;

    // Produtividade Total da Agua com Irrigacao
    // PR_Chu_IRR = Rcul / ETa / 10
    property PR_CHU_IRR : real read FPR_CHU_IRR;

    // Intervalos (dias) de Irrigacao de Pico
    property II_P : real read FII_P write FII_P;

    //Obtem a demanda de um mes
    property Demanda[Mes: integer] : real read getDemanda;
  end;

  // Dados sobre os anos de um manejo
  TYearList = class
  private
    FCulture: TCulture;
    FManagement: TManagement;
    FList: TObjectList;
    function getNumAnos: integer;
    function getItem(i: integer): TYear;
  public
    constructor Create(Culture: TCulture);
    destructor Destroy();

    procedure Adicionar(Item: TYear);
    function NovoAno(Irrigado: boolean; Management: TManagement): TYear;
    function ObterAno(Ano: integer): TYear;
    procedure MostrarDados(Saida: TStrings);

    procedure SaveToFile(Ini: TMemIniFile; const Section: string);
    procedure LoadFromFile(Ini: TMemIniFile; const Section: string);
    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDomNode);

    property NumAnos : integer read getNumAnos;
    property Item[i: integer] : TYear read getItem;
  end;

  TManagement = class(TBase, IMessageReceptor)
  private
    FCulture    : TCulture;
    FManagement : string;
    FRestricoes : string;
    FAtivado    : boolean;
    FIrrigado   : boolean;
    FLA         : TYearList;

    FReqs       : TwsDataset;
    FReqs_MI    : byte;     // mes Inicial
    FReqs_MF    : byte;     // mes Final
    FReqs_CMA   : boolean;  // o ciclo esta em um mesmo ano

    FVU_80 : real;
    FVB_18 : real;
    FVB_SI : real;

    // Janelas criadas por esta instância
    FForms: TObjectList;

    destructor Destroy(); override;

    // ITreeNode interface
    function getNodeText(): string; override;
    function getImageIndex(): integer; override;
    function canEdit(): boolean; override;
    procedure executeDefaultAction(); override;
    procedure getActions(Actions: TActionList); override;

    // Eventos
    procedure RemoveEvent(Sender: TObject);
    procedure AtivarEvent(Sender: TObject);
    procedure VisGraficoDasDemandasEvent(Sender: TObject);

    function ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
    function ReceiveMessage(const MSG: TadvMessage): Boolean;
    function getDesc(): string;
    function getVB_18: real;
    function getVB_SI: real;
  public
    constructor Create(const Management, Restricoes: string; Culture: TCulture);

    procedure SaveToFile(Ini: TMemIniFile; const Section: string);
    procedure LoadFromFile(Ini: TMemIniFile; const Section: string);
    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDomNode);

    // Arquivos de saida
    // Verificar estes métodos para saber quais propriedades são
    // lidas de arquivo.
    procedure LerIRR(const Nome: string);
    procedure LerFAS(const Nome: string);

    procedure MostrarDados();

    // Graficos
    procedure MostrarGraficoDasDemandas();

    // Culture a que pertence este resultado
    property Culture : TCulture read FCulture;

    // Descrição do manejo
    property Descricao : string  read getDesc;

    // Indica se o manejo está ativo
    // Esta indicação é feita do usuário
    property Ativado : boolean read FAtivado write FAtivado;

    // Indica se o manejo é irrigado
    // <<< Verificar este esquema
    property Irrigado : boolean read FIrrigado write FIrrigado;

    // Representa os anos de simulação
    property Anos : TYearList read FLA;

    // Necessidades de Demanda
    property Reqs : TwsDataSet read FReqs;

    // Mes inicial da cultura
    property MesInicialDaCultura : byte read FReqs_MI;

    // Mes final da cultura
    property MesFinalDaCultura : byte read FReqs_MF;

    // Retorna se o intervalo da cultura esta dentro de um mesmo ano
    property CicloDeUmAno : boolean read FReqs_CMA;

    // Vazao Unitaria a 80%
    property VU_80 : real read FVU_80;

    // Vazao da Bomba a 18 horas/dia
    // VB_18 = (VU_80 / Culture.EficienciaDoSistema) * 3.6 * 1.333
    property VB_18 : real read getVB_18;

    // Vazao Bomba do Sistema de Irrigacao
    // VB_SI = VB_18 * CultureLavoura.Area
    property VB_SI : real read getVB_SI;
  end;

  TTipoGrafico = (tiProdChuva, tiRendPotCultNI, tiRendPotCultI, tiCoefConvReal,
                  tiCoefConvPot, tiCoefChuvas, tiQ, tiChuva, tiPR_ChuvaIrr,
                  tiLIC);

  TManagementList = class
  private
    FCulture: TCulture;
    FList: TObjectList;
    function getCount: Integer;
    function getItem(i: integer): TManagement;
  public
    constructor Create(Culture: TCulture);
    destructor Destroy(); override;

    procedure Adicionar(Management: TManagement);
    procedure Remover(Management: TManagement);
    procedure Ativar(Management: TManagement);

    procedure Clear();

    procedure SaveToFile(Ini: TMemIniFile; const Section: string);
    procedure LoadFromFile(Ini: TMemIniFile; const Section: string);
    procedure toXML(x: TXML_Writer);
    procedure fromXML(no: IXMLDOMNode);

    // Visualizacao de resultados
    procedure Plotar(Tipo: TTipoGrafico);

    // Se nao existe resultado ativado entao retorna o primeiro
    function  ResultadoAtivo(): TManagement;

    property Count : Integer read getCount;
    property Item[i: integer] : TManagement read getItem;
  end;

  TCulture = class(TBase, ICenarioDemanda, IMessageReceptor)
  private
    FNome        : string;
    FTemErro     : Boolean;
    FErros       : TStrings;
    FExePath     : string;
    FModificado  : boolean;
    FxmlVersion  : integer;

    // Quando diferente de nil indica que o gerenciador esta ativo
    FTree: TTreeView;

    // Nodes - Somente ativos enquanto o gerenciador visual estiver ativo
    FNode_Manejos: TTreeNode;

    // Diretorio de trabalho
    FWorkDir : ShortString;

    // Arquivos
    FCul : string;
    FSol : string;
    FPre : string;
    FEto : string;
    FAsc : string;
    FMan : string;
    FRes : string;

    //FManInd        : integer;
    //FManFiles      : TStrings;
    //FResInd        : integer;
    //FResFiles      : TStrings;

    // Geral
    FAnos : string;  // 1987 ou 2000-2003
    FAnoInicial: integer;
    FAnoFinal: integer;

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
    FArea       : real;
    FIntervalos : integer;
    FHorasOper  : integer;

    // Tabelas anuais
    FRendCultNI   : TRendimentosAnuais; // Nao irrigada
    FRendCultI    : TRendimentosAnuais; // Irrigada
    FVPM          : TRendimentosAnuais;
    FVPA          : TRendimentosAnuais;
    FRPLC         : TRendimentosAnuais;

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
    procedure NewManagementEvent(Sender: TObject);
    procedure ShowDataDialogEvent(Sender: TObject);

    procedure MenuShowVisualManager(Sender: TObject);
    procedure MenuRemoverManejos(Sender: TObject);
    procedure MenuVisRes(Sender: TObject);
    procedure MenuRemoverRes(Sender: TObject);
    procedure MenuPlotarProdChuva(Sender: TObject);
    procedure MenuPlotarRendPotCultNI(Sender: TObject);
    procedure MenuPlotarRendPotCultI(Sender: TObject);
    procedure MenuPlotarCoefConvReal(Sender: TObject);
    procedure MenuPlotarCoefConvPot(Sender: TObject);
    procedure MenuPlotarCoefChuvas(Sender: TObject);
    procedure MenuPlotarQPI(Sender: TObject);
    procedure MenuPlotarCCC(Sender: TObject);
    procedure MenuPlotarPTAI(Sender: TObject);
    procedure MenuPlotarLIC(Sender: TObject);

    // Separa os anos em ano Inicial e Final
    procedure ProcessaAnos();

    // Obtem a lista de anos. Ex: 1990|1991|1992...
    function  ObtemAnos(): string;

    function  RendimentoToString(const r: TRendimentosAnuais): string;
    procedure StringToRendimento(const s: string; var r: TRendimentosAnuais; const anos: TIntArray);
    function  ObterValorDoVetor(const vetor: TRendimentosAnuais; ano: Integer): real;

    // Obtem o nome curto do arquivo
    function getShortName(const Name: string; DelExt: boolean = true): string;

    procedure ObterValor_Erro(const Erro: string);
    procedure GerarArquivosDoIsareg();
    procedure LerResultadosDoIsareg();
    procedure setErro(const Erro: string);
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
    procedure ihc_LerDoArquivo(Ini: TMemIniFile; const Section: string);
    procedure ihc_SalvarEmArquivo(Ini: TMemIniFile; const Section: string);
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

    procedure Edit();
    procedure ShowVisualManager();
    procedure ShowInTree(Tree: TTreeView);

    // Tabelas
    // Retorna os valores anuais entrados pelo usuário
    function RendimentoDaCultura          (ano: Integer): real;
    function RendimentoDaCulturaIrrigada  (ano: Integer): real;
    function ValorProdutoMercado          (ano: Integer): real;
    function ValorProducaoAgropecuaria    (ano: Integer): real;
    function RendimentoPotencialCalculado (ano: Integer): real;

    // Retornas as informações nutricionais do alimento selecionado
    function Calorias(): integer;
    function Proteinas(): integer;
    function Gorduras(): integer;
    function Calcio(): real;

    // Retorna a eficiencia do sistema dependendo do
    // sistema de irrigação empregado (usuário)
    function EficienciaDoSistema(): real;

    // Retorna o custo de produção em dolares dependento do
    // sistema de irrigação empregado (usuário)
    function CustoPorHectar(): integer;

    procedure PorDadosNoDialogo(d: TForm);
    procedure PegarDadosDoDialogo(d: TForm);

    procedure Simular();
    procedure MostrarErros();

    // Nome dados ao objeto no Propagar
    property Nome : string read FNome;

    // Diretorio de trabalho
    property WorkDir : ShortString read FWorkDir write FWorkDir;

    property TemErros : Boolean read ihc_TemErros;

    // Lista dos Manejos
    property Managements : TManagementList read FManagements;
  end;

  // Sistema de Irrigação
  function EficienciaDoSistema (TipoSistema: integer): real;
  function CustoPorHectar (TipoSistema: integer): integer;

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
     cd_Form_Dados,
     cd_Form_Resultados,
     cd_GR_Demandas,
     cd_GR_Indices,
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

function EficienciaDoSistema(TipoSistema: integer): real;
begin
  case TipoSistema of
    0: result := 0.9;
    1: result := 0.8;
    2: result := 0.6;
    3: result := 0.5;
    else
       result := 0.0;
  end;
end;

function CustoPorHectar(TipoSistema: integer): integer;
begin
  case TipoSistema of
    0: result := 2000;
    1: result := 1500;
    2: result := 800;
    3: result := 500;
    else
       result := 0;
  end;
end;

{ TManagement }

constructor TManagement.Create(const Management, Restricoes: string; Culture: TCulture);
begin
  inherited Create();
  FCulture := Culture;
  FManagement := Management;
  FRestricoes := Restricoes;
  FLA := TYearList.Create(FCulture);
  FLA.FManagement := self;
  FForms := TObjectList.Create(false);
  getMessageManager.RegisterMessage(UM_FormDestroy, self);
end;

destructor TManagement.Destroy;
var i: Integer;
begin
  getMessageManager.UnRegisterMessage(UM_FormDestroy, self);
  for i := 0 to FForms.Count-1 do FForms[i].Free();
  FForms.Free();
  FLA.Free();
  inherited;
end;

function TManagement.getDesc(): string;
begin
  Result := FManagement;

  if FRestricoes <> '' then
     Result := Result + ' x ' + FRestricoes;

  if not FIrrigado then
     Result := Result + ' (Sem Irrigação)';
end;

procedure TManagement.LoadFromFile(Ini: TMemIniFile; const Section: string);
begin
  with Ini do
    begin
    FManagement   := readString (Section, 'Manejo', '');
    FRestricoes   := readString (Section, 'Restricoes', '');
    FAtivado      := readBool   (Section, 'Ativado', false);
    FVU_80        := readFloat  (Section, 'VU_80', 0);
    Irrigado      := readBool   (Section, 'ComIrrigacao', false);

    FLA.LoadFromFile(Ini, Section);

    FReqs := TwsDataSet.Load(Ini, Section + ' - Reqs');
    end;
end;

procedure TManagement.SaveToFile(Ini: TMemIniFile; const Section: string);
begin
  with Ini do
    begin
    writeString (Section, 'Manejo',       FManagement);
    writeString (Section, 'Restricoes',   FRestricoes);
    writeBool   (Section, 'Ativado',      FAtivado);
    writeFloat  (Section, 'VU_80',        FVU_80);
    writeBool   (Section, 'ComIrrigacao', Irrigado);

    FLA.SaveToFile(Ini, Section);

    FReqs.Save(Ini, Section + ' - Reqs');
    end;
end;

procedure TManagement.LerIRR(const Nome: string);
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
        FReqs := TwsDataset.CreateNumeric('Requerimentos', 0, 12, true);
        for i := anoIni - byte(not FReqs_CMA) to anoFim do
          FReqs.AddRow(toString(i));

        inc(L);

        // Lê as necessidades anuais
        for i := anoIni to anoFim do
          if Locate(toString(i), SL, L) then
             begin
             StringToStrings(SL[L+4], Meses, [' ']);

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
     if ano.Esquema <> 5 then
        begin
        Locate('B2:', SL, L);
        Dec(L, 2);
        ano.LIC := strToFloatDef(AllTrim(SL[L]), wscMissValue);
        end;
   end;

   procedure LerB2(var L: integer; ano: TYear);
   begin
     inc(L, 7);
     ano.Chuva := strToFloatDef(AllTrim(SL[L]), wscMissValue);
   end;

   procedure LerB3(var L: integer; ano: TYear);
   begin
     inc(L);
     ano.ETm := strToFloatDef(AllTrim(SL[L]), wscMissValue);

     inc(L);
     ano.ETa := strToFloatDef(AllTrim(SL[L]), wscMissValue);

     inc(L, 2);
     ano.Q := strToFloatDef(AllTrim(SL[L]), wscMissValue) / 100;
   end;

   procedure LerB4(var L: integer; ano: TYear);
   begin
     inc(L, 3);
     ano.II_P := strToFloatDef(AllTrim(SL[L]), wscMissValue);
   end;

   procedure LerAnaliseFrequencial(L: integer);
   var s: string;
   begin
     if Locate('ANÁLISE FREQUENCIAL', SL, L) then
        begin
        inc(L, 23);
        s := System.copy(SL[L], 13, 6);
        FVU_80 := strToFloatDef(AllTrim(s), wscMissValue);
        end;
   end;

   procedure LerSimulacao(LI, LF: integer);
   var L: Integer;
       s: shortString;
       ano: TYear;
   begin
     //dialogs.ShowMessage(format('Simulacao: %d - %d', [LI, LF]));

     L := LI + 1;

     ano := self.Anos.NovoAno(FIrrigado, self);

         ano.Year    := toInt(SL[L], 6, 4, false, -1);
         ano.Esquema := toInt(SL[L], 2, 1, false, -1);

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

     ano.CalcularIndices();  
   end;

var i, k: integer;
    Blocos: array of record LI, LF: integer; end;
begin
  try
    if FileExists(Nome) then
       try
         SL := TStringList.Create();
         SL.LoadFromFile(Nome);

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

procedure TManagement.MostrarDados();
var d: TfoResultados;
begin
  d := TfoResultados.Create(self);
  d.Show();
  FForms.Add(d);
end;

procedure TManagement.MostrarGraficoDasDemandas();
var d: TfoGR_Demandas;
begin
  d := TfoGR_Demandas.Create(self);
  d.Show();
  FForms.Add(d);
end;

function TManagement.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
begin
  i := FForms.Remove(MSG.ParamAsObject(0));
end;

procedure TManagement.LerFAS(const Nome: string);
var SL : TStrings;
    i, PosicaoArquivo : integer;
begin
  if FileExists(Nome) then
     try
       PosicaoArquivo := 0;
       SL := SysUtilsEx.LoadFile(Nome);
       for i := 0 to Anos.NumAnos-1 do
         Anos.Item[i].LerFases(SL, {var} PosicaoArquivo);
     finally
       SL.Free();
     end;
end;

function TManagement.getVB_18(): real;
begin
  Result := ScalarDiv(FVU_80, FCulture.EficienciaDoSistema() ) * 3.6 * 1.333;
end;

function TManagement.getVB_SI(): real;
begin
  Result := getVB_18() * FCulture.FArea;
end;

procedure TManagement.toXML(x: TXML_Writer);
begin
  x.beginTag('management');
    x.beginIdent();

    x.Write('management_File', FManagement);
    x.Write('Restriction_File', FRestricoes);
    x.Write('Activate', FAtivado);
    x.Write('UO_80', FVU_80);
    x.Write('Irrigate', Irrigado);

    x.Write('Reqs_MI', FReqs_MI);
    x.Write('Reqs_MF', FReqs_MF);
    x.Write('Reqs_CMA', FReqs_CMA);

    FLA.toXML(x);
    FReqs.ToXML(x.Buffer, x.IdentSize);

    x.endIdent();
  x.endTag('management');
end;

procedure TManagement.fromXML(no: IXMLDomNode);
var i : Integer;
    cn: IXMLDOMNodeList;
    n : IXMLDOMNode;
begin
  cn := no.childNodes;

  FManagement     := cn.nextNode().text;
  FRestricoes := cn.nextNode().text;
  FAtivado    := toBoolean(cn.nextNode().text);
  FVU_80      := toFloat(cn.nextNode().text);
  Irrigado    := toBoolean(cn.nextNode().text);

  if FCulture.FxmlVersion > 2 then
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
  CreateAction(Actions, nil, 'Ativar', false, AtivarEvent, nil);
  CreateAction(Actions, nil, 'Remover', false, RemoveEvent, nil);
  if FIrrigado then
     CreateAction(Actions, nil, 'Visualizar Gráfico das Demandas ...', false,
                  VisGraficoDasDemandasEvent, nil);
end;

function TManagement.getImageIndex(): integer;
begin
  if FAtivado then
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
  if Dialogs.MessageDLG('Tem Certeza ?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     FCulture.Managements.Remover(Self);
end;

procedure TManagement.AtivarEvent(Sender: TObject);
begin
  FCulture.Managements.Ativar(self);
  FTreeNode.TreeView.Refresh();
end;

procedure TManagement.VisGraficoDasDemandasEvent(Sender: TObject);
begin
  MostrarGraficoDasDemandas();
end;

function TManagement.ShowInTree(Tree: TTreeView; ParentNode: TTreeNode): TTreeNode;
var k: Integer;
begin
  result := AddNode(Tree, ParentNode, '', -1, self);
  FTreeNode := result;

  // Anos
  for k := 0 to FLA.NumAnos-1 do
    FLA.Item[k].ShowInTree(Tree, result);
end;

{ TManagementList }

constructor TManagementList.Create(Culture: TCulture);
begin
  inherited Create();
  FCulture := Culture;
  FList := TObjectList.Create(true);
end;

destructor TManagementList.Destroy();
begin
  getMessageManager.SendMessage(UM_ObjectDestroy, [self]);
  FList.Free();
  inherited Destroy();
end;

procedure TManagementList.Adicionar(Management: TManagement);
begin
  Management.Irrigado := (FList.Count > 0);
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

procedure TManagementList.Ativar(Management: TManagement);
var i: Integer;
    r: TManagement;
begin
  for i := 0 to getCount()-1 do
    begin
    r := getItem(i);
    r.Ativado := (r = Management);
    end;
end;

// Se nao existe resultado ativado entao retorna o primeiro
function TManagementList.ResultadoAtivo(): TManagement;
var i: Integer;
begin
  Result := nil;
  for i := 0 to getCount()-1 do
    if getItem(i).Ativado then
       begin
       Result := getItem(i);
       break;
       end;

  if (Result = nil) and (getCount() > 0) then
     begin
     Result := getItem(0);
     Result.Ativado := true;
     end;
end;

procedure TManagementList.Remover(Management: TManagement);
begin
  FList.Remove(Management);
end;

procedure TManagementList.Plotar(Tipo: TTipoGrafico);
var d: TfoGR_Indices;
begin
  d := TfoGR_Indices.Create(self, Tipo);
  d.Show();
end;

procedure TManagementList.LoadFromFile(Ini: TMemIniFile; const Section: string);
var i: Integer;
    Management: TManagement;
begin
  with Ini do
    begin
    i := readInteger(Section, 'Resultados', 0);
    for i := 0 to i-1 do
      begin
      Management := TManagement.Create('xx', 'yy', FCulture);
      Management.LoadFromFile(Ini, Section + ' - Resultado_' + toString(i));
      Adicionar(Management);
      end;
    end;
end;

procedure TManagementList.SaveToFile(Ini: TMemIniFile; const Section: string);
var i: Integer;
begin
  with Ini do
    begin
    writeInteger(Section, 'Resultados', getCount());
    for i := 0 to getCount()-1 do
      getItem(i).SaveToFile(Ini, Section + ' - Resultado_' + toString(i));
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
    Management := TManagement.Create('xx', 'yy', FCulture);
    Management.fromXML(no.childNodes.item[i]);
    Adicionar(Management);
    end;
end;

procedure TManagementList.Clear();
begin
  FList.Clear();
end;

{ TYearList }

constructor TYearList.Create(Culture: TCulture);
begin
  inherited Create();
  FCulture := Culture;
  FList := TObjectList.Create(true);
end;

destructor TYearList.Destroy();
begin
  FList.Free();
  inherited Destroy();
end;

procedure TYearList.Adicionar(Item: TYear);
begin
  FList.Add(Item);
end;

function TYearList.getNumAnos(): integer;
begin
  Result := FList.Count;
end;

function TYearList.getItem(i: integer): TYear;
begin
  Result := TYear(FList[i]);
end;

function TYearList.NovoAno(Irrigado: boolean; Management: TManagement): TYear;
begin
  Result := TYear.Create(Irrigado, FCulture);
  Result.FManagement := Management;
  self.Adicionar(Result);
end;

procedure TYearList.MostrarDados(Saida: TStrings);
var i: Integer;
begin
  for i := 0 to FList.Count-1 do
    begin
    if i > 0 then Saida.Add('');
    getItem(i).MostrarDados(Saida);
    end;
end;

procedure TYearList.LoadFromFile(Ini: TMemIniFile; const Section: string);
var i: Integer;
    ano: TYear;
begin
  i := Ini.readInteger(Section, 'NumAnos', 0);
  for i := 0 to i-1 do
    begin
    ano := self.NovoAno(false, FManagement);
    ano.LoadFromFile(ini, Section, i);
    end;
end;

procedure TYearList.SaveToFile(Ini: TMemIniFile; const Section: string);
var i: Integer;
begin
  Ini.WriteInteger(Section, 'NumAnos', getNumAnos());
  for i := 0 to getNumAnos()-1 do
    getItem(i).SaveToFile(ini, Section, i);
end;

function TYearList.ObterAno(Ano: integer): TYear;
var i: Integer;
begin
  for i := 0 to getNumAnos()-1 do
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
    for i := 0 to getNumAnos()-1 do
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
    ano := self.NovoAno(false, FManagement);
    ano.fromXML(no.childNodes.item[i]);
    end;
end;

{ TYear }

procedure TYear.LoadFromFile(Ini: TMemIniFile; const Section: string; varIndex: Integer);
var s, s2: string;
    k: integer;
begin
  s := toString(varIndex);
  with Ini do
    begin
    FYear      := readInteger (Section, 'Ano_'   + s, 0);
    FEsq       := readInteger (Section, 'Esq_'   + s, 0);
    FIrrigado  := readBool    (Section, 'Irr_'   + s, false);
    FETa       := readFloat   (Section, 'ETa_'   + s, 0);
    FETm       := readFloat   (Section, 'ETm_'   + s, 0);
    FQ         := readFloat   (Section, 'Q_'     + s, 0);
    FChuva     := readFloat   (Section, 'ChT_'   + s, 0);
    FLIC       := readFloat   (Section, 'LIC_'   + s, 0);
    FII_P      := readFloat   (Section, 'II_P_'  + s, 0);

    // Fases
    k := readInteger (Section, 'NumFases_' + s, 0);
    setLength(FFases, k);
    for k := 0 to k-1 do
      begin
      s2 := s + '_' + toString(k+1);

      FFases[k].Irrigacao := readFloat  (Section, 'FAS_Irrigacao_' + s2, -1);
      FFases[k].Excesso   := readFloat  (Section, 'FAS_Excesso_'   + s2, -1);
      FFases[k].Inicio    := readString (Section, 'FAS_Inicio_'    + s2, 'ND');
      FFases[k].Fim       := readString (Section, 'FAS_Fim_'       + s2, 'ND');
      FFases[k].ETm       := readFloat  (Section, 'FAS_ETm_'       + s2, -1);
      FFases[k].ETa       := readFloat  (Section, 'FAS_ETa_'       + s2, -1);
      end;
    end;

  CalcularIndices();
end;

procedure TYear.SaveToFile(Ini: TMemIniFile; const Section: string; varIndex: Integer);
var s, s2: string;
    k: integer;
begin
  s := toString(varIndex);
  with Ini do
    begin
    writeInteger (Section, 'Ano_'   + s, FYear);
    writeInteger (Section, 'Esq_'   + s, FEsq);
    writeBool    (Section, 'Irr_'   + s, FIrrigado);
    writeFloat   (Section, 'ETa_'   + s, FETa);
    writeFloat   (Section, 'ETm_'   + s, FETm);
    writeFloat   (Section, 'Q_'     + s, FQ);
    writeFloat   (Section, 'ChT_'   + s, FChuva);
    writeFloat   (Section, 'LIC_'   + s, FLIC);
    writeFloat   (Section, 'II_P_'  + s, FII_P);

    // Fases
    writeInteger (Section, 'NumFases_' + s, Length(FFases));
    for k := 0 to High(FFases) do
      begin
      s2 := s + '_' + toString(k+1);

      writeFloat  (Section, 'FAS_Irrigacao_' + s2, FFases[k].Irrigacao);
      writeFloat  (Section, 'FAS_Excesso_'   + s2, FFases[k].Excesso);
      writeString (Section, 'FAS_Inicio_'    + s2, FFases[k].Inicio);
      writeString (Section, 'FAS_Fim_'       + s2, FFases[k].Fim);
      writeFloat  (Section, 'FAS_ETm_'       + s2, FFases[k].ETm);
      writeFloat  (Section, 'FAS_ETa_'       + s2, FFases[k].ETa);
      end;
    end;
end;

procedure TYear.MostrarDados(Saida: TStrings);
var s: string;
    k: integer;
begin
  Saida.Add('  Ano: ' + toString(FYear) + '  Esquema: ' + toString(FEsq));
  Saida.Add('');

  Saida.Add('  Evapotranspiração Real da Cultura (ETa): .................... ' + toString(FETa));
  Saida.Add('  Evapotranspiração Potencial da Cultura (ETm): ............... ' + toString(FETm));
  Saida.Add('  Quebra de Produção Estimada (Q): ............................ ' + toString(FQ));
  Saida.Add('  Rendimento Potencial da Cultura (RPCul): .................... ' + toString(FRPcul));
  Saida.Add('  Rendimento Potencial da Cultura Calculado (RPculCal): ....... ' + toString(getRPLC));

  if not FIrrigado then
     begin
     Saida.Add('  Rendimento da Cultura (Rcul): ............................... ' + toString(getRCul));
     Saida.Add('  Chuva no Ciclo da Cultura (ChT): ............................ ' + toString(FChuva));
     Saida.Add('  Produtividade da Chuva (PR_CHU): ............................ ' + toString(FPR_CHU));
     Saida.Add('  Coeficiente de Conversão de Chuva (CCC): .................... ' + toString(FCCC));
     Saida.Add('  Coeficiente de Conversão de Chuva Potencial (CCCP): ......... ' + toString(FCCCP));
     Saida.Add('  Coeficiente de Chuva (CC): .................................. ' + toString(FCC));
     end
  else
     begin
     Saida.Add('  Eficiência do Sistema de Irrigação (Ei): .................... ' + toString(FCulture.EficienciaDoSistema()));
     Saida.Add('  Rendimento da Cultura Irrigada (RculI): ..................... ' + toString(getRCulI));
     Saida.Add('  Lâmina de Irrigação no Ciclo (LIC): ......................... ' + toString(FLIC));
     Saida.Add('  Produtividade Total da Água de Irrigação (PR_CHU_IRR): ...... ' + toString(FPR_CHU_IRR));
     Saida.Add('  Intervalos de Irrigação de Pico (II_P): ..................... ' + toString(FII_P));

     Saida.Add('');
     Saida.Add('  FASES:');
     Saida.Add('');

     // Fases       5           17        27                 46       53
     Saida.Add('    Irrigação   Excesso       Periodo        ETm      ETa');
     for k := 0 to High(FFases) do
       begin
       s := '    ' +
            LeftStr(toString(FFases[k].Irrigacao, 2), 12) +
            LeftStr(toString(FFases[k].Excesso, 2), 12) +
            LeftStr(FFases[k].Inicio + ' a ' + FFases[k].Fim, 17) +
            LeftStr(toString(FFases[k].ETm, 2), 09) +
            toString(FFases[k].ETa, 2);

       Saida.Add(s);
       end;
     end;
end;

constructor TYear.Create(Irrigado: boolean; Culture: TCulture);
begin
  inherited Create();
  FIrrigado := Irrigado;
  FCulture := Culture;
end;

procedure TYear.LerFases(Arquivo: TStrings; var PosicaoArquivo: integer);
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

procedure TYear.CalcularIndices();
var rCul: real;
begin
  rCul := getRCul();
  if FIrrigado then
     begin
     FRPcul      := ScalarDiv(getRCulI, 1-FQ);
     FPR_Chu_IRR := ScalarDiv(rCul, FETa) / 10;
     end
  else
     begin
     FRPcul  := ScalarDiv(rCul, 1-FQ);
     FPR_CHU := ScalarDiv(rCul, FETa) / 10;
     FCCC    := ScalarDiv(FETa, FChuva);
     FCCCP   := ScalarDiv(FETm, FChuva);
     FCC     := FCCCP - FCCC;
     end;
end;

function TYear.getRCul(): real;
begin
  result := FCulture.RendimentoDaCultura(FYear);
end;

function TYear.getRCulI(): real;
begin
  result := FCulture.RendimentoDaCulturaIrrigada(FYear);
end;

function TYear.getRPLC(): real;
begin
  result := FCulture.RendimentoPotencialCalculado(FYear);
end;

function TYear.getVPA(): real;
begin
  result := FCulture.ValorProducaoAgropecuaria(FYear);
end;

function TYear.getVPM(): real;
begin
  result := FCulture.ValorProdutoMercado(FYear);
end;

function TYear.getDemanda(Mes: integer): real;
begin
  if (Mes > 0) and (Mes < 13) then
     try
       result := FManagement.Reqs[FYear - FCulture.FAnoInicial + 1, Mes];
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
  x.beginTag('data', ['year', 'manType'], [FYear, FEsq]);
    x.beginIdent();

    x.Write('Irr', FIrrigado);
    x.Write('ETa', FETa);
    x.Write('ETm', FETm);
    x.Write('Q', FQ);
    x.Write('ChT', FChuva);
    x.Write('LIC', FLIC);
    x.Write('II_P', FII_P);

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

  FYear := toInt(no.attributes.item[0].text);
  FEsq := toInt(no.attributes.item[1].text);

  FIrrigado := toBoolean(cn.nextNode.text);
  FETa      := toFloat(cn.nextNode.text);
  FETm      := toFloat(cn.nextNode.text);
  FQ        := toFloat(cn.nextNode.text);
  FChuva    := toFloat(cn.nextNode.text);
  FLIC      := toFloat(cn.nextNode.text);
  FII_P     := toFloat(cn.nextNode.text);

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

    if FCulture.FxmlVersion > 3 then
       begin
       FFases[i].PRE := toFloat(cn2.nextNode.text);
       FFases[i].R   := toFloat(cn2.nextNode.text);
       FFases[i].ASC := toFloat(cn2.nextNode.text);
       end;
    end;

  CalcularIndices();
end;

function TYear.canEdit: boolean;
begin
  result := false;
end;

procedure TYear.executeDefaultAction();
begin

end;

procedure TYear.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Simular Zoom Temporal', false, ZoomEvent, nil);
end;

function TYear.getImageIndex(): integer;
begin
  result := ciYear;
end;

function TYear.getNodeText(): string;
begin
  result := toString(FYear);
end;

procedure TYear.ZoomEvent(Sender: TObject);
begin
  FZoom := TYearZoom.Create(self);
  AddNode(TTreeView(FTreeNode.TreeView), FTreeNode, '', -1, FZoom);
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
  FTreeNode := result;

  // Fases
  n1 := AddNode(Tree, result, 'Fases', ciFolder);
  for k := 0 to High(FFases) do
    begin
    n2 := AddNode(Tree, n1, 'Fase ' + intToStr(k), ciClock);

    AddNode(Tree, n2, 'Intervalo: '           + FFases[k].Inicio + ' - ' + FFases[k].Fim     , ciItem);
    AddNode(Tree, n2, 'Irrigacao: '           + SysUtilsEx.toString(FFases[k].Irrigacao), ciItem);
    AddNode(Tree, n2, 'Excesso: '             + SysUtilsEx.toString(FFases[k].Excesso)  , ciItem);
    AddNode(Tree, n2, 'ETm: '                 + SysUtilsEx.toString(FFases[k].ETm)      , ciItem);
    AddNode(Tree, n2, 'ETa: '                 + SysUtilsEx.toString(FFases[k].ETa)      , ciItem);
    AddNode(Tree, n2, 'Precipitação: '        + SysUtilsEx.toString(FFases[k].PRE)      , ciItem);
    AddNode(Tree, n2, 'Variação de Umidade: ' + SysUtilsEx.toString(FFases[k].R)        , ciItem);
    AddNode(Tree, n2, 'Ascenção Capilar: '    + SysUtilsEx.toString(FFases[k].ASC)      , ciItem);
    end;

  if FZoom <> nil then
     FZoom.ShowInTree(Tree, result);
end;

{ TCulture }

procedure TCulture.GerarArquivosDoIsareg();
var sl: TStrings;
begin
  SysUtils.DeleteFile(FExePath + 'erros.txt');

  if not DirectoryExists(IsaregDir) then
     if not ForceDirectories(IsaregDir) then
        begin
        setErro('Diretório "' + IsaregDir + '" não pode ser criado.');
        setErro('Verifique seus direitos ou crie manualmente este diretório');
        exit;
        end;

  SysUtils.DeleteFile(IsaregDir + 'sai.sai');
  SysUtils.DeleteFile(IsaregDir + 'sai.fas');
  SysUtils.DeleteFile(IsaregDir + 'sai.irr');

  SetCurrentDir(FWorkDir);

  sl := TStringList.Create();
  sl.Add('');
  sl.Add(getShortName(FCul));
  sl.Add(getShortName(FSol));
  sl.Add(getShortName(FEto));
  sl.Add(getShortName(FPre));
  sl.Add('sai');
  sl.Add(FAnos);
  sl.Add(getShortName(FMan));
  if FRes = '' then sl.Add('N') else sl.Add(getShortName(FRes));
  if FAsc = '' then sl.Add('N') else sl.Add(getShortName(FAsc));
  sl.SaveToFile(IsaregDir + '\Batch.reg');
  sl.Free();
end;

procedure TCulture.LerResultadosDoIsareg();
var sl: TStrings;
    M: TManagement;
begin
  sl := TStringList.Create();
  if FileExists(FExePath + 'erros.txt') then
     begin
     sl.LoadFromFile(FExePath + 'erros.txt');
     if sl.Count > 0 then
        setErro(sl.Text)
     else
        begin
        M := TManagement.Create(FMan, FRes, self);
        M.LerIRR(IsaregDir + '\SAI.IRR');
        M.LerFAS(IsaregDir + '\SAI.FAS');
        FManagements.Adicionar(M);
        if FTree <> nil then M.ShowInTree(FTree, FNode_Manejos);
        FModificado := false;
        setErro('');
        end;
     end
  else
     setErro('Erro desconhecido');
  sl.Free();
end;

type
  T1 = array[0..163] of char;
  T2 = char;

  TProc = procedure(var p1: T1;
                    var p2: T2); stdcall;

procedure TCulture.Simular();
var ExecIsareg: TProc;
    h: THandle;
    i: integer;
    s1: T1;
    s2: T2;
begin
  fillChar(s1, sizeof(s1), #0);
  s1 := 'c:\temp\isareg';
  s2 := '0';

  setErro('');
  h := LoadLibrary(pChar(FExePath + sIsaregDLL));
  if h <> 0 then
     try
     @ExecIsareg := windows.GetProcAddress(h, 'isareg');
     if @ExecIsareg <> nil then
        begin
        GerarArquivosDoIsareg();
        SysUtils.SetCurrentDir(FExePath);
        if not FTemErro then
           begin
           ExecIsareg(s1, s2);
           LerResultadosDoIsareg();
           end;
        end
     else
        setErro('Ponto de entrada da Isareg.dll não encontrado.')
     finally
        FreeLibrary(h);
     end
  else
     setErro('Isareg.dll não encontrada.');
end;

procedure TCulture.PegarDadosDoDialogo(d: TForm);
var b: boolean;
    i: integer;
begin
  with TfoDados(d) do
    begin
    FWorkDir := edPasta.Text;

    FCul := edC.Text;
    FSol := edS.Text;
    FPre := edP.Text;
    FEto := edE.Text;
    FAsc := edA.Text;

    with DLG_InfoGerais do
      begin
      FAnos := Alltrim(edAnos.Text);
      if FAnos = '' then FAnos := '0';

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

      FArea       := edArea.AsFloat;
      FIntervalos := edInt.AsInteger;
      FHorasOper  := edHorasOper.AsInteger;

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
      end; // with DLG_InfoGerais
    end; // with TfoDados(d)

  ProcessaAnos();
  FModificado := true;
end;

procedure TCulture.PorDadosNoDialogo(d: TForm);
var i: Integer;
begin
  with TfoDados(d) do
    begin
    edPasta.Text := FWorkDir;
    edC.Text := FCul;
    edS.Text := FSol;
    edP.Text := FPre;
    edE.Text := FEto;
    edA.Text := FAsc;

    with DLG_InfoGerais do
      begin
      edAnos.Text := FAnos;
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

      edArea.AsFloat        := FArea;
      edInt.AsInteger       := FIntervalos;
      edHorasOper.AsInteger := FHorasOper;

      for i := 0 to High(FRPLC) do
        sgRPLC.Cells[i, 1] := SysUtilsEx.toString(FRPLC[i].Val, 0);

      for i := 0 to High(FVPM) do
        sgVPM.Cells[i, 1] := SysUtilsEx.toString(FVPM[i].Val, 0);

      for i := 0 to High(FVPA) do
        sgVPA.Cells[i, 1] := SysUtilsEx.toString(FVPA[i].Val, 0);

      for i := 0 to High(FRendCultNI) do
        sgRCNI.Cells[i, 1] := SysUtilsEx.toString(FRendCultNI[i].Val, 0);

      for i := 0 to High(FRendCultI) do
        sgRCI.Cells[i, 1] := SysUtilsEx.toString(FRendCultI[i].Val, 0);
      end; // with DLG_InfoGerais
    end; // with foSimular
end;

procedure TCulture.ihc_Simular();
begin
  setErro('');
  if FModificado then
     Simular();
end;

procedure TCulture.ihc_LerDoArquivo(Ini: TMemIniFile; const Section: string);
var i: Integer;
    s: string;
    ia: TIntArray;
begin
  with Ini do
    begin
    FCul := ReadString(Section, 'Cul', '');
    FSol := ReadString(Section, 'Sol', '');
    FPre := ReadString(Section, 'Pre', '');
    FEto := ReadString(Section, 'Eto', '');
    FAsc  := ReadString(Section, 'Asc', '');
    FAnos := ReadString(Section, 'Intervalo', '');

    FLat := readInteger(Section, 'Lat', 0);
    FLon := readInteger(Section, 'Lon', 0);
    FAlt := readInteger(Section, 'Alt', 0);
    FAn  := readInteger(Section, 'Ane', 0);

    FSemChuva := readBool(Section, 'SemChuva', false);
    FComChuva := readBool(Section, 'ComChuva', false);
    FSeco     := readBool(Section, 'Seco',     false);
    FMedio    := readBool(Section, 'Medio',    false);
    FUmido    := readBool(Section, 'Umido',    false);

    FAlimento    := readInteger(Section, 'TipoAlimento', -1);
    FTipoSistema := readInteger(Section, 'TipoSistema', -1);

    FNatureza   := readBool(Section, 'Natureza',   false);
    FProdMax    := readBool(Section, 'ProdMax',    false);
    FComDeficit := readBool(Section, 'ComDeficit', false);

    FArea       := readFloat  (Section, 'Area',       0);
    FIntervalos := readInteger(Section, 'Intervalos', 0);
    FHorasOper  := readInteger(Section, 'HorasOper',  0);

    // Tabelas
    ia := StringToIntArray(readString(Section, 'Anos', ''), ['|']);
    StringToRendimento(readString(Section, 'RendCultCalc', ''), FRPLC, ia);
    StringToRendimento(readString(Section, 'VPA', ''         ), FVPA, ia);
    StringToRendimento(readString(Section, 'VPM', ''         ), FVPM, ia);
    StringToRendimento(readString(Section, 'RendCultNI', ''  ), FRendCultNI, ia);
    StringToRendimento(readString(Section, 'RendCultI', ''   ), FRendCultI, ia);

    FManagements.LoadFromFile(Ini, Section);

    ProcessaAnos();
    FModificado := true;
    end;
end;

procedure TCulture.ihc_SalvarEmArquivo(Ini: TMemIniFile; const Section: string);
var i: Integer;
    s: string;
begin
  with Ini do
    begin
    WriteString(Section, 'Cul', FCul);
    WriteString(Section, 'Sol', FSol);
    WriteString(Section, 'Pre', FPre);
    WriteString(Section, 'Eto', FEto);
    WriteString(Section, 'Man', FMan);
    WriteString(Section, 'Res', FRes);
    WriteString(Section, 'Asc', FAsc);

    WriteString(Section, 'Intervalo', FAnos);

    WriteInteger(Section, 'Lat', FLat);
    WriteInteger(Section, 'Lon', FLon);
    WriteInteger(Section, 'Alt', FAlt);
    WriteInteger(Section, 'Ane', FAn);

    WriteBool(Section, 'SemChuva', FSemChuva);
    WriteBool(Section, 'ComChuva', FComChuva);
    WriteBool(Section, 'Seco',     FSeco);
    WriteBool(Section, 'Medio',    FMedio);
    WriteBool(Section, 'Umido',    FUmido);

    WriteInteger(Section, 'TipoAlimento', FAlimento);
    WriteInteger(Section, 'TipoSistema', FTipoSistema);

    WriteBool(Section, 'Natureza',   FNatureza);
    WriteBool(Section, 'ProdMax',    FProdMax);
    WriteBool(Section, 'ComDeficit', FComDeficit);

    WriteFloat  (Section, 'Area',       FArea);
    WriteInteger(Section, 'Intervalos', FIntervalos);
    WriteInteger(Section, 'HorasOper',  FHorasOper);

    // Tabelas
    WriteString(Section, 'Anos',         ObtemAnos());
    WriteString(Section, 'RendCultCalc', RendimentoToString(FRPLC));
    WriteString(Section, 'VPA',          RendimentoToString(FVPA));
    WriteString(Section, 'VPM',          RendimentoToString(FVPM));
    WriteString(Section, 'RendCultNI',   RendimentoToString(FRendCultNI));
    WriteString(Section, 'RendCultI',    RendimentoToString(FRendCultI));

    FManagements.SaveToFile(Ini, Section);
    end;
end;

procedure TCulture.Release;
begin
  self.Free;
end;

procedure TCulture.setErro(const Erro: string);
begin
  FTemErro := (Erro <> '');
  if (Erro <> '') then
     FErros.Add(Erro)
  else
     FErros.Clear;
end;

procedure TCulture.ipr_setExePath(const ExePath: string);
begin
  FExePath := ExePath;
end;

function TCulture.ToString(): wideString;
begin
  Result := 'Cenário de Demanda: Lavoura Isareg';
end;

constructor TCulture.Create();
begin
  inherited Create();
  FModificado := true;
  FErros := TStringList.Create();
  FManagements := TManagementList.Create(self);
  FAlimento := -1;
  getMessageManager.RegisterMessage(UM_Get_Lavouras, self);
end;

destructor TCulture.Destroy();
begin
  getMessageManager.UnregisterMessage(UM_Get_Lavouras, self);
  FErros.Free();
  FManagements.Free();
  inherited;
end;

procedure TCulture.ihc_ObterErros(var Erros: TStrings);
begin
  if Erros = nil then Erros := TStringList.Create();
  Erros.AddStrings(FErros);
end;

function TCulture.ihc_TemErros: boolean;
begin
  Result := (FErros.Count > 0)
end;

procedure TCulture.ihc_ObterAcoesDeMenu(Acoes: TActionList);
begin
  CreateAction(Acoes, nil, 'Mostrar Gerenciador ...', false, MenuShowVisualManager, self);
end;

procedure TCulture.ShowDataDialogEvent(Sender: TObject);
begin
  Edit();
end;

procedure TCulture.MostrarErros();
begin
  Dialogs.MessageDLG(FErros.Text, mtError, [mbOk], 0);
end;

function TCulture.getShortName(const Name: string; DelExt: boolean = true): string;
var ext: string;
begin
  Result := ExpandFileName(Name);
  ext := ExtractFileExt(Result);
  delete(ext, 1, 1);

  if FileExists(Result) then
     CopyFile(pChar(Result), pChar(IsaregDir + '\' + ext + '.' + ext), false)
  else
     begin
     setErro('Arquivo não encontrado: ');
     setErro('  ' + Result);
     end;

  if DelExt then
     Result := ext
  else
     Result := ext + '.' + ext;
end;

procedure TCulture.MenuVisRes(Sender: TObject);
begin
  TManagement(TComponent(Sender).Tag).MostrarDados();
end;

procedure TCulture.MenuRemoverRes(Sender: TObject);
begin
  Managements.Remover(TManagement(TComponent(Sender).Tag));
end;

function TCulture.icd_ObterValoresUnitarios(): TObject;
var r: TManagement;
begin
  r := Managements.ResultadoAtivo();
  if r <> nil then
     Result := r.Reqs
  else
     Result := nil;
end;

procedure TCulture.MenuPlotarProdChuva(Sender: TObject);
begin
  Managements.Plotar(tiProdChuva);
end;

procedure TCulture.MenuPlotarCoefChuvas(Sender: TObject);
begin
  Managements.Plotar(tiCoefChuvas);
end;

procedure TCulture.MenuPlotarCoefConvPot(Sender: TObject);
begin
  Managements.Plotar(tiCoefConvPot);
end;

procedure TCulture.MenuPlotarCoefConvReal(Sender: TObject);
begin
  Managements.Plotar(tiCoefConvReal);
end;

procedure TCulture.MenuPlotarRendPotCultI(Sender: TObject);
begin
  Managements.Plotar(tiRendPotCultI);
end;

procedure TCulture.MenuPlotarRendPotCultNI(Sender: TObject);
begin
  Managements.Plotar(tiRendPotCultNI);
end;

function TCulture.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_Get_Lavouras then
     if self <> MSG.ParamAsObject(0) then
        TList(MSG.ParamAsObject(1)).Add(self);
end;

procedure TCulture.ipr_setObjectName(const Name: string);
begin
  FNome := Name;
end;

const
  cErro0 = 'Número de sub-parâmetros incorrero';
  cErro1 = 'Referência Incorreta ao Manejo';
  cErro2 = 'Índice de Manejo Inválido';
  cErro3 = 'Ano inválido';
  cErro4 = 'Propriedade não Definida';

function TCulture.icd_ObterValorFloat(const Propriedade: string): real;
var SL: TStrings;
    M: TManagement;
    A: TYear;
    i: integer;
    s, s1, s2, s3, s4: string;

    procedure ObterManejo();
    begin
      s := SysUtilsEx.RigthStringOf(s1, '_');
      if s = '' then
         ObterValor_Erro(cErro1 + ' <' + s1 + '>')
      else
         begin
         i := strToIntDef(s, -1);
         if i = -1 then
            ObterValor_Erro(cErro1 + ' <' + s1 + '>')
         else
            begin
            if (i > -1) and (i < Managements.Count) then
               M := Managements.Item[i]
            else
               ObterValor_Erro(cErro2 + ' <' + SysUtilsEx.toString(i) + '>')
            end;
         end;
    end;

begin
  // Regra: Manejo_n.ano.Propriedade

  SL := nil;
  StringToStrings(Propriedade, SL, ['.']);

  // Erro
  if SL.Count = 0 then
     ObterValor_Erro(cErro0 + ' <' + Propriedade + '>')
  else

  // 1 Parametro: Culture
  if SL.Count = 1 then
     begin
     s1 := SL[0];

     // Obtem a propriedade ...

     if CompareText(s1, 'Area'      ) = 0 then result := FArea                 else
     if CompareText(s1, 'Manejos'   ) = 0 then result := Managements.Count     else
     if CompareText(s1, 'EI'        ) = 0 then result := EficienciaDoSistema() else
     if CompareText(s1, 'CustoI'    ) = 0 then result := CustoPorHectar()      else
     if CompareText(s1, 'AnoInicial') = 0 then result := FAnoInicial           else
     if CompareText(s1, 'AnoFinal'  ) = 0 then result := FAnoFinal             else
     if CompareText(s1, 'Proteina'  ) = 0 then result := Proteinas()           else
     if CompareText(s1, 'Gordura'   ) = 0 then result := Gorduras()            else
     if CompareText(s1, 'Caloria'   ) = 0 then result := Calorias()            else
     if CompareText(s1, 'Calcio'    ) = 0 then result := Calcio()
     else
        ObterValor_Erro(cErro4 + ' <' + s3 + '>');
     end
  else

  // 2 Parametros: Manejo.Indice
  if SL.Count = 2 then
     begin
     s1 := SL[0];
     s2 := SL[1];

     ObterManejo(); // --> M

     // Obtem a propriedade ...

     if CompareText(s2, 'VU_80'  ) = 0 then result := M.VU_80 else
     if CompareText(s2, 'VB_18'  ) = 0 then result := M.VB_18 else
     if CompareText(s2, 'VB_SI'  ) = 0 then result := M.VB_SI
     else
        ObterValor_Erro(cErro4 + ' <' + s3 + '>');
     end
  else

  // 3 Parametros: Manejo.Ano.Indice
  if SL.Count = 3 then
     begin
     s1 := SL[0];
     s2 := SL[1];
     s3 := SL[2];

     ObterManejo(); // --> M

     // Obtem o Ano
     i := strToIntDef(s2, -1);
     if i = -1 then
        ObterValor_Erro(cErro3 + ' <' + s2 + '>')
     else
        begin
        A := M.Anos.ObterAno(i);
        if A = nil then
           ObterValor_Erro(cErro3 + ' <' + s2 + '>');
        end;

     // Obtem a propriedade ...

     if System.Pos('demanda', LowerCase(s3)) > 0 then
        begin
        s4 := SysUtilsEx.SubString(s3, '(', ')');
        if s4 = '' then
           ObterValor_Erro('Parâmetro mal formado <' + s3 + '>')
        else
           result := A.Demanda[strToIntDef(s4, 0)];
        end
     else

     if CompareText(s3, 'Irrigado'  ) = 0 then result := byte(A.FIrrigado) else

     if CompareText(s3, 'VPM'       ) = 0 then result := A.VPM             else
     if CompareText(s3, 'VPA'       ) = 0 then result := A.VPA             else
     if CompareText(s3, 'RPLC'      ) = 0 then result := A.RPLC            else
     if CompareText(s3, 'Rcul'      ) = 0 then result := A.Rcul            else
     if CompareText(s3, 'RculI'     ) = 0 then result := A.RculI           else

     //if CompareText(s3, 'LIMB'      ) = 0 then result := A.LIMB            else
     if CompareText(s3, 'CCCP'      ) = 0 then result := A.CCCP            else
     if CompareText(s3, 'RPcul'     ) = 0 then result := A.RPcul           else
     if CompareText(s3, 'ETa'       ) = 0 then result := A.ETa             else
     if CompareText(s3, 'CCC'       ) = 0 then result := A.CCC             else
     if CompareText(s3, 'Q'         ) = 0 then result := A.Q               else
     if CompareText(s3, 'PR_CHU'    ) = 0 then result := A.PR_CHU          else
     if CompareText(s3, 'ChT'       ) = 0 then result := A.Chuva           else
     //if CompareText(s3, 'LIM'       ) = 0 then result := A.LIM             else
     if CompareText(s3, 'CC'        ) = 0 then result := A.CC              else
     if CompareText(s3, 'II_P'      ) = 0 then result := A.II_P            else
     if CompareText(s3, 'ETm'       ) = 0 then result := A.ETm             else
     if CompareText(s3, 'PR_CHU_IRR') = 0 then result := A.PR_CHU_IRR      else
     if CompareText(s3, 'LIC'       ) = 0 then result := A.LIC
     else
        ObterValor_Erro(cErro4 + ' <' + s3 + '>');
     end
  else
     ObterValor_Erro(cErro0 + ' <' + Propriedade + '>');
end;

function TCulture.icd_ObterValorString(const Propriedade: string): string;
begin
  // Nao ha propriedades String
  Result := '';
end;

procedure TCulture.ObterValor_Erro(const Erro: string);
begin
  raise Exception.Create(#13 +
                         'Objeto: ' + FNome + #13 +
                         'Método: ObterValor'#13 +
                         'Erro: ' + Erro +
                         #13);
end;

procedure TCulture.ipr_setProjectPath(const ProjectPath: string);
begin
  FWorkDir := ProjectPath;
  if LastChar(FWorkDir) <> '\' then
     FWorkDir := FWorkDir + '\';
end;

function TCulture.ObtemAnos(): string;
var i: Integer;
begin
  for i := 0 to High(FVPA) do
    if i = 0 then
       result := SysUtilsEx.toString(FVPA[i].Ano)
    else
       result := result + '|' + SysUtilsEx.toString(FVPA[i].Ano);
end;

function TCulture.RendimentoToString(const r: TRendimentosAnuais): string;
var i: Integer;
begin
  for i := 0 to High(r) do
    if i = 0 then
       result := SysUtilsEx.toString(r[i].Val)
    else
       result := result + '|' + SysUtilsEx.toString(r[i].Val);
end;

procedure TCulture.StringToRendimento(const s: string; var r: TRendimentosAnuais; const anos: TIntArray);
var ar: TFloatArray;
     i: integer;
begin
  if Length(anos) > 0 then
     begin
     ar := StringToFloatArray(s, ['|']);
     if Length(ar) = Length(anos) then
        begin
        setLength(r, Length(ar));
        for i := 0 to High(r) do
          begin
          r[i].Ano := Anos[i];
          r[i].Val := ar[i];
          end;
        end;
     end;
end;

function TCulture.ObterValorDoVetor(const vetor: TRendimentosAnuais; ano: Integer): real;
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

function TCulture.RendimentoDaCultura(ano: Integer): real;
begin
  result := ObterValorDoVetor(FRendCultNI, ano);
end;

function TCulture.RendimentoDaCulturaIrrigada(ano: Integer): real;
begin
  result := ObterValorDoVetor(FRendCultI, ano);
end;

function TCulture.RendimentoPotencialCalculado(ano: Integer): real;
begin
  result := ObterValorDoVetor(FRPLC, ano);
end;

function TCulture.ValorProducaoAgropecuaria(ano: Integer): real;
begin
  result := ObterValorDoVetor(FVPA, ano);
end;

function TCulture.ValorProdutoMercado(ano: Integer): real;
begin
  result := ObterValorDoVetor(FVPM, ano);
end;

function TCulture.EficienciaDoSistema(): real;
begin
  result := cd_Classes.EficienciaDoSistema(FTipoSistema);
end;

function TCulture.CustoPorHectar(): integer;
begin
  result := cd_Classes.CustoPorHectar(FTipoSistema);
end;

procedure TCulture.ProcessaAnos();
var s1, s2: string;
begin
  if System.Pos('-', FAnos) > 0 then
     begin
     SysUtilsEx.SubStrings('-', s1, s2, FAnos, true);
     FAnoInicial := strToIntDef(s1, -1);
     FAnoFinal := strToIntDef(s2, -1);
     end
  else
     begin
     FAnoInicial := strToIntDef(FAnos, -1);
     FAnoFinal := strToIntDef(FAnos, -1);
     end;
end;

procedure TCulture.ihc_toXML(Buffer: TStrings; Ident: integer);
var x: TXML_Writer;
    i: Integer;
    s: string;
begin
  x := TXML_Writer.Create(Buffer, Ident);

  x.Write('interval', FAnos);

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

  x.Write('area', FArea);
  x.Write('irrigationInterval', FIntervalos);
  x.Write('operationTime', FHorasOper);

  // Tabelas
  x.Write('years', ObtemAnos());
  x.Write('CCE',   RendimentoToString(FRPLC));
  x.Write('APV',   RendimentoToString(FVPA));
  x.Write('MPV',   RendimentoToString(FVPM));
  x.Write('NIC',   RendimentoToString(FRendCultNI));
  x.Write('IC',    RendimentoToString(FRendCultI));

  Managements.toXML(x);

  x.Free();
end;

procedure TCulture.ihc_fromXML(no: IXMLDOMNode);
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

  FAnos := allTrim(cn.nextNode().text);
  if FAnos = '' then FAnos := '0';

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

  if FxmlVersion > 1 then
     FAlimento := toInt(cn.nextNode().text)
  else
     FAlimento := -1;

  FTipoSistema := toInt(cn.nextNode().text);

  FNatureza   := toBoolean(cn.nextNode().text);
  FProdMax    := toBoolean(cn.nextNode().text);
  FComDeficit := toBoolean(cn.nextNode().text);

  FArea       := toFloat(cn.nextNode().text);
  FIntervalos := toInt(cn.nextNode().text);
  FHorasOper  := toInt(cn.nextNode().text);

  // Tabelas
  ia := StringToIntArray (cn.nextNode().text, ['|']);
  StringToRendimento (cn.nextNode().text, FRPLC, ia);
  StringToRendimento (cn.nextNode().text, FVPA, ia);
  StringToRendimento (cn.nextNode().text, FVPM, ia);
  StringToRendimento (cn.nextNode().text, FRendCultNI, ia);
  StringToRendimento (cn.nextNode().text, FRendCultI, ia);

  // Managements
  Managements.FromXML( cn.nextNode() );

  ProcessaAnos();
  FModificado := true;
end;

procedure TCulture.MenuRemoverManejos(Sender: TObject);
begin
  if MessageDLG('Tem certeza ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     FManagements.Clear();
end;

procedure TCulture.MenuPlotarCCC(Sender: TObject);
begin
  FManagements.Plotar(tiChuva);
end;

procedure TCulture.MenuPlotarLIC(Sender: TObject);
begin
  FManagements.Plotar(tiLIC);
end;

procedure TCulture.MenuPlotarPTAI(Sender: TObject);
begin
  FManagements.Plotar(tiPR_ChuvaIrr);
end;

procedure TCulture.MenuPlotarQPI(Sender: TObject);
begin
  FManagements.Plotar(tiQ);
end;

function TCulture.Calcio(): real;
begin
  result := cd_Classes.Calcio(FAlimento);
end;

function TCulture.Calorias(): integer;
begin
  result := cd_Classes.Calorias(FAlimento);
end;

function TCulture.Gorduras(): integer;
begin
  result := cd_Classes.Gorduras(FAlimento);
end;

function TCulture.Proteinas(): integer;
begin
  result := cd_Classes.Proteinas(FAlimento);
end;

// Versao 1: Primeira Versao
// Versao 2: Adicao do tipo de Alimento Produzido (FAlimento)
// Versao 3: Nao Lembro !!!
// Versao 4: Mais info. sobre as fases de culturas
// Versao 5: Desconsideracao dos arquivos de manejo e restricao
function TCulture.ihc_getXMLVersion(): integer;
begin
  result := 5;
end;

procedure TCulture.ShowVisualManager();
begin
  with TfoMain.Create(self) do
    begin
    FTree := frTree.Tree;
    ShowModal();
    Release();
    FTree := nil;
    end;
end;

procedure TCulture.MenuShowVisualManager(Sender: TObject);
begin
  ShowVisualManager();
end;

procedure TCulture.ShowInTree(Tree: TTreeView);
var i: Integer;
    n1: TTreeNode;
begin
  n1 := AddNode(Tree, nil, '', -1, self);

  // Managements
  FNode_Manejos := AddNode(Tree, n1, 'Managements', ciFolder);
  for i := 0 to FManagements.Count-1 do
    FManagements.Item[i].ShowInTree(Tree, FNode_Manejos);

  FNode_Manejos.Expand(false);
end;

function TCulture.getNodeText(): string;
begin
  result := FNome;
end;

function TCulture.canEdit(): boolean;
begin
  result := true;
end;

procedure TCulture.executeDefaultAction();
begin
  Edit();
end;

procedure TCulture.getActions(Actions: TActionList);
var Act1, Act2 : TAction;
    i: integer;
    Management: TManagement;
begin
  CreateAction(Actions, nil, 'Edit ...', false, ShowDataDialogEvent, self);
  CreateAction(Actions, nil, 'Simulate Management ...', false, NewManagementEvent, self);

  if FManagements.Count > 0 then
     begin
     CreateAction(Actions, nil, '-', false, nil, nil);
     CreateAction(Actions, nil, 'Remove all Managements', false, MenuRemoverManejos, nil);
     CreateAction(Actions, nil, '-', false, nil, nil);

     Act1 := CreateAction(Actions, nil, 'Managements', false, nil, nil);

       Act2 := CreateAction(Actions, Act1, 'Plot', false, nil, nil);
         CreateAction(Actions, Act2, 'Produtividade da Chuva ...', false, MenuPlotarProdChuva, nil);
         CreateAction(Actions, Act2, 'Rendimento Potencial da Cultura não Irrigada...', false, MenuPlotarRendPotCultNI, nil);
         CreateAction(Actions, Act2, 'Rendimento Potencial da Cultura Irrigada...', false, MenuPlotarRendPotCultI, nil);
         CreateAction(Actions, Act2, 'Coeficiente de Conversão Real ...', false, MenuPlotarCoefConvReal, nil);
         CreateAction(Actions, Act2, 'Coeficiente de Conversão Potencial ...', false, MenuPlotarCoefConvPot, nil);
         CreateAction(Actions, Act2, 'Coeficiente de Chuvas ...', false, MenuPlotarCoefChuvas, nil);
         CreateAction(Actions, Act2, 'Chuva no Ciclo da Cultura ...', false, MenuPlotarCCC, nil);
         CreateAction(Actions, Act2, 'Produtividade Total da Água com Irrigação ...', false, MenuPlotarPTAI, nil);
         CreateAction(Actions, Act2, 'Quebra de Produção Estimada ...', false, MenuPlotarQPI, nil);
         CreateAction(Actions, Act2, 'Lâmina de Irrigação no Ciclo ...', false, MenuPlotarLIC, nil);
     end;
end;

function TCulture.getImageIndex(): integer;
begin
  result := ciFarming;
end;

procedure TCulture.setEditedText(var Text: string);
begin
  Text := SysUtilsEx.getValidID(Text);
  FNome := Text;
end;

procedure TCulture.NewManagementEvent(Sender: TObject);
var d: TfoSel_Man_Res;
begin
  d := TfoSel_Man_Res.Create(self);
  try
    if d.ShowModal() = mrOk then
       begin
       FMan := d.edMan.Text;
       FRes := d.edRes.Text;
       Simular();
       if TemErros then
          MostrarErros()
       else
          //
       end;
  finally
    d.Free();
  end;  
end;

procedure TCulture.Edit();
var d: TfoDados;
begin
  d := TfoDados.Create(self);
  try
    PorDadosNoDialogo(d);
    d.ShowModal();
    PegarDadosDoDialogo(d);
  finally
    d.Release();
  end;
end;

{ TYearZoom }

function TYearZoom.canEdit(): boolean;
begin
  Result := true;
end;

constructor TYearZoom.Create(Year: TYear);
begin
  inherited Create();
  FYear := Year;
  FTitle := toString(FYear.Year);
end;

procedure TYearZoom.executeDefaultAction();
begin

end;

procedure TYearZoom.getActions(Actions: TActionList);
begin

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

end.
