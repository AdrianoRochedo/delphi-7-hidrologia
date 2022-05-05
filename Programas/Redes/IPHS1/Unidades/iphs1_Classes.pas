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
     Form_Chart,
     Form_SheetChart,

     // Misc
     MessageManager,
     Rochedo.Simulators.Shapes,
     psBASE,
     psCORE,
     SysUtilsEx,
     MessagesForm,
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
  Tiphs1_PC         = Class;
  Tiphs1_PCR        = Class;

  // Trecho Paralelo de um conduto fechado
  TRec_TD_CF_TP = record
                    TS : Integer; // Tipo da secao
                    AD : Real;    // Altura/Diâmetro
                    L  : Real;    // Largura
                    DE : Real;    // Dec. Esq.
                    DD : Real;    // Dec. Dir
                    R  : Real;    // Rugosidade
                  end;

  // Trechos Paralelos
  TArray_Rec_TD_CF_TP = Array of TRec_TD_CF_TP;

  Tiphs1_TrechoDagua = class(TTrechoDagua)
  private
    FSB : Tiphs1_SubBacia;

    // Geral
    FMPE  : TenMPE;  // Tipo de Método
    FNHCL : Integer; // Número do hid. de contribuição Lateral

    // Base

    FCTP      : Real;    // Comprimento do Trecho
    FCFM      : Real;    // Cota de fundo de montante
    FCFJ      : Real;    // Cota de fundo de jusante
    FAC       : Real;    // Altura do canal
    FLC       : Real;    // Largura do canal
    FRST      : Real;    // Rugosidade dos Sub-Trechos
    FVR       : Real;    // Vazão de Ref.
    FNST      : Integer; // Número de Sub-trechos
    FITC      : Integer; // Intervalo de tempo de Cálculo
    FVR_auto  : Boolean; // Vazão de Ref. automática
    FNST_auto : Boolean; // Número de Sub-trechos automático
    FITC_auto : Boolean; // Intervalo de tempo de Cálculo automático
    FAPI      : Real;    // Planicie de Inundação - Altura da Planicie de Inundação
    FLPI      : Real;    // Planicie de Inundação - ALargura da Planicie de Inundação

    // Planicie de Inundacao

    FRPI : Real;    // Rugosidade da Planície de Idundação

    // Tabelas
    FNPT_KX : Integer;
    FTab_KX : TTab3D;

    { Conduto Fechado ------------------------------------------------------ }

    // Dados Gerais
    FCF_DG_VR       : Real;                   // Vazão de Ref.
    FCF_DG_LT       : Real;                   // Long. Trecho
    FCF_DG_CFM      : Real;                   // Cota de Fundo de Montante
    FCF_DG_CFJ      : Real;                   // Cota de Fundo de Jusante
    FCF_DG_IS       : Real;                   // Int. Sim.
    FCF_DG_ST       : Integer;                // Sub-Trechos
    FCF_DG_TE       : Integer;                // Tipo de Excesso: 0, 1 ou 2
    FCF_DG_Ex_RR    : Real;                   // Excesso 2: Rugosidade da Rua
    FCF_DG_Ex_AD_SR : Integer;                // Excesso 1: Secao de Ref.
    FCF_DG_Ex_AD_L  : Boolean;                // Excesso 1: Largura
    FCF_DG_Ex_AD_A  : Boolean;                // Excesso 1: Altura
    FCF_DG_Ex_AD_DE : Boolean;                // Excesso 1: Dec. Esq.
    FCF_DG_Ex_AD_DD : Boolean;                // Excesso 1: Dec. Dir.

    FCF_DG_VR_auto : Boolean;
    FCF_DG_IS_auto : Boolean;
    FCF_DG_ST_auto : Boolean;

    // trecho Principal
    FCF_TPrinc: TRec_TD_CF_TP;

    // trechos Paralelos
    FCF_TPs : TArray_Rec_TD_CF_TP;

    FTemQRua : Boolean;

    // Resultados
    FQRua   : TV;
    FCotas  : TV;
    Fal_Dur : Real;
    Fal_Vol : Real;
  protected
    procedure PlotarInformacoesExtras(G: TfoSheetChart); override;
    procedure PlotarHidrogramasEm(G: TfoChart); override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure PrepararParaSimulacao; override;
    function  ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure DesconectarObjetos; override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;
  public
    constructor Create(PC1, PC2: TPC; UmaTabelaDeNomes: TStrings; Projeto: TProjeto);
    destructor Destroy; override;

    procedure PlotarCotas;
    procedure PlotarQRua;

    property SubBacia : Tiphs1_SubBacia read FSB;

    // Número do hid. de contribuição Lateral
    property NHCL : Integer read FNHCL write FNHCL;

    // compartilhadas por CL, CNL e CPI

    property CTP  : Real    read FCTP write FCTP;
    property CFM  : Real    read FCFM write FCFM; // compartilhado também por KX
    property CFJ  : Real    read FCFJ write FCFJ; // compartilhado também por KX
    property AC   : Real    read FAC  write FAC;  // compartilhado também por KX
    property LC   : Real    read FLC  write FLC;
    property RST  : Real    read FRST write FRST;
    property VR   : Real    read FVR  write FVR;
    property NST  : Integer read FNST write FNST;
    property ITC  : Integer read FITC write FITC;

    property VR_auto  : Boolean read FVR_auto  write FVR_auto;
    property NST_auto : Boolean read FNST_auto write FNST_auto;
    property ITC_auto : Boolean read FITC_auto write FITC_auto;

    // complemento de CPI

    property API : Real read FAPI write FAPI;
    property LPI : Real read FLPI write FLPI;
    property RPI : Real read FRPI write FRPI;

    // KX

    property NPT_KX : Integer read FNPT_KX write FNPT_KX;
    property Tab_KX : TTab3D  read FTab_KX write FTab_KX;

    { Conduto Fechado ------------------------------------------------------ }

    // Dados Gerais
    property CF_DG_VR       : Real    read FCF_DG_VR;                // Vazão de Ref.
    property CF_DG_TE       : Integer read FCF_DG_TE;                // Tipo de Excesso
    property CF_DG_Ex_RR    : Real    read FCF_DG_Ex_RR;             // Excesso 2: Rugosidade da Rua
    property CF_DG_Ex_AD_SR : Integer read FCF_DG_Ex_AD_SR;          // Excesso 1: Secao de Ref.
    property CF_DG_Ex_AD_L  : Boolean read FCF_DG_Ex_AD_L;           // Excesso 1: Largura
    property CF_DG_Ex_AD_A  : Boolean read FCF_DG_Ex_AD_A;           // Excesso 1: Altura
    property CF_DG_Ex_AD_DE : Boolean read FCF_DG_Ex_AD_DE;          // Excesso 1: Dec. Esq.
    property CF_DG_Ex_AD_DD : Boolean read FCF_DG_Ex_AD_DD;          // Excesso 1: Dec. Dir.
    property CF_DG_LT       : Real    read FCF_DG_LT;                // Long. Trecho
    property CF_DG_CFM      : Real    read FCF_DG_CFM;               // Cota de Fundo de Montante
    property CF_DG_CFJ      : Real    read FCF_DG_CFJ;               // Cota de Fundo de Jusante
    property CF_DG_IS       : Real    read FCF_DG_IS;                // Int. Sim.
    property CF_DG_ST       : Integer read FCF_DG_ST;                // Sub-Trechos
    property CF_DG_VR_auto  : Boolean read FCF_DG_VR_auto;
    property CF_DG_IS_auto  : Boolean read FCF_DG_IS_auto;
    property CF_DG_ST_auto  : Boolean read FCF_DG_ST_auto;

    // Trecho Pprincipal
    property CF_TPrinc : TRec_TD_CF_TP read FCF_TPrinc;

    // Trechos Paralelos
    property CF_TPs : TArray_Rec_TD_CF_TP read FCF_TPs;

    { Fim Conduto Fechado ------------------------------------------------------ }

    // Método
    property MPE : TenMPE read FMPE write FMPE;

    // Verifica se o QRua foi gerado
    property TemQRua : Boolean read FTemQRua write FTemQRua;

    { Resultados --------------------------------------------------------------- }

    property QRua               : TV   read FQRua;
    property Cotas              : TV   read FCotas;
    property Alagamento_Volume  : Real read Fal_Vol write Fal_Vol;
    property Alagamento_Duracao : Real read Fal_Dur write Fal_Dur;
  end;

  Tiphs1_Derivacao = class(THidroComponente)  // Reservatorio
  private
    FCPD: Real;
    FCPR: Real;
    FCDL: Real;
    FCDD: Real;
    FCPL: Real;
    FCDR: Real;
    FPer: Real;
    FPC: Tiphs1_PC;
  protected
    Function  ObtemPrefixo: String; Override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure PlotarHidrogramaResultante; override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;
  public
    constructor Create(Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    // PC onde esta derivacao esta conectado
    property PC : Tiphs1_PC read FPC write FPC;

    // Derivação
    property CDD : Real read FCDD write FCDD;
    property CDL : Real read FCDL write FCDL;
    property CDR : Real read FCDR write FCDR;
    property CPD : Real read FCPD write FCPD;
    property CPL : Real read FCPL write FCPL;
    property CPR : Real read FCPR write FCPR;

    // Divisão de Hidrograma
    property Percentagem : Real read FPer;
  end;

  Tiphs1_PC_Base = Class(TPC)
  protected
    function CriarTrechoDagua(ConectarEm: TPC): TTrechoDagua; override;
    procedure PlotarHidrogramasEm(G: TfoChart); override;
  end;

  Tiphs1_PC = class(Tiphs1_PC_Base)
  private
    FDerivacao: Tiphs1_Derivacao;
  protected
    procedure PlotarHidrogramasEm(G: TfoChart); override;
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

  Tiphs1_Res_EstruturasExtravazoras = class
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
    procedure Associar(Estruturas: Tiphs1_Res_EstruturasExtravazoras);

    property NumEstruturas : Integer read GetNumEstr write SetNumEstr;
    property Estrutura[i: Integer] : Tiphs1_EstruturaRes_Q read GetEst; default;
  end;

  Tiphs1_PCR = class(Tiphs1_PC_Base)  // Reservatorio
  private
    // Geral
    FAI : Real;   // Armazenamento Inicial

    // Vertedor
    FVert_CD : Real;  // Coef. Descarga
    FVert_L  : Real;  // Largura
    FVert_CC : Real;  // Cota da Crista

    // Orificio
    FOrif_CD : Real;  // Coef. Descarga
    FOrif_A  : Real;  // Area
    FOrif_C  : Real;  // Cota

    // NO = 0
    FSaidaPor_VO    : Boolean;   // Saída por Vertedor e/ou Orifício
    FTemVertedor    : Boolean;   // Possui Vertedor ?
    FTemOrificio    : Boolean;   // Possui Orificio
    FVZO_Max_Bypass : Real;      // Vazão Máx. do Bypass

    // NO > 0
    FSaidaPor_EE : Boolean;      // Possui Estruturas Extravazoras
    FEE          : Tiphs1_Res_EstruturasExtravazoras; // Estruturas

    // Tabela Cota-Volume
    FTCV_CMR : Real;             // Cota Máx. do Reservatório
    FTCV_Tab : TTab2D;           // Dados Cota-Volume

    FCotas : TwsDataSet;
  protected
    Function  ObtemPrefixo: String; Override;
    function  PossuiObjetosConectados: Boolean; override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    function  CriarInstancia: THidroObjeto;  override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure PrepararParaSimulacao; override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;
  public
    constructor Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    function MudarParaPC(UmMenu: TPopupMenu): Tiphs1_PC;
    procedure MostrarCotas;
    procedure PlotarCotas;

    // Geral
    property AI : Real read FAI write FAI;

    // Vertedor
    property Vert_CD : Real read FVert_CD;  // Coef. Descarga
    property Vert_L  : Real read FVert_L;   // Largura
    property Vert_CC : Real read FVert_CC;  // Cota da Crista

    // Orificio
    property Orif_CD : Real read FOrif_CD;  // Coef. Descarga
    property Orif_A  : Real read FOrif_A;   // Area
    property Orif_C  : Real read FOrif_C;   // Cota

    // NO = 0
    property SaidaPor_VO    : Boolean read FSaidaPor_VO;    // Saída por Vertedor e/ou Orifício
    property TemVertedor    : Boolean read FTemVertedor;    // Possui Vertedor ?
    property TemOrificio    : Boolean read FTemOrificio;    // Possui Orificio
    property VZO_Max_Bypass : Real    read FVZO_Max_Bypass; // Vazão Máx. do Bypass

    // NO > 0
    property SaidaPor_EE : Boolean read FSaidaPor_EE;         // Possui Estruturas Extravazoras
    property EE : Tiphs1_Res_EstruturasExtravazoras read FEE; // Estruturas

    // Tabela Cota-Volume
    //property TCV_NPT : byte   read FTCV_NPT;  // Numero de Pontos na Tabela
    property TCV_CMR : Real   read FTCV_CMR;  // Cota Máx. do Reservatório
    property TCV_Tab : TTab2D read FTCV_Tab;  // Dados Cota-Volume

    // Resultados
    property Cotas : TwsDataSet read FCotas;
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

    FIR       : boolean;
    FAB       : Real;
    FTC       : Real;
    FTabT     : Real;
    FH        : String;
    FTipo     : TenTipoSubBacia;
    FES       : TenES;
    FSE       : TenSE;
    FTP       : TenTP;
    FCoefs    : TTab1D;

    FTabPrecip: TwsDataSet;
    procedure setHU_NPT(const Value: byte);
  protected
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PrepararParaSimulacao; override;
    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure CopiarPara(HC: THidroObjeto); override;
    procedure PlotarHidrogramaResultante; override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;
  public
    constructor Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    procedure Copiar(SB: Tiphs1_SubBacia);

    procedure PlotarGrafico_Perdas_X_Efetiva;
    procedure PlotarTabelaDePrecipitacoes;
    procedure MostrarTabPrecipitacao;

    property Tipo : TenTipoSubBacia read FTipo write FTipo;

    // TCV.Base
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
    property HU_NPT : byte   read FHU_NPT write setHU_NPT;
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

    function LerResultados(const ArqErr, Dir: String): Boolean;
    function PossuiAlagamentos(): Boolean;
  protected
    procedure PercorreSubBacias(ITSB: TProcPSB); override;
    procedure ExecutarSimulacao; override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Override;
    function  CriarDialogo: TForm_Dialogo_Base; Override;
    procedure LerDoArquivo(Ini: TIF; const Secao: String); Overload; Override;
    procedure SalvarEmArquivo(Arquivo: TIF); Overload; Override;
    procedure PrepararParaSimulacao; override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;
  public
    constructor Create(UmaTabelaDeNomes: TStrings);
    destructor  Destroy; override;

    procedure Executar;

    // Métodos da simulação
    function  RealizarDiagnostico(Completo: Boolean = False): Boolean; override;
    procedure TerminarSimulacao; override;

    function  CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TfoChart;
    procedure DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);

    property ModoDeExecucao : TenModoDeExecucao read FME     write FME;       // Indica se estamos no modo DOS ou WIN
    property NIT            : word              read FNIT    write FNIT;      // Número de intervalos de tempo
    property NITC           : word              read FNITC   write FNITC;     // Número de intervalos de tempo com Chuva
    property TIT            : Real              read FTIT    write FTIT;      // Tamanho do intervalo de tempo
    property PChuva         : TStrings          read FPChuva write FPChuva;   // Postos de chuva

    // Resultados
    property DadosPostos : TwsDataSet read FDadosPostos;
  end;

