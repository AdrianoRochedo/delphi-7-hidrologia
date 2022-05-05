unit pr_Classes;

{
  Instruções de como implementar processos: Olhar arquivo "Como (How-To).txt"
}

{
  Sempre procurar pelo símbolo "<<<", ele indica coisas inacabadas ou desabilitadas
}

interface
uses Windows, Types, Messages, Classes, Shapes, Forms, SysUtils, ExtCtrls,
     Graphics, Controls, ComCtrls, Menus,
     MapObjects,
     MapObjectsEx,
     MessageManager,
     Simulation,
     Rosenbrock_Class,
     hidro_Optimizer_Interfaces,
     psBASE,
     psCORE,
     Lib_GlobalObjects,
     wsMatrix,
     teEngine,
     drGraficos,
     SysUtilsEx,
     Lists,
     ErrosDLG,

     pr_Const,
     pr_Tipos,
     pr_DialogoBase,
     pr_Dialogo_PCP,
     pr_Dialogo_PCPR,
     pr_Dialogo_SB,
     pr_Dialogo_TD,
     pr_Dialogo_ClasseDeDemanda,
     pr_Dialogo_Demanda,
     pr_Dialogo_Projeto,
     pr_Dialogo_Projeto_Rosenbrock;

type
  TEventoDeMonitoracao = procedure(Sender: TObject;
                                   const Variavel: String;
                                   const Valor: Real) of object;

  TprPC                  = Class;
  TprSubBacia            = Class;
  TprDemanda             = Class;
  TprProjeto             = Class;
  TListaDeClassesDemanda = Class;
  TListaDePCs            = Class;
  TListaDeIntervalos     = Class;

  // Exceções

  ProjectNotSaved = class(Exception);
  NullLayerException = class(Exception);

  // Classes básicas ----------------------------------------------------------

  THidroComponente = class(T_NRC_InterfacedObject, IMessageReceptor, IOptimizer)
  private
    FVisitado   : Boolean;
    FModificado : Boolean;
    FProjeto    : TprProjeto;

    FVarsQuePodemSerMonitoradas : String;
    FVarsMonitoradas            : String;
    FEventoDeMonitoracao        : TEventoDeMonitoracao;

    FImagemDoComponente     : TdrBaseShape;
    FPos                    : ImoPoint;
    FNome                   : String;
    Dialogo                 : TprDialogo_Base;
    FDescricao              : String;
    FComentarios            : TStrings;
    FTN                     : TStrings;
    FMenu                   : TPopupMenu;
    FAvisarQueVaiSeDestruir : Boolean;

    procedure SetModificado(const Value: Boolean);
    function  GetRect: TRect;
    function  GetScreenPos: TPoint;
    function  GetPos: ImoPoint;
    procedure SetPos(Const Value: ImoPoint);
    procedure SetNome(const Value: String);
    procedure DuploClick(Sender: TObject);
    function  Section: String;

    procedure AtualizaHint;

    function  ObtemNome: String;
    procedure PreparaScript(Arquivo: String; var Script: TPascalScript);
  protected
    // IMessageReceptor Interface
    function ReceiveMessage(Const MSG: TadvMessage): Boolean; virtual;

    // IOptimizer Interface
    function Optimizer_getValue(const PropName: string; Year, Month: Integer): real; virtual;
    procedure Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real); virtual;

    Function  ObtemPrefixo: String; Virtual;
    procedure PrepararMenu; virtual;

    procedure CriarComponenteVisual(Pos: ImoPoint);
    function  CriarImagemDoComponente: TdrBaseShape; Virtual; Abstract;

    // Comunicação com o usuário (Interface gráfica)
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Virtual;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Virtual;
    function  CriaDialogo: TprDialogo_Base; Virtual;
    procedure ColocaDadosNaPlanilha(Planilha: TForm); Virtual; Abstract;
  public
    constructor Create(UmaTabelaDeNomes: TStrings; Projeto: TprProjeto);
    destructor  Destroy; override;

    function  CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TgrGrafico;
    procedure DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);

    // Cria uma conecção de um componente a este componente
    function ConectarObjeto(Obj: THidroComponente): Integer; Virtual;

    // Desconecta todos os componentes ligados a este componente
    procedure DesconectarObjetos; Virtual;

    function  MostrarDialogo: Integer;
    procedure MostrarPlanilha;
    procedure MostrarDataSet(const Titulo: String; Dados: TwsDataSet);
    procedure MostrarMenu(x: Integer = -1; y: Integer = -1); Virtual;
    procedure MostrarVariavel(const NomeVar: String); Virtual; Abstract;

    function  ObterDataSet(Dados: TV): TwsDataSet;

    function  AdicionaObjeto(Obj: THidroComponente): Integer; Virtual; Abstract;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Virtual;
    procedure SalvarEmArquivo(Arquivo: TIF); Virtual;

    {Realiza o diagnóstico dos dados (Erros Fatais e Avisos)}
    procedure Diagnostico(var TudoOk: Boolean; Completo: Boolean = False);

    // Rotinas de tratamento de Paths de arquivo
    function  VerificarCaminho(var Arquivo: String): Boolean;
    procedure RetirarCaminhoSePuder(var Arquivo: String);

    procedure VerificarRotinaUsuario(Arquivo: String; const Texto: String;
                                    Completo: Boolean; var TudoOk: Boolean;
                                    DialogoDeErros: TErros_DLG;
                                    FuncaoObjetivo: Boolean = False);

    // Realiza as inicializações para as simulações
    // Este método é chamado através de um evento disparado antes de uma simulação
    procedure PrepararParaSimulacao; virtual;

    procedure AutoDescricao(Identacao: byte); virtual;

    {Realiza somente a validação dos dados (Erros Fatais)
     Regra: A variável TudoOk deverá ser inicializada em TRUE}
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Virtual;

    // Calcula o número de dias de um DeltaT
    function DiasNoIntervalo: Integer;

    procedure DefinirVariaveisQuePodemSerMonitoradas(const Variaveis: Array of String);
    procedure MotitorarVariaveis(const Variaveis: Array of String);
    procedure Monitorar; virtual;

    property Visitado   : Boolean    read FVisitado   write FVisitado;
    property Projeto    : TprProjeto read FProjeto    write FProjeto;
    property Modificado : Boolean    read FModificado write SetModificado;

    property VarsQuePodemSerMonitoradas : String read FVarsQuePodemSerMonitoradas;
    property VarsMonitoradas            : String read FVarsMonitoradas write FVarsMonitoradas;

    property EventoDeMonitoracao : TEventoDeMonitoracao
        read FEventoDeMonitoracao
        write FEventoDeMonitoracao;

    property AvisarQueVaiSeDestruir: Boolean
       read  FAvisarQueVaiSeDestruir
       write FAvisarQueVaiSeDestruir;

    property  TabelaDeNomes : TStrings  read FTN           write FTN;
    property  Nome          : String    read FNome         write SetNome;
    property  Descricao     : String    read FDescricao    write FDescricao;
    property  Comentarios   : TStrings  read FComentarios;

    property ImagemDoComponente : TdrBaseShape read FImagemDoComponente;

    property Menu       : TPopupMenu read FMenu         write FMenu;
    property Pos        : ImoPoint   read FPos          write SetPos;
    property ScreenPos  : TPoint     read GetScreenPos;
    property Regiao     : TRect      read GetRect;
  end;

  TprPCP = class;

  TListaDeObjetos = Class
  private
    FList: TList;
    FLiberarObjetos: Boolean;
    function  getObjeto(index: Integer): THidroComponente;
    procedure setObjeto(index: Integer; const Value: THidroComponente);
    function  getNumObjetos: Integer;
  public
    constructor Create;
    Destructor  Destroy; override;

    function  IndiceDo(Objeto: THidroComponente): Integer;
    procedure Deletar(Indice: Integer);
    function  Remover(Objeto: THidroComponente): Integer;
    function  Adicionar(Objeto: THidroComponente): Integer;
    procedure RemoverNulos;
    procedure Ordenar(FuncaoDeComparacao: TListSortCompare);

    property LiberarObjetos: Boolean          read FLiberarObjetos write FLiberarObjetos;
    property Objeto[index: Integer]: THidroComponente read getObjeto write setObjeto; default;
    property Objetos: Integer                 read getNumObjetos;
  end;

  // Classes específicas -------------------------------------------------------------

  TprTrechoDagua = class(THidroComponente)
  private
    FVazaoMinima : Real;
    FVazaoMaxima : Real;
    //FVzMon       : TwsSFVec; // Vazão de Montante

    procedure SetVazaoMaxima(const Value: Real);
    procedure SetVazaoMinima(const Value: Real);
    Function  ObtemPrefixo: String; Override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriaDialogo: TprDialogo_Base; Override;
    function  ReceiveMessage(const MSG: TadvMessage): Boolean; Override;
  public
    PC_aMontante : TprPCP;
    PC_aJusante  : TprPCP;

    constructor Create(PC1, PC2: TprPCP; UmaTabelaDeNomes: TStrings; Projeto: TprProjeto);
    destructor Destroy; override;

    // procedure ObtemVazaoDeMontante; // Atualiza FVzMon

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;

    property VazaoMaxima: Real read FVazaoMaxima write SetVazaoMaxima;
    property VazaoMinima: Real read FVazaoMinima write SetVazaoMinima;
  end;

  TprPC = Class(THidroComponente) // PC Característico
  private
    // FLC somente contém referências a outros objetos
    FPCs_aMontante  : TListaDeObjetos;
    FSubBacias      : TListaDeObjetos;
    FDemandas       : TListaDeObjetos;
    FTD             : TprTrechoDagua;

    FVisivel        : Boolean;
    FHierarquia     : Integer;
    FAfluenciaSB    : TV;      // Afluencia no intervalo t
    FDefluencia     : TV;      // Defluencia no intervalo t
    FVzMon          : TV;      // Vazão total de Montante no intervalo t

    function  GetPC_aMontante(Index: Integer): TprPCP;
    function  GetPCs_aMontante: Integer;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function  GetNumSubBacias: Integer;
    function  GetPC_aJusante: TprPCP;
    function  GetSubBacia(index: Integer): TprSubBacia;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    procedure SetVisivel(Value: Boolean);
    procedure SetPC_aJusante(const Value: TprPCP);
    function  GetDemanda(index: Integer): TprDemanda;
    function  GetNumDemandas: Integer;
    procedure ColocaDadosNaPlanilha(Planilha: TForm); Override;
  public
    constructor Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
    destructor  Destroy; override;

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure Monitorar; override;

    // Métodos que mexem com as listas de Objetos
    function  AdicionaObjeto(Obj: THidroComponente): Integer; override;
    function  Eh_umPC_aMontante(PC: THidroComponente): Boolean;
    procedure RemoveTrecho; // Remove trecho de agua a frente
    procedure LimpaObjetos; // Limpa todos os objetos conectados a este PC, exceto outros PCs
    procedure RemovePC_aMontante(PC: TprPCP); // Remove coneccao atras
    procedure AdicionaPC_aMontante(PC: TprPCP); // Insere na Lista de Chegada

    procedure BalancoHidrico; virtual; abstract;
    function  ObtemVazoesDeMontante: Real; virtual; abstract;
    function  ObtemVazaoAfluenteSBs: Real;
    procedure PrepararParaSimulacao; override;
    procedure MostrarVariavel(const NomeVar: String); override;
    procedure AutoDescricao(Identacao: byte); override;

    property Hierarquia:       Integer         read FHierarquia write FHierarquia;
    property PCs_aMontante:    Integer         read GetPCs_aMontante;
    property SubBacias:        Integer         read GetNumSubBacias;
    property Demandas:         Integer         read GetNumDemandas;
    property PC_aJusante:      TprPCP          read GetPC_aJusante write SetPC_aJusante;
    property TrechoDagua:      TprTrechoDagua  read FTD;
    property Visivel:          Boolean         read FVisivel write SetVisivel;

    property PC_aMontante [index: Integer]: TprPCP      read GetPC_aMontante;
    property SubBacia     [index: Integer]: TprSubBacia read GetSubBacia;
    property Demanda      [index: Integer]: TprDemanda  read GetDemanda;

    property AfluenciaSB     : TV read FAfluenciaSB;
    property Defluencia      : TV read FDefluencia;
    property VazMontante     : TV read FVzMon;
  end;

  TListaDeFalhas = class;
  TprPCPR        = class;

  TprPCP = class(TprPC) // PC Propagar
  private
    //FCRC: String; // código de retorno de contribuição

    // F = Field    D = Demanda     P,S,T = Primaria..Terciaria
    // T = Totais   A = Atendidas   P = Planejadas
    FDPT: TV;
    FDST: TV;
    FDTT: TV;

    FDPA: TV;
    FDSA: TV;
    FDTA: TV;

    FDPP: TV;
    FDSP: TV;
    FDTP: TV;

    FEG : TV; // Energia Gerada no intervalo t
    FCurvaDemEnergetica : TV;

    FNCFP: Real; // Nível Crítico de Falha Primária
    FNCFS: Real; // Nível Crítico de Falha Secundária
    FNCFT: Real; // Nível Crítico de Falha Terciária

    FFRP: Real; // Fator de retorno Primario
    FFRS: Real; // Fator de retorno Secundario
    FFRT: Real; // Fator de retorno Terciario

    FMDs : Boolean; // Mostrar demandas

    FEnergiaUsuario : String;
    FEnergiaScript  : TPascalScript;

    FExecutarEnergiaPadrao : Boolean;

    FGerarEnergia       : Boolean;
    FRendiGera          : Real;
    FQMaxTurb           : Real;
    FRendiAduc          : Real;
    FRendiTurb          : Real;
    FDemEnergetica      : Real;
    FQuedaFixa          : Real;
    FArqDemEnergetica   : String;

    procedure CopiarPara(PC: TprPCP);
    function  CriaDialogo: TprDialogo_Base; Override;
    Function  ObtemPrefixo: String; Override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    procedure GraficarDemandas(const Titulo, TipoDem: String; TipoGraf: TEnumTipoDeGrafico);
    procedure ObtemNiveisCriticosDeFalhas;
    procedure ColocaDadosNaPlanilha(Planilha: TForm); Override;
    procedure SetMDs(const Value: Boolean);
    procedure PrepararMenu; override;
    procedure Menu_DemandasClick(Sender: TObject);
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure BalancoHidrico; override;
    procedure CalculaVzMon_e_AfluenciaSB;
    function  CalculaEnergia(Queda, Vazao : Real): Real;
    procedure Raciona(AguaDisponivel, DPX, DSX, DTX: Real; out DPA, DSA, DTA: Real);
    function Optimizer_getValue(const PropName: string; Year, Month: Integer): real; override;
    procedure Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real); override;
  protected
    function  ObterVazoesDeMontante: Real;
    function  ObterVazaoAfluenteSBs: Real;
  public
    constructor Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
    destructor  Destroy; override;

    function ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure DesconectarObjetos; override;

    // Retorna verdadeiro se existe objetos conectados, DEVE ser implementado nos descendentes
    function PossuiObjetosConectados: Boolean; 

    // Remove o PC que está a montante deste (atrás)
    procedure DesconectarPC_aMontante(PC: TprPCP);

    // Conecta um PC a montante deste
    procedure ConectarPC_aMontante(PC: TprPCP);

    // Remove o trecho de água deste PC
    procedure RemoverTrecho;

    function MudarParaReservatorio(UmMenu: TPopupMenu): TprPCPR;

    procedure Monitorar; override;

    function  Hm3_m3_Intervalo(const Valor: Real): Real;
    function  m3_Hm3_Intervalo(const Valor: Real): Real;

    procedure TotalizaDemandas;
    function  CalculaFatorRetorno(Tipo: TEnumPriorDemanda): Real;
    function  ObtemVazoesDeMontante: Real; override;
    function  ObtemDemanda(Prioridade: TEnumPriorDemanda): Real;

    procedure PrepararParaSimulacao; override;

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;

    procedure GraficarTudo; Virtual;
    procedure GraficarDemandasAtendidas (Tipo: TEnumTipoDeGrafico);
    procedure GraficarDemandasPlanejadas(Tipo: TEnumTipoDeGrafico);
    procedure GraficarDemandasTotais (Tipo: TEnumTipoDeGrafico);
    procedure GraficarDisponibilidade_X_Demanda(Tipo: TEnumTipoDeGrafico);
    procedure GraficarEnergia(Tipo: TEnumTipoDeGrafico);

    function  ObtemFalhas: TListaDeFalhas;
    procedure MostrarFalhas;
    procedure MostrarVariavel(const NomeVar: String); override;
    procedure MostrarMenu(x: Integer = -1; y: Integer = -1); override;

    procedure AutoDescricao(Identacao: byte); override;

    //property CRC: String read FCRC write FCRC;

    property DemPriAtendida: TV read FDPA;
    property DemSecAtendida: TV read FDSA;
    property DemTerAtendida: TV read FDTA;

    property DemPriTotal: TV read FDPT;
    property DemSecTotal: TV read FDST;
    property DemTerTotal: TV read FDTT;

    property DemPriPlanejada: TV read FDPP;
    property DemSecPlanejada: TV read FDSP;
    property DemTerPlanejada: TV read FDTP;

    property GerarEnergia       : Boolean read FGerarEnergia       write FGerarEnergia;
    property RendiAduc          : Real    read FRendiAduc          write FRendiAduc;
    property RendiTurb          : Real    read FRendiTurb          write FRendiTurb;
    property RendiGera          : Real    read FRendiGera          write FRendiGera;
    property QMaxTurb           : Real    read FQMaxTurb           write FQMaxTurb;
    property QuedaFixa          : Real    read FQuedaFixa          write FQuedaFixa;
    property DemEnergetica      : Real    read FDemEnergetica      write FDemEnergetica;
    property CurvaDemEnergetica : TV      read FCurvaDemEnergetica write FCurvaDemEnergetica;
    property ArqDemEnergetica   : String  read FArqDemEnergetica   write FArqDemEnergetica;

    property Energia : TV read FEG;

    property MostrarDemandas: Boolean read FMDs write SetMDs;
  end;

  TprPCPR = class(TprPCP)  // PC Propagar Reservatorio
  private
    FArqPrec     : String;
    FArqETP      : String;
    FTipoETP     : Byte;
    FVolMax      : Real;
    FVolMin      : Real;
    FVolIni      : Real;
    FCotaJusante : Real;
    FCV          : Array of TRecCotaVolume;  // Cota Volume
    FAV          : Array of TRecAreaVolume;  // Área Volume
    FStatus      : Boolean;
    FDeflu_Pl    : TV;
    FVolume      : TV; // Volumes em cada intervalo
    FEU          : TV; // Evaporação Unitária
    FPU          : TV; // Precipitação Unitária
    FDeflu_Op    : TV;

    FOperaUsuario : String;
    FOperaScript  : TPascalScript;

    FExecutarOperaPadrao   : Boolean;
    FExecutarEnergiaPadrao : Boolean;

    Function  ObtemPrefixo: String; Override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriaDialogo: TprDialogo_Base; Override;
    function  GetAV(index: Word): TRecAreaVolume;
    function  GetCV(index: Word): TRecCotaVolume;
    function  GetPAV: Word;
    function  GetPCV: Word;
    function  GetEU: TV;
    function  GetPU: TV;
    procedure SetPAV(const Value: Word);
    procedure SetPVC(const Value: Word);
    procedure ColocaDadosNaPlanilha(Planilha: TForm); Override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;

    function Optimizer_getValue(const PropName: string; Year, Month: Integer): real; override;
    procedure Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real); override;

    function  ObtemVolFinalIntervaloAnterior: Real;

    procedure BalancoHidrico; override;
    procedure Opera(const VolumeDisponivel, DPP, DSP, DTP, Deflu_Pl: Real;
                    out DPO, DSO, DTO, Deflu_OP: Real);
  public
    constructor Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
    destructor  Destroy; override;

    function  CalculaCotaHidraulica(const Volume: Real): Real;
    function  CalculaAreaDoReservatorio(const Volume: Real): Real;

    procedure PrepararParaSimulacao; override;
    function  MudarParaPC(UmMenu: TPopupMenu): TprPCP;

    procedure GraficarVolumes(Tipo: TEnumTipoDeGrafico);
    procedure GraficarTudo; Override;

    procedure MostrarVariavel(const NomeVar: String); override;

    procedure AutoDescricao(Identacao: byte); override;

    procedure Monitorar; override;

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;

    property ArqPrec            : String  read FArqPrec     write FArqPrec;
    property ArqETP             : String  read FArqETP      write FArqETP;
    property TipoETP            : Byte    read FTipoETP     write FTipoETP;
    property VolumeMaximo       : Real    read FVolMax      write FVolMax;
    property VolumeMinimo       : Real    read FVolMin      write FVolMin;
    property VolumeInicial      : Real    read FVolIni      write FVolIni;
    property CotaJusante        : Real    read FCotaJusante write FCotaJusante;

    property PontosCV           : Word    read GetPCV    write SetPVC;
    property PontosAV           : Word    read GetPAV    write SetPAV;
    property Status             : Boolean read FStatus   write FStatus;

    property CV[i: Word]: TRecCotaVolume  read GetCV;   // Cota Volume
    property AV[i: Word]: TRecAreaVolume  read GetAV;   // Área Volume

    property Volume  : TV read FVolume;

    property DefluvioPlanejado    : TV read FDeflu_Pl;
    property DefluvioOperado      : TV read FDeflu_Op;
    property EvaporacaoUnitaria   : TV read getEU;
    property PrecipitacaoUnitaria : TV read getPU;
  end;

  TprSubBacia = Class(THidroComponente)
  private
    FPCs       : TListaDeObjetos;
    FDemandas  : TListaDeObjetos;

    FCCs       : TDoubleList;
    FArea      : Real;
    FArqVA     : String;
    FVazoes    : TV;

    function  getNDD: Integer;
    function  GetDD(index: Integer): TprDemanda;
    function  GetVazoes: TV;
    function  ObterVazaoAfluente(PC: TprPCP): Real;
  protected
    Function  ObtemPrefixo: String; Override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriaDialogo: TprDialogo_Base; Override;
    function  CriarImagemDoComponente: TdrBaseShape;  Override;
    function  ReceiveMessage(const MSG: TadvMessage): Boolean; Override;
    procedure ColocaDadosNaPlanilha(Planilha: TForm); Override;
  public
    constructor Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    function  ObtemVazaoAfluente(PC: TprPCP): Real;

    procedure PrepararParaSimulacao; override;

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;

    function  AdicionaObjeto(Obj: THidroComponente): Integer; override;
    procedure LiberaVazoes;
    procedure LimpaObjetos;

    procedure GraficarVazoes(Tipo: TEnumTipoDeGrafico);
    procedure MostrarVariavel(const NomeVar: String); override;

    procedure AutoDescricao(Identacao: byte); override;

    procedure Monitorar; override;

    property Area                    : Real             read FArea write FArea;
    property Demandas                : Integer          read getNDD;
    property Arq_VazoesAfluentes     : String           read FArqVA;
    property PCs                     : TListaDeObjetos  read FPCs;
    property CCs                     : TDoubleList    read FCCs;
    property Vazoes                  : TV               read GetVazoes;
    property Demanda[index: Integer] : TprDemanda       read GetDD;
  end;

  TListaDePCs = Class
  private
    FList : TListaDeObjetos;
    function GetPC(Index: Integer): TprPCP;
    function GetNumPCs: Integer;
    procedure SetPC(index: Integer; const Value: TprPCP);
  public
    constructor Create;
    destructor Destroy; override;

    function Adicionar(PC: TprPCP): Integer;
    function Remover(PC: TprPCP): boolean;
    function IndiceDo(PC: TprPCP): Integer;

    procedure CalcularHierarquia;
    procedure Ordenar;

    property PCs: Integer read GetNumPCs;
    property PC[index: Integer]: TprPCP read GetPC write SetPC; Default;
  end;

  // Classe basica para implementacao de demandas.
  // Eh de responsabilidade das classes descendentes a implementacao dos
  // metodos para recuperar e configurar as propriedades "Ligada" e "Prioridade"
  // bem como o comportamento das instancias em relacao a estas propriedades.
  // Tambem eh de responsabilidade a implementacao do calculo do valor da demanda.
  THidroDemanda = class(THidroComponente)
  private
    FLigada: Boolean;
    FPrioridade: TEnumPriorDemanda;
    FSalvarLerBitmap: Boolean;
    FBitmapMudou: Boolean;
    function  GetBitmap: TBitmap;
    procedure SetBitmap(B: TBitmap);
    procedure BitmapChange(Sender: TObject);
  protected
    function getBitmapName: String; virtual;

    // Implemente este metodo para calcular o valor da demanda
    function getDemanda: Real; virtual;
  public
    procedure SalvarEmArquivo(Arquivo: TIF); override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); override;

    property Ligada      : Boolean           read FLigada;
    property Prioridade  : TEnumPriorDemanda read FPrioridade;
    property Bitmap      : TBitmap           read GetBitmap write SetBitmap;
    property BitmapMudou : Boolean           read FBitmapMudou write FBitmapMudou;
    property Demanda     : Real              read getDemanda;
  end;

  TprClasseDemanda = class(THidroDemanda)
  private
    FED           : Real;
    FFC           : Real;
    FNUCD         : String;
    FNUD          : String;
    FUD           : TaRecUD;
    FVU           : TaRecVU;
    FFI           : TaRecFI;
    FData         : TRec_prData;
    FFR           : Real;
    FNFC          : Real;

    FSincronizaDados : Boolean;
    FSincVU          : Boolean;
    FSincUD          : Boolean;
    FSincFI          : Boolean;

    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriarImagemDoComponente: TdrBaseShape;  Override;
    function  CriaDialogo: TprDialogo_Base; Override;
    function  ObtemPrefixo: String; Override;

    // Obtem as unidades com base na data de simulacao
    function  GetUC: Real;
    function  GetUD: Real;
    function  GetFI: Real;

    function  Optimizer_getValue(const PropName: string; Year, Month: Integer): real; override;
    procedure Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real); override;

    function getUnidadeDeConsumo (Ano, Mes: Integer): Real;
    function getUnidadeDeDemanda (Ano, Mes: Integer): Real;
    function getFatorDeImplantacao (Ano, Mes: Integer): Real;

    function setUnidadeDeConsumo (Ano, Mes: Integer; Valor: real): Real;
    function setUnidadeDeDemanda (Ano, Mes: Integer; Valor: real): Real;
    function setFatorDeImplantacao (Ano, Mes: Integer; Valor: real): Real;

    procedure ErroTVU(const Rotina: string);
  protected
    // Cuidado: Esta implementacao depende da propriedade "data"
    function getDemanda: Real; override;
  public
    constructor Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;

    procedure AutoDescricao(Identacao: byte); Override;

    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;

    // Gerenciamento da TVU (Tab. de Valores Unitários)
    procedure TVU_NumIntervalos(const NumIntervalos: Integer);
    procedure TVU_AnoInicialFinalIntervalo(const Ind_Intervalo, AnoInicial, AnoFinal: Integer);
    procedure TVU_Demanda(const Ind_Intervalo, Mes: Integer; const Demanda: Real);

    property Data                     : TRec_prData       read FData     write FData;
    property EscalaDeDesenvolvimento  : Real              read FED       write FED;
    property FatorDeConversao         : Real              read FFC       write FFC;
    property FatorDeRetorno           : Real              read FFR       write FFR;
    property NomeUnidadeConsumoDagua  : String            read FNUCD     write FNUCD;
    property NomeUnidadeDeDemanda     : String            read FNUD      write FNUD;

    property TabValoresUnitarios      : TaRecVU           read FVU       write FVU;
    property TabUnidadesDeDemanda     : TaRecUD           read FUD;
    property TabFatoresImplantacao    : TaRecFI           read FFI;

    property UnidadeDeConsumo         : Real              read GetUC;
    property UnidadeDeDemanda         : Real              read GetUD;
    property FatorDeImplantacao       : Real              read GetFI;

    property NivelDeFalhaCritica      : Real              read FNFC;

    property SincronizaDados : Boolean read FSincronizaDados;
    property SincVU          : Boolean read FSincVU;
    property SincUD          : Boolean read FSincUD;
    property SincFI          : Boolean read FSincFI;
  end;

  TprDemanda = class(TprClasseDemanda)
  private
    FClasse          : String;
    FGrupos          : TStrings;
    FTipo            : TEnumTipoDemanda;
    FHabilitada      : Boolean;
    FTemp: Real;

    function  getVisivel: Boolean;
    procedure SetVisivel(const Value: Boolean);
    function  Sincronizar(Dado: Integer; Dados: TStrings): Boolean;
  protected
    Function  ObtemPrefixo: String; Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriaDialogo: TprDialogo_Base; Override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
  public
    constructor Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;

    procedure AutoDescricao(Identacao: byte); Override;

    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;

    procedure Atribuir(Demanda: TprClasseDemanda; Criando: Boolean; Dados: TStrings = nil);
    function  AdicionaObjeto(Obj: THidroComponente): Integer; override;

    property Classe      : String           read FClasse;
    property Grupos      : TStrings         read FGrupos;
    property Tipo        : TEnumTipoDemanda read FTipo        write FTipo;
    property Habilitada  : Boolean          read FHabilitada;
    property ValorTemp   : Real             read FTemp        write FTemp;
    property Visivel     : Boolean          read getVisivel   write SetVisivel;
  end;

  TEventoDeMudanca = TNotifyEvent;

  TListaDeClassesDemanda = class
  private
    FTN       : TStrings;
    FList     : TStrings;
    FEM       : TEventoDeMudanca;
    FProjeto  : TprProjeto;

    function getClasse(indice: Integer): TprClasseDemanda;
    function GetClasses: Integer;
    function getBitmap(indice: Integer): TBitmap;
    procedure RemoverObjeto(indice: Integer);
  public
    constructor Create;
    destructor Destroy; Override;

    procedure LerDoArquivo(Arquivo: TIF);
    procedure SalvarEmArquivo(Arquivo: TIF);

    procedure Adicionar(DM: TprClasseDemanda);
    procedure Editar(DM: TprClasseDemanda);
    function  Remover(DM: TprClasseDemanda): Boolean;

    procedure Limpar;
    function  ClassePeloNome(Const NomeClasse: String): TprClasseDemanda;

    property Classes         : Integer             read GetClasses;
    property EventoDeMudanca : TEventoDeMudanca    read FEM write FEM;
    property Projeto         : TprProjeto          read FProjeto write FProjeto;
    property TabelaDeNomes   : TStrings            read FTN write FTN;

    property Classe[indice: Integer]: TprClasseDemanda read getClasse; Default;
    property Bitmap[indice: Integer]: TBitmap          read getBitmap;
  end;

  // Representa as falhas em um ano, não especificando o nível}
  // Ex: 1998: (intervalo/critica) --> (34/não), (534/sim), (678/não)
  // Para um ano ser crítico basta que apenas um intervalo seja crítico.
  TprFalha = class
  private
    FAno        : Integer;
    FIntervalos : TIntegerList;
    FIntCrit    : TBooleanList;
    FDemsRef    : TDoubleList;
    FDemsAten   : TDoubleList;
    function GetSAno: String;
    function GetFalhaCritica: Boolean;
  public
    constructor Create(Ano, Intervalo: Integer; Const DR, DA, NCF: Real);
    destructor Destroy; override;

    property Ano                : Integer          read FAno             write FAno;
    property sAno               : String           read GetSAno;
    property FalhaCritica       : Boolean          read GetFalhaCritica;
    property Intervalos         : TIntegerList read FIntervalos;
    property IntervalosCriticos : TBooleanList read FIntCrit;
    property DemsRef            : TDoubleList    read FDemsRef;
    property DemsAten           : TDoubleList    read FDemsAten;
  end;

  {Armazena todas as falhas de suprimento de água de um PC.
   As falhas estão divididas em 3 níveis: Falhas primárias, secundárias e terciárias.
   Cada nível armazena os intervalos onde ocorreram as falhas em um ano e também se nesse
   intervalo a falha foi crítica ou não.
   Ex: Falha primária: 3 anos -->
       1978: (intervalo/critica) --> (34/não), (534/sim), (678/não)
       1981: (intervalo/critica) --> (23/não), (345/não), (456/não)
       1982: (intervalo/critica) --> (249/não)
  }
  TListaDeFalhas = class
  private
    FFalhasPri: TStrings;
    FFalhasSec: TStrings;
    FFalhasTer: TStrings;
    FProjeto  : TprProjeto;

    function  PegarFalhas(Tipo: TEnumPriorDemanda): TStrings;
    function  getFalhaPri(i: Integer): TprFalha;
    function  getFalhaSec(i: Integer): TprFalha;
    function  getFalhaTer(i: Integer): TprFalha;
    function  getNumFalhasPri: Integer;
    function  getNumFalhasSec: Integer;
    function  getNumFalhasTer: Integer;
  public
    constructor Create(Projeto: TprProjeto);
    Destructor  Destroy; override;

    function  FalhaPeloAno(Tipo: TEnumPriorDemanda; const Ano: String): TprFalha;
    function  Adicionar(Tipo: TEnumPriorDemanda; Intervalo: Integer; const DR, DA, NCF: Real): Integer;
    function  MostrarFalhas: TForm;

    function IntervalosTotais(Tipo: TEnumPriorDemanda): Integer;   // número de anos
    function AnosCriticos(Tipo: TEnumPriorDemanda): Integer;       // anos críticos
    function IntervalosCriticos(Tipo: TEnumPriorDemanda): Integer; // Intervalos críticos de todos os anos

    property Projeto: TprProjeto read FProjeto;

    property FalhaPrimaria   [i: Integer]: TprFalha read getFalhaPri;
    property FalhaSecundaria [i: Integer]: TprFalha read getFalhaSec;
    property FalhaTerciaria  [i: Integer]: TprFalha read getFalhaTer;

    property FalhasPrimarias   : Integer read getNumFalhasPri;
    property FalhasSecundarias : Integer read getNumFalhasSec;
    property FalhasTerciarias  : Integer read getNumFalhasTer;
  end;

  // Representa a lista de intervalos válidos para uma análise
  TListaDeIntervalos = Class
  private
    FIntIni: TIntegerList;
    FIntFim: TIntegerList;
    FHab   : TIntegerList;
    FNomes: TStrings;
    FProjeto: TprProjeto;
    function getNumInts: Integer;
    function GetsDataFim(i: Integer): String;
    function GetsDataIni(i: Integer): String;
    function GetNome(i: Integer): String;
    function GetHabilitado(i: Integer): Boolean;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Adicionar(Ini, Fim: Integer; const Nome: String; Habilitado: Boolean);
    procedure Remover(indice: Integer);
    procedure Limpar;

    property IntIni      : TIntegerList read FIntIni;
    property IntFim      : TIntegerList read FIntFim;
    property NumInts     : Integer          read getNumInts;

    property Nome       [i: Integer] : String  read GetNome;
    property sDataIni   [i: Integer] : String  read GetsDataIni;
    property sDataFim   [i: Integer] : String  read GetsDataFim;
    property Habilitado [i: Integer] : Boolean read GetHabilitado;
  end;

  TProcPSB = procedure(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList = nil);
  TProcPDM = procedure(Projeto: TprProjeto; SB: TprDemanda;  Lista: TList = nil);

  TStatusProjeto = (sFazendoNada, sSimulando, sOtimizando);

  TprProjeto = Class(THidroComponente)
  private
    FLerSomenteRede     : Boolean;
    FVersion            : Single;
    FIntervalosSim      : Integer;
    FIni                : TIF;
    FDirSaida           : String;    // temporário para cada simulação (DOS)
    FClasDem            : TListaDeClassesDemanda;
    FModificado         : Boolean;
    FNomeArquivo        : String;
    FTI                 : byte;
    FPCs                : TListaDePCs;
    FAnos               : TaRecIntervalos;
    FIntSim             : TEnumIntSim;
    FNF                 : Real;                    // Nível de Falha
    FArqVazoes          : String;                  // Vazões afluentes de cada PC
    FArqDPS             : String;                  // Demanda Primária Suprida
    FArqDSS             : String;                  // Demanda secundária Suprida
    FArqDTS             : String;                  // Demanda Terciária Suprida
    FArqAR              : String;                  // Armazenamentos nos reservatórios
    FArqEG              : String;                  // Energia Gerada em cada PC
    FDirSai             : String;
    FDirTrab            : String;                  // Dir. de trabalho (database)
    FDeltaT             : Integer;
    FInts               : TListaDeIntervalos;
    FPropDOS            : String;
    FValorFO            : Real;
    FAreaDeProjeto      : TForm;
    //FSubBacias          : TList;
    FSimulador          : TSimulation;
    FTS                 : TEnumTipoSimulacao;
    FTotal_IntSim       : Integer; // Atualizado na leitura do projeto e após o diálogo
    FPlanejaUsuario     : String;
    FRotinaGeralUsuario : String;
    //FRacionaUsuario     : String;
    FOperaUsuario       : String;
    FEnergiaUsuario     : String;
    FPlanejaScript      : TPascalScript;
    FScriptGeral        : TPascalScript;
    FGlobalObjects      : TGlobalObjects;
    FEC                 : String;         // Execucao corrente
    FSC                 : TPascalScript;  // Script corrente
    FStatus             : TStatusProjeto; // Armazena o status de execução do projeto
    FScripts            : TStrings;

    // Eventos
    FEvento_InicioSimulacao : TNotifyEvent;
    FEvento_FimSimulacao    : TNotifyEvent;

    // Mapa
    FMap          : TMapEx;  // Componente gráfico para visualização de mapas
    FMap_SC       : String;  // Nome e tipo do sistema de coordenadas em uso
    FMap_SC_Cod   : String;  // Código do sistema de coordenadas em uso
    FMap_Escala   : Integer; // Escala do Mapa
    FMap_Unit     : String;  // Unidade de medida utilizada
    FMap_UnitCode : Integer; // Código da Unidade

    // Atualiza o Sistema de Coordenadas utilizada pelo Mapa
    procedure UpdateCoordinateSystem(const Name, Code: String);

    // Atualiza a unidade do mapa
    procedure UpdateUnit(UnitCode: Integer);

    function  ObtemSubBacias: TList;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriaDialogo: TprDialogo_Base; Override;
    function  getTAIS: Integer;
    function  getTIS: Integer;
    function  getData: TRec_prData;
    function  getTMIS: Integer;
    function  getNumAnos: Integer;
    procedure EscreveAnosNoEditor(Const Ident: String = '');

    // Mecanismo de Simulação
    procedure  ExecutarSimulacao; Virtual;
    procedure  AtualizaPontoExecucao(const EC: String; SCC: TPascalScript);

    // Métodos Interativos
    procedure Planeja;
    procedure ExecutarRotinaGeral;

    // Mecanismo de ligação do Propagar DOS
    function  GerarArquivoDeVazoes: String;
    function  GerarArquivoDeDemandasDifusas: String;
    function  GerarArquivoDeDemanda(Tipo: TEnumPriorDemanda): String;
    function  GerarArquivoDosReservatorios(const Tipo: String): String;
    procedure LeArquivosDoPropagarDOS;

    function  LerPC(Ini: TIF; const NomeDoPC: String): TprPCP;
    procedure Ler_Objetos(Ini: TIF; const NomeDoPC: String);
    function ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function Optimizer_getValue(const PropName: string; Year, Month: Integer): real; override;
    procedure Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real); override;
    function getDirTrab: String;
  protected
    // Métodos da simulação.
    procedure  Temporizador (Sender: TObject; out EventID: Integer);
    procedure  Simulacao    (Sender: TObject; const EventID: Integer);
  public
    constructor Create(UmaTabelaDeNomes: TStrings; AreaDeProjeto: TForm);
    destructor  Destroy; override;

    { GIS Methods ------------------------------------------------------------ }

    // Adiciona uma camada se o projeto não possui uma camada em branco,
    // isto é, não possui a camada "Null_Layer.shp"
    function AddLayer(FileName: String): Tmoec_Layer;

    // Métodos de conversão TPoint <--> ImoPoint
    function moPointToPoint(p: ImoPoint): TPoint;
    function PointTo_moPoint(p: TPoint): ImoPoint;

    { GIS Methods ------------------------------------------------------------ }

    // Cria um descendente de THidroComponente.
    // Este método deverá ser obrigatoriamente implementado pelos descendentes e deverá
    // fornecer pelo menos a possibilidade de criação de PCs, Reservatórios, Sub-Bacias,
    // Derivações e Demandas.
    // Os valores que "ID" poderá assumir são:
    //   "PC", "Reservatorio", "Sub-Bacia", "Derivacao", "Demanda" ou diretamante o nome
    //   das classes dos objetos, por exemplo, "Txx_PC", ""Txx_RES".
    // "Pos" é a posição na tela onde o objeto será criado.
    function CriarObjeto(const ID: String; Pos: ImoPoint): THidroComponente; virtual;

    // Verifica se o projeto ja foi salvo, isto é, (NomeArquivo <> '')
    // Se não foi salvo gera uma exceção.
    procedure VerificarSeSalvo;

    // Verifica se o projeto possui uma camada em branco (Null_Layer.shp)
    function VerificarSePossuiCamadaEmBranco: Boolean;

    // Se um projeto esta salvo, retorna o caminho deste no formato:
    // x:\xxx\...\xxx\
    function ObterDiretorioDoProjeto: String;

    // Métodos de arquivo
    procedure LerDoArquivo(Ini: TIF; const Secao: String); Overload; Override;
    procedure LerDoArquivo(const Nome: String; SomenteRede: Boolean); Overload;
    procedure SalvarEmArquivo(Arquivo: TIF); Overload; Override;
    procedure SalvarEmArquivo(const Nome: String); Overload;

    // Métodos Iterativos
    procedure PercorreSubBacias(ITSB: TProcPSB; Lista: TList = nil);
    procedure PercorreDemandas(ITDM: TProcPDM; Lista: TList = nil);

    // Métodos da simulação
    procedure GerarArquivoPropagarDOS(NomeArquivo: String = '');
    function  RealizarDiagnostico(Completo: Boolean = False): Boolean;
    procedure Executar;
    procedure TerminarSimulacao;

    // Métodos de relatório
    procedure RelatorioGeral;
    procedure AutoDescricao(Identacao: byte); override;

    // Métodos que mostram resultados ou dialogos
    procedure MostrarMatrizDeContribuicao;
    procedure MostrarFalhasNoAtendimentoDasDemandas;
    procedure MostrarIntervalos;

    // Verifica se existem Intervalos de Análise
    procedure VerificarIntervalosDeAnalise;

    {Realiza somente a validação dos dados (Erros Fatais)
     Regra: A variável TudoOk deverá ser inicializada em TRUE}
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;

    {O método a seguir tem por objetivo determinar um valor que sirva para avaliação da
     performance do sistema.}
    function CalculaFuncaoObjetivo: Real;

    // Realiza o Balanço Hídrico até o PC determinado, incluíndo ele.
    // Os PCs deverão estar ordenados, isto é, respeitando as regras de hierarquia.
    procedure RealizarBalancoHidricoAte(PC: TprPCP);

    // Retorna uma lista com as referencias a todos os PCs que estao a montante de um determinado
    // PC, inclusive ele.
    // Os PCs deverão estar ordenados, isto é, respeitando as regras de hierarquia.
    function  ObtemSubRede(PC: TprPCP): TStrings;

    // Métodos dos objetos da rede
    function TrechoPeloNome(const Nome: String): TprTrechoDagua;
    function SubBaciaPeloNome(const Nome: String): TprSubBacia;
    function DemandaPeloNome(const Nome: String): TprDemanda;
    function PCPeloNome(const Nome: String): TprPCP;
    function PCsEntreDois(const NomePC1, NomePC2: String): TStrings;

    // Versão do projeto
    property Version: Single read FVersion;

    // Indica que na leitura de um arquivo queremos ler somente a
    // rede hidrológica, ignorando as informações das camadas.
    property LerSomenteRede: Boolean read FLerSomenteRede;

    // Mapa (fundo da Janela)
    property Map : TMapEx read FMap;
    property Escala : Integer read FMap_Escala write FMap_Escala;

    property IntervaloDeSimulacao    : TEnumIntSim        read FIntSim    write FIntSim;
    property TotalAnual_IntSim       : Integer            read getTAIS;
    property TotalMensal_IntSim      : Integer            read getTMIS;
    property Total_IntSim            : Integer            read FTotal_IntSim;
    property Data                    : TRec_prData        read getData;
    property NumAnosDeExecucao       : Integer            read getNumAnos;
    property DeltaT                  : Integer            read FDeltaT    write FDeltaT;
    property AnosDeExecucao          : TaRecIntervalos    read FAnos      write FAnos;
    property ArqVazoes               : String             read FArqVazoes write FArqVazoes;
    property ArqDPS                  : String             read FArqDPS    write FArqDPS;
    property ArqDSS                  : String             read FArqDSS    write FArqDSS;
    property ArqDTS                  : String             read FArqDTS    write FArqDTS;
    property ArqAR                   : String             read FArqAR     write FArqAR;
    property ArqEG                   : String             read FArqEG     write FArqEG;
    property DirSai                  : String             read FDirSai    write FDirSai;
    property DirTrab                 : String             read getDirTrab write FDirTrab;
    property PCs                     : TListaDePCs        read FPCs       write FPCs;
    property TipoImpressao           : byte               read FTI        write FTI;
    property TipoSimulacao           : TEnumTipoSimulacao read FTS;
    property NivelDeFalha            : Real               read FNF        write FNF;
    property PropDOS                 : String             read FPropDOS   write FPropDOS;
    property ValorFO                 : Real               read FValorFO   write FValorFO;
    property Intervalos              : TListaDeIntervalos read FInts;
    property GlobalObjects           : TGlobalObjects     read FGlobalObjects;

    property ClassesDeDemanda   : TListaDeClassesDemanda read FClasDem;
    property NomeArquivo        : String                 read FNomeArquivo   write FNomeArquivo;
    property Modificado         : Boolean                read FModificado    write FModificado;
    property AreaDeProjeto      : TForm                  read FAreaDeProjeto write FAreaDeProjeto;
    property Simulador          : TSimulation            read FSimulador;
    property Status             : TStatusProjeto         read FStatus;

    property Scripts            : TStrings               read FScripts;

    // Para Debug
    property ScriptCorrente     : TPascalScript  read FSC write FSC;
    property ExecucaoCorrente   : String         read FEC write FEC;

    // eventos
    property Evento_InicioSimulacao  : TNotifyEvent read  FEvento_InicioSimulacao
                                                    write FEvento_InicioSimulacao;

    property Evento_FimSimulacao     : TNotifyEvent read  FEvento_FimSimulacao
                                                    write FEvento_FimSimulacao;
  end;

  // Classe que utiliza o mecanismo de otimização "Rosenbrock"
  TprProjeto_Rosen = Class(TprProjeto)
  private
    FRosenbrock             : TRosenbrock;
    FIndSimulacao           : Integer;        // Simulação corrente (índice)
    FCaption                : String;         // auxiliar temporário

    FIniRosenbrockUsuario   : String;
    FFimRosenbrockUsuario   : String;
    FGeralRosenbrockUsuario : String;

    FIniRosenbrockScript   : TPascalScript;
    FFimRosenbrockScript   : TPascalScript;
    FGeralRosenbrockScript : TPascalScript;

    // Rotinas conectadas ao objeto Rosenbrock
    function  Rosen_GeralFunction(Params: TrbParameters): Real;
    procedure ExecutarRotinaDeInicializacao;
    procedure ExecutarRotinaDeFinalizacao;

    // métodos do mecanismo de simulação adaptados para otimização
    procedure ExecutarSimulacao; override;

    // mecanismo de Otimizacao
    procedure DispararOtimizacao;
    procedure IniciarOtimizacao;
    procedure FinalizarOtimizacao;

    procedure SalvarEmArquivo(Arquivo: TIF); Override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Override;

    function ReceiveMessage(Const MSG: TadvMessage): Boolean; override;

    // Edição e validação dos dados
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriaDialogo: TprDialogo_Base; Override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TErros_DLG;
                              Completo: Boolean = False); Override;
  public
    constructor Create(UmaTabelaDeNomes: TStrings; AreaDeProjeto: TForm);
    destructor  Destroy; Override;

    procedure Otimizar;
    procedure TerminarOtimizacao;

    property IndiceSimulacao : Integer     read FIndSimulacao;
    property Rosenbrock      : TRosenbrock read FRosenbrock;
  end;

  // Gera uma excessão de método não implementado
  procedure NaoImplementado(const Metodo, Classe: String);

  // Converte um intervalo (Delta T) para uma data do propagar (mes/ano) em string
  Function IntervaloToStrData(Projeto: TprProjeto; Intervalo: Integer): String;

  // Retorna os intervalos entre as datas iniciais e finais inclusive
  Function IntervalosDo(p: TprProjeto; di, df: TDate): TIntegerList;

