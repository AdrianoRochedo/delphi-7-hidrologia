unit ch_Tipos;

interface
uses Classes, ActnList, ComCtrls, wsVec, wsMatrix, SysUtilsEx, wsOutPut,
     ErrosDLG, drPlanilha, Form_Chart, Application_Class, pro_Interfaces;

const
  cPostos = 5; // As primeiras 4 colunas são informações sobre a data

type
  TTipoDados         = (tdChuva, tdVazao);
  TTipoIntervalo     = (tiDiario, tiQuinquendial, tiSemanal, tiDecendial, tiQuinzenal, tiMensal, tiAnual);

  pRecDadosPeriodo = ^TRecDadosPeriodo;
  TRecDadosPeriodo = record
                       DI     : TDateTime; // Data Inicial
                       DF     : TDateTime; // Data Final
                       Postos : TByteSet;  // Índices dos Postos
                     end;

  TRecPLU_DEF = Record
                  IntComp   : Byte;
                  IntSim    : Byte;
                  Linhas    : Word;
                  Colunas   : Word;
                  DataIni   : Double;
                  Valores   : TStrings;
                  PostosSel : TStrings;
                End;

  TRecVZO_DEF = Record
                  IntComp       : Byte;
                  IntSim        : Byte;
                  Posto         : String[30];
                  nIntervalos   : Word;
                  InterIni      : TStrings;
                  InterFin      : TStrings;
                  Multiplic     : Double;
                  UsarMultiplic : Boolean;
                End;

type
  TDSInfo = class;
  TPosto  = class;

