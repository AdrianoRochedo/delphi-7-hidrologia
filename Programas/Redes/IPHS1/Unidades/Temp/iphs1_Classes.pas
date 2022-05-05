unit iphs1_Classes;

{
  Instruções de como implementar processos: Olhar arquivo "Como (How-To).txt"
}

{
  Sempre procurar pelo símbolo "<<<", ele indica coisas inacabadas ou desabilitadas
}

{  ******************** OBS. ***********************
   TabPrecip (SubBacias) - é criada com NIT linhas mas é preenchida com NITC linhas de dados
                           na leitura das operações.
                           >>>> Mudei para NITC na criação em 07/06/2002
                           >>>> Tambem modifiquei algumas validacoes nos dados do projeto para
                                os testes.
}

interface
uses Windows, Messages, Classes, Forms, SysUtils, ExtCtrls,
     Graphics, Controls, ComCtrls, Menus, Contnrs,
     teEngine,
     drGraficos,

     // Misc
     MessageManager,
     Shapes,
     psBASE,
     psCORE,
     SysUtilsEx,
     ErrosDLG,
     wsMatrix,

     // Unidades Básicas
     Hidro_Constantes,
     Hidro_Variaveis,
     Hidro_Classes,
     Hidro_Tipos,
     iphs1_Tipos,

     // Planilhas
     Planilha_Base,

     // Forms
     Dialogo_Base;