implementation
uses Variants,Dialogs, ImgList, FileCTRL, edit,Math, Execfile, stDate,
     pr_AreaDeProjeto,
     pr_Funcoes,
     pr_Util,
     pr_Vars,
     pr_Gerenciador,
     wsVec,
     WinUtils,
     FileUtils,
     pr_Dialogo_FalhasDeUmPC,
     pr_Dialogo_PlanilhaBase,
     Planilha_DadosDosObjetos,
     pr_Dialogo_Grafico_PCs_XTudo,
     pr_Dialogo_Grafico_PCsRes_XTudo,
     pr_Dialogo_Intervalos,
     pr_Dialogo_MatContrib,
     pr_Dialogo_Planilha_FalhasDasDemandas;

// Realiza um type-casting, só isso
Function AP(F: TForm): TprDialogo_AreaDeProjeto;
begin
  Result := TprDialogo_AreaDeProjeto(F);
end;

// Gera uma excessão de método não implementado
procedure NaoImplementado(const Metodo, Classe: String);
begin
  raise Exception.CreateFmt(cMsgErro07, [Metodo, Classe]);
end;

Function IntervaloToStrData(Projeto: TprProjeto; Intervalo: Integer): String;
var d: TRec_prData;
    temp: Integer;
begin
  temp := Projeto.DeltaT;
  Projeto.DeltaT := Intervalo;
  d := Projeto.Data;
  Result := Format('%2d/%4d', [d.Mes, d.Ano]);
  Projeto.DeltaT := temp;
end;

Function IntervalosDo(p: TprProjeto; di, df: TDate): TIntegerList;
var daux: TDate;
    i: Integer;
    d: TRec_prData;
begin
  Result := TIntegerList.Create;
  for i := 1 to p.Total_IntSim do
    begin
    p.DeltaT := i;
    d := p.Data;
    daux := EncodeDate(d.Ano, d.Mes, 01);
    if (dAux >= di) and (daux < df) then Result.Add(i);
    end;
end;

{ TListaDeObjetos }

function TListaDeObjetos.Adicionar(Objeto: THidroComponente): Integer;
begin
  Result := FList.Add(Objeto);
end;

constructor TListaDeObjetos.Create;
begin
  Inherited Create;
  FList := TList.Create;
end;

procedure TListaDeObjetos.Deletar(Indice: Integer);
begin
  FList.Delete(Indice);
end;

destructor TListaDeObjetos.Destroy;
var i: Integer;
begin
  if FLiberarObjetos then
     for i := 0 to FList.Count-1 do THidroComponente(FList[i]).Free;

  FList.Free;
  Inherited Destroy;
end;

function TListaDeObjetos.getNumObjetos: Integer;
begin
  Result := FList.Count;
end;

function TListaDeObjetos.getObjeto(index: Integer): THidroComponente;
begin
  Result := THidroComponente(FList[index]);
end;

function TListaDeObjetos.IndiceDo(Objeto: THidroComponente): Integer;
begin
  Result := FList.IndexOf(Objeto);
end;

procedure TListaDeObjetos.Ordenar(FuncaoDeComparacao: TListSortCompare);
begin
  FList.Sort(FuncaoDeComparacao);
end;

function TListaDeObjetos.Remover(Objeto: THidroComponente): Integer;
begin
  Result := FList.Remove(Objeto);
end;

procedure TListaDeObjetos.RemoverNulos;
begin
  FList.Pack;
end;

procedure TListaDeObjetos.setObjeto(index: Integer; const Value: THidroComponente);
begin
  if FList.Count > 0 then
     FList[index] := Value;
end;

{ TListaDePCs }

constructor TListaDePCs.Create;
begin
  Inherited Create;
  FList := TListaDeObjetos.Create;
end;

destructor TListaDePCs.Destroy;
var i: Integer;
begin
  for i := 0 to FList.Objetos-1 do
    begin
    PC[i].DesconectarObjetos;
    PC[i].Free;
    end;

  FList.Free;
  Inherited Destroy;
end;

function TListaDePCs.Adicionar(PC: TprPCP): Integer;
begin
  PC.Modificado := True;
  Result := FList.Adicionar(PC);
end;

function TListaDePCs.Remover(PC: TprPCP): boolean;
var PS  : TprPCP; // PC seguinte
    i   : Integer;
begin
  Result := False;

  if PC.PossuiObjetosConectados then
     MessageDLG('Primeiro remova todos os objetos conectados a este PC.',
                 mtInformation, [mbOK], 0)
  else
     begin
     PS := PC.PC_aJusante;

     if PS <> nil then
        begin
        PS.DesconectarPC_aMontante(PC);
        for i := 0 to PC.PCs_aMontante - 1 do
           PC.PC_aMontante[i].ConectarObjeto(PS);
        end
     else
        while PC.PCs_aMontante > 0 do
           PC.PC_aMontante[0].RemoverTrecho;

     FList.Remover(PC);
     PC.DesconectarObjetos;
     PC.Free;
     CalcularHierarquia;
     Result := True;
     end;
end;

function TListaDePCs.GetNumPCs: Integer;
begin
  Result := FList.Objetos;
end;

function TListaDePCs.GetPC(Index: Integer): TprPCP;
begin
  try
    Result := TprPCP(FList[Index]);
  except
    Raise Exception.Create('Índice de PC inválido: ' + IntToStr(Index));
  end;
end;

procedure TListaDePCs.CalcularHierarquia;
var i, k: Integer;
    PC: TprPCP;
begin
  for i := 0 to PCs-1 do
    if Self.PC[i].PCs_aMontante = 0 then
       begin
       k := 1;
       PC := Self.PC[i];
       PC.Hierarquia := k;
       while PC.PC_aJusante <> nil do
         begin
         inc(k);
         PC := PC.PC_aJusante;
         if PC.Hierarquia < k then PC.Hierarquia := k;
         end;
       end;
end;

function FuncaoDeComparacao(pc1, pc2: Pointer): Integer;
begin
  Result := TprPCP(pc1).Hierarquia - TprPCP(pc2).Hierarquia;
end;

procedure TListaDePCs.Ordenar;
begin
  FList.Ordenar(FuncaoDeComparacao);
end;

function TListaDePCs.IndiceDo(PC: TprPCP): Integer;
begin
  Result := FList.IndiceDo(PC);
end;

procedure TListaDePCs.SetPC(index: Integer; const Value: TprPCP);
begin
  try
    FList[Index] := Value;
  except
    Raise Exception.Create('Índice de PC inválido: ' + IntToStr(Index));
  end;
end;

{ THidroComponente }

constructor THidroComponente.Create(UmaTabelaDeNomes: TStrings; Projeto: TprProjeto);
begin
  inherited Create;

  FAvisarQueVaiSeDestruir := True;

  FProjeto      := Projeto;
  FTN           := UmaTabelaDeNomes;
  FNome         := ObtemNome;
  FComentarios  := TStringList.Create;

  if not (self is TprProjeto) then
     FEventoDeMonitoracao := AP(Projeto.AreaDeProjeto).Monitor.Monitorar;

  GetMessageManager.RegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.RegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_INICIAR_SIMULACAO, self);
  GetMessageManager.RegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.RegisterMessage(UM_CoordinateSystem_Changed, Self);

  if FTN <> nil then FTN.Add(FNome);
  AtualizaHint;
end;

destructor THidroComponente.Destroy;
var i: Integer;
begin
  FComentarios.Free;

  GetMessageManager.UnRegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.UnRegisterMessage(UM_INICIAR_SIMULACAO, self);
  GetMessageManager.UnRegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.UnRegisterMessage(UM_CoordinateSystem_Changed, Self);

  i := FTN.IndexOf(FNome);
  if i > -1 then FTN.Delete(i);

  FImagemDoComponente.Free;
  Inherited Destroy;
end;

{
A rotina abaixo está completa, mas faz mais do que o necessário. Ela calcula
o enégimo período, que para o cálculo dos dias do último período não há
necessidade. A única coisa necessária é saber se estamos ou não no último.
}
function THidroComponente.DiasNoIntervalo: Integer;
const NumDiasNornais: Array[isQuinquendial..isQuinzenal] of byte = ( 5,  7, 10, 15);
      UDPI          : Array[isQuinquendial..isQuinzenal] of byte = (25, 21, 20, 15);

var N         : byte;
    D         : TRec_prData;
    DiasNoMes : byte;
begin
  D := FProjeto.Data;
  DiasNoMes := DaysInMonth(D.Mes, D.Ano, 0);

  // Obtém o número de períodos de um mês
  N := caNumIntSimMes[FProjeto.IntervaloDeSimulacao];

  // Obtém o enégimo período do mês corrente
  case FProjeto.IntervaloDeSimulacao of
    isQuinquendial, isSemanal, isDecendial:
      if FProjeto.DeltaT mod N = 0 then
         Result := N
      else
         begin
         Result := FProjeto.DeltaT - (FProjeto.DeltaT div N * N);
         end;

    isQuinzenal:
      if FProjeto.DeltaT mod N = 0 then Result := N else Result := 1;

    isMensal:
      begin
      Result := DiasNoMes;
      Exit; // Já possui o número de dias do período, neste caso um mês
      end;
  end;

  // Calcula o número de dias do período encontrado
  if Result = N then
     Result := DiasNoMes - UDPI[FProjeto.IntervaloDeSimulacao]
  else
     Result := NumDiasNornais[FProjeto.IntervaloDeSimulacao];
end;

procedure THidroComponente.Monitorar;
begin
  // nada
end;

procedure THidroComponente.DefinirVariaveisQuePodemSerMonitoradas(const Variaveis: array of String);
var i: Integer;
begin
  for i := 0 to High(Variaveis) do
    if (FVarsQuePodemSerMonitoradas = '') and (i = 0) then
       FVarsQuePodemSerMonitoradas := Variaveis[0]
    else
       FVarsQuePodemSerMonitoradas := FVarsQuePodemSerMonitoradas + ';' + Variaveis[i];
end;

procedure THidroComponente.MotitorarVariaveis(const Variaveis: array of String);
var i: Integer;
begin
  for i := 0 to High(Variaveis) do
    if (FVarsMonitoradas = '') and (i = 0) then
       FVarsMonitoradas := Variaveis[0]
    else
       FVarsMonitoradas := FVarsMonitoradas + ';' + Variaveis[i];
end;

procedure THidroComponente.SetModificado(const Value: Boolean);
begin
  FModificado := Value;
  if FProjeto <> nil then FProjeto.FModificado := Value;
end;

function THidroComponente.Optimizer_getValue(const PropName: string; Year, Month: Integer): real;
begin
  // se chegou a este nível então é porque não encontrou a propriedade
  OptimizerError(PropName, ClassName);
end;

procedure THidroComponente.Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real);
begin
  // se chegou a este nível então é porque não encontrou a propriedade
  OptimizerError(PropName, ClassName);
end;

function THidroComponente.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
    s: String;
    p: TPoint;
begin
  if MSG.ID = UM_RESET_VISIT then
     Visitado := False
  else

  if MSG.ID = UM_OBTEM_OBJETO then
     {Verifica se o nome do objeto atual bate com o parâmetro passado.
      Se opcionalmente um terceiro parâmetro for passado (projeto) verificamos
      se este objeto pertence a este projeto.}
     begin
     s := MSG.ParamAsString(0);

     if (CompareText(s, Nome) = 0) then
        if MSG.ParamCount = 3 then
           if MSG.ParamAsObject(2) = FProjeto then
              pRecObjeto(MSG.ParamAsObject(1)).Obj := Self
           else
              {nada}
        else
           pRecObjeto(MSG.ParamAsObject(1)).Obj := Self
     end else

    if MSG.ID = UM_INICIAR_SIMULACAO then
       begin
       if (MSG.ParamAsObject(0) = FProjeto) then
          PrepararParaSimulacao;
       end
   else

   if MSG.ID = UM_CoordinateSystem_Changed then
      if FImagemDoComponente <> nil then
         begin
         p := FImagemDoComponente.Center;
         SetPos(FProjeto.PointTo_moPoint(p));
         end;

end;

function THidroComponente.MostrarDialogo: Integer;
var i: Integer;
begin
  if FProjeto.Simulador <> nil then Exit; 

  Result := mrNone;
  Dialogo := CriaDialogo;
  Dialogo.Objeto := Self;

  i := FTN.IndexOf(FNome);
  if i <> -1 then FTN.Delete(i);
  Try
    PorDadosNoDialogo(Dialogo);
    Dialogo.Hide;
    Result := Dialogo.ShowModal;
    if (Result = mrOk) then
       begin
       SetModificado(True);
       PegarDadosDoDialogo(Dialogo);
       end;
  Finally
    if i <> -1 then FTN.Add(FNome);
    Dialogo.Free;
    Dialogo := nil;
  End;
end;

procedure THidroComponente.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  d.edNome.Text       := FNome;
  d.edDescricao.Text  := FDescricao;
  d.mComentarios.Text := FComentarios.Text;
end;

procedure THidroComponente.PegarDadosDoDialogo(d: TprDialogo_Base);
var s: String;
begin
  if FDescricao <> d.edDescricao.Text then
     begin
     FDescricao := d.edDescricao.Text;
     GetMessageManager.SendMessage(UM_DESCRICAO_OBJETO_MUDOU, [Self]);
     end;

  if FComentarios.Text <> d.mComentarios.Text then
     begin
     FComentarios.Text := d.mComentarios.Text;
     GetMessageManager.SendMessage(UM_COMENTARIO_OBJETO_MUDOU, [Self]);
     end;

  if FNome <> d.edNome.Text then
     begin
     s := FNome;
     FNome := d.edNome.Text;
     GetMessageManager.SendMessage(UM_NOME_OBJETO_MUDOU, [Self, @s, @FNome]);
     end;

  AtualizaHint;
end;

procedure THidroComponente.DuploClick(Sender: TObject);
begin
  FProjeto.VerificarSeSalvo();
  MostrarDialogo;
end;

procedure THidroComponente.SalvarEmArquivo(Arquivo: TIF);
var s: String;
    p: Types.TPoint;
begin
  with Arquivo do
    begin
    WriteString  (Section, 'Classe'     , Self.ClassName);
    WriteString  (Section, 'Nome'       , FNome);
    WriteString  (Section, 'Descricao'  , FDescricao);

    { Isto é necessário devido a um possível bug em (TStrings.CommaText).
      Quando tentamos atribuir uma string no formato ["aaaaaa bbbb ccccc"] ele
      se perde. Se houver uma única (,) no final, isto já é suficiente para o
      erro não acontecer. Ex: ["aaaaa bbbb cccc",]}
    s := FComentarios.CommaText;
    if Length(s) > 0 then
       if s[Length(s)] <> ',' then s := s + ',';
    WriteString(Section, 'Comentarios', s);

    if FImagemDoComponente <> nil then
       begin
       p := getScreenPos();
       WriteFloat (Section, 'x', FPos.x);
       WriteFloat (Section, 'y', FPos.y);
       WriteInteger (Section, 'ScreenPos_x', p.x);
       WriteInteger (Section, 'ScreenPos_x', p.y);
       end;
    end;
end;

function THidroComponente.Section: String;
begin
  Result := 'Dados ' + FNome;
end;

procedure THidroComponente.SetNome(const Value: String);
begin
  if CompareText(Value, FNome) <> 0 then
     begin
     FTN.Delete(FTN.IndexOf(FNome));
     FNome := Value;
     FTN.Add(FNome);
     end;
end;

function THidroComponente.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_Base.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

function THidroComponente.ObtemNome: String;
var i: Integer;
    Prefixo: String;
begin
  if FTN <> nil then
     begin
     i := 0;
     Prefixo := ObtemPrefixo;
     repeat
       inc(i);
       Result := Prefixo + IntToStr(i);
       until FTN.IndexOf(Result) = -1
     end;
end;

function THidroComponente.ObtemPrefixo: String;
begin
  Result := 'Proj_';
end;

procedure THidroComponente.Diagnostico(var TudoOk: Boolean; Completo: Boolean = False);
begin
  ValidarDados(TudoOk, gErros, Completo);
end;

procedure THidroComponente.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
begin
  // Nada por enquanto
end;

procedure THidroComponente.CriarComponenteVisual(Pos: ImoPoint);
begin
  FPos := coPoint.Create;

  FImagemDoComponente := CriarImagemDoComponente;
  if FImagemDoComponente <> nil then
     begin
     FImagemDoComponente.Tag         := Integer(self);
     FImagemDoComponente.Parent      := FProjeto.Map;
     FImagemDoComponente.OnMouseDown := AP(FProjeto.AreaDeProjeto).Map_MouseDown;
     FImagemDoComponente.OnMouseMove := AP(FProjeto.AreaDeProjeto).Map_MouseMove;
     FImagemDoComponente.OnMouseUp   := AP(FProjeto.AreaDeProjeto).Map_MouseUp;
     FImagemDoComponente.OnClick     := AP(FProjeto.AreaDeProjeto).Map_Click;
     FImagemDoComponente.OnDblClick  := DuploClick;
     if pos <> nil then
        begin
        FPos.X := Pos.X;
        FPos.Y := Pos.Y;
        SetPos(FPos);
        end;
     end
  else
     NaoImplementado('CriarImagemDoComponente', ClassName);
end;

procedure THidroComponente.LerDoArquivo(Ini: TIF; Const Secao: String);
var p: ImoPoint;
    sp: Types.TPoint;
begin
  FNome                  := Ini.ReadString(Secao, 'Nome', '');;
  FDescricao             := Ini.ReadString(Secao, 'Descricao', '');
  FComentarios.CommaText := Ini.ReadString(Secao, 'Comentarios', '');

  if FImagemDoComponente <> nil then
     begin
     p := gmoPoint;
     
     p.x := Ini.ReadFloat(Secao, 'X', 0);
     p.y := Ini.ReadFloat(Secao, 'Y', 0);

     if FProjeto.Version < 3.0 then
        p := FProjeto.PointTo_moPoint(Types.Point(Trunc(p.x), Trunc(p.y)))
     else
        if FProjeto.LerSomenteRede then
           begin
           sp.x := Ini.ReadInteger(Secao, 'ScreenPos_x', 0);
           sp.y := Ini.ReadInteger(Secao, 'ScreenPos_y', 0);
           p := FProjeto.PointTo_moPoint(sp);
           end;

     SetPos(p);
     end;

  AtualizaHint;
end;

function THidroComponente.GetPos: ImoPoint;
begin
  if FImagemDoComponente <> nil then
     Result := FPos
  else
     Result := nil;
end;

function THidroComponente.GetRect: TRect;
begin
  if FImagemDoComponente <> nil then
     with FImagemDoComponente do
        Result := Classes.Rect(Left, Top, Left + Width, Top + Height)
  else
     Result := Rect(0, 0, 0, 0);
end;

procedure THidroComponente.SetPos(const Value: ImoPoint);
var p: TPoint;
begin
  if FImagemDoComponente <> nil then
     begin
     SetModificado(True);

     FPos.x := Value.x;
     FPos.y := Value.y;

     p := GetScreenPos();
     FImagemDoComponente.SetBounds(
       p.x - FImagemDoComponente.Width  div 2,
       p.y - FImagemDoComponente.Height div 2,
       FImagemDoComponente.Width,
       FImagemDoComponente.Height);
     end;
end;

procedure THidroComponente.AtualizaHint;
var s: String;
begin
  if FImagemDoComponente <> nil then
     begin
     s := FNome;
     if FComentarios.Count > 0 then s := s + #13#10 + FComentarios.Text;
     FImagemDoComponente.Hint := s;
     end;
end;

procedure THidroComponente.PrepararParaSimulacao;
begin
  //nada
end;

procedure THidroComponente.MostrarMenu(x, y: Integer);
var p, p2: TPoint;
begin
  if FMenu <> nil then
     begin
     PrepararMenu;
     if x <> -1 then
        FMenu.Popup(x, y)
     else
        begin
        p  := FProjeto.Map.ClientToScreen(Types.Point(0, 0));
        p2 := GetScreenPos();
        FMenu.Popup(p.x + p2.x, p.y + p2.y);
        end;
     end;
end;

procedure THidroComponente.MostrarPlanilha;
var d: TForm_Planilha_DadosDosObjetos;
    i: Integer;
    x: TRec_prData;
begin
  d := TForm_Planilha_DadosDosObjetos.Create(FProjeto.AreaDeProjeto);
  d.FormStyle := fsMDIChild;
  d.Caption := 'Dados do(a) ' + Nome;
  d.Show;

  d.Tab.TextRC[1, 1] := 'Mes/Ano (Int)';

  for i := 1 to FProjeto.Total_IntSim do
    begin
    FProjeto.DeltaT := i;
    x := FProjeto.Data;
    d.Tab.TextRC[i+1, 1] := Format('   %2d/%d (%d)', [x.Mes, x.Ano, i]);
    end;

  StartWait;
  try
    ColocaDadosNaPlanilha(d);
  finally
    StopWait;
  end;
end;

// Cria uma janela default e faz as primeiras inicializações
function THidroComponente.CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TgrGrafico;
begin
  FProjeto.VerificarIntervalosDeAnalise;

  Result := TgrGrafico.Create;
  Result.FormStyle := fsMDIChild;
  Result.Grafico.Title.Text.Add(Titulo);

  if FProjeto.Intervalos.Nome[Intervalo] <> '' then
     Result.Grafico.Title.Text.Add(FProjeto.Intervalos.Nome[Intervalo]);

  Result.Caption := Format(' Projeto %s - [%s a %s]',
     [FProjeto.Nome,
      FProjeto.Intervalos.sDataIni[Intervalo],
      FProjeto.Intervalos.sDataFim[Intervalo]]);
end;

procedure THidroComponente.DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);
var i: integer;
begin
  for i := 0 to FProjeto.Intervalos.IntFim[Intervalo] - FProjeto.Intervalos.IntIni[Intervalo] do
    if i < Serie.Labels.Count then
       Serie.XLabel[i] := intToStr(FProjeto.Intervalos.IntIni[Intervalo] + i);
end;

function THidroComponente.ObterDataSet(Dados: TV): TwsDataSet;
var i, j, k, ii: integer;
    v: TV;
    //p: TprProjeto;
begin
  //p := TprDialogo_AreaDeProjeto(FProjeto).Projeto;

  // Criação da estrutura do Conjunto de dados: Anos X Intervalos Anuais
  ii := FProjeto.TotalAnual_IntSim;
  Result := TwsDataSet.Create('DS_' + Nome);
  for i := 1 to ii do
    Result.Struct.AddNumeric('_'+ intToStr(i) +'_', '');

  // Preenchimento do Conjunto
  k := 1;
  for i := 1 to FProjeto.NumAnosDeExecucao do
    begin
    FProjeto.DeltaT := k;
    v := TV.Create(ii);
    v.Name := intToStr(FProjeto.Data.Ano);
    for j := 1 to ii do
      begin
      v[j] := Dados[k];
      inc(k);
      end; // for j
    Result.MAdd(v);
    end; // for i
end;

procedure THidroComponente.MostrarDataSet(const Titulo: String; Dados: TwsDataSet);
var d    : TprDialogo_PlanilhaBase;
    i, j : Integer;
begin
  d := TprDialogo_PlanilhaBase.Create(FProjeto.AreaDeProjeto);
  d.FormStyle := fsMDIChild;
  d.Caption := Format('Dados do(a) %s [%s]', [Nome, Titulo]);
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

procedure THidroComponente.AutoDescricao(Identacao: byte);
var s: string;
begin
  s := StringOfChar(' ', Identacao);
  gOutPut.Editor.Write (s + 'Nome : ' + FNome);
  if FDescricao <> '' then gOutPut.Editor.Write (s + 'Descrição : ' + FDescricao);
  gOutPut.Editor.WriteStringsIdent (FComentarios, s + 'Comentários : ');
  gOutPut.Editor.Write;
end;

function THidroComponente.VerificarCaminho(var Arquivo: String): Boolean;
begin
  if Arquivo <> '' then
     begin
     if not PossuiCaminho(Arquivo) then
        begin
        if FProjeto.DirTrab <> '' then
           SetCurrentDir(FProjeto.DirTrab)
        else
           SetCurrentDir(ExtractFilePath(FProjeto.NomeArquivo));

        Arquivo := ExpandFileName(Arquivo);
        end;

     Result := FileExists(Arquivo);
     end
  else
     Result := False;
end;

procedure THidroComponente.RetirarCaminhoSePuder(var Arquivo: String);
var s: String;
begin
  if PossuiCaminho(Arquivo) then
     begin
     s := ExtractFilePath(FProjeto.NomeArquivo);
     if LastChar(s) = '\' then DeleteLastChar(s);

     if CompareText(s, Arquivo) = 0 then
        Arquivo := ''
     else
        Arquivo := ExtractRelativePath(s + '\', Arquivo);
     end;
end;

procedure THidroComponente.PrepararMenu;
begin
  // Nada por enquanto
end;

procedure THidroComponente.VerificarRotinaUsuario(Arquivo: String; const Texto: String;
                                         Completo: Boolean; var TudoOk: Boolean;
                                         DialogoDeErros: TErros_DLG;
                                         FuncaoObjetivo: Boolean = False);
var PS: TPascalScript;
begin
  if Arquivo <> '' then
     if not VerificarCaminho(Arquivo) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Arquivo da rotina do Usuário (%s) não encontrado:'#13 +
               '%s', [self.Nome, Texto, Arquivo]));
        TudoOk := False;
        end
     else
        if Completo then
           begin
           PS := TPascalScript.Create;
           PS.Text.LoadFromFile(Arquivo);

           // bibliotecas
           PS.AssignLib(g_psLib);

           // Variáveis pré-inicializadas
           PS.Variables.AddVar(
             TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True));

           PS.Variables.AddVar(
             TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True));

           if FuncaoObjetivo then
              PS.Variables.AddVar(
                 TVariable.Create('FO', pvtReal, 0, TObject, True));

           // Objetos Globais
           PS.GlobalObjects := Projeto.GlobalObjects;

           PS.Compile;
           if not PS.Compiled then
              begin
              DialogoDeErros.Add(etError,
              Format('Objeto: %s'#13 + 'A rotina do Usuário (%s) contém erros.', [Nome, Texto]));
              TudoOk := False;
              end;
           PS.Free;
           end;
end;

procedure THidroComponente.PreparaScript(Arquivo: String; var Script: TPascalScript);
begin
  if Script = nil then Script := TPascalScript.Create;
  VerificarCaminho(Arquivo);
  Script.GlobalObjects := Projeto.GlobalObjects;
  with Script do
    begin
    // Bibliotecas
    AssignLib(g_psLib);

    Text.LoadFromFile(Arquivo);

    // Opções
    GerCODE  := True;
    Optimize := True;

    // Variáveis pré-inicializadas
    Variables.AddVar(
      TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True));

    Variables.AddVar(
      TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True));

    // Compile;
    end;