{
  TwsDataSetChuvaz = Class(TwsDataSet)
  Private
    FIC: Boolean;
    FCalcEst: Boolean;
    FIPD: Boolean;
    procedure SetCE(Value: Boolean);
    function getTipoIntervalo: TTipoIntervalo;
    function getTipoDados: TTipoDados;
    procedure GetSheetValue(L, C: Integer; var IsNUM: Boolean; var sValue: String; var rValue: Real); override;
    Procedure Header(Start, Amt:Longint; Buffer: TStrings); override;
    function ToChar(L, Start, Amt: Integer; Buffer: TStrings): Integer; override;
    class function UserCreate: TwsMatrix; override;
  Public
    property CalcularEstatisticas : Boolean        read FCalcEst write SetCE;
    property ImprimirPorData      : Boolean        read FIPD     write FIPD;

    property TipoIntervalo        : TTipoIntervalo read getTipoIntervalo;
    property TipoDados            : TTipoDados     read getTipoDados;
  end;
}
  TNoObjeto = class
  protected
    procedure CriarAcao(Acoes: TActionList; const Nome: String; Evento: TNotifyEvent);
  public
    procedure ExecutarAcaoPadrao(Evento: TNotifyEvent); virtual;
    function ObterResumo: String; virtual;

    // Ações externas que poderão ser envocadas pela interface gráfica. Ex: "Graficar".
    // Uma instância da classe TActionList deverá ser passado através do parâmetro "Acoes"
    procedure ObterAcoesIndividuais(Acoes: TActionList); virtual;
    procedure ObterAcoesColetivas(Acoes: TActionList); virtual;
  end;

  TClasse_NoObjeto = class of TNoObjeto;

  // Classe abstrata que define uma Série de dados e suas ações.
  TSerie = class(TNoObjeto)
  private
    FNome: String;
    FPosto: TPosto;
    FAcoes: TActionList;
  protected
    procedure Calcular; virtual; abstract;
    procedure Iniciar; virtual; abstract;
  public
    constructor Create(Posto: TPosto);
    destructor Destroy; override;

    // Nome "humano" dado a série. Deverá ser iniciada no método "Iniciar".
    property Nome : String read FNome;

    // Posto utilizado para o cálculo da série.
    property Posto : TPosto read FPosto;
  end;

  // Define uma Série onde os dados são agrupados ou selecionados ano a ano.
  // Caracteriza-se pela formação de séries anuais onde cada elemento é obtido através de
  // estatísticas que agregam os N dias de um ano em um único valor ou selecionam um único
  // representante para o ano baseados em uma determinada regra.
  TSerie_Anual = class(TSerie)
  private
    FRes: TwsDFVec;
    function GetAnoInicial: Word;
    function GetAnoFinal: Word;
  protected
    procedure Calcular; override;

    // Método responsável pela seleção do elemento representante do ano ou
    // pela agregação dos dados do ano.
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real; virtual; abstract;
  public
    destructor Destroy; override;
    function  ObterResumo: String; override;

    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;

    procedure Plotar(Grafico: TfoChart; Ordem: Word);
    procedure MostrarEmPlanilha(Planilha: TPlanilha; Coluna: Word);

    property Resultado: TwsDFVec read FRes;

    property AnoInicial: Word read GetAnoInicial;
    property AnoFinal: Word   read GetAnoFinal;
  end;

  // Caracteriza-se pela formação de séries anuais onde cada elemento é obtido através da eleição
  // de um único valor para cada ano baseado em uma determinada regra.
  // Este tipo de série não pode sofrer preenchimento de falhas.
  TSerie_Anual_Diaria = class(TSerie_Anual)
  public
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  end;

  // Seleciona o maior valor em um ano
  TSerie_Anual_Diaria_Maximos = class(TSerie_Anual_Diaria)               {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  // Seleciona o menor valor não nulo encontrado em um ano.
  TSerie_Anual_Diaria_Minimos = class(TSerie_Anual_Diaria)               {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  // Neste tipo de série podemos realizar o Preenchimento de Falhas
  TSerie_Anual_PF = class(TSerie_Anual)
  public
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  end;

  // Cada elemento é o somatório dos valores encontrados em um ano.
  TSerie_Anual_Agregada_Totais = class(TSerie_Anual_PF)              {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // Cada elemento é a média dos valores encontrados em um ano.
  TSerie_Anual_Agregada_Medias = class(TSerie_Anual_PF)              {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // Caracteriza-se pela formação de séries anuais onde cada elemento é obtido através da
  // agregação dos dados de um mês, mês a mês para cada ano e após é feito a agregação/seleção
  // dos valores resultantes para cada ano para/de um único valor que representará um ano.
  TSerie_Anual_Mensal = class(TSerie_Anual_PF)
  protected
    procedure Calcular; override;

    // Método responsável por implemenar o algorítimo de agregação do mês.
    // Deverá ser implementado pelos descendentes.
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; virtual; abstract;

    // É o método responsável por escolher um único representante ou agregar os elementos
    // em um único valor que represente o ano.
    function SelecionarValor(Valores: TwsDFVec): Real; virtual; abstract;
  end;

  // É a série que totaliza os elementos do mês.
  TSerie_Anual_Mensal_AG_Total = class(TSerie_Anual_Mensal)
  protected
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // É a série que calcula a média dos elementos do mês.
  TSerie_Anual_Mensal_AG_Media = class(TSerie_Anual_Mensal)
  protected
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // É a série que calcula a média anual das médias mensais.
  TSerie_Anual_Mensal_AG_Media_Medias = class(TSerie_Anual_Mensal_AG_Media)          {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

  // É a série que calcula a média dos totais mensais.
  TSerie_Anual_Mensal_AG_Total_Medias = class(TSerie_Anual_Mensal_AG_Total)           {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

  // É a série que obtém o maior dos totais mensais.
  TSerie_Anual_Mensal_AG_Total_Maximos = class(TSerie_Anual_Mensal_AG_Total)          {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

  // É a série que obtém o menor dos totais mensais.
  TSerie_Anual_Mensal_AG_Total_Minimos = class(TSerie_Anual_Mensal_AG_Total)          {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

//  SÉRIES PARCIAIS **********************************************************************

  TSerie_Parcial = class(TSerie)
  private
    FRes: TwsDFVec;
    FBase: Real;
  protected
    // Método responsável pela seleção ou não do elemento.
    function SelecionarValor(const Valor: Real): Boolean; virtual; abstract;
  public
    constructor Create(Posto: TPosto; const ValorBase: Real);
    destructor Destroy; override;

    function  ObterResumo: String; override;

    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;
    procedure MostrarEmPlanilha(Planilha: TPlanilha; Coluna: Word);

    property Resultado: TwsDFVec read FRes;
    property ValorBase: Real read FBase;
  end;

  // Série parcial que NÃO pode sofrer preenchimento de falhas
  // mais pode sofrer Análise de Frequência.
  // O percorrimento deste tipo de série é totalmente sequencial.
  TSerie_Parcial_Diaria = class(TSerie_Parcial)
  protected
    procedure Calcular; override;
  public
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  end;

  TSerie_Parcial_Diaria_Maximos = class(TSerie_Parcial_Diaria)               {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  TSerie_Parcial_Diaria_Minimos = class(TSerie_Parcial_Diaria)               {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  // Série parcial que pode sofrer preenchimento de falhas
  // mais NÃO pode sofrer Análise de Frequência
  // O percorrimento é feito agregando-se os dados mês a mês.
  TSerie_Parcial_AG_Mensal = class(TSerie_Parcial)
  protected
    procedure Calcular; override;
    function AgregarMes(LinhaInicial, LinhaFinal: Integer): Real; virtual; abstract;
  public
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  end;

  TSerie_Parcial_TotalMensal = class(TSerie_Parcial_AG_Mensal)
  protected
    function AgregarMes(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  TSerie_Parcial_TotalMensal_Maximas = class(TSerie_Parcial_TotalMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  TSerie_Parcial_TotalMensal_Minimas = class(TSerie_Parcial_TotalMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  TSerie_Parcial_MediaMensal = class(TSerie_Parcial_AG_Mensal)
  protected
    function AgregarMes(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  TSerie_Parcial_MediaMensal_Maximas = class(TSerie_Parcial_MediaMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  TSerie_Parcial_MediaMensal_Minimas = class(TSerie_Parcial_MediaMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

(*
// SÉRIES PREENCHIDAS *************************************************************************

  // Série preenchida pelo método Vetor Regional
  TSerie_Preenchida_VetorRegional = class(TSerie_Preenchida)
  protected
    procedure Iniciar; override;
    procedure Calcular; override;
  end;

  // Base para as séries preenchidas por Regressão Linear
  TSerie_Preenchida_RL = class(TSerie_Preenchida)
  public
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  end;

  // Série preenchida por Regressão Linear Simples
  TSerie_Preenchida_RLS = class(TSerie_Preenchida_RL)
  protected
    procedure Iniciar; override;
    procedure Calcular; override;
  end;

  // Série preenchida por Regressão Linear Múltipla
  TSerie_Preenchida_RLM = class(TSerie_Preenchida_RL)
  protected
    procedure Iniciar; override;
    procedure Calcular; override;
  end;
*)

  TSeries = class
  private
    FList: TList;
    function getSerie(i: integer): TSerie;
    function getNumSeries: integer;
  public
    constructor Create;
    destructor Destroy; override;

    function Adicionar(Serie: TSerie): Integer;

    property NumSeries : Integer read getNumSeries;
    property Serie[i: integer] : TSerie read getSerie; default;
  end;

  TPosto = class(TNoObjeto)
  private
    FInfo: TDSInfo;
    FSeries: TSeries;
    FNome: String;
    FIndiceCol: Integer; // Índice da coluna do DataSet
    FIndice: Integer; // posição atual dos dados
    FDado: Real;
    FDia, FMes, FAno: Word; // dia, mes e ano da posição atual;
  public
    constructor Create(const Nome: String; Info: TDSInfo);
    destructor Destroy; override;

    procedure ExecutarAcaoPadrao(Evento: TNotifyEvent);override;
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    function  ObterResumo: String; override;

    // Métodos de navegação pelos dados
    function VaiPara(const Data: TDateTime): Integer;
    function VaiParaProximoDia: Integer;
    function VaiParaProximoDiaDoAnoAtual: Integer;
    function VaiParaProximoAno: Integer;
    function VaiParaFinalDoMes: Integer;

    property Series       : TSeries       read FSeries;
    property Nome         : String        read FNome;
    property Info         : TDSInfo       read FInfo;
    property IndiceCol    : Integer       read FIndiceCol; // Índice da variável (col) no DataSet

    // Dados da posição atual
    property Dado  : Real  read FDado;      // Valor do dado da posição atual
    property Dia   : Word  read FDia;       // Dia da posição atual
    property Mes   : Word  read FMes;       // Mes da posição atual
    property Ano   : Word  read FAno;       // Ano da posição atual
  end;

  TDSInfo = class(TNoObjeto)
  private
    FDS: TwsDataSet;
    function getNomeArq: String;
    function getDataInicial: TDateTime;
    function getTD: TTipoDados;
    function getTI: TTipoIntervalo;
    function getDataFinal: TDateTime;
    function getNumPostos: Integer;
  public
    constructor Create(const NomeArq: String);
    destructor Destroy; override;

    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    function  ObterResumo: String; override;

    function DataDoPrimeiroValorValido(const Posto: String): String;
    function DataDoUltimoValorValido(const Posto: String): String;

    function IndiceDaData(const Data: TDateTime): Integer; overload;
    function IndiceDaData(const Data: String): Integer; overload;

    function  PostoPeloNome(const Nome: String): TPosto;
    procedure MostrarPostos(Lugar: TStrings);

    // Indice pode variar de 0 a Numero de Postos - 1
    function PostoPeloIndice(const Indice: Integer): TPosto;

    property DS            : TwsDataSet       read FDS;
    property NomeArq       : String           read getNomeArq;
    property TipoIntervalo : TTipoIntervalo   read getTI;
    property TipoDados     : TTipoDados       read getTD;
    property DataInicial   : TDateTime        read getDataInicial;
    property DataFinal     : TDateTime        read getDataFinal;

    // Controle dos Postos
    property NumPostos : Integer read getNumPostos;
  end;

  TListaDePeriodos = Class
  private
    FList: TList;
    function getNumPeriodos: Integer;
    function getPeriodo(i: integer): pRecDadosPeriodo;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Adicionar(const DI, DF: TDateTime; const Postos: TByteSet);
    procedure Imprimir(Lugar: TwsOutPut; Info: TDSInfo; MostrarPostos: Boolean);

    property NumPeriodos: Integer read getNumPeriodos;
    property Periodo[i: integer]: pRecDadosPeriodo read getPeriodo; default;
  end;

  TchApplication = class(TApplication, IProcedaControl)
  private
    FTree: TTreeView;
    FErrors: TErros_DLG;
    FOutPut: TwsOutPut;
  protected
    // IProcedaControl interface
    procedure ip_NewDataSet(const iniDate, endDate: TDateTime; const StationCount: integer);
    procedure ip_SetStationName(StationIndex: integer; const Name: string);
    procedure ip_SetStationValue(Date: TDateTime; StationIndex: integer; const Value: real);
    procedure ip_DoneImport();

    procedure CreateMainForm(); override;
    procedure BeforeRun(); override;
    procedure PostRun(); override;
  public
    property Tree   : TTreeView  read FTree;
    property Errors : TErros_DLG read FErrors;
    property OutPut : TwsOutPut  read FOutPut;
  end;

  // Conversões
  function TipoIntervaloToStr(Tipo: TTipoIntervalo): String;
  function TipoDadosToStr(Tipo: TTipoDados): String;

var
  Applic: TchApplication;

implementation
uses Math, SysUtils, DateUtils, Graphics, Forms, Dialogs, Series, GraphicUtils,
     WinUtils,
     Lists,
     wsConstTypes,
     wsgLib,
     ch_Procs,
     ch_Acoes,
     Principal;

function TipoIntervaloToStr(Tipo: TTipoIntervalo): String;
const x : array[TTipoIntervalo] of String =
          ('Diario', 'Quinquendial', 'Semanal', 'Decendial', 'Quinzenal', 'Mensal', 'Anual');
begin
  Result := x[Tipo];
end;

function TipoDadosToStr(Tipo: TTipoDados): String;
const x : array[TTipoDados] of String = ('Chuva', 'Vazão');
begin
  Result := x[Tipo];
end;

{ TNoObjeto }

procedure TNoObjeto.CriarAcao(Acoes: TActionList; const Nome: String; Evento: TNotifyEvent);
var Act : TAction;
begin
  Act := TAction.Create(nil);
  Act.ActionList := Acoes;
  Act.Caption := Nome;
  Act.OnExecute := Evento;
end;

procedure TNoObjeto.ExecutarAcaoPadrao(Evento: TNotifyEvent);
begin
  // Somente classes descendentes definem ações padrões
end;

procedure TNoObjeto.ObterAcoesColetivas(Acoes: TActionList);
begin
  // Somente classes descendentes definem ações
end;

procedure TNoObjeto.ObterAcoesIndividuais(Acoes: TActionList);
begin
  // Somente classes descendentes definem ações
end;

function TNoObjeto.ObterResumo: String;
begin
  Result := '';
end;

{ TDSInfo }

constructor TDSInfo.Create(const NomeArq: String);
var i: Integer;
begin
  inherited Create;
  FDS := TwsDataSet(TwsDataSet.LoadFromFile(NomeArq));

  // As primeiras 4 colunas são informações sobre a data
  for i := cPostos to FDS.Struct.Cols.Count do
    FDS.Struct.Col[i].aObject := TPosto.Create(FDS.Struct.Col[i].Name, Self);
end;

destructor TDSInfo.Destroy();
var i: Integer;
begin
  // a primeira coluna é a Data
  for i := cPostos to FDS.Struct.Cols.Count do
    FDS.Struct.Col[i].aObject.Free();
  FDS.Free();
  inherited;
end;

function TDSInfo.DataDoPrimeiroValorValido(const Posto: String): String;
var i, k: Integer;
    x   : Double;
begin
  Result := '';
  k := FDS.Struct.IndexOf(Posto);
  for i := 1 to FDS.nRows do
    if not FDS.IsMissValue(i, k, x) then
       begin
       Result := DateToStr(FDS.AsDateTime[i, 1]);
       Break;
       end;
end;

function TDSInfo.DataDoUltimoValorValido(const Posto: String): String;
var i, k: Integer;
    x   : Double;
begin
  Result := '';
  k := FDS.Struct.IndexOf(Posto);
  for i := FDS.nRows downto 1 do
    if not FDS.IsMissValue(i, k, x) then
       begin
       Result := DateToStr(FDS.AsDateTime[i, 1]);
       Break;
       end;
end;

function TDSInfo.getDataInicial(): TDateTime;
begin
  Result := FDS.AsDateTime[1, 1];
end;

function TDSInfo.getNomeArq(): String;
begin
  Result := FDS.FileName;
end;

function TDSInfo.IndiceDaData(const Data: TDateTime): Integer;
begin
  for Result := 1 to FDS.NRows do
    if SameDate(Data, FDS.AsDateTime[Result, 1]) then
       Exit;

  Result := -1;
end;

function TDSInfo.getTD: TTipoDados;
begin
  Result := TTipoDados(FDS.Tag_2);
end;

function TDSInfo.getTI: TTipoIntervalo;
begin
  Result := TTipoIntervalo(FDS.Tag_1);
end;

function TDSInfo.IndiceDaData(const Data: String): Integer;
begin
  Result := IndiceDaData(StrToDate(Data));
end;

procedure TDSInfo.MostrarPostos(Lugar: TStrings);
var i: Integer;
begin
  Lugar.Clear;
  for i := cPostos to FDS.nCols do
    Lugar.Add(FDS.ColName[i]);
end;

function TDSInfo.getDataFinal(): TDateTime;
begin
  Result := FDS.AsDateTime[FDS.NRows, 1];
end;

function TDSInfo.getNumPostos(): Integer;
begin
  Result := FDS.Struct.Cols.Count - cPostos + 1;
end;

// "Indice" variar de 0 a Numero de Postos - 1
function TDSInfo.PostoPeloIndice(const Indice: Integer): TPosto;
begin
  try
    Result := TPosto(FDS.Struct.Col[Indice + cPostos].aObject);
  except
    Raise Exception.CreateFmt('Índice do Posto desconhecido: %d', [Indice]);
  end;
end;

function TDSInfo.PostoPeloNome(const Nome: String): TPosto;
begin
  try
    Result := TPosto(FDS.Struct.ColByName(Nome).aObject);
  except
    Raise Exception.CreateFmt('Posto %s desconhecido', [Nome]);
  end;
end;

procedure TDSInfo.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited;
  CriarAcao(Acoes, 'Gráfico Gantt', ActionManager.DSInfo_Gantt);
end;

function TDSInfo.ObterResumo(): String;
begin
  Result := 'Arquivo: ' + NomeArq;
end;

{ TListaDePeriodos }

constructor TListaDePeriodos.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TListaDePeriodos.Destroy;
var i: Integer;
begin
  for i := 0 to FList.Count-1 do Dispose(pRecDadosPeriodo(FList[i]));
  FList.Free;
  inherited;
end;

procedure TListaDePeriodos.Adicionar(const DI, DF: TDateTime; const Postos: TByteSet);
var p: pRecDadosPeriodo;
begin
  New(p);
  p.DI := DI;
  p.DF := DF;
  p.Postos := Postos;
  FList.Add(p);
end;

function TListaDePeriodos.getNumPeriodos: Integer;
begin
  Result := FList.Count;
end;

function TListaDePeriodos.getPeriodo(i: integer): pRecDadosPeriodo;
begin
  Result := pRecDadosPeriodo(FList[i]);
end;

procedure TListaDePeriodos.Imprimir(Lugar: TwsOutPut; Info: TDSInfo; MostrarPostos: Boolean);
var i: Integer;
    p: pRecDadosPeriodo;
begin
  for i := 0 to FList.Count-1 do
    begin
    p := getPeriodo(i);
    if MostrarPostos then
       Lugar.Editor.WriteFmt('DI = %s   DF = %s   Postos = %s',
                             [DateToStr(p.DI), DateToStr(p.DF), SetToPostos(p.Postos, Info)])
    else
       Lugar.Editor.WriteFmt('DI = %s   DF = %s',
                             [DateToStr(p.DI), DateToStr(p.DF)])
    end;
end;

(*
{ TwsDataSetChuvaz }

procedure TwsDataSetChuvaz.SetCE(Value: Boolean);
var i, inutil      : Integer;
    Stat, Col      : TwsLIVec;
    Estatisticas   : TwsGeneral;
    Media, DSP, CV : Double;
    Mensal         : Boolean;
begin
  if (Value <> FCalcEst) and (FnRows > 1) and (FnCols > 1) Then
     begin
     {$ifdef Forms}
     Screen.Cursor := crHourGlass;
     {$endif}

     Mensal := (TipoIntervalo = tiMensal);
     Try
       if FCalcEst then // Destroi as estatísticas
          begin
          Struct.Delete('Coef_Var');
          Struct.Delete('Desv_Pad');
          Struct.Delete('Media');
          MDelete(FnRows);
          MDelete(FnRows);
          MDelete(FnRows);
          end
       else // Cria as estatísticas
          begin
          Stat := TwsLIVec.Create(3); // Estatísticas que serão calculadas
          Stat[1] := ord(teMedia);
          Stat[2] := ord(teDPadr);
          Stat[3] := ord(teCVar);
          Col := TwsLIVec.Create(nCols-1);
          For i := 1 to nCols-1 Do Col[i] := i+1; // Colunas que quero calcular as estatísticas
          Estatisticas := DescStat(Col, Stat);
          Col.Free; Stat.Free;

          for i := 1 to 3 do MADD(TwsDFVec.Create(nCols));
          for i := 1 to Estatisticas.NRows do
            begin
            Self[nRows-2, i+1] := Estatisticas[i, 1]; // Media
            Self[nRows-1, i+1] := Estatisticas[i, 2]; // Desv. Padrão
            Self[nRows-0, i+1] := Estatisticas[i, 3]; // Coeficiente de variação
            end;

          Struct.AddNumeric('Media'   , 'Média para cada intervalo');
          Struct.AddNumeric('Desv_Pad', 'Desvio Padrão para cada intervalo');
          Struct.AddNumeric('Coef_Var', 'Coeficiente de Variação para cada intervalo');

          // Calcula as estatísticas para cada intervalo
          for i := 1 to nRows - 3 do
            begin
            Row[i].PartialVec_Mean_DSP_CV(1+1, nCols-3, inutil, Media, DSP, CV);
            Self[i, nCols-2] := Media;
            Self[i, nCols-1] := DSP;
            Self[i, nCols-0] := CV;
            end;

          // Calcula as estatísticas para as estatísticas de cada coluna
          for i := (nRows - 2) to nRows do
            begin
            Self[i, nCols-2] := wscMissValue; // Media
            Self[i, nCols-1] := wscMissValue; // Desv. Padrão
            Self[i, nCols-0] := wscMissValue; // Coeficiente de variação
            end;

            Self.RowName[nRows-2] := 'Média  ';
            Self.RowName[nRows-1] := 'Desv.Pad  ';
            Self.RowName[nRows-0] := 'Coef.Var  ';

          Estatisticas.Free;
          end;
       FCalcEst := Value;
     Finally
       {$ifdef Forms}
       Screen.Cursor := crDefault;
       {$endif}
       end;
     end;
end;

function TwsDataSetChuvaz.ToChar(L, Start, Amt: Integer; Buffer: TStrings): Integer;
var j, c: Longint;
    S: string;
    x: Double;
    Mensal: Boolean;
begin
  Mensal := (TipoIntervalo = tiMensal);
  if FIPD Then
     if FCalcEst and (L > nRows - 3) then
        S := RowName[L] + ' '
     else
        S := DateToStr(AsDateTime[L, 1]) + ' '
  else
     if FCalcEst and (L > nRows - 3) then
        S := RowName[L] + ' '
     else
        S := IntToStr(L) + ' ';

  s := LeftPad(s, 12);

  Amt := Min(Amt, FNCols - Start + 1);
  for j := byte(Start = 1) to Amt - 1 do
    begin
    c := Start + j;
    x := Data[L, Start + j];
    if not wsgLib.isMissValue(x) then
      AppendStr(S, Format('%*.*g',[Struct.Col[c].Size, PrintOptions.ColPrecision, Fuzz(x)]))
    else
      AppendStr(S, Format('%*s',[Struct.Col[c].Size, '.']))
    end;

  if PrintOptions.Center Then Buffer.Add(StrCenter(s, 110)) Else Buffer.Add(s);
  Result := Length(S)
end; { TWSMatrix.ToChar }

Procedure TwsDataSetChuvaz.Header(Start, Amt: Longint; Buffer: TStrings);
Var j, k, c: Longint;
    L: Word;
    st, P: string;
    SL: TStrings;
    Col: TwsDataSetCol;
    Mensal: Boolean;
Begin
  Mensal := (TipoIntervalo = tiMensal);
  Try
    Buffer.Add('');
    k := integer((nRows > 0) and (Row[1].Name <> ''));

    if FIPD Then
       L := Length('xx/xx/xxxx ')
    else
       L := Length(IntToStr(nRows) + ' ');

    P := StringOfChar(' ', L);
    P := LeftPad(P, 12);

    for j := 2 to Amt do
      begin
      c  := Start+j;
      st := Struct.Col[c].Name;
      L  := Length(Format('%*.*g',
                   [Struct.Col[c].Size, PrintOptions.ColPrecision, Fuzz(9.99999999999999)]));

      if L <= Length(st) then L := Length(st);

      AppendStr(P, LeftPad(st, L));
      end;

      if PrintOptions.Center Then
         begin
         Buffer.Add(strCenter(P, 110));
         Buffer.Add(strCenter(StringOfChar('-', Length(P)), 110))
         end
      Else
         begin
         Buffer.Add(StringOfChar('-', Length(P)));
         Buffer.Add(P);
         end;

  Except
    P := 'Existe um erro nos Descritores do Conjunto de Dados --> ' + Name;
    Buffer.Add(P);
  End;
End;

function TwsDataSetChuvaz.getTipoIntervalo: TTipoIntervalo;
begin
 Result := TTipoIntervalo(Tag_1);
end;

function TwsDataSetChuvaz.getTipoDados: TTipoDados;
begin
  Result := TTipoDados(Tag_2);
end;

class function TwsDataSetChuvaz.UserCreate: TwsMatrix;
begin
  Result := TwsDataSetChuvaz.Create('');
end;

procedure TwsDataSetChuvaz.GetSheetValue(L, C: Integer; var IsNUM: Boolean;
                                                        var sValue: String;
                                                        var rValue: Real);
var x: Double;
begin
  if C = 0 then
     begin
     IsNUM := False;
     sValue := intToStr(L);
     end
  else if C = 1 then
     begin
     IsNUM := False;
     sValue := DateToStr(AsDateTime[L, 1])
     end
  else
     if not Self.IsMissValue(L, C, x) then
        begin
        IsNUM := True;
        rValue := x
        end
     else
        begin
        IsNUM := False;
        sValue := '';
        end;
end;
*)
{ TSeries }

function TSeries.Adicionar(Serie: TSerie): Integer;
begin
  Result := FList.Add(Serie);
end;

constructor TSeries.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TSeries.Destroy;
var i: Integer;
begin
  for i := 0 to FList.Count-1 do TObject(FList[i]).Free;
  FList.Free;
  inherited;
end;

function TSeries.getSerie(i: integer): TSerie;
begin
  Result := TSerie(FList[i]);
end;

function TSeries.getNumSeries: Integer;
begin
  Result := FList.Count;
end;

{ TPosto }

constructor TPosto.Create(const Nome: String; Info: TDSInfo);
begin
  inherited Create;

  FNome      := Nome;
  FInfo      := Info;
  FIndiceCol := Info.DS.Struct.IndexOf(Nome);
  FIndice    := 1;
  FDado      := FInfo.DS[FIndice, FIndiceCol];
  FSeries    := TSeries.Create;

  DecodeDate(FInfo.DS.AsDateTime[FIndice, 1], FAno, FMes, FDia);
end;

destructor TPosto.Destroy;
begin
  FSeries.Free;
  inherited;
end;

procedure TPosto.ExecutarAcaoPadrao(Evento: TNotifyEvent);
begin
  inherited;
  ShowMessage('ExecutarAcaoPadrao');
end;

procedure TPosto.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited;
  CriarAcao(Acoes, 'Mostrar em Planilha', nil);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Calcular Máximos Diários Anuais', ActionManager.SerieVetor_Ind_CriarMaximosDiariosAnuais);
  CriarAcao(Acoes, 'Calcular Mínimos Diários Anuais', ActionManager.SerieVetor_Ind_CriarMinimosDiariosAnuais);
  CriarAcao(Acoes, 'Calcular Totais Anuais'         , ActionManager.SerieVetor_Ind_TotaisAnuais);
  CriarAcao(Acoes, 'Calcular Medias Anuais'         , ActionManager.SerieVetor_Ind_MediasAnuais);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Calcular Totais Mensais Anuais' , ActionManager.SerieVetor_Ind_TotaisMensaisAnuais);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Máximos Diários Parciais'        , ActionManager.SerieVetor_Ind_Parcial_Maximos_Diario);
  CriarAcao(Acoes, 'Mínimos Diários Parciais'        , ActionManager.SerieVetor_Ind_Parcial_Minimos_Diario);
  CriarAcao(Acoes, 'Máximas Totais Mensais Parciais' , ActionManager.SerieVetor_Ind_Parcial_Maximas_TotalMensal);
  CriarAcao(Acoes, 'Mínimas Totais Mensais Parciais' , ActionManager.SerieVetor_Ind_Parcial_Minimas_TotalMensal);
  CriarAcao(Acoes, 'Máximas Médias Mensais Parciais' , ActionManager.SerieVetor_Ind_Parcial_Maximas_MediaMensal);
  CriarAcao(Acoes, 'Mínimas Médias Mensais Parciais' , ActionManager.SerieVetor_Ind_Parcial_Minimas_MediaMensal);
end;

function TPosto.ObterResumo: String;
begin
  Result := 'Período: ' + FInfo.DataDoPrimeiroValorValido(Nome) + ' a ' +
                          FInfo.DataDoUltimoValorValido(Nome)
end;

function TPosto.VaiPara(const Data: TDateTime): Integer;
begin
  FIndice := FInfo.IndiceDaData(Data);
  DecodeDate(FInfo.DS.AsDateTime[FIndice, 1], FAno, FMes, FDia);
  Result := FIndice;
end;

// Nunca retorna -1
function TPosto.VaiParaFinalDoMes: Integer;
var i: Integer;
begin
  i := DaysInAMonth(FAno, FMes);

  inc(FIndice, i-FDia);
  if FIndice <= FInfo.DS.NRows then
     FDia := i
  else
     begin
     FIndice := FInfo.DS.NRows;
     DecodeDate(FInfo.DS.AsDateTime[FIndice, 1], FAno, FMes, FDia);
     end;

  Result := FIndice;
end;

function TPosto.VaiParaProximoAno: Integer;
var Ano, Mes, Dia: Word;
begin
  Result := FIndice;
  Ano := FAno;
  Mes := FMes;
  Dia := FDia;

  while (Result < FInfo.DS.NRows) and (Ano = FAno) do
    begin
    inc(Result);
    DecodeDate(FInfo.DS.AsDateTime[Result, 1], Ano, Mes, Dia);
    end;

  if Ano <> FAno then
     begin
     FIndice := Result;
     FAno := Ano;
     FMes := Mes;
     FDia := Dia;
     end
  else
     Result := -1;
end;

// se o ano mudar, a posição não será alterada
function TPosto.VaiParaProximoDia: Integer;
var Ano, Mes, Dia: Word;
begin
  Result := FIndice;
  Ano := FAno;
  Mes := FMes;
  Dia := FDia;

  inc(Result);
  if Result <= FInfo.DS.NRows then
     begin
     DecodeDate(FInfo.DS.AsDateTime[Result, 1], Ano, Mes, Dia);
     FAno := Ano;
     FMes := Mes;
     FDia := Dia;
     FIndice := Result;
     end
  else
     Result := -1;
end;

function TPosto.VaiParaProximoDiaDoAnoAtual: Integer;
var Ano, Mes, Dia: Word;
begin
  Result := FIndice;
  Ano := FAno;
  Mes := FMes;
  Dia := FDia;

  inc(Result);
  if Result <= FInfo.DS.NRows then
     begin
     DecodeDate(FInfo.DS.AsDateTime[Result, 1], Ano, Mes, Dia);
     if Ano <> FAno then
        Result := -1
     else
        begin
        FAno := Ano;
        FMes := Mes;
        FDia := Dia;
        FIndice := Result;
        end;
     end
  else
     Result := -1;
end;

{ TSerie }

constructor TSerie.Create(Posto: TPosto);
begin
  inherited Create;
  FAcoes := TActionList.Create(nil);
  FPosto := Posto;
  Iniciar;
  Calcular;
end;

destructor TSerie.Destroy;
begin
  FAcoes.Free;
  inherited;
end;

{ TSerie_Anual }

destructor TSerie_Anual.Destroy;
begin
  FRes.Free;
  inherited;
end;

function TSerie_Anual.ObterResumo: String;
var i, Ano: Integer;
begin
  Result := '(' + IntToStr(FRes.Len) + ' anos)   Dados:  ';

  Ano := YearOF(FPosto.Info.DataInicial);
  if FRes.Len > 5 then
     for i := 1 to 5 do
        Result := Result + Format('(%d) %f   ', [Ano + i - 1, FRes[i]]);

  Result := Result + '...';
end;
(*
procedure TSerie_AgrupamentoAnual.CalcularMedia(Sender: TObject);
var n: Integer;
    x: Double;
begin
  x := FRes.Mean(n);
  ShowMessage(Format('Número de Valores Válidos: %d'#13#10 +
                     'Média dos %d Valores: %f', [n, n, x]));
end;
*)
procedure TSerie_Anual.MostrarEmPlanilha(Planilha: TPlanilha; Coluna: Word);
begin
  // Cabecalho das colunas
  Planilha.SetCellFont(1, Coluna, 'arial', 10, clBlack, true);
  Planilha.Write(1, Coluna, FNome);
  Planilha.SetCellFont(2, Coluna, 'arial', 10, clBlack, true);
  Planilha.Write(2, Coluna, FPosto.Nome);

  // Escreve os valores
  Planilha.WriteVecInCol(FRes, Coluna, 3);
end;

procedure TSerie_Anual.Plotar(Grafico: TfoChart; Ordem: Word);
var s: TLineSeries;
    i, Ano, AnoIni: Integer;
    y: Double;
    ii, ff: Integer;
begin
  s := Grafico.Series.AddLineSerie(FNome + ' (' + FPosto.Nome + ')', SelectColor(Ordem));
  AnoIni := YearOf(FPosto.Info.DataInicial);

  // evita um inicio com dados nulos
  for i := 1 to FRes.Len do
    if not FRes.IsMissValue(i, y) then
       begin
       ii := i;
       break;
       end;

  // evita um fim com dados nulos
  for i := FRes.Len downto 1 do
    if not FRes.IsMissValue(i, y) then
       begin
       ff := i;
       break;
       end;

  // Isto é feito para se evitar um bug no TeeChart com valores Null no inicio ou no final
  for i := ii to ff do
    begin
    Ano := AnoIni + i - 1;
    if FRes.IsMissValue(i, y) then
       s.AddNullXY(Ano, 0, intToStr(Ano))
    else
       s.AddXY(Ano, y, intToStr(Ano));
       end;
end;

// Método genérico de cálculo
procedure TSerie_Anual.Calcular;
Var AnoInicial, AnoFinal, k     : Word;
    Ano, Mes, Dia               : Word;
    IndiceInicial, IndiceFinal  : Integer;
begin
  AnoInicial := YearOf(FPosto.Info.DataInicial);
  AnoFinal   := YearOf(FPosto.Info.DataFinal);

  k := 0;
  FRes.Free;
  FRes := TwsDFVec.Create(AnoFinal - AnoInicial + 1);
  FRes.Fill(wscMissValue);

  // Calcula as estatísticas para cada ano
  For Ano := AnoInicial To AnoFinal Do
    begin
    Inc(k);

    IndiceInicial := FPosto.Info.IndiceDaData('01/01/' + IntToStr(Ano));
    if IndiceInicial = -1 then Continue;

    IndiceFinal := FPosto.Info.IndiceDaData('31/12/' + IntToStr(Ano));
    if IndiceFinal = -1 then Continue;

    if IndiceInicial = IndiceFinal then
       FRes[k] := FPosto.Info.DS[IndiceInicial, FPosto.IndiceCol]
    else
       FRes[k] := SelecionarValorOuAgregar(IndiceInicial, IndiceFinal);
    end;   {For Ano...}
end;

procedure TSerie_Anual.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited;
  CriarAcao(Acoes, 'Mostrar em Planilha'      , ActionManager.SerieVetor_Ind_MostrarEmPlanilha);
  CriarAcao(Acoes, 'Mostrar em Gráfico'       , ActionManager.SerieVetor_Ind_Graficar);
end;

procedure TSerie_Anual.ObterAcoesColetivas(Acoes: TActionList);
begin
  inherited;
  CriarAcao(Acoes, 'Mostrar em Planilha'      , ActionManager.SerieVetor_Col_MostrarEmPlanilha);
  CriarAcao(Acoes, 'Mostrar em Gráfico'       , ActionManager.SerieVetor_Col_Graficar);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Calcular Coefs. de Correlação' , ActionManager.SerieVetor_Col_CoefCorrel);
end;

function TSerie_Anual.GetAnoInicial: Word;
begin
  Result := YearOf(FPosto.Info.DataInicial);
end;

function TSerie_Anual.GetAnoFinal: Word;
begin
  Result := YearOf(FPosto.Info.DataFinal);
end;

{ TSerie_Anual_Diaria_Maximos }

function TSerie_Anual_Diaria_Maximos.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
begin
  Result := wsMatrixMax(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal);
end;

procedure TSerie_Anual_Diaria_Maximos.Iniciar;
begin
  FNome := 'Max.An.';
end;

{ TSerie_Anual_Diaria_Minimos }

// Obtém os menores valores não nulos
Function TSerie_Anual_Diaria_Minimos.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
var y, x: Real;
    i, k: Integer;
begin
  y := 999999999999; // número muito grande
  for i := LinhaInicial to LinhaFinal do
    begin
    x := FPosto.Info.DS[i, FPosto.IndiceCol];
    if (x > 0) and (x < y) then y := x;
    end;

  if y < 999999999999 then
     Result := y
  else
     Result := wscMissValue;
end;

procedure TSerie_Anual_Diaria_Minimos.Iniciar;
begin
  FNome := 'Min.An.';
end;

{ TSerie_Anual_PF }

procedure TSerie_Anual_PF.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Preencher Falhas por Reg.Lin.Simples', nil);
end;

{ TSerie_Anual_Diaria }

procedure TSerie_Anual_Diaria.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Gráfico Dupla Massa'            , nil);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Análise de Frequência Empírica' , nil);
  CriarAcao(Acoes, 'Análise de Frequência Teórica'  , nil);
end;

{ TSerie_Anual_Agregada_Totais }

function TSerie_Anual_Agregada_Totais.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
var NumSomados: Integer;
begin
  Result := wsMatrixSum(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, NumSomados);
end;

procedure TSerie_Anual_Agregada_Totais.Iniciar;
begin
  FNome := 'Tot.An.';
end;

{ TSerie_Anual_Agregada_Medias }

function TSerie_Anual_Agregada_Medias.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
begin
  Result := wsMatrixMean(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal);
end;

procedure TSerie_Anual_Agregada_Medias.Iniciar;
begin
  FNome := 'Med.An.';
end;

{ TSerie_Anual_Mensal }

procedure TSerie_Anual_Mensal.Calcular;
Var i, j, k    : Integer;
    d1, d2     : TDateTime;
    FAgregados : TwsDFVec;
begin
  FRes.Free;
  FRes := TwsDFVec.Create(YearOf(FPosto.Info.DataFinal) - YearOf(FPosto.Info.DataInicial) + 1);
  FAgregados := TwsDFVec.Create(12);
  try
    j := 1;
    i := FPosto.VaiPara(FPosto.Info.DataInicial);
    repeat // para todos os anos
      k := FPosto.VaiParaFinalDoMes;
      FAgregados.Fill(wscMissValue);

      while i <> -1 do // para todos os meses
        begin
        FAgregados[FPosto.Mes] := AgregarMes(i, k);
        i := FPosto.VaiParaProximoDiaDoAnoAtual;
        if i > -1 then k := FPosto.VaiParaFinalDoMes;
        end;

      FRes[j] := SelecionarValor(FAgregados); inc(j);
      i := FPosto.VaiParaProximoAno;
    until i = -1;
  finally
    FAgregados.Free;
  end;
end;

{ TSerie_Anual_Mensal_AG_Total }

function TSerie_Anual_Mensal_AG_Total.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
var NumSomados: Integer;
begin
  Result := wsMatrixSum(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, NumSomados);
end;

{ TSerie_Anual_Mensal_AG_Media }

function TSerie_Anual_Mensal_AG_Media.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
begin
  Result := wsMatrixMean(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal);
end;

{ TSerie_Anual_Mensal_AG_Media_Medias }

function TSerie_Anual_Mensal_AG_Media_Medias.SelecionarValor(Valores: TwsDFVec): Real;
var outN: Integer;
begin
  Result := Valores.Mean(outN);
end;

procedure TSerie_Anual_Mensal_AG_Media_Medias.Iniciar;
begin
  FNome := 'Med.Men.An.';
end;

{ TSerie_Anual_Mensal_AG_Total_Medias }

function TSerie_Anual_Mensal_AG_Total_Medias.SelecionarValor(Valores: TwsDFVec): Real;
var outN: Integer;
begin
  Result := Valores.Mean(outN);
end;

procedure TSerie_Anual_Mensal_AG_Total_Medias.Iniciar;
begin
  FNome := 'Tot.Men.An.';
end;

{ TSerie_Anual_Mensal_AG_Total_Maximos }

function TSerie_Anual_Mensal_AG_Total_Maximos.SelecionarValor(Valores: TwsDFVec): Real;
begin
  Result := Valores.Max;
end;

procedure TSerie_Anual_Mensal_AG_Total_Maximos.Iniciar;
begin
  FNome := 'Max.Tot.Men.An.';
end;

{ TSerie_Anual_Mensal_AG_Total_Minimos }

function TSerie_Anual_Mensal_AG_Total_Minimos.SelecionarValor(Valores: TwsDFVec): Real;
begin
  Result := Valores.Min;
end;

procedure TSerie_Anual_Mensal_AG_Total_Minimos.Iniciar;
begin
  FNome := 'Min.Tot.Men.An.';
end;

{ TSerie_Parcial }

constructor TSerie_Parcial.Create(Posto: TPosto; const ValorBase: Real);
begin
  FBase := ValorBase;
  inherited Create(Posto);
end;

destructor TSerie_Parcial.Destroy;
begin
  FRes.Free;
  inherited;
end;

procedure TSerie_Parcial.MostrarEmPlanilha(Planilha: TPlanilha; Coluna: Word);
begin
  // Cabecalho das colunas
  Planilha.SetCellFont(1, Coluna, 'arial', 10, clBlack, true);
  Planilha.Write(1, Coluna, FNome);
  Planilha.SetCellFont(2, Coluna, 'arial', 10, clBlack, true);
  Planilha.Write(2, Coluna, FPosto.Nome);

  // Escreve os valores
  Planilha.WriteVecInCol(FRes, Coluna, 3);
end;

procedure TSerie_Parcial.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited;
  CriarAcao(Acoes, 'Mostrar em Planilha', ActionManager.SerieVetor_Ind_Parcial_MostrarEmPlanilha);
end;

procedure TSerie_Parcial.ObterAcoesColetivas(Acoes: TActionList);
begin
  inherited;
  CriarAcao(Acoes, 'Mostrar em Planilha'      , {ActionManager.SerieVetor_Col_MostrarEmPlanilha_??} nil);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Calcular Coef.Correlação' , nil);
end;

function TSerie_Parcial.ObterResumo: String;
var i, Ano: Integer;
begin
  Result := '(' + IntToStr(FRes.Len) + ' Elementos)    Valor Base: ' + FloatToStr(FBase) +
            '    Dados:  ';

  Ano := YearOF(FPosto.Info.DataInicial);
  if FRes.Len > 5 then
     for i := 1 to 5 do
        Result := Result + Format('(%d) %f   ', [Ano + i - 1, FRes[i]]);

  Result := Result + '...';
end;

{ TSerie_Parcial_Diaria }

procedure TSerie_Parcial_Diaria.Calcular;
Var IndiceInicial, IndiceFinal: Integer;
    i, k: Integer;
    L: TDoubleList;
    x: Double;
begin
  IndiceInicial := FPosto.Info.IndiceDaData(FPosto.Info.DataDoPrimeiroValorValido(FPosto.Nome));
  IndiceFinal   := FPosto.Info.IndiceDaData(FPosto.Info.DataDoUltimoValorValido(FPosto.Nome));

  L := TDoubleList.Create;

  // Percorre os dados do posto
  For i := IndiceInicial To IndiceFinal Do
    if not FPosto.Info.DS.IsMissValue(i, FPosto.IndiceCol, {out} x) then
       if SelecionarValor(x) then
          L.Add(x);

  // Passa os valores da lista temporária para o vetor definitivo
  FRes.Free;
  FRes := TwsDFVec.Create(L.Count);
  for i := 0 to L.Count-1 do FRes[i+1] := L[i];

  L.Free;
end;

procedure TSerie_Parcial_Diaria.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Análise de Frequência Empírica' , nil);
  CriarAcao(Acoes, 'Análise de Frequência Teórica'  , nil);
end;

{ TSerie_Parcial_Diaria_Maximos }

procedure TSerie_Parcial_Diaria_Maximos.Iniciar;
begin
  FNome := 'Max.Dia.Parc.';
end;

function TSerie_Parcial_Diaria_Maximos.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor >= FBase);
end;

{ TSerie_Parcial_Diaria_Minimos }

procedure TSerie_Parcial_Diaria_Minimos.Iniciar;
begin
  FNome := 'Min.Dia.Parc.';
end;

function TSerie_Parcial_Diaria_Minimos.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor > 0) and (Valor <= FBase);
end;

{ TSerie_Parcial_AG_Mensal }

procedure TSerie_Parcial_AG_Mensal.Calcular;
Var i, k: Integer;
    L: TDoubleList;
    x: Real;
begin
  L := TDoubleList.Create;

  i := FPosto.VaiPara(StrToDate(FPosto.Info.DataDoPrimeiroValorValido(FPosto.Nome)));
  while i <> -1 do
    begin
    k := FPosto.VaiParaFinalDoMes;
    x := AgregarMes(i, k);
    if SelecionarValor(x) then L.Add(x);
    i := FPosto.VaiParaProximoDia;
    end;

  // Passa os valores da lista temporária para o vetor definitivo
  FRes.Free;
  FRes := TwsDFVec.Create(L.Count);
  for i := 0 to L.Count-1 do FRes[i+1] := L[i];

  L.Free;
end;

procedure TSerie_Parcial_AG_Mensal.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CriarAcao(Acoes, '-', nil);
  CriarAcao(Acoes, 'Preencher Falhas por Reg.Lin.Simples', nil);
end;

{ TSerie_Parcial_TotalMensal }

function TSerie_Parcial_TotalMensal.AgregarMes(LinhaInicial, LinhaFinal: Integer): Real;
var NumSomados: Integer;
begin
  Result := wsMatrixSum(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, NumSomados);
end;

{ TSerie_Parcial_TotalMensal_Maximas }

procedure TSerie_Parcial_TotalMensal_Maximas.Iniciar;
begin
  FNome := 'Max.Tot.Men.Parc.';
end;

function TSerie_Parcial_TotalMensal_Maximas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor >= FBase);
end;

{ TSerie_Parcial_TotalMensal_Minimas }

procedure TSerie_Parcial_TotalMensal_Minimas.Iniciar;
begin
  FNome := 'Min.Tot.Men.Parc.';
end;

function TSerie_Parcial_TotalMensal_Minimas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor <= FBase);
end;

{ TSerie_Parcial_MediaMensal }

function TSerie_Parcial_MediaMensal.AgregarMes(LinhaInicial, LinhaFinal: Integer): Real;
begin
  Result := wsMatrixMean(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal);
end;

{ TSerie_Parcial_MediaMensal_Maximas }

procedure TSerie_Parcial_MediaMensal_Maximas.Iniciar;
begin
  FNome := 'Max.Med.Men.Parc.';
end;

function TSerie_Parcial_MediaMensal_Maximas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor >= FBase);
end;

{ TSerie_Parcial_MediaMensal_Minimas }

procedure TSerie_Parcial_MediaMensal_Minimas.Iniciar;
begin
  FNome := 'Min.Med.Men.Parc.';
end;

function TSerie_Parcial_MediaMensal_Minimas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor <= FBase);
end;

{ TchApplication }

procedure TchApplication.BeforeRun();
begin
  inherited BeforeRun();
  SysUtils.ShortDateFormat := 'dd/mm/yyyy';
  WinUtils.PixelsPerInch := 96;
  ActionManager := Tch_ActionManager.Create(FTree);

  FErrors := TErros_DLG.Create(nil);
  FOutPut := TwsOutPut.Create();
  FOutPut.Editor.FormStyle := fsStayOnTop;
end;

procedure TchApplication.CreateMainForm();
var Main: TDLG_Principal;
begin
  CreateForm(TDLG_Principal, Main);
  FTree := Main.Arvore;
end;

procedure TchApplication.PostRun();
begin
  FOutPut.Free();
  FErrors.Free();
  ActionManager.Free();
  inherited PostRun();
end;

procedure TchApplication.ip_NewDataSet(const iniDate, endDate: TDateTime; const StationCount: integer);
begin

end;

procedure TchApplication.ip_SetStationName(StationIndex: integer; const Name: string);
begin

end;

procedure TchApplication.ip_SetStationValue(Date: TDateTime; StationIndex: integer; const Value: real);
begin

end;

procedure TchApplication.ip_DoneImport();
begin

end;

end.