implementation
uses Dialogs, ImgList, FileCTRL, Math, stDate,

     // Unidades básicas
     Hidro_Procs,
     iphs1_Procs,

     // Misc
     wsConstTypes,
     foBook,
     Execfile,
     wsVec,
     WinUtils,
     FileUtils,
     drPlanilha,
     SpreadSheetBook,
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
     iphs1_Dialogo_TD_Alagamentos,

     // Frames
     FrameEstruturaRes_Q,

     // Planilhas
     Planilha_DadosDosObjetos,

     //Graficos
     Graf_CExHR,
     Graf_Res_Cota_X_Vazao,

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

procedure Tiphs1_PC_Base.PlotarHidrogramasEm(G: TfoChart);
var i, k: Integer;
    TD: TTrechoDagua;
begin
  i := 0;
  for i := 0 to SubBacias-1 do
    G.Series.AddLineSerie('Qs ' + SubBacia[i].Nome + ' (m³/s)', SelectColor(i, True), SubBacia[i].HidroRes);

  for k := 0 to PCs_aMontante-1 do
    begin
    TD := PC_aMontante[k].TrechoDagua;
    G.Series.AddLineSerie('Qs ' + TD.Nome + ' (m³/s)', SelectColor(i + k, True), TD.HidroRes);
    end;
end;

{ Tiphs1_PCR }

constructor Tiphs1_PCR.Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  Inherited Create(Point(-100,-100), Projeto, UmaTabelaDeNomes);

  FTCV_Tab := TTab2D.Create(0);
  FEE      := Tiphs1_Res_EstruturasExtravazoras.Create;

  FSaidaPor_VO := True;

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
  FTCV_Tab.Free;
  FEE.Free;
  FCotas.Free;
  inherited Destroy;
end;

procedure Tiphs1_PCR.SalvarEmArquivo(Arquivo: TIF);
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    // Geral
    WriteFloat   (Secao, 'AI', FAI);

    // Vertedor
    WriteFloat   (Secao, 'Vert_CD', FVert_CD);
    WriteFloat   (Secao, 'Vert_L' , FVert_L);
    WriteFloat   (Secao, 'Vert_CC', FVert_CC);

    // Orificio
    WriteFloat   (Secao, 'Orif_CD', FOrif_CD);
    WriteFloat   (Secao, 'Orif_A' , FOrif_A);
    WriteFloat   (Secao, 'Orif_C' , FOrif_C);

    // NO = 0
    WriteBool    (Secao, 'SaidaPor_VO'   , FSaidaPor_VO);
    WriteBool    (Secao, 'TemVertedor'   , FTemVertedor);
    WriteBool    (Secao, 'TemOrificio'   , FTemOrificio);
    WriteFloat   (Secao, 'VZO_Max_Bypass', FVZO_Max_Bypass);

    // NO > 0
    WriteBool(Secao, 'SaidaPor_EE', FSaidaPor_EE);
    FEE.SalvarEmArquivo(Arquivo, Secao);

    // Tabela Cota-Volume
    //WriteInteger (Secao, 'TCV_NPT', FTCV_NPT);
    WriteFloat   (Secao, 'TCV_CMR', FTCV_CMR);
    FTCV_Tab.SaveToFile(Arquivo, Secao, 'TCV_Tab');
    end;
end;