end;

function THidroComponente.GetScreenPos: TPoint;
begin
  Result := FProjeto.moPointToPoint(FPos)
end;

function THidroComponente.ConectarObjeto(Obj: THidroComponente): Integer;
begin
  // Nada
end;

procedure THidroComponente.DesconectarObjetos;
begin
  // Nada
end;

{ TprTrechoDagua }

constructor TprTrechoDagua.Create(PC1, PC2: TprPCP; UmaTabelaDeNomes: TStrings; Projeto: TprProjeto);
begin
  inherited Create(UmaTabelaDeNomes, Projeto);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);
  PC_aMontante := PC1;
  PC_aJusante  := PC2;
end;

function TprTrechoDagua.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_TD.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

destructor TprTrechoDagua.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);
  inherited Destroy;
end;

procedure TprTrechoDagua.LerDoArquivo(Ini: TIF; Const Secao: String);
begin
  Inherited LerDoArquivo(Ini, Secao);

  FVazaoMinima := Ini.ReadFloat (Secao, 'Vazao Minima', 0);
  FVazaoMaxima := Ini.ReadFloat (Secao, 'Vazao Maxima', 0);
end;

function TprTrechoDagua.ObtemPrefixo: String;
begin
  Result := 'TrechoDagua_';
end;

procedure TprTrechoDagua.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_TD) do
    begin
    FVazaoMinima := edVazMin.AsFloat;
    FVazaoMaxima := edVazMax.AsFloat;
    end;
end;

procedure TprTrechoDagua.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_TD) do
    begin
    edVazMin.AsFloat := FVazaoMinima;
    edVazMax.AsFloat := FVazaoMaxima;
    end;
end;

function TprTrechoDagua.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
begin
  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     if MSG.ParamAsObject(0) = PC_aJusante then
        PC_aJusante := pointer(MSG.ParamAsObject(1)) else

     if MSG.ParamAsObject(0) = PC_aMontante then
        PC_aMontante := pointer(MSG.ParamAsObject(1));
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TprTrechoDagua.SalvarEmArquivo(Arquivo: TIF);
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteString (Section, 'PM', PC_aMontante.Nome);
    WriteString (Section, 'PJ', PC_aJusante. Nome);
    WriteFloat  (Section, 'Vazao Minima', FVazaoMinima);
    WriteFloat  (Section, 'Vazao Maxima', FVazaoMaxima);
    end;
end;

procedure TprTrechoDagua.SetVazaoMaxima(const Value: Real);
begin
  FVazaoMaxima := Value;
end;

procedure TprTrechoDagua.SetVazaoMinima(const Value: Real);
begin
  FVazaoMinima := Value;
end;

procedure TprTrechoDagua.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var R1: Real; // VazaoMinima
    R2: Real; // VazaoMaxima
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if Dialogo <> nil then
     begin
     R1 := TprDialogo_TD(Dialogo).edVazMin.AsFloat;
     R2 := TprDialogo_TD(Dialogo).edVazMax.AsFloat;
     end
  else
     begin
     R1 := FVazaoMinima;
     R2 := FVazaoMaxima;
     end;

  if R1 < 0 then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Vazão Mínima inválida: %f', [Nome, R1]));
     TudoOk := False;
     end;

  if R2 < 0 then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Vazão Máxima inválida: %f', [Nome, R2]));
     TudoOk := False;
     end;
end;

{ TprPC }

constructor TprPC.Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
begin
  Inherited Create(UmaTabelaDeNomes, Projeto);

  FPCs_aMontante   := TListaDeObjetos.Create;
  FSubBacias       := TListaDeObjetos.Create;
  FDemandas        := TListaDeObjetos.Create;

  FAfluenciaSB  := TV.Create(0);
  FDefluencia   := TV.Create(0);
  FVzMon        := TV.Create(0);

  DefinirVariaveisQuePodemSerMonitoradas(['Afluencia SB', 'Defluencia', 'Vz. Mon.']);

  FHierarquia := -1;

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);

  CriarComponenteVisual(Pos);
end;

{Teoricamente, as listas deverão estar vazias}
destructor TprPC.Destroy;
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);

  FPCs_aMontante.Free;
  FSubBacias.Free;
  FDemandas.Free;
  FTD.Free;
  FVzMon.Free;
  FAfluenciaSB.Free;
  FDefluencia.Free;
  Inherited Destroy;
end;

function TprPC.AdicionaObjeto(Obj: THidroComponente): Integer;
var PC: TprPCP;
    SB: TprSubBacia;
    DM: TprDemanda;
begin
  SetModificado(True);

  // Objeto é uma Sub-Bacia ----------------------------------------------------------
  if Obj is TprSubBacia then
     begin
     SB := TprSubBacia(Obj);
     FSubBacias.Adicionar(SB);
     SB.PCs.Adicionar(Self);
     if SB.PCs.Objetos > SB.CCs.Count then
        if SB.CCs.Count = 0 then
           SB.CCs.Add(1.0)
        else
           SB.CCs.Add(0.0);
     end else

  // Objeto é uma Demanda ------------------------------------------------------------
  if Obj is TprDemanda then
     begin
     DM := TprDemanda(Obj);
     DM.Tipo := tdLocalizada;
     FDemandas.Adicionar(DM);
     end else

  // Objeto é um PC ------------------------------------------------------------------
  if Obj is TprPCP then
     begin
     PC := TprPCP(Obj);
     PC.AdicionaPC_aMontante(TprPCP(Self));
     Self.PC_aJusante := PC;
     end;
end;

procedure TprPC.LimpaObjetos;
var i, k: Integer;
begin
  For i := 0 to SubBacias - 1 Do
    if (SubBacia[i] <> nil) then
       begin
       if (SubBacia[i].PCs.Objetos = 1) then
          begin
          SubBacia[i].LimpaObjetos;
          SubBacia[i].Free;
          FSubBacias[i] := nil;
          end
       else
          begin
          k := SubBacia[i].PCs.IndiceDo(Self);
          SubBacia[i].PCs.Deletar(k);
          SubBacia[i].CCs.Delete(k);
          end;
       end;

  FSubBacias.RemoverNulos;
  For i := 0 to Demandas - 1 Do Demanda[i].Free;
end;

procedure TprPC.AdicionaPC_aMontante(PC: TprPCP);
begin
  FPCs_aMontante.Adicionar(PC);
end;

function TprPC.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
begin
  if MSG.ID = UM_OBJETO_SE_DESTRUINDO then
    {Verifica se o objeto que está se destruindo está conectado a este PC.
     Se está, elimina a referência}
     begin
     i := FSubBacias.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then
        FSubBacias[i] := nil
     else
        begin
        i := FDemandas.IndiceDo(MSG.ParamAsPointer(0));
        if i > -1 then FDemandas[i] := nil;
        end;
     end else

  if MSG.ID = UM_REPINTAR_OBJETO then
     begin
     SetPos(FPos);
     end
  else

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     i := FPCs_aMontante.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then FPCs_aMontante.Objeto[i] := MSG.ParamAsPointer(1);
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TprPC.SalvarEmArquivo(Arquivo: TIF);
var i: Integer;
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    if TrechoDagua <> nil then
       WriteString (Section, 'TD', TrechoDagua.Nome);

    WriteInteger (Section, 'SubBacias', SubBacias);
    for i := 0 to SubBacias - 1 do
       WriteString (Section, 'SB'+IntToStr(i+1), SubBacia[i].Nome);

    WriteInteger (Section, 'Demandas', Demandas);
    for i := 0 to Demandas - 1 do
       WriteString (Section, 'DM'+IntToStr(i+1), Demanda[i].Nome);
    end;
end;

procedure TprPC.SetVisivel(Value: Boolean);
begin
  FVisivel := Value;
  FImagemDoComponente.Visible := FVisivel;
end;

function TprPC.GetPCs_aMontante: Integer;
begin
  Result := FPCs_aMontante.Objetos;
end;

function TprPC.GetNumSubBacias: Integer;
begin
  FSubBacias.RemoverNulos;
  Result := FSubBacias.Objetos;
end;

function TprPC.GetPC_aJusante: TprPCP;
begin
  if FTD <> nil then
     Result := FTD.PC_aJusante
  else
     Result := nil;
end;

procedure TprPC.SetPC_aJusante(const Value: TprPCP);
begin
  if FTD <> nil then
     FTD.PC_aJusante := Value
  else
     FTD := TprTrechoDagua.Create(TprPCP(Self), Value, FTN, FProjeto);
end;

function TprPC.GetPC_aMontante(Index: Integer): TprPCP;
begin
  Result := TprPCP(FPCs_aMontante[Index]);
end;

function TprPC.GetSubBacia(index: Integer): TprSubBacia;
begin
  Result := TprSubBacia(FSubBacias[Index]);
end;

// Remove a coneccao do PC que está a montante deste PC
procedure TprPC.RemovePC_aMontante(PC: TprPCP);
begin
  FPCs_aMontante.Remover(PC);
end;

procedure TprPC.RemoveTrecho;
begin
  if FTD <> nil then
     begin
     SetModificado(True);
     FTD.PC_aJusante.RemovePC_aMontante(FTD.PC_aMontante);
     FTD.Free;
     FTD := nil;
     end;
end;

function TprPC.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrRectangle.Create(nil);
  Result.Width := 10;
  Result.Height := 10;
end;

function TprPC.GetDemanda(index: Integer): TprDemanda;
begin
  Result := TprDemanda(FDemandas[Index]);
end;

function TprPC.GetNumDemandas: Integer;
begin
  FDemandas.RemoverNulos;
  Result := FDemandas.Objetos;
end;

function TprPC.Eh_umPC_aMontante(PC: THidroComponente): Boolean;
begin
  Result := (FPCs_aMontante.IndiceDo(PC) > -1);
end;

procedure TprPC.PrepararParaSimulacao;
var i, j: integer;
begin
  inherited PrepararParaSimulacao;

  FAfluenciaSB.Len := FProjeto.Total_IntSim;
  FAfluenciaSB.Fill(0);

  FVzMon.Len := FAfluenciaSB.Len;

  if FProjeto.TipoSimulacao = tsWIN then
     FDefluencia.Len := FAfluenciaSB.Len;
end;

procedure TprPC.ColocaDadosNaPlanilha(Planilha: TForm);
var i: Integer;
begin
  with TForm_Planilha_DadosDosObjetos(Planilha).Tab do
    begin
    TextRC[1, 2] := 'Vz.Mon';
    TextRC[1, 3] := 'Aflu.SB';
    TextRC[1, 4] := 'Vz. TOT';
    TextRC[1, 5] := 'Deflu';
    for i := 1 to FVzMon.Len       do NumberRC[i+1, 2] := FVzMon[i];
    for i := 1 to FAfluenciaSB.Len do NumberRC[i+1, 3] := FAfluenciaSB[i];
    for i := 1 to FAfluenciaSB.Len do NumberRC[i+1, 4] := FAfluenciaSB[i] + FVzMon[i];
    for i := 1 to FDefluencia.Len  do NumberRC[i+1, 5] := FDefluencia[i];
    end;
end;

procedure TprPC.MostrarVariavel(const NomeVar: String);
var v: TV;
    d: TwsDataSet;
begin
  v := nil;
  if CompareText(NomeVar, 'AfluenciaSB') = 0 then v := AfluenciaSB else
  if CompareText(NomeVar, 'Defluencia' ) = 0 then v := Defluencia else
  if CompareText(NomeVar, 'VazMontante') = 0 then v := VazMontante;
  if (v <> nil) and (v.Len > 0) then
     begin
     d := ObterDataSet(v);
     MostrarDataSet(NomeVar, d);
     d.Free;
     end;
end;

procedure TprPC.AutoDescricao(Identacao: byte);
var s, s2: String;
    i    : Integer;
begin
  inherited;
  s  := StringOfChar(' ', Identacao);
  s2 := s + StringOfChar(' ', 4);

  with gOutPut.Editor do
    begin
    if TrechoDagua <> nil then
       begin
       Write (s + 'Trecho-Dagua : ' + TrechoDagua.Nome);
       Write;
       end;

    Write   (s + 'Sub-Bacias : ');
    for i := 0 to SubBacias - 1 do Write(s2 + SubBacia[i].Nome);
    Write;

    Write   (s + 'Demandas : ');
    for i := 0 to Demandas - 1 do Write(s2 + Demanda[i].Nome);
    Write;
    end;
end;

function TprPC.ObtemVazaoAfluenteSBs: Real;
var i: Integer;
begin
  // SubBacia.ObtemVazaoAfluente depende do deltaT atual do projeto
  Result := 0;
  for i := 0 to SubBacias-1 do
    Result := Result + SubBacia[i].ObterVazaoAfluente(TprPCP(Self));
end;

procedure TprPC.Monitorar;
var i: Integer;
begin
  inherited;

  if Assigned(FEventoDeMonitoracao) then
     begin
     i := FProjeto.DeltaT;

     if System.Pos('Afluencia SB', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Afluencia SB', FAfluenciaSB[i]);

     if System.Pos('Defluencia', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Defluencia', FDefluencia[i]);

     if System.Pos('Vz. Mon.', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Vz. Mon.', FVzMon[i]);
     end;
end;

{ TprPCP }

constructor TprPCP.Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(Pos, Projeto, UmaTabelaDeNomes);

  FRendiGera := 0.93;
  FRendiAduc := 0.97;
  FRendiTurb := 0.90;

  GetMessageManager.RegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.RegisterMessage(UM_LIBERAR_SCRIPTS, self);

  FDPA := TV.Create(0);
  FDSA := TV.Create(0);
  FDTA := TV.Create(0);

  FDPT := TV.Create(0);
  FDST := TV.Create(0);
  FDTT := TV.Create(0);

  FDPP := TV.Create(0);
  FDSP := TV.Create(0);
  FDTP := TV.Create(0);

  FEG := TV.Create(0);
  FCurvaDemEnergetica := TV.Create(0);

  DefinirVariaveisQuePodemSerMonitoradas(['DPA', 'DSA', 'DTA',
                                          'DPT', 'DST', 'DTT',
                                          'DPP', 'DSP', 'DTP',
                                          'EG' , 'Curva Dem. EG']);

  FMDs := True;
end;

// Cria um reservatorio e copia os dados para ele
function TprPCP.MudarParaReservatorio(UmMenu: TPopupMenu): TprPCPR;
begin
  Result := TprPCPR.Create(FPos, FProjeto, nil);
  Result.FTN := FTN;
  Result.Menu := UmMenu;
  GetMessageManager.SendMessage(UM_TROCAR_REFERENCIA, [Self, Result]);
  CopiarPara(Result);
end;

procedure TprPCP.SalvarEmArquivo(Arquivo: TIF);
begin
  Inherited SalvarEmArquivo(Arquivo);

  Arquivo.WriteBool   (Section, 'Mostrar Demandas', FMDs);
  Arquivo.WriteInteger(Section, 'Cor', Integer(FImagemDoComponente.Canvas.Brush.Color));

  // Trecho dágua do PC
  if (FTD <> nil) then FTD.SalvarEmArquivo(Arquivo);

  // Geração de Energia
  Arquivo.WriteBool  (Section, 'Executar Energia Padrao', FExecutarEnergiaPadrao);
  Arquivo.WriteBool  (Section, 'GerarEnergia',            FGerarEnergia);
  Arquivo.WriteFloat (Section, 'RendiGera',               FRendiGera);
  Arquivo.WriteFloat (Section, 'QMaxTurb',                FQMaxTurb);
  Arquivo.WriteFloat (Section, 'RendiAduc',               FRendiAduc);
  Arquivo.WriteFloat (Section, 'RendiTurb',               FRendiTurb);
  Arquivo.WriteFloat (Section, 'DemEnergetica',           FDemEnergetica);
  Arquivo.WriteFloat (Section, 'QuedaFixa',               FQuedaFixa);
  Arquivo.WriteString(Section, 'ArqDemEnergetica',        FArqDemEnergetica);
  Arquivo.WriteString(Section, 'Energia Usuario',         FEnergiaUsuario);
end;

function TprPCP.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_PCP.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

procedure TprPCP.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_PCP) do
    begin
    cbCor.Selected := FImagemDoComponente.Canvas.Brush.Color;

    edEnergiaUsuario.Text := FEnergiaUsuario;

    rbGerNao.Checked := not FGerarEnergia;
    rbGerSim.Checked := FGerarEnergia;

    Form_Energia.edRG.AsFloat    := FRendiGera;
    Form_Energia.edVMT.AsFloat   := FQMaxTurb;
    Form_Energia.edRSA.AsFloat   := FRendiAduc;
    Form_Energia.edRT.AsFloat    := FRendiTurb;
    Form_Energia.edDE.AsFloat    := FDemEnergetica;
    Form_Energia.edX.AsFloat     := FQuedaFixa;  // Queda Hidraulica
    Form_Energia.edACDE.AsString := FArqDemEnergetica;
    end;
end;

procedure TprPCP.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_PCP) do
    begin
    FImagemDoComponente.Canvas.Brush.Color := cbCor.Selected;

    FGerarEnergia     := rbGerSim.Checked;
    FRendiGera        := Form_Energia.edRG.AsFloat;
    FQMaxTurb         := Form_Energia.edVMT.AsFloat;
    FRendiAduc        := Form_Energia.edRSA.AsFloat;
    FRendiTurb        := Form_Energia.edRT.AsFloat;
    FDemEnergetica    := Form_Energia.edDE.AsFloat;
    FQuedaFixa        := Form_Energia.edX.AsFloat;     // Queda Hidraulica
    FArqDemEnergetica := Form_Energia.edACDE.AsString;
    FEnergiaUsuario   := edEnergiaUsuario.Text;

    FImagemDoComponente.Invalidate;
    end;
end;

function TprPCP.ObtemPrefixo: String;
begin
  Result := 'PC_';
end;

procedure TprPCP.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);

(*
  function ValidaCRC: Boolean;
  var s: String[3];
  begin
    if Dialogo <> nil then
       s := TprDialogo_PCP(Dialogo).CRC1.Text +
            TprDialogo_PCP(Dialogo).CRC2.Text +
            TprDialogo_PCP(Dialogo).CRC3.Text
    else
       s := FCRC;

    case StrToInt(s) of
      000, 012, 013, 021, 023, 031, 032,
      123, 132, 213, 231, 312, 321:
        Result := True;
      else
        Result := False;
    end; // case
  end;
*)
var RU: String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
{
  if not ValidaCRC then
     begin
     DialogoDeErros.Add(etError, Format(cMsgErro04, [Nome]));
     TudoOk := False;
     end;
}
  if Dialogo <> nil then
     RU := TprDialogo_PCP(Dialogo).edEnergiaUsuario.Text
  else
     RU := FEnergiaUsuario;

  VerificarRotinaUsuario(RU, 'Energia', Completo, TudoOk, DialogoDeErros);
end;

procedure TprPCP.LerDoArquivo(Ini: TIF; Const Secao: String);
begin
  Inherited LerDoArquivo(Ini, Secao);

  FImagemDoComponente.Canvas.Brush.Color :=
    TColor(Ini.ReadInteger(Secao, 'Cor', Integer(clBlue)));

  FMDs                   := Ini.ReadBool  (Secao, 'Mostrar Demandas'       , True);
  FExecutarEnergiaPadrao := ini.ReadBool  (Secao, 'Executar Energia Padrao', False);
  FGerarEnergia          := ini.ReadBool  (Secao, 'GerarEnergia',            False);
  FRendiGera             := ini.ReadFloat (Secao, 'RendiGera',               0.93);
  FQMaxTurb              := ini.ReadFloat (Secao, 'QMaxTurb',                0);
  FRendiAduc             := ini.ReadFloat (Secao, 'RendiAduc',               0.97);
  FRendiTurb             := ini.ReadFloat (Secao, 'RendiTurb',               0.90);
  FDemEnergetica         := ini.ReadFloat (Secao, 'DemEnergetica',           0);
  FQuedaFixa             := ini.ReadFloat (Secao, 'QuedaFixa',               0);
  FArqDemEnergetica      := ini.ReadString(Secao, 'ArqDemEnergetica',        '');
  FEnergiaUsuario        := ini.ReadString(Secao, 'Energia Usuario',         '');
end;

// obtem toda a água que vem de trás deste PC
function TprPCP.ObtemVazoesDeMontante: Real;
var i  : Integer;
    PC : TprPCP;
begin
  Result := 0;
  if FHierarquia > 1 then
     for i := 0 to FPCs_aMontante.Objetos-1 do
       begin
       PC := TprPCP(FPCs_aMontante[i]);
       Result := Result + PC.Defluencia[FProjeto.DeltaT];
       end;
end;

(*
procedure TprPCP.Raciona(AguaDisponivel, DPP, DSP, DTP: Real; out DPA, DSA, DTA: Real);
var i_CRC: Integer;

  function CalculaRetorno(Prioridade: byte; const D1, D2: Real): Real;
  const x : Array[1..13] of Array[1..6] of byte = ((0,0,0,0,0,0),
                                                   (1,0,0,0,0,0),
                                                   (0,1,0,0,0,0),
                                                   (0,0,1,0,0,0),
                                                   (0,0,0,1,0,0),
                                                   (0,0,0,0,1,0),
                                                   (0,0,0,0,0,1),
                                                   (1,1,0,1,0,0),
                                                   (1,1,0,0,0,1),
                                                   (0,1,1,1,0,0),
                                                   (0,0,1,1,1,0),
                                                   (1,0,0,0,1,1),
                                                   (0,0,1,0,1,1));
  var i: byte;
  begin
    case i_CRC of
      000: i := 1;
      012: i := 2;
      013: i := 3;
      021: i := 4;
      023: i := 5;
      031: i := 6;
      032: i := 7;
      123: i := 8;
      132: i := 9;
      213: i := 10;
      231: i := 11;
      312: i := 12;
      321: i := 13;
    end; // case

    // cálculo do retorno;
    case Prioridade of
      1: Result := x[i][3]*FFRS*D1 + x[i][5]*FFRT*D2;
      2: Result := x[i][1]*FFRP*D1 + x[i][6]*FFRT*D2;
      3: Result := x[i][2]*FFRP*D1 + x[i][4]*FFRS*D2;
      end;
  end; // CalculaRetorno

Var DPA1 : Real;  // Auxiliar
    DSA1 : Real;  // Auxiliar
    DTA1 : Real;  // Auxiliar
    DPA2 : Real;  // Auxiliar
    DSA2 : Real;  // Auxiliar
    DTA2 : Real;  // Auxiliar
Begin
  Projeto.AtualizaPontoExecucao(FNome + '.Raciona', nil);

  i_CRC := StrToInt(FCRC);

  DPA1 := DPP;
  DSA1 := DSP;
  DTA1 := DTP;

  // só vai funcionar para 321 !!!
  repeat
    DTA2 := AguaDisponivel - DPA1 - DSA1 + CalculaRetorno(3, DPA1, DSA1);
    DTA  := Max(Min(DTA2, DTP), 0);

    DSA2 := AguaDisponivel - DPA1 - DTA + CalculaRetorno(2, DPA1, DTA);
    DSA  := Max(Min(DSA2, DSP), 0);

    DPA2 := AguaDisponivel - DSA - DTA + CalculaRetorno(1, DSA, DTA);
    DPA  := Max(Min(DPA2, DPP), 0);

    if ((ABS(DPA1 - DPA) <= 0.01*DPA) and
       ( ABS(DSA1 - DSA) <= 0.01*DSA) and
       ( ABS(DTA1 - DTA) <= 0.01*DTA)) then
       Break;

    DPA1 := DPA;
    DSA1 := DSA;
    DTA1 := DTA;

  until False;
{
  if FRacionaScript <> nil then
     begin
     Projeto.AtualizaPontoExecucao(FNome + '.RacionaScript', FRacionaScript);
     FRacionaScript.Execute;
     Projeto.AtualizaPontoExecucao(FNome + '.Raciona', nil);
     end;
}
end;
*)

// Tenta atender total ou parcialmente cada uma das demandas
procedure TprPCP.Raciona(AguaDisponivel, DPX, DSX, DTX: Real; out DPA, DSA, DTA: Real);
Begin
  Projeto.AtualizaPontoExecucao(FNome + '.Raciona', nil);
  if AguaDisponivel < DPX then
     begin
     DPA := AguaDisponivel;
     DSA := 0;
     DTA := 0;
     end
  else
     begin
     DPA := DPX;
     AguaDisponivel := AguaDisponivel - DPX;
     if AguaDisponivel < DSX then
        begin
        DSA := AguaDisponivel;
        DTA := 0;
        end
     else
        begin
        DSA := DSX;
        DTA := AguaDisponivel - DSX;
        end;
     end;
end;

// Realiza o balanço Hídricö: X[t] = Q[t] - D[t] + RD[t]
// Atenção: Teoricamente o método PrepararParaSimulacao já foi disparado.
procedure TprPCP.BalancoHidrico;
var   i              : Integer;  // Intervalo de Simulação
      j              : Integer;  // Auxiliar
      DemandaTotal   : Real;     // Soma das demandas Totais
      AfluenciaTotal : Real;     // Toda a água que vem de trás deste PC
      DPP            : Real;     // Aux. - Demanda Primaria Planejada
      DSP            : Real;     // Aux. - Demanda Secundaria Planejada
      DTP            : Real;     // Aux. - Demanda Terciaria Planejada
      DPA            : Real;     // Aux. - Demanda Primaria Atendida
      DSA            : Real;     // Aux. - Demanda Secundaria Atendida
      DTA            : Real;     // Aux. - Demanda Terciaria Atendida
      Retorno        : Real;     // Aux. - Fração de Retorno
begin
  Projeto.AtualizaPontoExecucao(FNome + '.BalancoHidrico', nil);

  i := FProjeto.DeltaT;

  FAfluenciaSB[i] := ObtemVazaoAfluenteSBs;

  // Cálculo do campo VazõesDeMontante
  FVzMon[i] := ObtemVazoesDeMontante;
  AfluenciaTotal := M3_Hm3_Intervalo(FVzMon[i]);

  // Totalização da agua afluente ao PC no DeltaT atual
  // FAfluenciaSB já esta sendo inicializado em PrepararParaSimulacao
  AfluenciaTotal := AfluenciaTotal + M3_Hm3_Intervalo(FAfluenciaSB[i]);

  // Análise para atendimento das Demandas Hídricas no PC.
  DPP := M3_Hm3_Intervalo(FDPP[i]);
  DSP := M3_Hm3_Intervalo(FDSP[i]);
  DTP := M3_Hm3_Intervalo(FDTP[i]);

  DemandaTotal := DPP + DSP + DTP;

  // AfluenciaTotal é suficiente para atender todas a Demandas
  if AfluenciaTotal > DemandaTotal then
     begin
     // Atualização das Demandas Atendidas
     FDPA[i] := Hm3_m3_Intervalo(DPP);
     FDSA[i] := Hm3_m3_Intervalo(DSP);
     FDTA[i] := Hm3_m3_Intervalo(DTP);
     Retorno := FFRP*DPP + FFRS*DSP + FFRT*DTP;
     end
  else
     begin
     // Não existe água para atender todas as Demandas:
     // fazer racionamento
     Raciona(AfluenciaTotal, DPP, DSP, DTP, {out} DPA, DSA, DTA);
     Projeto.AtualizaPontoExecucao(FNome + '.BalancoHidrico', nil);
     FDPA[i] := Hm3_m3_Intervalo(DPA);
     FDSA[i] := Hm3_m3_Intervalo(DSA);
     FDTA[i] := Hm3_m3_Intervalo(DTA);
     DemandaTotal := DPA + DSA + DTA;
     Retorno := FFRP*DPA + FFRS*DSA + FFRT*DTA;
     end;

  // Cálculo do campo Defluência
  FDefluencia[i] := Hm3_m3_Intervalo (AfluenciaTotal - DemandaTotal + Retorno);

  // Cálculo da Energia Gerada quando houver geração no PC
  if FGerarEnergia then
     begin
     FEG[i] := CalculaEnergia(FQuedaFixa, FDefluencia[i]);
     if FEnergiaScript <> nil then
        begin
        FProjeto.AtualizaPontoExecucao(FNome + '.ScriptEnergia', FEnergiaScript);
        FEnergiaScript.Execute;
        end;
     end;
end;

function TprPCP.ObtemDemanda(Prioridade: TEnumPriorDemanda): Real;
var DM : TprDemanda;  // i-égima demanda
    k  : Integer;     // Contador
begin
  Result := 0;
  for k := 0 to getNumDemandas-1 do
    if (Demanda[k].Prioridade = Prioridade) and (Demanda[k].Ligada) then
       begin
       DM := getDemanda(k);

       // As unidades da demanda são dependentes da data geral da simulação
       DM.Data := FProjeto.Data;
       Result  := Result + DM.Demanda;
       end;
end;

// Totaliza as demandas 1, 2 e 3 para o intervalo t de simulação
procedure TprPCP.TotalizaDemandas;
var i: Integer;
begin
  FDPT.Len := FProjeto.Total_IntSim;
  FDST.Len := FDPT.Len;
  FDTT.Len := FDPT.Len;

  for i := 1 to FDPT.Len do
    begin
    FProjeto.DeltaT := i;
    FDPT[i] := ObtemDemanda(pdPrimaria);
    FDST[i] := ObtemDemanda(pdSecundaria);
    FDTT[i] := ObtemDemanda(pdTerciaria);
    end;

  FProjeto.DeltaT := 0;
end;

procedure TprPCP.ObtemNiveisCriticosDeFalhas;
var i: Integer;
    x: Real;
begin
  x := FProjeto.NivelDeFalha / 100;
  FNCFP := x; FNCFS := x; FNCFT := x;
(* ....
  for i := 0 to Demandas-1 do
    begin
    x := Demanda[i].NivelDeFalhaCritica;
    if (Demanda[i].Prioridade = pdPrimaria  ) and (x > FNCFP) then FNCFP := x;
    if (Demanda[i].Prioridade = pdSecundaria) and (x > FNCFS) then FNCFS := x;
    if (Demanda[i].Prioridade = pdTerciaria ) and (x > FNCFT) then FNCFT := x;
    end;
*)
end;

function TprPCP.ObtemFalhas: TListaDeFalhas;

  function Falha(const x, y: Real): Boolean;
  begin
    Result := ABS(x - y) > 0.01 * x;
  end;

var i: Integer;
begin
  if FDPA.Len <> FProjeto.Total_IntSim then
     Raise Exception.Create('Demandas Atendidas e Planejadas ainda não calculadas');

  ObtemNiveisCriticosDeFalhas;
  Result := TListaDeFalhas.Create(FProjeto);
  for i := 1 to FProjeto.Total_IntSim do
    begin
    if Falha(FDPT[i], FDPA[i]) then Result.Adicionar(pdPrimaria,   i, FDPT[i], FDPA[i], FNCFP);
    if Falha(FDST[i], FDSA[i]) then Result.Adicionar(pdSecundaria, i, FDST[i], FDSA[i], FNCFS);
    if Falha(FDTT[i], FDTA[i]) then Result.Adicionar(pdTerciaria,  i, FDTT[i], FDTA[i], FNCFT);
    end;
end;

procedure TprPCP.PrepararParaSimulacao;
var s: String;
begin
  Inherited PrepararParaSimulacao;

  FDPP.Len := FProjeto.Total_IntSim; FDPP.Fill(0);
  FDSP.Len := FDPP.Len; FDSP.Fill(0);
  FDTP.Len := FDPP.Len; FDTP.Fill(0);
  FEG.Len  := FDPP.Len; FEG.Fill(0);

  if VerificarCaminho(FArqDemEnergetica) then
     FCurvaDemEnergetica.LoadFromTextFile(FArqDemEnergetica);

  if FProjeto.TipoSimulacao = tsWIN then
     begin
     FDPA.Len := FDPP.Len; FDPA.Fill(0);
     FDSA.Len := FDPP.Len; FDSA.Fill(0);
     FDTA.Len := FDPP.Len; FDTA.Fill(0);
     end;

  FFRP := CalculaFatorRetorno(pdPrimaria);
  FFRS := CalculaFatorRetorno(pdSecundaria);
  FFRT := CalculaFatorRetorno(pdTerciaria);

  // Já totaliza todos os DeltaTs --> FDxT
  TotalizaDemandas;
end;

destructor TprPCP.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.UnRegisterMessage(UM_LIBERAR_SCRIPTS, self);

  FEG.Free;

  FDPA.Free;
  FDSA.Free;
  FDTA.Free;

  FDPT.Free;
  FDST.Free;
  FDTT.Free;

  FDPP.Free;
  FDSP.Free;
  FDTP.Free;

  FCurvaDemEnergetica.Free;

  inherited Destroy;
end;

procedure TprPCP.GraficarDemandasAtendidas(Tipo: TEnumTipoDeGrafico);
begin
  GraficarDemandas('Demandas Atendidas do(a) ', 'Atendidas', Tipo);
end;

procedure TprPCP.GraficarDemandasPlanejadas(Tipo: TEnumTipoDeGrafico);
begin
  GraficarDemandas('Demandas Planejadas do(a) ', 'Planejadas', Tipo);
end;

procedure TprPCP.GraficarDemandasTotais(Tipo: TEnumTipoDeGrafico);
begin
  GraficarDemandas('Demandas de Referência do(a) ', 'Ref', Tipo);
end;

procedure TprPCP.GraficarDemandas(const Titulo, TipoDem: String; TipoGraf: TEnumTipoDeGrafico);
var g           : TgrGrafico;
    b           : TChartSeries;
    //p           : TprProjeto;
    d1, d2, d3  : TV;
    i, k        : Integer;