type
  Tiphs1_SubBacia   = Class;
  Tiphs1_Projeto    = Class;
  Tiphs1_PCR        = Class;

  Tiphs1_TrechoDagua = class(TTrechoDagua)
  private
    FSB : Tiphs1_SubBacia;

    FMPE    : TenMPE;
    FRPI    : Real;
    FCFPI   : Real;
    FCTP    : Real;
    FVR     : Real;
    FLPI    : Real;
    FDFC    : Real;
    FLC     : Real;
    FRST    : Real;
    FITC    : Integer;
    FNHCL   : Integer;
    FNST    : Integer;
    FNPT_KX : Integer;
    FTab_KX : TTab3D;
  protected
    procedure PlotarHidrogramasEm(G: TgrGrafico); override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure AutoDescricao(Identacao: byte); override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure PrepararParaSimulacao; override;
    function  ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure DesconectarObjetos; override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;
  public
    constructor Create(PC1, PC2: TPC; UmaTabelaDeNomes: TStrings; Projeto: TProjeto);
    destructor Destroy; override;

    property SubBacia : Tiphs1_SubBacia read FSB;

    // compartilhadas por CL, CNL e CPI
    property CTP  : Real    read FCTP  write FCTP;
    property DFC  : Real    read FDFC  write FDFC;
    property LC   : Real    read FLC   write FLC;
    property RST  : Real    read FRST  write FRST;
    property ITC  : Integer read FITC  write FITC;
    property NHCL : Integer read FNHCL write FNHCL;
    property NST  : Integer read FNST  write FNST;

    // complemento de CL
    property VR : Real read FVR write FVR;

    // complemento de CPI
    property CFPI : Real read FCFPI write FCFPI;
    property LPI  : Real read FLPI  write FLPI;
    property RPI  : Real read FRPI  write FRPI;

    // KX
    property NPT_KX : Integer read FNPT_KX write FNPT_KX;
    property Tab_KX : TTab3D  read FTab_KX write FTab_KX;

    property MPE : TenMPE read FMPE write FMPE;
  end;

  Tiphs1_Derivacao = class(THidroComponente)  // Reservatorio
  private
    FCPD: Real;
    FCPR: Real;
    FCDL: Real;
    FCDD: Real;
    FCPL: Real;
    FCDR: Real;
  protected
    Function  ObtemPrefixo: String; Override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure AutoDescricao(Identacao: byte); override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;
  public
    constructor Create(Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    property CDD : Real read FCDD write FCDD;
    property CDL : Real read FCDL write FCDL;
    property CDR : Real read FCDR write FCDR;
    property CPD : Real read FCPD write FCPD;
    property CPL : Real read FCPL write FCPL;
    property CPR : Real read FCPR write FCPR;
  end;

  Tiphs1_PC_Base = Class(TPC)
  protected
    function CriarTrechoDagua(ConectarEm: TPC): TTrechoDagua; override;
    procedure PlotarHidrogramasEm(G: TgrGrafico); override;
  end;

  Tiphs1_PC = class(Tiphs1_PC_Base)
  private
    FDerivacao: Tiphs1_Derivacao;
  protected
    procedure PlotarHidrogramasEm(G: TgrGrafico); override;
    Function ObtemPrefixo: String; Override;
    function CriarDialogo: TForm_Dialogo_Base; Override;
    function ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure DesconectarObjetos; override;
    function ReceiveMessage(const MSG: TadvMessage): Boolean; override;
    function PossuiObjetosConectados: Boolean; override;
    procedure SalvarEmArquivo(Arquivo: TIF); override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    function CriarInstancia: THidroObjeto;  override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
  public
    constructor Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    function MudarParaReservatorio(UmMenu: TPopupMenu): Tiphs1_PCR;
    property Derivacao : Tiphs1_Derivacao read FDerivacao;
  end;

  Tiphs1_EstruturaRes_Q = class
  private
    FNPT: byte;
    FIT: Integer;
    FTab: TTab2D;
  public
    constructor Create(IT, NumPontos: Integer);
    destructor Destroy; override;

    procedure SalvarEmArquivo(Arquivo: TIF; const Secao, SubSecao: String);
    procedure LerDoArquivo(Arquivo: TIF; const Secao, SubSecao: String);
    procedure Associar(Estrutura: Tiphs1_EstruturaRes_Q);

    property IT   : Integer read FIT   write FIT;
    property NPT  : byte    read FNPT  write FNPT;
    property Tab  : TTab2D  read FTab  write FTab;
  end;

  Tiphs1_EstruturasRes_Q = class
  private
    FList: TObjectList;
    function GetEst(i: Integer): Tiphs1_EstruturaRes_Q;
    function GetNumEstr: Integer;
    procedure SetNumEstr(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function  Adicionar(IT, NumPontos: Integer): Tiphs1_EstruturaRes_Q;
    procedure SalvarEmArquivo(Arquivo: TIF; const Secao: String);
    procedure LerDoArquivo(Arquivo: TIF; const Secao: String);
    procedure Associar(Estruturas: Tiphs1_EstruturasRes_Q);

    property NumEstruturas : Integer read GetNumEstr write SetNumEstr;
    property Estrutura[i: Integer] : Tiphs1_EstruturaRes_Q read GetEst; default;
  end;

  Tiphs1_PCR = class(Tiphs1_PC_Base)  // Reservatorio
  private
    FNO    : byte;
    FAI    : Real;
    FH_NPT : byte;
    FH_LV  : Real;
    FH_CCV : Real;
    FH_CD  : Real;
    FH_Tab : TTab2D;
    FQ: Tiphs1_EstruturasRes_Q;
  protected
    Function  ObtemPrefixo: String; Override;
    function  PossuiObjetosConectados: Boolean; override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    procedure AutoDescricao(Identacao: byte); override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    function  CriarInstancia: THidroObjeto;  override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;
  public
    constructor Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;
    function MudarParaPC(UmMenu: TPopupMenu): Tiphs1_PC;

    property AI : Real read FAI write FAI;
    property NO : byte read FNO write FNO;

    // H
    property H_CCV  : Real   read FH_CCV  write FH_CCV;
    property H_CD   : Real   read FH_CD   write FH_CD;
    property H_LV   : Real   read FH_LV   write FH_LV;
    property H_NPT  : byte   read FH_NPT  write FH_NPT;
    property H_Tab  : TTab2D read FH_Tab  write FH_Tab;

    property Q : Tiphs1_EstruturasRes_Q read FQ;
  end;

  Tiphs1_SubBacia = Class(TSubBacia)
  private
    FCL_NPT   : byte;
    FCL_DB    : Real;
    FCL_XN    : Real;
    FCL_KS    : Real;
    FCL_Tab   : TTab1D;

    FFI_PI    : Real;
    FFI_I     : Real;

    FHEC_EI   : Real;
    FHEC_VI   : Real;
    FHEC_PD   : Real;
    FHEC_LP   : Real;

    FHO_EE    : Real;
    FHO_EI    : Real;
    FHO_CI    : Real;
    FHO_IB    : Real;

    FHT_DB    : Real;

    FHU_NPT   : byte;
    FHU_Tab   : TTab1D;

    FHY_CC    : Real;
    FHY_DN    : Real;
    FHY_RR    : Real;
    FHY_TP    : Real;

    FIP_IO    : Real;
    FIP_IB    : Real;
    FIP_PAI   : Real;
    FIP_RMAX  : Real;
    FIP_VB    : Real;
    FIP_H     : Real;

    FPEB_VB   : Real;
    FPEB_PR   : Real;
    FPEB      : Boolean;

    FSCS_CN   : Real;

    //FIT       : boolean;
    FIR       : boolean;
    FAB       : Real;
    FTC       : Real;
    FTabT     : Real;
    FH        : String;
    FTipo     : TenTipoSubBacia;
    FES       : TenES;
    FSE       : TenSE;
    FTP       : TenTP;
    FPM       : Real;    // <<< deprecated
    FCoefs    : TTab1D;
    FTabPrecip: TwsDataSet;
  protected
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PrepararParaSimulacao; override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    function  ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure DesconectarObjetos;
    procedure AutoDescricao(Identacao: byte); override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;
  public
    constructor Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    procedure Copiar(SB: Tiphs1_SubBacia);

    procedure PlotarHidrogramaResultante; override;
    procedure PlotarGrafico_Perdas_X_Efetiva;
    procedure PlotarTabelaDePrecipitacoes;
    procedure MostrarTabPrecipitacao;

    property Tipo : TenTipoSubBacia read FTipo write FTipo;

    // TCV.Base
    property PM         : Real     read FPM     write FPM;
    property IR         : boolean  read FIR     write FIR;
    property AB         : Real     read FAB     write FAB;
    property TC         : Real     read FTC     write FTC;
    property Tab_T      : Real     read FTabT   write FTabT;
    property Coefs      : TTab1D   read FCoefs  write FCoefs;
    property Hidrograma : String   read FH      write FH;

    // TCV.CLARK
    property CL_DB    : Real    read FCL_DB    write FCL_DB;
    property CL_KS    : Real    read FCL_KS    write FCL_KS;
    property CL_NPT   : byte    read FCL_NPT   write FCL_NPT;
    property CL_XN    : Real    read FCL_XN    write FCL_XN;
    property CL_Tab   : TTab1D  read FCL_Tab   write FCL_Tab;

    // TCV.FI
    property FI_I  : Real read FFI_I  write FFI_I;
    property FI_PI : Real read FFI_PI write FFI_PI;

    // TCV.HEC
    property HEC_EI : Real read FHEC_EI write FHEC_EI;
    property HEC_LP : Real read FHEC_LP write FHEC_LP;
    property HEC_PD : Real read FHEC_PD write FHEC_PD;
    property HEC_VI : Real read FHEC_VI write FHEC_VI;

    // TCV.HOLTAN
    property HO_CI : Real read FHO_CI write FHO_CI;
    property HO_EE : Real read FHO_EE write FHO_EE;
    property HO_EI : Real read FHO_EI write FHO_EI;
    property HO_IB : Real read FHO_IB write FHO_IB;

    // TCV.HT
    property HT_DB : Real read FHT_DB write FHT_DB;

    // TCV.HU
    property HU_NPT : byte   read FHU_NPT write FHU_NPT;
    property HU_Tab : TTab1D read FHU_Tab write FHU_Tab;

    // TCV.HYMO
    property HY_CC : Real read FHY_CC write FHY_CC;
    property HY_DN : Real read FHY_DN write FHY_DN;
    property HY_RR : Real read FHY_RR write FHY_RR;
    property HY_TP : Real read FHY_TP write FHY_TP;

    // TCV.IPHII
    property IP_H    : Real read FIP_H    write FIP_H;
    property IP_IB   : Real read FIP_IB   write FIP_IB;
    property IP_IO   : Real read FIP_IO   write FIP_IO;
    property IP_PAI  : Real read FIP_PAI  write FIP_PAI;
    property IP_RMAX : Real read FIP_RMAX write FIP_RMAX;
    property IP_VB   : Real read FIP_VB   write FIP_VB;

    // TCV.PEB
    property PEB    : Boolean read FPEB    write FPEB;
    property PEB_PR : Real    read FPEB_PR write FPEB_PR;
    property PEB_VB : Real    read FPEB_VB write FPEB_VB;

    // TCV
    property TP : TenTP read FTP write FTP; // Tormenta de Projeto
    property SE : TenSE read FSE write FSE; // Separaçao do Escoamento
    property ES : TenES read FES write FES; // Escoamento Superficial

    // TCV.SCS
    property SCS_CN : Real read FSCS_CN write FSCS_CN;

    // Resultados
    property TabPrecip : TwsDataSet read FTabPrecip;
  end;

  Tiphs1_Projeto = Class(TProjeto)
  private
    FPChuva: TStrings;
    FNIT: word;
    FME: TenModoDeExecucao;
    FTIT: Real;
    FNITC: word;
    FDadosPostos: TwsDataSet;

    procedure PrepararCarta(SL: TStrings);
    procedure Ler_Objetos(Ini: TIF; const NomeDoPC: String);

    // Eventos da simulação, conectados ao objeto "Simulador"
    procedure Temporizador (Sender: TObject; out EventID: Integer);
    procedure Simulacao    (Sender: TObject; const EventID: Integer);

    procedure LerTrechoDaguaDoPC(Ini: TIF; const NomePC: String);
    function  LerSubBacia(Ini: TIF; const Nome: String): Tiphs1_SubBacia;
    function  LerPC(Ini: TIF; const NomeDoPC: String): TPC;

    procedure LerResultados(const Arquivo: String);
  protected
    procedure ExecutarSimulacao; override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    procedure LerDoArquivo(Ini: TIF; const Secao: String); Overload; Override;
    procedure SalvarEmArquivo(Arquivo: TIF); Overload; Override;
    procedure AutoDescricao(Identacao: byte); override;
    procedure PrepararParaSimulacao; override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;
  public
    constructor Create(UmaTabelaDeNomes: TStrings);
    destructor  Destroy; override;

    procedure Executar;

    // Métodos da simulação
    function  RealizarDiagnostico(Completo: Boolean = False): Boolean; override;
    procedure TerminarSimulacao; override;

    // Métodos de relatório
    procedure RelatorioGeral;

    function  CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TgrGrafico;
    procedure DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);

    // Ajustar Título internamente <<<
    //procedure MostrarDataSet(const Titulo: String; Dados: TwsDataSet);

    // Trocar para MostrarVetor(Vetor: TV) <<< ???
    procedure MostraVariavel(const NomeVar: String); Virtual; Abstract;

    property ModoDeExecucao : TenModoDeExecucao read FME     write FME;       // Indica se estamos no modo DOS ou WIN
    property NIT            : word              read FNIT    write FNIT;      // Número de intervalos de tempo
    property NITC           : word              read FNITC   write FNITC;     // Número de intervalos de tempo com Chuva
    property TIT            : Real              read FTIT    write FTIT;      // Tamanho do intervalo de tempo
    property PChuva         : TStrings          read FPChuva write FPChuva;   // Postos de chuva

    // Resultados
    property DadosPostos : TwsDataSet read FDadosPostos;
  end;

implementation
uses Dialogs, ImgList, FileCTRL, edit, Math, stDate,
    //ovcIntL,
    drGraficosPlanilha
     ,{$IFDEF DEBUG} uDEBUG, {$ENDIF}
     //pr_Util,

     // Unidades básicas
     Hidro_Procs,
     iphs1_Procs,

     // Misc
     Execfile,
     wsVec,
     WinUtils,
     FileUtils,
     drPlanilha,
     Series,
     GraphicUtils,

     // Forms
     iphs1_AreaDeProjeto,
     iphs1_VisaoEmArvore,
     iphs1_Dialogo_Base,
     iphs1_Dialogo_TD,
     iphs1_Dialogo_PC,
     iphs1_Dialogo_RES,
     iphs1_Dialogo_SB,
     iphs1_Dialogo_Projeto,
     iphs1_Dialogo_Derivacao,

     // Frames
     FrameEstruturaRes_Q,

     // Planilhas
     Planilha_DadosDosObjetos,

     //Graficos
     Graf_CExHR,

     // Idiomas
     iphs1_Constantes,
     LanguageControl;


// Realiza um type-casting, só isso
Function AP(F: TForm): Tiphs1_Form_AreaDeProjeto;
begin
  Result := Tiphs1_Form_AreaDeProjeto(F);
end;

{ Tiphs1_PC_Base }

function Tiphs1_PC_Base.CriarTrechoDagua(ConectarEm: TPC): TTrechoDagua;
begin
  Result := Tiphs1_TrechoDagua.Create(Self, ConectarEm, TabNomes, Projeto);
  Result.Menu := AP(Projeto.AreaDeProjeto).Menu_TD;
end;

procedure Tiphs1_PC_Base.PlotarHidrogramasEm(G: TgrGrafico);
var i, k: Integer;
    TD: TTrechoDagua;
begin
  i := 0;
  for i := 0 to SubBacias-1 do
    G.Series.AdicionaSerieDePontos('Qs ' + SubBacia[i].Nome + ' (m³/s)', SelectColor(i, True), SubBacia[i].HidroRes);

  for k := 0 to PCs_aMontante-1 do
    begin
    TD := PC_aMontante[k].TrechoDagua;
    G.Series.AdicionaSerieDePontos('Qs ' + TD.Nome + ' (m³/s)', SelectColor(i + k, True), TD.HidroRes);
    end;
end;

{ Tiphs1_PCR }

constructor Tiphs1_PCR.Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  Inherited Create(Point(-100,-100), Projeto, UmaTabelaDeNomes);

  FH_Tab := TTab2D.Create(3);
  //FQ_Tab := TTab2D.Create(3);
  FQ := Tiphs1_EstruturasRes_Q.Create;

  if Projeto <> nil then
     begin
     ImagemDoComponente.Width  := 20;
     ImagemDoComponente.Height := 20;
     ImagemDoComponente.Canvas.Brush.Color  := clBlue;
     Self.Pos := Pos;
     end;

  IB.Oper := coRes;
end;

destructor Tiphs1_PCR.Destroy;
begin
  FH_Tab.Free;
  FQ.Free;
  inherited Destroy;
end;

procedure Tiphs1_PCR.SalvarEmArquivo(Arquivo: TIF);
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteFloat   (Secao, 'AI' , FAI );
    WriteInteger (Secao, 'NO', FNO);

    // H
    WriteFloat   (Secao, 'H_CCV', FH_CCV);
    WriteFloat   (Secao, 'H_CD' , FH_CD );
    WriteFloat   (Secao, 'H_LV' , FH_LV );
    WriteInteger (Secao, 'H_NPT', FH_NPT);
    H_Tab.SaveToFile(Arquivo, Secao, 'H_TAB');

    // Q
    FQ.SalvarEmArquivo(Arquivo, Secao);
    end;
end;

procedure Tiphs1_PCR.LerDoArquivo(Ini: TIF; Const Secao: String);
begin
  Inherited LerDoArquivo(Ini, Secao);
  with Ini do
    begin
    FAI  := ReadFloat   (Secao, 'AI' , 0);
    FNO := ReadInteger (Secao, 'NO', 0);

    // H
    FH_CCV := ReadFloat   (Secao, 'H_CCV', 0);
    FH_CD  := ReadFloat   (Secao, 'H_CD' , 0);
    FH_LV  := ReadFloat   (Secao, 'H_LV' , 0);
    FH_NPT := ReadInteger (Secao, 'H_NPT', 0);
    H_Tab.LoadFromFile    (Ini, Secao, 'H_TAB');

    // Q
    FQ.LerDoArquivo(Ini, Secao);
    end;
end;

function Tiphs1_PCR.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := Tiphs1_Form_Dialogo_RES.Create(nil);
  Result.TN := TabNomes;
end;

procedure Tiphs1_PCR.PorDadosNoDialogo(d: TForm_Dialogo_Base);
var i, j, k, ii: Integer;
    f: TfrEstruturaRes_Q;
begin
  inherited PorDadosNoDialogo(d);
  with (d as Tiphs1_Form_Dialogo_RES) do
    begin
    edMOV.AsInteger := FNO;
    edAI.AsFloat    := FAI;

    // *****  H  *****

    DLG_TabH.edLV.AsFloat    := FH_LV;
    DLG_TabH.edCCV.AsFloat   := FH_CCV;
    DLG_TabH.edCD.AsFloat    := FH_CD;
    DLG_TabH.edNPT.AsInteger := FH_NPT;

    if (FH_NPT > 0) and (FNO = 0) then
       begin
       DLG_TabH.Tab.MaxRow := FH_NPT;
       FH_Tab.Len := FH_NPT;
       for i := 1 to FH_NPT do
         begin
         DLG_TabH.Tab.NumberRC[i, 1] := FH_Tab[i-1].x;
         DLG_TabH.Tab.NumberRC[i, 2] := FH_Tab[i-1].y;
         end;
       end;

    // *****  Q  *****
    DLG_TabQ.NumEstruturas := FQ.NumEstruturas;
    for i := 0 to FQ.NumEstruturas-1 do
      begin
      f := TfrEstruturaRes_Q(DLG_TabQ.FindComponent('f' + IntToStr(i+1)));
      if f <> nil then
         begin
         f.Tab.MaxRow := FQ[i].NPT;
         f.edNPT.AsInteger := FQ[i].NPT;
         f.edIT.AsInteger := FQ[i].IT;
         for k := 0 to FQ[i].Tab.Len-1 do
           begin
           f.Tab.NumberRC[k+1, 1] := FQ[i].Tab[k].x;
           f.Tab.NumberRC[k+1, 2] := FQ[i].Tab[k].y;
           end;
         end;
      end;
    end;
end;

procedure Tiphs1_PCR.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
var i, j, k, ii: Integer;
    f: TfrEstruturaRes_Q;
begin
  inherited PegarDadosDoDialogo(d);
  with (d as Tiphs1_Form_Dialogo_RES) do
    begin
    FNO := edMOV.AsInteger;
    FAI  := edAI.AsFloat;

    // ****  H  ****

    FH_LV  := DLG_TabH.edLV.AsFloat;
    FH_CCV := DLG_TabH.edCCV.AsFloat;
    FH_CD  := DLG_TabH.edCD.AsFloat;
    FH_NPT := DLG_TabH.edNPT.AsInteger;

    if (FH_NPT > 0) and (FNO = 0) then
       begin
       FH_Tab.Len := FH_NPT;
       for i := 1 to FH_NPT do
         begin
         FH_Tab[i-1].x := DLG_TabH.Tab.NumberRC[i, 1];
         FH_Tab[i-1].y := DLG_TabH.Tab.NumberRC[i, 2];
         end;
       end;

    // ****  Q  ****
    FQ.NumEstruturas := edMov.AsInteger;
    for i := 0 to FQ.NumEstruturas-1 do
      begin
      f := TfrEstruturaRes_Q(DLG_TabQ.FindComponent('f' + IntToStr(i+1)));
      if f <> nil then
         begin
         FQ[i].NPT := f.edNPT.AsInteger;
         FQ[i].IT := f.edIT.AsInteger;
         FQ[i].Tab.Len := f.Tab.MaxRow;
         for k := 0 to f.Tab.MaxRow-1 do
           begin
           FQ[i].Tab[k].x := f.Tab.NumberRC[k+1, 1];
           FQ[i].Tab[k].y := f.Tab.NumberRC[k+1, 2];
           end;
         end;
      end;
    end;
end;

function Tiphs1_PCR.ObtemPrefixo: String;
begin
  Result := 'RES_';
end;

function Tiphs1_PCR.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrTriangle.Create(nil);
end;

procedure Tiphs1_PCR.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var R1: Real;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if Dialogo <> nil then
     begin
     R1  := Tiphs1_Form_Dialogo_Res(Dialogo).edAI.AsFloat;
     end
  else
     begin
     R1  := FAI;
     end;

  if R1 < 0 then
     begin
     DialogoDeErros.Add(etError,
     Format(LanguageManager.GetMessage(cMesID_IPH, 12)
           {'Objeto: %s'#13'Armazenamento Inicial inválido: %f'}, [Nome, R1]));
     TudoOk := False;
     end;
end;

procedure Tiphs1_PCR.AutoDescricao(Identacao: byte);
var s, s2: String;
    i    : Integer;
begin
  inherited;
  s  := StringOfChar(' ', Identacao);

  with gOutPut.Editor do
    begin
    Write;
    end;
end;

function Tiphs1_PCR.PossuiObjetosConectados: Boolean;
begin
  Result := (SubBacias > 0);
end;

procedure Tiphs1_PCR.CopiarPara(HC: THidroObjeto);
begin
  inherited;
  with Tiphs1_PCR(HC) do
    begin
    FNO    := self.FNO;    
    FAI    := self.FAI;    
    FH_NPT := self.FH_NPT; 
    FH_LV  := self.FH_LV;  
    FH_CCV := self.FH_CCV; 
    FH_CD  := self.FH_CD;  
    FH_Tab.Assign(self.FH_Tab);
    FQ.Associar(self.FQ);
    end;
end;

function Tiphs1_PCR.CriarInstancia: THidroObjeto;
begin
  Result := Tiphs1_PCR.Create(Point(Pos.X + 20, Pos.Y - 20), Projeto, TabNomes);
end;

function Tiphs1_PCR.MudarParaPC(UmMenu: TPopupMenu): Tiphs1_PC;
begin
  Result := Tiphs1_PC.Create(Pos, Projeto, nil);
  Result.TabNomes := TabNomes;
  Result.Menu := UmMenu;
  GetMessageManager.SendMessage(UM_TROCAR_REFERENCIA, [Self, Result]);

  //CopiarPara(Result); // Nao se pode copiar os dados de um RES para um PC pois o RES eh descendente do PC

  // Troca as Referências

  Result.FSubBacias.Free;
  Result.FSubBacias := FSubBacias;
  FSubBacias := nil;

  Result.FPCs_aMontante.Free;
  Result.FPCs_aMontante := FPCs_aMontante;
  FPCs_aMontante := nil;

  Result.FTD.Free;
  Result.FTD := FTD;
  FTD := nil;

  Result.AtualizarHint;
end;

{ Tiphs1_SubBacia }

constructor Tiphs1_SubBacia.Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(Pos, Projeto, UmaTabelaDeNomes);

  //FPM := 0;
  FIR := True;

  FCoefs  := TTab1D.Create(0);
  FCL_Tab := TTab1D.Create(3);
  FHU_Tab := TTab1D.Create(3);

  IB.Oper := coTCV;
  FSE     := seSCS;
  FES     := esHU;
end;

destructor Tiphs1_SubBacia.Destroy;
begin
  FCoefs.Free;
  FCL_Tab.Free;
  FHU_Tab.Free;
  FTabPrecip.Free;
  inherited Destroy;
end;

procedure Tiphs1_SubBacia.SalvarEmArquivo(Arquivo: TIF);
var i: Integer;
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteInteger (Secao, 'CL_NPT', FCL_NPT);
    WriteFloat   (Secao, 'CL_DB' , FCL_DB);
    WriteFloat   (Secao, 'CL_XN' , FCL_XN);
    WriteFloat   (Secao, 'CL_KS' , FCL_KS);
    FCL_Tab.SaveToFile(Arquivo, Secao, 'CL_Pontos');

    WriteFloat (Secao, 'FI_PI', FFI_PI);
    WriteFloat (Secao, 'FI_I' , FFI_I);

    WriteFloat (Secao, 'HEC_EI', FHEC_EI);
    WriteFloat (Secao, 'HEC_VI', FHEC_VI);
    WriteFloat (Secao, 'HEC_PD', FHEC_PD);
    WriteFloat (Secao, 'HEC_LP', FHEC_LP);

    WriteFloat (Secao, 'HO_EE', FHO_EE);
    WriteFloat (Secao, 'HO_EI', FHO_EI);
    WriteFloat (Secao, 'HO_CI', FHO_CI);
    WriteFloat (Secao, 'HO_IB', FHO_IB);

    WriteFloat (Secao, 'HT_DB', FHT_DB);

    WriteInteger (Secao, 'HU_NPT', FHU_NPT);
    FHU_Tab.SaveToFile(Arquivo, Secao, 'HU_Pontos');

    WriteFloat (Secao, 'HY_CC', FHY_CC);
    WriteFloat (Secao, 'HY_DN', FHY_DN);
    WriteFloat (Secao, 'HY_RR', FHY_RR);
    WriteFloat (Secao, 'HY_TP', FHY_TP);

    WriteFloat (Secao, 'IP_IO'  , FIP_IO  );
    WriteFloat (Secao, 'IP_IB'  , FIP_IB  );
    WriteFloat (Secao, 'IP_PAI' , FIP_PAI );
    WriteFloat (Secao, 'IP_RMAX', FIP_RMAX);
    WriteFloat (Secao, 'IP_VB'  , FIP_VB  );
    WriteFloat (Secao, 'IP_H'   , FIP_H   );

    WriteFloat (Secao, 'PEB_VB', PEB_VB);
    WriteFloat (Secao, 'PEB_PR', PEB_PR);
    WriteBool  (Secao, 'PEB', PEB   );

    WriteFloat (Secao, 'SCS_CN', FSCS_CN);

    //WriteBool    (Secao , 'IT'  , FIT  );
    WriteBool    (Secao , 'IR'  , FIR  );
    WriteFloat   (Secao , 'AB'  , FAB  );
    WriteFloat   (Secao , 'TC'  , FTC  );
    WriteFloat   (Secao , 'TabT', FTabT);
    WriteString  (Secao , 'H'   , FH   );
    //WriteFloat   (Secao , 'PM'  , FPM  );

    WriteInteger (Secao , 'Tipo', Ord(FTipo));
    WriteInteger (Secao , 'ES'  , Ord(FES)  );
    WriteInteger (Secao , 'SE'  , Ord(FSE)  );
    WriteInteger (Secao , 'TP'  , Ord(FTP)  );

    FCoefs.SaveToFile(Arquivo, Secao, 'Coefs');
    end;
end;

function Tiphs1_SubBacia.ConectarObjeto(Obj: THidroComponente): Integer;
begin
  //inherited ConectarObjeto(Obj); é abstrato
end;

function Tiphs1_SubBacia.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := Tiphs1_Form_Dialogo_SB.Create(nil);
  Result.TN := TabNomes;
end;

procedure Tiphs1_SubBacia.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
var i: Integer;
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_SB) do
    begin
    self.Copiar(SubBacia);
    end;
end;

procedure Tiphs1_SubBacia.PorDadosNoDialogo(d: TForm_Dialogo_Base);
var i: Integer;
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_SB) do
    begin
    SubBacia.Copiar(self);
    end;
end;

procedure Tiphs1_SubBacia.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var R1, R2, R3, R4, R5, R6: Real; // Area
    s1: String;
    T1: TenTipoSubBacia;
    NIT, NITC: Integer;
    v : TwsSFVec;
begin
  Inherited;

  if Dialogo <> nil then
     begin
     //R6 := Tiphs1_Form_Dialogo_SB(Dialogo).edPM.AsFloat;
     R1 := Tiphs1_Form_Dialogo_SB(Dialogo).DLG_TCV.edAB.AsFloat;
     R2 := Tiphs1_Form_Dialogo_SB(Dialogo).DLG_TCV.SubBacia.SCS_CN;
     R3 := Tiphs1_Form_Dialogo_SB(Dialogo).DLG_TCV.SubBacia.FI_I;
     R4 := Tiphs1_Form_Dialogo_SB(Dialogo).DLG_TCV.SubBacia.FI_PI;
     R5 := Tiphs1_Form_Dialogo_SB(Dialogo).DLG_TCV.edTC.AsFloat;
     T1 := TenTipoSubBacia(Tiphs1_Form_Dialogo_SB(Dialogo).rbH.Checked);
     end
  else
     begin
     //R6 := FPM;
     R1 := FAB;
     R2 := FSCS_CN;
     R3 := FI_I;
     R4 := FI_PI;
     R5 := FTC;
     T1 := FTipo;
     end;
(*
       Case SB.SE of
         seIPHII  : {A1} AIL([SB.IP_IO, SB.IP_IB, SB.IP_H, SB.IP_RMAX, SB.IP_VB, SB.IP_PAI]);
         seSCS    : {B1} AIL([SB.SCS_CN]);
         seHEC1   : {C1} AIL([SB.HEC_VI, SB.HEC_LP, SB.HEC_PD, SB.HEC_EI]);
         seFI     : {D1} AIL([SB.FI_PI, SB.FI_I]);
         seHOLTAN : {E1} AIL([SB.HO_EI, SB.HO_EE, SB.HO_IB, SB.HO_CI]);
         end;

       Case SB.ES of
         esHU    : begin
                   // Cartão G1
                   AIL([SB.HU_NPT]);
                   Vetor(SB.HU_Tab);
                   end;

         esHT    : begin
                   AIL([SB.AB, SB.TC]); // Cartão I1
                   if SB.TC = 0 then AIL([SB.HT_DB]); // Cartão J1
                   end;

         esHYMO  : begin
                   AIL([SB.AB, SB.HY_RR, SB.HY_TP]); // Cartão K1
                   if (SB.HY_RR = 0) or (SB.HY_TP = 0) then AIL([SB.HY_DN, SB.HY_CC]); // Cartão L1
                   end;

         esCLARK : begin
                   AIL([SB.CL_KS, SB.TC, SB.CL_XN, SB.AB]); // Cartão M1
                   if (SB.CL_KS = 0) or (SB.TC = 0) then AIL([SB.CL_DB]); // Cartão N1
                   if SB.CL_XN = 0 then Vetor(SB.CL_Tab); // Cartão O1
                   end;
         end;

       if SB.PEB and (SB.SE = seIPHII) then
          AIL([SB.AB, SB.PEB_PR, SB.PEB_VB]); // Cartão P1
*)

  NIT  := Tiphs1_Projeto(Projeto).NIT;
  NITC := Tiphs1_Projeto(Projeto).NITC;

  if NITC = 0 then
     if T1 = sbTCV then
        begin
        DialogoDeErros.Add(etError, Format(LanguageManager.GetMessage(cMesID_IPH, 79), [Nome]));
         {'Objeto: %s'#13'A operação Transformação Chuva-Vazão não pode ser realizada sem a'#13 +
          'definição prévia da Precipitação (intervalo de tempo com chuva, arquivos, etc)'}
        TudoOk := False;
        end
     else
        try
          v := TwsSFVec.Create(NIT);
          if not VerificaCaminho(self.FH) then
             begin
             DialogoDeErros.Add(etError,
             Format(LanguageManager.GetMessage(cMesID_IPH, 33)
                    {'Projeto: %s'#13 + 'Arquivo não encontrado:'#13'%s'}, [Nome, self.FH]));
             TudoOk := False;
             end
          else
             if Completo then
                begin // Conta os valores se o arquivo existe
                v.LoadFromTextFile(FH);
                if NIT <> v.Len then
                   begin
                   DialogoDeErros.Add(etError,
                   Format(LanguageManager.GetMessage(cMesID_IPH, 80) // <<< Mudar Mansagem
                         {'Projeto: %s'#13 +
                          'Número de Valores (%d) encontrado no arquivo.'#13 +
                          '%s'#13 +
                          'não pode ser diferente do Número de Intervalos de Tempo (%d)'}
                          ,[Nome, FH, v.Len, NIT]));
                   TudoOk := False;
                   end;
                end;
        finally
          v.Free;
        end;
(*
  if R6 <= 0 then
     begin
     DialogoDeErros.Add(etError,
     Format(LanguageManager.GetMessage(cMesID_IPH, 13)
            {'Objeto: %s'#13'Precipitação Máxima Inválida: %f'}, [Nome, R6]));
     TudoOk := False;
     end;
*)
  if T1 = sbTCV then
     begin
     if R1 <= 0 then
        begin
        DialogoDeErros.Add(etError,
        Format(LanguageManager.GetMessage(cMesID_IPH, 14)
              {'Objeto: %s'#13'Área inválida: %f'}, [Nome, R1]));
        TudoOk := False;
        end;

     if R5 < 0 then
        begin
        DialogoDeErros.Add(etError,
        Format(LanguageManager.GetMessage(cMesID_IPH, 15)
               {'Objeto: %s'#13'Tempo de Concentração inválido: %f'}, [Nome, R5]));
        TudoOk := False;
        end;
{
     if (R2 <= 0) or (R2 > 100) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Curva Número Inválida: %f', [Nome, R2]));
        TudoOk := False;
        end;

     if R3 < 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Perda inicial inválida: %f', [Nome, R3]));
        TudoOk := False;
        end;

     if R4 < 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Índice FI inválida: %f', [Nome, R4]));
        TudoOk := False;
        end;
}
     end;
end;

procedure Tiphs1_SubBacia.LerDoArquivo(Ini: TIF; Const Secao: String);
var i, ii: Integer;
begin
  Inherited;
  with Ini do
    begin
    FCL_NPT := ReadInteger (Secao, 'CL_NPT', 0);
    FCL_DB  := ReadFloat   (Secao, 'CL_DB' , 0);
    FCL_XN  := ReadFloat (Secao, 'CL_XN' , 0);
    FCL_KS  := ReadFloat (Secao, 'CL_KS' , 0);
    FCL_Tab.LoadFromFile(Ini, Secao, 'CL_Pontos');

    FFI_PI := ReadFloat (Secao, 'FI_PI', 0);
    FFI_I  := ReadFloat (Secao, 'FI_I' , 0);

    FHEC_EI := ReadFloat (Secao, 'HEC_EI', 0);
    FHEC_VI := ReadFloat (Secao, 'HEC_VI', 0);
    FHEC_PD := ReadFloat (Secao, 'HEC_PD', 0);
    FHEC_LP := ReadFloat (Secao, 'HEC_LP', 0);

    FHO_EE := ReadFloat (Secao, 'HO_EE', 0);
    FHO_EI := ReadFloat (Secao, 'HO_EI', 0);
    FHO_CI := ReadFloat (Secao, 'HO_CI', 0);
    FHO_IB := ReadFloat (Secao, 'HO_IB', 0);

    FHT_DB := ReadFloat (Secao, 'HT_DB', 0);

    FHU_NPT := ReadInteger (Secao, 'HU_NPT', 0);
    FHU_Tab.LoadFromFile(Ini, Secao, 'HU_Pontos');

    FHY_CC := ReadFloat (Secao, 'HY_CC', 0);
    FHY_DN := ReadFloat (Secao, 'HY_DN', 0);
    FHY_RR := ReadFloat (Secao, 'HY_RR', 0);
    FHY_TP := ReadFloat (Secao, 'HY_TP', 0);

    FIP_IO   := ReadFloat (Secao, 'IP_IO'  , 0);
    FIP_IB   := ReadFloat (Secao, 'IP_IB'  , 0);
    FIP_PAI  := ReadFloat (Secao, 'IP_PAI' , 0);
    FIP_RMAX := ReadFloat (Secao, 'IP_RMAX', 0);
    FIP_VB   := ReadFloat (Secao, 'IP_VB'  , 0);
    FIP_H    := ReadFloat (Secao, 'IP_H'   , 0);

    PEB_VB := ReadFloat (Secao, 'PEB_VB', 0);
    PEB_PR := ReadFloat (Secao, 'PEB_PR', 0);
    PEB    := ReadBool  (Secao, 'PEB'   , False);

    FSCS_CN := ReadFloat(Secao, 'SCS_CN', 0);

    //FIT   := ReadBool    (Secao , 'IT'  , False);
    FIR   := ReadBool   (Secao , 'IR'  , True);
    FAB   := ReadFloat  (Secao , 'AB'  , 0);
    FTC   := ReadFloat  (Secao , 'TC'  , 0);
    FTabT := ReadFloat  (Secao , 'TabT', 0);
    FH    := ReadString (Secao , 'H'   , '');
    //FPM   := ReadFloat  (Secao , 'PM'  , 0);

    byte(FTipo) := ReadInteger (Secao , 'Tipo', 0);
    byte(FES)   := ReadInteger (Secao , 'ES'  , 0);
    byte(FSE)   := ReadInteger (Secao , 'SE'  , 1);
    byte(FTP)   := ReadInteger (Secao , 'TP'  , 0);

    FCoefs.LoadFromFile(Ini, Secao, 'Coefs');
    end;
end;

procedure Tiphs1_SubBacia.DesconectarObjetos;
begin
  //inherited DesconectarObjetos; é abstrato
end;

procedure Tiphs1_SubBacia.AutoDescricao(Identacao: byte);
var s, s2: String;
    i    : Integer;
begin
  inherited;
  s  := StringOfChar(' ', Identacao);
  s2 := s + StringOfChar(' ', 19);

  with gOutPut.Editor do
    begin
    end;
end;

procedure Tiphs1_SubBacia.Copiar(SB: Tiphs1_SubBacia);
begin
  Projeto   := SB.Projeto;

  FCL_NPT   :=  SB.FCL_NPT;
  FCL_DB    :=  SB.FCL_DB;
  FCL_XN    :=  SB.FCL_XN;
  FCL_KS    :=  SB.FCL_KS;
  FCL_Tab.Assign(SB.FCL_Tab);

  FFI_PI    :=  SB.FFI_PI;
  FFI_I     :=  SB.FFI_I;

  FHEC_EI   :=  SB.FHEC_EI;
  FHEC_VI   :=  SB.FHEC_VI;
  FHEC_PD   :=  SB.FHEC_PD;
  FHEC_LP   :=  SB.FHEC_LP;

  FHO_EE    :=  SB.FHO_EE;
  FHO_EI    :=  SB.FHO_EI;
  FHO_CI    :=  SB.FHO_CI;
  FHO_IB    :=  SB.FHO_IB;

  FHT_DB    :=  SB.FHT_DB;

  FHU_NPT   :=  SB.FHU_NPT;
  FHU_Tab.Assign(SB.FHU_Tab);

  FHY_CC    :=  SB.FHY_CC;
  FHY_DN    :=  SB.FHY_DN;
  FHY_RR    :=  SB.FHY_RR;
  FHY_TP    :=  SB.FHY_TP;

  FIP_IO    :=  SB.FIP_IO;
  FIP_IB    :=  SB.FIP_IB;
  FIP_PAI   :=  SB.FIP_PAI;
  FIP_RMAX  :=  SB.FIP_RMAX;
  FIP_VB    :=  SB.FIP_VB;
  FIP_H     :=  SB.FIP_H;

  FPEB_VB   :=  SB.FPEB_VB;
  FPEB_PR   :=  SB.FPEB_PR;
  FPEB      :=  SB.FPEB;

  FSCS_CN   :=  SB.FSCS_CN;

  FIR       :=  SB.FIR;
  FAB       :=  SB.FAB;
  FTC       :=  SB.FTC;
  FTP       :=  SB.FTP;
  FTabT     :=  SB.FTabT;
  //FPM       :=  SB.FPM;
  FH        :=  SB.FH;
  FES       :=  SB.ES;
  FSE       :=  SB.SE;
  FTipo     :=  SB.Tipo;

  FCoefs.Assign(SB.Coefs);
end;

procedure Tiphs1_SubBacia.PrepararParaSimulacao;
var i: Integer;
begin
  inherited;
  FreeAndNil(FTabPrecip);
  if IB.Oper = coTCV then
     begin
     FTabPrecip := TwsDataSet.CreateFix('Dados', Tiphs1_Projeto(Projeto).NITC,
                   [dtNumeric, dtNumeric, dtNumeric, dtNumeric]);
     FTabPrecip.ColName[1] := 'PRECIP';
     FTabPrecip.ColName[2] := 'PACUM';
     FTabPrecip.ColName[3] := 'PERD';
     FTabPrecip.ColName[4] := 'PEFCT';
     FTabPrecip.Fill(0);
     end;
end;

procedure Tiphs1_SubBacia.MostrarTabPrecipitacao;
var p: TPlanilha;
    x: Longint;
begin
  if (IB.Oper = coTCV) and (FTabPrecip <> nil) then
     try
       StartWait;
       p := FTabPrecip.ShowInSheet;

       p.Caption          := Nome + ' - ' + LanguageManager.GetMessage(cMesID_IPH, 16);{'Tabela de Precipitações'}
       p.nRows            := p.nRows + 1;

       p.SetCellFont(p.nRows, 1, 'arial', 10, clBlack, True);
       p.SetCellFont(p.nRows, 2, 'arial', 10, clBlack, True);
       p.SetCellFont(p.nRows, 4, 'arial', 10, clBlack, True);
       p.SetCellFont(p.nRows, 5, 'arial', 10, clBlack, True);
       p.Write(p.nRows, 1, LanguageManager.GetMessage(cMesID_IPH, 17){'Total'});
       p.Write(p.nRows, 2, wsMatrixSum(FTabPrecip, 1, 1, FTabPrecip.nRows, x));
       p.Write(p.nRows, 4, wsMatrixSum(FTabPrecip, 3, 1, FTabPrecip.nRows, x));
       p.Write(p.nRows, 5, wsMatrixSum(FTabPrecip, 4, 1, FTabPrecip.nRows, x));
       p.Show(fsMDIChild);
     finally
       StopWait;
     end;
end;

procedure Tiphs1_SubBacia.PlotarHidrogramaResultante;
var CExHR : TGrafico_CExHR;
    G     : TgrGraficoPlanilha;
begin
  if HidroRes = nil then Exit;

  if (IB.Oper = coTCV) then
     begin
     CExHR := TGrafico_CExHR.Create(TabPrecip, HidroRes);
     CExHR.Caption := Projeto.Nome + ': ' + Nome + ' - ' +
                      LanguageManager.GetMessage(cMesID_IPH, 18); //'Chuva Efetiva X Hidrograma Resultante'
     CExHR.FormStyle := fsMDIChild;
     end
  else
     begin
     G := TgrGraficoPlanilha.Create(Nome);
     G.Caption := Projeto.Nome + ': ' + Nome + ' - ' +
                  LanguageManager.GetMessage(cMesID_IPH, 19); //'Hidrograma Resultante (m³/s)'
     G.Width := 400;
     G.cb3D.Checked := False;
     G.Grafico.BottomAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 20);//'Intervalos (n. Delta T)'
     G.Series.AdicionaSerieDePontos('Qs (m³/s)', clRED, HidroRes);
     G.Show(fsMDIChild);
     end;
end;

procedure Tiphs1_SubBacia.PlotarGrafico_Perdas_X_Efetiva;
var G: TgrGraficoPlanilha;
    s1, s2: TBarSeries;
    i: Integer;
begin
  G := TgrGraficoPlanilha.Create(Nome);
  G.Caption := Projeto.Nome + ': ' + Nome + ' - ' + LanguageManager.GetMessage(cMesID_IPH, 21); //'Perdas X Prec.Efetiva';
  G.Grafico.BottomAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 22); //'Intervalos (n. Delta T)';
  G.Width := 400;

  s1 := G.Series.AdicionaSerieDeBarras(LanguageManager.GetMessage(cMesID_IPH, 23){'Perdas (mm)'}, clRED, 0, 2);
  s2 := G.Series.AdicionaSerieDeBarras(LanguageManager.GetMessage(cMesID_IPH, 24){'Pe (mm)'}, clBLUE, 0, 2);

  for i := 1 to TabPrecip.nRows do
    begin
    s1.Add(TabPrecip[i, 3]);
    s2.Add(TabPrecip[i, 4]);
    end;

  G.Show(fsMDIChild);
end;

procedure Tiphs1_SubBacia.PlotarTabelaDePrecipitacoes;
var G: TgrGraficoPlanilha;
    s1, s2, s3, s4: TBarSeries;
    i: Integer;
begin
  G := TgrGraficoPlanilha.Create(Nome);
  g.Caption := Projeto.Nome + ': ' + Nome + ' - ' + LanguageManager.GetMessage(cMesID_IPH, 25); //'Precipitação';
  G.Width := 400;

  G.Grafico.Title.Text.Add(LanguageManager.GetMessage(cMesID_IPH, 26){'P = Pe + Perdas'});
  G.Grafico.LeftAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 27); //'Precipitação (mm)';
  G.Grafico.BottomAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 28); //'Intervalos (n. Delta T)';

  s3 := G.Series.AdicionaSerieDeBarras(LanguageManager.GetMessage(cMesID_IPH, 29){'Perdas (mm)'}, clYELLOW, 0, 2);
  s4 := G.Series.AdicionaSerieDeBarras(LanguageManager.GetMessage(cMesID_IPH, 30){'Pe (mm)'}, clLIME, 0, 2);

  for i := 1 to TabPrecip.nRows do
    begin
    s3.Add(TabPrecip[i, 3]);
    s4.Add(TabPrecip[i, 4]);
    end;

  G.Show(fsMDIChild);
end;

procedure Tiphs1_SubBacia.CopiarPara(HC: THidroObjeto);
begin
  inherited;
  with Tiphs1_SubBacia(HC) do
    begin
    FCL_NPT := self.FCL_NPT;
    FCL_DB  := self.FCL_DB;
    FCL_XN  := self.FCL_XN;
    FCL_KS  := self.FCL_KS;
    FCL_Tab.Assign(self.FCL_Tab);

    FFI_PI  := self.FFI_PI;
    FFI_I   := self.FFI_I;

    FHEC_EI := self.FHEC_EI;
    FHEC_VI := self.FHEC_VI;
    FHEC_PD := self.FHEC_PD;
    FHEC_LP := self.FHEC_LP;

    FHO_EE  := self.FHO_EE;
    FHO_EI  := self.FHO_EI;
    FHO_CI  := self.FHO_CI;
    FHO_IB  := self.FHO_IB;

    FHT_DB  := self.FHT_DB;

    FHU_NPT := self.FHU_NPT;
    FHU_Tab.Assign(self.FHU_Tab);

    FHY_CC  := self.FHY_CC;
    FHY_DN  := self.FHY_DN;
    FHY_RR  := self.FHY_RR;
    FHY_TP  := self.FHY_TP;

    FIP_IO   := self.FIP_IO;
    FIP_IB   := self.FIP_IB;
    FIP_PAI  := self.FIP_PAI;
    FIP_RMAX := self.FIP_RMAX;
    FIP_VB   := self.FIP_VB;
    FIP_H    := self.FIP_H;

    FPEB_VB  := self.FPEB_VB;
    FPEB_PR  := self.FPEB_PR;
    FPEB     := self.FPEB;

    FSCS_CN := self.FSCS_CN;

    FIR   := self.FIR;
    FAB   := self.FAB;
    FTC   := self.FTC;
    FTabT := self.FTabT;
    FH    := self.FH;
    FTipo := self.FTipo;
    FES   := self.FES;
    FSE   := self.FSE;
    FTP   := self.FTP;
    //FPM   := self.FPM;
    FCoefs.Assign(self.FCoefs);
    end;
end;

{ Tiphs1_Projeto }

function Tiphs1_Projeto.ReceiveMessage(Const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     end else

  if MSG.ID = UM_LIBERAR_SCRIPTS then
     begin
     end;

  inherited ReceiveMessage(MSG);
end;

procedure Tiphs1_Projeto.TerminarSimulacao;
begin
  Inherited;
end;

procedure Tiphs1_Projeto.AutoDescricao(Identacao: byte);
var s: String;
begin
  inherited;
  s := StringOfChar(' ', Identacao);
  with gOutPut.Editor do
    begin
    end;
end;

constructor Tiphs1_Projeto.Create(UmaTabelaDeNomes: TStrings);
begin
  inherited Create(UmaTabelaDeNomes);
  FPChuva := TStringList.Create;
  FME := meDOS;
end;

destructor Tiphs1_Projeto.Destroy;
begin
  FPChuva.Free;
  FDadosPostos.Free;
  inherited Destroy;
end;

function Tiphs1_Projeto.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := Tiphs1_Form_Dialogo_Projeto.Create(nil);
  Result.TN := TabNomes;
end;

{ - Faz a leitura dos trechos dágua
  - Faz a leitura de todas as Sub-Bacias deste PC
    - Faz a leitura das Demandas desta SubBacia
  - Faz a leitura de todos as demandas deste PC
}
procedure Tiphs1_Projeto.Ler_Objetos(Ini: TIF; const NomeDoPC: String);
var Secao, s : String;
    x,y,i,ii : Integer;
    pc1, pc2 : Tiphs1_PC_Base;
    SB       : Tiphs1_SubBacia;
begin
  pc1 := nil;
  // Faz a leitura dos trechos dágua
  Secao := Ini.ReadString('Dados ' + NomeDoPC, 'TD', '');
  if Secao <> '' then
     begin
     Secao := 'Dados ' + Secao;
     pc1 := Tiphs1_PC_Base(ObtemObjetoPeloNome(Ini.ReadString(Secao, 'PM', ''), self));
     pc2 := Tiphs1_PC_Base(ObtemObjetoPeloNome(Ini.ReadString(Secao, 'PJ', ''), self));
     pc1.ConectarObjeto(pc2); // E finalmente conecta os PCs
     Tiphs1_TrechoDagua(pc1.TrechoDagua).LerDoArquivo(Ini, Secao);
     end
  else // Somente obtém o próprio PC
     pc1 := Tiphs1_PC_Base(ObtemObjetoPeloNome(NomeDoPC, self));

  // Faz a leitura de todas as Sub-Bacias deste PC
  for i := 1 to Ini.ReadInteger('Dados ' + NomeDoPC, 'SubBacias', 0) do
    begin
    Secao := Ini.ReadString('Dados ' + NomeDoPC, 'SB'+intToStr(i), '');
    if Secao <> '' then
       begin
       SB := Tiphs1_SubBacia(ObtemObjetoPeloNome(Secao, self));

       if SB = nil then
          begin
          Secao := 'Dados ' + Secao;
          x := Ini.ReadInteger(Secao, 'x', 0);
          y := Ini.ReadInteger(Secao, 'y', 0);
          SB := Tiphs1_SubBacia.Create(Point(x,y), self, TabNomes);
          SB.LerDoArquivo(Ini, Secao);
          SB.Menu := AP(AreaDeProjeto).Menu_SB;
          {
          // Faz a leitura das Demandas desta SubBacia
          for ii := 1 to Ini.ReadInteger(Secao, 'Demandas', 0) do
            begin
            s := Ini.ReadString(Secao, 'DM'+intToStr(ii), '');
            if s <> '' then
               begin
               s := 'Dados ' + s;
               x := Ini.ReadInteger(s, 'x', 0);
               y := Ini.ReadInteger(s, 'y', 0);
               DM := TprDemanda.Create(Point(x,y), self, TabNomes);
               DM.LerDoArquivo(Ini, s);
               DM.Menu := AP(AreaDeProjeto).Menu_Demanda;
               SB.ConectarObjeto(DM);
               end;
            end; // For ii
          }
          end;

       if pc1 <> nil then pc1.ConectarObjeto(SB);
       end;
    end; // for i
{
  // Faz a leitura de todos as demandas deste PC
  for i := 1 to Ini.ReadInteger('Dados ' + NomeDoPC, 'Demandas', 0) do
    begin
    Secao := Ini.ReadString('Dados ' + NomeDoPC, 'DM'+intToStr(i), '');
    if Secao <> '' then
       begin
       Secao := 'Dados ' + Secao;
       x := Ini.ReadInteger(Secao, 'x', 0);
       y := Ini.ReadInteger(Secao, 'y', 0);
       DM := TprDemanda.Create(Point(x,y), self, TabNomes);
       DM.LerDoArquivo(Ini, Secao);
       DM.Menu := AP(AreaDeProjeto).Menu_Demanda;
       pc1.ConectarObjeto(DM);
       end;
    end;
}
end;

function Tiphs1_Projeto.LerSubBacia(Ini: TIF; const Nome: String): Tiphs1_SubBacia;
var Tipo, Secao: String;
    x, y: Integer;
begin
  Secao := 'Dados ' + Nome;
  Result := Tiphs1_SubBacia.Create(Point(0, 0), Self, TabNomes);
  Result.Menu := AP(AreaDeProjeto).Menu_SB;
  Result.LerDoArquivo(Ini, Secao);
end;

function Tiphs1_Projeto.LerPC(Ini: TIF; const NomeDoPC: String): TPC;
var Tipo, Secao: String;
    i: Integer;
    s: String;

    procedure LerDerivacao(const Nome: String; PC: TPC);
    var D: Tiphs1_Derivacao;
    begin
      D := Tiphs1_Derivacao.Create(Self, TabNomes);
      D.LerDoArquivo(Ini, 'Dados ' + Nome);
      D.Menu := AP(AreaDeProjeto).Menu_Der;
      PC.ConectarObjeto(D);
    end;

begin
  Result := nil;
  if NomeDoPC = '' then Exit;
  Secao := 'Dados ' + NomeDoPC;
  Tipo  := Ini.ReadString(Secao, 'Classe', '');
  if Tipo = '' then Exit;

  if Tipo = 'Tiphs1_PC'  then
     begin
     Result := AP(AreaDeProjeto).CriarPC(Point(0,0));
     s := Ini.ReadString(Secao, 'Derivacao', '');
     if s <> '' then LerDerivacao(s, Result);
     end;

  if Tipo = 'Tiphs1_PCR' then
     Result := AP(AreaDeProjeto).CriarReservatorio(Point(0, 0));

  Result.LerDoArquivo(Ini, Secao);
  for i := 1 to Ini.ReadInteger(Secao, 'SubBacias', -1) do
    begin
    s := Ini.ReadString(Secao, 'SB' + IntToStr(i), '');
    Result.ConectarObjeto(LerSubBacia(Ini, s));
    end;
end;

procedure Tiphs1_Projeto.LerTrechoDaguaDoPC(Ini: TIF; const NomePC: String);
var Secao, s : String;
    i, ii    : Integer;
    pc1, pc2 : TPC;
    SB       : Tiphs1_SubBacia;
begin
  pc1 := nil;
  // Faz a leitura dos trechos dágua
  Secao := Ini.ReadString('Dados ' + NomePC, 'TD', '');
  if Secao <> '' then
     begin
     Secao := 'Dados ' + Secao;
     pc1 := TPC(ObtemObjetoPeloNome(Ini.ReadString(Secao, 'PM', ''), self));
     pc2 := TPC(ObtemObjetoPeloNome(Ini.ReadString(Secao, 'PJ', ''), self));
     pc1.ConectarObjeto(pc2); // E finalmente conecta os PCs
     pc1.TrechoDagua.LerDoArquivo(Ini, Secao);
     s := Ini.ReadString(Secao, 'SubBacia', '');
     if s <> '' then
        begin
        SB := LerSubBacia(Ini, s);
        pc1.TrechoDagua.ConectarObjeto(SB);
        end;
     end;
end;

procedure Tiphs1_Projeto.LerDoArquivo(Ini: TIF; const Secao: String);
var i, ii : Integer;
    s : String;
    PC: TPC;
begin
  Inherited;

  with Ini do
    begin
    FNIT := ReadInteger(Secao, 'NIT', 0);
    FNITC := ReadInteger(Secao, 'NITC', 0);
    FTIT := ReadFloat(Secao, 'TIT', 0);
    ii := ReadInteger(Secao, 'Postos de Chuva', 0);
    for i := 1 to ii do
       FPChuva.Add(ReadString(Secao, 'Posto de Chuva ' + intToStr(i), ''));

    // Lê as informações dos PCs
    ii := ReadInteger('PCs', 'Quantidade', -1);
    for i := 1 to ii do
       begin
       s := ReadString('PCs', 'PC'+intToStr(i), '');
       PC := LerPC(Ini, s);
       end;

    // Lê as informações dos Objetos dos PCs
    for i := 1 to ii do
       begin
       s := Ini.ReadString('PCs', 'PC'+intToStr(i), '');
       LerTrechoDaguaDoPC(Ini, s);
       end;
    end; // with
end;

procedure Tiphs1_Projeto.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_Projeto) do
    begin
    FNIT := edNIT.AsInteger;
    FNITC := edNITC.AsInteger;
    FTIT := edTIT.AsFloat;
    FPChuva.Assign(lbPCs.Items);
    end;
end;

procedure Tiphs1_Projeto.PorDadosNoDialogo(d: TForm_Dialogo_Base);
var i: Integer;
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_Projeto) do
    begin
    edNIT.AsInteger := FNIT;
    edNITC.AsInteger := FNITC;
    edTIT.AsFloat := FTIT;
    lbPCs.Items.Assign(FPChuva);
    end;
end;

procedure Tiphs1_Projeto.SalvarEmArquivo(Arquivo: TIF);
var i, j : Integer;
    s    : String;
begin
  Inherited;

  with Arquivo do
    begin
    // Salva as informações do projeto
    WriteInteger(Secao, 'NIT', FNIT);
    WriteInteger(Secao, 'NITC', FNITC);
    WriteFloat(Secao, 'TIT', FTIT);
    WriteInteger(Secao, 'Postos de Chuva', FPChuva.Count);
    for i := 1 to FPChuva.Count do
       WriteString(Secao, 'Posto de Chuva ' + intToStr(i), FPChuva[i-1]);

    // Nome dos PCs
    WriteInteger('PCs', 'Quantidade', PCs.PCs);
    for i := 0 to PCs.PCs - 1 do
      WriteString('PCs', 'PC' + intToStr(i + 1), PCs[i].Nome);

    // Salva as informações de cada PC (Trechos-Dagua, Sub-Bacias e Derivacoes)
    for i := 0 to PCs.PCs - 1 do
      begin
      // Informações dele proprio
      PCs[i].SalvarEmArquivo(Arquivo);

      // Trecho-Dagua
      if PCs[i].TrechoDagua <> nil then
         begin
         PCs[i].TrechoDagua.SalvarEmArquivo(Arquivo);
         if Tiphs1_TrechoDagua(PCs[i].TrechoDagua).SubBacia <> nil then
            Tiphs1_TrechoDagua(PCs[i].TrechoDagua).SubBacia.SalvarEmArquivo(Arquivo);
         end;

      // Sub-Bacias
      for j := 0 to PCs[i].SubBacias-1 do
        PCs[i].SubBacia[j].SalvarEmArquivo(Arquivo);

      // Derivacao
      if PCs[i] is Tiphs1_PC then
         if Tiphs1_PC(PCs[i]).Derivacao <> nil then
            Tiphs1_PC(PCs[i]).Derivacao.SalvarEmArquivo(Arquivo);
      end;

    // Salva as informações de cada Sub-Bacia
    PercorreSubBacias(SalvaSubBacia);

    Modificado := false;
    end;
end;

procedure Tiphs1_Projeto.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var i, i1, i2 : Integer;
    r1: Real;
    Postos: TStrings;
    v: TwsVec;
    Arquivo: String;
begin
  Inherited;
  if Dialogo <> nil then
     begin
     i1     := Tiphs1_Form_Dialogo_Projeto(Dialogo).edNIT.AsInteger;
     i2     := Tiphs1_Form_Dialogo_Projeto(Dialogo).edNITC.AsInteger;
     r1     := strToFloat(AllTrim(Tiphs1_Form_Dialogo_Projeto(Dialogo).edTIT.Text));
     Postos := Tiphs1_Form_Dialogo_Projeto(Dialogo).lbPCs.Items;

     Completo := True; // Força a verificação completa para o diálogo
     end
  else
     begin
     i1     := FNIT;
     i2     := FNITC;
     r1     := FTIT;
     Postos := FPChuva;
     end;

   if i2 > i1 then
      begin
      DialogoDeErros.Add(etError,
      Format(LanguageManager.GetMessage(cMesID_IPH, 35)
            {'Projeto: %s'#13 +
             'Número de Intervalos de Tempo com Chuva não pode ser maior'#13 +
             'que o Número de Intervalos de Tempo.'}, [Nome]));
      TudoOk := False;
      end;
(*
   if i2 < 1 then                          // ???
      begin
      DialogoDeErros.Add(etError,
      Format(LanguageManager.GetMessage(cMesID_IPH, 31)
      {'Projeto: %s'#13 + 'Número de Intervalos de Tempo não definido'}, [Nome]));
      TudoOk := False;
      end;
*)

   if i2 > 0 then
      try
        v := TwsSFVec.Create(i2);
        for i := 0 to Postos.Count-1 do
          begin
          Arquivo := GetSubString(Postos[i], '[', ']');
          if not VerificaCaminho(Arquivo) then
             begin
             DialogoDeErros.Add(etError,
             Format(LanguageManager.GetMessage(cMesID_IPH, 33)
                    {'Projeto: %s'#13 + 'Arquivo não encontrado:'#13'%s'}, [Nome, Arquivo]));
             TudoOk := False;
             end
          else
             if Completo then
                begin // Conta os valores se o arquivo existe
                v.LoadFromTextFile(Arquivo);
                if i2 > v.Len then
                   begin
                   DialogoDeErros.Add(etError,
                   Format(LanguageManager.GetMessage(cMesID_IPH, 34) // <<< Mudar Mansagem
                         {'Projeto: %s'#13 +
                          'Número de Intervalos de Tempo com Chuva (%d) não pode ser maior que o'#13 +
                          'Número de Valores (%d) encontrado no arquivo.'#13 +
                          '%s'}, [Nome, i2, v.Len, Arquivo]));
                   TudoOk := False;
                   end;
                end;
          end;
      finally
        v.Free;
      end;

   if r1 < 1 then
      begin
      DialogoDeErros.Add(etError,
      Format(LanguageManager.GetMessage(cMesID_IPH, 36)
             {'Projeto: %s'#13'Tamanho do Intervalo de Tempo não definido'}, [Nome]));
      TudoOk := False;
      end;
end;

procedure Tiphs1_Projeto.Temporizador(Sender: TObject; out EventID: Integer);
begin
end;

// Este método (evento) é disparado automaticamente após o evento de relógio do
// simulador, neste caso Temporizador_1 que incrementa o relógio.
// Executa uma simulação na rede para o intervalo de simulação Projeto.DeltaT
procedure Tiphs1_Projeto.Simulacao(Sender: TObject; const EventID: Integer);
begin
end;

procedure Tiphs1_Projeto.PrepararCarta(SL: TStrings);
var HS  : Integer; // Hidrograma de Saída
    //NHS : Integer; // Número de operações hidrológicas

  // Add in Line
  procedure AIL(const x: Array of Const);
  var s: String;
      i: Integer;
      k: byte;
  begin
    s := '';
    for i := 0 to High(x) do
      case x[i].vType of
        vtBoolean:
          begin
          if x[i].vBoolean then k := 1 else k := 0;
          s := s + RightStr(IntToStr(k), 10);
          end;
        vtInteger    : s := s + RightStr(IntToStr(x[i].vInteger), 10);
        vtExtended   : s := s + RightStr(FormatFloat('0.0#####', x[i].vExtended^), 10);
        end;

    SL.Add(s);
  end;

  // Add File
  procedure AF(NomeArq: String);
  var i, k: Integer;
      v: TV;
      s: String;
  begin
    if not VerificaCaminho(NomeArq) then Exit;
    v := TV.Create(0);
    try
      v.LoadFromTextFile(NomeArq);
      s := '';
      k := 0;
      for i := 1 to v.Len do
        begin
        inc(k);
        s := s + RightStr(FormatFloat('0.00', v[i]), 10);
        if k = 8 then
           begin
           SL.Add(s);
           k := 0;
           s := '';
           end;
        end;
      if s <> '' then SL.Add(s);
    finally
      v.Free;
    end;
  end;

  // Calcula o número do hidrograma de entrada
  function ObtemNHE(HC: THidroComponente; SH: Boolean = False): Integer;
  var PC: Tiphs1_PC;
      TD: Tiphs1_TrechoDagua;
  begin
    if SH then
       Result := 0
    else

    if (HC is Tiphs1_PC) then
       begin
       PC := Tiphs1_PC(HC);
       if PC.SubBacias = 1 then
          Result := PC.SubBacia[0].IB.NHS
       else
          if PC.PCs_aMontante = 1 then
             Result := PC.PC_aMontante[0].TrechoDagua.IB.NHS;
       end else

    if (HC is Tiphs1_SubBacia) then
       Result := 0 else

    if (HC is Tiphs1_PCR) or (HC is Tiphs1_Derivacao) then
       Result := HS - 1 else

    if HC is Tiphs1_TrechoDagua then
       begin
       TD := Tiphs1_TrechoDagua(HC);
       if TD.PC_aMontante.IB.NHP = 0 then
          Result := TD.PC_aMontante.IB.NHS
       else
          Result := TD.PC_aMontante.IB.NHP
       end else
  end;

  // Adiciona as informações comuns aos objetos
  procedure AC(HC: THidroComponente; const Prefixo: String; SH: Boolean = False);
  var s: String[80];
      i: Integer;
      SB: Tiphs1_SubBacia;
  begin
    s := Prefixo + ' - ' + HC.Nome + ' - ' + HC.Descricao;
    SL.Add(s);

    if HC is Tiphs1_SubBacia then
       begin
       SB := Tiphs1_SubBacia(HC);
       if SB.Tipo = sbHidrograma then i := 0 else {i := byte(SB.IR)} i := 1;
       end
    else
       begin
       SB := nil;
       i := 0;
       end;

    // Cálculo do Número do Hidrograma de Saída
    inc(HS);
    //HC.IB.NHE := HS;
    HC.IB.NHP := 0;
    HC.IB.NHE := ObtemNHE(HC, SH);
    HC.IB.NHS := HS;

    // Cartão F.
    AIL([Ord(HC.IB.Oper), i, HC.IB.GHC, HC.IB.ITH, HS, HC.IB.NHE, HC.IB.PDO]);

    // Cartão G
    if SB <> nil then
       if (SB.IB.Oper = coTCV) or ((SB.IB.Oper = coH) and SB.IB.GHC) then
          //AIL([HC.IB.VMax, HC.IB.VMin, SB.PM])
          AIL([0.0, 0.0, 0.0]) // <<<<<<
       else
          // não escreve o cartão G
    else
       AIL([HC.IB.VMax, HC.IB.VMin]);

    // Cartão H
    if HC.IB.PDO then AF(HC.IB.DadosObs);
  end;

  procedure ProcessarSubBacia(SB: Tiphs1_SubBacia);

    procedure PostosDeChuva_e_Coefs(const Coefs: TTab1D);
    var s: String;
        i: Integer;
        k: Integer;
        PostosPrj: TStrings;
    begin
      PostosPrj := Tiphs1_Projeto(SB.Projeto).PChuva;
      SB.Coefs.Len := PostosPrj.Count;

      // Índices dos Postos
      s := '';
      k := 0;
      for i := 0 to SB.Coefs.Len-1 do
        if SB.Coefs[i] > 0.0001 then
           begin
           inc(k);
           s := s + RightStr(IntToStr(i + 1), 10);
           if k = 8 then
              begin
              SL.Add(s);
              s := '';
              end;
           end;
      if s <> '' then SL.Add(s);

      // Coefs
      s := '';
      k := 0;
      for i := 0 to SB.Coefs.Len-1 do
        if SB.Coefs[i] > 0.0001 then
           begin
           inc(k);
           s := s + RightStr(FloatToStr(Coefs[i]), 10);
           if k = 8 then
              begin
              SL.Add(s);
              s := '';
              end;
           end;
      if s <> '' then SL.Add(s);
    end;

    procedure Vetor(const Tab: TTab1D);
    var i,k: Integer;
        s: String;
    begin
      k := 0;
      s := '';
      for i := 0 to Tab.Len-1 do
        begin
        inc(k);
        s := s + RightStr(FormatFloat('0.00', Tab[i]), 10);
        if k = 8 then
           begin
           SL.Add(s);
           k := 0;
           s := '';
           end;
        end;
      if s <> '' then SL.Add(s);
    end;

  var s: String;
      i, k: Integer;
      x: Real;
  begin
    if SB.Tipo = sbTCV then
       s := LanguageManager.GetMessage(cMesID_IPH, 37) //'Transformação Chuva-Vazão'
    else
       s := LanguageManager.GetMessage(cMesID_IPH, 38); //'Hidrograma Lido';

    AC(SB, s);

    if SB.Tipo = sbTCV then
       begin
       // Transformação Chuva-Vazão

       // Cartão V
       k := 0;
       for i := 0 to SB.Coefs.Len-1 do
         if SB.Coefs[i] > 0.00001 then inc(k);
       AIL([k, Boolean(SB.TP)]);

       // Cartão W e X
       PostosDeChuva_e_Coefs(SB.Coefs);

       if SB.TP <> tp0 then
          begin
          // Cartão Y
          case SB.TP of
            tp25: x := 0.25;
            tp50: x := 0.50;
            tp75: x := 0.75;
            end;
          AIL([x]);
          end;

       // Cartão Z
       AIL([ord(SB.SE) + 1]);
       Case SB.SE of
         seIPHII  : {A1} AIL([SB.IP_IO, SB.IP_IB, SB.IP_H, SB.IP_RMAX, SB.IP_VB, SB.IP_PAI]);
         seSCS    : {B1} AIL([SB.SCS_CN]);
         seHEC1   : {C1} AIL([SB.HEC_VI, SB.HEC_LP, SB.HEC_PD, SB.HEC_EI]);
         seFI     : {D1} AIL([SB.FI_PI, SB.FI_I]);
         seHOLTAN : {E1} AIL([SB.HO_EI, SB.HO_EE, SB.HO_IB, SB.HO_CI]);
         end;

       // Cartão F1
       AIL([ord(SB.ES) + 1, SB.PEB]);
       Case SB.ES of
         esHU    : begin
                   // Cartão G1
                   AIL([SB.HU_NPT]);
                   Vetor(SB.HU_Tab);
                   end;

         esHT    : begin
                   AIL([SB.AB, SB.TC]); // Cartão I1
                   if SB.TC = 0 then AIL([SB.HT_DB]); // Cartão J1
                   end;

         esHYMO  : begin
                   AIL([SB.AB, SB.HY_RR, SB.HY_TP]); // Cartão K1
                   if (SB.HY_RR = 0) or (SB.HY_TP = 0) then AIL([SB.HY_DN, SB.HY_CC]); // Cartão L1
                   end;

         esCLARK : begin
                   AIL([SB.CL_KS, SB.TC, SB.CL_XN, SB.AB]); // Cartão M1
                   if (SB.CL_KS = 0) or (SB.TC = 0) then AIL([SB.CL_DB]); // Cartão N1
                   if SB.CL_XN = 0 then Vetor(SB.CL_Tab); // Cartão O1
                   end;
         end;

       if SB.PEB and (SB.SE = seIPHII) then
          AIL([SB.AB, SB.PEB_PR, SB.PEB_VB]); // Cartão P1
       end
    else
       // Hidrograma Lido
       AF(SB.Hidrograma); // Cartão Q1
  end;

  // Propagação em Reservatório
  procedure PER(R: Tiphs1_PCR);
  var i: Integer;
  begin
    AIL(['I', R.NO, R.AI]); // Cartão I
    if R.NO > 0 then
       begin
       // Cartão Ji e Ki
       for i := 0 to R.Q.NumEstruturas-1 do
         begin
         AIL([R.Q[i].TAB.Len, {R.Q[i].IT} FNIT]);
         R.Q[i].TAB.ToStrings(SL, 4, 10);
         end;
       end
    else
       begin
       // Cartão L, M, N
       AIL([R.H_NPT]);
       R.H_TAB.ToStrings(SL, 4, 10);
       AIL([R.H_CD, R.H_LV, R.H_CCV]);
       end;
  end;

  procedure PERio(TD: Tiphs1_TrechoDagua);
  var i: Integer;
  begin
    AIL([Ord(TD.MPE) + 1]); // Cartão O
    case TD.MPE of
      mpeKX  : begin
               // Cartão P
               AIL([TD.NPT_KX]);
               for i := 0 to TD.NPT_KX-1 do
                  AIL([TD.Tab_KX[i].x, TD.Tab_KX[i].y, TD.Tab_KX[i].z]);
               end;

      mpeCL  : begin
               AIL([TD.VR]); // Cartão Q
               AIL([TD.LC, TD.CTP, TD.DFC, TD.ITC, TD.NST, TD.RST, TD.NHCL]); // Cartão R
               end;

      mpeCNL : begin
               AIL([TD.LC, TD.CTP, TD.DFC, TD.ITC, TD.NST, TD.RST, TD.NHCL]); // Cartão S
               end;

      mpeCPI : begin
               AIL([TD.LC, TD.CTP, TD.DFC, TD.ITC, TD.NST, TD.RST, TD.NHCL]); // Cartão T
               AIL([TD.LPI, TD.RPI, TD.CFPI]); // Cartão U
               end;
    end;
  end;

  procedure Derivacao(DE: Tiphs1_Derivacao; TD: Tiphs1_TrechoDagua);
  begin
    // Cartão T1
    if TD = nil then
       AIL([DE.CDL, DE.CDR, DE.CDD, DE.CPL, DE.CPR, DE.CPD])
    else
       AIL([DE.CDL, DE.CDR, DE.CDD, TD.LC, TD.RST, TD.DFC]);
  end;

  procedure SH(PC: Tiphs1_PC);
  var i, k: Integer;
      s: String;
  begin
    i := PC.SubBacias + PC.PCs_aMontante;
    PC.Hidrogramas.Len := i;

    // Cartão R1
    AIL([i]);

    // Cartão S1
    s := '';
    k := 0;
    for i := 0 to PC.PCs_aMontante-1 do
      begin
      s := s + RightStr(IntToStr(PC.PC_aMontante[i].TrechoDagua.IB.NHS), 10);
      inc(k);
      PC.Hidrogramas[k] := PC.PC_aMontante[i].TrechoDagua.IB.NHS;
      end;

    for i := 0 to PC.SubBacias-1 do
      begin
      s := s + RightStr(IntToStr(PC.SubBacia[i].IB.NHS), 10);
      inc(k);
      PC.Hidrogramas[k] := PC.SubBacia[i].IB.NHS;
      end;

    SL.Add(s);
  end;

var s       : String[80];
    i, j, k : Integer;
    SubRede : Integer;
    PC      : Tiphs1_PC;
    PCR     : Tiphs1_PCR;
    SB      : Tiphs1_SubBacia;
    TD      : Tiphs1_TrechoDagua;
    DE      : Tiphs1_Derivacao;
begin
  HS  := 0;
  //NHS := 0;

  // Dados do Projeto
  s := Nome + ' - ' + Descricao;
  SL.Add(s); // Cartão A
  AIL([NIT, 0 {Calculado ao final}, PChuva.Count, NITC, TIT]); // Cartão B
  for i := 0 to PChuva.Count-1 do
    begin
    s := GetSubString(PChuva[i], '[', ']'); // Nome do Arquivo
    k := StrToInt(GetSubString(PChuva[i], '(', ')')); // Código de Tormenta - 1 ou 2
    AIL([i+1, k]); // Cartão C
    AF(s); // Cartão D
    end;

  // Verifica Quantas SubRedes Existem
  k := 0;
  for i := 0 to PCs.PCs-1 do
    k := max(PCs[i].SubRede, k);

  // para cada SubRede
  for SubRede := 1 to k do

    // para todos os PCs de cada SubRede
    for i := 0 to PCs.PCs-1 do
      begin
      if PCs[i].SubRede <> SubRede then Continue;

      // Obtem um PC ou um Reservatório
      PC := Tiphs1_PC(PCs[i]);
      if PCs[i] is Tiphs1_PCR then
         PCR := Tiphs1_PCR(PCs[i])
      else
         PCR := nil;

      // Num. do Hidro. de entrada é sempre 0 e o processo gera um num. de Hidro. de saída
      // Para todas as Transformações Chuva-Vazão ou Hidrogramas Lidos das Sub-Bacias
      for j := 0 to PC.SubBacias-1 do
        ProcessarSubBacia(Tiphs1_SubBacia(PC.SubBacia[j]));

      // Soma dos Hidrogramas
      // Calcula um novo num. de Hidro.
      // Pegar os objetos conectados atras e na Tag R1 vai o total de objetos
      // Na Tag S1 vao os numeros calculados do Hidrogramas
      if (PC.SubBacias > 1) or (PC.SubBacias + PC.PCs_aMontante > 1) then
         begin
         PC.IB.Oper := iphs1_Tipos.coSH;
         AC(PC, 'Soma de Hidrogramas', True);
         SH(PC);
         end
      else // ou é simplesmente um ponto de passagem. Não realiza nenhuma oper. hidrológica
         begin
         PC.IB.Oper := iphs1_Tipos.coSH;
         PC.IB.NHP := ObtemNHE(PC);  // Funciona como hid. de saída
         PC.IB.NHE := PC.IB.NHP;
         end;

      // Propagação em Reservatório
      if PCR <> nil then
         begin
         PC.IB.Oper := iphs1_Tipos.coRes;
         AC(PCR, 'Propagação em Reservatório');
         PER(PCR);
         end
      else
         // Propagação na Derivação
         if PC.Derivacao <> nil then
            begin
            AC(PC.Derivacao, 'Derivação');
            Derivacao(PC.Derivacao, Tiphs1_TrechoDagua(PC.TrechoDagua));
            end;

      // Propagação da Sub-Bacia conectada a um Trecho-Dágua
      if PC.TrechoDagua <> nil then
         begin
         TD := Tiphs1_TrechoDagua(PC.TrechoDagua);
         if TD.SubBacia <> nil then  // <<<<<
            begin
            ProcessarSubBacia(TD.SubBacia);
            TD.NHCL := TD.SubBacia.IB.NHS;
            end;

         // Propagação em Rio
         AC(TD, 'Propagação em Rio');
         PERio(TD);
         end;
      end;

  // Ajusta o número de operações hidrológicas
  s := SL[1];
  Delete(s, 11, 10);
  Insert(RightStr(IntToStr(HS), 10), s, 11);
  SL[1] := s;
end;

procedure Tiphs1_Projeto.ExecutarSimulacao;
var SL: TStrings;
    Exec: TExecFile;
    s: String;
    Ent, Sai, Err: String;
    ds: Char;
begin
  s := Copy(GetValidID(Nome), 1, 8); // O IPHS1 DOS exige que o nome tenha no máximo 8 caracteres
  SL := TStringList.Create;
  try
    DeleteFile(DirSai + '\' + s + '.sai');
    ent := DirSai + '\' + s + '.ent';

    PCs.CalcularHierarquia;

    PrepararCarta(SL);
    SL.SaveToFile(ent);

    // Só da para extrair a forma curta do nome de um arquivo existente
    ent := ExtractShortPathName(ent);
    sai := ChangeFileExt(ent, '.sai');
    err := ChangeFileExt(ent, '.err');

    // Caminho dos arquivos
    SL.Clear;
    SL.Add(ent);
    SL.Add(sai);
    SL.Add(err);
    SL.SaveToFile(gExePath + 'DRVPROY');

    SetCurrentDir(gExePath);
    if FME = meDOS then
       try
         //
         Exec := TExecFile.Create(nil);
         Exec.Wait := True;
         Exec.CommandLine := gExePath + 'PROY.EXE';
         ds := DecimalSeparator;
         DecimalSeparator := '.';
         if Exec.Execute then
            begin
(*
            SL.LoadFromFile(err);
            if SL[0] {Num. op. totais} = SL[1] {Última op. realizada} then
               begin
               LerResultados(sai);
               Dialogs.ShowMessage(LanguageManager.GetMessage(cMesID_IPH, 39){'Simulação concluída. Verifique a saída'});
               end
            else
               Dialogs.ShowMessage(LanguageManager.GetMessage(cMesID_IPH, 40)
                                  {'Erro na Simulação.'#13#10 +
                                   'Última operação realizada: '} + SL[2]);
*)
            LerResultados(sai);
            Dialogs.ShowMessage(LanguageManager.GetMessage(cMesID_IPH, 39){'Simulação concluída. Verifique a saída'});

            gOutPut.Editor.NewPage;
            gOutPut.Editor.OpenDoc(ent);
            gOutPut.Editor.NewPage;
            gOutPut.Editor.OpenDoc(sai);
            gOutPut.Editor.Show;
            end;
       finally
         DecimalSeparator := ds;
         Exec.Free;
       end;
  finally
    SL.Free;
  end;
end;

procedure Tiphs1_Projeto.Executar;
begin
  Status := sSimulando;
  GetMessageManager.SendMessage(UM_PREPARAR_SCRIPTS, [Self]);
  GetMessageManager.SendMessage(UM_INICIAR_SIMULACAO, [Self]);
  try
    ExecutarSimulacao;
  finally
    Status := sFazendoNada;
    GetMessageManager.SendMessage(UM_LIBERAR_SCRIPTS, [Self]);
  end;
end;

function Tiphs1_Projeto.RealizarDiagnostico(Completo: Boolean = False): Boolean;
var i,j,k  : integer;
    TudoOk : Boolean;
    T      : Tiphs1_TrechoDagua;
begin
  // Método abstrato no ascendente

  TudoOk := True;
  gErros.Clear;
  GetMessageManager.SendMessage(UM_RESET_VISIT, [0]);

  if PCs.PCs = 0 then
     begin
     gErros.Add(etError,
     Format(LanguageManager.GetMessage(cMesID_IPH, 41){'Projeto: %s'#13'Rede não definida!'}, [Nome]));
     TudoOk := False;
     end;

  if NomeArquivo = '' then
     begin
     gErros.Add(etError, LanguageManager.GetMessage(cMesID_IPH, 42){'Projeto sem nome !'});
     TudoOk := False;
     end;

  Diagnostico(TudoOk, Completo);

  // Realiza o diagnostico de todos os objetos conectados aos PCs, inclusive o deles
  for i := 0 to PCs.PCs-1 do
    begin
    PCs[i].Diagnostico(TudoOk, Completo);

    // Valida o Trecho dágua do PC e a sub-bacia deste trecho
    if PCs[i].TrechoDagua <> nil then
       begin
       T := Tiphs1_TrechoDagua(PCs[i].TrechoDagua);
       T.Diagnostico(TudoOk, Completo);
       if T.SubBacia <> nil then
          begin
          T.SubBacia.Visitado := True;
          T.SubBacia.Diagnostico(TudoOk, Completo);
          end;
       end;

    // Valida as Sub-Bacias deste PC.
    // Esta sub-bacias poder ser compartilhadas por outros PCs
    for j := 0 to PCs[i].SubBacias-1 do
      if not PCs[i].SubBacia[j].Visitado then
         begin
         PCs[i].SubBacia[j].Visitado := True;
         PCs[i].SubBacia[j].Diagnostico(TudoOk, Completo);
         end;

    // Valida a derivação deste PC se ele não é um Reservatório
    if (PCs[i] is Tiphs1_PC) and (Tiphs1_PC(PCs[i]).Derivacao <> nil) then
       Tiphs1_PC(PCs[i]).Derivacao.Diagnostico(TudoOk, Completo);
    end;

  Result := TudoOk;
end;

procedure Tiphs1_Projeto.RelatorioGeral;
const cSeparador = '--------------------- // --------------------- // ---------------------';

var i, j : Integer;
    SL   : TStrings;
begin
  with gOutPut.Editor do
    begin
    NewPage;

    Write    ('PROJETO *********************************************************************************************');
    Write;

    self.AutoDescricao(0);

    Write    ('CLASSES DE DEMANDAS e DESCENDENTES ******************************************************************');
    Write;

    Write    ('SUB-BACIAS ******************************************************************************************');
    Write;

    ObtemSubBacias;
    for i := 0 to SubBacias.Count - 1 do
      begin
      Tiphs1_SubBacia(SubBacias[i]).AutoDescricao(0);
      if i < SubBacias.Count - 1 then
         begin
         WriteCenter(cSeparador, 80);
         Write;
         end;
      end;

    Write;
    Write    ('POSTOS DE CONTROLE (PCs) ****************************************************************************');
    Write;

    for i := 0 to PCs.PCs-1 do
      begin
      PCs.PC[i].AutoDescricao(0);
      if i < PCs.PCs-1 then
         begin
         WriteCenter(cSeparador, 80);
         Write;
         end;
      end;

    Show;
    end;
end;

function Tiphs1_Projeto.CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TgrGrafico;
begin
  Result := TgrGraficoPlanilha.Create;
  Result.Grafico.Title.Text.Add(Titulo);
end;

procedure Tiphs1_Projeto.DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);
begin
end;
{
procedure Tiphs1_Projeto.MostrarDataSet(const Titulo: String; Dados: TwsDataSet);
var d    : TprDialogo_PlanilhaBase;
    i, j : Integer;
begin
  d := TprDialogo_PlanilhaBase.Create(AreaDeProjeto);
  d.Caption := Titulo;
  d.Show;

  StartWait;

  for i := 1 to Dados.NRows do
    d.Tab.TextRC[i+1, 1] := Dados.Row[i].Name;

  for j := 1 to Dados.nCols do
    d.Tab.TextRC[1, j+1] := Dados.Struct.Col[j].Name;

  for i := 1 to Dados.NRows do
    for j := 1 to Dados.nCols do
      d.Tab.NumberRC[i+1, j+1] := Dados[i, j];

  StopWait;
end;

function Tiphs1_Projeto.ObtemDataSet(Dados: TV): TwsDataSet;
var i, j, k, ii: integer;
    v: TV;
begin
  // Criação da estrutura do Conjunto de dados: Anos X Intervalos Anuais
  ii := TotalAnual_IntSim;
  Result := TwsDataSet.Create('DS_' + Nome, 0, 0);
  for i := 1 to ii do
    Result.Struct.AddNumeric('_'+ intToStr(i) + '_', '');
end;
}
procedure Tiphs1_Projeto.PrepararParaSimulacao;
var i: Integer;
begin
  inherited;
  FreeAndNil(FDadosPostos);
  if FPChuva.Count <> 0 then
     begin
     FDadosPostos := TwsDataSet.Create('Dados_Postos', FNITC, 0);
     for i := 0 to FPChuva.Count-1 do
       FDadosPostos.Struct.AddNumeric('Posto_' + IntToStr(i+1), ''); 
     FDadosPostos.Fill(0); // prepara e preenche a estrutura com zeros
     end;
end;

procedure Tiphs1_Projeto.LerResultados(const Arquivo: String);
var SL, SL2: TStrings;
    L : Integer;

    function Localizar(const Texto: String; var ApartirDe: Integer): Boolean;
    begin
      Result := False;
      if ApartirDe < SL.Count then
         repeat
           if System.Pos(Texto, SL[ApartirDe]) > 0 then
              begin
              Result := True;
              Exit;
              end;
           inc(ApartirDe);
         until ApartirDe = SL.Count;
    end;

    procedure Erro(const Msg: String);
    begin
      Raise Exception.Create(Msg);
    end;

    procedure LerDadosDosPostos;
    var i, j, k: Integer;
    begin
      k := 0;
      for i := L+4 to L+4+FNITC-1 do
        begin
        inc(k);
        StringToStrings(DelSpace1(AllTrim(SL[i])), SL2, [#32]);
        for j := 1 to SL2.Count-1 do
          FDadosPostos[k, j] := StrToFloatDef(SL2[j]);
        end;
    end;

    procedure LerDadosDaOperacao(Oper: Integer);
    var HC  : THidroComponente;
        SB  : Tiphs1_SubBacia;
        k,i : Integer;
    begin
      HC := ObterObjetoPelaOperacao(Oper);
      if HC = nil then
         Exit;
{
      else
         if HC.IB.Oper = coH then
            Exit;
}
      if (HC.IB.Oper = coTCV) and Localizar('INT     PRECIP', L) then
         begin
         k := 0;
         SB := Tiphs1_SubBacia(HC);
         for i := L+3 to L+3+FNITC-1 do
           begin
           inc(k);
           SB.TabPrecip[k, 1] := StrToFloat(AllTrim(Copy(SL[i], 16, 09)));
           SB.TabPrecip[k, 2] := StrToFloat(AllTrim(Copy(SL[i], 26, 09)));
           SB.TabPrecip[k, 3] := StrToFloat(AllTrim(Copy(SL[i], 36, 08)));
           SB.TabPrecip[k, 4] := StrToFloat(AllTrim(Copy(SL[i], 45, 09)));
           end;
         inc(L, SB.TabPrecip.NRows + 3);
         end;

      if Localizar('AT    VAZAO', L) then
         begin
         k := 0;
         for i := L+2 to L+2+HC.HidroRes.Len-1 do
           begin
           inc(k);
           HC.HidroRes[k] := StrToFloat(AllTrim(Copy(SL[i], 7, 9)));
           end;
         inc(L, HC.HidroRes.Len + 2);
         end;

      if Localizar('VOL ESCOADO=', L) then
         HC.VolEscoado := StrToFloat(AllTrim(Copy(SL[L], 23, 8)));
    end;

var i, Oper: Integer;
begin
  L := 0;
  SL  := TStringList.Create;
  SL2 := TStringList.Create;
  try
    SL.LoadFromFile(Arquivo);

    if (FPChuva.Count > 0) and Localizar('NUMERO DE POSTOS COM CHUVA:', L) then
       LerDadosDosPostos;

    repeat
      if Localizar('OPERACAO NRO', L) then
         begin
         Oper := StrToInt(Alltrim(Copy(SL[L], 26, 3)));
         LerDadosDaOperacao(Oper);
         inc(L);
         end
      else
         break;
    until false;

  finally
    SL.Free;
    SL2.Free;
  end;
end;

{ Tiphs1_TrechoDagua }

procedure Tiphs1_TrechoDagua.AutoDescricao(Identacao: byte);
begin
  inherited;

end;

function Tiphs1_TrechoDagua.ConectarObjeto(Obj: THidroComponente): Integer;
begin
  if Obj is Tiphs1_SubBacia then
     FSB := Tiphs1_SubBacia(Obj)
  else
     inherited ConectarObjeto(Obj);
end;

procedure Tiphs1_TrechoDagua.CopiarPara(HC: THidroObjeto);
begin
  inherited;
  with Tiphs1_TrechoDagua(HC) do
    begin
    FMPE    := self.FMPE;        
    FRPI    := self.FRPI;        
    FCFPI   := self.FCFPI;       
    FCTP    := self.FCTP;        
    FVR     := self.FVR;         
    FLPI    := self.FLPI;        
    FDFC    := self.FDFC;        
    FLC     := self.FLC;         
    FRST    := self.FRST;        
    FITC    := self.FITC;        
    FNHCL   := self.FNHCL;       
    FNST    := self.FNST;

    FNPT_KX := self.FNPT_KX;
    FTab_KX.Assign(self.FTab_KX);
    end;
end;

constructor Tiphs1_TrechoDagua.Create(PC1, PC2: TPC; UmaTabelaDeNomes: TStrings; Projeto: TProjeto);
begin
  inherited Create(PC1, PC2, UmaTabelaDeNomes, Projeto);
  FTab_KX := TTab3D.Create(3);
  IB.Oper := coRio;
end;

function Tiphs1_TrechoDagua.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := Tiphs1_Form_Dialogo_TD.Create(nil);
  Result.TN := TabNomes;
end;

procedure Tiphs1_TrechoDagua.DesconectarObjetos;
begin
  FreeAndNil(FSB);
  inherited;
end;

destructor Tiphs1_TrechoDagua.Destroy;
begin
  FTab_KX.Free;
  DesconectarObjetos;
  inherited;
end;

procedure Tiphs1_TrechoDagua.LerDoArquivo(Ini: TIF; const Secao: String);
begin
  inherited;
  with Ini do
    begin
    byte(FMPE) := ReadInteger (Secao, 'MPE', 0);

    FRPI    := ReadFloat   (Secao, 'RPI'   , 0);
    FCFPI   := ReadFloat   (Secao, 'CFPI'  , 0);
    FCTP    := ReadFloat   (Secao, 'CTP'   , 0);
    FVR     := ReadFloat   (Secao, 'VR'    , 0);
    FLPI    := ReadFloat   (Secao, 'LPI'   , 0);
    FDFC    := ReadFloat   (Secao, 'DFC'   , 0);
    FLC     := ReadFloat   (Secao, 'LC'    , 0);
    FRST    := ReadFloat   (Secao, 'RST'   , 0);
    FITC    := ReadInteger (Secao, 'ITC'   , 0);
    FNHCL   := ReadInteger (Secao, 'NHCL'  , 0);
    FNST    := ReadInteger (Secao, 'NST'   , 0);
    FNPT_KX := ReadInteger (Secao, 'NPT_KX', 0);

    FTab_KX.LoadFromFile(Ini, Secao, 'KX_Pontos');
    end
end;

procedure Tiphs1_TrechoDagua.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_TD) do
    begin
    if rbCL .Checked then FMPE := mpeCL else
    if rbCNL.Checked then FMPE := mpeCNL else
    if rbCPI.Checked then FMPE := mpeCPI else
    if rbKX .Checked then FMPE := mpeKX;
    GetDados(FCTP, FDFC, FLC, FRST, FVR, FCFPI, FLPI, FRPI, FITC, FNHCL, FNST, FNPT_KX, FTab_KX);
    end;
end;

procedure Tiphs1_TrechoDagua.PlotarHidrogramasEm(G: TgrGrafico);
begin
end;

procedure Tiphs1_TrechoDagua.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_TD) do
    begin
    case FMPE of
      mpeCL  : rbCL .Checked := True;
      mpeCNL : rbCNL.Checked := True;
      mpeCPI : rbCPI.Checked := True;
      mpeKX  : rbKX .Checked := True;
      end;
    SetDados(FCTP, FDFC, FLC, FRST, FVR, FCFPI, FLPI, FRPI, FITC, FNHCL, FNST, FNPT_KX, FTab_KX);
    end;
end;

procedure Tiphs1_TrechoDagua.PrepararParaSimulacao;
begin
  inherited;
end;

function Tiphs1_TrechoDagua.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_OBJETO_SE_DESTRUINDO then
     if FSB = MSG.ParamAsObject(0) then
        FSB := nil;

  inherited ReceiveMessage(MSG);
end;

procedure Tiphs1_TrechoDagua.SalvarEmArquivo(Arquivo: TIF);
begin
  inherited;
  with Arquivo do
    begin
    if FSB <> nil then WriteString(Secao, 'SubBacia', FSB.Nome);

    WriteInteger (Secao, 'MPE'   , Ord(FMPE));
    WriteFloat   (Secao, 'RPI'   , FRPI   );
    WriteFloat   (Secao, 'CFPI'  , FCFPI  );
    WriteFloat   (Secao, 'CTP'   , FCTP   );
    WriteFloat   (Secao, 'VR'    , FVR    );
    WriteFloat   (Secao, 'LPI'   , FLPI   );
    WriteFloat   (Secao, 'DFC'   , FDFC   );
    WriteFloat   (Secao, 'LC'    , FLC    );
    WriteFloat   (Secao, 'RST'   , FRST   );
    WriteInteger (Secao, 'ITC'   , FITC   );
    WriteInteger (Secao, 'NHCL'  , FNHCL  );
    WriteInteger (Secao, 'NST'   , FNST   );
    WriteInteger (Secao, 'NPT_KX', FNPT_KX);
    FTab_KX.SaveToFile(Arquivo, Secao, 'KX_Pontos');
    end;
end;

procedure Tiphs1_TrechoDagua.ValidarDados(var TudoOk: Boolean; DialogoDeErros: TErros_DLG; Completo: Boolean);
begin
  inherited;
end;

{ Tiphs1_PC }

function Tiphs1_PC.ConectarObjeto(Obj: THidroComponente): Integer;
begin
  if Obj is Tiphs1_Derivacao then
     begin
     FDerivacao := Tiphs1_Derivacao(Obj);
     if TrechoDagua <> nil then
        begin
        FDerivacao.CPD := Tiphs1_TrechoDagua(TrechoDagua).DFC;
        FDerivacao.CPL := Tiphs1_TrechoDagua(TrechoDagua).LC;  
        FDerivacao.CPR := Tiphs1_TrechoDagua(TrechoDagua).RST;
        end
     end
  else
     inherited ConectarObjeto(Obj);
end;

function Tiphs1_PC.CriarInstancia: THidroObjeto;
begin
  Result := Tiphs1_PC.Create(Point(Pos.X + 20, Pos.Y - 20), Projeto, TabNomes);
end;

constructor Tiphs1_PC.Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(Pos, Projeto, UmaTabelaDeNomes);

  if Projeto <> nil then
     begin
     ImagemDoComponente.Width  := 10;
     ImagemDoComponente.Height := 10;
     ImagemDoComponente.Canvas.Brush.Color  := clBlue;
     Self.Pos := Pos;
     end;

  IB.Oper := iphs1_Tipos.coSH;
end;

function Tiphs1_PC.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := Tiphs1_Form_Dialogo_PC.Create(nil);
  Result.TN := TabNomes;
end;

procedure Tiphs1_PC.DesconectarObjetos;
begin
  FreeAndNil(FDerivacao);
  inherited;
end;

function Tiphs1_PC.MudarParaReservatorio(UmMenu: TPopupMenu): Tiphs1_PCR;
var p: TPoint;
begin
  p := Pos;
  Result := Tiphs1_PCR.Create(p, Projeto, nil);
  Result.TabNomes := TabNomes;
  Result.Menu := UmMenu;
  GetMessageManager.SendMessage(UM_TROCAR_REFERENCIA, [Self, Result]);

  CopiarPara(Result);

  // Troca as Referências

  Result.FSubBacias.Free;
  Result.FSubBacias := FSubBacias;
  FSubBacias := nil;

  Result.FPCs_aMontante.Free;
  Result.FPCs_aMontante := FPCs_aMontante;
  FPCs_aMontante := nil;

  Result.FTD.Free;
  Result.FTD := FTD;
  FTD := nil;

  Result.AtualizarHint;
end;

function Tiphs1_PC.ObtemPrefixo: String;
begin
  Result := 'PC_';
end;

procedure Tiphs1_PC.PlotarHidrogramasEm(G: TgrGrafico);
begin
  inherited;
  if Derivacao <> nil then
     G.Series.AdicionaSerieDePontos('Qs de ' + Derivacao.Nome + ' (m³/s)', clTEAL, Derivacao.HidroRes);
end;

function Tiphs1_PC.PossuiObjetosConectados: Boolean;
begin
  Result := (SubBacias > 0) or (FDerivacao <> nil);
end;

function Tiphs1_PC.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_OBJETO_SE_DESTRUINDO then
     if FDerivacao = MSG.ParamAsObject(0) then
        FDerivacao := nil;

  inherited ReceiveMessage(MSG);
end;

procedure Tiphs1_PC.LerDoArquivo(Ini: TIF; const Secao: String);
begin
  inherited;
  with Ini do
    begin
    ImagemDoComponente.Canvas.Brush.Color := TColor(ReadInteger(Secao, 'Cor', Integer(clBlue)));
    end;
end;

procedure Tiphs1_PC.SalvarEmArquivo(Arquivo: TIF);
begin
  inherited;
  Arquivo.WriteInteger(Secao, 'Cor', Integer(ImagemDoComponente.Canvas.Brush.Color));
  if FDerivacao <> nil then
     Arquivo.WriteString(Secao, 'Derivacao', FDerivacao.Nome);
end;

procedure Tiphs1_PC.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_PC) do
    begin
    ImagemDoComponente.Canvas.Brush.Color := cbCor.Selected;
    ImagemDoComponente.Invalidate;
    end;
end;

procedure Tiphs1_PC.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_PC) do
    begin
    cbCor.Selected := ImagemDoComponente.Canvas.Brush.Color;
    end;
end;

{ Tiphs1_Derivacao }

procedure Tiphs1_Derivacao.AutoDescricao(Identacao: byte);
begin
  inherited;

end;

procedure Tiphs1_Derivacao.CopiarPara(HC: THidroObjeto);
begin
  inherited;
  with Tiphs1_Derivacao(HC) do
    begin
    FCPD := self.FCPD;
    FCPR := self.FCPR;
    FCDL := self.FCDL;
    FCDD := self.FCDD;
    FCPL := self.FCPL;
    FCDR := self.FCDR;
    end;
end;

constructor Tiphs1_Derivacao.Create(Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(UmaTabelaDeNomes, Projeto);

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, Self);

  CriarComponenteVisual;
  ImagemDoComponente.Width  := 20;
  ImagemDoComponente.Height := 20;
  ImagemDoComponente.Canvas.Brush.Color := clSilver;

  IB.Oper := coDer;
end;

function Tiphs1_Derivacao.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := Tiphs1_Form_Dialogo_Derivacao.Create(nil);
  Result.TN := TabNomes;
end;

function Tiphs1_Derivacao.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'DERIVACAO_20X20');
  TdrBitmap(Result).DrawFrame := True;
end;

destructor Tiphs1_Derivacao.Destroy;
begin
  GetMessageManager.UnregisterMessage(UM_REPINTAR_OBJETO, self);
  inherited;
end;

procedure Tiphs1_Derivacao.LerDoArquivo(Ini: TIF; const Secao: String);
begin
  inherited;
  with Ini do
    begin
    FCDD := ReadFloat(Secao, 'CDD', 0);
    FCDL := ReadFloat(Secao, 'CDL', 0);
    FCDR := ReadFloat(Secao, 'CDR', 0);
    FCPD := ReadFloat(Secao, 'CPD', 0);
    FCPL := ReadFloat(Secao, 'CPL', 0);
    FCPR := ReadFloat(Secao, 'CPR', 0);
    end;
end;

function Tiphs1_Derivacao.ObtemPrefixo: String;
begin
  Result := 'Derivacao_';
end;

procedure Tiphs1_Derivacao.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_Derivacao) do
    begin
    FCDL := edCDL.AsFloat;
    FCDD := edCDD.AsFloat;
    FCDR := edCDR.AsFloat;
    FCPD := edCPD.AsFloat;
    FCPR := edCPR.AsFloat;
    FCPL := edCPL.AsFloat;
    end
end;

procedure Tiphs1_Derivacao.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_Derivacao) do
    begin
    edCDL.AsFloat := FCDL;
    edCDD.AsFloat := FCDD;
    edCDR.AsFloat := FCDR;
    edCPD.AsFloat := FCPD;
    edCPR.AsFloat := FCPR;
    edCPL.AsFloat := FCPL;
    end;
end;

function Tiphs1_Derivacao.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_REPINTAR_OBJETO then
     ImagemDoComponente.Paint;

  inherited ReceiveMessage(MSG);
end;

procedure Tiphs1_Derivacao.SalvarEmArquivo(Arquivo: TIF);
begin
  inherited;
  with Arquivo do
    begin
    WriteFloat(Secao, 'CDD', FCDD);
    WriteFloat(Secao, 'CDL', FCDL);
    WriteFloat(Secao, 'CDR', FCDR);
    WriteFloat(Secao, 'CPD', FCPD);
    WriteFloat(Secao, 'CPL', FCPL);
    WriteFloat(Secao, 'CPR', FCPR);
    end;
end;

procedure Tiphs1_Derivacao.ValidarDados(var TudoOk: Boolean;
                                  DialogoDeErros: TErros_DLG; Completo: Boolean);
begin
  inherited;
end;

{ Tiphs1_EstruturaRes_Q }

procedure Tiphs1_EstruturaRes_Q.Associar(Estrutura: Tiphs1_EstruturaRes_Q);
begin
  FNPT := Estrutura.NPT;
  FIT := Estrutura.IT;
  FTab.Assign(Estrutura.Tab);
end;

constructor Tiphs1_EstruturaRes_Q.Create(IT, NumPontos: Integer);
begin
  inherited Create;
  FIT := IT;
  FNPT := NumPontos;
  FTab := TTab2D.Create(FNPT);
end;

destructor Tiphs1_EstruturaRes_Q.Destroy;
begin
  FTab.Free;
  inherited;
end;

procedure Tiphs1_EstruturaRes_Q.LerDoArquivo(Arquivo: TIF; const Secao, SubSecao: String);
begin
  FNPT := Arquivo.ReadInteger(Secao, SubSecao + '_NPT', 0);
  FIT  := Arquivo.ReadInteger(Secao, SubSecao + '_IT', 0);
  FTab.LoadFromFile(Arquivo, Secao, SubSecao);
end;

procedure Tiphs1_EstruturaRes_Q.SalvarEmArquivo(Arquivo: TIF; const Secao, SubSecao: String);
begin
  Arquivo.WriteInteger(Secao, SubSecao + '_NPT', FNPT);
  Arquivo.WriteInteger(Secao, SubSecao + '_IT', FIT);
  FTab.SaveToFile(Arquivo, Secao, SubSecao);
end;

{ Tiphs1_EstruturasRes_Q }

constructor Tiphs1_EstruturasRes_Q.Create;
begin
  inherited;
  FList := TObjectList.Create(True);
end;

destructor Tiphs1_EstruturasRes_Q.Destroy;
begin
  FList.Free;
  inherited;
end;

function Tiphs1_EstruturasRes_Q.Adicionar(IT, NumPontos: Integer): Tiphs1_EstruturaRes_Q;
begin
  Result := Tiphs1_EstruturaRes_Q.Create(IT, NumPontos);
  FList.Add(Result);
end;

function Tiphs1_EstruturasRes_Q.GetEst(i: Integer): Tiphs1_EstruturaRes_Q;
begin
  Result := Tiphs1_EstruturaRes_Q(FList[i]);
end;

procedure Tiphs1_EstruturasRes_Q.LerDoArquivo(Arquivo: TIF; const Secao: String);
var i: Integer;
    q: Tiphs1_EstruturaRes_Q;
begin
  FList.Clear;
  i := Arquivo.ReadInteger(Secao, 'EstruturasQ', 0);
  for i := 0 to i-1 do
    begin
    q := Adicionar(0, 0);
    q.LerDoArquivo(Arquivo, Secao, 'EstruturaQ' + IntToStr(i+1));
    end;
end;

procedure Tiphs1_EstruturasRes_Q.SalvarEmArquivo(Arquivo: TIF; const Secao: String);
var i: Integer;
begin
  Arquivo.WriteInteger(Secao, 'EstruturasQ', FList.Count);
  for i := 0 to FList.Count-1 do
    GetEst(i).SalvarEmArquivo(Arquivo, Secao, 'EstruturaQ' + IntToStr(i+1));
end;

function Tiphs1_EstruturasRes_Q.GetNumEstr: Integer;
begin
  Result := FList.Count;
end;

procedure Tiphs1_EstruturasRes_Q.SetNumEstr(const Value: Integer);
var i: Integer;
begin
  if Value <> FList.Count then
     if Value > FList.Count then
        for i := FList.Count+1 to Value do Adicionar(0, 0)
     else
        while FList.Count > Value do FList.Delete(FList.Count-1);
end;

procedure Tiphs1_EstruturasRes_Q.Associar(Estruturas: Tiphs1_EstruturasRes_Q);
var i: Integer;
begin
  SetNumEstr(Estruturas.NumEstruturas);
  for i := 0 to Estruturas.NumEstruturas-1 do
    GetEst(i).Associar(Estruturas[i]);
end;

end.