procedure Tiphs1_PCR.LerDoArquivo(Ini: TIF; Const Secao: String);
begin
  Inherited LerDoArquivo(Ini, Secao);
  with Ini do
    begin
    // Geral
    FAI := ReadFloat (Secao, 'AI', 0);

    // Vertedor
    FVert_CD := ReadFloat (Secao, 'Vert_CD', 0);
    FVert_L  := ReadFloat (Secao, 'Vert_L' , 0);
    FVert_CC := ReadFloat (Secao, 'Vert_CC', 0);

    // Orificio
    FOrif_CD := ReadFloat (Secao, 'Orif_CD', 0);
    FOrif_A  := ReadFloat (Secao, 'Orif_A' , 0);
    FOrif_C  := ReadFloat (Secao, 'Orif_C' , 0);

    // NO = 0
    FSaidaPor_VO    := ReadBool  (Secao, 'SaidaPor_VO'   , True);
    FTemVertedor    := ReadBool  (Secao, 'TemVertedor'   , False);
    FTemOrificio    := ReadBool  (Secao, 'TemOrificio'   , False);
    FVZO_Max_Bypass := ReadFloat (Secao, 'VZO_Max_Bypass', 0);

    // NO > 0
    FSaidaPor_EE := ReadBool(Secao, 'SaidaPor_EE', False);
    FEE.LerDoArquivo (Ini, Secao);

    // Tabela Cota-Volume
    //FTCV_NPT := ReadInteger (Secao, 'TCV_NPT', 0);
    FTCV_CMR := ReadFloat   (Secao, 'TCV_CMR', 0);
    FTCV_Tab.LoadFromFile   (Ini, Secao, 'TCV_Tab');
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
    edAI.AsFloat := FAI;

    // Vertedor

    DLG_Vert.edCD.AsFloat := FVert_CD;
    DLG_Vert.edL.AsFloat  := FVert_L;
    DLG_Vert.edCC.AsFloat := FVert_CC;

    // Orificio

    DLG_Orif.edCD.AsFloat := FOrif_CD;
    DLG_Orif.edA.AsFloat  := FOrif_A;
    DLG_Orif.edC.AsFloat  := FOrif_C;

    // NO = 0 -> Vertedor e/ou Orificio

    paVO.Enabled     := FSaidaPor_VO;
    rbVO.Checked     := FSaidaPor_VO;
    cbVert.Checked   := FTemVertedor;
    cbOrif.Checked   := FTemOrificio;
    edBypass.AsFloat := FVZO_Max_Bypass;

    // NO > 0 -> Estruturas Extravazoras

    paEE.Enabled   := FSaidaPor_EE;
    rbEE.Checked   := FSaidaPor_EE;
    edNE.AsInteger := FEE.NumEstruturas;

    DLG_EE.NumEstruturas := FEE.NumEstruturas;
    for i := 0 to FEE.NumEstruturas-1 do
      begin
      f := TfrEstruturaRes_Q(DLG_EE.FindComponent('f' + IntToStr(i+1)));
      if f <> nil then
         begin
         f.edIT.AsInteger := FEE[i].IT;
         if FEE[i].NPT > 0 then
            begin
            f.Tab.MaxRow := FEE[i].NPT;
            f.edNPT.AsInteger := FEE[i].NPT;
            for k := 0 to FEE[i].Tab.Len-1 do
              begin
              f.Tab.NumberRC[k+1, 1] := FEE[i].Tab[k].x;
              f.Tab.NumberRC[k+1, 2] := FEE[i].Tab[k].y;
              end;
            end;
         end;
      end;

    // Tabela Cota-Volume

    DLG_TCV.edNPT.AsInteger := FTCV_Tab.Len;
    DLG_TCV.edCMR.AsFloat   := FTCV_CMR;

    if FTCV_Tab.Len > 0 then
       begin
       DLG_TCV.Tab.MaxRow := FTCV_Tab.Len;
       for i := 1 to FTCV_Tab.Len do
         begin
         DLG_TCV.Tab.NumberRC[i, 1] := FTCV_Tab[i-1].x;
         DLG_TCV.Tab.NumberRC[i, 2] := FTCV_Tab[i-1].y;
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
    FAI := edAI.AsFloat;

    // Vertedor

    FVert_CD := DLG_Vert.edCD.AsFloat;
    FVert_L := DLG_Vert.edL.AsFloat;
    FVert_CC := DLG_Vert.edCC.AsFloat;

    // Orificio

    FOrif_CD := DLG_Orif.edCD.AsFloat;
    FOrif_A := DLG_Orif.edA.AsFloat;
    FOrif_C := DLG_Orif.edC.AsFloat;

    // NO = 0 -> Vertedor e/ou Orificio

    FSaidaPor_VO := rbVO.Checked;
    FTemVertedor := cbVert.Checked;
    FTemOrificio := cbOrif.Checked;
    FVZO_Max_Bypass := edBypass.AsFloat;

    // NO > 0 -> Estruturas Extravazoras

    FSaidaPor_EE := rbEE.Checked;
    FEE.NumEstruturas := edNE.AsInteger;

    for i := 0 to FEE.NumEstruturas-1 do
      begin
      f := TfrEstruturaRes_Q(DLG_EE.FindComponent('f' + IntToStr(i+1)));
      if f <> nil then
         begin
         FEE[i].NPT := f.edNPT.AsInteger;
         FEE[i].IT := f.edIT.AsInteger;
         FEE[i].Tab.Len := FEE[i].NPT;
         for k := 0 to FEE[i].NPT-1 do
           begin
           FEE[i].Tab[k].x := f.Tab.NumberRC[k+1, 1];
           FEE[i].Tab[k].y := f.Tab.NumberRC[k+1, 2];
           end;
         end;
      end;

    // Tabela Cota-Volume

   FTCV_Tab.Len := DLG_TCV.edNPT.AsInteger;
   FTCV_CMR     := DLG_TCV.edCMR.AsFloat;

    if FTCV_Tab.Len > 0 then
       for i := 1 to FTCV_Tab.Len do
         begin
         FTCV_Tab[i-1].x := DLG_TCV.Tab.NumberRC[i, 1];
         FTCV_Tab[i-1].y := DLG_TCV.Tab.NumberRC[i, 2];
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
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var R1: Real;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if FAI < 0 then
     begin
     DialogoDeErros.Add(etError,
     Format(LanguageManager.GetMessage(cMesID_IPH, 12)
           {'Objeto: %s'#13'Armazenamento Inicial inválido: %f'}, [Nome, FAI]));
     TudoOk := False;
     end;

  if FSaidaPor_VO then
     begin
     if not FTemVertedor and not FTemOrificio then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'Tipo de Saída (Vertedor e/ou Orifício) não definido', [Nome]));
        TudoOk := False;
        end;

     if FTemVertedor then
        begin
        if FVert_CD <= 0 then
           begin
           DialogoDeErros.Add(etError,
             Format('Objeto: %s'#13'Coeficiente de Descarga do Vertedor inválido: %f', [Nome, FVert_CD]));
           TudoOk := False;
           end;

        if FVert_L <= 0 then
           begin
           DialogoDeErros.Add(etError,
             Format('Objeto: %s'#13'Largura do Vertedor inválida: %f', [Nome, FVert_L]));
           TudoOk := False;
           end;

        if FVert_CC < 0 then
           begin
           DialogoDeErros.Add(etError,
             Format('Objeto: %s'#13'Cota da Crista do Vertedor inválida: %f', [Nome, FVert_CC]));
           TudoOk := False;
           end;
        end;

     if FTemOrificio then
        begin
        if FOrif_CD <= 0 then
           begin
           DialogoDeErros.Add(etError,
             Format('Objeto: %s'#13'Coeficiente de Descarga do Orifício Inválido: %f', [Nome, FOrif_CD]));
           TudoOk := False;
           end;

        if FOrif_A <= 0 then
           begin
           DialogoDeErros.Add(etError,
             Format('Objeto: %s'#13'Altura do Orifício Inválida: %f', [Nome, FOrif_A]));
           TudoOk := False;
           end;

        if FOrif_C < 0 then
           begin
           DialogoDeErros.Add(etError,
             Format('Objeto: %s'#13'Cota do Orifício Inválida: %f', [Nome, FOrif_C]));
           TudoOk := False;
           end;
        end;

     if FVZO_Max_Bypass < 0 then
        begin
        DialogoDeErros.Add(etError,
          Format('Objeto: %s'#13'Vazão do py-pass inválida: %f', [Nome, FVZO_Max_Bypass]));
        TudoOk := False;
        end;
     end;

  if FSaidaPor_EE then
     if self.FEE.NumEstruturas = 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'Número de Estruturas Extravazoras não pode ser 0', [Nome]));
        TudoOk := False;
        end;

  if FTCV_Tab.Len = 0 then
     begin
     DialogoDeErros.Add(etError, Format('Objeto: %s'#13'Tabela Cota-Volume inválida', [Nome]));
     TudoOk := False;
     end;
end;

function Tiphs1_PCR.PossuiObjetosConectados: Boolean;
begin
  Result := (SubBacias > 0);
end;

procedure Tiphs1_PCR.CopiarPara(HC: THidroObjeto);
begin
  inherited CopiarPara(HC);

  with Tiphs1_PCR(HC) do
    begin
    FAI := self.FAI;

    // Vertedor
    FVert_CD := self.FVert_CD;
    FVert_L  := self.FVert_L;
    FVert_CC := self.FVert_CC;

    // Orificio
    FOrif_CD := self.FOrif_CD;
    FOrif_A  := self.FOrif_A;
    FOrif_C  := self.FOrif_C;

    // NO = 0
    FSaidaPor_VO    := self.FSaidaPor_VO;
    FTemVertedor    := self.FTemVertedor;
    FTemOrificio    := self.FTemOrificio;
    FVZO_Max_Bypass := self.FVZO_Max_Bypass;

    // NO > 0
    FSaidaPor_EE := self.FSaidaPor_EE;
    FEE.Associar(self.FEE);

    // Tabela Cota-Volume
    FTCV_CMR := self.FTCV_CMR;
    FTCV_Tab.Assign(self.FTCV_Tab);
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

procedure Tiphs1_PCR.PrepararParaSimulacao;
begin
  inherited;
  FCotas.Free;
  FCotas := TwsDataSet.CreateFix('Cotas', Tiphs1_Projeto(Projeto).NIT,
            [dtNumeric, dtNumeric, dtNumeric, dtNumeric, dtNumeric]);
  FCotas.ColName[1] := 'Cota';
  FCotas.ColName[2] := 'Q_Vert';
  FCotas.ColName[3] := 'Q_Orif';
  FCotas.ColName[4] := 'Q_Bypass';
  FCotas.ColName[5] := 'Q_Total';
  FCotas.Fill(0);
end;

procedure Tiphs1_PCR.MostrarCotas();
var p: TSpreadSheetBook;
    x: integer;
    n: integer;
    b: boolean;
begin
  if FCotas <> nil then
     try
       StartWait();
       p := TSpreadSheetBook.Create('', 'Cotas e Vazôes');
       p.Caption := Projeto.Nome + ': ' + Nome + ' - ' + 'Cotas e Vazôes';
       FCotas.ShowInSheet(p);
       n := FCotas.nRows + 3;

       with p.ActiveSheet do
         begin
         BoldRow(n);
         Write(n, 1, 'Máximos');
         Write(n, 2, wsMatrixMax(FCotas, 1, 1, FCotas.nRows, b));
         Write(n, 3, wsMatrixMax(FCotas, 2, 1, FCotas.nRows, b));
         Write(n, 4, wsMatrixMax(FCotas, 3, 1, FCotas.nRows, b));
         Write(n, 5, wsMatrixMax(FCotas, 4, 1, FCotas.nRows, b));
         Write(n, 6, wsMatrixMax(FCotas, 5, 1, FCotas.nRows, b));
         end;

       p.Show(fsMDIChild);
     finally
       StopWait();
     end;
end;

procedure Tiphs1_PCR.PlotarCotas();
begin
  if FCotas = nil then Exit;
  TGrafico_Res_Cota_X_Vazao.Create(FCotas).Show();
end;

{ Tiphs1_SubBacia }

constructor Tiphs1_SubBacia.Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(Pos, Projeto, UmaTabelaDeNomes);

  FTP := tp50;
  FIR := True;

  FCoefs  := TTab1D.Create(0);
  FCL_Tab := TTab1D.Create(3);
  FHU_Tab := TTab1D.Create(3);

  IB.Oper := coTCV;
  FSE     := seSCS;
  FES     := esHU;
end;

destructor Tiphs1_SubBacia.Destroy();
begin
  // Avisa que vai ser eliminado
  // Dependencias com trecho-Dagua e PCs
  GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

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

    WriteBool    (Secao , 'IR'  , FIR  );
    WriteFloat   (Secao , 'AB'  , FAB  );
    WriteFloat   (Secao , 'TC'  , FTC  );
    WriteFloat   (Secao , 'TabT', FTabT);
    WriteString  (Secao , 'H'   , FH   );

    WriteInteger (Secao , 'Tipo', Ord(FTipo));
    WriteInteger (Secao , 'ES'  , Ord(FES)  );
    WriteInteger (Secao , 'SE'  , Ord(FSE)  );
    WriteInteger (Secao , 'TP'  , Ord(FTP)  );

    FCoefs.SaveToFile(Arquivo, Secao, 'Coefs');
    end;
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
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var s1: String;
    NIT, NITC: Integer;
    v : TwsSFVec;
begin
  Inherited;

  NIT  := Tiphs1_Projeto(Projeto).NIT;
  NITC := Tiphs1_Projeto(Projeto).NITC;

  if NITC = 0 then
     if FTipo = sbTCV then
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
                   Format('Projeto: %s'#13 +
                          'Número de Valores (%d) encontrado no arquivo do Hidrograma.'#13 +
                          '%s'#13 +
                          'não pode ser diferente do Número de Intervalos de Tempo do Projeto (%d)'
                          ,[Nome, v.Len, FH, NIT]));
                   TudoOk := False;
                   end;
                end;
        finally
          v.Free;
        end;

  if FTipo = sbTCV then
     begin
     if FAB <= 0 then
        begin
        DialogoDeErros.Add(etError,
        Format(LanguageManager.GetMessage(cMesID_IPH, 14)
              {'Objeto: %s'#13'Área inválida: %f'}, [Nome, FAB]));
        TudoOk := False;
        end;

     if FTC <= 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'Tempo de Concentração inválido: %f',
               [Nome, FTC]));
        TudoOk := False;
        end;

     if (FSE = seSCS) and ((FSCS_CN <= 0) or (FSCS_CN > 100)) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Curva Número Inválida: %f', [Nome, FSCS_CN]));
        TudoOk := False;
        end;

     if (FSE = seIPHII) then
        begin
        if (FIP_IO <= 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro IO Inválido: %f', [Nome, FIP_IO]));
           TudoOk := False;
           end;

        if (FIP_IB <= 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro IB Inválido: %f', [Nome, FIP_IB]));
           TudoOk := False;
           end;

        if (FIP_H <= 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro H Inválido: %f', [Nome, FIP_H]));
           TudoOk := False;
           end;

        if (FIP_RMAX <= 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro RMAX Inválido: %f', [Nome, FIP_RMAX]));
           TudoOk := False;
           end;

        if (FIP_PAI < 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + '%% da Área Impermeável Inválida: %f', [Nome, FIP_PAI]));
           TudoOk := False;
           end;

        if (FIP_VB < 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Vazão de Base Específica Inválida: %f', [Nome, FIP_VB]));
           TudoOk := False;
           end;
        end;

     if (FSE = seFI) then
        begin
        if (FFI_PI < 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Perda Inicial: %f', [Nome, FFI_PI]));
           TudoOk := False;
           end;

        if (FFI_I <= 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Índice Ø Inválido: %f', [Nome, FFI_I]));
           TudoOk := False;
           end;
        end;

     if (FES = esCLARK) then
        begin
        if (FCL_KS < 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro KS Inválido: %f', [Nome, FCL_KS]));
           TudoOk := False;
           end;

        if (FCL_KS = 0) and (FCL_DB <= 0) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Declividade da Bacia Inválida: %f', [Nome, FCL_DB]));
           TudoOk := False;
           end;

        if (FCL_XN > 2) then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro XN Inválido: %f', [Nome, FCL_XN]));
           TudoOk := False;
           end
        else
           if (FCL_XN < 1) and (FCL_NPT = 0) then
              begin
              DialogoDeErros.Add(etError,
              Format('Objeto: %s'#13 +
                     'CLARK: Histograma não definido.'#13 +
                     'XN = %f  e  Núm. de Pontos do Histograma = 0', [Nome, FCL_XN]));
              TudoOk := False;
              end
        end;

     if (FES = esHU) and (FHU_NPT <= 0) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Número de Pontos do HU ter que ser maior que 0', [Nome]));
        TudoOk := False;
        end;
{
     if (FES = esHT) and (FHT_DB <= 0) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Declividade da Bacia: %f', [Nome, FHT_DB]));
        TudoOk := False;
        end;
}
     if (FSE = seHEC1) then
        begin
        if FHEC_VI < 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Valor Inicial do Coeficiente de Perdas inválido: %f', [Nome, FHEC_VI]));
           TudoOk := False;
           end;

        if FHEC_LP <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Lâmina de Precipitação inválida: %f', [Nome, FHEC_LP]));
           TudoOk := False;
           end;

        if FHEC_PD <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro de Declividade do Graf. Semi-Log inválido: %f', [Nome, FHEC_PD]));
           TudoOk := False;
           end;

        if FHEC_EI <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Expoente da Internsidade da Precipitação inválido: %f', [Nome, FHEC_EI]));
           TudoOk := False;
           end;
        end;

     if (FSE = seHOLTAN) then
        begin
        if FHO_EI < 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Estado Inicial do Reservatório de Umidade inválido: %f', [Nome, FHO_EI]));
           TudoOk := False;
           end;

        if FHO_EE <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Expoente Empírico inválido: %f', [Nome, FHO_EE]));
           TudoOk := False;
           end;

        if FHO_IB <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Infiltração de Base inválida: %f', [Nome, FHO_IB]));
           TudoOk := False;
           end;

        if FHO_CI <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Cap. de Infiltração Inicial inválida: %f', [Nome, FHO_CI]));
           TudoOk := False;
           end;
        end;

     if (FES = esHYMO) then
        begin
        if FHY_RR <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'HYMO: Retardo do Reservatório Nash inválido: %f', [Nome, FHY_RR]));
           TudoOk := False;
           end;

        if FHY_TP <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'HYMO: Tempo de Pico inválido: %f', [Nome, FHY_TP]));
           TudoOk := False;
           end;

        // Se informou o tempo de concentração:
        if (FTC = 0) then
           begin
           if FHY_DN <= 0 then
              begin
              DialogoDeErros.Add(etError,
              Format('Objeto: %s'#13 + 'HYMO: Diferença de Nível da Sub-Bacia inválido: %f', [Nome, FHY_DN]));
              TudoOk := False;
              end;

           if FHY_CC <= 0 then
              begin
              DialogoDeErros.Add(etError,
              Format('Objeto: %s'#13 + 'HYMO: Comprimento do Canal Principal inválido: %f', [Nome, FHY_CC]));
              TudoOk := False;
              end;
           end;
        end;

     if FPEB then
        begin
        if FPEB_PR <= 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Parâmetro do Reservatório Linear Simples inválido: %f', [Nome, FPEB_PR]));
           TudoOk := False;
           end;

        if FPEB_VB < 0 then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 + 'Vazão Base Inicial inválida: %f', [Nome, FPEB_VB]));
           TudoOk := False;
           end;
        end;
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

    byte(FTipo) := ReadInteger (Secao , 'Tipo', 0);
    byte(FES)   := ReadInteger (Secao , 'ES'  , 0);
    byte(FSE)   := ReadInteger (Secao , 'SE'  , 1);
    byte(FTP)   := ReadInteger (Secao , 'TP'  , 0);

    FCoefs.LoadFromFile(Ini, Secao, 'Coefs');
    end;
end;

procedure Tiphs1_SubBacia.Copiar(SB: Tiphs1_SubBacia);
begin
  Projeto  := SB.Projeto;
  IB.Oper  := SB.IB.Oper;

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
  FH        :=  SB.FH;
  FES       :=  SB.FES;
  FSE       :=  SB.FSE;
  FTipo     :=  SB.FTipo;

  FCoefs.Assign(SB.FCoefs);
end;

procedure Tiphs1_SubBacia.PrepararParaSimulacao();
var i: Integer;
begin
  inherited;
  FreeAndNil(FTabPrecip);
  if IB.Oper = coTCV then
     begin
     FTabPrecip := TwsDataSet.CreateFix('Dados', Tiphs1_Projeto(Projeto).NITC,
                   [dtNumeric, dtNumeric, dtNumeric]);
     FTabPrecip.ColName[1] := 'Total';
     FTabPrecip.ColName[2] := 'Perdas';
     FTabPrecip.ColName[3] := 'Efetiva';
     FTabPrecip.Fill(0);
     end;
end;

procedure Tiphs1_SubBacia.MostrarTabPrecipitacao();
var p: TSpreadSheetBook;
    x: integer;
    n: integer;
    b: boolean;
begin
  if (IB.Oper = coTCV) and (FTabPrecip <> nil) then
     try
       StartWait();

       p := TSpreadSheetBook.Create('', 'Precipitações');
       p.Caption := Projeto.Nome + ': ' + Nome + ' - ' +
                    LanguageManager.GetMessage(cMesID_IPH, 16); {'Tabela de Precipitações'}

       FTabPrecip.ShowInSheet(p);
       n := FTabPrecip.nRows + 3;

       with p.ActiveSheet do
         begin
         BoldRow(n);
         Write(n, 1, LanguageManager.GetMessage(cMesID_IPH, 17) {'Total'});
         Write(n, 2, wsMatrixSum(FTabPrecip, 1, 1, FTabPrecip.nRows, x, b));
         Write(n, 3, wsMatrixSum(FTabPrecip, 2, 1, FTabPrecip.nRows, x, b));
         Write(n, 4, wsMatrixSum(FTabPrecip, 3, 1, FTabPrecip.nRows, x, b));
         end;
       p.Show(fsMDIChild);
     finally
       StopWait();
     end;
end;

procedure Tiphs1_SubBacia.PlotarHidrogramaResultante();
var CExHR : TGrafico_CExHR;
    G     : TfoSheetChart;
begin
  if HidroRes = nil then Exit;

  if (IB.Oper = coTCV) then
     begin
     CExHR := TGrafico_CExHR.Create(TabPrecip, HidroRes, IB.DadosObs);
     CExHR.Caption := Projeto.Nome + ': ' + Nome + ' - ' +
                      LanguageManager.GetMessage(cMesID_IPH, 18); //'Chuva Efetiva X Hidrograma Resultante'
     CExHR.FormStyle := fsMDIChild;
     end
  else
     begin
     G := TfoSheetChart.Create(Nome);
     G.Caption := Projeto.Nome + ': ' + Nome + ' - ' +
                  LanguageManager.GetMessage(cMesID_IPH, 19); //'Hidrograma Resultante (m³/s)'
     G.Width := 400;
     G.cb3D.Checked := False;
     G.Chart.BottomAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 20);//'Intervalos (n. Delta T)'
     G.Series.AddLineSerie('Qs (m³/s)', clRED, HidroRes);
     if IB.DadosObs <> nil then
        G.Series.AddLineSerie('Dados Obs. (m³/s)', clBLUE, IB.DadosObs);
     G.Show(fsMDIChild);
     end;
end;

procedure Tiphs1_SubBacia.PlotarGrafico_Perdas_X_Efetiva;
var G: TfoSheetChart;
    s1, s2: TBarSeries;
    i: Integer;
begin
  G := TfoSheetChart.Create(Nome);
  G.Caption := Projeto.Nome + ': ' + Nome + ' - ' + LanguageManager.GetMessage(cMesID_IPH, 21); //'Perdas X Prec.Efetiva';
  G.Chart.BottomAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 22); //'Intervalos (n. Delta T)';
  G.Width := 400;

  s1 := G.Series.addBarSerie(LanguageManager.GetMessage(cMesID_IPH, 23){'Perdas (mm)'}, clRED, 0, 2);
  s2 := G.Series.addBarSerie(LanguageManager.GetMessage(cMesID_IPH, 24){'Pe (mm)'}, clBLUE, 0, 2);

  for i := 1 to TabPrecip.nRows do
    begin
    s1.Add(TabPrecip[i, 2]);
    s2.Add(TabPrecip[i, 3]);
    end;

  G.Show(fsMDIChild);
end;

procedure Tiphs1_SubBacia.PlotarTabelaDePrecipitacoes;
var G: TfoSheetChart;
    s1, s2, s3, s4: TBarSeries;
    i: Integer;
begin
  G := TfoSheetChart.Create(Nome);
  g.Caption := Projeto.Nome + ': ' + Nome + ' - ' + LanguageManager.GetMessage(cMesID_IPH, 25); //'Precipitação';
  G.Width := 400;

  G.Chart.Title.Text.Add(LanguageManager.GetMessage(cMesID_IPH, 26){'P = Pe + Perdas'});
  G.Chart.LeftAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 27); //'Precipitação (mm)';
  G.Chart.BottomAxis.Title.Caption := LanguageManager.GetMessage(cMesID_IPH, 28); //'Intervalos (n. Delta T)';

  s3 := G.Series.addBarSerie(LanguageManager.GetMessage(cMesID_IPH, 29){'Perdas (mm)'}, clYELLOW, 0, 2);
  s4 := G.Series.addBarSerie(LanguageManager.GetMessage(cMesID_IPH, 30){'Pe (mm)'}, clLIME, 0, 2);

  for i := 1 to TabPrecip.nRows do
    begin
    s3.Add(TabPrecip[i, 2]);
    s4.Add(TabPrecip[i, 3]);
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
    FCoefs.Assign(self.FCoefs);
    end;
end;

procedure Tiphs1_SubBacia.setHU_NPT(const Value: byte);
begin
  FHU_NPT := Value;
  FHU_Tab.Len := FHU_NPT;
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
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var i, i1, i2, k : Integer;
    r1: Real;
    Postos: TStrings;
    v: TwsVec;
    Arquivo: String;
    L: TList;
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

   // Postos de chuva nao sao necessarios se nao houverem operacoes Chuva-vazao
   if (Postos.Count = 0) then
      begin
      // Verifica se existe pelo menos uma operação Chuva-Vazão
      L := ObtemSubBacias();
      for k := 0 to L.Count-1 do
        if Tiphs1_SubBacia(L[k]).Tipo = sbTCV then
           begin
           DialogoDeErros.Add(etError, Format(
             'É necessário pelo menos um posto de chuva pois'#13 +
             'existe pelo menos uma operação de Transformação Chuva-Vazão.', [Nome]));
           TudoOk := False;
           break;
           end;
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
          Arquivo := System.Copy(Postos[i], 1, System.Pos(' : ', Postos[i])-1);
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
                if i2 <> v.Len then
                   begin
                   DialogoDeErros.Add(etError,
                   Format('Projeto: %s'#13 +
                          'Número de Intervalos de Tempo com Chuva (%d) não pode ser diferente do'#13 +
                          'Número de Valores (%d) encontrados no arquivo.'#13 +
                          '%s', [Nome, i2, v.Len, Arquivo]));
                   TudoOk := False;
                   end;
                end;
          end; // for
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

  // Add Vector
  procedure AV (v: TV);
  var i, k: Integer;
      s: String;
  begin
    if v = nil then
       raise Exception.Create('PrepararCarta().AV(): Vetor Nulo');

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
  end;

  // Add File
  procedure AF (NomeArq: String);
  var v: TV;
  begin
    if not VerificaCaminho(NomeArq) then Exit;
    v := TV.Create(0);
    try
      v.LoadFromTextFile(NomeArq);
      AV(v);
    finally
      v.Free();
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
       if SB.Tipo = sbHidrograma then i := 0 else i := 1;
       end
    else
       begin
       SB := nil;
       i := 0;
       end;

    // Cálculo do Número do Hidrograma de Saída
    inc(HS);
    HC.IB.NHP := 0;
    HC.IB.NHE := ObtemNHE(HC, SH);
    HC.IB.NHS := HS;

    // Cartão F.
    AIL([Ord(HC.IB.Oper), i, HC.IB.GHC, HC.IB.ITH, HS, HC.IB.NHE, HC.IB.PDO, HC.IB.VC]);

    // Cartão G
    if SB <> nil then
       if (SB.IB.Oper = coTCV) or ((SB.IB.Oper = coH) and SB.IB.GHC) then
          AIL([0.0, 0.0, 0.0]) 
       else
          // não escreve o cartão G
    else
       AIL([HC.IB.VMax, HC.IB.VMin]);

    // Cartão H
    if HC.IB.PDO then AV( HC.IB.LerDadosObs() );
  end;

  procedure ProcessarSubBacia(SB: Tiphs1_SubBacia);

    procedure PostosDeChuva_e_Coefs(const Coefs: TTab1D);
    var s: String;
        i: Integer;
        k: Integer;
    begin
      SB.Coefs.Len := Tiphs1_Projeto(SB.Projeto).PChuva.Count;

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
         if SB.Coefs[i] > 0.0001 then inc(k);
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
  var NO, i: Integer;
  begin
    if R.SaidaPor_VO then NO := 0 else NO := R.EE.NumEstruturas;

    // Linha A1
    AIL([NO, R.AI, R.TCV_CMR, R.TCV_Tab.Len]);

    // Linhas A2
    for i := 0 to R.TCV_Tab.Len-1 do
      AIL([R.TCV_Tab[i].x, R.TCV_Tab[i].y]);

    // Linhas A3 e A4
    if NO > 0 then
       begin
       for i := 0 to R.EE.NumEstruturas-1 do
         begin
         AIL([R.EE[i].Tab.Len, R.EE[i].IT]);  // Linha A3
         R.EE[i].Tab.ToStrings(SL, 1, 10);    // Linha A4
         end;
       end
    else
       begin
       AIL([R.TemVertedor, R.TemOrificio, R.VZO_Max_Bypass]);

       // Linha A4
       if R.TemVertedor then
          AIL([R.Vert_CD, R.Vert_L, R.Vert_CC]);

       // Linha A5
       if R.TemOrificio then
          AIL([R.Orif_CD, R.Orif_A, R.Orif_C]);
       end;
  end;

  procedure PERio(TD: Tiphs1_TrechoDagua);
  var i   : Integer;
      VR  : Real;
      NST : Integer;
      ITC : Integer;
      _IS : Real;
  begin
    case TD.MPE of
      mpeKX  : begin
               // Cartão P
               AIL([Ord(TD.MPE) + 1, TD.NPT_KX, TD.CFM, TD.CFJ, TD.AC]);
               for i := 0 to TD.NPT_KX-1 do
                  AIL([TD.Tab_KX[i].x, TD.Tab_KX[i].y, TD.Tab_KX[i].z]);
               end;

      mpeCL,
      mpeCNL,
      mpeCPI : begin
               if TD.VR_auto  then  VR := 0 else  VR := TD.VR;
               if TD.NST_auto then NST := 0 else NST := TD.NST;
               if TD.ITC_auto then ITC := 0 else ITC := TD.ITC;

               AIL([Ord(TD.MPE) + 1]);
               if (TD.MPE <> mpeCNL) then AIL([VR]); // Cartão Q
               AIL([TD.LC, TD.AC, TD.CTP, TD.CFM, TD.CFJ, ITC, NST, TD.RST, TD.NHCL]); // Linha B4 ou B6
               if TD.MPE = mpeCPI then
                  AIL([TD.LPI, TD.RPI, TD.API]);
               end;

      mpeCF  : begin
               if TD.CF_DG_VR_auto then  VR := 0 else  VR := TD.CF_DG_VR;
               if TD.CF_DG_ST_auto then NST := 0 else NST := TD.CF_DG_ST;
               if TD.CF_DG_IS_auto then _IS := 0 else _IS := TD.CF_DG_IS;

               // linha B1
               AIL([Ord(TD.MPE) + 1, Length(TD.CF_TPs) + 1{T.Princ}]);

               // linha B8
               AIL([VR, TD.CF_DG_TE]);

               // linha B9
               // se tipo de excesso = Ampliar Dim. e Tipo da Secao da Secao de Ref <> 2
               if (TD.CF_DG_TE = 1) and (TD.CF_TPs[TD.CF_DG_Ex_AD_SR].TS <> 2) then
                  AIL([TD.CF_DG_Ex_AD_SR, TD.CF_DG_Ex_AD_L, TD.CF_DG_Ex_AD_A, TD.CF_DG_Ex_AD_DE, TD.CF_DG_Ex_AD_DD])
               else
                  if TD.CF_DG_TE = 2 then
                     AIL([TD.CF_DG_Ex_RR]);

               // linha B10
               with TD.CF_TPrinc do
                 AIL([TS, AD, L, DE, DD, R, TD.CF_DG_LT, TD.CF_DG_CFM, TD.CF_DG_CFJ, _IS, NST, TD.NHCL]);

               // linhas B11
               for i := 0 to High(TD.CF_TPs) do
                 with TD.CF_TPs[i] do
                   AIL([TS, AD, L, DE, DD, R]);
               end;
    end;
  end;

  procedure Derivacao(DE: Tiphs1_Derivacao; TD: Tiphs1_TrechoDagua);
  begin
    // Cartão T1
    if DE.IB.Oper = coDer then
          AIL([DE.CDL, DE.CDR, DE.CDD, DE.CPL, DE.CPR, DE.CPD])
    else
       AIL([DE.Percentagem / 100]);
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

var s, s2   : String;
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
    subStrings(':', s, s2, PChuva[i]);
    s := AllTrim(s); // Nome do Arquivo
    s2 := AllTrim(s2); // Código de Tormenta - 1 ou 2
    if s2 = 'Tormenta Desagregada' then k := 1 else k := 2;
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
         if TD.SubBacia <> nil then
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

function Tiphs1_Projeto.LerResultados(const ArqErr, Dir: String): Boolean;
var SL, SL2: TStrings;
    L : Integer;

    procedure Erro(const Msg: String);
    begin
      Raise Exception.Create(Msg);
    end;

    procedure LerHidrogramas(const Arquivo: String);
    var L, Oper, i, k: Integer;
        HC: THidroComponente;
    begin
      SL.LoadFromFile(Arquivo);
      L := 0;
      While Locate('ophid', SL, L) do
        begin
        Oper := toInt(SL[L], 7, 4, true, -1);
        if Oper > -1 then
           begin
           HC := ObterObjetoPelaOperacao(Oper);
           if HC <> nil then
              begin
              k := 1;
              for i := L+1 to L+FNIT do
                begin
                HC.HidroRes[k] := StrToFloatDef(AllTrim(SL[i]), wscMissValue);
                inc(k);
                end;
              end;
           end;
        inc(L, FNIT);
        end;
    end;

    procedure LerVazoesControladas(const Arquivo: String);
    var L, Oper, i, k: Integer;
        c: THidroComponente;
    begin
      SL.LoadFromFile(Arquivo);
      if SL.Count < 5 then Exit;

      // Número de operações existentes no arquivo
      i := (SL.Count - 1) div 9;

      // Para cada Operação
      L := 1;
      for k := 1 to i do
        begin
        Oper := toInt(SL[L], 1, 8, true, -1);
        c := ObterObjetoPelaOperacao(Oper);
        if c <> nil then
           for i := 1 to 9 do
             begin
             c.VazaoCont[i, 1] := toFloat(SL[L], 09, 12, true, 0);
             c.VazaoCont[i, 2] := toFloat(SL[L], 24, 12, true, 0);
             c.VazaoCont[i, 3] := toFloat(SL[L], 39, 12, true, 0);
             c.VazaoCont[i, 4] := toFloat(SL[L], 54, 12, true, 0);
             inc(L);
             end
        else
           inc(L, 9);
        end;
    end;

    procedure LerPrecipitacoes(const Arquivo: String);
    var L, Oper, i, k: Integer;
        SB: Tiphs1_SubBacia;
    begin
      SL.LoadFromFile(Arquivo);
      L := 0;
      While Locate('ophid', SL, L) do
        begin
        Oper := toInt(SL[L], 7, 4, true, -1);
        if Oper > -1 then
           begin
           SB := Tiphs1_SubBacia(ObterObjetoPelaOperacao(Oper));
           if SB <> nil then
              begin
              k := 1;
              for i := L+1 to L+FNITC do
                begin
                SB.TabPrecip[k, 3] := toFloat(SL[i], 1, 10, true, wscMissValue); // Efetiva
                SB.TabPrecip[k, 1] := toFloat(SL[i], 11, 10, true, wscMissValue); // Total
                SB.TabPrecip[k, 2] := SB.TabPrecip[k, 1] - SB.TabPrecip[k, 3]; // Perdas
                inc(k);
                end;
              end;
           end;
        inc(L, FNITC);
        end;
    end;

    procedure LerQRua(const Arquivo: String);
    var L, Oper, i, k: Integer;
        TD: Tiphs1_TrechoDagua;
    begin
      SL.LoadFromFile(Arquivo);
      L := 0;
      While Locate('ophid', SL, L) do
        begin
        Oper := toInt(SL[L], 7, 4, true, -1);
        if Oper > -1 then
           begin
           TD := Tiphs1_TrechoDagua(ObterObjetoPelaOperacao(Oper));
           if TD <> nil then
              begin
              TD.TemQRua := True;
              k := 1;
              for i := L+1 to L+FNIT do
                begin
                TD.QRua[k] := toFloat(SL[i], 11, 10, true, wscMissValue);
                inc(k);
                end;
              end;
           end;
        inc(L, FNIT);
        end;
    end;

    procedure LerCotasRes(const Arquivo: String);
    var L, Oper, i, k: Integer;
        R: Tiphs1_PCR;
        s: String;
    begin
      SL.LoadFromFile(Arquivo);
      L := 0;
      While Locate('Operacao hidrologica', SL, L) do
        begin
        Oper := toInt(SL[L], 23, 5, true, -1);
        if Oper > -1 then
           begin
           R := Tiphs1_PCR(ObterObjetoPelaOperacao(Oper));
           if R <> nil then
              begin
              k := 1;
              for i := L+1 to L+FNIT do
                begin
                s := SL[i];
                R.Cotas[k, 1] := toFloat(s, 12, 9, true, 0); // cota
                R.Cotas[k, 2] := toFloat(s, 22, 9, true, 0); // vert
                R.Cotas[k, 3] := toFloat(s, 32, 9, true, 0); // orif
                R.Cotas[k, 4] := toFloat(s, 42, 9, true, 0); // bypass
                R.Cotas[k, 5] := toFloat(s, 52, 9, true, 0); // Q.Total
                inc(k);
                end;
              end;
           end;
        inc(L, FNIT);
        end;
    end;

    procedure LerCotasTD(const Arquivo: String);
    var L, Oper, i, k: Integer;
        TD: Tiphs1_TrechoDagua;
    begin
      SL.LoadFromFile(Arquivo);
      L := 0;
      While Locate('ophid', SL, L) do
        begin
        Oper := toInt(SL[L], 7, 4, true, -1);
        if Oper > -1 then
           begin
           TD := Tiphs1_TrechoDagua(ObterObjetoPelaOperacao(Oper));
           if TD <> nil then
              begin
              k := 1;
              for i := L+1 to L+FNIT do
                begin
                TD.Cotas[k] := StrToFloatDef(AllTrim(SL[i]), wsConstTypes.wscMissValue);
                inc(k);
                end;
              end;
           end;
        inc(L, FNIT);
        end;
    end;

    procedure LerAlagamentos(const Arquivo: String);
    var L, Oper, i, k: Integer;
        TD: Tiphs1_TrechoDagua;
    begin
      SL.LoadFromFile(Arquivo);
      L := 0;
      for L := 1 to SL.Count-1 do
        begin
        Oper := toInt(SL[L], 8, 3, true, -1);
        if Oper > -1 then
           begin
           TD := Tiphs1_TrechoDagua(ObterObjetoPelaOperacao(Oper));
           if TD <> nil then
              begin
              TD.Alagamento_Volume  := toFloat(SL[L], 11, 10, true, -1);
              TD.Alagamento_Duracao := toFloat(SL[L], 21, 10, true, -1);
              end;
           end;
        end;
    end;

begin
  Result := False;

  SL  := TStringList.Create;
  SL2 := TStringList.Create;
  try
    if FileExists(ArqErr) then
       begin
       SL.LoadFromFile(ArqErr);
       if SL[0] {Num. op. totais} = SL[1] {Última op. realizada} then
          begin
          // Todas as Operações
          LerHidrogramas(Dir + 'hidrograma.iph');
          LerVazoesControladas(Dir + 'vazao cont.iph');

          // Sub-Bacias
          LerPrecipitacoes(Dir + 'precipit.iph');

          // Reservatórios
          LerCotasRes(Dir + 'reservatorio.iph');

          // Trecho-Dagua
          LerQRua(Dir + 'QRua.iph');
          LerCotasTD(Dir + 'cotas.iph');
          LerAlagamentos(Dir + 'alagamento.iph');

          Result := True;
          Dialogs.ShowMessage(LanguageManager.GetMessage(cMesID_IPH, 39){'Simulação concluída. Verifique a saída'});
          end
       else
          Dialogs.ShowMessage(LanguageManager.GetMessage(cMesID_IPH, 40)
                             {'Erro na Simulação.'#13#10 +
                              'Última operação realizada: '} + AllTrim(SL[2]) + ' (' + AllTrim(SL[1]) + ')');
       end
    else
       Dialogs.ShowMessage('Arquivo de Erro não encontrado.'#13 +
                           'Provavelmente um erro ocorreu durante a Simulação.');

  finally
    SL.Free;
    SL2.Free;
  end;
end;

procedure Tiphs1_Projeto.ExecutarSimulacao();
var SL: TStrings;
    Exec: TExecFile;
    s: String;
    Ent, Sai, Err: String;
    ds: Char;
    Book: TBook;
begin
  s := System.Copy(GetValidID(Nome), 1, 8); // O IPHS1 DOS exige que o nome tenha no máximo 8 caracteres
  SL := TStringList.Create;
  try
    DeleteFile(DirSai + '\' + s + '.sai');
    DeleteFile(gExePath + 'DOS\alagamento.iph');
    DeleteFile(gExePath + 'DOS\comentario.iph');
    DeleteFile(gExePath + 'DOS\cotas.iph');
    DeleteFile(gExePath + 'DOS\hidrograma.iph');
    DeleteFile(gExePath + 'DOS\precipit.iph');
    DeleteFile(gExePath + 'DOS\qrua.iph');
    DeleteFile(gExePath + 'DOS\reservatorio.iph');
    DeleteFile(gExePath + 'DOS\vazao cont.iph');

    ent := DirSai + '\' + s + '.ent';

    PCs.CalcularHierarquia;

    PrepararCarta(SL);

    try
      SL.SaveToFile(ent);
    except
      raise Exception.CreateFmt('Can not create file <%s>'#13 +
                                'Verify the file/folder attributies.', [ent]);
    end;

    // Só da para extrair a forma curta do nome de um arquivo existente
    ent := ExtractShortPathName(ent);
    sai := ChangeFileExt(ent, '.sai');
    err := ChangeFileExt(ent, '.err');

    // Caminho dos arquivos
    SL.Clear;
    SL.Add(ent);
    SL.Add(sai);
    SL.Add(err);
    SL.SaveToFile(gExePath + 'DOS\DRVPROY');

    SetCurrentDir(gExePath + 'DOS\');
    if FME = meDOS then
       try
         Exec := TExecFile.Create(nil);
         Exec.Wait := True;
         Exec.CommandLine := gExePath + 'DOS\IPHS1.EXE'; // gIPHS1_DOS

         ds := DecimalSeparator;
         DecimalSeparator := '.';

         if Exec.Execute() then
            begin
            Book := TBook.Create('Projeto: ' + Nome + ' - Horário da Simulação: ' + TimeToStr(Time), fsMDIChild);
            Book.CloseConfirmation := True;
            Book.SetCloseMessage('Após esta janela ser fechada, você somente poderá recuperar'#13 +
                                 'seu conteúdo simulando o Projeto novamente. Você deseja continuar ?');

            if FileExists(ent) then
               Book.NewPage('rtf', 'Entrada', ent);

            if LerResultados(err, gExePath + 'DOS\') then
               try
                 StartWait();
                 Book.NewPage('rtf', 'Saída', sai);
                 Book.NewPage('memo', 'QRua', gExePath + 'DOS\QRua.iph');
                 Book.NewPage('memo', 'Armazenamentos', gExePath + 'DOS\alagamento.iph');
                 Book.NewPage('memo', 'Comentários', gExePath + 'DOS\comentario.iph');
                 if PossuiAlagamentos then
                    Tiphs1_fo_TD_Alagamentos.Create(self);
               finally
                 StopWait()
               end;
            end
         else
            Dialogs.ShowMessage('Erro na Execução do IPHS1-DOS');

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

function Tiphs1_Projeto.CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TfoChart;
begin
  Result := TfoSheetChart.Create;
  Result.Chart.Title.Text.Add(Titulo);
end;

procedure Tiphs1_Projeto.DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);
begin
end;

procedure Tiphs1_Projeto.PrepararParaSimulacao();
var i: Integer;
begin
  inherited;
  FreeAndNil(FDadosPostos);
  if FPChuva.Count > 0 then
     begin
     FDadosPostos := TwsDataSet.Create('Dados_Postos'); 
     for i := 0 to FPChuva.Count-1 do
       FDadosPostos.Struct.AddNumeric('Posto_' + IntToStr(i+1), '');
     for i := 1 to FNITC do FDadosPostos.AddRow();
     FDadosPostos.Fill(0); // prepara e preenche a estrutura com zeros
     end;
end;

function Tiphs1_Projeto.PossuiAlagamentos(): Boolean;
var i: Integer;
    TD: Tiphs1_TrechoDagua;
begin
  for i := 0 to PCs.PCs-1 do
    if PCs[i].TrechoDagua <> nil then
       begin
       TD := Tiphs1_TrechoDagua(PCs[i].TrechoDagua);
       if TD.Alagamento_Duracao > 0 then
          begin
          Result := True;
          Exit;
          end;
       end;
  Result := False;
end;

procedure Tiphs1_Projeto.PercorreSubBacias(ITSB: TProcPSB);
var i, j: Integer;
    SB: TSubBacia;
    PC: TPC;
begin
  GetMessageManager.SendMessage(UM_RESET_VISIT, [0]);

  // Todos os PCs
  for i := 0 to PCs.PCs-1 do
    begin
    PC := PCs[i];

    // Todas as SBs de um PC
    for j := 0 to PC.SubBacias-1 do
      if not PC.SubBacia[j].Visitado then
         begin
         SB := PC.SubBacia[j];
         SB.Visitado := True;
         ITSB(Self, SB);
         end;

    // SB de um trecho-dagua de um PC
    if PC.TrechoDagua <> nil then
       if Tiphs1_TrechoDagua(PC.TrechoDagua).SubBacia <> nil then
          begin
          SB := Tiphs1_TrechoDagua(PC.TrechoDagua).SubBacia;
          SB.Visitado := True;
          ITSB(Self, SB);
          end;
    end;
end;

{ Tiphs1_TrechoDagua }

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
    FMPE := self.FMPE;

    FCTP  := self.FCTP;                     
    FCFM  := self.FCFM;                     
    FCFJ  := self.FCFJ;                     
    FAC   := self.FAC;                      
    FLC   := self.FLC;                      
    FRST  := self.FRST;                     
    FVR   := self.FVR;                      
    FNST  := self.FNST;                     
    FITC  := self.FITC;                     
                                            
    FVR_auto    := self.FVR_auto;           
    FNST_auto   := self.FNST_auto;          
    FITC_auto   := self.FITC_auto;          

    FAPI  := self.FAPI;
    FLPI  := self.FLPI;
    FRPI  := self.FRPI;

    FNPT_KX := self.FNPT_KX;
    FTab_KX.Assign(self.FTab_KX);

    { Conduto Fechado ------------------------------------------------------ }

    FCF_DG_VR       := self.FCF_DG_VR;
    FCF_DG_LT       := self.FCF_DG_LT;
    FCF_DG_CFM      := self.FCF_DG_CFM;
    FCF_DG_CFJ      := self.FCF_DG_CFJ;
    FCF_DG_IS       := self.FCF_DG_IS;
    FCF_DG_ST       := self.FCF_DG_ST;
    FCF_DG_TE       := self.FCF_DG_TE;
    FCF_DG_Ex_RR    := self.FCF_DG_Ex_RR;
    FCF_DG_Ex_AD_SR := self.FCF_DG_Ex_AD_SR;
    FCF_DG_Ex_AD_L  := self.FCF_DG_Ex_AD_L;
    FCF_DG_Ex_AD_A  := self.FCF_DG_Ex_AD_A;
    FCF_DG_Ex_AD_DE := self.FCF_DG_Ex_AD_DE;
    FCF_DG_Ex_AD_DD := self.FCF_DG_Ex_AD_DD;
    FCF_DG_VR_auto  := self.FCF_DG_VR_auto;
    FCF_DG_IS_auto  := self.FCF_DG_IS_auto;
    FCF_DG_ST_auto  := self.FCF_DG_ST_auto;

    // trechos Paralelos
    FCF_TPrinc := self.FCF_TPrinc;

    // trechos Paralelos
    FCF_TPs := System.Copy(self.FCF_TPs);
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

procedure Tiphs1_TrechoDagua.DesconectarObjetos();
begin
  FreeAndNil(FSB);
  inherited;
end;

destructor Tiphs1_TrechoDagua.Destroy();
begin
  FTab_KX.Free;
  FCotas.Free;
  FQRua.Free;
  DesconectarObjetos();
  inherited;
end;

procedure Tiphs1_TrechoDagua.LerDoArquivo(Ini: TIF; const Secao: String);
var i: Integer;
    s: String;
begin
  inherited;
  with Ini do
    begin
    byte(FMPE) := ReadInteger (Secao, 'MPE'  , 0);
    //FNHCL      := ReadInteger (Secao, 'NHCL' , 0);

    FCTP      := ReadFloat   (Secao, 'CTP'      , 0);
    FCFM      := ReadFloat   (Secao, 'CFM'      , 0);
    FCFJ      := ReadFloat   (Secao, 'CFJ'      , 0);
    FAC       := ReadFloat   (Secao, 'AC'       , 0);
    FLC       := ReadFloat   (Secao, 'LC'       , 0);
    FRST      := ReadFloat   (Secao, 'RST'      , 0);
    FVR       := ReadFloat   (Secao, 'VR'       , 0);
    FNST      := ReadInteger (Secao, 'NST'      , 0);
    FITC      := ReadInteger (Secao, 'ITC'      , 0);

    FVR_auto  := ReadBool (Secao, 'VR_auto'  , true);
    FNST_auto := ReadBool (Secao, 'NST_auto' , true);
    FITC_auto := ReadBool (Secao, 'ITC_auto' , true);

    if FMPE = mpeCNL then // <<<<< 2.06
       begin
       FNST_auto := false; // por enquanto !!!
       FITC_auto := false; // por enquanto !!!
       end;

    FAPI      := ReadFloat   (Secao, 'API' , 0);
    FLPI      := ReadFloat   (Secao, 'LPI' , 0);
    FRPI      := ReadFloat   (Secao, 'RPI' , 0);

    FCF_DG_VR_auto := ReadBool (Secao, 'CF_DG_VR_auto' , true);
    FCF_DG_IS_auto := ReadBool (Secao, 'CF_DG_IS_auto' , true);
    FCF_DG_ST_auto := ReadBool (Secao, 'CF_DG_ST_auto' , true);

    FNPT_KX := ReadInteger(Secao, 'NPT_KX', 0);
    FTab_KX.LoadFromFile(Ini, Secao, 'KX_Pontos');

    { Conduto Fechado ------------------------------------------------------ }

    // Dados Gerais
    FCF_DG_VR       := ReadFloat   (Secao, 'CF_DG_VR'      , 0);
    FCF_DG_TE       := ReadInteger (Secao, 'CF_DG_TE'      , 0);
    FCF_DG_Ex_RR    := ReadFloat   (Secao, 'CF_DG_Ex_RR'   , 0);
    FCF_DG_Ex_AD_SR := ReadInteger (Secao, 'CF_DG_Ex_AD_SR', 0);
    FCF_DG_Ex_AD_L  := ReadBool    (Secao, 'CF_DG_Ex_AD_L' , false);
    FCF_DG_Ex_AD_A  := ReadBool    (Secao, 'CF_DG_Ex_AD_A' , false);
    FCF_DG_Ex_AD_DE := ReadBool    (Secao, 'CF_DG_Ex_AD_DE', false);
    FCF_DG_Ex_AD_DD := ReadBool    (Secao, 'CF_DG_Ex_AD_DD', false);
    FCF_DG_LT       := ReadFloat   (Secao, 'CF_DG_LT'      , 0);
    FCF_DG_CFM      := ReadFloat   (Secao, 'CF_DG_CFM'     , 0);
    FCF_DG_CFJ      := ReadFloat   (Secao, 'CF_DG_CFJ'     , 0);
    FCF_DG_IS       := ReadFloat   (Secao, 'CF_DG_IS'      , 0);
    FCF_DG_ST       := ReadInteger (Secao, 'CF_DG_ST'      , 0);

    // Trecho Principal
    with FCF_TPrinc do
      begin
      TS := ReadInteger (Secao, 'CF_TPrinc_TS', 0);
      AD := ReadFloat   (Secao, 'CF_TPrinc_AD', 0);
      L  := ReadFloat   (Secao, 'CF_TPrinc_L' , 0);
      DE := ReadFloat   (Secao, 'CF_TPrinc_DE', 0);
      DD := ReadFloat   (Secao, 'CF_TPrinc_DD', 0);
      R  := ReadFloat   (Secao, 'CF_TPrinc_R' , 0);
      end;

    // Trechos Paralelos
    i := ReadInteger (Secao, 'TPs', 0);
    SetLength(FCF_TPs, i);
    for i := 0 to High(FCF_TPs) do
      with FCF_TPs[i] do
        begin
        s := IntToStr(i + 1);
        TS := ReadInteger (Secao, 'CF_TP_TS_' + s, 0);
        AD := ReadFloat   (Secao, 'CF_TP_AD_' + s, 0);
        L  := ReadFloat   (Secao, 'CF_TP_L_'  + s, 0);
        DE := ReadFloat   (Secao, 'CF_TP_DE_' + s, 0);
        DD := ReadFloat   (Secao, 'CF_TP_DD_' + s, 0);
        R  := ReadFloat   (Secao, 'CF_TP_R_'  + s, 0);
        end;
    end
end;

procedure Tiphs1_TrechoDagua.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_TD) do
    begin
    FRPI := DLG_MPE_CPI.edRPI.AsFloat;
    GetDados(FCTP, FCFM, FCFJ, FAC, FLC, FRST, FVR, FAPI, FLPI, FVR_auto, FNST_auto, FITC_auto,
             FITC, FNST, FNPT_KX, FTab_KX);

    if rbCL .Checked then
       FMPE := mpeCL
    else
    if rbCNL.Checked then
       FMPE := mpeCNL
    else
    if rbCPI.Checked then
       FMPE := mpeCPI
    else
    if rbKX.Checked then
       FMPE := mpeKX;

    if rbCF .Checked then
       begin
       FMPE := mpeCF;
       DLG_MPE_CF.GetDados(FCF_DG_VR, FCF_DG_TE, FCF_DG_Ex_RR, FCF_DG_Ex_AD_SR, FCF_DG_Ex_AD_L,
                           FCF_DG_Ex_AD_A, FCF_DG_Ex_AD_DE, FCF_DG_Ex_AD_DD, FCF_DG_LT, FCF_DG_CFM,
                           FCF_DG_CFJ, FCF_DG_IS, FCF_DG_ST,
                           FCF_DG_VR_auto, FCF_DG_IS_auto, FCF_DG_ST_auto, FCF_TPrinc, FCF_TPs);
       end;
    end;
end;

procedure Tiphs1_TrechoDagua.PlotarCotas();
var i : Integer;
    G : TfoSheetChart;
    s1: TLineSeries;
begin
  if FCotas = nil then Exit;

  G := TfoSheetChart.Create(Nome);
  G.Width := 400;
  G.Caption := Projeto.Nome + ': ' + Nome + ' - ' + 'Cotas';

  G.Chart.LeftAxis.Title.Caption := 'Cotas (m)';
  G.Chart.BottomAxis.Title.Caption := 'Intervalos (n. Delta T)';

  s1 := G.Series.AddLineSerie('Cotas', clRed);

  for i := 1 to FCotas.Len do
    s1.Add(FCotas[i]);

  G.Show(fsMDIChild);
end;

procedure Tiphs1_TrechoDagua.PlotarHidrogramasEm(G: TfoChart);
begin
  if FSB <> nil then
     G.Series.AddLineSerie('Qs ' + FSB.Nome + ' (m³/s)', clLIME, FSB.HidroRes);
end;

procedure Tiphs1_TrechoDagua.PlotarInformacoesExtras(G: TfoSheetChart);
begin
  inherited PlotarInformacoesExtras(G);
  if FTemQRua then
     G.Series.AddLineSerie('Q.Rua (m³/s)', clMaroon, FQRua);
end;

procedure Tiphs1_TrechoDagua.PlotarQRua;
var i : Integer;
    G : TfoSheetChart;
    s1: TLineSeries;
begin
  if FQRua = nil then Exit;

  G := TfoSheetChart.Create(Nome);
  G.Width := 400;
  G.Caption := Projeto.Nome + ': ' + Nome + ' - ' + 'Q.Rua';

  G.Chart.LeftAxis.Title.Caption := 'Q.Rua (m³/s)';
  G.Chart.BottomAxis.Title.Caption := 'Intervalos (n. Delta T)';

  s1 := G.Series.AddLineSerie('Q.Rua', clRed);

  for i := 1 to FQRua.Len do
    s1.Add(FQRua[i]);

  G.Show(fsMDIChild);
end;

procedure Tiphs1_TrechoDagua.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_TD) do
    begin
    DLG_MPE_CPI.edRPI.AsFloat := FRPI;
    SetDados(FCTP, FCFM, FCFJ, FAC, FLC, FRST, FVR, FAPI, FLPI, FVR_auto, FNST_auto, FITC_auto,
             FITC, FNST, FNPT_KX, FTab_KX);

    case FMPE of
      mpeCL  : rbCL .Checked := True;
      mpeCNL : rbCNL.Checked := True;
      mpeCPI : rbCPI.Checked := True;
      mpeKX  : rbKX .Checked := True;
      mpeCF  : begin
               rbCF .Checked := True;
               DLG_MPE_CF.SetDados(FCF_DG_VR, FCF_DG_TE, FCF_DG_Ex_RR, FCF_DG_Ex_AD_SR, FCF_DG_Ex_AD_L,
                                   FCF_DG_Ex_AD_A, FCF_DG_Ex_AD_DE, FCF_DG_Ex_AD_DD, FCF_DG_LT,
                                   FCF_DG_CFM, FCF_DG_CFJ, FCF_DG_IS, FCF_DG_ST,
                                   FCF_DG_VR_auto, FCF_DG_IS_auto, FCF_DG_ST_auto, FCF_TPrinc, FCF_TPs);
               end;
      end;
    end;
end;

procedure Tiphs1_TrechoDagua.PrepararParaSimulacao();
begin
  inherited;
  FQRua.Free;
  FQRua := TV.Create(Tiphs1_Projeto(Projeto).NIT);
  FQRua.Fill(0);

  FCotas.Free;
  FCotas := TV.Create(Tiphs1_Projeto(Projeto).NIT);
  FCotas.Fill(0);

  FTemQRua := False;

  Fal_Dur := 0;
  Fal_Vol := 0;
end;

function Tiphs1_TrechoDagua.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_OBJETO_SE_DESTRUINDO then
     if FSB = MSG.ParamAsObject(0) then
        begin
        FSB := nil;
        FNHCL := 0;
        end;

  inherited ReceiveMessage(MSG);
end;

procedure Tiphs1_TrechoDagua.SalvarEmArquivo(Arquivo: TIF);
var i: Integer;
    s: String;
begin
  inherited;
  with Arquivo do
    begin
    if FSB <> nil then
       WriteString(Secao, 'SubBacia', FSB.Nome);

    WriteInteger (Secao, 'MPE'  , Ord(FMPE));
    //WriteInteger (Secao, 'NHCL' , FNHCL);

    WriteFloat   (Secao, 'CTP'      , FCTP     );
    WriteFloat   (Secao, 'CFM'      , FCFM     );
    WriteFloat   (Secao, 'CFJ'      , FCFJ     );
    WriteFloat   (Secao, 'AC'       , FAC      );
    WriteFloat   (Secao, 'LC'       , FLC      );
    WriteFloat   (Secao, 'RST'      , FRST     );
    WriteFloat   (Secao, 'VR'       , FVR      );
    WriteInteger (Secao, 'NST'      , FNST     );
    WriteInteger (Secao, 'ITC'      , FITC     );
    WriteBool    (Secao, 'VR_auto'  , FVR_auto );
    WriteBool    (Secao, 'NST_auto' , FNST_auto);
    WriteBool    (Secao, 'ITC_auto' , FITC_auto);
    WriteFloat   (Secao, 'API'      , FAPI     );
    WriteFloat   (Secao, 'LPI'      , FLPI     );
    WriteFloat   (Secao, 'RPI'      , FRPI     );

    WriteInteger (Secao, 'NPT_KX', FNPT_KX);
    FTab_KX.SaveToFile(Arquivo, Secao, 'KX_Pontos');

    { Conduto Fechado ------------------------------------------------------ }

    // Dados Gerais
    WriteFloat   (Secao, 'CF_DG_VR'      , FCF_DG_VR);
    WriteInteger (Secao, 'CF_DG_TE'      , FCF_DG_TE);
    WriteFloat   (Secao, 'CF_DG_Ex_RR'   , FCF_DG_Ex_RR);
    WriteInteger (Secao, 'CF_DG_Ex_AD_SR', FCF_DG_Ex_AD_SR);
    WriteBool    (Secao, 'CF_DG_Ex_AD_L' , FCF_DG_Ex_AD_L);
    WriteBool    (Secao, 'CF_DG_Ex_AD_A' , FCF_DG_Ex_AD_A);
    WriteBool    (Secao, 'CF_DG_Ex_AD_DE', FCF_DG_Ex_AD_DE);
    WriteBool    (Secao, 'CF_DG_Ex_AD_DD', FCF_DG_Ex_AD_DD);
    WriteFloat   (Secao, 'CF_DG_LT',       FCF_DG_LT);
    WriteFloat   (Secao, 'CF_DG_CFM',      FCF_DG_CFM);
    WriteFloat   (Secao, 'CF_DG_CFJ',      FCF_DG_CFJ);
    WriteFloat   (Secao, 'CF_DG_IS',       FCF_DG_IS);
    WriteInteger (Secao, 'CF_DG_ST',       FCF_DG_ST);
    WriteBool    (Secao, 'CF_DG_VR_auto' , FCF_DG_VR_auto);
    WriteBool    (Secao, 'CF_DG_IS_auto' , FCF_DG_IS_auto);
    WriteBool    (Secao, 'CF_DG_ST_auto' , FCF_DG_ST_auto);

    // Trecho Principal
    with FCF_TPrinc do
      begin
      WriteInteger (Secao, 'CF_TPrinc_TS', TS);
      WriteFloat   (Secao, 'CF_TPrinc_AD', AD);
      WriteFloat   (Secao, 'CF_TPrinc_L' , L);
      WriteFloat   (Secao, 'CF_TPrinc_DE', DE);
      WriteFloat   (Secao, 'CF_TPrinc_DD', DD);
      WriteFloat   (Secao, 'CF_TPrinc_R' , R);
      end;

    // Trechos Paralelos
    WriteInteger (Secao, 'TPs', Length(FCF_TPs));
    for i := 0 to High(FCF_TPs) do
      with FCF_TPs[i] do
        begin
        s := IntToStr(i + 1);
        WriteInteger (Secao, 'CF_TP_TS_' + s, TS);
        WriteFloat   (Secao, 'CF_TP_AD_' + s, AD);
        WriteFloat   (Secao, 'CF_TP_L_'  + s, L );
        WriteFloat   (Secao, 'CF_TP_DE_' + s, DE);
        WriteFloat   (Secao, 'CF_TP_DD_' + s, DD);
        WriteFloat   (Secao, 'CF_TP_R_'  + s, R );
        end;
    end;
end;

procedure Tiphs1_TrechoDagua.ValidarDados(var TudoOk: Boolean; DialogoDeErros: TfoMessages; Completo: Boolean);

   procedure ValidarTrecho(const T: TRec_TD_CF_TP; i: integer);
   var s: String;
   begin
     if i = 0 then
        s := 'Trecho Principal'
     else
        s := 'Trecho Paralelo ' + toString(i);

     if (T.TS = 2 {circular}) and (T.AD <= 0) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'%s'#13'Diâmetro Circular Inválido: %f',
              [Nome, s, T.AD]));
        TudoOk := False;
        end;

     if (T.TS <> 2 {circular}) and (T.AD <= 0) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'%s'#13'Altura Inválida: %f',
              [Nome, s, T.AD]));
        TudoOk := False;
        end;

     if T.L < 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'%s'#13'Largura Inválida: %f',
              [Nome, s, T.AD]));
        TudoOk := False;
        end;

     if T.DE < 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'%s'#13'Talude Esquerdo Inválido: %f',
              [Nome, s, T.DE]));
        TudoOk := False;
        end;

     if T.DD < 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'%s'#13'Talude Direito Inválido: %f',
              [Nome, s, T.DD]));
        TudoOk := False;
        end;

     if T.R <= 0 then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'%s'#13'Rugosidade Inválida: %f',
              [Nome, s, T.R]));
        TudoOk := False;
        end;
   end;

var i: Integer;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  // Dados comuns aos três métodos
  case FMPE of
    mpeCL, mpeCNL, mpeCPI:
      begin
      if FCTP <= 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Comprimento do Trecho Inválido: %f', [Nome, FCTP]));
         TudoOk := False;
         end;

      if FCFJ >= FCFM then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Cota de Fundo de Jusante tem que ser'#13 +
                'Menor que a Cota de Fundo de Montante.', [Nome]));
         TudoOk := False;
         end;

      if FAC <= 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Altura do Canal Inválido: %f', [Nome, FAC]));
         TudoOk := False;
         end;

      if FLC <= 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Largura do Canal Inválido: %f', [Nome, FLC]));
         TudoOk := False;
         end;

      if FRST <= 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Rugosidade (manning) Inválida: %f', [Nome, FRST]));
         TudoOk := False;
         end;

      if FMPE = mpeCNL then  // <<<<< 2.06 por enquanto
         begin
         if FNST <= 0 then
            begin
            DialogoDeErros.Add(etError,
            Format('Objeto: %s'#13'Número de Sub-Trechos Inválido: %f', [Nome, FNST]));
            TudoOk := False;
            end;

         if FITC <= 0 then
            begin
            DialogoDeErros.Add(etError,
            Format('Objeto: %s'#13' Intervalo de Tempo de Cálculo inválido: %f', [Nome, FITC]));
            TudoOk := False;
            end;
         end;

      if FMPE = mpeCPI then
         begin
         if FAPI < 0 then
            begin
            DialogoDeErros.Add(etError,
            Format('Objeto: %s'#13'Altura da Planicie Inválida: %f', [Nome, FAPI]));
            TudoOk := False;
            end;

         if FLPI < 0 then
            begin
            DialogoDeErros.Add(etError,
            Format('Objeto: %s'#13'Largura da Planicie Inválida: %f', [Nome, FLPI]));
            TudoOk := False;
            end;
         end;
      end;

    mpeCF:
      begin
      if FCF_DG_LT <= 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Longitude do Trecho Inválida: %f', [Nome, FCF_DG_LT]));
         TudoOk := False;
         end;

      if FCF_DG_CFJ >= FCF_DG_CFM then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Cota de Fundo de Jusante do Conduto Fechado'#13 +
                'tem que ser menor que a Cota de Fundo de Montante.', [Nome]));
         TudoOk := False;
         end;

      if (FCF_DG_TE = 2) and (FCF_DG_Ex_RR <= 0) then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Tratamento de Excessos:'#13'Rugosidade Inválida: %f',
               [Nome, FCF_DG_Ex_RR]));
         TudoOk := False;
         end;

      // Trecho Principal
      ValidarTrecho(FCF_TPrinc, 0);

      // Trechos Paralelos
      for i := 0 to High(FCF_TPs) do
        ValidarTrecho(FCF_TPs[i], i+1);
      end; // CF

    mpeKX:
      begin
      if FAC < 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Método Muskingun: Altura do Canal Inválida: %f', [Nome, FAC]));
         TudoOk := False;
         end;

      if FCFM < 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Método Muskingun: Cota de Fundo de Montante Inválida: %f', [Nome, FCFM]));
         TudoOk := False;
         end;

      if FCFJ < 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Método Muskingun: Cota de Fundo de Jusante Inválida: %f', [Nome, FCFJ]));
         TudoOk := False;
         end;

      if FNPT_KX = 0 then
         begin
         DialogoDeErros.Add(etError,
         Format('Objeto: %s'#13'Método Muskingun: Tabela não definida', [Nome]));
         TudoOk := False;
         end;
      end;
    end;
end;

{ Tiphs1_PC }

function Tiphs1_PC.ConectarObjeto(Obj: THidroComponente): Integer;
begin
  if Obj is Tiphs1_Derivacao then
     begin
     FDerivacao := Tiphs1_Derivacao(Obj);
     FDerivacao.PC := self;
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

procedure Tiphs1_PC.DesconectarObjetos();
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

procedure Tiphs1_PC.PlotarHidrogramasEm(G: TfoChart);
begin
  inherited;
  if Derivacao <> nil then
     G.Series.AddLineSerie('Qs de ' + Derivacao.Nome + ' (m³/s)', clTEAL, Derivacao.HidroRes);
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
    FPer := self.FPer;
    
    IB.Oper := self.IB.Oper;
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
    FPer := ReadFloat(Secao, 'Per', 0);
    IB.Oper := TenCodOper(ReadInteger(Secao, 'Oper', byte(coDer)));
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
    FPer := edPerc.AsFloat;
    if rbDer.Checked then
       IB.Oper := coDer
    else
       IB.Oper := coDH;
    end
end;

procedure Tiphs1_Derivacao.PlotarHidrogramaResultante();
var G: TfoSheetChart;
    C: THidroComponente;
    v: TV;
begin
  if self.HidroRes = nil then Exit;

  // Configurações do gráfico
  G := TfoSheetChart.Create(Nome);
  G.Caption := Projeto.Nome + ': ' + Nome + ' - Hidrograma Resultante (m³/s)';
  G.Width := 400;
  G.cb3D.Checked := False;
  G.Chart.BottomAxis.Title.Caption := 'Intervalos (n. Delta T)';

  // Hidrograma de entrada do PC
  if FPC <> nil then
     begin
     v := FPC.CalcularSomaDeHidrogramas();
     if v <> nil then
        begin
        G.Series.AddLineSerie('Qe de ' + FPC.Nome + ' (m³/s)', clRED, v);
        v.Free();
        end;
     end;

  // Hidrograma derivado
  G.Series.AddLineSerie('Qd (m³/s)', clBLUE, self.HidroRes);

  // Plota informações extras se existirem
  PlotarInformacoesExtras(G);

  // Mostra a janela como filha
  G.Show(fsMDIChild);
end;

procedure Tiphs1_Derivacao.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  inherited;
  with (d as Tiphs1_Form_Dialogo_Derivacao) do
    begin
    edCDL.AsFloat  := FCDL;
    edCDD.AsFloat  := FCDD;
    edCDR.AsFloat  := FCDR;
    edCPD.AsFloat  := FCPD;
    edCPR.AsFloat  := FCPR;
    edCPL.AsFloat  := FCPL;
    edPerc.AsFloat := FPer;
    rbDer.Checked := (IB.Oper = coDer);
    rbDH.Checked := (IB.Oper = coDH);
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
    WriteFloat(Secao, 'Per', FPer);
    WriteInteger(Secao, 'Oper', byte(IB.Oper));
    end;
end;

procedure Tiphs1_Derivacao.ValidarDados(var TudoOk: Boolean; DialogoDeErros: TfoMessages; Completo: Boolean);
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

constructor Tiphs1_Res_EstruturasExtravazoras.Create;
begin
  inherited;
  FList := TObjectList.Create(True);
end;

destructor Tiphs1_Res_EstruturasExtravazoras.Destroy;
begin
  FList.Free;
  inherited;
end;

function Tiphs1_Res_EstruturasExtravazoras.Adicionar(IT, NumPontos: Integer): Tiphs1_EstruturaRes_Q;
begin
  Result := Tiphs1_EstruturaRes_Q.Create(IT, NumPontos);
  FList.Add(Result);
end;

function Tiphs1_Res_EstruturasExtravazoras.GetEst(i: Integer): Tiphs1_EstruturaRes_Q;
begin
  Result := Tiphs1_EstruturaRes_Q(FList[i]);
end;

procedure Tiphs1_Res_EstruturasExtravazoras.LerDoArquivo(Arquivo: TIF; const Secao: String);
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

procedure Tiphs1_Res_EstruturasExtravazoras.SalvarEmArquivo(Arquivo: TIF; const Secao: String);
var i: Integer;
begin
  Arquivo.WriteInteger(Secao, 'EstruturasQ', FList.Count);
  for i := 0 to FList.Count-1 do
    GetEst(i).SalvarEmArquivo(Arquivo, Secao, 'EstruturaQ' + IntToStr(i+1));
end;

function Tiphs1_Res_EstruturasExtravazoras.GetNumEstr: Integer;
begin
  Result := FList.Count;
end;

procedure Tiphs1_Res_EstruturasExtravazoras.SetNumEstr(const Value: Integer);
var i: Integer;
begin
  if Value <> FList.Count then
     if Value > FList.Count then
        for i := FList.Count+1 to Value do Adicionar(0, 0)
     else
        while FList.Count > Value do FList.Delete(FList.Count-1);
end;

procedure Tiphs1_Res_EstruturasExtravazoras.Associar(Estruturas: Tiphs1_Res_EstruturasExtravazoras);
var i: Integer;
begin
  SetNumEstr(Estruturas.NumEstruturas);
  for i := 0 to Estruturas.NumEstruturas-1 do
    GetEst(i).Associar(Estruturas[i]);
end;

end.