begin
  if TipoDem = 'Ref' then
     begin
     d1 := FDPT; d2 := FDST; d3 := FDTT;
     end else
  if TipoDem = 'Atendidas' then
     begin
     d1 := FDPA; d2 := FDSA; d3 := FDTA;
     end else
  if TipoDem = 'Planejadas' then
     begin
     d1 := FDPP; d2 := FDSP; d3 := FDTP;
     end
  else
     Raise Exception.Create('Tipo de Demanda Desconhecido');

  //p := TprDialogo_AreaDeProjeto(FProjeto).Projeto;

  for k := 0 to FProjeto.Intervalos.NumInts - 1 do
    begin
    if not FProjeto.Intervalos.Habilitado[k] then Continue;

    g := CriarGrafico_Default(Titulo, k);

    case TipoGraf of
      tgBarras:
        begin
        b := g.Series.AdicionaSerieDeBarras(
          'Demanda Primária', clRed, 0, 1, d1, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeBarras(
          'Demanda Secundária', clGreen, 0, 1, d2, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeBarras(
          'Demanda Terciária', clYellow, 0, 1, d3, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;

      tgLinhas:
        begin
        b := g.Series.AdicionaSerieDeLinhas(
          'Demanda Primária', clRed, d1, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeLinhas(
          'Demanda Secundária', clGreen, d2, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeLinhas(
          'Demanda Terciária', clYellow, d3, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;
      end;

    DefinirEixoX_Default(b, k);
    g.Show;
    end; // for k
end;

procedure TprPCP.MostrarFalhas;
var LF: TListaDeFalhas;
begin
  LF := ObtemFalhas;
  LF.MostrarFalhas.Caption := 'Falhas de Atendimento do(a) ' + Nome;
end;

procedure TprPCP.ColocaDadosNaPlanilha(Planilha: TForm);
var i: Integer;
begin
  Inherited;
  with TForm_Planilha_DadosDosObjetos(Planilha).Tab do
    begin
    // Demandas de Referência
    TextRC[1, 6] := 'DPR';
    TextRC[1, 7] := 'DSR';
    TextRC[1, 8] := 'DTR';
    TextRC[1, 9] := 'D.REF';

    for i := 1 to FDPT.Len do NumberRC[i+1, 6] := FDPT[i];
    for i := 1 to FDST.Len do NumberRC[i+1, 7] := FDST[i];
    for i := 1 to FDTT.Len do NumberRC[i+1, 8] := FDTT[i];
    for i := 1 to FDPT.Len do NumberRC[i+1, 9] := FDPT[i] + FDST[i] + FDTT[i];

    // Demandas Atendidas
    TextRC[1, 10] := 'DPA';
    TextRC[1, 11] := 'DSA';
    TextRC[1, 12] := 'DTA';
    TextRC[1, 13] := 'D.ATE';

    for i := 1 to FDPA.Len do NumberRC[i+1, 10] := FDPA[i];
    for i := 1 to FDSA.Len do NumberRC[i+1, 11] := FDSA[i];
    for i := 1 to FDTA.Len do NumberRC[i+1, 12] := FDTA[i];
    for i := 1 to FDPA.Len do NumberRC[i+1, 13] := FDPA[i] + FDSA[i] + FDTA[i];

    // Demandas Planejadas
    TextRC[1, 14] := 'DPP';
    TextRC[1, 15] := 'DSP';
    TextRC[1, 16] := 'DTP';
    TextRC[1, 17] := 'D.PLA';
    TextRC[1, 18] := 'En.Ger';

    for i := 1 to FDPP.Len do NumberRC[i+1, 14] := FDPP[i];
    for i := 1 to FDSP.Len do NumberRC[i+1, 15] := FDSP[i];
    for i := 1 to FDTP.Len do NumberRC[i+1, 16] := FDTP[i];
    for i := 1 to FDPP.Len do NumberRC[i+1, 17] := FDPP[i] + FDSP[i] + FDTP[i];
    for i := 1 to FEG.Len  do NumberRC[i+1, 18] := FEG[i];
    end;
end;

procedure TprPCP.GraficarTudo;
var D: TprDialogo_Grafico_PCs_XTudo;
begin
  FProjeto.VerificarIntervalosDeAnalise;
  D := TprDialogo_Grafico_PCs_XTudo.Create(nil);
  Try
    D.Caption := 'Opções para o ' + Nome;
    D.PC := Self;
    D.ShowModal;
  Finally
    D.Release;
    End;
end;

procedure TprPCP.GraficarDisponibilidade_X_Demanda(Tipo: TEnumTipoDeGrafico);
var g      : TgrGrafico;
    b      : TChartSeries;
    //p      : TprProjeto;
    i, k   : Integer;
    DT     : TV;
    AT     : TV;
begin
  FProjeto.VerificarIntervalosDeAnalise;

  DT := TV.Create(FDPT.Len); // Soma das Demandas Totais
  AT := TV.Create(FDPT.Len); // Água Total
  for i := 1 to DT.Len do
    begin
    DT[i] := FDPT[i] + FDST[i] + FDTT[i];
    AT[i] := FVzMon[i] + FAfluenciaSB[i];
    end;

  for k := 0 to FProjeto.Intervalos.NumInts - 1 do
    begin
    if not FProjeto.Intervalos.Habilitado[k] then Continue;

    g := CriarGrafico_Default('Disponibilidade X Demanda do(a) ', k);

    case Tipo of
      tgBarras:
        begin
        b := g.Series.AdicionaSerieDeBarras(
         'Demanda Total', clRed, 0, 1, DT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeBarras(
          'Disponibilidade', clYellow, 0, 1, AT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeBarras(
          'Diferença', clGreen, 0, 1, FDefluencia, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;

      tgLinhas:
        begin
        b := g.Series.AdicionaSerieDeLinhas(
          'Demanda Total', clRed, DT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeLinhas(
          'Disponibilidade', clGreen, AT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AdicionaSerieDeLinhas(
          'Diferença', clYellow, FDefluencia, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;
      end;

    DefinirEixoX_Default(b, k);
    g.Show;
    end; // for k

  DT.Free;
  AT.Free;
end;

procedure TprPCP.MostrarVariavel(const NomeVar: String);
var v: TV;
    d: TwsDataSet;
begin
  v := nil;
  if CompareText(NomeVar, 'DPA')     = 0 then v := FDPA else
  if CompareText(NomeVar, 'DSA')     = 0 then v := FDSA else
  if CompareText(NomeVar, 'DTA')     = 0 then v := FDTA else
  if CompareText(NomeVar, 'DPP')     = 0 then v := FDPP else
  if CompareText(NomeVar, 'DSP')     = 0 then v := FDSP else
  if CompareText(NomeVar, 'DTP')     = 0 then v := FDTP else
  if CompareText(NomeVar, 'DPT')     = 0 then v := FDPT else
  if CompareText(NomeVar, 'DST')     = 0 then v := FDST else
  if CompareText(NomeVar, 'DTT')     = 0 then v := FDTT else
  if CompareText(NomeVar, 'Energia') = 0 then v := FEG;

  if (v <> nil) and (v.Len > 0) then
     begin
     d := ObterDataSet(v);
     MostrarDataSet(NomeVar, d);
     d.Free;
     end
  else
     inherited;
end;

procedure TprPCP.CopiarPara(PC: TprPCP);
begin
  PC.FNome           := FNome + 'x';
  PC.FDescricao      := FDescricao;
  PC.FHierarquia     := FHierarquia;
  PC.FVisivel        := FVisivel;
  //PC.FCRC            := FCRC;
  PC.FNCFP           := FNCFP;
  PC.FNCFS           := FNCFS;
  PC.FNCFT           := FNCFT;
  PC.FFRP            := FFRP;
  PC.FFRS            := FFRS;
  PC.FFRT            := FFRT;
  PC.FMDs            := FMDs;

  PC.FEnergiaUsuario        := FEnergiaUsuario; 
  PC.FExecutarEnergiaPadrao := FExecutarEnergiaPadrao;

  PC.FGerarEnergia     := FGerarEnergia;
  PC.FRendiGera        := FRendiGera;
  PC.FQMaxTurb         := FQMaxTurb;
  PC.FRendiAduc        := FRendiAduc;
  PC.FRendiTurb        := FRendiTurb;
  PC.FDemEnergetica    := FDemEnergetica;
  PC.FQuedaFixa        := FQuedaFixa;
  PC.FArqDemEnergetica := FArqDemEnergetica;

  PC.FCurvaDemEnergetica.Free;
  PC.FCurvaDemEnergetica := FCurvaDemEnergetica;
  FCurvaDemEnergetica := nil;

  PC.FComentarios.Free;
  PC.FComentarios := FComentarios;
  FComentarios := nil;

  PC.FAfluenciaSB.Free;
  PC.FAfluenciaSB := FAfluenciaSB;
  FAfluenciaSB := nil;

  PC.FDefluencia.Free;
  PC.FDefluencia := FDefluencia;
  FDefluencia := nil;

  PC.FVzMon.Free;
  PC.FVzMon := FVzMon;
  FVzMon := nil;

  PC.FDPA.Free;
  PC.FDPA := FDPA;
  FDPA := nil;

  PC.FDSA.Free;
  PC.FDSA := FDSA;
  FDSA := nil;

  PC.FDTA.Free;
  PC.FDTA := FDTA;
  FDTA := nil;

  PC.FDPP.Free;
  PC.FDPP := FDPP;
  FDPP := nil;

  PC.FDSP.Free;
  PC.FDSP := FDSP;
  FDSP := nil;

  PC.FDTP.Free;
  PC.FDTP := FDTP;
  FDTP := nil;

  PC.FDPT.Free;
  PC.FDPT := FDPT;
  FDPT := nil;

  PC.FDST.Free;
  PC.FDST := FDST;
  FDST := nil;

  PC.FDTT.Free;
  PC.FDTT := FDTT;
  FDTT := nil;

  PC.FSubBacias.Free;
  PC.FSubBacias := FSubBacias;
  FSubBacias := nil;

  PC.FDemandas.Free;
  PC.FDemandas := FDemandas;
  FDemandas := nil;

  PC.FPCs_aMontante.Free;
  PC.FPCs_aMontante := FPCs_aMontante;
  FPCs_aMontante := nil;

  PC.FTD.Free;
  PC.FTD := FTD;
  FTD := nil;

  PC.AtualizaHint;
end;

procedure TprPCP.AutoDescricao(Identacao: byte);
var s: String;
begin
  inherited;
  s  := StringOfChar(' ', Identacao);
{
  with gOutPut.Editor do
    begin
    Write (s + 'Código de Retorno de Contribuição : ' + CRC);
    Write;
    end;
}    
end;

// Configura a visibilidade das demandas do PC e das Sub-bacias conectadas a ele
procedure TprPCP.SetMDs(const Value: Boolean);
var i, j: Integer;
begin
  FMDs := Value;

  for i := 0 to FDemandas.Objetos-1 do
    TprDemanda(FDemandas[i]).Visivel := FMDs;

  for i := 0 to FSubBacias.Objetos-1 do
    for j := 0 to TprSubBacia(FSubBacias[i]).FDemandas.Objetos-1 do
      TprDemanda(TprSubBacia(FSubBacias[i]).FDemandas[j]).Visivel := FMDs;
end;

procedure TprPCP.MostrarMenu(x, y: Integer);
var M: TMenuItem;
begin
  M := FMenu.Items.Find('Mostrar Demandas');
  if M <> nil then M.Checked := FMDs;
  inherited;
end;

procedure TprPCP.PrepararMenu;
var i, ii: integer;
    m, MD: TMenuItem;
    s: String;
begin
  inherited;

  // Apaga os menus demandas para que eles sejam atualizados
  m := FMenu.Items[FMenu.Items.Count-1];
  if m.Tag = -1 then
     begin
     m.Free;
     m := FMenu.Items[FMenu.Items.Count-1]; m.Free; // separador
     end;

  ii := GetNumDemandas;
  if (ii > 0) then
     begin
     FMenu.Items.NewBottomLine;
     MD := TMenuItem.Create(FMenu);
     MD.Caption := 'Demandas';
     MD.Tag := -1;
     FMenu.Items.Add(MD);

     for i := 0 to ii-1 do
       begin
       s := Demanda[i].Nome;
       case Demanda[i].Prioridade of
         pdPrimaria   : s := s + ' - PRIMÁRIA';
         pdSecundaria : s := s + ' - SECUNDÁRIA';
         pdTerciaria  : s := s + ' - TERCIÁRIA';
       end;

       m := NewItem(s, 0, False, True, Menu_DemandasClick, 0, 'MD_' + intToStr(i));
       m.Tag := integer(Demanda[i]); // põe a referência a demanda i no Tag do Menu
       MD.Add(m);
       end;
     end;
end;

procedure TprPCP.Menu_DemandasClick(Sender: TObject);
var m: TMenuItem;
    d: TprDemanda;
begin
  m := TMenuItem(Sender);
  if m.Tag <> 0 then
     begin
     d := TprDemanda(m.Tag);
     d.MostrarDialogo;
     end;
end;

function TprPCP.Hm3_m3_Intervalo(const Valor: Real): Real;
begin
  Result := Valor / DiasNoIntervalo / 0.0864;
end;

function TprPCP.m3_Hm3_Intervalo(const Valor: Real): Real;
begin
  Result := Valor * DiasNoIntervalo * 0.0864;
end;

{ Esta função atualiza as propriedades FatorDeRetornoPri, FatorDeRetornoSec
  e FatorDeRetornoTer.
  Para cada uma é determinado o menor valor dentre aqueles que correspondam
  à propriedade FatorDeRetorno das Classes de Demandas da prioridade Tipo
  associadas ao PC
  É chamado antes da simulação iniciar}
function TprPCP.CalculaFatorRetorno(Tipo: TEnumPriorDemanda): Real;
var i: Integer;
begin
  Result := 2;
  for i := 0 to GetNumDemandas-1 do
    if Demanda[i].Prioridade = Tipo then
       if Demanda[i].FatorDeRetorno < Result then
          Result := Demanda[i].FatorDeRetorno;

  // caso não exista uma demanda de prioridade "tipo"
  if Result = 2 then Result := 0;
end;

function TprPCP.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     if FEnergiaUsuario <> '' then
        begin
        PreparaScript(FEnergiaUsuario, FEnergiaScript);
        FEnergiaScript.Compile;
        end
     else
        if FProjeto.FEnergiaUsuario <> '' then
           begin
           PreparaScript(FProjeto.FEnergiaUsuario, FEnergiaScript);
           FEnergiaScript.Compile;
           end;
     end else

    if MSG.ID = UM_LIBERAR_SCRIPTS then
       FreeAndNil(FEnergiaScript);

  inherited ReceiveMessage(MSG);
end;

procedure TprPCP.CalculaVzMon_e_AfluenciaSB;
var i, j: Integer;
begin
  FAfluenciaSB.Len := FProjeto.getTIS; FAfluenciaSB.Fill(0);
  FVzMon.Len       := FAfluenciaSB.Len;
  FDefluencia.Len  := FAfluenciaSB.Len;

  for i := 1 to FAfluenciaSB.Len do
    begin
    FProjeto.DeltaT := i;

    // FAfluenciaSB já está inicializado
    for j := 0 to SubBacias-1 do
      FAfluenciaSB[i] := FAfluenciaSB[i] + SubBacia[j].ObtemVazaoAfluente(Self);

    // Cálculo do campo VazõesDeMontante
    FVzMon[i] := ObtemVazoesDeMontante;
    end;
end;

function TprPCP.CalculaEnergia(Queda, Vazao: Real): Real;
begin
  if Vazao > FQMaxTurb then Vazao := FQMaxTurb;
  Result := 9.81 * FRendiAduc * FRendiTurb * FRendiGera * Vazao * Queda * (DiasNoIntervalo * 24) ;
end;

procedure TprPCP.GraficarEnergia(Tipo: TEnumTipoDeGrafico);
var g    : TgrGrafico;
    b    : TChartSeries;
    i, k : Integer;
begin
  FProjeto.VerificarIntervalosDeAnalise;

  for k := 0 to FProjeto.Intervalos.NumInts - 1 do
    begin
    if not FProjeto.Intervalos.Habilitado[k] then Continue;

    g := CriarGrafico_Default('Energia do(a) ', k);

    case Tipo of
      tgBarras:
        b := g.Series.AdicionaSerieDeBarras(
               'Energia', clRed, 0, 0, FEG,
                FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

      tgLinhas:
        b := g.Series.AdicionaSerieDeLinhas(
               'Energia', clRed,
               FEG,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
      end;

    b.ShowInLegend := False;
    DefinirEixoX_Default(b, k);
    g.Show;
    end; // for k
end;

procedure TprPCP.Monitorar;
var i: Integer;
begin
  inherited;

  if Assigned(FEventoDeMonitoracao) then
     begin
     i := FProjeto.DeltaT;

     if System.Pos('DPT', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DPT', FDPT[i]);

     if System.Pos('DST', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DST', FDST[i]);

     if System.Pos('DTT', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DTT', FDTT[i]);

     if System.Pos('DPA', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DPA', FDPA[i]);

     if System.Pos('DSA', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DSA', FDSA[i]);

     if System.Pos('DTA', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DTA', FDTA[i]);

     if System.Pos('DPP', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DPP', FDPP[i]);

     if System.Pos('DSP', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DSP', FDSP[i]);

     if System.Pos('DTP', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'DTP', FDTP[i]);

     if System.Pos('EG', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'EG', FEG[i]);

     if System.Pos('Curva Dem. EG', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Curva Dem. EG', FCurvaDemEnergetica[i]);
     end;
end;

function TprPCP.Optimizer_getValue(const PropName: string; Year, Month: Integer): real;
begin
  if CompareText(PropName, 'RendiAduc') = 0 then
     Result := FRendiAduc else

  if CompareText(PropName, 'RendiTurb') = 0 then
     Result := FRendiTurb else

  if CompareText(PropName, 'RendiGera') = 0 then
     Result := FRendiGera else

  if CompareText(PropName, 'QMaxTurb') = 0 then
     Result := FQMaxTurb else

  if CompareText(PropName, 'QuedaFixa') = 0 then
     Result := FQuedaFixa else

  if CompareText(PropName, 'DemEnergetica') = 0 then
     Result := FDemEnergetica else

  Result := inherited Optimizer_getValue(PropName, Year, Month);
end;

procedure TprPCP.Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real);
begin
  if CompareText(PropName, 'RendiAduc') = 0 then
     FRendiAduc := r else

  if CompareText(PropName, 'RendiTurb') = 0 then
     FRendiTurb := r else

  if CompareText(PropName, 'RendiGera') = 0 then
     FRendiGera := r else

  if CompareText(PropName, 'QMaxTurb') = 0 then
     FQMaxTurb := r else

  if CompareText(PropName, 'QuedaFixa') = 0 then
     FQuedaFixa := r else

  if CompareText(PropName, 'DemEnergetica') = 0 then
     FDemEnergetica := r else

  inherited;
end;

function TprPCP.ConectarObjeto(Obj: THidroComponente): Integer;
var PC: TprPCP;
    SB: TprSubBacia;
begin
  SetModificado(True);

  // Objeto é uma Sub-Bacia ----------------------------------------------------------
  if Obj is TprSubBacia then
     begin
     SB := TprSubBacia(Obj);
     FSubBacias.Adicionar(SB);
     SB.PCs.Adicionar(Self);
     if SB.PCs.Objetos > SB.CCs.Count then
        if SB.CCs.Count = 0 then
           SB.CCs.Add(1.0)
        else
           SB.CCs.Add(0.0);
     end
  else
{
  // Objeto é uma Derivação ----------------------------------------------------------
  if Obj is TDerivacao then
     begin
     FDerivacoes.Adicionar(Obj);
     end
  else
}
  // Objeto é uma Derivação ----------------------------------------------------------
  if Obj is TprDemanda then
     begin
     FDemandas.Adicionar(Obj);
     end
  else

  // Objeto é um PC ------------------------------------------------------------------
  if Obj is TprPCP then
     begin
     PC := TprPCP(Obj);
     PC.ConectarPC_aMontante(Self);
     Self.PC_aJusante := PC;
     end;
end;

procedure TprPCP.DesconectarObjetos;
var i, k: Integer;
begin
(*
  // Derivações

  for i := 0 to GetNumDerivacoes-1 do
    begin
    FDerivacoes[i].Free;
    FDerivacoes[i] := nil;
    end;

  FDerivacoes.RemoverNulos;
*)
  // Demandas

  for i := 0 to GetNumDemandas-1 do
    begin
    FDemandas[i].Free;
    FDemandas[i] := nil;
    end;

  FDemandas.RemoverNulos;

  // Sub-Bacias

  for i := 0 to SubBacias - 1 Do
    if (SubBacia[i] <> nil) then
       begin
       if (SubBacia[i].PCs.Objetos = 1) then
          begin
          SubBacia[i].DesconectarObjetos;
          SubBacia[i].Free;
          FSubBacias[i] := nil;
          end
       else
          begin
          k := SubBacia[i].PCs.IndiceDo(Self);
          SubBacia[i].PCs.Deletar(k);
          SubBacia[i].CCs.Delete(k);
          end;
       end;

  FSubBacias.RemoverNulos;
end;

procedure TprPCP.RemoverTrecho;
begin
  if FTD <> nil then
     begin
     SetModificado(True);
     FTD.PC_aJusante.DesconectarPC_aMontante(FTD.PC_aMontante);
     FTD.Free;
     FTD := nil;
     end;
end;

function TprPCP.PossuiObjetosConectados: Boolean;
begin
  Result := False;
end;

procedure TprPCP.ConectarPC_aMontante(PC: TprPCP);
begin
  FPCs_aMontante.Adicionar(PC);
end;

procedure TprPCP.DesconectarPC_aMontante(PC: TprPCP);
begin
  FPCs_aMontante.Remover(PC);
end;

function TprPCP.ObterVazaoAfluenteSBs: Real;
begin

end;

function TprPCP.ObterVazoesDeMontante: Real;
begin

end;

{ TprPCPR }

constructor TprPCPR.Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
begin
  Inherited Create(Pos, Projeto, UmaTabelaDeNomes);

  FVolume   := TV.Create(0);
  FDeflu_Pl := TV.Create(0);
  FDeflu_Op := TV.Create(0);

  DefinirVariaveisQuePodemSerMonitoradas(['Volume', 'Defluvio Planejado', 'Defluvio Operado']);

  //CriarComponenteVisual(Pos);
end;

procedure TprPCPR.SalvarEmArquivo(Arquivo: TIF);
var SL : TStringList;
    i  : Integer;
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteString  (Section, 'Arq. Prec'     , FArqPrec);
    WriteString  (Section, 'Arq. ETP'      , FArqETP);
    WriteInteger (Section, 'Tipo ETP'      , FTipoETP);

    WriteFloat   (Section, 'Volume Maximo' , FVolMax);
    WriteFloat   (Section, 'Volume Minimo' , FVolMin);
    WriteFloat   (Section, 'Volume Inicial', FVolIni);
    WriteFloat   (Section, 'Cota Jusante'  , FCotajusante);
    WriteInteger (Section, 'PontosAV'      , PontosAV);
    WriteInteger (Section, 'PontosCV'      , PontosCV);

    WriteBool    (Section, 'Status'             , FStatus);

    //WriteBool    (Section, 'Demanda por Energia', FDPE);
    //WriteFloat   (Section, 'Coef. Tranf.'  , FCT);
    //WriteFloat   (Section, 'Energia Firme' , FEF);

    SL := TStringList.Create;
    for i := 0 to PontosAV-1 do SL.Add(FloatToStr(FAV[i].Area));
    WriteString  (Section, 'AV Area', SL.CommaText); SL.Clear;

    for i := 0 to PontosAV-1 do SL.Add(FloatToStr(FAV[i].Vol));
    WriteString  (Section, 'AV Vol', SL.CommaText); SL.Clear;

    for i := 0 to PontosCV-1 do SL.Add(FloatToStr(FCV[i].Cota));
    WriteString  (Section, 'CV Cota', SL.CommaText); SL.Clear;

    for i := 0 to PontosCV-1 do SL.Add(FloatToStr(FCV[i].Vol));
    WriteString  (Section, 'CV Vol', SL.CommaText);
    SL.Free;

    WriteString(Section, 'Opera Usuario', FOperaUsuario);
    end;
end;

procedure TprPCPR.LerDoArquivo(Ini: TIF; Const Secao: String);
var SL: TStringList;
    i : Integer;
begin
  Inherited LerDoArquivo(Ini, Secao);
  with ini do
    begin
    FArqPrec := ReadString  (Section, 'Arq. Prec'   , '');
    FArqETP  := ReadString  (Section, 'Arq. ETP'    , '');
    FTipoETP := ReadInteger (Section, 'Tipo ETP'    , 1);

    FVolMax      := ReadFloat   (Secao, 'Volume Maximo' , 0);
    FVolMin      := ReadFloat   (Secao, 'Volume Minimo' , 0);
    FVolIni      := ReadFloat   (Secao, 'Volume Inicial', 0);
    FCotajusante := ReadFloat   (Secao, 'Cota Jusante'  , 0);
    PontosAV     := ReadInteger (Secao, 'PontosAV'      , 0);
    PontosCV     := ReadInteger (Secao, 'PontosCV'      , 0);

    FStatus  := ReadBool    (Secao, 'Status'             , True);

    //FDPE     := ReadBool    (Secao, 'Demanda por Energia', False);
    //FCT      := ReadFloat   (Secao, 'Coef. Tranf.'  , 0);
    //FEF      := ReadFloat   (Secao, 'Energia Firme' , 0);

    SL := TStringList.Create;
    SL.CommaText := ReadString(Section, 'AV Area', '');
    for i := 0 to PontosAV-1 do FAV[i].Area := 0;
    for i := 0 to SL.Count-1 do FAV[i].Area := strToFloat(SL[i]);

    SL.CommaText := ReadString(Section, 'AV Vol', '');
    for i := 0 to PontosAV-1 do FAV[i].Vol := 0;
    for i := 0 to SL.Count-1 do FAV[i].Vol := strToFloat(SL[i]);

    SL.CommaText := ReadString(Section, 'CV Cota', '');
    for i := 0 to PontosCV-1 do FCV[i].Cota := 0;
    for i := 0 to SL.Count-1 do FCV[i].Cota := strToFloat(SL[i]);

    SL.CommaText := ReadString(Section, 'CV Vol', '');
    for i := 0 to PontosCV-1 do FCV[i].Vol := 0;
    for i := 0 to SL.Count-1 do FCV[i].Vol := strToFloat(SL[i]);
    SL.Free;

    FOperaUsuario := ReadString(Section, 'Opera Usuario', '');
    end;
end;

function TprPCPR.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_PCPR.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

procedure TprPCPR.PorDadosNoDialogo(d: TprDialogo_Base);
var i: Integer;
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_PCPR) do
    begin
    edArqPrec.Text := FArqPrec;
    edArqETP.Text  := FArqETP;
    //rbDT.Checked   := Boolean(FTipoETP);

    edVolMax.AsFloat := FVolMax;
    edVolMin.AsFloat := FVolMin;
    edVolIni.AsFloat := FVolIni;
    //edCT.AsFloat     := FCT;
    //edEF.AsFloat     := FEF;

    //cbDPE.Checked    := FDPE; cbDPEClick(nil);
    cbStatus.ItemIndex := ord(FStatus);

    Curvas.edCV.Text   := intToStr(PontosCV);
    Curvas.edAV.Text   := intToStr(PontosAV);

    for i := 1 to PontosCV do
      begin
      Curvas.CV.NumberRC[i, 1] := FCV[i-1].Cota;
      Curvas.CV.NumberRC[i, 2] := FCV[i-1].Vol;
      end;

    for i := 1 to PontosAV do
      begin
      Curvas.AV.NumberRC[i, 1] := FAV[i-1].Area;
      Curvas.AV.NumberRC[i, 2] := FAV[i-1].Vol;
      end;

    edOperaUsuario.Text   := FOperaUsuario;

    Form_Energia.edX.AsFloat := FCotaJusante;  // Cota Jusante
    end;
end;

procedure TprPCPR.PegarDadosDoDialogo(d: TprDialogo_Base);
var i: Integer;
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_PCPR) do
    begin
    FArqPrec := edArqPrec.Text;
    FArqETP  := edArqETP.Text;
    //FTipoETP := byte(rbDT.Checked);

    FVolMax := StrToFloat(edVolMax.Text);
    FVolMin := StrToFloat(edVolMin.Text);
    FVolIni := StrToFloat(edVolIni.Text);

    //FDPE    := cbDPE.Checked;
    FStatus := Boolean(cbStatus.ItemIndex);

    //FCT     := StrToFloat(edCT.Text);
    //FEF     := StrToFloat(edEF.Text);

    PontosCV := StrToInt(Curvas.edCV.Text);
    PontosAV := StrToInt(Curvas.edAV.Text);

    for i := 1 to PontosCV do
      begin
      FCV[i-1].Cota := Curvas.CV.NumberRC[i, 1];
      FCV[i-1].Vol  := Curvas.CV.NumberRC[i, 2];
      end;

    for i := 1 to PontosAV do
      begin
      FAV[i-1].Area := Curvas.AV.NumberRC[i, 1];
      FAV[i-1].Vol  := Curvas.AV.NumberRC[i, 2];
      end;

    FOperaUsuario := edOperaUsuario.Text;
    
    FCotaJusante := Form_Energia.edX.AsFloat;  // Cota Jusante
    end;
end;

function TprPCPR.ObtemPrefixo: String;
begin
  Result := 'RES_';
end;

function TprPCPR.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrTriangle.Create(nil);
  Result.Width := 20;
  Result.Height := 20;
end;

function TprPCPR.GetAV(index: Word): TRecAreaVolume;
begin
  if index <= High(FAV) then
     Result := FAV[index]
  else
     fillChar(Result, SizeOf(Result), -1);
end;

function TprPCPR.GetCV(index: Word): TRecCotaVolume;
begin
  if index <= High(FCV) then
     Result := FCV[index]
  else
     fillChar(Result, SizeOf(Result), -1);
end;

function TprPCPR.GetPAV: Word;
begin
  Result := High(FAV) + 1;
end;

function TprPCPR.GetPCV: Word;
begin
  Result := High(FCV) + 1;
end;

procedure TprPCPR.SetPAV(const Value: Word);
begin
  if Value <> PontosAV then SetLength(FAV, Value);
end;

procedure TprPCPR.SetPVC(const Value: Word);
begin
  if Value <> PontosCV then SetLength(FCV, Value);
end;

procedure TprPCPR.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var R1: Real; // VolIni
    R2: Real; // VolMin
    R3: Real; // VolMax
    PCV: Integer;
    PAV: Integer;
    s1 : String;
    s2 : String;
    OU : String;
    EU : String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if Dialogo <> nil then
     begin
     R1  := TprDialogo_PCPR(Dialogo).edVolIni.AsFloat;
     R2  := TprDialogo_PCPR(Dialogo).edVolMin.AsFloat;
     R3  := TprDialogo_PCPR(Dialogo).edVolMax.AsFloat;
     PCV := StrToInt(TprDialogo_PCPR(Dialogo).Curvas.edCV.Text);
     PAV := StrToInt(TprDialogo_PCPR(Dialogo).Curvas.edAV.Text);
     s1  := TprDialogo_PCPR(Dialogo).edArqPrec.Text;
     s2  := TprDialogo_PCPR(Dialogo).edArqETP.Text;
     OU  := TprDialogo_PCPR(Dialogo).edOperaUsuario.Text;
     EU  := TprDialogo_PCPR(Dialogo).edEnergiaUsuario.Text;
     end
  else
     begin
     R1  := FVolIni;
     R2  := FVolMin;
     R3  := FVolMax;
     PCV := PontosCV;
     PAV := PontosAV;
     s1  := FArqPrec;
     s2  := FArqETP;
     OU  := FOperaUsuario;
     end;

  if R1 < 0 then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Volume Inicial inválido: %f', [Nome, R1]));
     TudoOk := False;
     end;

  if R2 < 0 then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Volume Mínimo inválido: %f', [Nome, R2]));
     TudoOk := False;
     end;

  if PAV < 2 then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Curva Área-Volume inválida:'#13 +
            'É necessário pelo menos dois pares de valores', [Nome]));
     TudoOk := False;
     end;

  if PCV < 2 then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Curva Cota-Volume inválida:'#13 +
            'É necessário pelo menos dois pares de valores', [Nome]));
     TudoOk := False;
     end;

  if not VerificarCaminho(s1) then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Arquivo de precipitações não encontrado: %s', [Nome, s1]));
     TudoOk := False;
     end
  else
     if Completo and (PrecipitacaoUnitaria.Len <> FProjeto.Total_IntSim) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 +
               'O número de elementos do arquivo de precipitações [%d]'#13 +
               'não coincide com o número de Intervalos de Simulação [%d]',
               [Nome, PrecipitacaoUnitaria.Len, FProjeto.Total_IntSim]));
        TudoOk := False;
        end;

  if not VerificarCaminho(s2) then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Arquivo de evapotranspiração não encontrado: %s', [Nome, s2]));
     TudoOk := False;
     end
  else
     if Completo and (EvaporacaoUnitaria.Len <> FProjeto.Total_IntSim) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 +
               'O número de elementos do arquivo de evapotranspiração [%d]'#13 +
               'não coincide com o número de Intervalos de Simulação [%d]',
               [Nome, EvaporacaoUnitaria.Len, FProjeto.Total_IntSim]));
        TudoOk := False;
        end;

  VerificarRotinaUsuario(OU, 'Opera', Completo, TudoOk, DialogoDeErros);
  VerificarRotinaUsuario(EU, 'Cálculo de Energia', Completo, TudoOk, DialogoDeErros);
end;

procedure TprPCPR.ColocaDadosNaPlanilha(Planilha: TForm);
var i: Integer;
begin
  inherited;
  with TForm_Planilha_DadosDosObjetos(Planilha).Tab do
    begin
    TextRC[1, 19] := 'Volume';
    for i := 1 to FVolume.Len do NumberRC[i+1, 19] := FVolume[i];
    end;
end;

procedure TprPCPR.GraficarVolumes(Tipo: TEnumTipoDeGrafico);
var g: TgrGrafico;
    b: TChartSeries;
    k: Integer;
begin
  FProjeto.VerificarIntervalosDeAnalise;

  for k := 0 to FProjeto.Intervalos.NumInts - 1 do
    begin
    if not FProjeto.Intervalos.Habilitado[k] then Continue;

    g := CriarGrafico_Default('Volumes do(a) ', k);

    case Tipo of
      tgBarras:
        b := g.Series.AdicionaSerieDeBarras(
               'Volumes', clRed, 0, 0,
               FVolume,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

      tgLinhas:
        b := g.Series.AdicionaSerieDeLinhas(
               'Volumes', clRed, FVolume,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
      end;

    b.ShowInLegend := False;
    DefinirEixoX_Default(b, k);
    g.Show;
    end;
end;

procedure TprPCPR.GraficarTudo;
var D: TprDialogo_Grafico_PCsRes_XTudo;
begin
  FProjeto.VerificarIntervalosDeAnalise;
  D := TprDialogo_Grafico_PCsRes_XTudo.Create(nil);
  Try
    D.Caption := 'Opções para o ' + Nome;
    D.PC := Self;
    D.ShowModal;
  Finally
    D.Release;
    End;
end;

destructor TprPCPR.Destroy;
begin
  FVolume.Free;
  FDeflu_Pl.Free;
  FDeflu_Op.Free;

  inherited Destroy;
end;

procedure TprPCPR.MostrarVariavel(const NomeVar: String);
var v: TV;
    d: TwsDataSet;
begin
  v := nil;
  if CompareText(NomeVar, 'Volume' ) = 0 then v := FVolume;

  if (v <> nil) and (v.Len > 0) then
     begin
     d := ObterDataSet(v);
     MostrarDataSet(NomeVar, d);
     d.Free;
     end
  else
     inherited;
end;

procedure TprPCPR.PrepararParaSimulacao;
var s: String;
begin
  inherited PrepararParaSimulacao;
  FVolume.Len   := FEG.Len;  FVolume.Fill(0);
  FDeflu_Pl.Len := FEG.Len;  FDeflu_Pl.Fill(0);
  FDeflu_Op.Len := FEG.Len;  FDeflu_Op.Fill(0);
end;

function TprPCPR.MudarParaPC(UmMenu: TPopupMenu): TprPCP;
begin
  Result := TprPCP.Create(Pos, FProjeto, nil);
  Result.FTN := FTN;
  Result.Menu := UmMenu;
  GetMessageManager.SendMessage(UM_TROCAR_REFERENCIA, [Self, Result]);
  CopiarPara(Result);
end;

procedure TprPCPR.AutoDescricao(Identacao: byte);
var s, s2: String;
    i    : Integer;  
begin
  inherited;
  s  := StringOfChar(' ', Identacao);

  with gOutPut.Editor do
    begin
    if FStatus then s2 := 'Sim' else s2 := 'Não';
    Write (s + 'Ativo : ' + s2);
    Write;

    WriteFmt (s + 'Volume Inicial : %f', [FVolIni]);
    WriteFmt (s + 'Volume Mínimo  : %f', [FVolMin]);
    WriteFmt (s + 'Volume Máximo  : %f', [FVolMax]);
    Write;

    //WriteFmt (s + 'Coef. Transformação : %f', [FCT]);
    //WriteFmt (s + 'Energia Firme       : %f', [FEF]);
    Write;

    //if FDPE then s2 := 'Sim' else s2 := 'Não';
    Write (s + 'Demanda por Energia : ' + s2);
    Write;

    Write (s + 'Arquivo ETP  : ' + FArqETP);
    Write (s + 'Arquivo Prec : ' + FArqPrec);
    Write;

    s2 := '     ';
    Write (s + 'Cota Volume :');
    for i := 0 to PontosCV - 1 do
      WriteFmt(s + s2 + '%8.3f  %8.3f', [CV[i].Cota, CV[i].Vol]);
    Write;

    s2 := '     ';
    Write (s + 'Área Volume :');
    for i := 0 to PontosAV - 1 do
      WriteFmt(s + s2 + '%8.3f  %8.3f', [AV[i].Area, AV[i].Vol]);
    Write;
    end;
end;

function TprPCPR.CalculaAreaDoReservatorio(const Volume: Real): Real;
var i: Integer;
    A1, A2, V1, V2: Real;
begin
  for i := 0 to High(FAV) do
    if (Volume = FAV[i].Vol) then
       begin
       Result := FAV[i].Area;
       Exit;
       end;

  if Volume < FAV[0].Vol then
     begin
     A1 := FAV[0].Area;  V1 := FAV[0].Vol;
     A2 := FAV[1].Area;  V2 := FAV[1].Vol;   
     Result := - ((A2-A1) * ((V1-Volume)/(V2-V1))) + A1;
     end
  else
     begin
     if Volume > FAV[High(FAV)].Vol then
        begin
        i := High(FAV);
        A1 := FAV[i-1].Area;  V1 := FAV[i-1].Vol;
        A2 := FAV[i  ].Area;  V2 := FAV[i  ].Vol;
        end
     else
        for i := 1 to High(FAV) do
           if (Volume > FAV[i-1].Vol) and (Volume < FAV[i].Vol) then
              begin
              A1 := FAV[i-1].Area;  V1 := FAV[i-1].Vol;
              A2 := FAV[i  ].Area;  V2 := FAV[i  ].Vol;
              Break;
              end;

     Result := (A2-A1) * ((Volume-V1)/(V2-V1)) + A1;
     end;
end;

function TprPCPR.CalculaCotaHidraulica(const Volume: Real): Real;
var i: Integer;
    C1, C2, V1, V2: Real;
begin
  for i := 0 to High(FCV) do
    if (Volume = FCV[i].Vol) then
       begin
       Result := FCV[i].Cota;
       Exit;
       end;

  if Volume < FCV[0].Vol then
     begin
     C1 := FCV[0].Cota;  V1 := FCV[0].Vol;
     C2 := FCV[1].Cota;  V2 := FCV[1].Vol;
     Result := - ((C2-C1) * ((V1-Volume)/(V2-V1))) + C1;
     end
  else
     begin
     if Volume > FCV[High(FCV)].Vol then
        begin
        i := High(FCV);
        C1 := FCV[i-1].Cota;  V1 := FCV[i-1].Vol;
        C2 := FCV[i  ].Cota;  V2 := FCV[i  ].Vol;
        end
     else
        for i := 1 to High(FCV) do
           if (Volume > FCV[i-1].Vol) and (Volume < FCV[i].Vol) then
              begin
              C1 := FCV[i-1].Cota;  V1 := FCV[i-1].Vol;
              C2 := FCV[i  ].Cota;  V2 := FCV[i  ].Vol;
              Break;
              end;

     Result := (C2-C1) * ((Volume-V1)/(V2-V1)) + C1;
     end;
end;

function TprPCPR.ObtemVolFinalIntervaloAnterior: Real;
begin
  if FProjeto.DeltaT = 1 then
    Result := FVolIni
  else
    Result := FVolume[FProjeto.DeltaT - 1];
end;

procedure TprPCPR.Opera(const VolumeDisponivel, DPP, DSP, DTP, Deflu_Pl: Real; // passagem por valor
                        out DPO, DSO, DTO, Deflu_OP: Real);                    // variaveis de saída
          {IMPORTANTE: Deflu_Op não deve incorporar os RETORNOS das
                       Demandas Operadas no Reservatorio - estes são considerados
                       como que retornando ao curso d'água à jusante do mesmo.}
var i: Integer;
    PC: TprPCP;
begin
  FExecutarOperaPadrao := True;

  // FExecutarOperaPadrao pode ser desligado de dentro do Script
  if FExecutarOperaPadrao then // Operação míope
     begin
     DPO      := DPP;
     DSO      := DSP;
     DTO      := DTP;
     Deflu_OP := Deflu_Pl;
     end;

  if FOperaScript <> nil then
     begin
     Projeto.AtualizaPontoExecucao(FNome + '.ScriptOpera', FOperaScript);
     FOperaScript.Execute;
     Projeto.AtualizaPontoExecucao(FNome + '.Opera', nil);
     end;
end;

procedure TprPCPR.BalancoHidrico;
Var i               : Integer;    // Intervalo de Simulação Atual
    j               : Integer;    // Auxiliar
    DemandaTotal    : Real;       // Soma das demandas Totais
    AfluenciaTotal  : Real;       // Toda a água que aflui ao PC no Intervalo
    AfluenciaAux    : Real;       // Auxiliar
    PriVez          : Boolean;    // Auxiliar
    VolumeAtual     : Real;       // Auxiliar
    VolumeAux       : Real;       // Auxiliar
    AguaDisponivel  : Real;       // Auxiliar
    VolInicioInterv : Real;       // Auxiliar
    VolFinalInterv  : Real;       // Auxiliar
    VolumeMedio     : Real;       // Auxiliar
    AreaMedia       : Real;       // Auxiliar
    EvapoMedia      : Real;       // Auxiliar
    EvapoUnitaria   : Real;       // Auxiliar
    PrecipUnitaria  : Real;       // Auxiliar
    CicloEvapo      : Integer;    // Auxiliar
    DPT             : Real;       // Aux. - Demanda Primaria Total
    DST             : Real;       // Aux. - Demanda Secundaria Total
    DTT             : Real;       // Aux. - Demanda Terciaria Total
    DPP             : Real;       // Aux. - Demanda Primaria Planejada
    DSP             : Real;       // Aux. - Demanda Secundaria Planejada
    DTP             : Real;       // Aux. - Demanda Terciaria Planejada
    DPA             : Real;       // Aux. - Demanda Primaria Atendida
    DSA             : Real;       // Aux. - Demanda Secundaria Atendida
    DTA             : Real;       // Aux. - Demanda Terciaria Atendida
    DPO             : Real;       // Aux. - Demanda Primaria Operada
    DSO             : Real;       // Aux. - Demanda Secundaria Operada
    DTO             : Real;       // Aux. - Demanda Terciaria Operada
    Deflu_OP        : Real;       // Aux. - Defluvio Operado
    Deflu_Pl        : Real;       // Aux. - Defluvio Planejado
    Sair            : Boolean;
    Retorno         : Real;       // Aux. - Fração de Retorno
    Queda           : Real;       // Aux. - Queda Hidráulica
    Vazao           : Real;       // Aux. -  em m3/s
    Vertimento      : Real;       // Aux.
Begin
  Projeto.AtualizaPontoExecucao(FNome + '.BalancoHidrico', nil);

  // Inicializa variáveis auxiliares
  i               := FProjeto.DeltaT;
  PriVez          := True;
  VolumeAtual     := 0;
  VolInicioInterv := ObtemVolFinalIntervaloAnterior;
  VolFinalInterv  := VolInicioInterv;
  EvapoMedia      := 0;
  EvapoUnitaria   := EvaporacaoUnitaria[i];
  PrecipUnitaria  := PrecipitacaoUnitaria[i];
  CicloEvapo      := 1;
  DPO             := 0;
  DSO             := 0;
  DTO             := 0;
  DPT             := M3_Hm3_Intervalo(FDPT[i]);
  DST             := M3_Hm3_Intervalo(FDST[i]);
  DTT             := M3_Hm3_Intervalo(FDTT[i]);
  Vertimento      := 0;
  Deflu_OP        := 0;

  {
  Calculo das vazões afluentes
     - das Sub-bacias do PC e
     - dos PCs à montante do Reservatorio

     Cálculo do campo AfluenciaSB
       - FAfluenciaSB[i] é iniciada em zero por método da própria
         Classe SubBacia
  }

  FAfluenciaSB[i] := ObtemVazaoAfluenteSBs;

  // Cálculo do campo VazõesDeMontante
  FVzMon[i] := ObtemVazoesDeMontante;
  AfluenciaTotal := M3_Hm3_Intervalo(FVzMon[i]);

  // Totalização da agua afluente ao PC no DeltaT atual
  // FAfluenciaSB já esta sendo inicializado em PrepararParaSimulacao
  AfluenciaTotal := AfluenciaTotal + M3_Hm3_Intervalo(FAfluenciaSB[i]);

  // Prepara para análise para atendimento das Demandas Hídricas no PC.
  DPP := M3_Hm3_Intervalo(FDPP[i]);
  DSP := M3_Hm3_Intervalo(FDSP[i]);
  DTP := M3_Hm3_Intervalo(FDTP[i]);
  Deflu_Pl := M3_Hm3_Intervalo(FDeflu_Pl[i]);

{ Inicio da OPERACAO DO RESERVATORIO:
  A operação é feita dentro de um conjunto de CICLOS DE AJUSTE DA
  EVAPORAÇÃO DO RESERVATORIO }

  CicloEvapo := 0;
  Sair := False;
  Repeat
    inc(CicloEvapo);

    VolumeMedio := (VolInicioInterv + VolFinalInterv) / 2;
    AreaMedia   := CalculaAreaDoReservatorio(VolumeMedio);

    // Retira da AfluenciaTotal a EvaporacaoMedia menos o que precipitou
    // sobre o reservatório no intervalo.

    // A multiplicação abaixo por 0,001 transforma mm*km2 em Hm3
    AfluenciaAux := AfluenciaTotal - 0.001 * AreaMedia * (EvapoUnitaria - PrecipUnitaria);

    // VERIFICA SE EXISTE ÁGUA suficiente para prosseguir o processamento:
       // se o Armazenamento Inicial é zero e se não existe
       // afluência, portanto, não existe água para o atendimento
       // de nenhuma demanda no PC.
    if (VolInicioInterv = 0) and (AfluenciaAux <= 0) then Break;

    // Se o armazenamento no inicio do mes nao é nulo, pode acontecer
    // que a afluencia seja negativa. Isso acontece quando nao existe
    // afluencia de fato, so evaporacao. Assim o proximo passo e
    // testar se isso nao ira zerar a existencia de agua ou, entao, a
    // torne tao pequena (menor que o Volume Morto = VolumeMinimo) que
    // nao possa satisfazer as demandas.
    VolumeAtual := VolInicioInterv + AfluenciaAux;
    if VolumeAtual <= 0 then
      // É possível que em uma primeira vez isso aconteça em função de
      // uma evaporação excessiva em virtude de uma aproximação
      // grosseira no cálculo. Assim é tentada uma segunda vez agora com
      // o VolFinalInterv = 0. Isso é controlado pela variável auxiliar
      // PrimVez.
      begin
      VolumeAtual:= 0;
      if Not PriVez then
         begin
         VolFinalInterv := VolumeAtual;
         Break; // NÃO HÁ ÁGUA - Sai do ciclo
         end
      else
         begin
         VolFinalInterv := 0;
         PriVez := False;
         Continue;
         end
      end
    else
      PriVez := True;
    // ... continua o teste da disponibilidade de água; agora se o
    // VolumeAtual nao é inferior ao VolumeMinimo.
    if VolumeAtual <= VolumeMinimo then
       // Mais uma vez é possível que isso aconteça em função de uma
       // evaporação excessiva em virtude de uma aproximação grosseira no
       // cálculo. Assim é tentada uma segunda vez agora com o
       // o VolFinalInterv = VolumeAtual. Isso é controlado, também, pela
       // variável auxiliar PrimVez.
       if Not PriVez then
          begin
          VolFinalInterv := VolumeAtual;
          Break; // NÃO HÁ ÁGUA - Sai do ciclo
          end
       else
          begin
          VolFinalInterv := VolumeAtual;
          PriVez := False;
          Continue;
          end
    else
      PriVez := True;
    {EXISTE ÁGUA - é chamado o método Opera que contém as regras de operação
     do reservatório. Este método pode ser escrito pelo usuário com o propósito
     de testar regras operacionais.
     Seu funcionamento pode ser combinado com o método Planeja da Classe Projeto.
     É feita a verificação se as demandas planejadas podem ser atendidas totalmente ou
     apenas em parte.
     Como saída este método dá:
       DPO = Demanda Primaria Operada,
       DSO = Demanda Secundária Operada,
       DTO = Demanda Terciária Operada e
       Deflu_OP = defluvio operado (agua que é liberada para jusante)
                  IMPORTANTE: Deflu_Op não deve incorporar os RETORNOS das
                              Demandas Operadas no Reservatorio - estes são
                              considerados como que retornando ao curso d'água
                              à jusante do mesmo.
     Outras variaveis podem ser alteradas (ver cabeçalho do método) sob exclusiva
     responsabilidade do usuário.}

    VolumeAux := VolumeAtual;
    Opera(VolumeAtual, DPP, DSP, DTP, Deflu_Pl, {out} DPO, DSO, DTO, Deflu_OP);

    Projeto.AtualizaPontoExecucao(FNome + '.BalancoHidrico', nil);

    // Verifica a CONSISTÊNCIA das DEMANDAS OPERADAS.
    if DPO > DPT then
       begin
       DPO := DPT;
       // avisa do erro
       end;

    if DSO > DST then
       begin
       DSO := DST;
       // avisa do erro
       end;

    if DTO > DTT then
       begin
       DTO := DTT;
       // avisa do erro
       end;

    // Verifica a CONSISTÊNCIA de saída da OPERA em termos de
    // VIABILIDADE FÍSICA DO VOLUME DO RESERVATÓRIO

    VolumeAtual := VolumeAtual - (DPO + DSO + DTO + Deflu_OP);  // <<<< VolumeAtual está dando negativo

    // verifica se o VolumeAtual é inferior ao mínimo
    if VolumeAtual < VolumeMinimo then
       begin
       // procura atender à limitação do VolumeMinimo reduzindo a defluência operada
       Deflu_OP := Deflu_OP - (VolumeMinimo - VolumeAtual);

       if Deflu_OP >= 0 then
          // somente a redução da defluência foi suficiente
          // DPO, DSO e DTO continuam atendidas conforme a OPERA
          VolumeAtual := VolumeMinimo
       else
          {NÃO É SUFICIENTE REDUZIR APENAS A DEFLUÊNCIA:
           - esta situação já deveria ter sido tratada em Planeja e/ou
           em Opera através de um critério de racionamento de modo
           que agora não acontecesse esse tipo de inviabilidade.
           Entretanto, esses testes são feitos exatamente para que se
           isso venha a acontecer, não tendo sido tratado
           convenientemente pelo usuário não prejudique o
           desenvolvimento da simulação.}

           begin
             // existe água a ser racionada - é chamado o RACIONA
             // a saída da OPERA é tornada sem efeito
             // o VolumeAtual é reconstituído para o valor anterior à utilização da OPERA
             VolumeAtual := VolumeAux;
             AguaDisponivel := VolumeAtual - VolumeMinimo;

             Raciona(AguaDisponivel, DPP, DSP, DTP, {out} DPA, DSA, DTA);

             Projeto.AtualizaPontoExecucao(FNome + '.BalancoHidrico', nil);

             DPO         := DPA;
             DSO         := DSA;
             DTO         := DTA;
             Deflu_OP    := 0 ;
             VolumeAtual := VolumeMinimo;
          end;
       end; // VolumeAtual é menor que VolumeMinimo ...

    // verifica se o VolumeAtual é superior ao máximo
    if VolumeAtual > VolumeMaximo then
       begin
       Vertimento := VolumeAtual - VolumeMaximo;
       VolumeAtual := VolumeMaximo;
       end;
    // verifica CONVERGÊNCIA de VOLUMES para cálculo da EVAPORAÇÃO
    Sair := (ABS(VolFinalInterv - VolumeAtual) <= (0.01 * VolumeMaximo));
    VolFinalInterv := VolumeAtual;

  until Sair or (CicloEvapo > 100);

  // Atualização das Demandas Atendidas.
  FDPA[I]    := Hm3_m3_Intervalo(DPO);
  FDSA[I]    := Hm3_m3_Intervalo(DSO);
  FDTA[I]    := Hm3_m3_Intervalo(DTO);
  FVolume[i] := VolFinalInterv;
  Retorno    := FFRP*DPO + FFRS*DSO + FFRT*DTO;

  // Atualização da Defluencia.
  FDefluencia[i] := Hm3_m3_Intervalo(Deflu_OP + Retorno + Vertimento);
  FDeflu_OP[i] := Deflu_OP;

  // Cálculo da Energia Gerada quando houver geração no Reservatorio
  if FGerarEnergia then
     begin
     Queda := CalculaCotaHidraulica((VolumeAtual + VolInicioInterv) / 2) - FCotaJusante;
     FEG[i] := CalculaEnergia(Queda, Hm3_m3_Intervalo(Deflu_OP));
     if FEnergiaScript <> nil then
        begin
        FProjeto.AtualizaPontoExecucao(FNome + '.ScriptEnergia', FEnergiaScript);
        FEnergiaScript.Execute;
        end;
     end;
end; // PCPR.BalancoHidrico

function TprPCPR.GetEU: TV;
var ds: char;
    s1: String;
begin
  if FEU = nil then
     begin
     s1 := FArqETP;
     VerificarCaminho(s1);
     FEU := TV.Create(0);  
     ds := DecimalSeparator;
     DecimalSeparator := '.';
     try
       FEU.LoadFromTextFile(s1);
     finally
       DecimalSeparator := ds;
       end;
     end;

  Result := FEU;
end;

function TprPCPR.GetPU: TV;
var ds: char;
    s1: String;
begin
  if FPU = nil then
     begin
     s1 := FArqPrec;
     VerificarCaminho(s1);
     FPU := TV.Create(0);
     ds := DecimalSeparator;
     DecimalSeparator := '.';
     try
       FPU.LoadFromTextFile(s1);
     finally
       DecimalSeparator := ds;
       end;
     end;

  Result := FPU;
end;

function TprPCPR.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     if FOperaUsuario <> '' then
        begin
        PreparaScript(FOperaUsuario, FOperaScript);
        FOperaScript.Compile;
        end
     else
        if FProjeto.FOperaUsuario <> '' then
           begin
           PreparaScript(FProjeto.FOperaUsuario, FOperaScript);
           FOperaScript.Compile;
           end;
     end else

    if MSG.ID = UM_LIBERAR_SCRIPTS then
       FreeAndNil(FOperaScript);

  inherited ReceiveMessage(MSG);
end;

procedure TprPCPR.Monitorar;
var i: Integer;
begin
  inherited;
  if Assigned(FEventoDeMonitoracao) then
     begin
     i := FProjeto.DeltaT;

     if System.Pos('Volume', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Volume', FVolume[i]);

     if System.Pos('Defluvio Planejado', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Defluvio Planejado', FDeflu_Pl[i]);

     if System.Pos('Defluvio Operado', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Defluvio Planejado', FDeflu_Op[i]);
     end;
end;

function TprPCPR.Optimizer_getValue(const PropName: string; Year, Month: Integer): real;
begin
  if CompareText(PropName, 'VolumeMaximo') = 0 then
     Result := FVolMax else

  if CompareText(PropName, 'VolumeMinimo') = 0 then
     Result := FVolMin else

  if CompareText(PropName, 'VolumeInicial') = 0 then
     Result := FVolIni else

  if CompareText(PropName, 'CotaJusante') = 0 then
     Result := FCotaJusante else

  Result := inherited Optimizer_getValue(PropName, Year, Month);
end;

procedure TprPCPR.Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real);
begin
  if CompareText(PropName, 'VolumeMaximo') = 0 then
     FVolMax := r else

  if CompareText(PropName, 'VolumeMinimo') = 0 then
     FVolMin := r else

  if CompareText(PropName, 'VolumeInicial') = 0 then
     FVolIni := r else

  if CompareText(PropName, 'CotaJusante') = 0 then
     FCotaJusante := r else

  inherited;
end;

{ TprSubBacia }

constructor TprSubBacia.Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(UmaTabelaDeNomes, Projeto);
  FArea := 1;

  FDemandas := TListaDeObjetos.Create; {Demandas Difusas}
  FPCs      := TListaDeObjetos.Create;
  FCCs      := TDoubleList.Create;

  DefinirVariaveisQuePodemSerMonitoradas(['Vazao']);

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);

  CriarComponenteVisual(Pos);
end;

destructor TprSubBacia.Destroy;
begin
  GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);
  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);

  FDemandas.Free;
  FPCs.Free;
  FCCs.Free;
  LiberaVazoes;
  inherited Destroy;
end;

function TprSubBacia.getNDD: Integer;
begin
  Result := FDemandas.Objetos;
end;

procedure TprSubBacia.SalvarEmArquivo(Arquivo: TIF);
var i: Integer;
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteFloat   (Section, 'Area'    ,               FArea);
    WriteInteger (Section, 'Demandas',               Demandas);
    WriteString  (Section, 'Vazoes Afluentes',       FArqVA);

    for i := 0 to Demandas - 1 do
       WriteString (Section, 'DM'+IntToStr(i+1), Demanda[i].Nome);

    WriteInteger (Section, 'Coefs. de Contribuicao' , FCCs.Count);
    for i := 0 to FCCs.Count - 1 do
       WriteFloat (Section, 'Coef'+IntToStr(i+1), FCCs[i]);
    end;
end;

function TprSubBacia.AdicionaObjeto(Obj: THidroComponente): Integer;
begin
  SetModificado(True);
  if Obj is TprDemanda then
     begin
     FDemandas.Adicionar(Obj);
     TprDemanda(Obj).Tipo := tdDifusa;
     end;
end;

function TprSubBacia.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
begin
  if MSG.ID = UM_OBJETO_SE_DESTRUINDO then
    {Verifica se o objeto que está se destruindo está conectado a esta Sub-Bacia.
     Se está, elimina a referência}
     begin
     i := FDemandas.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then FDemandas.Deletar(i);
     end
  else

  if MSG.ID = UM_REPINTAR_OBJETO then
     begin
     SetPos(FPos);
     end
  else

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     i := FPCs.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then FPCs.Objeto[i] := MSG.ParamAsPointer(1);
     end;

  inherited ReceiveMessage(MSG);
end;

function TprSubBacia.ObtemPrefixo: String;
begin
  Result := 'SubBacia_';
end;

function TprSubBacia.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_SB.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

procedure TprSubBacia.PegarDadosDoDialogo(d: TprDialogo_Base);
var i: Integer;
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_SB) do
    begin
    FArea := StrToFloat(edArea.Text);
    FArqVA := edVA.Text;
    if ArqVazModificado then LiberaVazoes;
    for i := 1 to FPCs.Objetos do
      FCCs.AsString[i-1] := sgCoefs.Cells[1, i];
    end;
end;

procedure TprSubBacia.PorDadosNoDialogo(d: TprDialogo_Base);
var i: Integer;
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_SB) do
    begin
    edArea.AsFloat   := FArea;
    edVA.Text        := FArqVA;
    sgCoefs.RowCount := FPCs.Objetos + 1;

    for i := 1 to FPCs.Objetos do
      begin
      sgCoefs.Cells[0, i] := TprPCP(FPCs.Objeto[i-1]).Nome;
      sgCoefs.Cells[1, i] := FCCs.AsString[i-1];
      end;
    end;
end;

procedure TprSubBacia.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var R1: Real; // Area
    s1: String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if Dialogo <> nil then
     begin
     R1 := TprDialogo_SB(Dialogo).edArea.AsFloat;
     s1 := TprDialogo_SB(Dialogo).edVA.Text;
     end
  else
     begin
     R1 := FArea;
     s1 := FArqVA;
     end;

  if R1 < 0 then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Área inválida: %f', [Nome, R1]));
     TudoOk := False;
     end;

  if Dialogo <> nil then Exit;

  if not VerificarCaminho(s1) then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Arquivo de vazões não encontrado: %s', [Nome, s1]));
     TudoOk := False;
     end
  else
     if Completo and (Vazoes.Len <> FProjeto.Total_IntSim) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 +
               'O número de elementos do arquivo de vazões [%d]'#13 +
               'não coincide com o número de Intervalos de Simulação [%d]',
               [Nome, Vazoes.Len, FProjeto.Total_IntSim]));
        TudoOk := False;
        end;
end;

function TprSubBacia.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'SUB_BACIA_20X20');
  Result.Width := 20;
  Result.Height := 20;
  TdrBitmap(Result).DrawFrame := True;
end;

procedure TprSubBacia.LerDoArquivo(Ini: TIF; Const Secao: String);
var i, ii: Integer;
begin
  Inherited LerDoArquivo(Ini, Secao);
  with Ini do
    begin
    FArea  := Ini.ReadFloat  (Secao, 'Area', 0);
    FArqVA := Ini.ReadString (Section, 'Vazoes Afluentes', '');

    ii := ReadInteger (Section, 'Coefs. de Contribuicao' , FCCs.Count);
    for i := 1 to ii do
       FCCs.Add(ReadFloat (Section, 'Coef'+IntToStr(i), 0.0));
    end;
end;

function TprSubBacia.GetDD(index: Integer): TprDemanda;
begin
  Result := TprDemanda(FDemandas[Index]);
end;

function TprSubBacia.GetVazoes: TV;
var ds: char;
    s1: String;
begin
  if FVazoes = nil then
     begin
     s1 := FArqVA;
     FVazoes := TV.Create(0);
     ds := DecimalSeparator;
     DecimalSeparator := '.';
     VerificarCaminho(s1);
     FVazoes.LoadFromTextFile(s1);
     DecimalSeparator := ds;
     end;

  Result := FVazoes;
end;

procedure TprSubBacia.LiberaVazoes;
begin
  if FVazoes <> nil then
     FreeAndNil(FVazoes);
end;

procedure TprSubBacia.LimpaObjetos;
var i: Integer;
begin
  while FDemandas.Objetos > 0 do
    begin
    FDemandas[FDemandas.Objetos-1].Free;
   {O delete será dado quando a própria subbacia recebar a mensagem
    de destruição da demanda}
    //FDemandas.Lista.Delete(i);
    end;
end;

function TprSubBacia.ObtemVazaoAfluente(PC: TprPCP): Real;
var i : Integer;  // Intervalo de Simulação
    k : Integer;  // Contador
    CC: Real;     // Coef. Contribuição
    D : Real;     // Somatório das demandas difusas
    DM: TprDemanda; // n-égima Demanda
begin
  i := FProjeto.DeltaT;

  // Calcula o consumo das demandas difusas ativas
  D := 0;
  for k := 0 to Demandas-1 do
    if Demanda[k].Ligada then
       begin
       DM := Demanda[k];

       // As unidades da demanda são dependentes da data geral da simulação
       DM.Data := FProjeto.Data;
       D := D + DM.UnidadeDeConsumo * DM.UnidadeDeDemanda * Area * DM.FatorDeConversao;
       end;

  Result := Max(0, (Vazoes[i] - D)) * CCs[PCs.IndiceDo(PC)];
end;

procedure TprSubBacia.PrepararParaSimulacao;
begin
  Inherited PrepararParaSimulacao;
  LiberaVazoes;
end;

procedure TprSubBacia.GraficarVazoes(Tipo: TEnumTipoDeGrafico);
var g: TgrGrafico;
    b: TChartSeries;
    k: Integer;
begin
  FProjeto.VerificarIntervalosDeAnalise;

  for k := 0 to FProjeto.Intervalos.NumInts - 1 do
    begin
    if not FProjeto.Intervalos.Habilitado[k] then Continue;

    g := CriarGrafico_Default('Vazões da(o) ', k);

    case Tipo of
      tgBarras:
        b := g.Series.AdicionaSerieDeBarras(
               'Vazões', clRed, 0, 0,
               GetVazoes,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

      tgLinhas:
        b := g.Series.AdicionaSerieDeLinhas(
               'Vazões', clRed, GetVazoes,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
      end;

    b.ShowInLegend := False;
    DefinirEixoX_Default(b, k);
    g.Show;
    end;
end;

procedure TprSubBacia.ColocaDadosNaPlanilha(Planilha: TForm);
var i: Integer;
begin
  with TForm_Planilha_DadosDosObjetos(Planilha).Tab do
    begin
    TextRC[1, 2] := 'Vazões';
    for i := 1 to Vazoes.Len do NumberRC[i+1, 2] := Vazoes[i];
    end;
end;

procedure TprSubBacia.MostrarVariavel(const NomeVar: String);
var d: TwsDataSet;
begin
  d := ObterDataSet(GetVazoes);
  MostrarDataSet('Vazões', d);
  d.Free;
end;

procedure TprSubBacia.AutoDescricao(Identacao: byte);
var s, s2: String;
    i    : Integer;
begin
  inherited;
  s  := StringOfChar(' ', Identacao);
  s2 := s + StringOfChar(' ', 19);

  with gOutPut.Editor do
    begin
    WriteFmt(s + 'Área             : %f', [Area]);
    Write   (s + 'Vazões Afluentes : ' + Arq_VazoesAfluentes);
    Write   (s + 'Contribuições    : PCs       Coeficientes');
    //Write   (s2 +     'PCs       Coeficientes');
    for i := 0 to CCs.Count - 1 do
       WriteFmt(s2 +  '%-9s %f', [PCs[i].Nome, CCs[i]]);

    Write;   
    end;
end;

procedure TprSubBacia.Monitorar;
var i: Integer;
begin
  inherited;

  if Assigned(FEventoDeMonitoracao) then
     begin
     i := FProjeto.DeltaT;

     if System.Pos('Vazao', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Vazao', FVazoes[i]);
     end;
end;

function TprSubBacia.ObterVazaoAfluente(PC: TprPCP): Real;
begin

end;

{ THidroDemanda }

function THidroDemanda.GetBitmapName: String;
begin
  Result := 'Bitmap ' + FNome;
end;

function THidroDemanda.GetBitmap: TBitmap;
begin
  Result := TdrBitmap(FImagemDoComponente).Bitmap;
end;

procedure THidroDemanda.SetBitmap(B: TBitmap);
begin
  if B <> Nil then
     TdrBitmap(FImagemDoComponente).Bitmap.Assign(B);
end;

procedure THidroDemanda.BitmapChange(Sender: TObject);
begin
  SetModificado(True);
  FBitmapMudou := True;
end;

procedure THidroDemanda.LerDoArquivo(Ini: TIF; const Secao: String);
begin
  Inherited LerDoArquivo(Ini, Secao);
  with Ini do
    begin
    FLigada := ReadBool (Section, 'Status', False);
    FPrioridade := TEnumPriorDemanda(ReadInteger (Section, 'Prioridade', 0));
    end;
end;

procedure THidroDemanda.SalvarEmArquivo(Arquivo: TIF);
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteBool    (Section, 'Status', FLigada);
    WriteInteger (Section, 'Prioridade', ord(FPrioridade));
    end;
end;

function THidroDemanda.getDemanda: Real;
begin
  raise Exception.CreateFmt(
    'Metodo "getDemanda" nao implementado na classe %s', [self.ClassName]);
end;

{ TprClasseDemanda }

constructor TprClasseDemanda.Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(UmaTabelaDeNomes, Projeto);
  FED := 1;
  FFR := 0;
  FSalvarLerBitmap := True;

  FSincronizaDados := True;
  FSincVU          := True;
  FSincUD          := False;
  FSincFI          := True;

  CriarComponenteVisual(Pos);
end;

function TprClasseDemanda.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'DEMANDA_IRRIGACAO_20X20');
  Result.Visible := False;
  Result.Width := 20;
  Result.Height := 20;
  with TdrBitmap(Result) do
    begin
    DrawFrame := True;
    Bitmap.Transparent := True;
    Bitmap.TransparentMode := tmAuto;
    Bitmap.OnChange := BitmapChange;
    end;
end;

function TprClasseDemanda.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_ClasseDeDemanda.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

procedure TprClasseDemanda.LerDoArquivo(Ini: TIF; const Secao: String);
var i,j       : Integer;
    s, s1, s2 : String;
    SL        : TStrings;
begin
  Inherited LerDoArquivo(Ini, Secao);
  with Ini do
    begin
    FED   := ReadFloat   (Section,  'EscalaDeDesenvolvimento',   1);
    FFC   := ReadFloat   (Section,  'FatorDeConversao',          0);
    FFR   := ReadFloat   (Section,  'FatorDeRetorno',            0);
    FNUCD := ReadString  (Section,  'NomeUnidadeDeConsumoDagua','');
    FNUD  := ReadString  (Section,  'NomeUnidadeDeDemanda',     '');

    FSincronizaDados  := ReadBool   (Section,  'Sincronizacao',  True);
    FSincVU           := ReadBool   (Section,  'Sinc. TVU',      True);
    FSincUD           := ReadBool   (Section,  'Sinc. TUD',      False);
    FSincFI           := ReadBool   (Section,  'Sinc. TFI',      True);

    SetLength(FVU, ReadInteger (Section,  'NTVU', 0));
    SetLength(FUD, ReadInteger (Section,  'NTUD', 0));
    SetLength(FFI, ReadInteger (Section,  'NTFI', 0));

    for i := 0 to High(FVU) do
      begin
      s := ReadString(Section, 'TVU' + IntToStr(i+1), '(0-0)|00');

      // leitura dos anos
      SubStrings('-', s1, s2, SubString(s, '(', ')'));
      FVU[i].AnoIni := StrToInt(s1);
      FVU[i].AnoFim := StrToInt(s2);

      // leitura dos meses
      s := Copy(s, System.Pos(')', s) + 2, Length(s));
      SL := TStringList.Create;
      StringToStrings(s, SL, ['|']);
      if SL.Count > 0 then
         for j := 1 to 12 do
           try
             FVU[i].Mes[j] := strToFloat(SL[j-1]);
           except
             FVU[i].Mes[j] := 0;
           end;
      SL.Free;
      end;

    for i := 0 to High(FFI) do
      begin
      s := ReadString(Section, 'TFI' + IntToStr(i+1), '(0-0)|00');

      // leitura dos anos
      SubStrings('-', s1, s2, SubString(s, '(', ')'));
      FFI[i].AnoIni := StrToInt(s1);
      FFI[i].AnoFim := StrToInt(s2);

      // leitura dos meses
      s := Copy(s, System.Pos(')', s) + 2, Length(s));
      SL := TStringList.Create;
      StringToStrings(s, SL, ['|']);
      if SL.Count > 0 then
         for j := 1 to 12 do
           try
             FFI[i].Mes[j] := strToFloat(SL[j-1]);
           except
             FFI[i].Mes[j] := 0;
           end;
      SL.Free;
      end;

    for i := 0 to High(FUD) do
      begin
      s := ReadString(Section, 'TUD' + IntToStr(i+1), '(0-0)|NADA');

      // leitura dos anos e Unidades
      SubStrings('-', s1, s2, SubString(s, '(', ')'));
      FUD[i].AnoIni := StrToInt(s1);
      FUD[i].AnoFim := StrToInt(s2);
      FUD[i].Unidade := strToFloat(Copy(s, System.Pos(')', s) + 2, Length(s)));
      end;

      if FSalvarLerBitmap then
         Bitmap := LerBitmapDoArquivo(Ini, 'Bitmap ' + FNome);
    end;
end;

procedure TprClasseDemanda.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_ClasseDeDemanda) do
    begin
    if ImagemMudou then
       begin
       Bitmap.Assign(Image.Picture);
       Gerenciador.ReconstroiArvore;
       end;

    if FLigada <> boolean(cbStatus.ItemIndex) then
       begin
       FLigada := boolean(cbStatus.ItemIndex);
       if FLigada then
          GetMessageManager.SendMessage(UM_HABILITAR_STATUS,
          [@FNome, self, FProjeto])
       else
          GetMessageManager.SendMessage(UM_DESABILITAR_STATUS,
          [@FNome, self, FProjeto]);
       end;

    FED    := edED.AsFloat;
    FFC    := edFC.AsFloat;
    FFR    := edFR.AsFloat;
    FNUCD  := edUCA.Text;
    FNUD   := edUD.Text;

    DLG_TVU.Obter(FVU);
    DLG_TUD.Obtem(FUD);
    DLG_TFI.Obter(FFI);

    if TEnumPriorDemanda(cbPrioridade.ItemIndex) <> FPrioridade then
       begin
       FPrioridade := TEnumPriorDemanda(cbPrioridade.ItemIndex);
       Gerenciador.ReconstroiArvore;
       end;

    FSincronizaDados := DLG_OPC.cbSincronizar.Checked;
    FSincVU          := DLG_OPC.cbTVU.Checked;
    FSincUD          := DLG_OPC.cbTUD.Checked;
    FSincFI          := DLG_OPC.cbTFI.Checked;

    GetMessageManager.SendMessage(UM_DADOS_DO_ANCESTRAL_MUDARAM,
      [@FNome, self, FProjeto, // Ident. de quem esta mandando a mensagem
       DLG_SD.DstList.Items]);
    end;
end;

procedure TprClasseDemanda.PorDadosNoDialogo(d: TprDialogo_Base);
var AnoIni, AnoFim: Integer;
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_ClasseDeDemanda) do
    begin
    Image.Picture.Assign(Bitmap);
    cbStatus.ItemIndex  := integer(FLigada);
    edED.AsFloat := FED;
    edFC.AsFloat := FFC;
    edFR.AsFloat := FFR;
    edUCA.Text   := FNUCD;
    edUD.Text    := FNUD;

    cbPrioridade.ItemIndex := ord(FPrioridade);

    //Projeto := TprDialogo_AreaDeProjeto(FProjeto).Projeto;
    if Length(Projeto.AnosDeExecucao) > 0 then
       begin
       AnoIni := FProjeto.AnosDeExecucao[0].AnoIni;
       AnoFim := FProjeto.AnosDeExecucao[High(FProjeto.AnosDeExecucao)].AnoFim;
       end
    else
       begin
       AnoIni := 0;
       AnoFim := 0;
       end;

    DLG_TVU.Atribuir(FVU, AnoIni, AnoFim);
    DLG_TUD.Atribui(FUD, AnoIni, AnoFim);
    DLG_TFI.Atribuir(FFI, AnoIni, AnoFim);

    DLG_OPC.cbSincronizar.Checked := FSincronizaDados;
    DLG_OPC.cbTVU.Checked := FSincVU;
    DLG_OPC.cbTUD.Checked := FSincUD;
    DLG_OPC.cbTFI.Checked := FSincFI;
    end;
end;

procedure TprClasseDemanda.SalvarEmArquivo(Arquivo: TIF);
var i,j: Integer;
    s  : String;
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteFloat   (Section,  'EscalaDeDesenvolvimento',   FED);
    WriteFloat   (Section,  'FatorDeConversao',          FFC);
    WriteFloat   (Section,  'FatorDeRetorno',            FFR);
    WriteString  (Section,  'NomeUnidadeDeConsumoDagua', FNUCD);
    WriteString  (Section,  'NomeUnidadeDeDemanda',      FNUD);
    WriteInteger (Section,  'NTVU',                      length(FVU));
    WriteInteger (Section,  'NTUD',                      length(FUD));
    WriteInteger (Section,  'NTFI',                      length(FFI));

    WriteBool    (Section,  'Sincronizacao', FSincronizaDados);
    WriteBool    (Section,  'Sinc. TVU',     FSincVU);
    WriteBool    (Section,  'Sinc. TUD',     FSincUD);
    WriteBool    (Section,  'Sinc. TFI',     FSincFI);

    WriteString  (Section,  'Bitmap', 'Bitmap ' + FNome);

    for i := 0 to High(FVU) do
      begin
      s := Format('(%d-%d)', [FVU[i].AnoIni, FVU[i].AnoFim]);
      for j := 1 to 12 do s := s + '|' + FloatToStr(FVU[i].Mes[j]);
      WriteString(Section, 'TVU' + IntToStr(i+1), s);
      end;

    for i := 0 to High(FUD) do
      begin
      s := Format('(%d-%d)', [FUD[i].AnoIni, FUD[i].AnoFim]);
      s := s + '|' + FloatToStr(FUD[i].Unidade);
      WriteString(Section, 'TUD' + IntToStr(i+1), s);
      end;

    for i := 0 to High(FFI) do
      begin
      s := Format('(%d-%d)', [FFI[i].AnoIni, FFI[i].AnoFim]);
      for j := 1 to 12 do s := s + '|' + FloatToStr(FFI[i].Mes[j]);
      WriteString(Section, 'TFI' + IntToStr(i+1), s);
      end;

     if FSalvarLerBitmap then
        SalvarBitmapEmArquivo(Bitmap, Arquivo, 'Bitmap ' + FNome);
    end;
end;

function TprClasseDemanda.ObtemPrefixo: String;
begin
  Result := 'ClasseDeDemanda_';
end;

function TprClasseDemanda.getFatorDeImplantacao(Ano, Mes: Integer): Real;
var i, ii, n: Integer;
begin
  n := Length(FFI);

  ii := n-1;
  for i := 0 to n-1 do
    if (Ano >= FFI[i].AnoIni) and (Ano <= FFI[i].AnoFim) then
       begin
       ii := i;
       Break;
       end;

  if n > 0 then Result := FFI[ii].Mes[1] else Result := 0;
end;

function TprClasseDemanda.getUnidadeDeConsumo(Ano, Mes: Integer): Real;
var i, ii, n: Integer;
begin
  n := Length(FVU);

  ii := n-1;
  for i := 0 to n-1 do
    if (Ano >= FVU[i].AnoIni) and (Ano <= FVU[i].AnoFim) then
       begin
       ii := i;
       Break;
       end;

  if n > 0 then Result := FVU[ii].Mes[Mes] else Result := 0;
end;

function TprClasseDemanda.getUnidadeDeDemanda(Ano, Mes: Integer): Real;
var i, ii, n: Integer;
begin
  n := Length(FUD);

  ii := n-1;
  for i := 0 to n-1 do
    if (Ano >= FUD[i].AnoIni) and (Ano <= FUD[i].AnoFim) then
       begin
       ii := i;
       Break;
       end;

  if n > 0 then Result := FUD[ii].Unidade else Result := 0;
end;

function TprClasseDemanda.setFatorDeImplantacao(Ano, Mes: Integer; Valor: real): Real;
var i, ii, n: Integer;
begin
  n := Length(FFI);

  ii := n-1;
  for i := 0 to n-1 do
    if (Ano >= FFI[i].AnoIni) and (Ano <= FFI[i].AnoFim) then
       begin
       ii := i;
       Break;
       end;

  if n > 0 then
     FFI[ii].Mes[1] := Valor;
end;

function TprClasseDemanda.setUnidadeDeConsumo(Ano, Mes: Integer; Valor: real): Real;
var i, ii, n: Integer;
begin
  n := Length(FVU);

  ii := n-1;
  for i := 0 to n-1 do
    if (Ano >= FVU[i].AnoIni) and (Ano <= FVU[i].AnoFim) then
       begin
       ii := i;
       Break;
       end;

  if n > 0 then
     FVU[ii].Mes[Mes] := Valor;
end;

function TprClasseDemanda.setUnidadeDeDemanda(Ano, Mes: Integer; Valor: real): Real;
var i, ii, n: Integer;
begin
  n := Length(FUD);

  ii := n-1;
  for i := 0 to n-1 do
    if (Ano >= FUD[i].AnoIni) and (Ano <= FUD[i].AnoFim) then
       begin
       ii := i;
       Break;
       end;

  if n > 0 then
     FUD[ii].Unidade := Valor;
end;

function TprClasseDemanda.GetUC: Real;
begin
  Result := getUnidadeDeConsumo(FData.Ano, FData.Mes);
end;

function TprClasseDemanda.GetUD: Real;
begin
  Result := getUnidadeDeDemanda(FData.Ano, FData.Mes);
end;

function TprClasseDemanda.GetFI: Real;
begin
  Result := getFatorDeImplantacao(FData.Ano, FData.Mes);
end;

procedure TprClasseDemanda.AutoDescricao(Identacao: byte);
var s, s2: String;
    i,j  : Integer;
begin
  inherited;
  if self is TprDemanda then exit;

  s := StringOfChar(' ', Identacao);

  with gOutPut.Editor do
    begin
    if FLigada then s2 := 'Ligada' else s2 := 'Desligada';
    Write (s + 'Status     : ' + s2);
    case FPrioridade of
      pdPrimaria   : s2 := 'Primária';
      pdSecundaria : s2 := 'Secundária';
      pdTerciaria  : s2 := 'Terciária';
      end;
    Write (s + 'Prioridade : ' + s2);
    Write;

    WriteFmt (s + 'Escala de Desenvolvimento : %f', [FED]);
    WriteFmt (s + 'Fator de Conversao        : %f', [FFC]);
    WriteFmt (s + 'Fator de Retorno          : %f', [FFR]);
    Write;

    Write (s + 'Nome da Unidade de Consumo Dagua : ' + FNUCD);
    Write (s + 'Nome da Unidade de Demanda       : ' + FNUD);
    Write;

    Write(s + 'Tabela de Valores Unitários');
    for i := 0 to High(FVU) do
      begin
      s2 := Format('(%d - %d)', [FVU[i].AnoIni, FVU[i].AnoFim]);
      for j := 1 to 12 do s2 := s2 + '|' + FloatToStr(FVU[i].Mes[j]);
      Write(s + s2);
      end;
    Write;

    Write(s + 'Tabela de Unidades de Demanda');
    for i := 0 to High(FUD) do
      begin
      s2 := Format('(%d - %d)', [FUD[i].AnoIni, FUD[i].AnoFim]);
      s2 := s2 + '|' + FloatToStr(FUD[i].Unidade);
      Write(s + s2);
      end;
    Write;

    Write(s + 'Tabela de Fatores de Implantação');
    for i := 0 to High(FFI) do
      begin
      s2 := Format('(%d - %d)', [FFI[i].AnoIni, FFI[i].AnoFim]);
      for j := 1 to 12 do s2 := s2 + '|' + FloatToStr(FFI[i].Mes[j]);
      Write(s + s2);
      end;
    Write;
    end;
end;

procedure TprClasseDemanda.ValidarDados(var TudoOk: Boolean;
                           DialogoDeErros: TErros_DLG; Completo: Boolean);
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if not (self is TprDemanda) and not FLigada then
     DialogoDeErros.Add(etInformation,
     Format('Objeto: %s'#13 +
            'Classe de Demanda Desligada.'#13 +
            'Isto afeta todas as demandas descendentes desta classe.', [Nome]));

end;

function TprClasseDemanda.Optimizer_getValue(const PropName: string; Year, Month: Integer): real;
begin
  if CompareText(PropName, 'EscalaDeDesenvolvimento') = 0 then
     Result := FED else

  if CompareText(PropName, 'FatorDeConversao') = 0 then
     Result := FFC else

  if CompareText(PropName, 'FatorDeRetorno') = 0 then
     Result := FFR else

  if CompareText(PropName, 'UnidadeDeConsumo') = 0 then
     Result := getUnidadeDeConsumo(Year, Month) else

  if CompareText(PropName, 'UnidadeDeDemanda') = 0 then
     Result := getUnidadeDeDemanda(Year, Month) else

  if CompareText(PropName, 'FatorDeImplantacao') = 0 then
     Result := getFatorDeImplantacao(Year, Month) else

  Result := inherited Optimizer_getValue(PropName, Year, Month);
end;

procedure TprClasseDemanda.Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real);
begin
  if CompareText(PropName, 'EscalaDeDesenvolvimento') = 0 then
     FED := r else

  if CompareText(PropName, 'FatorDeConversao') = 0 then
     FFC := r else

  if CompareText(PropName, 'FatorDeRetorno') = 0 then
     FFR := r else

  if CompareText(PropName, 'UnidadeDeConsumo') = 0 then
     setUnidadeDeConsumo(Year, Month, r) else

  if CompareText(PropName, 'UnidadeDeDemanda') = 0 then
     setUnidadeDeDemanda(Year, Month, r) else

  if CompareText(PropName, 'FatorDeImplantacao') = 0 then
     setFatorDeImplantacao(Year, Month, r) else

  inherited;
end;

procedure TprClasseDemanda.TVU_NumIntervalos(const NumIntervalos: Integer);
begin
  SetLength(FVU, NumIntervalos);
end;

procedure TprClasseDemanda.TVU_AnoInicialFinalIntervalo(const Ind_Intervalo, AnoInicial, AnoFinal: Integer);
begin
  if (Ind_Intervalo < Length(FVU)) and (AnoInicial <= AnoFinal) then
     begin
     FVU[Ind_Intervalo].AnoIni := AnoInicial;
     FVU[Ind_Intervalo].AnoFim := AnoFinal;
     end
  else
     ErroTVU('TVU_AnoInicialFinalIntervalo');
end;

procedure TprClasseDemanda.TVU_Demanda(const Ind_Intervalo, Mes: Integer; const Demanda: Real);
begin
  if (Ind_Intervalo < Length(FVU)) and (Mes >= 1) and (Mes <= 12) then
     FVU[Ind_Intervalo].Mes[Mes] := Demanda
  else
     ErroTVU('TVU_Demanda');
end;

procedure TprClasseDemanda.ErroTVU(const Rotina: string);
begin
  raise Exception.CreateFmt('Método: %s'#13'Erro: Parâmetros Incorretos', [Rotina]);
end;

function TprClasseDemanda.getDemanda: Real;
begin
  Result := getUC * getUD * FFC + getFI;
end;

{ TprDemanda }

constructor TprDemanda.Create(Pos: ImoPoint; Projeto: TprProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(Pos, Projeto, UmaTabelaDeNomes);

  FSalvarLerBitmap := False;
  FHabilitada      := True;
  FGrupos          := TStringList.Create;

  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_OBTEM_DEMANDA_PELA_CLASSE, self);
  GetMessageManager.RegisterMessage(UM_DADOS_DO_ANCESTRAL_MUDARAM, self);
  GetMessageManager.RegisterMessage(UM_HABILITAR_STATUS, self);
  GetMessageManager.RegisterMessage(UM_DESABILITAR_STATUS, self);
end;

destructor TprDemanda.Destroy;
begin
  GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  GetMessageManager.UnRegisterMessage(UM_DESABILITAR_STATUS, self);
  GetMessageManager.UnRegisterMessage(UM_HABILITAR_STATUS, self);
  GetMessageManager.UnRegisterMessage(UM_OBTEM_DEMANDA_PELA_CLASSE, self);
  GetMessageManager.UnRegisterMessage(UM_DADOS_DO_ANCESTRAL_MUDARAM, self);
  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_NOME_OBJETO_MUDOU, self);

  FGrupos.Free;
  inherited Destroy;
end;

function TprDemanda.AdicionaObjeto(Obj: THidroComponente): Integer;
begin
  {nada}
end;

function TprDemanda.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_Demanda.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

procedure TprDemanda.LerDoArquivo(Ini: TIF; const Secao: String);
var i,j: Integer;
    s  : String;
    DM : TprClasseDemanda;
begin
  Inherited LerDoArquivo(Ini, Secao);
  with Ini do
    begin
    FCLasse       := ReadString (Section,  'ClasseDemanda',  '');
    FGrupos.Text  := ReadString (Section,  'Grupos',         '');
    FTipo         := TEnumTipoDemanda(ReadInteger (Section,  'Tipo',  0));

    DM := FProjeto.ClassesDeDemanda.ClassePeloNome(FClasse);
    if DM <> nil then
       begin
       Bitmap := TBitmap.Create;
       Bitmap.Assign(DM.Bitmap);
       end;
    end;
end;

function TprDemanda.ObtemPrefixo: String;
begin
  Result := 'Demanda_';
end;

procedure TprDemanda.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_Demanda) do
    begin
    cbStatus.Enabled := FHabilitada;
    edClasse.Text := FClasse;
    cbGrupos.Items.Assign(FGrupos);
    case FTipo of
      tdDifusa     : edTipo.Text := 'DIFUSA';
      tdLocalizada : edTipo.Text := 'LOCALIZADA';
      end;
    end;
end;

procedure TprDemanda.SalvarEmArquivo(Arquivo: TIF);
var i,j: Integer;
    s  : String;
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteString  (Section,  'ClasseDemanda', FClasse);
    WriteString  (Section,  'Grupos',        FGrupos.Text);
    WriteInteger (Section,  'Tipo',          ord(FTipo));
    end;
end;

procedure TprDemanda.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var I1, I2, I3: Integer;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
  if Dialogo <> nil then
     begin
     exit;
     end
  else
     begin
     I1 := Length(FUD);
     I2 := Length(FVU);
     I3 := Length(FFI);
     end;

  if (I1 = 0) then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Ausência de Dados: Tabela de Unidades de Demanda', [Nome]));
     TudoOk := False;
     end;

  if (I2 = 0) then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Ausência de Dados: Tabela de Valores Unitários', [Nome]));
     TudoOk := False;
     end;

  if (I3 = 0) then
     begin
     DialogoDeErros.Add(etError,
     Format('Objeto: %s'#13 + 'Ausência de Dados: Tabela de Fatores de Implantação', [Nome]));
     TudoOk := False;
     end;

  if not FLigada then
     DialogoDeErros.Add(etInformation,
     Format('Objeto: %s'#13 + 'Demanda Desligada', [Nome]));
end;

function TprDemanda.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
    s: String;
    o: TObject;
begin
  if MSG.ID = UM_REPINTAR_OBJETO then
     begin
     SetPos(FPos);
     end
  else

  if MSG.ID = UM_HABILITAR_STATUS then
     begin
     s := MSG.ParamAsString(0);
     if (CompareText(s, FClasse) = 0) and (MSG.ParamAsObject(2) = FProjeto) then
        Self.FHabilitada := True;
     end
  else

  if MSG.ID = UM_DESABILITAR_STATUS then
     begin
     s := MSG.ParamAsString(0);
     if (CompareText(s, FClasse) = 0) and (MSG.ParamAsObject(2) = FProjeto) then
        Self.FHabilitada := False;
     end
  else

  if MSG.ID = UM_OBTEM_DEMANDA_PELA_CLASSE then
     begin
     s := MSG.ParamAsString(0);
     if (MSG.ParamAsObject(2) = FProjeto) then
        if (CompareText(s, FClasse) = 0) then
           TStrings(MSG.ParamAsObject(1)).AddObject(FNome, Self)
        else
           if (s = 'TODAS') then
              TStrings(MSG.ParamAsObject(1)).AddObject('[' + FClasse + '] ' + FNome, Self)
     end
  else

  if MSG.ID = UM_DADOS_DO_ANCESTRAL_MUDARAM then
     begin
     s := MSG.ParamAsString(0);
     if (CompareText(s, FClasse) = 0) and (FSincronizaDados) and
        (MSG.ParamAsObject(2) = self.Projeto) then
        Atribuir(TprClasseDemanda(MSG.ParamAsObject(1)), False, TStrings(MSG.ParamAsObject(3)));
     end
  else

  if MSG.ID = UM_NOME_OBJETO_MUDOU then
     begin
     o := MSG.ParamAsObject(0);
     if (o is TprClasseDemanda) and (TprClasseDemanda(o).Projeto = self.Projeto) and
        (MSG.ParamAsString(1) = FClasse) then
        FClasse := MSG.ParamAsString(2);
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TprDemanda.Atribuir(Demanda: TprClasseDemanda; Criando: Boolean; Dados: TStrings = nil);
begin
  // Associa os dados do parâmetro aos dados desta instância
  if Demanda <> nil then
     begin
     if Demanda is TprClasseDemanda then FClasse := Demanda.Nome;

     SetModificado(True);

     if Criando then
        begin
        Descricao        := Demanda.Descricao;
        Comentarios.Text := Demanda.Comentarios.Text;
        FLigada          := Demanda.Ligada;
        FHabilitada      := Demanda.FLigada;
        end;

     FPrioridade := Demanda.Prioridade;

     if Sincronizar(cSD_BM, Dados) or Criando then
        Bitmap := Demanda.Bitmap;

     if Sincronizar(cSD_ED, Dados) or Criando then
        EscalaDeDesenvolvimento := Demanda.EscalaDeDesenvolvimento;

     if Sincronizar(cSD_FC, Dados) or Criando then
        FatorDeConversao := Demanda.FatorDeConversao;

     if Sincronizar(cSD_FR, Dados) or Criando then
        FatorDeRetorno := Demanda.FatorDeRetorno;

     if Sincronizar(cSD_UCA, Dados) or Criando then
        NomeUnidadeConsumoDagua := Demanda.NomeUnidadeConsumoDagua;

     if Sincronizar(cSD_UD, Dados) or Criando then
        NomeUnidadeDeDemanda := Demanda.NomeUnidadeDeDemanda;

     if Sincronizar(cSD_TVU, Dados) and FSincVU or Criando then
        FVU := Demanda.TabValoresUnitarios;

     if Sincronizar(cSD_TUD, Dados) and FSincUD or Criando then
        FUD := Demanda.TabUnidadesDeDemanda;

     if Sincronizar(cSD_TFI, Dados) and FSincFI or Criando then
        FFI := Demanda.TabFatoresImplantacao;

     if Sincronizar(cSD_SVU, Dados) or Criando then
        FSincVU := Demanda.SincVU;

     if Sincronizar(cSD_SUD, Dados) or Criando then
        FSincUD := Demanda.SincUD;

     if Sincronizar(cSD_SFI, Dados) or Criando then
        FSincFI := Demanda.SincFI;

     AtualizaHint;
     end;
end;

procedure TprDemanda.AutoDescricao(Identacao: byte);
var s, s2: String;
begin
  inherited;
  s := StringOfChar(' ', Identacao);
  if FTipo = tdDifusa then s2 := 'Difusa' else s2 := 'Localizada';
  gOutPut.Editor.Write(s + 'Tipo        : ' + s2);
  gOutPut.Editor.Write;
end;

function TprDemanda.getVisivel: Boolean;
begin
  Result := FImagemDoComponente.Visible;
end;

procedure TprDemanda.SetVisivel(const Value: Boolean);
begin
  FImagemDoComponente.Visible := Value;
end;

function TprDemanda.Sincronizar(Dado: Integer; Dados: TStrings): Boolean;
var i: Integer;
begin
  Result := False;
  if Dados <> nil then
     for i := 1 to cSD_Count do
       if (cSD_Dados[i].Cod = Dado) then
          Result := (Dados.IndexOf(cSD_Dados[i].Dado) >= 0);
end;

function TprDemanda.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := Inherited CriarImagemDoComponente;
  Result.Visible := True;
end;

{ TListaDeClassesDemanda }

constructor TListaDeClassesDemanda.Create;
begin
  Inherited Create;
  FList := TStringList.Create;
end;

destructor TListaDeClassesDemanda.Destroy;
begin
  FEM := nil;
  Limpar;
  FList.Free;
  Inherited Destroy;
end;

procedure TListaDeClassesDemanda.Adicionar(DM: TprClasseDemanda);
begin
  FProjeto.FModificado := True;
  FList.AddObject(DM.Nome, DM);
  if assigned(FEM) then FEM(Self);
end;

procedure TListaDeClassesDemanda.Editar(DM: TprClasseDemanda);
begin
  if FList.IndexOfObject(DM) > -1 then
     begin
     DM.MostrarDialogo;
     if assigned(FEM) then FEM(Self);
     end;
end;

function TListaDeClassesDemanda.getClasse(indice: Integer): TprClasseDemanda;
begin
  Result := TprClasseDemanda(FList.Objects[indice]);
end;

function TListaDeClassesDemanda.GetClasses: Integer;
begin
  Result := FList.Count;
end;

procedure TListaDeClassesDemanda.LerDoArquivo(Arquivo: TIF);
var Demanda  : TprClasseDemanda;
    BM       : TBitmap;
    nClasses : Integer;
    i        : Integer;
    Secao    : String;
    auxEM    : TEventoDeMudanca;
begin
  auxEM := FEM;
  FEM := nil;
  Limpar;
  nClasses := Arquivo.ReadInteger('Classes De Demanda', 'Quantidade', 0);
  for i := 0 to nClasses-1 do
    begin
    Secao := Arquivo.ReadString('Classes De Demanda', intToStr(i+1), '');
    if Secao <> '' then
       begin
       Secao := 'Dados ' + Secao;
       Demanda := TprClasseDemanda.Create(gmoPoint, FProjeto, FTN);
       Demanda.LerDoArquivo(Arquivo, Secao);
       Secao := Arquivo.ReadString(Secao, 'Bitmap', '');
       Adicionar(Demanda);
       end;
    end;
  FEM := auxEM;
end;

procedure TListaDeClassesDemanda.RemoverObjeto(indice: Integer);
begin
  FProjeto.FModificado := True;
  TprClasseDemanda(FList.Objects[indice]).Free;
  FList.Delete(indice);
  if assigned(FEM) then FEM(Self);
end;

procedure TListaDeClassesDemanda.SalvarEmArquivo(Arquivo: TIF);
var i: Integer;
begin
  Arquivo.WriteInteger('Classes De Demanda', 'Quantidade', Classes);
  for i := 0 to Classes-1 do
    begin
    Arquivo.WriteString('Classes De Demanda', intToStr(i+1), Classe[i].Nome);
    Classe[i].SalvarEmArquivo(Arquivo);
    end;
end;

function TListaDeClassesDemanda.getBitmap(indice: Integer): TBitmap;
begin
  Result := TprClasseDemanda(FList.Objects[indice]).Bitmap;
end;

procedure TListaDeClassesDemanda.Limpar;
begin
  While FList.Count > 0 do RemoverObjeto(FList.Count-1);
end;

function TListaDeClassesDemanda.Remover(DM: TprClasseDemanda): Boolean;
var i: Integer;
    Demandas: TStrings;
begin
  Result := False;
  Demandas := TStringList.Create;
  try
    i := FList.IndexOfObject(DM);
    if i > -1 then
       begin
       ObterDemandasPelaClasse(DM.Nome, Demandas, FProjeto);
       if Demandas.Count = 0 then
          begin
          Gerenciador.RemoverObjeto(DM);
          TprDialogo_AreaDeProjeto(FProjeto.AreaDeProjeto).ObjetoSelecionado := nil;
          RemoverObjeto(i);
          Result := True;
          end
       else
          MessageDLG(cMsgInfo02, mtInformation, [mbOk], 0);
       end;
  finally
    Demandas.Free;
  end;
end;

function TListaDeClassesDemanda.ClassePeloNome(const NomeClasse: String): TprClasseDemanda;
var i: Integer;
begin
  i := FList.IndexOf(NomeClasse);
  if i > -1 then
     Result := TprClasseDemanda(FList.Objects[i])
  else
     Result := nil;
end;

{ TprProjeto }

function TprProjeto.ReceiveMessage(Const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     if FPlanejaUsuario <> '' then
        begin
        PreparaScript(FPlanejaUsuario, FPlanejaScript);
        FPlanejaScript.Compile;
        end;

     if FRotinaGeralUsuario <> '' then
        begin
        PreparaScript(FRotinaGeralUsuario, FScriptGeral);
        FScriptGeral.Compile;
        end;
     end else

  if MSG.ID = UM_LIBERAR_SCRIPTS then
     begin
     FreeAndNil(FPlanejaScript);
     FreeAndNil(FScriptGeral);
     end;

  inherited ReceiveMessage(MSG);
end;

function TprProjeto.TrechoPeloNome(const Nome: String): TprTrechoDagua;
begin
  Result := TprTrechoDagua(ObterObjetoPeloNome(Nome, self));
end;

function TprProjeto.DemandaPeloNome(const Nome: String): TprDemanda;
begin
  Result := TprDemanda(ObterObjetoPeloNome(Nome, self));
end;

function TprProjeto.SubBaciaPeloNome(const Nome: String): TprSubBacia;
begin
  Result := TprSubBacia(ObterObjetoPeloNome(Nome, self));
end;

function TprProjeto.PCPeloNome(const Nome: String): TprPCP;
begin
  Result := TprPCP(ObterObjetoPeloNome(Nome, self));
end;

procedure TprProjeto.TerminarSimulacao;
begin
  if FSimulador <> nil then
     begin
     FStatus := sFazendoNada;
     if FSC <> nil then FSC.Stop;
     FSimulador.Terminate;
     //gOutPut.Editor.Write('Simulação terminada pelo usuário.');
     //gOutPut.Editor.Write('  - Último ponto de execução ... ' + FEC);
     //gOutPut.Editor.Write('  - Delta T .................... ' + IntToStr(FDeltaT));
     //gOutPut.Editor.Show;
     FEC := '';
     FSC := nil;
     if Assigned(FEvento_FimSimulacao) then FEvento_FimSimulacao(Self);
     end;
end;

procedure TprProjeto.AtualizaPontoExecucao(const EC: String; SCC: TPascalScript);
begin
  FEC := EC;
  FSC := SCC;
end;

procedure TprProjeto.AutoDescricao(Identacao: byte);
var s: String;
begin
  inherited;
  s := StringOfChar(' ', Identacao);
  with gOutPut.Editor do
    begin
    WriteFmt (s + 'Anos de Execução        : %d'   , [NumAnosDeExecucao]);
    WriteFmt (s + 'Intervalos de Simulação : %d'   , [Total_IntSim]);
    WriteFmt (s + 'Nível de Falha Crítica  : %f %%', [NivelDeFalha]);
    Write;

    Write    (s + 'Propagar DOS corrente : ' + PropDOS);
    Write    (s + 'Diretório de Pesquisa : ' + DirTrab);
    Write    (s + 'Diretório de Saída    : ' + DirSai);
    Write;
    end;
end;

{O método a seguir tem por objetivo determinar um valor que sirva para avaliação da
 performance do sistema.}
function TprProjeto.CalculaFuncaoObjetivo: Real;
begin
  AtualizaPontoExecucao(FNome + '.CalculaFuncaoObjetivo', nil);

  FValorFO := 0;
  Result := FValorFO;
end;

constructor TprProjeto.Create(UmaTabelaDeNomes: TStrings; AreaDeProjeto: TForm);
begin
  inherited Create(UmaTabelaDeNomes, nil);

  FProjeto := Self;
  FAreaDeProjeto := AreaDeProjeto;
  FMap := AP(AreaDeProjeto).Map;

  FScripts := TStringList.Create;

  GetMessageManager.RegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.RegisterMessage(UM_LIBERAR_SCRIPTS, self);

  FPCs  := TListaDePCs.Create;

  // Inicia o objeto responsável pelas classes de demanda
  FClasDem               := TListaDeClassesDemanda.Create;
  FClasDem.Projeto       := Self;
  FClasDem.TabelaDeNomes := UmaTabelaDeNomes;

  FInts := TListaDeIntervalos.Create;
  FInts.FProjeto := self;

  FTS      := tsWIN;
  FPropDOS := 'PropDOS0';
  FNF := 50;

  FGlobalObjects := TGlobalObjects.Create;
end;

destructor TprProjeto.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.UnRegisterMessage(UM_LIBERAR_SCRIPTS, self);
  FPCs.Free;
  FClasDem.Free;
  FInts.Free;
  FGlobalObjects.Free;
  FScripts.Free;
  inherited Destroy;
end;

function TprProjeto.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_Projeto.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

function TprProjeto.getData: TRec_prData;
var i, ii : Integer;
    x: Real;
begin
  // acha os DeltaTs acumulados se necessário
  //if FCalc_dtAcum then
     for i := 0 to High(FAnos) do
       begin
       ii := FAnos[i].AnoFim - FAnos[i].AnoIni + 1;
       if i = 0 then
          FAnos[i].dtAcum := ii * getTAIS
       else
          FAnos[i].dtAcum := FAnos[i-1].dtAcum + ii * getTAIS
       end;

  // acha o intervalo atual do DeltaT.
  for i := 0 to High(FAnos) do
    if FDeltaT <= FAnos[i].dtAcum then
       Break;

  if i = 0 then ii := 0 else ii := FAnos[i-1].dtAcum;
  x := (FDeltaT - ii - 1) / getTAIS + 1E-12;
  Result.Mes := Trunc(Frac(x) * 12) + 1;
  Result.Ano := Trunc(x) + FAnos[i].AnoIni;
end;

// retorna o número total de anos de execução
function TprProjeto.getNumAnos: Integer;
var i: Integer;
begin
  Result := 0;
  for i := 0 to High(FAnos) do
    inc(Result, FAnos[i].AnoFim - FAnos[i].AnoIni + 1);
end;

// retorna o número total de intervalos de simulação em um ano
function TprProjeto.getTAIS: Integer;
begin
  Result := ord(FIntSim);
  if Result > -1 then
     Result := caNumIntSimAno[FIntSim]
end;

// retorna o número total de intervalos de simulação
function TprProjeto.getTIS: Integer;
begin
  Result := getNumAnos * getTAIS;
end;

// retorna o número total de intervalos de simulação em um mês
function TprProjeto.getTMIS: Integer;
begin
  Result := caNumIntSimMes[FIntSim];
end;

procedure TprProjeto.LerDoArquivo(const Nome: String; SomenteRede: Boolean);
begin
  FNomeArquivo := Nome;
  FLerSomenteRede := SomenteRede;

  FIni := TIF.Create(Nome);
  AP(FAreaDeProjeto).Lendo := True;
  try
    LerDoArquivo(FIni, 'Dados ' + FIni.ReadString('Projeto', 'Nome', ''));
    SetGlobalStatus(RealizarDiagnostico);
    FPCs.CalcularHierarquia;
    FModificado := False;
    AP(FAreaDeProjeto).DesenharRede;
    Gerenciador.ReconstroiArvore;
  finally
    FLerSomenteRede := False;
    AP(FAreaDeProjeto).Lendo := False;
    FreeAndNil(FIni);
  end;
end;

function TprProjeto.LerPC(Ini: TIF; const NomeDoPC: String): TprPCP;
var Tipo, Secao: String;
    p: ImoPoint;
begin
  Result := nil;
  if NomeDoPC = '' then Exit;
  Secao := 'Dados ' + NomeDoPC;

  Tipo  := Ini.ReadString(Secao, 'Classe', '');
  if Tipo = '' then Exit;

  if Tipo = 'TprPCP'  then
     begin
     Result := TprPCP.Create(p, Self, FTN);
     Result.Menu := AP(FAreaDeProjeto).Menu_PCP;
     end;

  if Tipo = 'TprPCPR' then
     begin
     Result := TprPCPR.Create(p, Self, FTN);
     Result.Menu := AP(FAreaDeProjeto).Menu_PCPR;
     end;

  Result.LerDoArquivo(Ini, Secao);
  FPCs.Adicionar(Result);
end;

procedure TprProjeto.UpdateUnit(UnitCode: Integer);
var u: ImoUnit;
    v: Variant;
    G: ImoGeoCoordSys;
    P: ImoProjCoordSys;
begin
  v := FMap.CoordinateSystem;
  if not VarIsClear(v) then
     begin
     u := CoUnit_.Create;
     u.type_ := UnitCode;
     v.Unit := u;
     end;
end;

procedure TprProjeto.UpdateCoordinateSystem(const Name, Code: String);
var G: ImoGeoCoordSys;
    P: ImoProjCoordSys;
begin
  if Name <> '' then
     begin
     if Name[2] = 'G' then
        begin
        G := coGeoCoordSys.Create;
        G.type_ := StrToInt(Code);
        FMap.CoordinateSystem := G;
        end
     else
        begin
        P := coProjCoordSys.Create;
        P.type_ := StrToInt(Code);
        FMap.CoordinateSystem := P;
        end;

     GetMessageManager.SendMessage(UM_CoordinateSystem_Changed, []);
     end;
end;

{ - Faz a leitura dos trechos dágua
  - Faz a leitura de todas as Sub-Bacias deste PC
    - Faz a leitura das Demandas desta SubBacia
  - Faz a leitura de todos as demandas deste PC
}
procedure TprProjeto.Ler_Objetos(Ini: TIF; const NomeDoPC: String);
var Secao, s : String;
    i,ii     : Integer;
    p        : ImoPoint;
    pc1, pc2 : TprPCP;
    SB       : TprSubBacia;
    DM       : TprDemanda;
begin
  pc1 := nil;
  // Faz a leitura dos trechos dágua
  Secao := Ini.ReadString('Dados ' + NomeDoPC, 'TD', '');
  if Secao <> '' then
     begin
     Secao := 'Dados ' + Secao;
     pc1 := TprPCP(ObterObjetoPeloNome(Ini.ReadString(Secao, 'PM', ''), self));
     pc2 := TprPCP(ObterObjetoPeloNome(Ini.ReadString(Secao, 'PJ', ''), self));
     pc1.AdicionaObjeto(pc2); // E finalmente conecta os PCs
     pc1.TrechoDagua.LerDoArquivo(Ini, Secao);
     end
  else // Somente obtém o próprio PC
     pc1 := TprPCP(ObterObjetoPeloNome(NomeDoPC, self));

  // Faz a leitura de todas as Sub-Bacias deste PC
  for i := 1 to Ini.ReadInteger('Dados ' + NomeDoPC, 'SubBacias', 0) do
    begin
    Secao := Ini.ReadString('Dados ' + NomeDoPC, 'SB'+intToStr(i), '');
    if Secao <> '' then
       begin
       SB := TprSubBacia(ObterObjetoPeloNome(Secao, self));

       if SB = nil then
          begin
          Secao := 'Dados ' + Secao;
          SB := TprSubBacia(CriarObjeto('Sub-Bacia', nil));
          SB.LerDoArquivo(Ini, Secao);
          SB.Menu := AP(FAreaDeProjeto).Menu_SubBacias;

          // Faz a leitura das Demandas desta SubBacia
          for ii := 1 to Ini.ReadInteger(Secao, 'Demandas', 0) do
            begin
            s := Ini.ReadString(Secao, 'DM'+intToStr(ii), '');
            if s <> '' then
               begin
               s := 'Dados ' + s;
               DM := TprDemanda(CriarObjeto('Demanda', nil));
               DM.LerDoArquivo(Ini, s);
               DM.Menu := AP(FAreaDeProjeto).Menu_Demanda;
               SB.AdicionaObjeto(DM);
               end;
            end; // For ii
          end;

       if pc1 <> nil then pc1.AdicionaObjeto(SB);
       end;
    end; // for i

  // Faz a leitura de todos as demandas deste PC
  for i := 1 to Ini.ReadInteger('Dados ' + NomeDoPC, 'Demandas', 0) do
    begin
    Secao := Ini.ReadString('Dados ' + NomeDoPC, 'DM'+intToStr(i), '');
    if Secao <> '' then
       begin
       Secao := 'Dados ' + Secao;
       DM := TprDemanda(CriarObjeto('Demanda', nil));
       DM.LerDoArquivo(Ini, Secao);
       DM.Menu := AP(FAreaDeProjeto).Menu_Demanda;
       pc1.AdicionaObjeto(DM);
       end;
    end;
end;

{ - Lê as informações do Projeto
  - Lê todos os PCs deste Projeto (LerPC(nomePC))
  - Lê os Objetos de cada PC (LerObjetos(nomePC))
}
procedure TprProjeto.LerDoArquivo(Ini: TIF; const Secao: String);
var i, ii    : Integer;
    s, s1, s2: String;
    PC       : TprPCP;
    DS       : Char;
    v        : Variant;
    LEI      : Tmoec_Layer;
begin
  // Leitura dos dados da área de projeto
  if not FLerSomenteRede then
     AP(FAreaDeProjeto).LerDoArquivo(Ini);

  // Faz as leitura preliminar dos dados
  Inherited LerDoArquivo(Ini, Secao);

  try
    with Ini do
      begin
      DS                     := DecimalSeparator;
      DecimalSeparator       := ReadString(Secao, 'Separador Decimal', '.')[1];

      FVersion := ReadFloat (Secao, 'Versao', 1.0);
      FNF      := ReadFloat (Secao, 'Nivel de Falha', 50);
      FTS      := TEnumTipoSimulacao(ReadInteger (Secao, 'Tipo Simulacao', 1));

      i := ReadInteger (Secao, 'Num. Intervalos', 0);
      SetLength(FAnos, i);
      for i := 0 to High(FAnos) do
        begin
        s := ReadString(Secao, 'Intervalo' + intToStr(i+1), '0-0');
        SubStrings('-', s1, s2, s);
        FAnos[i].AnoIni := strToInt(s1);
        FAnos[i].AnoFim := strToInt(s2);
        end;

      FDirSai    := ReadString (Secao, 'Dir. Saida',    '');
      FDirTrab   := ReadString (Secao, 'Dir. Trabalho', '');
      FIntSim    := TEnumIntSim(ReadInteger (Secao, 'Intervalo de Simulacao', -1));

      FPlanejaUsuario     := ReadString(Secao, 'Planeja Usuario', '');
      FRotinaGeralUsuario := ReadString(Secao, 'Debug Usuario', '');
      FOperaUsuario       := ReadString(Secao, 'Opera Usuario', '');
      FEnergiaUsuario     := ReadString(Secao, 'Energia Usuario', '');

      for i := 1 to ReadInteger(Secao, 'Num Intervalos', 0) do
        begin
        s := 'Intervalo ' + intToStr(i);
        FInts.Adicionar(
          ReadInteger(s, 'Inicio'    , 0),
          ReadInteger(s, 'Final'     , -1),
          ReadString (s, 'Nome'      , 'Indefinido'),
          ReadBool   (s, 'Habilitado', True)
          );
        end;

      FTotal_IntSim := getTIS;
      FPropDOS := ReadString (Secao, 'PropDOS', 'PropDOS0');

      FScripts.Clear;
      for i := 1 to ReadInteger(Secao, 'Num Scripts', 0) do
        begin
        s := 'Script ' + intToStr(i);
        FScripts.Add(ReadString(Secao, s, ''));
        end;

      if not FLerSomenteRede then
         begin
         if FVersion < 3.0 then
            AddLayer(gExePath + 'Null_Layer\Null_Layer.shp');

         FMap_SC := ReadString(Section, 'SC', '');
         FMap_SC_Cod := ReadString(Section, 'SC_COD', '');
         FMap_Escala := ReadInteger(Section, 'Escala', 0);

         ii := ReadInteger(Secao, 'Layers', 0);

         // Lê as informações do Mapa
         for i := ii downto 1 do
           begin
           s := Secao + ' - Layer ' + IntToStr(i);
           LEI := AddLayer(ReadString(s, 'Name', ''));
           v := LEI.moLayer;

           v.Visible := ReadBool(s, 'Visible', True);

           if v.LayerType = moMapLayer then
              begin
              v.Symbol.Color := ReadInteger(s, 'Symbol.Color', 0);
              v.Symbol.Size  := ReadInteger(s, 'Symbol.Size' , 4);
              v.Symbol.Style := ReadInteger(s, 'Symbol.Style', 0);
              end
           else
              begin
              //...
              end;

           LEI.UseScaleForVisibility := ReadBool(s, 'UseScaleForVisibility', False);
           LEI.MinScale := ReadInteger(s, 'MinScale', 0);
           LEI.MaxScale := ReadInteger(s, 'MaxScale', 0);
           end;

         // atualiza o sistema após ler as camadas
         UpdateCoordinateSystem(FMap_SC, FMap_SC_Cod);
         end;

      // Classes de Demanda
      FClasDem.LerDoArquivo(Ini);

      // Lê as informações dos PCs
      ii := Ini.ReadInteger('PCs', 'Quantidade', -1);
      if ii <> -1 then
         begin
         for i := 1 to ii do
            begin
            s := Ini.ReadString('PCs', 'PC'+intToStr(i), '');
            LerPC(Ini, s);
            end;

         // Lê as informações dos Objetos dos PCs
         for i := 1 to ii do
            begin
            s := Ini.ReadString('PCs', 'PC'+intToStr(i), '');
            Ler_Objetos(Ini, s);
            end;
         end;

       // Atualiza o status de cada demanda de uma classe se sua classe está desligada
       for i := 0 to FClasDem.Classes - 1 do
         if not FClasDem[i].Ligada then
            GetMessageManager.SendMessage(UM_DESABILITAR_STATUS,
              [@FClasDem[i].FNome, FClasDem[i], self]);
      end; // with

    AP(FAreaDeProjeto).InvertLayers();  

  finally
    DecimalSeparator := DS;
  end;
end;

procedure TprProjeto.MostrarIntervalos;
var d: TprDialogo_Intervalos;
begin
  d := TprDialogo_Intervalos.Create(nil);
  d.Projeto := self;
  try
    if d.ShowModal = mrOK then FModificado := True;
  finally
    d.Free;
  end;
end;

procedure TprProjeto.PegarDadosDoDialogo(d: TprDialogo_Base);
var i: Integer;
    s, s1, s2: String;
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_Projeto) do
    begin
    FIntSim  := TEnumIntSim(cbIntSim.ItemIndex);
    FDirSai  := edDirSai.Text;
    FDirTrab := edDirPes.Text;
    FNF      := edNF.AsFloat;

    SetLength(FAnos, mAnos.Lines.Count);
    for i := 0 to High(FAnos) do
      begin
      s := mAnos.Lines[i];
      SubStrings('-', s1, s2, s, true);
      FAnos[i].AnoIni := strToInt(s1);
      FAnos[i].AnoFim := strToInt(s2);
      end;

    FPropDOS  := cbPropDos.Items[cbPropDos.ItemIndex];
    FTS       := TEnumTipoSimulacao(rbTipoSimulacao.Checked); // 0 = DOS

    FTotal_IntSim := getTIS;

    FScripts.Assign(lbScripts.Items);

    // Diálogo "Rotinas"
    FPlanejaUsuario     := Rotinas.edPlanejaUsuario.Text;
    FRotinaGeralUsuario := Rotinas.edGeralUsuario.Text;
    FOperaUsuario       := Rotinas.edOperaUsuario.Text;
    FEnergiaUsuario     := Rotinas.edEnergiaUsuario.Text;

    // Diálogo "OpcVisRede"
    FMap_SC := OpcVisRede.edSC.Text;
    FMap_SC_Cod := OpcVisRede.edSC_Cod.Text;
    FMap_Escala := OpcVisRede.edEscala.AsInteger;
    FMap_Unit := OpcVisRede.frUnidade.UnitAsString;
    FMap_UnitCode := OpcVisRede.frUnidade.UnitCode;
    UpdateCoordinateSystem(FMap_SC, FMap_SC_Cod);
    UpdateUnit(FMap_UnitCode);
    end;
end;

procedure TprProjeto.PorDadosNoDialogo(d: TprDialogo_Base);
var i: Integer;
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_Projeto) do
    begin
    for i := 0 to High(FAnos) do
      mAnos.Lines.Add(Format('%d - %d', [FAnos[i].AnoIni, FAnos[i].AnoFim]));

    edDirSai.Text  := FDirSai;
    edDirPes.Text  := FDirTrab;
    edNF.AsFloat   := FNF;

    cbIntSim.ItemIndex := ord(FIntSim);

    cbPropDos.Items.Clear;
    for i := 0 to 9 do
      if FileExists(gExePath + 'PropDOS' + intToStr(i) + '.EXE') then
         cbPropDos.Items.Add('PropDOS' + intToStr(i));

    i := cbPropDos.Items.IndexOf(FPropDOS);
    if i <> -1 then cbPropDos.ItemIndex := i else cbPropDos.ItemIndex := 0;

    rbTipoSimulacao.Checked := Boolean(FTS);
    rbDOS.Checked := not Boolean(FTS);

    lbScripts.Items.Assign(FScripts);

    // Diálogo "Rotinas"
    Rotinas.edPlanejaUsuario.Text := FPlanejaUsuario;
    Rotinas.edGeralUsuario.Text   := FRotinaGeralUsuario;
    Rotinas.edOperaUsuario.Text   := FOperaUsuario;
    Rotinas.edEnergiaUsuario.Text := FEnergiaUsuario;

    // Diálogo "OpcVisRede"
    OpcVisRede.edSC.Text := FMap_SC;
    OpcVisRede.edSC_Cod.Text := FMap_SC_Cod;
    OpcVisRede.edEscala.AsInteger := FMap_Escala;
    end;
end;

procedure TprProjeto.SalvarEmArquivo(const Nome: String);
var i     : Integer;
    s     : String;
begin
  s := ChangeFileExt(Nome, '.bak');
  DeleteFile(s);
  RenameFile(Nome, s);

  FIni := TIF.Create(Nome);
  try
    FIni.WriteString('Projeto', 'Nome', FNome);
    SalvarEmArquivo(FIni);
    Fini.UpdateFile;
    FNomeArquivo := Nome;
  finally
    FreeAndNil(FIni);
  end;
end;

procedure SalvaSubBacia(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList = nil);
begin
  SB.SalvarEmArquivo(Projeto.FIni);
end;

procedure SalvaDemanda(Projeto: TprProjeto; DM: TprDemanda; Lista: TList = nil);
begin
  DM.SalvarEmArquivo(Projeto.FIni);
end;

{ - Salva as informações do projeto
  - Salva as informações de cada PC
  - Salva as informações de cada Sub-Bacia
  - Salva as informações de cada Demanda }
procedure TprProjeto.SalvarEmArquivo(Arquivo: TIF);
var i     : Integer;
    s     : String;
    sPath : String;
    ML    : ImoMapLayer;
    IL    : ImoImageLayer;
    v     : Variant;
    LEI   : Tmoec_Layer;
    iDisp : iDispatch;
begin
  // Salva as informações da área de projeto
  AP(FAreaDeProjeto).SalvarEmArquivo(Arquivo);

  Inherited SalvarEmArquivo(Arquivo);

  with Arquivo do
    begin
    // Salva as informações do projeto
    WriteString (Section, 'Separador Decimal', DecimalSeparator);
    WriteFloat  (Section, 'Versao', 3.0);
    WriteFloat  (Section, 'Nivel de Falha', FNF);
    WriteInteger(Section, 'Tipo Simulacao', ord(FTS));

    WriteInteger (Section, 'Num. Intervalos', Length(FAnos));
    for i := 0 to High(FAnos) do
      WriteString(Section, 'Intervalo' + intToStr(i+1),
      Format('%d-%d', [FAnos[i].AnoIni, FAnos[i].AnoFim]));

    WriteString  (Section, 'Dir. Saida',     FDirSai);
    WriteString  (Section, 'Dir. Trabalho',  FDirTrab);
    WriteInteger (Section, 'Intervalo de Simulacao', ord(FIntSim));
    WriteString  (Section, 'Planeja Usuario', FPlanejaUsuario);
    WriteString  (Section, 'Debug Usuario', FRotinaGeralUsuario);
    WriteString  (Section, 'Opera Usuario', FOperaUsuario);
    WriteString  (Section, 'Energia Usuario', FEnergiaUsuario);

    // Intervalos
    WriteInteger(Section, 'Num Intervalos', FInts.NumInts);
    for i := 0 to FInts.NumInts - 1 do
      begin
      s := 'Intervalo ' + IntToStr(i + 1);
      WriteInteger(s, 'Inicio'     , FInts.IntIni[i]);
      WriteInteger(s, 'Final'      , FInts.IntFim[i]);
      WriteString (s, 'Nome'       , FInts.Nome[i]);
      WriteBool   (s, 'Habilitado' , FInts.Habilitado[i]);
      end;

    WriteString  (Section, 'PropDOS', FPropDOS);

    WriteInteger(Section, 'Num Scripts', FScripts.Count);
    for i := 1 to FScripts.Count do
      begin
      s := 'Script ' + intToStr(i);
      WriteString(Section, s, FScripts[i-1]);
      end;

    // Se a camada Null_Layer não existe na pasta destino entao
    // a copiamos e todos seus arquivos relacionados.
    sPath := ExtractFilePath(Arquivo.FileName);
    iDisp := Map.Layers.ByName('Null_Layer.shp');
    if (iDisp <> nil) and not FileExists(sPath + 'Null_Layer.shp') then
       FProjeto.Map.CopyLayer(gExePath + 'Null_Layer\Null_Layer.shp', sPath);

    WriteString(Section, 'SC', FMap_SC);
    WriteString(Section, 'SC_COD', FMap_SC_Cod);
    WriteInteger(Section, 'Escala', FMap_Escala);

    WriteInteger(Section, 'Layers', FMap.Layers.Count);

    // Salva as informações do Mapa
    for i := FMap.Layers.Count-1 downto 0 do
      begin
      LEI := FMap.Layers[i];
      v := LEI.moLayer;

      s := Section + ' - Layer ' + IntToStr(i+1);

      WriteInteger(s, 'Type'   , v.LayerType);
      WriteString (s, 'Name'   , v.Name);
      WriteBool   (s, 'Visible', v.Visible);

      if v.LayerType = moMapLayer then
         begin
         ML := ImoMapLayer(FMap.Layers[i].moLayer);
         WriteInteger(s, 'Symbol.Color', ML.Symbol.Color);
         WriteInteger(s, 'Symbol.Size' , ML.Symbol.Size);
         WriteInteger(s, 'Symbol.Style', ML.Symbol.Style);
         end
      else
         begin
         IL := ImoImageLayer(FMap.Layers[i].moLayer);
         //...
         end;

      WriteBool(s, 'UseScaleForVisibility', LEI.UseScaleForVisibility);
      WriteInteger(s, 'MinScale', LEI.MinScale);
      WriteInteger(s, 'MaxScale', LEI.MaxScale);
      end;

    // Salva as informações das Classes de Demanda
    FClasDem.SalvarEmArquivo(Arquivo);

    // Nome dos PCs
    WriteInteger('PCs', 'Quantidade', FPCs.PCs);
    for i := 0 to FPCs.PCs - 1 do
      WriteString('PCs', 'PC' + intToStr(i + 1), FPCs[i].Nome);

    // Salva as informações de cada PC
    for i := 0 to FPCs.PCs - 1 do
      FPCs[i].SalvarEmArquivo(Arquivo);

    // Salva as informações de cada Sub-Bacia
    PercorreSubBacias(SalvaSubBacia, nil);

    // Salva as informações de cada Demanda
    PercorreDemandas(SalvaDemanda);

    FModificado := false;
    end;
end;

procedure TprProjeto.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TErros_DLG; Completo: Boolean = False);
var i1, i2, i3 : Integer;
    s1, s2, s3 : String;
    PU, DU, RU, OU, EU : String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
  if Dialogo <> nil then
     begin
     i1 := TprDialogo_Projeto(Dialogo).mAnos.Lines.Count;
     i2 := TprDialogo_Projeto(Dialogo).cbIntSim.ItemIndex;

     s1 := allTrim(TprDialogo_Projeto(Dialogo).edDirSai.Text);
     s2 := allTrim(TprDialogo_Projeto(Dialogo).edDirPes.Text);

     i3 := TprDialogo_Projeto(Dialogo).cbPropDos.ItemIndex;
     s3 := allTrim(TprDialogo_Projeto(Dialogo).cbPropDos.Items[i3]);

     PU := TprDialogo_Projeto(Dialogo).Rotinas.edPlanejaUsuario.Text;
     DU := TprDialogo_Projeto(Dialogo).Rotinas.edGeralUsuario.Text;
     OU := TprDialogo_Projeto(Dialogo).Rotinas.edOperaUsuario.Text;
     EU := TprDialogo_Projeto(Dialogo).Rotinas.edEnergiaUsuario.Text;
     end
  else
     begin
     i1 := Length(FAnos);
     i2 := ord(FIntSim);
     s1 := allTrim(FDirSai);
     s2 := allTrim(FDirTrab);
     s3 := allTrim(FPropDos);
     PU := FPlanejaUsuario;
     DU := FRotinaGeralUsuario;
     OU := FOperaUsuario;
     EU := FEnergiaUsuario;
     end;

  if (i2 < 0) or (i2 > 4) then
     begin
     DialogoDeErros.Add(etError,
     Format('Projeto: %s'#13 + 'Intervalo de Simulação não definido', [Nome]));
     TudoOk := False;
     end;

  if I1 = 0 then
     begin
     DialogoDeErros.Add(etError,
     Format('Projeto: %s'#13 + 'Ausência de Dados: Anos de Execução', [Nome]));
     TudoOk := False;
     end;

  if (s1 <> '') and not DirectoryExists(s1) then
     begin
     DialogoDeErros.Add(etError,
     Format('Projeto: %s'#13 + 'Diretório de saída inválido: %s', [Nome, s1]));
     TudoOk := False;
     end;

  if (s2 <> '') and not DirectoryExists(s2) then
     begin
     DialogoDeErros.Add(etError,
     Format('Projeto: %s'#13 + 'Diretório de pesquisa inválido: %s', [Nome, s2]));
     TudoOk := False;
     end;

  if not FileExists(gExePath + s3 + '.exe') then
     begin
     DialogoDeErros.Add(etError,
     Format('Projeto: %s'#13 +
            'Ausência do Propagar DOS', [Nome]));
     TudoOk := False;
     end;

  VerificarRotinaUsuario(PU, 'Planeja', Completo, TudoOk, DialogoDeErros);
  VerificarRotinaUsuario(DU, 'Debug'  , Completo, TudoOk, DialogoDeErros);
  VerificarRotinaUsuario(OU, 'Opera'  , Completo, TudoOk, DialogoDeErros);
  VerificarRotinaUsuario(EU, 'Energia', Completo, TudoOk, DialogoDeErros);
end;

// Proc. auxiliar para retorno das subBacias de um projeto
procedure Proc_ObtemSubBacias(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList = nil);
begin
  Lista.Add(SB);
end;

procedure TprProjeto.PercorreSubBacias(ITSB: TProcPSB; Lista: TList = nil);
var i, j: Integer;
begin
  i := 0;
  GetMessageManager.SendMessage(UM_RESET_VISIT, [@i]);
  for i := 0 to PCs.PCs-1 do
    for j := 0 to PCs[i].SubBacias-1 do
      if not PCs[i].SubBacia[j].Visitado then
         begin
         ITSB(Self, PCs[i].SubBacia[j], Lista);
         PCs[i].SubBacia[j].Visitado := True;
         end;
end;

procedure TprProjeto.PercorreDemandas(ITDM: TProcPDM; Lista: TList = nil);
var i, j, k: Integer;
begin
  for i := 0 to PCs.PCs-1 do
    begin
    for j := 0 to PCs[i].Demandas-1 do
       ITDM(Self, PCs[i].Demanda[j], Lista);

    for j := 0 to PCs[i].SubBacias-1 do
       for k := 0 to PCs[i].SubBacia[j].Demandas-1 do
          ITDM(Self, PCs[i].SubBacia[j].Demanda[k], Lista);
    end;
end;

// Retorna as subBacias de um projeto
function TprProjeto.ObtemSubBacias: TList;
begin
  Result := TList.Create;
  PercorreSubBacias(Proc_ObtemSubBacias, Result);
end;

procedure TprProjeto.ExecutarRotinaGeral;
begin
  if FRotinaGeralUsuario <> '' then
     begin
     FAreaDeProjeto.Caption := 'Executando a Rotina Geral do Usuário. Aguarde ...';
     AtualizaPontoExecucao(FNome + '.ScriptGeral', FScriptGeral);
     FScriptGeral.Execute;
     end;
end;

procedure TprProjeto.Temporizador(Sender: TObject; out EventID: Integer);
begin
  inc(FDeltaT);
end;

{O método a seguir faz o planejamento da distribuição de água em função de regras
 fornecidas pelo usuário no inicio de cada intervalo de tempo}
procedure TprProjeto.Planeja;
var i: Integer;
    PC: TprPCP;
begin
  AtualizaPontoExecucao(FNome + '.Planeja', nil);

  // Rotina míope - é o planejamento utilizado caso o usuário não programe nada
  for i := 0 to FPCs.PCs-1 do
    begin
    PC := TprPCP(FPCs[i]);
    PC.DemPriPlanejada[FDeltaT] := PC.DemPriTotal[FDeltaT];
    PC.DemSecPlanejada[FDeltaT] := PC.DemSecTotal[FDeltaT];
    PC.DemTerPlanejada[FDeltaT] := PC.DemTerTotal[FDeltaT];
    if PC is TprPCPR then
       TprPCPR(PC).DefluvioPlanejado[FDeltaT] := 0;
    end;

  if FPlanejaUsuario <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.ScriptPlaneja', FPlanejaScript);
     FPlanejaScript.Execute;
     end;
end;

procedure MonitorarSBs(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList = nil);
begin
  SB.Monitorar;
end;

// Este método (evento) é disparado automaticamente após o evento de relógio do
// simulador, neste caso Temporizador_1 que incrementa o relógio.
// Executa uma simulação na rede para o intervalo de simulação Projeto.DeltaT
procedure TprProjeto.Simulacao(Sender: TObject; const EventID: Integer);
var i: Integer;
begin
  if FDeltaT > FIntervalosSim then
     begin
     FSimulador.Terminate;
     Exit;
     end;

  {O método a seguir faz o planejamento da distribuição de água em função de regras
   fornecidas pelo usuário no inicio de cada intervalo de tempo}
  Planeja; {metodo do projeto, devera ser interpretado ou padrao}

  {Dentro do intervalo de tempo todos os PCs são percorridos em ordem hierárquica
   para que se faça o Balanço Hídrico de cada um e o atendimento das Demandas}
   for i := 0 to FPCs.PCs-1 do
    FPCs.PC[i].BalancoHidrico;

  {O método a seguir tem por objetivo determinar um valor que sirva para avaliação da
   performance do sistema.}
   CalculaFuncaoObjetivo;

  // Motirocao dos Objetos
  if AP(AreaDeProjeto).Monitor.Visible then
     begin
     for i := 0 to FPCs.PCs-1 do
       FPCs.PC[i].Monitorar;
     PercorreSubBacias(MonitorarSBs, nil);
     end;
end;

function TprProjeto.ObtemSubRede(PC: TprPCP): TStrings;
var Temp: TList;

  procedure Percorre(PC: TprPCP);
  var i: Integer;
  begin
    for i := 0 to PC.PCs_aMontante-1 do
      Percorre(TprPCP(PC.PC_aMontante[i]));
    Temp.Add(PC);
  end;

var i: Integer;
begin
  Temp := TList.Create;
  Percorre(PC);

  Result := TStringList.Create;

  // Organiza os PCs da Sub-arvore de acordo com os PCs que ja estao
  // organizados hierarquicamente
  for i := 0 to PCs.PCs-1 do
    if Temp.IndexOf(PCs[i]) > -1 then
       Result.AddObject(PCs[i].Nome, PCs[i]);

  Temp.Free;
end;

procedure TprProjeto.RealizarBalancoHidricoAte(PC: TprPCP);
var i: Integer;
    SubRede: TStrings;
begin
  SubRede := ObtemSubRede(PC);

  for i := 0 to SubRede.Count-1 do
    TprPCP(SubRede.Objects[i]).BalancoHidrico;

  SubRede.Free;
end;

procedure TprProjeto.ExecutarSimulacao;
var s, Erro1, Erro2, PE1, PE2: String;
begin
  if FSimulador = nil then
     if RealizarDiagnostico(True) then
        try
          // Salva as configurações
          s := AP(FAreaDeProjeto).Caption;
          AP(FAreaDeProjeto).Cursor             := crHourGlass;
          AP(FAreaDeProjeto).Enabled            := False;
          AP(FAreaDeProjeto).Progresso.Position := 0;
          AP(FAreaDeProjeto).Progresso.Max      := Total_IntSim;
          AP(FAreaDeProjeto).Progresso.Visible  := True;

          FSimulador            := TSimulation.Create(True);
          FSimulador.OnClock    := Temporizador;
          FSimulador.OnEvent    := Simulacao;
          FSimulador.OnDoVisual := AP(FAreaDeProjeto).AtualizacaoVisualDaSimulacao;

          if Assigned(FEvento_InicioSimulacao) then FEvento_InicioSimulacao(Self);

          // Inicia o relógio da Simulação e outras variáveis de controle
          FDeltaT := 0;
          FIntervalosSim := getTIS;

          // Ordena os PCs por Prioridade
          FPCs.Ordenar;

          // Inicia os objetos da rede
          GetMessageManager.SendMessage(UM_INICIAR_SIMULACAO, [self]);

          if AP(AreaDeProjeto).Monitor.Visible then
             AP(AreaDeProjeto).Monitor.Limpar;

          Erro1 := ''; Erro2 := ''; PE1 := ''; PE2 := '';
          try
             try
               FSimulador.Resume;
             except
               on E: Exception do
                  begin
                  Erro1 := E.Message;
                  PE1   := FEC;
                  end;
             end;
          finally
             try
               ExecutarRotinaGeral;
             except
               on E: Exception do
                  begin
                  Erro2 := E.Message;
                  PE2   := FEC;
                  end;
             end;
          end;

        finally
          FreeAndNil(FSimulador);

          // Recupera as configurações
          AP(FAreaDeProjeto).Caption           := s;
          AP(FAreaDeProjeto).Cursor            := crDefault;
          AP(FAreaDeProjeto).Enabled           := True;
          AP(FAreaDeProjeto).Progresso.Visible := False;

          if Assigned(FEvento_FimSimulacao) then FEvento_FimSimulacao(Self);

          if (PE1 <> '') or (PE2 <> '') then
             begin
             gOutPut.Editor.Write('A simulação não foi finalizada.');
             gOutPut.Editor.Write('  - Intervalo de Tempo: ' + IntToStr(FDeltaT));
             gOutPut.Editor.Write('  - Erros:');
             if PE1 <> '' then
                begin
                gOutPut.Editor.Write('    Ponto de Execução: ' + PE1);
                gOutPut.Editor.Write(Erro1, #13, '    ');
                end;
             if PE2 <> '' then
                begin
                if PE1 <> '' then gOutPut.Editor.Write;
                gOutPut.Editor.Write('    Ponto de Execução: ' + PE2);
                gOutPut.Editor.Write(Erro2, #13, '    ');
                end;

             gOutPut.Editor.Write(StringOfChar('-', 100));
             gOutPut.Editor.Show;
             gOutPut.Editor.GoLastLine;
             end;
        end
     else
        gErros.Show;
end;

procedure TprProjeto.Executar;
var i: Integer;
begin
  for i := 0 to PCs.PCs-1 do
     TprPCP(PCs[i]).TotalizaDemandas;

  FStatus := sSimulando;
  GetMessageManager.SendMessage(UM_PREPARAR_SCRIPTS, [self]);
  try
    if FTS = tsWIN then
       ExecutarSimulacao;
  finally
    FStatus := sFazendoNada;
    GetMessageManager.SendMessage(UM_LIBERAR_SCRIPTS, [self]);
  end;
end;

// Faz a leitura de cada um dos arquivos do PropagarDOS
procedure TprProjeto.LeArquivosDoPropagarDOS;
var s: String;
    SL, SL2: TStrings;

  procedure LeDados(Vetor: TV; const Nome: String);
  var i1, i2, k: Integer;
  begin
    // acha os índices do bloco de dados deste Objeto
    s := ' ' + #39 + LeftStr(Nome, 8) + #39;
    i1 := SL.IndexOf(s);
    if i1 > -1 then
       begin
       inc(i1);
       i2 := i1;
       while (i2 < SL.Count) and (SL[i2][2] <> #39) do inc(i2);
       dec(i2);

       SL2.Clear;
       for k := i1 to i2 do SL2.Add(SL[k]);
       Vetor.LoadFromStrings(SL2);
       end;
  end;

var i: Integer;
begin
  SL  := TStringList.Create;
  SL2 := TStringList.Create;
  try
    for i := 0 to PCs.PCs-1 do
       TprPCP(PCs[i]).CalculaVzMon_e_AfluenciaSB;

    // Le as Vazões Defluentes de cada PC
    s := ArqVazoes;
    VerificarCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do LeDados(TprPCP(PCs[i]).Defluencia, PCs[i].Nome);
       end;

    // Le as Demandas Primárias Atendidas
    s := ArqDPS;
    VerificarCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do LeDados(TprPCP(PCs[i]).DemPriAtendida, PCs[i].Nome);
       end;

    // Le os dados de Demandas Secundárias Atendidas
    s := ArqDSS;
    VerificarCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do LeDados(TprPCP(PCs[i]).DemSecAtendida, PCs[i].Nome);
       end;

    // Le os dados de Demandas Terciárias Atendida
    s := ArqDTS;
    VerificarCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do LeDados(TprPCP(PCs[i]).DemTerAtendida, PCs[i].Nome);
       end;

    // Le os dados de Volumes dos Reservatórios se existirem
    s := ArqAR;
    VerificarCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do
         if PCs[i] is TprPCPR then
            LeDados(TprPCPR(PCs[i]).Volume, PCs[i].Nome);
       end;

    // Le os dados de Energia Gerada dos Reservatórios se existirem
    s := ArqEG;
    VerificarCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do
         if PCs[i] is TprPCPR then
            LeDados(TprPCPR(PCs[i]).Energia, PCs[i].Nome);
       end;
  finally
    SL2.Free;
    SL.Free;
  end;
end;

function TprProjeto.RealizarDiagnostico(Completo: Boolean = False): Boolean;
var i,j,k  : integer;
    TudoOk : Boolean;
begin
  TudoOk := True;
  gErros.Clear;

  i := 0;
  GetMessageManager.SendMessage(UM_RESET_VISIT, [@i]);

  if PCs.PCs = 0 then
     begin
     gErros.Add(etError,
     Format('Projeto: %s'#13 + 'Rede não definida!', [Nome]));
     TudoOk := False;
     end;

  if NomeArquivo = '' then
     begin
     gErros.Add(etError, 'Projeto sem nome !');
     TudoOk := False;
     end;

  Diagnostico(TudoOk, Completo);

  for i := 0 to FClasDem.Classes-1 do
    FClasDem[i].Diagnostico(TudoOk, Completo);

  // Realiza o diagnostico de todos os objetos conectados aos PCs, inclusive o deles
  for i := 0 to PCs.PCs-1 do
    begin
    PCs[i].Diagnostico(TudoOk, Completo);

    for j := 0 to PCs[i].Demandas-1 do
      PCs[i].Demanda[j].Diagnostico(TudoOk, Completo);

    for j := 0 to PCs[i].SubBacias-1 do
      if not PCs[i].SubBacia[j].Visitado then
         begin
         PCs[i].SubBacia[j].Visitado := True;
         PCs[i].SubBacia[j].Diagnostico(TudoOk, Completo);
         for k := 0 to PCs[i].SubBacia[j].Demandas-1 do
           PCs[i].SubBacia[j].Demanda[k].Diagnostico(TudoOk, Completo);
         end;
    end;

  // ... Realiza o diagnóstico em outros objetos

  Result := TudoOk;
end;

procedure TprProjeto.RelatorioGeral;
const cSeparador = '--------------------- // --------------------- // ---------------------';

var i, j : Integer;
    SL   : TStrings;
    SBs  : TList;
begin
  with gOutPut.Editor do
    begin
    NewPage;

    Write    ('PROJETO *********************************************************************************************');
    Write;

    self.AutoDescricao(0);

    Write    ('CLASSES DE DEMANDAS e DESCENDENTES ******************************************************************');
    Write;

    SL := TStringList.Create;
    For i := 0 to FClasDem.Classes-1 do
      begin
      FClasDem[i].AutoDescricao(0);
      ObterDemandasPelaClasse(FClasDem[i].Nome, SL, FProjeto);
      for j := 0 to SL.Count-1 do
        begin
        TprDemanda(SL.Objects[j]).AutoDescricao(14);
        if j < SL.Count - 1 then
           begin
           WriteCenter(cSeparador);
           Write;
           end;
        end;
      end;
    SL.Free;

    Write    ('SUB-BACIAS ******************************************************************************************');
    Write;

    SBs := ObtemSubBacias;
    for i := 0 to SBs.Count - 1 do
      begin
      TprSubBacia(SBs[i]).AutoDescricao(0);
      if i < SBs.Count - 1 then
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

procedure TprProjeto.MostrarMatrizDeContribuicao;
var D     : TprDialogo_MatContrib;
    nPCs  : Integer;
    i,j,k : Integer;
    SBs   : TList;
    SB    : TprSubBacia;
    p     : pRecMatContrib;
begin
  if FSimulador <> nil then Exit;

  D := TprDialogo_MatContrib.Create(nil);
  Try
    nPCs := PCs.PCs;
    SBs := ObtemSubBacias;

    if (nPCs = 0) or (SBs.Count = 0) then
       MessageDLG('Matriz de Contribuição Vazia', mtInformation, [mbOK], 0)
    else
       begin
       D.Matriz.RowCount := SBs.Count + 1; // Número de SubBacias + Cabeçalho
       D.Matriz.ColCount := nPCs + 1;      // Número de PCs + Cabeçalho

       for i := 1 to PCs.PCs do
         D.Matriz.Cells[i, 0] := ' ' + PCs[i-1].Nome;

       for i := 1 to SBs.Count do
         D.Matriz.Cells[0, i] := ' ' + TprSubBacia(SBs[i-1]).Nome;

       // Preenche os dados para a matriz
       D.Dados := TList.Create;
       for i := 0 to SBs.Count-1 do
         begin
         SB := TprSubBacia(SBs[i]);
         for j := 0 to SB.PCs.Objetos-1 do
           begin
           new(p);
           p.Lin := D.Matriz.Cols[0].IndexOf(' ' + SB.Nome);
           p.Col := PCs.IndiceDo(TprPCP(SB.PCs.Objeto[j])) + 1;
           p.Val := SB.CCs[j];
           D.Dados.Add(p);
           end;
         end;

       D.ShowModal; k := -1;
       if D.MatrizAlterada then
          for i := 0 to SBs.Count-1 do
            begin
            SB := TprSubBacia(SBs[i]);
            for j := 0 to SB.PCs.Objetos-1 do
              begin
              inc(k);
              p := D.Dados[k];
              SB.CCs[j] := p.Val;
              end;
            end;

       for i := 0 to D.Dados.Count-1 do Dispose(pRecMatContrib(D.Dados[i]));
       D.Dados.Free;
       end;
  Finally
    SBs.Free;
    D.Release;
    End;
end;

procedure TprProjeto.MostrarFalhasNoAtendimentoDasDemandas;
var D: TprDialogo_Planilha_FalhasDasDemandas;
begin
  D := TprDialogo_Planilha_FalhasDasDemandas.Create(AreaDeProjeto);
  D.Caption := ' Falhas no Atendimento das Demandas';
  D.PCs := PCs;
  D.Show;
end;

procedure TprProjeto.EscreveAnosNoEditor(Const Ident: String = '');
var i, j : Integer;
    s    : String;
begin
  for i := 0 to High(AnosDeExecucao) do
    begin
    s := Ident;
    for j := AnosDeExecucao[i].AnoIni to AnosDeExecucao[i].AnoFim do
      s := s + intToStr(j) + ' ';
    gOutPut.Write(s);
    end;
end;

procedure TprProjeto.GerarArquivoPropagarDOS(NomeArquivo: String = '');
var i, j           : Integer;
    d1, d2, d3     : Integer;
    s , s1, s2     : String;
    Entrada, Saida : String;
    R              : TprPCPR;
    DM             : TprDemanda;
    Exec           : TExecFile;
begin
  if FSimulador <> nil then Exit;

  if DirSai = '' then
     begin
     FDirSaida := ExtractFilePath(FNomeArquivo) + 'Saida\';
     if not DirectoryExists(FDirSaida) then ForceDirectories(FDirSaida);
     end;

  FPCs.Ordenar;
  gOutPut.BeginDoc;

  gOutPut.Write(aspa + Descricao + aspa);
  gOutPut.Write(aspa + StringsToString(Comentarios) + aspa);
  gOutPut.Write(intToStr(NumAnosDeExecucao));
  EscreveAnosNoEditor;
  gOutPut.Write(intToStr(Total_IntSim) + '  ' + intToStr(PCs.PCs));

  for i := 0 to PCs.PCs-1 do gOutPut.Write(aspa + PCs.PC[i].Nome + aspa);
  s := '';
  for i := 0 to PCs.PCs-1 do
    begin
    if i > 0 then s := s + ', ';
    s := s + intToStr(PCs.PC[i].Hierarquia);
    end;
  gOutPut.Write(s);

  s := '';
  for i := 0 to PCs.PCs-1 do
    begin
    if i > 0 then s := s + ', ';
    s := s + intToStr(PCs.PC[i].PCs_aMontante);
    end;
  gOutPut.Write(s);

  s := '';
  for i := 0 to PCs.PCs-1 do
    s := s + {TprPCP(PCs.PC[i]).CRC}'321' + ' ';
  gOutPut.Write(s);

  s := '';
  for i := 0 to PCs.PCs-1 do
    if PCs.PC[i].Hierarquia > 1 then
       begin
       s := '';
       for j := 0 to PCs.PC[i].PCs_aMontante-1 do
         s := s + intToStr(PCs.IndiceDo(PCs.PC[i].PC_aMontante[j])+1) + ' ';
       gOutPut.Write(s);
       end;

  gOutPut.Write(GerarArquivoDeVazoes);
  gOutPut.Write(GerarArquivoDeDemandasDifusas);
  gOutPut.Write(GerarArquivoDeDemanda(pdPrimaria));
  gOutPut.Write(GerarArquivoDeDemanda(pdSecundaria));
  gOutPut.Write(GerarArquivoDeDemanda(pdTerciaria));
  gOutPut.Write(GerarArquivoDosReservatorios('PLU'));
  gOutPut.Write(GerarArquivoDosReservatorios('ETP'));

  gOutPut.Write('3');

  s := ''; s1 := ''; s2 := '';
  for i := 0 to PCs.PCs-1 do
    begin
    d1 := 0; d2 := 0; d3 := 0;
    for j := 0 to PCs.PC[i].Demandas-1 do
      begin
      DM := PCs.PC[i].Demanda[j];
      if DM.Ligada and DM.Habilitada then
         case DM.Prioridade of
           pdPrimaria:
             begin
             inc(d1);
             s :=  s + Format('%f %f ', [DM.EscalaDeDesenvolvimento, DM.FatorDeRetorno]);
             end;
           pdSecundaria:
             begin
             inc(d2);
             s1 := s1 + Format('%f %f ', [DM.EscalaDeDesenvolvimento, DM.FatorDeRetorno]);
             end;
           pdTerciaria:
             begin
             inc(d3);
             s2 := s2 + Format('%f %f ', [DM.EscalaDeDesenvolvimento, DM.FatorDeRetorno]);
             end;
           end;
      end; // for j
    if d1 = 0 then s  := s  + '0.0 0.0 ';
    if d2 = 0 then s1 := s1 + '0.0 0.0 ';
    if d3 = 0 then s2 := s2 + '0.0 0.0 ';
    end;
  gOutPut.Write(s);
  gOutPut.Write(s1);
  gOutPut.Write(s2);

  if DirSai <> '' then
     s := ExtractShortPathName(DirSai)
  else
     s := ExtractShortPathName(FDirSaida);

  ArqVazoes := GetTempFile(s, 'Vaz');
  gOutPut.Write(aspa + ArqVazoes + aspa);

  ArqDPS := GetTempFile(s, 'DPS');
  gOutPut.Write(aspa + ArqDPS + aspa);

  ArqDSS := GetTempFile(s, 'DSS');
  gOutPut.Write(aspa + ArqDSS + aspa);

  ArqDTS := GetTempFile(s, 'DTS');
  gOutPut.Write(aspa + ArqDTS + aspa);

  ArqAR := GetTempFile(s, 'AR');
  gOutPut.Write(aspa + ArqAR + aspa);

  ArqEG := GetTempFile(s, 'EG');
  gOutPut.Write(aspa + ArqEG + aspa);

  s := ''; s1 := ''; s2 := '';
  for i := 0 to PCs.PCs-1 do
    if PCs.PC[i] is TprPCPR then
       begin
       s  := s  + FloatToStr(TprPCPR(PCs.PC[i]).VolumeMinimo) + ' ';
       s1 := s1 + FloatToStr(TprPCPR(PCs.PC[i]).VolumeMaximo) + ' ';
       s2 := s2 + FloatToStr(TprPCPR(PCs.PC[i]).VolumeInicial) + ' ';
       end
    else
       begin
       s := s + '0.0 '; s1 := s1 + '0.0 '; s2 := s2 + '0.0 ';
       end;
  gOutPut.Write(s);
  gOutPut.Write(s1);
  gOutPut.Write(s2);

  for i := 0 to PCs.PCs-1 do
    if PCs.PC[i] is TprPCPR then
       begin
       R := (PCs.PC[i] as TprPCPR);
       s := ''; s1 := '';
       gOutPut.Write(intToStr(R.PontosAV));
       for j := 0 to R.PontosAV - 1 do
         begin
         s  := s  + FloatToStr(R.AV[j].Area) + ' ';
         s1 := s1 + FloatToStr(R.AV[j].Vol) + ' ';
         end;
       gOutPut.Write(s);
       gOutPut.Write(s1);

       s := ''; s1 := '';
       gOutPut.Write(intToStr(R.PontosCV));
       for j := 0 to R.PontosCV - 1 do
         begin
         s  := s  + FloatToStr(R.CV[j].Cota) + ' ';
         s1 := s1 + FloatToStr(R.CV[j].Vol) + ' ';
         end;
       gOutPut.Write(s);
       gOutPut.Write(s1);
       {$IFDEF DEBUG}
       gOutPut.Write('Coeficiente de transformação energética e energia firme');
       {$ENDIF}
{ ??? esperando mudancas ...
       if R.GerarEnergia then
          gOutPut.Write(FloatToStr(R.Coef_Transformacao) + ' ' + FloatToStr(R.EnergiaFirme))
       else
          gOutPut.Write('0 0');
}
       end;
  gOutPut.Write(FloatToStr(NivelDeFalha));

  //gOutPut.Show;

  {$IFNDEF DEBUG}
  if NomeArquivo = '' then
     if DirSai <> '' then
        NomeArquivo := GetTempFile(DirSai, 'APR')
     else
        NomeArquivo := GetTempFile(FDirSaida, 'APR');

  Entrada := ChangeFileExt(NomeArquivo, '.ENT');
  Saida   := ChangeFileExt(NomeArquivo, '.SAI');

  gOutPut.FileName := Entrada;
  gOutPut.Save;

  {$IFDEF NomesCurtos}
  Entrada := ExtractShortPathName(Entrada);
  {$ENDIF}

  Exec := TExecFile.Create(nil);
  Exec.Wait := True;
  Exec.CommandLine := gExePath + PropDOS + '.exe';
  Exec.Parameters := Entrada + ' ' + Saida;

  if MessageDlg('Executar o Propagar DOS ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     if Exec.Execute then
        begin
        gOutPut.Editor.NewPage;
        gOutPut.Editor.OpenDoc(Entrada);
        LeArquivosDoPropagarDOS;
        if FileExists(Saida) then
           begin
           MessageDLG('A simulação ocorreu com sucesso.', mtInformation, [mbOK], 0);
           gOutPut.Editor.NewPage;
           gOutPut.Editor.OpenDoc(Saida);
           end;
        gOutPut.Editor.Show;   
        end
     else
  else
     Abort;

  Exec.Free;
  {$ENDIF}
end;

{
Alocar vetores QD, D, Q com Total_IntSim elemetos
Para cada PC --> PC[i] (i = 1..n)
  Limpar vetor QD
  Limpar vetor D
  Para todas as SubBacias do PC[i] --> SB[j] (j = 1..n)
    SB[j].QD = Ler Arquivo de Vazões da SB[j]
    SB[j].QD = SB[j].QD * SB[j].CC
    Acumular em QD, SB[j].QD
    Para todas as Demandas da SB[j] --> DM[k] (k = 1..n)
      Acumular em D, DM[k].UCA * DM[k].UD * SB[j].Area * SB[j].CC * DM[k].FC
  Q = QD - D
  Escrever Q de PC[i] no arquivo de Vazões
Desalocar vetores QD, D, Q
}
function TprProjeto.GerarArquivoDeVazoes: String;
var PC          : TprPCP;         // PC atual
    SB          : TprSubBacia;   // Sub-Bacia atual
    DM          : TprDemanda;    // Demanda Atual
    SL          : TStrings;    // Base para o arquivo
    x           : Real;        // Auxiliar para cálculos
    Vx          : TwsDFVec;    // Auxiliar para cálculos
    CC          : Real;        // Coef. De Contribuição da SB atual
    dt, i, j, k : Integer ;    // Contadores
    QD          : TwsDFVec;    // Vazões das Sub-Bacias
    D           : TwsDFVec;    // Consumo das Demandas

begin
  Result := 'Erro na criação do arquivo de Vazões Afluentes';

  SL := TStringList.Create;

  // Aloca memória para os dois vetores usados nos cálculos
  QD := TwsDFVec.Create(Total_IntSim);
   D := TwsDFVec.Create(Total_IntSim);

  try
    // Inicializa as vazões de Todas as Sub-Bacias
    for i := 0 to PCs.PCs-1 do
      for j := 0 to PCs.PC[i].SubBacias-1 do
        PCs.PC[i].SubBacia[j].LiberaVazoes;

    // para todos os PCs
    for i := 0 to PCs.PCs-1 do
      begin
      PC := PCs.PC[i]; // pega o PC atual
      QD.Fill(0); D.Fill(0); // limpa os dois vetores

      // para todas as Sub-Bacias de um PC
      for j := 0 to PC.SubBacias-1 do
        begin
        SB := PC.SubBacia[j]; // pega a Sub-Bacia atual
        CC := SB.CCs[SB.PCs.IndiceDo(PC)]; // Coef. Contribuição SB x PC

        Vx := TwsDFVec(VecScalarProd(SB.Vazoes, CC, True)); // Vx = SB.QD * SB.CC;
        VecSum(QD, Vx, False); // Acumula em QD, Vx
        Vx.Free;

        // para todas as Demandas de uma Sub-Bacia
        for k := 0 to SB.Demandas-1 do
          if SB.Demanda[k].Ligada and SB.Demanda[k].Habilitada then
             begin
             DM := SB.Demanda[k]; // pega a Demanda Atual

              x := SB.Area * CC * DM.FatorDeConversao;

             // calcula manualmente o vetor D de cada Demanda e vai acumulando-o
             for dt := 1 to Total_IntSim do
               begin
               DeltaT := dt;
               DM.Data := Data; // FProjeto.Data é dependente de DeltaT.
               D[dt] := D[dt] + DM.UnidadeDeConsumo * DM.UnidadeDeDemanda * x;
               end;

             end // if DM.Ligada
        end; // for j

      VecSub(QD, D, False); // QD = QD - D
      for j := 1 to QD.Len do if QD[j] < 0 then QD[j] := 0;
      SL.Add(Aspa + PC.Nome + Aspa);
      QD.ToEditor(SL, 12, 10);
      end; // for i

     if DirSai <> '' then
        Result := GetTempFile(DirSai, 'VAZ')
     else
        Result := GetTempFile(FDirSaida, 'VAZ');

    {$IFNDEF DEBUG}
    SL.SaveToFile(Result);
    {$ENDIF}

    {$IFDEF NomesCurtos}
    Result := ExtractShortPathName(Result);
    {$ENDIF}

    Result := aspa + Result + aspa;
  finally
    SL.Free;
    D.Free;
    QD.Free;
    for i := 0 to PCs.PCs-1 do
      for j := 0 to PCs.PC[i].SubBacias-1 do
        PCs.PC[i].SubBacia[j].LiberaVazoes;
  end;
end;

function TprProjeto.GerarArquivoDeDemandasDifusas: String;
var Vx: TwsDFVec;    // Auxiliar para cálculos
    SL: TStrings;
    i, j: Integer;
begin
  Result := 'Erro na criação do arquivo de Demandas Difusas';
  SL := TStringList.Create;
  Vx := TwsDFVec.Create(TotalAnual_IntSim);
  try
    Vx.Fill(0);

    for i := 0 to PCs.PCs-1 do
      for j := 0 to PCs.PC[i].SubBacias-1 do
        begin
        SL.Add(Aspa + PCs.PC[i].SubBacia[j].Nome + Aspa);
        Vx.ToEditor(SL, 12, 10);
        end;

    if DirSai <> '' then
       Result := GetTempFile(DirSai, 'DD')
    else
       Result := GetTempFile(FDirSaida, 'DD');

    {$IFNDEF DEBUG}
    SL.SaveToFile(Result);
    {$ENDIF}

    {$IFDEF NomesCurtos}
    Result := ExtractShortPathName(Result);
    {$ENDIF}

    Result := aspa + Result + aspa + ' ' + IntToStr(TotalAnual_IntSim);
  finally
    SL.Free;
    Vx.Free;
  end;
end;

function TprProjeto.GerarArquivoDeDemanda(Tipo: TEnumPriorDemanda): String;
var PC          : TprPCP;         // PC atual
    DM          : TprDemanda;    // Demanda Atual
    SL          : TStrings;    // Base para o arquivo
    dt, i, k    : Integer ;    // Contadores
    D           : TwsDFVec;    // Consumo das Demandas
begin
  Result := 'Erro na criação do arquivo de Demanda ' + intToStr(ord(Tipo) + 1) + '.';

  SL := TStringList.Create;

  // Aloca memória para os dois vetores usados nos cálculos
  D := TwsDFVec.Create(Total_IntSim);
  try
    // para todos os PCs
    for i := 0 to PCs.PCs-1 do
      begin
      PC := PCs.PC[i]; // pega o PC atual
      D.Fill(0); // limpa o vetor

      // para todas as Demandas de um PC
      for k := 0 to PC.Demandas-1 do
        if (PC.Demanda[k].Prioridade = Tipo) and
           (PC.Demanda[k].Ligada) and (PC.Demanda[k].Habilitada) then
           begin
           DM := PC.Demanda[k]; // pega a Demanda Atual

           // calcula manualmente o vetor D de cada Demanda e vai acumulando-o
           for dt := 1 to D.Len do
             begin
             DeltaT := dt;
             DM.Data := Data; // FProjeto.Data é dependente de DeltaT.
             D[dt] := D[dt] + DM.UnidadeDeConsumo * DM.UnidadeDeDemanda *
                      DM.FatorDeConversao * DM.FatorDeImplantacao;
             end;
           end; // if Tipo and DM.Ligada

      SL.Add(Aspa + PC.Nome + Aspa);
      D.ToEditor(SL, 12, 10);
      end; // for i

    if DirSai <> '' then
       Result := GetTempFile(DirSai, 'DM' + intToStr(ord(Tipo) + 1) + '_')
    else
       Result := GetTempFile(FDirSaida, 'DM' + intToStr(ord(Tipo) + 1) + '_');

    {$IFNDEF DEBUG}
    SL.SaveToFile(Result);
    {$ENDIF}

    {$IFDEF NomesCurtos}
    Result := ExtractShortPathName(Result);
    {$ENDIF}

    Result := aspa + Result + aspa + ' ' + intToStr(Total_IntSim);
  finally
    SL.Free;
    D.Free;
  end;
end;

function TprProjeto.GerarArquivoDosReservatorios(const Tipo: String): String;
var PC          : TprPCPR;     // PC atual
    SL          : TStrings;    // Base para o arquivo
    i, k        : Integer ;    // Contadores
    D           : TwsDFVec;    // Consumo das Demandas
    s           : String;      // Auxiliar;

    procedure GeraValores(const Nome: String);
    begin
      if Nome <> '' then SL.Add(Aspa + Nome + Aspa);
      D.ToEditor(SL, 12, 10);
    end;

begin
  Result := 'Erro na criação do arquivo de ' + Tipo;

  k  := 0;
  SL := TStringList.Create;

  // Aloca memória para os dois vetores usados nos cálculos
  D := TwsDFVec.Create(Total_IntSim);
  try
    // para todos os PCs Reservatórios
    for i := 0 to PCs.PCs-1 do
      if PCs.PC[i] is TprPCPR then
         begin
         inc(k);
         PC := TprPCPR(PCs.PC[i]); // pega o PC atual

         if Tipo = 'ETP' then s := PC.ArqETP else s := PC.ArqPrec;
         VerificarCaminho(s);
         D.LoadFromTextFile(s);

         GeraValores(PC.Nome);
         end; // for i

    if k = 0 then
       begin
       D.Fill(0);
       GeraValores('');
       end;

    if DirSai <> '' then
       Result := GetTempFile(DirSai, Tipo)
    else
       Result := GetTempFile(FDirSaida, Tipo);

    {$IFNDEF DEBUG}
    SL.SaveToFile(Result);
    {$ENDIF}

    {$IFDEF NomesCurtos}
    Result := ExtractShortPathName(Result);
    {$ENDIF}

    Result := aspa + Result + aspa + ' ' + intToStr(Total_IntSim);
  finally
    SL.Free;
    D.Free;
  end;
end;

{ TListaDeFalhas }

// DR  : Demanda de Referência
// DA  : Demanda Atendida
// NFC : Nível Crítico de Falha
function TListaDeFalhas.Adicionar(Tipo: TEnumPriorDemanda; Intervalo: Integer;
                                  const DR, DA, NCF: Real): Integer;

var SL: TStrings;
    i: Integer;
    s: String;
    F: TprFalha;
begin
  SL := PegarFalhas(Tipo);
  FProjeto.DeltaT := Intervalo;
  s := IntToStr(FProjeto.Data.Ano);
  i := SL.IndexOf(s);
  if i = -1 then
     SL.AddObject(s, TprFalha.Create(FProjeto.Data.Ano, Intervalo, DR, DA, NCF))
  else
     begin
     F := TprFalha(SL.Objects[i]);
     F.Intervalos.Add(Intervalo);
     F.DemsRef.Add(DR);
     F.DemsAten.Add(DA);
     F.IntervalosCriticos.Add(DA < DR * NCF);
     end;
end;

constructor TListaDeFalhas.Create(Projeto: TprProjeto);
begin
  inherited Create;
  FProjeto   := Projeto;
  FFalhasPri := TStringList.Create;
  FFalhasSec := TStringList.Create;
  FFalhasTer := TStringList.Create;
end;

destructor TListaDeFalhas.Destroy;
var i: Integer;
begin
  for i := 0 to FFalhasPri.Count-1 do TprFalha(FFalhasPri.Objects[i]).Free;
  for i := 0 to FFalhasSec.Count-1 do TprFalha(FFalhasSec.Objects[i]).Free;
  for i := 0 to FFalhasTer.Count-1 do TprFalha(FFalhasTer.Objects[i]).Free;
  inherited Destroy;
end;

function TListaDeFalhas.FalhaPeloAno(Tipo: TEnumPriorDemanda; Const Ano: String): TprFalha;
var SL: TStrings;
    i: Integer;
begin
  SL := PegarFalhas(Tipo);
  i := SL.IndexOf(Ano);
  if i > -1 then Result := TprFalha(SL.Objects[i]) else Result := nil;
end;

function TListaDeFalhas.AnosCriticos(Tipo: TEnumPriorDemanda): Integer;
var SL: TStrings;
    i: Integer;
    F: TprFalha;
begin
  SL := PegarFalhas(Tipo);
  Result := 0;
  for i := 0 to SL.Count-1 do
    begin
    F := TprFalha(SL.Objects[i]);
    if F.FalhaCritica then inc(Result);
    end;
end;

function TListaDeFalhas.getFalhaPri(i: Integer): TprFalha;
begin
  Result := TprFalha(FFalhasPri.Objects[i]);
end;

function TListaDeFalhas.getFalhaSec(i: Integer): TprFalha;
begin
  Result := TprFalha(FFalhasSec.Objects[i]);
end;

function TListaDeFalhas.getFalhaTer(i: Integer): TprFalha;
begin
  Result := TprFalha(FFalhasTer.Objects[i]);
end;

function TListaDeFalhas.getNumFalhasPri: Integer;
begin
  Result := FFalhasPri.Count;
end;

function TListaDeFalhas.getNumFalhasSec: Integer;
begin
  Result := FFalhasSec.Count;
end;

function TListaDeFalhas.getNumFalhasTer: Integer;
begin
  Result := FFalhasTer.Count;
end;

function TListaDeFalhas.IntervalosTotais(Tipo: TEnumPriorDemanda): Integer;
var SL: TStrings;
    i: Integer;
    F: TprFalha;
begin
  SL := PegarFalhas(Tipo);
  Result := 0;
  for i := 0 to SL.Count-1 do
    begin
    F := TprFalha(SL.Objects[i]);
    inc(Result, F.Intervalos.Count);
    end;
end;

function TListaDeFalhas.MostrarFalhas: TForm;
var d: TprDialogo_FalhasDeUmPC;
begin
  d := TprDialogo_FalhasDeUmPC.Create(Application);
  d.Falhas := Self;
  d.Show;
  Result := d;
end;

function TListaDeFalhas.PegarFalhas(Tipo: TEnumPriorDemanda): TStrings;
begin
  Case Tipo of
    pdPrimaria   : Result := FFalhasPri;
    pdSecundaria : Result := FFalhasSec;
    pdTerciaria  : Result := FFalhasTer;
    end;
end;

function TListaDeFalhas.IntervalosCriticos(Tipo: TEnumPriorDemanda): Integer;
var SL: TStrings;
    i, j, FC: Integer;
    F: TprFalha;
begin
  SL := PegarFalhas(Tipo);
  Result := 0;
  for i := 0 to SL.Count-1 do
    begin
    F := TprFalha(SL.Objects[i]);

    FC := 0;
    for j := 0 to F.IntervalosCriticos.Count-1 do
      if F.IntervalosCriticos[j] then inc(FC);

    inc(Result, FC);
    end;
end;

const cErro = 'PC <%s> não encontrado';

function TprProjeto.PCsEntreDois(const NomePC1, NomePC2: String): TStrings;
var pc, pc1, pc2: TprPCP;
    EncontrouPC2: boolean;
begin
  pc1 := PCPeloNome(NomePC1);
  pc2 := PCPeloNome(NomePC2);
  if pc1 = nil then Raise Exception.CreateFmt(cErro, [NomePC1]);
  if pc2 = nil then Raise Exception.CreateFmt(cErro, [NomePC2]);
  Result := TStringList.Create;

  EncontrouPC2 := False;

  pc := pc1;
  Result.AddObject(pc.Nome, pc);
  while pc <> nil do
    if pc.TrechoDagua <> nil then
       begin
       pc := pc.TrechoDagua.PC_aJusante;
       if pc = pc2 then
          begin
          Result.AddObject(pc.Nome, pc);
          EncontrouPC2 := True;
          Break;
          end
       else
          Result.AddObject(pc.Nome, pc);
       end
    else
       pc := nil;

  if not EncontrouPC2 then
     Result.Clear;
end;

function TprProjeto.Optimizer_getValue(const PropName: string; Year, Month: Integer): real;
begin
  if CompareText(PropName, 'NivelDeFalha') = 0 then
     Result := FNF else

  Result := inherited Optimizer_getValue(PropName, Year, Month);
end;

procedure TprProjeto.Optimizer_setValue(const PropName: string; Year, Month: Integer; const r: real);
begin
  if CompareText(PropName, 'NivelDeFalha') = 0 then
     FNF := r else

  inherited;
end;

procedure TprProjeto.VerificarIntervalosDeAnalise;
begin
  if FInts.NumInts = 0 then
     raise Exception.Create('Intervalos de Análise não definidos.'#13 +
                            'Utilize o menu Projeto/Intervalos de Análise');
end;

function TprProjeto.VerificarSePossuiCamadaEmBranco: Boolean;
begin
  Result := (AP(FAreaDeProjeto).Map.Layers.ByName('Null_Layer.shp') <> nil) and
            Map.Visible;
end;

function TprProjeto.AddLayer(FileName: String): Tmoec_Layer;
var sDataBase : string;
    dc        : ImoDataConnection;
    ML        : ImoMapLayer;
    IL        : ImoImageLayer;
    ext       : String;
    sDirTrab  : String;
begin
  VerificarSeSalvo();
  if VerificarSePossuiCamadaEmBranco() then
     raise NullLayerException.Create(cMsgErro08);

  Result := nil;
  sDirTrab := getDirTrab;
  sDataBase := ExtractFilePath(FileName);

  if sDataBase = '' then
     // Foi passado somente o nome do arquivo, sem o caminho
     // Isto significa que os arquivos deverão estar no dir. do projeto
     sDataBase := sDirTrab
  else
     begin
     FileName := ExtractFileName(FileName);

     // Copia a camada para o dir. do projeto se este é diferente do
     // dir. do arquivo passado para leitura
     if (sDataBase <> sDirTrab) then
        begin
        FMap.CopyLayer(sDataBase + FileName, sDirTrab);
        if DirectoryExists(sDirTrab) then
           sDataBase := sDirTrab;
        end
     end;

  if DirectoryExists(sDataBase) then
     begin
     ext := LowerCase(ExtractFileExt(FileName));

     // Camadas Vetorias
     if (ext = '.shp') then
        begin
        dc := CoDataConnection.Create;
        dc.Database := sDataBase;
        if dc.Connect then
           begin
           ML := CoMapLayer.Create;
           ML.GeoDataset := dc.FindGeoDataset(FileName);
           FMap.Layers.Add(ML, Result);
           end
        else
           raise Exception.Create('O sistema não conseguiu se conectar ao banco de dados:'#13 +
                                  sDataBase + #13 +
                                  'Erro ' + IntToStr(dc.ConnectError));
        end
     else

     // Camadas Raster
     if (ext = '.jpg') or (ext = '.bmp') or (ext = '.gif') or (ext = '.tiff') or
        (ext = '.tff') or (ext = '.tif') or (ext = '.sid') or (ext = '.ntf') or
        (ext = '.sun') or (ext = '.ras') or (ext = '.ovr') or (ext = '.img') then
        begin
        IL := CoImageLayer.Create;
        IL.File_ := sDataBase + '\' + FileName;
        if IL.Valid then FMap.Layers.Add(IL, Result);
        end

     else
        raise Exception.Create('Formato de Arquivo Desconhecido');

     end
  else
     if Map.Visible then
        raise Exception.Create('Diretório de Trabalho Inválido');

  if Result <> nil then AP(FAreaDeProjeto).AddLayer(Result);
end;

function TprProjeto.moPointToPoint(p: ImoPoint): TPoint;
var x, y: Single;
begin
  if p <> nil then
     begin
     FMap.FromMapPoint(p, x, y);
     Result.X := Trunc(x);
     Result.Y := Trunc(y);
     end
  else
     Result := Types.Point(0, 0);
end;
//{
function TprProjeto.PointTo_moPoint(p: TPoint): ImoPoint;
var mop: ImoPoint;
begin
  mop := FMap.ToMapPoint(p.x, p.y);
  Result := gmoPoint;
  Result.X := mop.X;
  Result.Y := mop.Y;
end;
//}
{
function TprProjeto.PointTo_moPoint(p: TPoint): ImoPoint;
begin
  Result := FMap.ToMapPoint(p.x, p.y);
end;
}
function TprProjeto.CriarObjeto(const ID: String; Pos: ImoPoint): THidroComponente;
var i: Integer;
    p: Types.TPoint;
begin
  VerificarSeSalvo();

  if ID = 'PC' then
     begin
     Result := TprPCP.Create(Pos, Self, FTN);
     end
  else

  if ID = 'Reservatorio' then
     begin
     Result := TprPCPR.Create(Pos, Self, FTN);
     end
  else

  if ID = 'Sub-Bacia' then
     begin
     p := moPointToPoint(Pos);
     inc(p.x, 30); dec(p.y, 30);
     Result := TprSubBacia.Create(PointTo_moPoint(p), self, FTN);
     end
  else
  
  if ID = 'Demanda' then
     begin
     p := moPointToPoint(Pos);
     inc(p.x, 20); dec(p.y, 20);
     Result := TprDemanda.Create(PointTo_moPoint(p), Self, FTN);
     end
  else

end;

function TprProjeto.getDirTrab: String;
begin
  if FDirTrab <> '' then
     Result := FDirTrab
  else
     Result := ObterDiretorioDoProjeto;
end;

function TprProjeto.ObterDiretorioDoProjeto: String;
begin
  Result := ExtractFilePath(NomeArquivo);
  //If LastChar(Result) = '\' then Delete(Result, Length(Result), 1);
end;

procedure TprProjeto.VerificarSeSalvo;
begin
  if (FNomeArquivo = '') and Map.Visible then
     raise ProjectNotSaved.Create('Por favor. Salve o projeto primeiro.');
end;

{ TprFalha }

constructor TprFalha.Create(Ano, Intervalo: Integer; Const DR, DA, NCF: Real);
begin
  inherited Create;

  FIntervalos := TIntegerList.Create;
  FIntCrit    := TBooleanList.Create;
  FDemsRef    := TDoubleList.Create;
  FDemsAten   := TDoubleList.Create;

  FAno := Ano;
  FIntervalos.Add(Intervalo);
  FIntCrit.Add(DA < DR * NCF);
  FDemsRef.Add(DR);
  FDemsAten.Add(DA);
end;

destructor TprFalha.Destroy;
begin
  FIntervalos.Free;
  FIntCrit.Free;
  FDemsRef.FRee;
  FDemsAten.Free;
  inherited Destroy;
end;

function TprFalha.GetFalhaCritica: Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to FIntCrit.Count-1 do
    if FIntCrit[i] then
       begin
       Result := True;
       Break;
       end;
end;

function TprFalha.GetSAno: String;
begin
  Result := IntToStr(Ano);
end;

{ TListaDeIntervalos }

procedure TListaDeIntervalos.Adicionar(Ini, Fim: Integer; const Nome: String; Habilitado: Boolean);
begin
  FIntIni.Add(Ini);
  FIntFim.Add(Fim);
  FNomes.Add(Nome);
  FHab.Add(byte(Habilitado));
end;

constructor TListaDeIntervalos.Create;
begin
  inherited Create;
  FIntIni := TIntegerList.Create;
  FIntFim := TIntegerList.Create;
  FHab    := TIntegerList.Create;
  FNomes  := TStringList.Create;
end;

destructor TListaDeIntervalos.Destroy;
begin
  FIntIni.Free;
  FIntFim.Free;
  FHab.Free;
  FNomes.Free;
  inherited Destroy;
end;

function TListaDeIntervalos.GetHabilitado(i: Integer): Boolean;
begin
  Result := (FHab[i] = 1);
end;

function TListaDeIntervalos.GetNome(i: Integer): String;
begin
  Result := FNomes[i];
end;

function TListaDeIntervalos.getNumInts: Integer;
begin
  Result := FIntIni.Count;
end;

function TListaDeIntervalos.GetsDataFim(i: Integer): String;
begin
  Result := IntervaloToStrData(FProjeto, FIntFim[i]);
end;

function TListaDeIntervalos.GetsDataIni(i: Integer): String;
begin
  Result := IntervaloToStrData(FProjeto, FIntIni[i]);
end;

procedure TListaDeIntervalos.Limpar;
begin
  FIntIni.Free; FIntIni := TIntegerList.Create;
  FIntFim.Free; FIntFim := TIntegerList.Create;
  FHab.Free;    FHab    := TIntegerList.Create;
  FNomes.Clear;
end;

procedure TListaDeIntervalos.Remover(indice: Integer);
begin
  FIntIni.Delete(Indice);
  FIntFim.Delete(Indice);
  FHab.Delete(Indice);
  FNomes.Delete(Indice);
end;

{ TprProjeto_Rosen }

constructor TprProjeto_Rosen.Create(UmaTabelaDeNomes: TStrings; AreaDeProjeto: TForm);
begin
  Inherited Create(UmaTabelaDeNomes, AreaDeProjeto);
  FRosenbrock := TRosenbrock.Create;
  FRosenbrock.OnGeralFunction := Rosen_GeralFunction;
end;

destructor TprProjeto_Rosen.Destroy;
begin
  FRosenbrock.Free;
  inherited;
end;

procedure TprProjeto_Rosen.ExecutarSimulacao;
var Erro: String;
begin
  if FStatus = sOtimizando then
     try
       AP(FAreaDeProjeto).Progresso.Position := 0;
       Erro := '';

       // Inicia os objetos da rede
       GetMessageManager.SendMessage(UM_INICIAR_SIMULACAO, [self]);
       if Assigned(FEvento_InicioSimulacao) then FEvento_InicioSimulacao(Self);
       AtualizaPontoExecucao('', nil);

       try
         inc(FIndSimulacao);
         FSimulador.Resume; // acho que falta criar a instancia !!!!! e os eventos
         AtualizaPontoExecucao('', nil);
       except
         on E: Exception do Erro := E.Message;
       end;
     finally
       if Assigned(FEvento_FimSimulacao) then FEvento_FimSimulacao(Self);
       if FEC <> '' then
          begin
          gOutPut.Editor.Write   ('Processo de otimização não concluído.');
          gOutPut.Editor.WriteFmt('  A %d simulação não foi finalizada.', [FIndSimulacao]);
          gOutPut.Editor.Write   ('    - Último ponto de execução ... ' + FEC);
          gOutPut.Editor.Write   ('    - Delta T .................... ' + IntToStr(FDeltaT));
          if Erro <> '' then
             gOutPut.Editor.Write('    - Erro ....................... ' + Erro);
          gOutPut.Editor.Show;
          gOutPut.Editor.GoLastLine;
          end;
     end
  else
     inherited;
end;

procedure TprProjeto_Rosen.DispararOtimizacao;
begin
  ExecutarRotinaDeInicializacao;
  try
    FRosenbrock.Execute;
  finally
    ExecutarRotinaDeFinalizacao;
  end;
end;

procedure TprProjeto_Rosen.IniciarOtimizacao;
var i: Integer;
begin
  FStatus := sOtimizando;

  // Rosen ...
  FRosenbrock.Parameters.Clear;

  // Inicia o relógio da Simulação e outras variáveis de controle
  FIndSimulacao := 0;
  FDeltaT := 0;
  FIntervalosSim := getTIS;

  // Ordena os PCs por Prioridade
  FPCs.Ordenar;

  for i := 0 to PCs.PCs-1 do
    TprPCP(PCs[i]).TotalizaDemandas;

  // Salva as configurações da área de projeto
  FCaption                              := AP(FAreaDeProjeto).Caption;
  AP(FAreaDeProjeto).Cursor             := crHourGlass;
  AP(FAreaDeProjeto).Enabled            := False;
  AP(FAreaDeProjeto).Progresso.Max      := Total_IntSim;
  AP(FAreaDeProjeto).Progresso.Visible  := True;

  // Inicializacao do mecanismo de simulacao
  FSimulador             := TSimulation.Create(True);
  FSimulador.OnClock     := Temporizador;
  FSimulador.OnEvent     := Simulacao;
  FSimulador.OnDoVisual  := AP(FAreaDeProjeto).AtualizacaoVisualDaSimulacao;

  GetMessageManager.SendMessage(UM_PREPARAR_SCRIPTS, [self]);
end;

procedure TprProjeto_Rosen.FinalizarOtimizacao;
begin
  // Rosen.Free;
  FreeAndNil(FSimulador);

  // Recupera as configurações da área de projeto
  AP(FAreaDeProjeto).Caption           := FCaption;
  AP(FAreaDeProjeto).Cursor            := crDefault;
  AP(FAreaDeProjeto).Enabled           := True;
  AP(FAreaDeProjeto).Progresso.Visible := False;

  FStatus := sFazendoNada;

  try
    ExecutarRotinaGeral;
  finally
    GetMessageManager.SendMessage(UM_LIBERAR_SCRIPTS, [self]);
  end;
end;

procedure TprProjeto_Rosen.Otimizar;
begin
  if RealizarDiagnostico(True) then
     try
       IniciarOtimizacao;
       DispararOtimizacao;
     finally
       FinalizarOtimizacao;
     end
  else
     gOutPut.Show;
end;

procedure TprProjeto_Rosen.TerminarOtimizacao;
begin
  FRosenbrock.Stop;
end;

function TprProjeto_Rosen.CriaDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_ProjetoRosen.Create(nil);
  Result.TabelaDeNomes := FTN;
end;

procedure TprProjeto_Rosen.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_ProjetoRosen) do
    begin
    FIniRosenbrockUsuario   := RotinasRosenbrock.edIniUsuario.Text;
    FFimRosenbrockUsuario   := RotinasRosenbrock.edFimUsuario.Text;
    FGeralRosenbrockUsuario := RotinasRosenbrock.edGeralUsuario.Text;
    end;
end;

procedure TprProjeto_Rosen.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_ProjetoRosen) do
    begin
    RotinasRosenbrock.edIniUsuario.Text   := FIniRosenbrockUsuario;
    RotinasRosenbrock.edFimUsuario.Text   := FFimRosenbrockUsuario;
    RotinasRosenbrock.edGeralUsuario.Text := FGeralRosenbrockUsuario;
    end;
end;

procedure TprProjeto_Rosen.ValidarDados(var TudoOk: Boolean;
  DialogoDeErros: TErros_DLG; Completo: Boolean);
var IU, FU, GU : String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
  if Dialogo <> nil then
     begin
     IU := TprDialogo_ProjetoRosen(Dialogo).RotinasRosenbrock.edIniUsuario.Text;
     FU := TprDialogo_ProjetoRosen(Dialogo).RotinasRosenbrock.edFimUsuario.Text;
     GU := TprDialogo_ProjetoRosen(Dialogo).RotinasRosenbrock.edGeralUsuario.Text;
     end
  else
     begin
     IU := FIniRosenbrockUsuario;
     FU := FFimRosenbrockUsuario;
     GU := FGeralRosenbrockUsuario;
     end;

  VerificarRotinaUsuario(IU, 'Inicialização do Rosenbrock', Completo, TudoOk, DialogoDeErros);
  VerificarRotinaUsuario(FU, 'Finalização do Rosenbrock'  , Completo, TudoOk, DialogoDeErros);
  VerificarRotinaUsuario(GU, 'Rotina Geral do Rosenbrock', Completo, TudoOk, DialogoDeErros, True);
end;

procedure TprProjeto_Rosen.LerDoArquivo(Ini: TIF; const Secao: String);
begin
  Inherited LerDoArquivo(Ini, Secao);

  FIniRosenbrockUsuario   := Ini.ReadString (Secao, 'Rosen Ini', '');
  FFimRosenbrockUsuario   := Ini.ReadString (Secao, 'Rosen Fim', '');
  FGeralRosenbrockUsuario := Ini.ReadString (Secao, 'Rosen Geral', '');
end;

procedure TprProjeto_Rosen.SalvarEmArquivo(Arquivo: TIF);
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteString (Section, 'Rosen Ini',   FIniRosenbrockUsuario);
    WriteString (Section, 'Rosen Fim',   FFimRosenbrockUsuario);
    WriteString (Section, 'Rosen Geral', FGeralRosenbrockUsuario);
    end;
end;

function TprProjeto_Rosen.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     if FIniRosenbrockUsuario <> '' then
        begin
        PreparaScript(FIniRosenbrockUsuario, FIniRosenbrockScript);
        FIniRosenbrockScript.Compile;
        end;

     if FFimRosenbrockUsuario <> '' then
        begin
        PreparaScript(FFimRosenbrockUsuario, FFimRosenbrockScript);
        FFimRosenbrockScript.Compile;
        end;

     if FGeralRosenbrockUsuario <> '' then
        begin
        PreparaScript(FGeralRosenbrockUsuario, FGeralRosenbrockScript);
        FGeralRosenbrockScript.Variables.AddVar(
          TVariable.Create('FO', pvtReal, 0, TObject, True));
        FGeralRosenbrockScript.Compile;
        end;
     end else

  if MSG.ID = UM_LIBERAR_SCRIPTS then
     begin
     FreeAndNil(FIniRosenbrockScript);
     FreeAndNil(FFimRosenbrockScript);
     FreeAndNil(FGeralRosenbrockScript);
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TprProjeto_Rosen.ExecutarRotinaDeFinalizacao;
begin
  if FFimRosenbrockUsuario <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.ScriptFimRosenbrock', FFimRosenbrockScript);
     FFimRosenbrockScript.Execute;
     AtualizaPontoExecucao('', nil);
     end;
end;

procedure TprProjeto_Rosen.ExecutarRotinaDeInicializacao;
begin
  if FIniRosenbrockUsuario <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.ScriptIniRosenbrock', FIniRosenbrockScript);
     FIniRosenbrockScript.Execute;
     AtualizaPontoExecucao('', nil);
     end;
end;

// O mecanismo do Rosenbrock é quem chama este método
function TprProjeto_Rosen.Rosen_GeralFunction(Params: TrbParameters): Real;
begin
  ExecutarSimulacao;
  if FGeralRosenbrockUsuario <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.ScriptGeralRosenbrock', FGeralRosenbrockScript);
     FGeralRosenbrockScript.Execute;
     AtualizaPontoExecucao('', nil);
     Result := FGeralRosenbrockScript.Variables.VarByName('FO').Value;
     end
  else
     Result := 0;
end;

end.

