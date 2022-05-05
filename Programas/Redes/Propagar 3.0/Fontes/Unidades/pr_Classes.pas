unit pr_Classes;

{
  Instruções de como implementar processos: Olhar arquivo "Como (How-To).txt"
}
                                              
{                                   
  Sempre procurar pelo símbolo "<<<", ele indica coisas inacabadas ou desabilitadas
}

  // Colocar um exit quando uma mensagem for reconhecida nos ReceiveMessages

interface
uses Types, Classes, Windows, Messages, Forms, SysUtils, ExtCtrls,
     Graphics, Controls, ComCtrls, Menus, Contnrs, ActnList,

     // Geral
     MSXML4,
     XML_Utils,
     XML_Interfaces,
     foBook,
     Plugin,
     Rochedo.Simulators.Shapes,
     MessageManager,
     Simulation,
     wsMatrix,
     teEngine,
     Form_Chart,
     SysUtilsEx,
     Lists,
     MessagesForm,
     EquationBuilder,
     Solver.Classes,

     // PascalScript
     psBASE,
     psCORE,
     Lib_GlobalObjects,

     // Otimizadores
     Optimizer_Interfaces,
     Optimizer_Base,
     Rosenbrock_Optimizer,
     Genetic_Optimizer,

     // Propagar
     pr_Const,
     pr_Tipos,
     pr_Interfaces,
     pr_DialogoBase,
     pr_Dialogo_PCP,
     pr_Dialogo_PCPR,
     pr_Dialogo_SB,
     pr_Dialogo_TD,
     pr_Dialogo_QA,
     pr_Dialogo_Descarga,
     pr_Dialogo_ClasseDeDemanda,
     pr_Dialogo_Demanda,
     pr_Dialogo_Projeto,
     pr_Dialogo_Projeto_Otimizavel;

type
  TEventoDeMonitoracao = procedure(Sender: TObject;
                                   const Variavel: String;
                                   const Valor: Real) of object;

  TprPC                    = class;
  TprSubBacia              = class;
  TprDemanda               = class;
  TprCenarioDeDemanda      = class;
  TprQualidadeDaAgua       = class;
  TprDescarga              = class;
  TprProjeto               = class;
  TprListaDeClassesDemanda = class;
  TprListaDePCs            = class;
  TprListaDeIntervalos     = class;

  // Excecoes

  ProjectNotSaved = class(Exception);
  NullLayerException = class(Exception);

  // Classes básicas -----------------------------------------------------------------

  THidroComponente = class(T_NRC_InterfacedObject, IMessageReceptor,
                                                   IOptimizableParameter,
                                                   IIdentificatorOwner)
  private
    // Salvas
    FNome          : String;
    FDescricao     : String;
    FComentarios   : TXML_StringList;
    FScripts       : TStrings;
    FDefaultScript : integer;

    // Representam as posicoes dos objetos.
    // Sao do tipo reais para poderem armazenarem tanto
    // coordenadas de tela quanto coord. geo referenciadas.
    FPos: TMapPoint;

    FVisitado    : Boolean;
    FModificado  : Boolean;
    FProjeto     : TprProjeto;
    FBloqueado   : Boolean;

    FVarsQuePodemSerMonitoradas : String;
    FVarsMonitoradas            : String;

    FEventoDeMonitoracao    : TEventoDeMonitoracao;
    FImagemDoComponente     : TdrBaseShape;
    FDialogo                : TprDialogo_Base;
    FTN                     : TStrings;
    FAvisarQueVaiSeDestruir : Boolean;

    // Utilizado na navegacao pelos nós quando lemos as informações
    // de um arquivo XML
    FNodeIndex : integer;

    procedure setPos(const Value: TMapPoint);
    function  getScreenArea(): TRect;
    function  getScreenPos(): TPoint;

    procedure setModificado(const Value: Boolean);

    procedure setNome(const Value: String);
    procedure DuploClick(Sender: TObject);
    procedure CriarComponenteVisual(AreaDeProjeto: TObject; const Pos: TMapPoint);
    function  ObterNomeDaSecao: String;
    procedure AtualizarHint();
    function  CriarNome: String;
    procedure PreparaScript(Arquivo: String; var Script: TPascalScript);
    function  ObterDataSet(Dados: TV): TwsDataSet;
    procedure MostrarDataSet(const Titulo: String; Dados: TwsDataSet);

    // Eventos
    procedure EditEvent(Sender: TObject);
    procedure ExecuteScriptEvent(Sender: TObject);
  protected
    // Mostra uma propriedade em planilha
    procedure MostrarVariavel(const NomeVar: String); Virtual; Abstract;

    // Retorna informacoes adicionais para serem mostradas no hint do componente
    function getHint(): string; virtual;

    // salva as informações da instância
    procedure internalToXML(); virtual;

    // Salva os dados da instancia para XML
    procedure toXML();

    // Le a instancia de um XML
    procedure fromXML(no: IXMLDomNode); virtual;

    // IMessageReceptor Interface
    function ReceiveMessage(Const MSG: TadvMessage): Boolean; virtual;

    // IOptimizer
    function op_getValue(const PropName: string; i1, i2: Integer): real; virtual;
    procedure op_setValue(const PropName: string; i1, i2: Integer; const r: real); virtual;

    function  CriarImagemDoComponente(): TdrBaseShape; Virtual; Abstract;
    function  ObterPrefixo: String; Virtual;

    // Comunicação com o usuário (Interface gráfica)
    function  CriarDialogo: TprDialogo_Base; Virtual;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Virtual;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Virtual;
    procedure ColocarDadosNaPlanilha(Planilha: TForm); Virtual; Abstract;

    // IIdentificatorOwner
    function io_getOwnerName(): string; virtual;
    function io_getValue(const FieldName: string): string; virtual;
  public
    constructor Create(TabelaDeNomes: TStrings; Projeto: TprProjeto);
    destructor Destroy(); override;

    // Fornece as acoes que este objeto disponibiliza
    procedure getActions(Actions: TActionList); virtual;

    // Executa um script
    procedure ExecuteScript(const Filename: string);

    // Utilizados para navegacao dos nós filhos de um nó
    function firstChild(no: IXMLDomNode): IXMLDomNode;
    function nextChild(no: IXMLDomNode): IXMLDomNode;

    // Calcula o número de dias de um Intervalo
    function DiasNoIntervalo(Intervalo: integer): Integer;

    procedure DefinirVariaveisQuePodemSerMonitoradas(const Variaveis: Array of String);
    procedure MotitorarVariaveis(const Variaveis: Array of String);
    procedure Monitorar(); virtual;

    function  ObjetoPeloNome(const Nome: String): TObject;
    procedure MostrarErro(const Erro: String);

    function  CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TfoChart;
    procedure DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);

    function  Editar(): Integer;
    procedure MostrarPlanilha();

    function  ConectarObjeto(Obj: THidroComponente): Integer; Virtual; Abstract;

    // Realiza as inicializações para as simulações
    // Este método é chamado através de um evento disparado antes de uma simulação
    procedure PrepararParaSimulacao; virtual;

    {Realiza somente a validação dos dados (Erros Fatais)
     Regra: A variável TudoOk deverá ser inicializada em TRUE}
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Virtual;

    {Realiza o diagnóstico dos dados (Erros Fatais e Avisos)}
    procedure Diagnostico(var TudoOk: Boolean; Completo: Boolean = False);

    // Rotinas de tratamento de Paths de arquivo
    function  VerificaCaminho(var Arquivo: String): Boolean;
    procedure RetiraCaminhoSePuder(var Arquivo: String);

    procedure VerificaRotinaUsuario(Arquivo: String; const Texto: String;
                                    Completo: Boolean; var TudoOk: Boolean;
                                    DialogoDeErros: TfoMessages);


    property Pos : TMapPoint read FPos write setPos;

    // Representa a posicao na tela
    property ScreenPos : TPoint read GetScreenPos;

    // Representa a area ocupada na tela
    property ScreenArea : TRect read getScreenArea;

    // Representa o projeto a que este objeto pertence
    property Projeto : TprProjeto read FProjeto write FProjeto;

    property Visitado   : Boolean    read FVisitado   write FVisitado;
    property Modificado : Boolean    read FModificado write SetModificado;
    property Bloqueado  : Boolean    read FBloqueado  write FBloqueado;

    property VarsQuePodemSerMonitoradas : String read FVarsQuePodemSerMonitoradas;
    property VarsMonitoradas            : String read FVarsMonitoradas write FVarsMonitoradas;

    property EventoDeMonitoracao : TEventoDeMonitoracao
        read FEventoDeMonitoracao
        write FEventoDeMonitoracao;

    property AvisarQueVaiSeDestruir: Boolean
       read  FAvisarQueVaiSeDestruir
       write FAvisarQueVaiSeDestruir;

    property TabNomes      : TStrings        read FTN;
    property Nome          : String          read FNome         write SetNome;
    property Descricao     : String          read FDescricao    write FDescricao;
    property Comentarios   : TXML_StringList read FComentarios;
    property Scripts       : TStrings        read FScripts;
    property DefaultScript : integer         read FDefaultScript write FDefaultScript;
    property Imagem        : TdrBaseShape    read FImagemDoComponente;
  end;

  TprListaDeObjetos = Class
  private
    FList: TList;
    FLiberarObjetos: Boolean;
    function  getObjeto(index: Integer): THidroComponente;
    procedure setObjeto(index: Integer; const Value: THidroComponente);
    function  getNumObjetos: Integer;
  public
    constructor Create();
    Destructor  Destroy(); override;

    function  IndiceDo(Objeto: THidroComponente): Integer;
    procedure Deletar(Indice: Integer);
    function  Remover(Objeto: THidroComponente): Integer;
    function  Adicionar(Objeto: THidroComponente): Integer;
    procedure RemoverNulos;
    procedure Ordenar(FuncaoDeComparacao: TListSortCompare);

    property LiberarObjetos: Boolean read FLiberarObjetos write FLiberarObjetos;
    property Objeto[index: Integer]: THidroComponente read getObjeto write setObjeto; default;
    property Objetos: Integer read getNumObjetos;
  end;

  // Classes específicas -------------------------------------------------------------

  TprTrechoDagua = class(THidroComponente)
  private
    FVazaoMinima : Real;
    FVazaoMaxima : Real;
    FLargBocaSecaoMedia: Real;
    FDeclividade: Real;
    FComprimento: Real;
    FRaioHidrologico: Real;
    FAreaSecaoMedia: Real;
    FCoefManning: Real;
    FPerimSecaoMedia: Real;
    function getVelocidade: real;
  protected
    function  ObterPrefixo(): String; Override;
    function  CriarDialogo(): TprDialogo_Base; Override;
    function  ReceiveMessage(const MSG: TadvMessage): Boolean; Override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
  public
    PC_aMontante : TprPC;
    PC_aJusante  : TprPC;

    constructor Create(PC1, PC2: TprPC; TabelaDeNomes: TStrings; Projeto: TprProjeto);
    destructor Destroy(); override;

    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;

    property VazaoMaxima        : Real read FVazaoMaxima        write FVazaoMaxima;
    property VazaoMinima        : Real read FVazaoMinima        write FVazaoMinima;
    property Comprimento        : Real read FComprimento        write FComprimento;
    property AreaSecaoMedia     : Real read FAreaSecaoMedia     write FAreaSecaoMedia;
    property PerimSecaoMedia    : Real read FPerimSecaoMedia    write FPerimSecaoMedia;
    property LargBocaSecaoMedia : Real read FLargBocaSecaoMedia write FLargBocaSecaoMedia;
    property RaioHidrologico    : Real read FRaioHidrologico    write FRaioHidrologico;
    property CoefManning        : Real read FCoefManning        write FCoefManning;
    property Declividade        : Real read FDeclividade        write FDeclividade;

    // Velocidade média 
    property Velocidade : real read getVelocidade;
  end;

  TprPC = Class(THidroComponente)
  private
    // FLC somente contém referências a outros objetos
    FPCs_aMontante  : TprListaDeObjetos;
    FSubBacias      : TprListaDeObjetos;
    FDemandas       : TprListaDeObjetos;
    FDescargas      : TprListaDeObjetos;
    FTD             : TprTrechoDagua;

    // Componente que representa a qualidade da agua em um determinado ponto
    FQA: TprQualidadeDaAgua;

    FVisivel        : Boolean;
    FHierarquia     : Integer;
    FAfluenciaSB    : TV;      // Afluencia no intervalo t
    FDefluencia     : TV;      // Defluencia no intervalo t
    FVzMon          : TV;      // Vazão total de Montante no intervalo t

    function  GetPCs_aMontante(): Integer;
    function  GetNumSubBacias(): Integer;
    function  GetNumDemandas(): Integer;
    function  GetPC_aJusante(): TprPC;
    function  GetPC_aMontante(Index: Integer): TprPC;
    function  GetDemanda(index: Integer): TprDemanda;
    function  GetSubBacia(index: Integer): TprSubBacia;
    procedure SetVisivel(Value: Boolean);
    procedure SetPC_aJusante(Value: TprPC);
    procedure DestruirEquacoes();
    function GetDescarga(index: Integer): TprDescarga;
    function GetNumDescargas: Integer;
  protected
    FEQL: TEquationList;

    // Metodos Virtuais
    destructor Destroy(); override;
    function  io_getValue(const FieldName: string): string; override;
    procedure CriarEquacoes(); virtual; abstract;
    procedure MostrarVariavel(const NomeVar: String); override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function  CriarImagemDoComponente(): TdrBaseShape; override;
    procedure ColocarDadosNaPlanilha(Planilha: TForm); override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);

    procedure Monitorar(); override;

    // Métodos que mexem com as listas de Objetos
    function ConectarObjeto(Obj: THidroComponente): Integer; override;
    function Eh_umPC_aMontante(PC: THidroComponente): Boolean;
    procedure RemoverTrecho(); // Remove trecho de agua a frente
    procedure DesconectarObjetos(); // Limpa todos os objetos conectados a este PC, exceto outros PCs
    procedure DesconectarPC_aMontante(PC: TprPC); // Remove coneccao atras
    procedure AdicionarPC_aMontante(PC: TprPC); // Insere na Lista de Chegada

    function  ObterVazoesDeMontante(Intervalo: integer): Real; virtual; abstract;
    function  ObterVazaoAfluenteSBs(Intervalo: integer): Real;

    procedure BalancoHidrico; virtual; abstract;
    procedure PrepararParaSimulacao; override;
    procedure GerarEquacoes(Text: TStrings; Intervalo: integer; var IndiceGeral: integer);

    property Hierarquia:       Integer         read FHierarquia write FHierarquia;
    property PCs_aMontante:    Integer         read GetPCs_aMontante;
    property SubBacias:        Integer         read GetNumSubBacias;
    property Demandas:         Integer         read GetNumDemandas;
    property Descargas:        Integer         read GetNumDescargas;
    property PC_aJusante:      TprPC           read GetPC_aJusante write SetPC_aJusante;
    property TrechoDagua:      TprTrechoDagua  read FTD;
    property Visivel:          Boolean         read FVisivel write SetVisivel;

    property AfluenciaSB : TV read FAfluenciaSB;
    property Defluencia  : TV read FDefluencia;
    property VazMontante : TV read FVzMon;

    // coneccoes ...

    property PC_aMontante [index: Integer]: TprPC       read GetPC_aMontante;
    property SubBacia     [index: Integer]: TprSubBacia read GetSubBacia;
    property Demanda      [index: Integer]: TprDemanda  read GetDemanda;
    property Descarga     [index: Integer]: TprDescarga read GetDescarga;

    property QualidadeDaAgua : TprQualidadeDaAgua read FQA;
  end;

  TprListaDeFalhas = class;
  TprPCPR          = class;

  TprPCP = class(TprPC) // PC Propagar
  private
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

    FGerarEnergia       : Boolean;
    FRendiGera          : Real;
    FQMaxTurb           : Real;
    FRendiAduc          : Real;
    FRendiTurb          : Real;
    FDemEnergetica      : Real;
    FQuedaFixa          : Real;
    FArqDemEnergetica   : String;

    procedure CopiarPara(PC: TprPCP);

    procedure GraficarDemandas(const Titulo, TipoDem: String; TipoGraf: TEnumTipoDeGrafico);
    procedure ObtemNiveisCriticosDeFalhas;
    procedure SetMDs(const Value: Boolean);
    procedure CalculaVzMon_e_AfluenciaSB();
    function  CalculaEnergia(Queda, Vazao : Real; Intervalo: integer): Real;
    procedure Raciona(AguaDisponivel, DPX, DSX, DTX: Real; out DPA, DSA, DTA: Real);

    // Eventos
    procedure GraphicEvent (Sender: TObject);
    procedure ShowDemandsEvent (Sender: TObject);
    procedure ShowFaultsEvent (Sender: TObject);
    procedure ShowSheetEvent (Sender: TObject);
    procedure ShowDataInSheetEvent (Sender: TObject);
  protected
    // Usado temporariamente na montagem dos menus dinamicos
    // para salvar a acao corrente para ser usada pelos descendentes
    // Are o momento, somente a classe "TprPCPR" o utiliza.
    FMenuAction_Sheet: TAction;

    function  CriarDialogo(): TprDialogo_Base; override;
    Function  ObterPrefixo(): String; override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); override;
    procedure ColocarDadosNaPlanilha(Planilha: TForm); override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure BalancoHidrico(); override;
    function  op_getValue(const PropName: string; i1, i2: Integer): real; override;
    procedure op_setValue(const PropName: string; i1, i2: Integer; const r: real); override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure getActions(Actions: TActionList); override;
    procedure MostrarVariavel(const NomeVar: String); override;
    procedure CriarEquacoes(); override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);
    destructor  Destroy(); override;

    function MudarParaReservatorio(): TprPCPR;

    procedure Monitorar(); override;

    // Metodos de conversao
    // Necessita do intervalo para calculo do numero de dias em um intervalo
    function  Hm3_m3(const Valor: Real; Intervalo: integer): Real;
    function  m3_Hm3(const Valor: Real; Intervalo: integer): Real;

    procedure TotalizarDemandas();
    function  CalculaFatorRetorno(Tipo: TEnumPriorDemanda): Real;
    function  ObterVazoesDeMontante(Intervalo: integer): Real; override;
    function  ObterDemanda(Prioridade: TEnumPriorDemanda; Intervalo: integer): Real;

    procedure PrepararParaSimulacao(); override;

    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;

    procedure GraficarTudo(); Virtual;
    procedure GraficarDemandasAtendidas (Tipo: TEnumTipoDeGrafico);
    procedure GraficarDemandasPlanejadas(Tipo: TEnumTipoDeGrafico);
    procedure GraficarDemandasTotais (Tipo: TEnumTipoDeGrafico);
    procedure GraficarDisponibilidade_X_Demanda(Tipo: TEnumTipoDeGrafico);
    procedure GraficarEnergia(Tipo: TEnumTipoDeGrafico);

    function  ObtemFalhas(): TprListaDeFalhas;
    procedure MostrarFalhas();

    // Palavras-Chaves: Equacao, Equacoes, Equation, Equations

    // Muda o tipo do identificador. Se Decisao, a variável aparecerá no lado
    // esquerdo da equacao. Se Estado aparecerá no lado direito. Se Constante,
    // aparecerá o valor atual da variável.
    //   indEQ : Índice da Equação
    //   Nome  : Nome do Identificador
    //   Tipo  : Tipo do Identificador
    procedure Equacoes_MudarTipoVar(indEQ: Integer; const Nome: string; Tipo: TIdentType);

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
    FLigado      : boolean;
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

    function  GetAV(index: Word): TRecAreaVolume;
    function  GetCV(index: Word): TRecCotaVolume;
    function  GetPAV: Word;
    function  GetPCV: Word;
    function  GetEU: TV;
    function  GetPU: TV;
    procedure SetPAV(const Value: Word);
    procedure SetPVC(const Value: Word);
    function  ObtemVolFinalIntervaloAnterior: Real;
    procedure Opera(const VolumeDisponivel, DPP, DSP, DTP, Deflu_Pl: Real;
                    out DPO, DSO, DTO, Deflu_OP: Real);
  protected
    // IOptimizableParameter interface
    function op_getValue(const PropName: string; i1, i2: Integer): real; override;
    procedure op_setValue(const PropName: string; i1, i2: Integer; const r: real); override;

    destructor Destroy(); override;
    function  ObterPrefixo(): String; override;
    function  CriarImagemDoComponente(): TdrBaseShape; override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); override;
    function  CriarDialogo: TprDialogo_Base; override;
    procedure MostrarVariavel(const NomeVar: String); override;
    procedure ColocarDadosNaPlanilha(Planilha: TForm); override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure BalancoHidrico(); override;
    procedure getActions(Actions: TActionList); override;
    procedure CriarEquacoes(); override;
    function io_getValue(const FieldName: string): string; override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);

    function  CalculaCotaHidraulica(const Volume: Real): Real;
    function  CalculaAreaDoReservatorio(const Volume: Real): Real;

    procedure PrepararParaSimulacao(); override;
    function  MudarParaPC(): TprPCP;

    procedure GraficarVolumes(Tipo: TEnumTipoDeGrafico);
    procedure GraficarTudo(); Override;
    procedure Monitorar; override;

    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;

    // Indica quando o reservatorio devera fazer seu BH ou se comportar como um simples PC
    // Ligado eh true por default.
    property Ligado : boolean read FLigado write FLigado;

    property ArqPrec       : String  read FArqPrec     write FArqPrec;
    property ArqETP        : String  read FArqETP      write FArqETP;
    property TipoETP       : Byte    read FTipoETP     write FTipoETP;
    property VolumeMaximo  : Real    read FVolMax      write FVolMax;
    property VolumeMinimo  : Real    read FVolMin      write FVolMin;
    property VolumeInicial : Real    read FVolIni      write FVolIni;
    property CotaJusante   : Real    read FCotaJusante write FCotaJusante;

    property PontosCV      : Word    read GetPCV    write SetPVC;
    property PontosAV      : Word    read GetPAV    write SetPAV;
    property Status        : Boolean read FStatus   write FStatus;

    property CV[i: Word]: TRecCotaVolume  read GetCV;   // Cota Volume
    property AV[i: Word]: TRecAreaVolume  read GetAV;   // Área Volume

    property Volume               : TV read FVolume;
    property DefluvioPlanejado    : TV read FDeflu_Pl;
    property DefluvioOperado      : TV read FDeflu_Op;
    property EvaporacaoUnitaria   : TV read getEU;
    property PrecipitacaoUnitaria : TV read getPU;
  end;

  TprSubBacia = Class(THidroComponente)
  private
    FPCs      : TprListaDeObjetos;
    FDemandas : TprListaDeObjetos;

    FCCs    : TDoubleList;
    FArea   : Real;
    FArqVA  : String;
    FVazoes : TV;

    function getNDD: Integer;
    function GetDD(index: Integer): TprDemanda;
    function GetVazoes(): TV;
    procedure GraficarVazoes(Tipo: TEnumTipoDeGrafico);
    procedure LiberarVazoes();
    procedure DesconectarObjetos();
    function ObterVazaoAfluente(PC: TprPC; Intervalo: integer): Real;

    // Eventos
    procedure ShowSheetEvent (Sender: TObject);
    procedure ShowOutletInSheetEvent (Sender: TObject);
    procedure ShowOutletInGraphicEvent (Sender: TObject);
  protected
    destructor Destroy(); override;
    function ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure MostrarVariavel(const NomeVar: String); override;
    function ObterPrefixo: String; Override;
    function CriarDialogo: TprDialogo_Base; Override;
    function CriarImagemDoComponente(): TdrBaseShape;  Override;
    function ReceiveMessage(const MSG: TadvMessage): Boolean; Override;
    procedure ColocarDadosNaPlanilha(Planilha: TForm); Override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure getActions(Actions: TActionList); override;
    procedure PrepararParaSimulacao(); override;
    procedure Monitorar(); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);

    // Area da Bacia
    property Area : Real read FArea write FArea;

    // Numero de Demandas conectadas a esta Sub-Bacia
    property Demandas : Integer read getNDD;

    // Retorna uma das demandas conectadas
    property Demanda[index: Integer] : TprDemanda read GetDD;

    // Nome do arquivo de vazoes afluentes
    property Arq_VazoesAfluentes : String read FArqVA;

    // PCs a que esta sub-bacia esta conectada
    property PCs : TprListaDeObjetos read FPCs;

    // Coeficientes de Contribuicao
    // Esta associado em ordem com os PCs
    property CCs : TDoubleList read FCCs;

    // Vazoes lidas do arquivo de vazoes afluentes
    // Soh estara disponivel apos o inicio de uma simulacao
    property Vazoes : TV read GetVazoes;
  end;

  TprQualidadeDaAgua = class(THidroComponente)
  private
    FCod: integer;
    procedure setColor(Code: integer);
  protected
    function getHint(): string; override;
    function ObterPrefixo(): string; override;
    function CriarDialogo(): TprDialogo_Base; override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    function CriarImagemDoComponente(): TdrBaseShape; override;
    function ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    destructor Destroy(); override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);
    property Codigo : integer read FCod write FCod;
  end;

  TprListaDePCs = class
  private
    FList : TprListaDeObjetos;
    function GetPC(Index: Integer): TprPC;
    function GetNumPCs: Integer;
    procedure SetPC(index: Integer; const Value: TprPC);
  public
    constructor Create();
    destructor Destroy(); override;

    function Adicionar(PC: TprPC): Integer;
    function Remover(PC: TprPC): boolean;
    function IndiceDo(PC: TprPC): Integer;

    // Calcula a hierarquia de cada PC contido nesta lista
    procedure CalcularHierarquia();

    // Ordena a lista de acordo com a hierarquia de cada PC
    procedure Ordenar();

    // Requisita que cada PC totalize suas demandas
    procedure TotalizarDemandas();

    // Numero de PCs contidos nesta lista
    property PCs: Integer read GetNumPCs;

    // Retorna ou estabelece um dos PCs contidos nesta lista
    property PC[index: Integer]: TprPC read GetPC write SetPC; default;
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

    // Indica se a instância, ao ser salva/lida deverá salvar/ler seu bitmap
    FSalvarLerBitmap: Boolean;

    // Indica se houve mudança de bitmap
    FBitmapMudou: Boolean;

    function GetBitmap: TBitmap;
    procedure SetBitmap(B: TBitmap);
    procedure BitmapChange(Sender: TObject);
  protected
    function getBitmapName: String; virtual;

    // Implemente este metodo para calcular o valor da demanda
    function getDemanda: Real; virtual;

    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
  public
    property Ligada      : Boolean           read FLigada write FLigada;
    property Prioridade  : TEnumPriorDemanda read FPrioridade;
    property Bitmap      : TBitmap           read GetBitmap write SetBitmap;
    property BitmapMudou : Boolean           read FBitmapMudou write FBitmapMudou;
    property Demanda     : Real              read getDemanda;
  end;

  TprClasseDemanda = class(THidroDemanda)
  private
    FED   : Real;
    FFC   : Real;
    FNUCD : String;
    FNUD  : String;
    FUD   : TaRecUD;
    FVU   : TaRecVU;
    FFI   : TaRecFI;
    FData : TRec_prData;
    FFR   : Real;
    FNFC  : Real;

    FSincronizaDados : Boolean;
    FSincVU          : Boolean;
    FSincUD          : Boolean;
    FSincFI          : Boolean;

    // Assunto: Equacoes
    // Indica se a demanda eh de decisao ou estado
    // Se setado na classe de demanda, todas as demendas pertencentes a classe
    // se tornarao o que for setado para a classe.
    FEQ_Decisao: boolean;

    // Obtem as unidades com base na data de simulacao
    function GetUC(): Real;
    function GetUD(): Real;
    function GetFI(): Real;

    function getUnidadeDeConsumo (Ano, Mes: Integer): Real;
    function getUnidadeDeDemanda (Ano, Mes: Integer): Real;
    function getFatorDeImplantacao (Ano, Mes: Integer): Real;

    function setUnidadeDeConsumo (Ano, Mes: Integer; Valor: real): Real;
    function setUnidadeDeDemanda (Ano, Mes: Integer; Valor: real): Real;
    function setFatorDeImplantacao (Ano, Mes: Integer; Valor: real): Real;

    procedure ErroTVU (const Rotina: string);
  protected
    // Cuidado: Esta implementacao depende da propriedade "data"
    function getDemanda: Real; override;

    procedure setVarDecisao(const Value: boolean); virtual;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); override;
    function  CriarImagemDoComponente(): TdrBaseShape;  override;
    function  CriarDialogo: TprDialogo_Base; override;
    function  ObterPrefixo: String; override;
    function  op_getValue(const PropName: string; i1, i2: Integer): real; override;
    procedure op_setValue(const PropName: string; i1, i2: Integer; const r: real); override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);

    // Gerenciamento da TVU (Tab. de Valores Unitários)
    procedure TVU_NumIntervalos(const NumIntervalos: Integer);
    procedure TVU_AnoInicialFinalIntervalo(const Ind_Intervalo, AnoInicial, AnoFinal: Integer);
    procedure TVU_Demanda(const Ind_Intervalo, Mes: Integer; const Demanda: Real);
    function  TVU_ObterNumIntervalos(): Integer;
    procedure TVU_ObterAnoInicialFinalIntervalo(const Ind_Intervalo: integer; out AnoInicial, AnoFinal: Integer);
    function  TVU_ObterDemanda(const Ind_Intervalo, Mes: Integer): real;
    procedure AssociarValoresUnitarios(Dados: TObject);

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

    // Sera acessado somente via Pascal Script
    property EQ_Eh_VarDecisao : boolean read FEQ_Decisao write setVarDecisao;
  end;

  TprDemanda = class(TprClasseDemanda)
  private
    FClasse      : String;
    FGrupos      : TStrings;
    FTipo        : TEnumTipoDemanda;
    FHabilitada  : Boolean;
    FTemp        : Real;
    FCenarios    : TObjectList;

    function  getCenario(i: integer): TprCenarioDeDemanda;
    function  getNumCenarios: integer;
    procedure SetVisivel(const Value: Boolean);
    function  Sincronizar(Dado: Integer; Dados: TStrings): Boolean;
    function  getVisivel: Boolean;
  protected
    destructor Destroy(); override;
    procedure setVarDecisao(const Value: boolean); override;
    function ObterPrefixo: String; Override;
    function CriarDialogo: TprDialogo_Base; Override;
    function CriarImagemDoComponente(): TdrBaseShape; override;
    function ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function GetBitmapName: String; override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    procedure PrepararParaSimulacao(); override;
    function  ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);

    // Copia os dados de uma classe de demanda
    procedure Copiar(Demanda: TprClasseDemanda;
                     Criando: Boolean;
                     Dados: TStrings);

    // Informa a qual classe esta demanda pertence
    // Aqui eh armazenado o "nome" do compoenente que representa
    // a classe de demanda.
    property Classe : String read FClasse;

    // !!! Ainda nao utilizado !!!
    // Serviria para classificar uma demanda
    property Grupos : TStrings read FGrupos;

    // Tipo da demanda: se localizada ou dispersa
    property Tipo : TEnumTipoDemanda read FTipo write FTipo;

    // Retorna se a demanda esta habilitada ou nao, isto eh,
    // se o PC/SB que a contem deve considera-la.
    property Habilitada : Boolean read FHabilitada;

    // Retorna se a demanda esta visualmente visivel ara a area de projeto.
    property Visivel : Boolean read getVisivel   write SetVisivel;

    // Retorna o numero de cenarios conectados
    property NumCenarios : integer read getNumCenarios;

    // Retorna um dos cenarios conectados
    property Cenario[i: integer] : TprCenarioDeDemanda read getCenario;

    // Utilizado temporariamente em alguns lugares quando lidando com
    // varias demandas ao mesmo tempo
    property ValorTemp : Real read FTemp write FTemp;
  end;

  TEventoDeMudanca = TNotifyEvent;

  TprListaDeClassesDemanda = class
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
    constructor Create();
    destructor Destroy(); Override;

    procedure ToXML();
    procedure fromXML(no: IXMLDomNode);

    procedure Adicionar(DM: TprClasseDemanda);
    procedure Editar(DM: TprClasseDemanda);
    function  Remover(DM: TprClasseDemanda): Boolean;

    procedure Limpar();
    function  ClassePeloNome(Const NomeClasse: String): TprClasseDemanda;

    property Classes         : Integer             read GetClasses;
    property EventoDeMudanca : TEventoDeMudanca    read FEM write FEM;
    property Projeto         : TprProjeto          read FProjeto write FProjeto;
    property TabelaDeNomes   : TStrings            read FTN write FTN;

    property Classe[indice: Integer]: TprClasseDemanda read getClasse; Default;
    property Bitmap[indice: Integer]: TBitmap          read getBitmap;
  end;

  // Representa um possivel cenario de demanda
  TprCenarioDeDemanda = Class(THidroComponente, ICenarioDemanda)
  private
    FFactoryName: string;
    FDI: ICenarioDemanda;
    FDemanda: TprDemanda;

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

    // ICenarioDemanda
    function icd_ObterValoresUnitarios(): TObject;
    function icd_ObterValorFloat(const Propriedade: string): real;
    function icd_ObterValorString(const Propriedade: string): string;
  protected
    function  ObterPrefixo(): string; override;
    function  CriarImagemDoComponente(): TdrBaseShape; override;
    function  CriarDialogo(): TprDialogo_Base; override;
    function  ReceiveMessage(const MSG: TadvMessage): Boolean; override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure getActions(Actions: TActionList); override;
  public
    constructor Create(const Pos: TMapPoint;
                       Projeto: TprProjeto;
                       TabelaDeNomes: TStrings;
                       FabricaDeCenario: IObjectFactory);

    destructor Destroy(); override;

    procedure AlimentarDemanda();
    function  ObterValorFloat(const Propriedade: string): real;
    function  ObterValorString(const Propriedade: string): string;

    // Referencia a demanda que possui este cenario
    property Demanda : TprDemanda read FDemanda write FDemanda;

    // Nome da fabrica de cenários
    property FactoryName : string read FFactoryName;
  end;

  TprDescarga = class(THidroComponente)
  private
    FCargaColiformios: real;
    FCargaDBOC: real;
    FConcentracaoDBOC: real;
    FConcentracaoDBON: real;
    FCargaDBON: real;
  protected
    function ObterPrefixo(): string; override;
    function CriarImagemDoComponente(): TdrBaseShape; override;
    function CriarDialogo(): TprDialogo_Base; override;
    function ReceiveMessage(const MSG: TadvMessage): Boolean; override;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); override;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    //procedure getActions(Actions: TActionList); override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);
    destructor Destroy(); override;

    property CargaDBOC        : real read FCargaDBOC        write FCargaDBOC;
    property CargaDBON        : real read FCargaDBON        write FCargaDBON;
    property CargaColiformios : real read FCargaColiformios write FCargaColiformios;
    property ConcentracaoDBOC : real read FConcentracaoDBOC write FConcentracaoDBOC;
    property ConcentracaoDBON : real read FConcentracaoDBON write FConcentracaoDBON;
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
    destructor Destroy(); override;

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
  TprListaDeFalhas = class
  private
    FFalhasPri: TStrings;
    FFalhasSec: TStrings;
    FFalhasTer: TStrings;
    FProjeto  : TprProjeto;

    function  PegaFalhas(Tipo: TEnumPriorDemanda): TStrings;
    function  getFalhaPri(i: Integer): TprFalha;
    function  getFalhaSec(i: Integer): TprFalha;
    function  getFalhaTer(i: Integer): TprFalha;
    function  getNumFalhasPri: Integer;
    function  getNumFalhasSec: Integer;
    function  getNumFalhasTer: Integer;
  public
    constructor Create(Projeto: TprProjeto);
    Destructor  Destroy(); override;

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
  TprListaDeIntervalos = Class
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
    constructor Create();
    destructor  Destroy(); override;

    procedure Adicionar(Ini, Fim: Integer; const Nome: String; Habilitado: Boolean);
    procedure Remover(indice: Integer);
    procedure Limpar();

    procedure toXML();
    procedure fromXML(no: IXMLDomNode);

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
  TProcPQA = procedure(Projeto: TprProjeto; QA: TprQualidadeDaAgua;  Lista: TList = nil);
  TProcPCN = procedure(Projeto: TprProjeto; CN: TprCenarioDeDemanda;  Lista: TList = nil);

  TStatusProjeto = (sFazendoNada, sSimulando, sOtimizando);

  TprProjeto = Class(THidroComponente, IEquationBuilder)
  private
    FProntoParaSimular  : Boolean; // Indica que na inicializacao da simulacao nao houve erros
    FExecutouSimulacao  : Boolean; // indica se pelo menos uma simulacao foi executada
    FIntervalosSim      : Integer;
    FArqFundo           : String;
    FDirSaida           : String;    // temporário para cada simulação (DOS)
    FClasDem            : TprListaDeClassesDemanda;
    FModificado         : Boolean;
    FNomeArquivo        : String;
    FTI                 : byte;
    FPCs                : TprListaDePCs;
    FAnos               : TaRecIntervalos;
    FIntSim             : TEnumIntSim;
    FNF                 : Real;    // Nível de Falha
    FArqVazoes          : String;  // Vazões afluentes de cada PC
    FArqDPS             : String;  // Demanda Primária Suprida
    FArqDSS             : String;  // Demanda secundária Suprida
    FArqDTS             : String;  // Demanda Terciária Suprida
    FArqAR              : String;  // Armazenamentos nos reservatórios
    FArqEG              : String;  // Energia Gerada em cada PC
    FDirSai             : String;
    FDirPes             : String;
    FIntervalo          : Integer;
    FInts               : TprListaDeIntervalos;
    FPropDOS            : String;
    FValorFO            : Real;
    FAreaDeProjeto      : TForm;
    FSimulador          : TSimulation;
    FTS                 : TEnumTipoSimulacao;
    FTotal_IntSim       : Integer; // Atualizado na leitura do projeto e após o diálogo
    FPlanejaUsuario     : String;
    FRotinaGeralUsuario : String;
    FOperaUsuario       : String;
    FEnergiaUsuario     : String;
    FPlanejaScript      : TPascalScript;
    FScriptGeral        : TPascalScript;
    FGlobalObjects      : TGlobalObjects;
    FEC                 : String;         // Execucao corrente
    FSC                 : TPascalScript;  // Script corrente
    FStatus             : TStatusProjeto;
    FSaveCaption        : String;
    FFileVersion        : integer;

    // Guarda as variaveis otimizadas apos uma otimizacao por um solver
    FVariaveis : Solver.Classes.TVariableList;

    FPermitirVazoesNegativasNasSubBacias: boolean;

    FEvento_InicioSimulacao : TNotifyEvent;
    FEvento_FimSimulacao    : TNotifyEvent; // Armazena o status de execução do projeto

    // Informa qual a acao do duplo-click que o IDE deve executar
    // 0 - Mostrar Dialogo   1 - Executar script padrao
    FAcaoDoDuploClickNosComponentes: integer;

    // Informa qual navegador o IDE devera utilizar para mostrar o HTML
    // 0 - Nav. Interno   1 - Nav. do SO
    FNavHTML: integer;

    // Palavras-Chaves: Equacao, Equacoes, Equation, Equations

    // Gerador de Equações
    FEQB: TEquationBuilder;

    FEquacoes_PreVisualizar    : Boolean;
    FEquacoes_NomeScriptGeral  : string;
    FEquacoes_IndiceGeral      : integer;

    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriarDialogo: TprDialogo_Base; Override;
    function  getTAIS: Integer;
    function  getTIS: Integer;
    function  getTMIS: Integer;
    function  getNumAnos: Integer;
    procedure EscreveAnosNoEditor(Book: TBook; Const Ident: String = '');
    procedure SetFundo(Value: String);

    // Mecanismo de Simulação
    procedure  ExecutarSimulacao; Virtual;
    procedure  AtualizaPontoExecucao(const EC: String; SCC: TPascalScript);

    // Métodos Interativos
    procedure Planeja();
    procedure ExecutarRotinaGeral();

    // Mecanismo de ligação do Propagar DOS
    function  GerarArquivoDeVazoes: String;
    function  GerarArquivoDeDemandasDifusas: String;
    function  GerarArquivoDeDemanda(Tipo: TEnumPriorDemanda): String;
    function  GerarArquivoDosReservatorios(const Tipo: String): String;
    procedure LeArquivosDoPropagarDOS;

    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function  op_getValue(const PropName: string; i1, i2: Integer): real; override;
    procedure op_setValue(const PropName: string; i1, i2: Integer; const r: real); override;

    // Assunto: Equacoes -----------------------------------------------------

    // IEquationBuilder
    procedure eb_Generate(Text: TStrings);
    procedure eb_Init(Text: TStrings);
    procedure eb_Finalize(Text: TStrings);

    // Chamado de dentro dos metodos de geracao
    //procedure ExecutarScriptComplementarDasEquacoes();

    // Gera equacoes totalmente atraves de script
    procedure GerarEquacoesPorScript(Text: TStrings);
    function getFilePath(): String;
  protected
    function getProjectType(): string; virtual;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
    procedure setBackgroundBitmap(Bitmap: TBitmap); virtual;

    procedure IniciarSimulacao(Evento: Simulation.TCallEvent);
    procedure FinalizarSimulacao();

    // Métodos da simulação.
    procedure TratarEventoDeProgressoDaSimulacao (Sender: TObject; out EventID: Integer);
    procedure TratarEventosDaSimulacao (Sender: TObject; const EventID: Integer);
  public
    constructor Create(TabelaDeNomes: TStrings);
    destructor  Destroy(); override;

    // Conversao de coordenadas
    function PointToMapPoint(p: TPoint): TMapPoint; virtual;
    function MapPointToPoint(p: TMapPoint): TPoint; virtual;

    // Cria um descendente de THidroComponente.
    // Este método deverá ser obrigatoriamente implementado pelos descendentes e deverá
    // fornecer pelo menos a possibilidade de criação de PCs, Reservatórios, Sub-Bacias,
    // Derivações e Demandas.
    // Os valores que "ID" poderá assumir são:
    //   "PC", "Reservatorio", "Sub-Bacia", "Derivacao", "Demanda" ou diretamante o nome
    //   das classes dos objetos, por exemplo, "Txx_PC", ""Txx_RES".
    // "Pos" é a posição na tela onde o objeto será criado.
    function CriarObjeto(const ID: String; Pos: TMapPoint): THidroComponente; virtual;

    // Verifica se o projeto ja foi salvo, isto é, (NomeArquivo <> '')
    // Se não foi salvo gera uma exceção.
    procedure VerificarSeSalvo();

    // Verifica pendencias iniciais antes do inicio de um projeto
    procedure VerificarPendencias(); virtual;

    // Lista de Objetos
    function ObtemDemandas(): TList;
    function ObtemSubBacias(): TList;
    function ObtemCenarios(): TList;
    function ObtemQAs(): TList;

    // Métodos de arquivo
    procedure SaveToXML(const Filename: String);
    procedure LoadFromXML(const Filename: String);

    // Métodos Iterativos
    procedure PercorreSubBacias(ITSB: TProcPSB; Lista: TList = nil);
    procedure PercorreDemandas(ITDM: TProcPDM; Lista: TList = nil);
    procedure PercorreCenarios(ITCN: TProcPCN; Lista: TList = nil);
    procedure PercorreQAs(ITQA: TProcPQA; Lista: TList = nil);

    // Métodos da simulação
    procedure ExecutarPropagarDOS(NomeArquivo: String = '');
    function  RealizarDiagnostico(Completo: Boolean = False): Boolean;
    procedure Executar();
    procedure TerminarSimulacao();

    // Métodos que mostram resultados ou dialogos
    procedure MostraMatrizDeContribuicao;
    procedure MostraFalhasNoAtendimentoDasDemandas;
    procedure MostrarIntervalos;

    // Verifica se existem Intervalos de Análise
    procedure VerificarIntervalosDeAnalise();

    {Realiza somente a validação dos dados (Erros Fatais)
     Regra: A variável TudoOk deverá ser inicializada em TRUE}
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;

    {O método a seguir tem por objetivo determinar um valor que sirva para avaliação da
     performance do sistema.}
    function CalcularFuncaoObjetivo(): Real;

    // Realiza o Balanço Hídrico até o PC determinado, incluíndo ele.
    // Os PCs deverão estar ordenados, isto é, respeitando as regras de hierarquia.
    // Se "AteOsReservatorios" for verdadeiro o Balanco Hidrico eh feito ate
    // os reservatorios, incluindo-os.
    procedure RealizarBalancoHidricoAte(PC: TprPCP; AteOsReservatorios: Boolean);

    // Retorna uma lista com as referencias a todos os PCs que estao a montante
    // de um determinado PC, inclusive ele. Os PCs deverão estar ordenados,
    // isto é, respeitando as regras de hierarquia.
    // Se "AteOsReservatorios" for verdadeiro é retornada a sub-rede que vai
    // ate os reservatorios, incluindo-os.
    function ObterSubRede(PC: TprPCP; AteOsReservatorios: Boolean): TStrings;

    // Métodos dos objetos da rede
    function CenarioPeloNome(const Nome: String): TprCenarioDeDemanda;
    function TrechoPeloNome(const Nome: String): TprTrechoDagua;
    function SubBaciaPeloNome(const Nome: String): TprSubBacia;
    function DemandaPeloNome(const Nome: String): TprDemanda;
    function PCPeloNome(const Nome: String): TprPCP;
    function PCsEntreDois(const NomePC1, NomePC2: String): TStrings;

    // Gera as equacoes do balanco hidrico para um determinado Delta T
    procedure Equacoes_GerarBalancoHidrico(Intervalo: integer);

    // Inicializa o mecanismo de geracao de equacoes
    procedure Equacoes_Iniciar();

    // Converte um intervalo de simulacao em uma data (mes e ano)
    function IntervaloParaData(Intervalo: integer): TRec_prData;

    // Mostra um HTML
    procedure ShowHTML(const URL: string);

    // Aplica os valores das variaveis otimizadas nos objetos da rede com base em um mapeamento.
    // Este mapeamento deve ser um arquivo texto CSV e seguir o formato abaixo:
    // NomeDaVariavel;NomeDoObjeto;NomeDaPropriedade
    procedure AplicarVariaveisNosObjetos(const ArquivoMapeamento: string);

    // Aplica valores nos objetos da rede com base em um mapeamento.
    // Este mapeamento deve ser um arquivo texto CSV e seguir o formato abaixo:
    // Valor;NomeDoObjeto;NomeDaPropriedade
    procedure AplicarValoresNosObjetos(const ArquivoMapeamento: string);

    // Retorna a versão do arquivo lido
    property FileVersion : integer read FFileVersion;

    property ExecutouSimulacao       : boolean              read FExecutouSimulacao;
    property TotalAnual_IntSim       : Integer              read getTAIS;
    property TotalMensal_IntSim      : Integer              read getTMIS;
    property Total_IntSim            : Integer              read FTotal_IntSim;
    property NumAnosDeExecucao       : Integer              read getNumAnos;
    property Intervalo               : Integer              read FIntervalo;
    property Intervalos              : TprListaDeIntervalos read FInts;
    property TipoSimulacao           : TEnumTipoSimulacao   read FTS;
    property GlobalObjects           : TGlobalObjects       read FGlobalObjects;

    // Permite ou nao valores negativos como vazao das sub-bacias
    // Se valores negativos nao forem aceitos eles serao convertidos para 0
    property PermitirVazoesNegativasNasSubBacias : boolean
        read FPermitirVazoesNegativasNasSubBacias
       write FPermitirVazoesNegativasNasSubBacias;

    property IntervaloDeSimulacao    : TEnumIntSim        read FIntSim    write FIntSim;
    property AnosDeExecucao          : TaRecIntervalos    read FAnos      write FAnos;
    property ArqVazoes               : String             read FArqVazoes write FArqVazoes;
    property ArqDPS                  : String             read FArqDPS    write FArqDPS;
    property ArqDSS                  : String             read FArqDSS    write FArqDSS;
    property ArqDTS                  : String             read FArqDTS    write FArqDTS;
    property ArqAR                   : String             read FArqAR     write FArqAR;
    property ArqEG                   : String             read FArqEG     write FArqEG;
    property DirSai                  : String             read FDirSai    write FDirSai;
    property DirPes                  : String             read FDirPes    write FDirPes;
    property PCs                     : TprListaDePCs      read FPCs       write FPCs;
    property TipoImpressao           : byte               read FTI        write FTI;
    property NivelDeFalha            : Real               read FNF        write FNF;
    property PropDOS                 : String             read FPropDOS   write FPropDOS;
    property ValorFO                 : Real               read FValorFO   write FValorFO;

    property ClassesDeDemanda   : TprListaDeClassesDemanda read FClasDem;
    property CaminhoArquivo     : String                   read getFilePath;
    property NomeArquivo        : String                   read FNomeArquivo   write FNomeArquivo;
    property Modificado         : Boolean                  read FModificado    write FModificado;
    property ArqFundo           : String                   read FArqFundo      write SetFundo;
    property AreaDeProjeto      : TForm                    read FAreaDeProjeto write FAreaDeProjeto;

    property Simulador          : TSimulation     read FSimulador;
    property Status             : TStatusProjeto  read FStatus;

    // Guarda as variaveis otimizadas apos uma otimizacao por um solver
    property Variaveis : Solver.Classes.TVariableList read FVariaveis;

    // Informa qual a acao do duplo-click que o IDE deve executar
    // 0 - Mostrar Dialogo   1 - Executar script padrao
    property AcaoDoDuploClickNosComponentes: integer read FAcaoDoDuploClickNosComponentes;

    // Informa qual navegador o IDE devera utilizar para mostrar o HTML
    // 0 - Nav. Interno   1 - Nav. do SO
    property NavHTML: integer read FNavHTML;

    // Gerador de Equações
    property EquationBuilder : TEquationBuilder read FEQB;

    property Equacoes_PreVisualizar : Boolean read  FEquacoes_PreVisualizar
                                              write FEquacoes_PreVisualizar;

    property Equacoes_NomeScriptGeral : string read  FEquacoes_NomeScriptGeral
                                               write FEquacoes_NomeScriptGeral;

    // Para Debug
    property ScriptCorrente     : TPascalScript  read FSC write FSC;
    property ExecucaoCorrente   : String         read FEC write FEC;

    // eventos
    property Evento_InicioSimulacao  : TNotifyEvent read  FEvento_InicioSimulacao
                                                    write FEvento_InicioSimulacao;

    property Evento_FimSimulacao     : TNotifyEvent read  FEvento_FimSimulacao
                                                    write FEvento_FimSimulacao;
  end;

  // Classe passível de ser otimizada
  TprProjetoOtimizavel = Class(TprProjeto, IOptimizable)
  private
    // Otimizador
    FOptimizer : TOptimizer;

    FCaption : String; // auxiliar temporário

    FOpt_NomeRotIni : String;
    FOpt_NomeRotFim : String;
    FOpt_NomeRotFO  : String;

    FOpt_Script_Ini : TPascalScript;
    FOpt_Script_Fim : TPascalScript;
    FOpt_Script_FO  : TPascalScript;

    FIndSim : integer; // Indice da simulacao

    procedure ExecutarRotinaDeInicializacao;
    procedure ExecutarRotinaDeFinalizacao;

    // métodos do mecanismo de simulação adaptados para otimização
    procedure ExecutarSimulacao; override;

    function ReceiveMessage(Const MSG: TadvMessage): Boolean; override;

    // Edição e validação dos dados
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function  CriarDialogo: TprDialogo_Base; Override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Override;

    function getRosenOpt(): TRosenbrock;
    function getGeneticOpt(): TGeneticOptimizer;

    // IOptimizable interface
    procedure o_setOptimizer(obj: TObject);
    procedure o_ProcessMessage(MessageID: integer);
    procedure o_beginOptimization();
    procedure o_endOptimization();
    procedure o_CalculateObjetiveFunctions();
  protected
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
  public
    procedure TerminarOtimizacao;

    property IndiceSimulacao : integer read FIndSim;

    // Otimizadores -----------------------------------------------------------

    // Para ser acessado somente via PascalScript
    property Optimizer : TOptimizer read FOptimizer;

    // Somente um estara ativo por vez enquanto a otimizacao estiver ocorrendo
    property RosenbrockOptimizer : TRosenbrock       read getRosenOpt;
    property GeneticOptimizer    : TGeneticOptimizer read getGeneticOpt;
  end;

  TprProjeto_ScrollCanvas = class(TprProjetoOtimizavel)
  private
    FBmp: TBitmap;
  protected
    function getProjectType(): string; override;
    procedure setBackgroundBitmap(Bitmap: TBitmap); override;
  public
    function PointToMapPoint(p: TPoint): TMapPoint; override;
    function MapPointToPoint(p: TMapPoint): TPoint; override;

    // Background image
    property Bmp : TBitmap read FBmp;
  end;

  TprProjeto_ZoomPanel = class(TprProjetoOtimizavel)
  protected
    function getProjectType(): string; override;
    procedure VerificarPendencias(); override;
    procedure setBackgroundBitmap(Bitmap: TBitmap); override;
  public
    function PointToMapPoint(p: TPoint): TMapPoint; override;
    function MapPointToPoint(p: TMapPoint): TPoint; override;
  end;

  // Gera uma excessão de método não implementado
  procedure NaoImplementado(const Metodo, Classe: String);

  // Converte um intervalo (Delta T) para uma data do propagar (mes/ano) em string
  Function IntervaloParaDataComoString(Projeto: TprProjeto; Intervalo: Integer): String;

  // Retorna os intervalos entre as datas iniciais e finais inclusive
  Function IntervalosDo(p: TprProjeto; di, df: TDate): TIntegerList;

implementation
uses Dialogs,
     pr_Funcoes,
     ImgList,
     pr_Util,
     FileCTRL,
     Math,
     DateUtils,
     OutPut,
     XML_Utils_Graphics,
     pr_Application,
     pr_Vars,
     Execfile,
     wsVec,
     WinUtils,
     FileUtils,
     Rochedo.PanZoom,
     HTML_Viewer,
     ShellAPI,
     pr_Gerenciador,
     pr_Dialogo_FalhasDeUmPC,
     pr_Dialogo_PlanilhaBase,
     Planilha_DadosDosObjetos,
     pr_Dialogo_Grafico_PCs_XTudo,
     pr_Dialogo_Grafico_PCsRes_XTudo,
     pr_Dialogo_Intervalos,
     pr_Dialogo_MatContrib,
     pr_Dialogo_Planilha_FalhasDasDemandas,
     pr_Form_AreaDeProjeto_Base;

// Realiza um type-casting, só isso
Function AP(F: TForm): TfoAreaDeProjeto_Base;
begin
  Result := TfoAreaDeProjeto_Base(F);
end;

// Gera uma excessão de método não implementado
procedure NaoImplementado(const Metodo, Classe: String);
begin
  raise Exception.CreateFmt(cMsgErro07, [Metodo, Classe]);
end;

Function IntervaloParaDataComoString(Projeto: TprProjeto; Intervalo: Integer): String;
var d: TRec_prData;
begin
  d := Projeto.IntervaloParaData(Intervalo);
  Result := Format('%2d/%4d', [d.Mes, d.Ano]);
end;

Function IntervalosDo(p: TprProjeto; di, df: TDate): TIntegerList;
var daux: TDate;
    i: Integer;
    d: TRec_prData;
begin
  Result := TIntegerList.Create();
  for i := 1 to p.Total_IntSim do
    begin
    d := p.IntervaloParaData(i);
    daux := EncodeDate(d.Ano, d.Mes, 01);
    if (dAux >= di) and (daux < df) then Result.Add(i);
    end;
end;

{ TprListaDeObjetos }

function TprListaDeObjetos.Adicionar(Objeto: THidroComponente): Integer;
begin
  Result := FList.Add(Objeto);
end;

constructor TprListaDeObjetos.Create();
begin
  Inherited Create();
  FList := TList.Create();
end;

procedure TprListaDeObjetos.Deletar(Indice: Integer);
begin
  FList.Delete(Indice);
end;

destructor TprListaDeObjetos.Destroy;
var i: Integer;
begin
  if FLiberarObjetos then
     for i := 0 to FList.Count-1 do THidroComponente(FList[i]).Free;

  FList.Free;
  Inherited Destroy;
end;

function TprListaDeObjetos.getNumObjetos: Integer;
begin
  Result := FList.Count;
end;

function TprListaDeObjetos.getObjeto(index: Integer): THidroComponente;
begin
  Result := THidroComponente(FList[index]);
end;

function TprListaDeObjetos.IndiceDo(Objeto: THidroComponente): Integer;
begin
  Result := FList.IndexOf(Objeto);
end;

procedure TprListaDeObjetos.Ordenar(FuncaoDeComparacao: TListSortCompare);
begin
  FList.Sort(FuncaoDeComparacao);
end;

function TprListaDeObjetos.Remover(Objeto: THidroComponente): Integer;
begin
  Result := FList.Remove(Objeto);
end;

procedure TprListaDeObjetos.RemoverNulos;
begin
  FList.Pack;
end;

procedure TprListaDeObjetos.setObjeto(index: Integer; const Value: THidroComponente);
begin
  if FList.Count > 0 then
     FList[index] := Value;
end;

{ TprListaDePCs }

constructor TprListaDePCs.Create();
begin
  Inherited Create();
  FList := TprListaDeObjetos.Create();
end;

destructor TprListaDePCs.Destroy;
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

function TprListaDePCs.Adicionar(PC: TprPC): Integer;
begin
  PC.Modificado := True;
  Result := FList.Adicionar(PC);
end;

function TprListaDePCs.Remover(PC: TprPC): boolean;
var PS  : TprPC; // PC seguinte
    i   : Integer;
begin
  Result := False;

  if (PC.SubBacias > 0) or (PC.Demandas > 0) then
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
     PC.DesconectarObjetos();
     PC.Free();
     CalcularHierarquia();
     Result := True;
     end;
end;

function TprListaDePCs.GetNumPCs(): Integer;
begin
  Result := FList.Objetos;
end;

function TprListaDePCs.GetPC(Index: Integer): TprPC;
begin
  try
    Result := TprPC(FList[Index]);
  except
    Raise Exception.Create('Índice de PC inválido: ' + IntToStr(Index));
  end;
end;

procedure TprListaDePCs.CalcularHierarquia();
var i, k: Integer;
    PC: TprPC;
begin
  // Inicia as hierarquias
  for i := 0 to PCs-1 do
    getPC(i).Hierarquia := 1;

  // Calcula as novas hierarquias
  for i := 0 to PCs-1 do
    if getPC(i).PCs_aMontante = 0 then
       begin
       k := 1;
       PC := getPC(i);
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
  Result := TprPC(pc1).Hierarquia - TprPC(pc2).Hierarquia;
end;

procedure TprListaDePCs.Ordenar;
begin
  FList.Ordenar(FuncaoDeComparacao);
end;

function TprListaDePCs.IndiceDo(PC: TprPC): Integer;
begin
  Result := FList.IndiceDo(PC);
end;

procedure TprListaDePCs.SetPC(index: Integer; const Value: TprPC);
begin
  try
    FList[Index] := Value;
  except
    Raise Exception.Create('Índice de PC inválido: ' + IntToStr(Index));
  end;
end;

// Totaliza as demnadas de cada PC
procedure TprListaDePCs.TotalizarDemandas();
var i: Integer;
begin
  for i := 0 to GetNumPCs-1 do
    TprPCP(GetPC(i)).TotalizarDemandas();
end;

{ THidroComponente }

constructor THidroComponente.Create(TabelaDeNomes: TStrings; Projeto: TprProjeto);
begin
  inherited Create;

  FAvisarQueVaiSeDestruir := True;

  FProjeto      := Projeto;
  FTN           := TabelaDeNomes;
  FNome         := CriarNome();
  FComentarios  := TXML_StringList.Create();
  FScripts      := TStringList.Create;

  if not (self is TprProjeto) then
     FEventoDeMonitoracao := AP(Projeto.AreaDeProjeto).Monitor.Monitorar;

  GetMessageManager.RegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.RegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_INICIAR_SIMULACAO, self);
  GetMessageManager.RegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.RegisterMessage(UM_BLOQUEAR_OBJETOS, self);

  if FTN <> nil then FTN.AddObject(FNome, self);
  AtualizarHint();
end;

destructor THidroComponente.Destroy();
var i: Integer;
begin
  FComentarios.Free();
  FScripts.Free();

  GetMessageManager.UnRegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.UnRegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.UnRegisterMessage(UM_INICIAR_SIMULACAO, self);
  GetMessageManager.UnRegisterMessage(UM_BLOQUEAR_OBJETOS, self);

  i := FTN.IndexOf(FNome);
  if i > -1 then FTN.Delete(i);
  
  FImagemDoComponente.Free();
  Inherited Destroy;
end;

{
A rotina abaixo está completa, mas faz mais do que o necessário. Ela calcula
o enégimo período, que para o cálculo dos dias do último período não há
necessidade. A única coisa necessária é saber se estamos ou não no último.
}
function THidroComponente.DiasNoIntervalo(Intervalo: integer): Integer;

  const NumDiasNornais: Array[isQuinquendial..isQuinzenal] of byte = ( 5,  7, 10, 15);
        UDPI          : Array[isQuinquendial..isQuinzenal] of byte = (25, 21, 20, 15);

  var N         : byte;
      D         : TRec_prData;
      DiasNoMes : byte;

begin
  D := FProjeto.IntervaloParaData(Intervalo);
  DiasNoMes := DateUtils.DaysInAMonth(D.Ano, D.Mes);

  // Obtém o número de períodos de um mês
  N := caNumIntSimMes[FProjeto.IntervaloDeSimulacao];

  // Obtém o enégimo período do mês corrente
  case FProjeto.IntervaloDeSimulacao of
    isQuinquendial, isSemanal, isDecendial:
      if Intervalo mod N = 0 then
         Result := N
      else
         Result := Intervalo - (Intervalo div N * N);

    isQuinzenal:
      if Intervalo mod N = 0 then Result := N else Result := 1;

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

procedure THidroComponente.Monitorar();
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

function THidroComponente.op_getValue(const PropName: string; i1, i2: Integer): real;
begin
  // se chegou a este nível então é porque não encontrou a propriedade
  OptimizerError(PropName, ClassName);
end;

procedure THidroComponente.op_setValue(const PropName: string; i1, i2: Integer; const r: real);
begin
  // se chegou a este nível então é porque não encontrou a propriedade
  OptimizerError(PropName, ClassName);
end;

function THidroComponente.ReceiveMessage(const MSG: TadvMessage): Boolean;
var s: String;
begin
  if MSG.ID = UM_RESET_VISIT then
     Visitado := False
  else

  if MSG.ID = UM_BLOQUEAR_OBJETOS then
     begin
     if (MSG.ParamAsObject(1) = self.Projeto) then
        FBloqueado := Boolean(MSG.ParamAsInteger(0));
     end else

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
          PrepararParaSimulacao();
       end
    else
end;

function THidroComponente.Editar(): Integer;
var i: Integer;
begin
  if FProjeto.Simulador <> nil then Exit;

  Result := mrNone;
  FDialogo := CriarDialogo();
  FDialogo.Objeto := Self;

  i := FTN.IndexOf(FNome);
  if i <> -1 then FTN.Delete(i);
  Try
    PorDadosNoDialogo(FDialogo);
    FDialogo.Bloqueado := FBloqueado;
    FDialogo.Hide();
    Result := FDialogo.ShowModal();
    if (Result = mrOk) and (not FBloqueado) then
       begin
       SetModificado(True);
       PegarDadosDoDialogo(FDialogo);
       AtualizarHint();
       end;
  Finally
    if i <> -1 then FTN.AddObject(FNome, self);
    FDialogo.Free();
    FDialogo := nil;
  End;
end;

procedure THidroComponente.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  // Dados Gerais
  d.edNome.Text       := FNome;
  d.edDescricao.Text  := FDescricao;
  d.mComentarios.Text := FComentarios.Text;

  // Scripts
  d.lbScripts.Items.Assign(FScripts);
  d.DefaultScript := FDefaultScript;
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

  // Scripts
  FScripts.Assign(d.lbScripts.Items);
  FDefaultScript := d.DefaultScript;
end;

procedure THidroComponente.DuploClick(Sender: TObject);
var s: string;
begin
  FProjeto.VerificarSeSalvo();

  if Projeto.AcaoDoDuploClickNosComponentes = 0 then
     Editar()
  else
     if FDefaultScript <> -1 then
        begin
        s := FScripts[FDefaultScript];
        Projeto.VerificaCaminho(s);
        ExecuteScript(s);
        end
     else
        begin
        MessageDLG('Script padrão não definido !', mtWarning, [mbOk], 0);
        Editar();
        end;
end;

function THidroComponente.ObterNomeDaSecao: String;
begin
  Result := 'Dados ' + FNome;
end;

procedure THidroComponente.SetNome(const Value: String);
var i: Integer;
begin
  if (Value <> '') and (CompareText(Value, FNome) <> 0) then
     begin
     i := FTN.IndexOf(FNome);
     if i > -1 then FTN.Delete(i);
     FNome := Value;
     FTN.AddObject(FNome, self);
     end;
end;

function THidroComponente.CriarDialogo(): TprDialogo_Base;
begin
  Result := TprDialogo_Base.Create(nil);
  Result.TN := FTN;
end;

function THidroComponente.CriarNome(): String;
var i: Integer;
    Prefixo: String;
begin
  if FTN <> nil then
     begin
     i := 0;
     Prefixo := ObterPrefixo();
     repeat
       inc(i);
       Result := Prefixo + IntToStr(i);
       until FTN.IndexOf(Result) = -1
     end;
end;

function THidroComponente.ObterPrefixo: String;
begin
  Result := 'Proj_';
end;

procedure THidroComponente.Diagnostico(var TudoOk: Boolean; Completo: Boolean = False);
begin
  ValidarDados(TudoOk, gErros, Completo);
end;

procedure THidroComponente.ValidarDados(var TudoOk: Boolean;
                                        DialogoDeErros: TfoMessages;
                                        Completo: Boolean = False);
begin
  // Nada por enquanto
end;

procedure THidroComponente.CriarComponenteVisual(AreaDeProjeto: TObject; const Pos: TMapPoint);
var ap: TfoAreaDeProjeto_Base;
begin
  ap := TfoAreaDeProjeto_Base(AreaDeProjeto);

  FImagemDoComponente := CriarImagemDoComponente();
  if FImagemDoComponente <> nil then
     begin
     FImagemDoComponente.Tag         := Integer(self);
     FImagemDoComponente.Parent      := ap.ControleDaAreaDeDesenho();
     FImagemDoComponente.OnMouseDown := ap.Mouse_Down;
     FImagemDoComponente.OnMouseMove := ap.Mouse_Move;
     FImagemDoComponente.OnMouseUp   := ap.Mouse_Up;
     FImagemDoComponente.OnClick     := ap.Mouse_Click;
     FImagemDoComponente.OnDblClick  := self.DuploClick;
     if Pos.X > -99 then setPos(Pos);
     end
  else
     NaoImplementado('CriarImagemDoComponente', ClassName);
end;

function THidroComponente.getScreenArea(): TRect;
begin
  if FImagemDoComponente <> nil then
     with FImagemDoComponente do
        Result := Classes.Rect(Left, Top, Left + Width, Top + Height)
  else
     Result := Classes.Rect(0, 0, 0, 0);
end;

procedure THidroComponente.setPos(const Value: TMapPoint);
var p: TPoint;
begin
  if (FImagemDoComponente <> nil) and
     ( (Value.x <> FPos.x) or (Value.y <> FPos.y) ) then
     begin
     SetModificado(True);
     FPos := Value;

     p := getScreenPos();
     FImagemDoComponente.SetBounds(
       p.X - FImagemDoComponente.Width  div 2,
       p.Y - FImagemDoComponente.Height div 2,
       FImagemDoComponente.Width,
       FImagemDoComponente.Height);
     end;
end;

procedure THidroComponente.AtualizarHint();
var s: String;
begin
  if FImagemDoComponente <> nil then
     begin
     s := FNome;
     if alltrim(FDescricao) <> '' then s := s + ': ' + FDescricao;

     if getHint() <> '' then
        s := s + System.sLineBreak + getHint();

     if (FComentarios.Count > 0) and (FComentarios[FComentarios.Count-1] = '') then
        FComentarios.Delete(FComentarios.Count-1);

     if FComentarios.Count > 0 then
        s := s + System.sLineBreak + FComentarios.Text;

     if LastChar(s) in [#13, #10] then System.Delete(s, Length(s)-1, 2);
     FImagemDoComponente.Hint := s;
     end;
end;

procedure THidroComponente.PrepararParaSimulacao;
begin
  //nada
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
    //FProjeto.Intervalo := i;
    x := FProjeto.IntervaloParaData(i);
    d.Tab.TextRC[i+1, 1] := Format('   %2d/%d (%d)', [x.Mes, x.Ano, i]);
    end;

  StartWait();
  try
    ColocarDadosNaPlanilha(d);
  finally
    StopWait();
  end;
end;

// Cria uma janela default e faz as primeiras inicializações
function THidroComponente.CriarGrafico_Default(const Titulo: String; Intervalo: Integer): TfoChart;
begin
  FProjeto.VerificarIntervalosDeAnalise();

  Result := TfoChart.Create();
  Result.FormStyle := fsMDIChild;
  Result.Chart.Title.Text.Add(Titulo);

  if FProjeto.Intervalos.Nome[Intervalo] <> '' then
     Result.Chart.Title.Text.Add(FProjeto.Intervalos.Nome[Intervalo]);

  Result.Caption := Format(' Project %s - [%s a %s]',
     [FProjeto.Nome,
      FProjeto.Intervalos.sDataIni[Intervalo],
      FProjeto.Intervalos.sDataFim[Intervalo]]);
end;

procedure THidroComponente.DefinirEixoX_Default(Serie: TChartSeries; Intervalo: Integer);
var i, k: integer;
begin
  k := FProjeto.Intervalos.IntIni[Intervalo];
  for i := 0 to FProjeto.Intervalos.IntFim[Intervalo] - k do
    if i < Serie.Labels.Count then
       Serie.XLabel[i] := IntervaloParaDataComoString(FProjeto, k + i) +
                          ' (' + ToString(k + i) + ')';
end;

function THidroComponente.ObterDataSet(Dados: TV): TwsDataSet;
var i, j, k, ii: integer;
    v: TV;
begin
  // Criação da estrutura do Conjunto de dados: Anos X Intervalos Anuais
  ii := FProjeto.TotalAnual_IntSim;
  Result := TwsDataSet.Create('DS_' + Nome);
  for i := 1 to ii do
    Result.Struct.AddNumeric('_'+ intToStr(i) +'_', '');

  // Preenchimento do Conjunto
  k := 1;
  for i := 1 to FProjeto.NumAnosDeExecucao do
    begin
    //FProjeto.Intervalo := k;
    v := TV.Create(ii);
    v.Name := intToStr(FProjeto.IntervaloParaData(k).Ano);
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

function THidroComponente.VerificaCaminho(var Arquivo: String): Boolean;
begin
  if Arquivo <> '' then
     begin
     if not PossuiCaminho(Arquivo) then
        begin
        if FProjeto.DirPes <> '' then
           SetCurrentDir(FProjeto.DirPes)
        else
           SetCurrentDir(FProjeto.CaminhoArquivo);

        Arquivo := ExpandFileName(Arquivo);
        end;

     Result := FileExists(Arquivo);
     end
  else
     Result := False;
end;

procedure THidroComponente.RetiraCaminhoSePuder(var Arquivo: String);
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

procedure THidroComponente.VerificaRotinaUsuario(Arquivo: String; const Texto: String;
                                         Completo: Boolean; var TudoOk: Boolean;
                                         DialogoDeErros: TfoMessages);
var PS: TPascalScript;
begin
  if Arquivo <> '' then
     if not VerificaCaminho(Arquivo) then
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13 + 'Arquivo da rotina do Usuário (%s) não encontrado:'#13 +
               '%s', [self.Nome, Texto, Arquivo]));
        TudoOk := False;
        end
     else
        if Completo then
           begin
           PS := TPascalScript.Create();
           PS.Code.LoadFromFile(Arquivo);

           // bibliotecas
           PS.AssignLib(g_psLib);

           // Variáveis pré-inicializadas
           PS.Variables.AddVar(
             TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True));

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
  if Script = nil then Script := TPascalScript.Create();
  VerificaCaminho(Arquivo);
  with Script do
    begin
    // Bibliotecas
    AssignLib(g_psLib);

    // Objetos Globais
    GlobalObjects := Projeto.GlobalObjects;

    // Codigo
    Code.LoadFromFile(Arquivo);

    // Opções
    GerCODE  := True;
    Optimize := True;

    // Variaveis pre-inicializadas
    Variables.AddVar(
      TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True));
    end;
end;

// Assunto: equacoes
function THidroComponente.io_getOwnerName: string;
begin
  Result := FNome;
end;

function THidroComponente.io_getValue(const FieldName: string): string;
begin
  Result := 'C_' + FieldName;
end;

procedure THidroComponente.MostrarErro(const Erro: String);
begin
  MessageDLG(Erro, mtError, [mbOk], 0);
  FProjeto.FProntoParaSimular := false;
end;

function THidroComponente.ObjetoPeloNome(const Nome: String): TObject;
var i: Integer;
begin
  i := FTN.IndexOf(Nome);
  if i <> -1 then
     Result := FTN.Objects[i]
  else
     Result := nil;
end;

procedure THidroComponente.ToXML(); // static
var x: TXML_Writer;
    p: TPoint;
    Factory: string;
begin
  Applic.ActiveObject := self;
  x := Applic.getXMLWriter();

  if self is TprCenarioDeDemanda then
     Factory := (self as TprCenarioDeDemanda).FactoryName
  else
     Factory := '';

  p := getScreenPos();

  x.BeginIdent();
  x.beginTag('object', ['class', 'name', 'sx', 'sy', 'Factory', 'rx', 'ry'],
                       [ClassName, Nome, p.X, p.Y, Factory, FPos.X, FPos.Y]);
    x.BeginIdent();
    internalToXML(); // virtual
    x.EndIdent();
  x.endTag('object');
  x.EndIdent();
end;

procedure THidroComponente.internalToXML(); // virtual
var x: TXML_Writer;
    i: integer;
begin
  x := Applic.getXMLWriter();

  x.Write('description', FDescricao);
  FComentarios.ToXML('comments', x.Buffer, x.IdentSize);

  x.beginTag('scripts');
    x.beginIdent();
    for i := 0 to FScripts.Count-1 do x.Write('script', FScripts[i]);
    x.endIdent();
  x.endTag('scripts');
  x.Write('DefaultScript', FDefaultScript);
end;

procedure THidroComponente.fromXML(no: IXMLDomNode); // virtual
var i: Integer;
    n: IXMLDomNode;
begin
  Applic.ActiveObject := self;

  setNome(no.attributes.item[1].text);
  FDescricao := firstChild(no).text;
  FComentarios.FromXML(nextChild(no));

  if Projeto.FileVersion >= 3 then
     begin
     n := nextChild(no);
     FScripts.Clear();
     for i := 0 to n.childNodes.length-1 do
       FScripts.Add(n.childNodes.item[i].text);
     end;

  if Projeto.FileVersion >= 4 then
     FDefaultScript := toInt(nextChild(no).Text);
end;

function THidroComponente.firstChild(no: IXMLDomNode): IXMLDomNode;
begin
  FNodeIndex := 0;
  if no.hasChildNodes then
     result := no.childNodes.item[FNodeIndex]
  else
     result := nil;
end;

function THidroComponente.nextChild(no: IXMLDomNode): IXMLDomNode;
begin
  inc(FNodeIndex);
  if (no.hasChildNodes) and (FNodeIndex < no.childNodes.length) then
     result := no.childNodes.item[FNodeIndex]
  else
     result := nil;
end;

function THidroComponente.GetScreenPos(): TPoint;
var c: TPoint;
begin
  Result := FProjeto.MapPointToPoint(FPos);
  if Imagem <> nil then
     begin
     c := Imagem.Center;
     if (Result.X <> c.X) or ((Result.Y <> c.Y)) then
        Imagem.Center := Result;
     end;
end;

procedure THidroComponente.EditEvent(Sender: TObject);
begin
  Editar();
end;

procedure THidroComponente.ExecuteScriptEvent(Sender: TObject);
var s: String;
    i: integer;
begin
  // Obtem o nome do arquivo do script pelo indice passado no caption do Menu "(n) xxx"
  s := TMenuItem(Sender).Caption;
  i := toInt(SubString(s, '(', ')'));
  s := FScripts[i-1];
  Projeto.VerificaCaminho(s);
  ExecuteScript(s);
end;

procedure THidroComponente.getActions(Actions: TActionList);
var act: TAction;
    i: integer;
    s: string;
begin
  CreateAction(Actions, nil, 'Editar ...', false, EditEvent, self);
  CreateAction(Actions, nil, '-', false, nil, self);
  if FScripts.Count > 0 then
     begin
     act := CreateAction(Actions, nil, 'Scripts', false, nil, self);
     for i := 0 to FScripts.Count - 1 do
        begin
        s := ChangeFileExt(ExtractFilename(FScripts[i]), '');
        CreateAction(Actions, act, '(' + intToStr(i+1) + ')  ' + s, false, ExecuteScriptEvent, self);
        end;
     end;
end;

function THidroComponente.getHint(): string;
begin
  result := '';
end;

procedure THidroComponente.ExecuteScript(const Filename: string);
var v1: TVariable;
    v2: TVariable;
    x: TPascalScript;
begin
  v1 := TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True);
  v2 := TVariable.Create('Obj', pvtObject, Integer(self), self.ClassType, True);
  x := TPascalScript.Create();
  try
    x.Code.LoadFromFile(Filename);
    x.Variables.AddVar(v1);
    x.Variables.AddVar(v2);
    x.GlobalObjects := Projeto.GlobalObjects;
    x.AssignLib(g_psLib);
    if x.Compile() then
       x.Execute()
    else
       Dialogs.ShowMessage(x.Errors.Text);
  finally
    x.Free();
  end;
end;

{ TprTrechoDagua }

constructor TprTrechoDagua.Create(PC1, PC2: TprPC;
                                  TabelaDeNomes: TStrings;
                                  Projeto: TprProjeto);
begin
  inherited Create(TabelaDeNomes, Projeto);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);
  PC_aMontante := PC1;
  PC_aJusante  := PC2;
end;

function TprTrechoDagua.CriarDialogo(): TprDialogo_Base;
begin
  Result := TprDialogo_TD.Create(nil);
  Result.TN := FTN;
end;

destructor TprTrechoDagua.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);
  inherited Destroy;
end;

procedure TprTrechoDagua.fromXML(no: IXMLDomNode);
begin
  inherited fromXML(no);
  FVazaoMinima := strToFloat(nextChild(no).text);
  FVazaoMaxima := strToFloat(nextChild(no).text);

  if Projeto.FileVersion >= 2 then
     begin
     FComprimento         := strToFloat(nextChild(no).text);
     FAreaSecaoMedia      := strToFloat(nextChild(no).text);
     FPerimSecaoMedia     := strToFloat(nextChild(no).text);
     FLargBocaSecaoMedia  := strToFloat(nextChild(no).text);
     FRaioHidrologico     := strToFloat(nextChild(no).text);
     FCoefManning         := strToFloat(nextChild(no).text);
     FDeclividade         := strToFloat(nextChild(no).text);
     end;
end;

function TprTrechoDagua.getVelocidade(): real;
begin
  if FCoefManning <> 0 then
     result := Power(FRaioHidrologico, 0.66666666666) *
               Power(FDeclividade, 0.5) /
               FCoefManning
  else
     result := 0;
end;

procedure TprTrechoDagua.internalToXML();
var x: TXML_Writer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('minOutlet'         , FVazaoMinima);
  x.Write('maxOutlet'         , FVazaoMaxima);
  x.Write('Comprimento'       , FComprimento);
  x.Write('AreaSecaoMedia'    , FAreaSecaoMedia);
  x.Write('PerimSecaoMedia'   , FPerimSecaoMedia);
  x.Write('LargBocaSecaoMedia', FLargBocaSecaoMedia);
  x.Write('RaioHidrologico'   , FRaioHidrologico);
  x.Write('CoefManning'       , FCoefManning);
  x.Write('Declividade'       , FDeclividade);
end;

function TprTrechoDagua.ObterPrefixo: String;
begin
  Result := 'TrechoDagua_';
end;

procedure TprTrechoDagua.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_TD) do
    begin
    FVazaoMinima        := edVazMin.AsFloat ;
    FVazaoMaxima        := edVazMax.AsFloat ;
    FComprimento        := edC.AsFloat      ;
    FAreaSecaoMedia     := edASM.AsFloat    ;
    FPerimSecaoMedia    := edPSM.AsFloat    ;
    FLargBocaSecaoMedia := edLBSM.AsFloat   ;
    FRaioHidrologico    := edRH.AsFloat     ;
    FCoefManning        := edCM.AsFloat     ;
    FDeclividade        := edD.AsFloat      ;
    end;
end;

procedure TprTrechoDagua.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_TD) do
    begin
    edVazMin.AsFloat := FVazaoMinima        ;
    edVazMax.AsFloat := FVazaoMaxima        ;
    edC.AsFloat      := FComprimento        ;
    edASM.AsFloat    := FAreaSecaoMedia     ;
    edPSM.AsFloat    := FPerimSecaoMedia    ;
    edLBSM.AsFloat   := FLargBocaSecaoMedia ;
    edRH.AsFloat     := FRaioHidrologico    ;
    edCM.AsFloat     := FCoefManning        ;
    edD.AsFloat      := FDeclividade        ;
    end;
end;

function TprTrechoDagua.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  {TODO 1 -cProgramacao: cuidar com as referencias as descargas}

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     if MSG.ParamAsObject(0) = PC_aJusante then
        PC_aJusante := pointer(MSG.ParamAsObject(1)) else

     if MSG.ParamAsObject(0) = PC_aMontante then
        PC_aMontante := pointer(MSG.ParamAsObject(1));
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TprTrechoDagua.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var R1: Real; // VazaoMinima
    R2: Real; // VazaoMaxima
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  {TODO 1 -cProgramacao: TprTrechoDagua.ValidarDados}
  {
  edC       Comprimento
  edASM     AreaSecaoMedia
  edPSM     PerimSecaoMedia
  edLBSM    LargBocaSecaoMedia
  edRH      RaioHidrologico
  edCM      CoefManning
  edD       Declividade
  }

  if FDialogo <> nil then
     begin
     R1 := TprDialogo_TD(FDialogo).edVazMin.AsFloat;
     R2 := TprDialogo_TD(FDialogo).edVazMax.AsFloat;
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

constructor TprPC.Create(const Pos: TMapPoint;
                         Projeto: TprProjeto;
                         TabelaDeNomes: TStrings);
begin
  Inherited Create(TabelaDeNomes, Projeto);

  FPCs_aMontante := TprListaDeObjetos.Create;
  FSubBacias     := TprListaDeObjetos.Create;
  FDemandas      := TprListaDeObjetos.Create;
  FDescargas     := TprListaDeObjetos.Create;

  FAfluenciaSB  := TV.Create(0);
  FDefluencia   := TV.Create(0);
  FVzMon        := TV.Create(0);

  DefinirVariaveisQuePodemSerMonitoradas(['Afluencia SB', 'Defluencia', 'Vz. Mon.']);

  FHierarquia := -1;

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);
  GetMessageManager.RegisterMessage(UM_INIT_EQUATIONS, self);
  GetMessageManager.RegisterMessage(UM_FINALIZE_EQUATIONS, self);

  CriarComponenteVisual(Projeto.AreaDeProjeto, Pos);
end;

{Teoricamente, as listas deverão estar vazias}
destructor TprPC.Destroy();
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  GetMessageManager.UnRegisterMessage(UM_INIT_EQUATIONS, self);
  GetMessageManager.UnRegisterMessage(UM_FINALIZE_EQUATIONS, self);
  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);

  FQA.Free();
  FPCs_aMontante.Free();
  FSubBacias.Free();
  FDemandas.Free();
  FDescargas.Free();
  FTD.Free();
  FVzMon.Free();
  FAfluenciaSB.Free();
  FDefluencia.Free();

  FEQL.Free();

  Inherited Destroy();
end;

function TprPC.ConectarObjeto(Obj: THidroComponente): Integer;
var PC: TprPC;
    SB: TprSubBacia;
    DM: TprDemanda;
    DC: TprDescarga;
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

  // Objeto é uma Demanda ------------------------------------------------------------
  if Obj is TprDescarga then
     begin
     DC := TprDescarga(Obj);
     FDescargas.Adicionar(DC);
     end else

  // Objeto é uma Qualidade De Agua --------------------------------------------------
  if Obj is TprQualidadeDaAgua then
     begin
     FQA := TprQualidadeDaAgua(Obj);
     end else

  // Objeto é um PC ------------------------------------------------------------------
  if Obj is TprPC then
     begin
     PC := TprPC(Obj);
     PC.AdicionarPC_aMontante(Self);
     Self.PC_aJusante := PC;
     end;
end;

procedure TprPC.DesconectarObjetos;
var i, k: Integer;
begin
  For i := 0 to SubBacias - 1 Do
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

  For i := 0 to Demandas - 1 Do
    begin
    Demanda[i].AvisarQueVaiSeDestruir := false;
    Demanda[i].Free;
    end;
end;

procedure TprPC.AdicionarPC_aMontante(PC: TprPC);
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
        if i > -1 then
           FDemandas[i] := nil
        else
           begin
           i := FDescargas.IndiceDo(MSG.ParamAsPointer(0));
           if i > -1 then
              FDescargas[i] := nil
           else
              if FQA = MSG.ParamAsPointer(0) then
                 FQA := nil;
           end;
        end
     end
  else

  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint() else

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     i := FPCs_aMontante.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then FPCs_aMontante.Objeto[i] := MSG.ParamAsPointer(1);
     end else

  if MSG.ID = UM_INIT_EQUATIONS then
     begin
     if MSG.ParamAsObject(0) = FProjeto then
        CriarEquacoes();
     end else

  if MSG.ID = UM_FINALIZE_EQUATIONS then
     begin
     if MSG.ParamAsObject(0) = self.Projeto then
        DestruirEquacoes();
     end;

  inherited ReceiveMessage(MSG);
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

function TprPC.GetPC_aJusante: TprPC;
begin
  if FTD <> nil then
     Result := FTD.PC_aJusante
  else
     Result := nil;
end;

procedure TprPC.SetPC_aJusante(Value: TprPC);
begin
  if FTD <> nil then
     FTD.PC_aJusante := Value
  else
     FTD := TprTrechoDagua.Create(Self, Value, FTN, FProjeto);
end;

function TprPC.GetPC_aMontante(Index: Integer): TprPC;
begin
  Result := TprPC(FPCs_aMontante[Index]);
end;

function TprPC.GetSubBacia(index: Integer): TprSubBacia;
begin
  Result := TprSubBacia(FSubBacias[Index]);
end;

// Remove a coneccao do PC que está a montante deste PC
procedure TprPC.DesconectarPC_aMontante(PC: TprPC);
begin
  FPCs_aMontante.Remover(PC);
end;

procedure TprPC.RemoverTrecho();
begin
  if FTD <> nil then
     begin
     SetModificado(True);
     FTD.PC_aJusante.DesconectarPC_aMontante(FTD.PC_aMontante);
     FTD.Free;
     FTD := nil;
     end;
end;

function TprPC.CriarImagemDoComponente(): TdrBaseShape;
begin
  Result := TdrRectangle.Create(nil);
  Result.Width := 10;
  Result.Height := 10;
end;

function TprPC.GetDemanda(index: Integer): TprDemanda;
begin
  Result := TprDemanda(FDemandas[Index]);
end;

function TprPC.GetNumDemandas(): Integer;
begin
  FDemandas.RemoverNulos();
  Result := FDemandas.Objetos;
end;

function TprPC.Eh_umPC_aMontante(PC: THidroComponente): Boolean;
begin
  Result := (FPCs_aMontante.IndiceDo(PC) > -1);
end;

procedure TprPC.PrepararParaSimulacao;
begin
  inherited PrepararParaSimulacao;

  FAfluenciaSB.Len := FProjeto.Total_IntSim;
  FAfluenciaSB.Fill(0);

  FVzMon.Len := FAfluenciaSB.Len;

  if FProjeto.TipoSimulacao = tsWIN then
     FDefluencia.Len := FAfluenciaSB.Len;
end;

procedure TprPC.ColocarDadosNaPlanilha(Planilha: TForm);
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

  if CompareText(NomeVar, 'Afluência das Sub-Bacias') = 0 then v := AfluenciaSB else
  if CompareText(NomeVar, 'Defluência'              ) = 0 then v := Defluencia else
  if CompareText(NomeVar, 'Vazão de Montante'       ) = 0 then v := VazMontante;

  if (v <> nil) and (v.Len > 0) then
     begin
     d := ObterDataSet(v);
     MostrarDataSet(NomeVar, d);
     d.Free;
     end;
end;

function TprPC.ObterVazaoAfluenteSBs(Intervalo: integer): Real;
var i: Integer;
begin
  // SubBacia.ObterVazaoAfluente depende do Intervalo atual do projeto
  Result := 0;
  for i := 0 to SubBacias-1 do
    Result := Result + SubBacia[i].ObterVazaoAfluente(Self, Intervalo);
end;

procedure TprPC.Monitorar;
var i: Integer;
begin
  inherited;

  if Assigned(FEventoDeMonitoracao) then
     begin
     i := FProjeto.Intervalo;

     if System.Pos('Afluencia SB', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Afluencia SB', FAfluenciaSB[i]);

     if System.Pos('Defluencia', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Defluencia', FDefluencia[i]);

     if System.Pos('Vz. Mon.', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Vz. Mon.', FVzMon[i]);
     end;
end;

// Palavras-Chaves: Equacao, Equacoes, Equation, Equations
// Pode estar errada (erro) ???
procedure TprPC.GerarEquacoes(Text: TStrings; Intervalo: integer; var IndiceGeral: integer);

  procedure Add(const s: string);
  begin
    inc(IndiceGeral);
    Text.Add('E' + intToStr(IndiceGeral) + ') ' + s);
  end;

  procedure Equacao_SomaDosPCsAMontante();
  var i: integer;
      s: string;
  begin
    s := 'M' + FNome + toString(Intervalo) + ' - ';
{
    for i := 0 to PCs_aMontante-1 do
      s := s + 'J' + PC_aMontante[i].Nome + toString(Intervalo) + ' - ';
}
    {TODO 1 -cProgramacao: CONFIRMAR}

    if PC_aJusante <> nil then
       s := s + 'J' + PC_aJusante.Nome + toString(Intervalo) + ' - ';

    for i := 0 to PCs_aMontante-1 do
      begin
      s := s + 'R' + PC_aMontante[i].Nome + toString(Intervalo);
      if i < PCs_aMontante-1 then s := s + ' - ';
      end;

    Add(s + ' = 0.0;');
  end;

begin
  if FHierarquia > 1 then
     Equacao_SomaDosPCsAMontante()
  else
     Add('M' + FNome + toString(Intervalo) + ' = 0.0;');

  FEQL.ToStrings(Text, Intervalo, IndiceGeral);
  Text.Add('');
end;

// Palavras-Chaves: Equacao, Equacoes, Equation, Equations
procedure TprPC.DestruirEquacoes();
begin
  FreeAndNil(FEQL);
end;

// Assunto: Equacoes
function TprPC.io_getValue(const FieldName: string): string;
var segundos: integer;
begin
  // M - D - J = - QSB

  segundos := DiasNoIntervalo(FProjeto.Intervalo) * {n. segundos em um dia} 86400;

  if FieldName = 'M' then
     Result := toString(ObterVazoesDeMontante(FProjeto.Intervalo) * segundos, 5)
  else
  if FieldName = 'SB' then
     Result := toString(ObterVazaoAfluenteSBs(FProjeto.Intervalo) * segundos, 5)
  else
  if FieldName = 'D' then
     Result := 'DM_NAO_DEF'
  else
  if FieldName = 'J' then
     Result := toString(Defluencia[FProjeto.Intervalo] * segundos, 5)
  else
    Result := inherited io_getValue(FieldName);
end;

function TprPC.GetDescarga(index: Integer): TprDescarga;
begin
  result := TprDescarga(FDescargas[index]);
end;

function TprPC.GetNumDescargas(): Integer;
begin
  FDescargas.RemoverNulos();
  result := FDescargas.Objetos;
end;

{ TprPCP }

constructor TprPCP.Create(const Pos: TMapPoint;
                          Projeto: TprProjeto;
                          TabelaDeNomes: TStrings);
begin
  inherited Create(Pos, Projeto, TabelaDeNomes);

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
function TprPCP.MudarParaReservatorio(): TprPCPR;
begin
  Result := TprPCPR.Create(FPos, FProjeto, nil);
  Result.FTN := FTN;
  GetMessageManager.SendMessage(UM_TROCAR_REFERENCIA, [Self, Result]);
  CopiarPara(Result);
end;

function TprPCP.CriarDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_PCP.Create(nil);
  Result.TN := FTN;
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

    FImagemDoComponente.Invalidate();
    end;
end;

function TprPCP.ObterPrefixo: String;
begin
  Result := 'PC_';
end;

procedure TprPCP.ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False);
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
  if FDialogo <> nil then
     RU := TprDialogo_PCP(FDialogo).edEnergiaUsuario.Text
  else
     RU := FEnergiaUsuario;

  VerificaRotinaUsuario(RU, 'Energia', Completo, TudoOk, DialogoDeErros);
end;

// obtem toda a água que vem de trás deste PC
function TprPCP.ObterVazoesDeMontante(Intervalo: integer): Real;
var i  : Integer;
    PC : TprPC;
begin
  Result := 0;
  if FHierarquia > 1 then
     for i := 0 to FPCs_aMontante.Objetos-1 do
       begin
       PC := TprPC(FPCs_aMontante[i]);
       Result := Result + PC.Defluencia[Intervalo];
       end;
end;

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
var   int            : Integer;  // Intervalo de Simulação
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

  int := FProjeto.Intervalo;

  FAfluenciaSB[int] := ObterVazaoAfluenteSBs(int);

  // Cálculo do campo VazõesDeMontante
  FVzMon[int] := ObterVazoesDeMontante(int);
  AfluenciaTotal := M3_Hm3(FVzMon[int], int);

  // Totalização da agua afluente ao PC no Intervalo atual
  // FAfluenciaSB já esta sendo inicializado em PrepararParaSimulacao
  AfluenciaTotal := AfluenciaTotal + M3_Hm3(FAfluenciaSB[int], int);

  // Análise para atendimento das Demandas Hídricas no PC.
  DPP := M3_Hm3(FDPP[int], int);
  DSP := M3_Hm3(FDSP[int], int);
  DTP := M3_Hm3(FDTP[int], int);

  DemandaTotal := DPP + DSP + DTP;

  // AfluenciaTotal é suficiente para atender todas a Demandas
  if AfluenciaTotal > DemandaTotal then
     begin
     // Atualização das Demandas Atendidas
     FDPA[int] := Hm3_m3(DPP, int);
     FDSA[int] := Hm3_m3(DSP, int);
     FDTA[int] := Hm3_m3(DTP, int);
     Retorno := FFRP*DPP + FFRS*DSP + FFRT*DTP;
     end
  else
     begin
     // Não existe água para atender todas as Demandas:
     // fazer racionamento
     Raciona(AfluenciaTotal, DPP, DSP, DTP, {out} DPA, DSA, DTA);
     Projeto.AtualizaPontoExecucao(FNome + '.BalancoHidrico', nil);
     FDPA[int] := Hm3_m3(DPA, int);
     FDSA[int] := Hm3_m3(DSA, int);
     FDTA[int] := Hm3_m3(DTA, int);
     DemandaTotal := DPA + DSA + DTA;
     Retorno := FFRP*DPA + FFRS*DSA + FFRT*DTA;
     end;

  // Cálculo do campo Defluência
  FDefluencia[int] := Hm3_m3 (AfluenciaTotal - DemandaTotal + Retorno, int);

  // Cálculo da Energia Gerada quando houver geração no PC
  if FGerarEnergia then
     begin
     FEG[int] := CalculaEnergia(FQuedaFixa, FDefluencia[int], int);
     if FEnergiaScript <> nil then
        begin
        FProjeto.AtualizaPontoExecucao(FNome + '.ScriptEnergia', FEnergiaScript);
        FEnergiaScript.Execute();
        end;
     end;
end;

function TprPCP.ObterDemanda(Prioridade: TEnumPriorDemanda; Intervalo: integer): Real;
var DM : TprDemanda;  // i-égima demanda
    k  : Integer;     // Contador
begin
  Result := 0;
  for k := 0 to getNumDemandas-1 do
    if (Demanda[k].Prioridade = Prioridade) and (Demanda[k].Ligada) then
       begin
       DM := getDemanda(k);

       // As unidades da demanda são dependentes da data geral da simulação
       DM.Data := FProjeto.IntervaloParaData(Intervalo);
       Result  := Result + DM.Demanda;
       end;
end;

// Totaliza as demandas 1., 2. e 3. para o intervalo t de simulação
procedure TprPCP.TotalizarDemandas();
var i: Integer;
begin
  FDPT.Len := FProjeto.Total_IntSim;
  FDST.Len := FDPT.Len;
  FDTT.Len := FDPT.Len;

  for i := 1 to FDPT.Len do
    begin
    FDPT[i] := ObterDemanda(pdPrimaria, i);
    FDST[i] := ObterDemanda(pdSecundaria, i);
    FDTT[i] := ObterDemanda(pdTerciaria, i);
    end;
end;

procedure TprPCP.ObtemNiveisCriticosDeFalhas();
var x: Real;
begin
  x := FProjeto.NivelDeFalha / 100;
  FNCFP := x; FNCFS := x; FNCFT := x;
end;

function TprPCP.ObtemFalhas: TprListaDeFalhas;

  function Falha(const x, y: Real): Boolean;
  begin
    Result := ABS(x - y) > 0.01 * x;
  end;

var i: Integer;
begin
  if FDPA.Len <> FProjeto.Total_IntSim then
     Raise Exception.Create('Demandas Atendidas e Planejadas ainda não calculadas');

  ObtemNiveisCriticosDeFalhas;
  Result := TprListaDeFalhas.Create(FProjeto);
  for i := 1 to FProjeto.Total_IntSim do
    begin
    if Falha(FDPT[i], FDPA[i]) then Result.Adicionar(pdPrimaria,   i, FDPT[i], FDPA[i], FNCFP);
    if Falha(FDST[i], FDSA[i]) then Result.Adicionar(pdSecundaria, i, FDST[i], FDSA[i], FNCFS);
    if Falha(FDTT[i], FDTA[i]) then Result.Adicionar(pdTerciaria,  i, FDTT[i], FDTA[i], FNCFT);
    end;
end;

procedure TprPCP.PrepararParaSimulacao();
begin
  Inherited PrepararParaSimulacao;

  // Demandas Planejadas
  FDPP.Len := FProjeto.Total_IntSim; FDPP.Fill(0);
  FDSP.Len := FDPP.Len; FDSP.Fill(0);
  FDTP.Len := FDPP.Len; FDTP.Fill(0);
  FEG.Len  := FDPP.Len; FEG.Fill(0);

  if VerificaCaminho(FArqDemEnergetica) then
     FCurvaDemEnergetica.LoadFromTextFile(FArqDemEnergetica);

  // Demandas Atendidas
  if FProjeto.TipoSimulacao = tsWIN then
     begin
     FDPA.Len := FDPP.Len; FDPA.Fill(0);
     FDSA.Len := FDPP.Len; FDSA.Fill(0);
     FDTA.Len := FDPP.Len; FDTA.Fill(0);
     end;

  FFRP := CalculaFatorRetorno(pdPrimaria);
  FFRS := CalculaFatorRetorno(pdSecundaria);
  FFRT := CalculaFatorRetorno(pdTerciaria);
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
  GraficarDemandas('Demandas Atendidas de ', 'Atendidas', Tipo);
end;

procedure TprPCP.GraficarDemandasPlanejadas(Tipo: TEnumTipoDeGrafico);
begin
  GraficarDemandas('Demandas Planejadas de ', 'Planejadas', Tipo);
end;

procedure TprPCP.GraficarDemandasTotais(Tipo: TEnumTipoDeGrafico);
begin
  GraficarDemandas('Demandas Totais de ', 'Ref', Tipo);
end;

procedure TprPCP.GraficarDemandas(const Titulo, TipoDem: String; TipoGraf: TEnumTipoDeGrafico);
var g           : TfoChart;
    b           : TChartSeries;
    d1, d2, d3  : TV;
    k           : Integer;
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

  for k := 0 to FProjeto.Intervalos.NumInts - 1 do
    begin
    if not FProjeto.Intervalos.Habilitado[k] then Continue;

    g := CriarGrafico_Default(Titulo, k);

    case TipoGraf of
      tgBarras:
        begin
        b := g.Series.AddBarSerie(
          'Demanda Primária', clRed, 0, 1, d1, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddBarSerie(
          'Demanda Secundária', clGreen, 0, 1, d2, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddBarSerie(
          'Demanda Terciária', clYellow, 0, 1, d3, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;

      tgLinhas:
        begin
        b := g.Series.AddLineSerie(
          'Demanda Primária', clRed, d1, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddLineSerie(
          'Demanda Secundária', clGreen, d2, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddLineSerie(
          'Demanda Terciária', clYellow, d3, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;
      end;

    DefinirEixoX_Default(b, k);
    g.Show(fsMDIChild);
    end; // for k

  Applic.ArrangeChildrens();  
end;

procedure TprPCP.MostrarFalhas();
var LF: TprListaDeFalhas;
begin
  LF := ObtemFalhas;
  LF.MostrarFalhas.Caption := Nome + ' - Fails of Demand Supply';
end;

procedure TprPCP.ColocarDadosNaPlanilha(Planilha: TForm);
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

procedure TprPCP.GraficarTudo();
var D: TprDialogo_Grafico_PCs_XTudo;
begin
  FProjeto.VerificarIntervalosDeAnalise();
  D := TprDialogo_Grafico_PCs_XTudo.Create(nil);
  Try
    D.Caption := 'Opções para o ' + Nome;
    D.PC := Self;
    D.ShowModal();
  Finally
    D.Release;
    End;
end;

procedure TprPCP.GraficarDisponibilidade_X_Demanda(Tipo: TEnumTipoDeGrafico);
var g      : TfoChart;
    b      : TChartSeries;
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
        b := g.Series.AddBarSerie(
         'Demanda Total', clRed, 0, 1, DT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddBarSerie(
          'Disponível', clYellow, 0, 1, AT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddBarSerie(
          'Diferença', clGreen, 0, 1, FDefluencia, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;

      tgLinhas:
        begin
        b := g.Series.AddLineSerie(
          'Demanda Total', clRed, DT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddLineSerie(
          'Disponível', clGreen, AT, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

        g.Series.AddLineSerie(
          'Diferença', clYellow, FDefluencia, FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
        end;
      end;

    DefinirEixoX_Default(b, k);
    g.Show(fsMDIChild);
    end; // for k

  DT.Free;
  AT.Free;

  Applic.ArrangeChildrens();
end;

procedure TprPCP.MostrarVariavel(const NomeVar: String);
var v: TV;
    d: TwsDataSet;
begin
  v := nil;
  if CompareText(NomeVar, 'Demanda Primária Atendida'   ) = 0 then v := FDPA else
  if CompareText(NomeVar, 'Demanda Secundária Atendida' ) = 0 then v := FDSA else
  if CompareText(NomeVar, 'Demanda Terciária Atendida'  ) = 0 then v := FDTA else
  if CompareText(NomeVar, 'Demanda Primária Planejada'  ) = 0 then v := FDPP else
  if CompareText(NomeVar, 'Demanda Secundária Planejada') = 0 then v := FDSP else
  if CompareText(NomeVar, 'Demanda Terciária Planejada' ) = 0 then v := FDTP else
  if CompareText(NomeVar, 'Demanda Primária Total'      ) = 0 then v := FDPT else
  if CompareText(NomeVar, 'Demanda Secundária Total'    ) = 0 then v := FDST else
  if CompareText(NomeVar, 'Demanda Terciária Total'     ) = 0 then v := FDTT
  else
  if CompareText(NomeVar, 'Energia Gerada') = 0 then v := FEG;

  if (v <> nil) and (v.Len > 0) then
     begin
     d := ObterDataSet(v);
     MostrarDataSet(NomeVar, d);
     d.Free;
     end
  else
     inherited MostrarVariavel(NomeVar);
end;

procedure TprPCP.CopiarPara(PC: TprPCP);
begin
  PC.FNome           := FNome + 'x';
  PC.FDescricao      := FDescricao;
  PC.FHierarquia     := FHierarquia;
  PC.FVisivel        := FVisivel;
  PC.FNCFP           := FNCFP;
  PC.FNCFS           := FNCFS;
  PC.FNCFT           := FNCFT;
  PC.FFRP            := FFRP;
  PC.FFRS            := FFRS;
  PC.FFRT            := FFRT;
  PC.FMDs            := FMDs;

  PC.FEnergiaUsuario   := FEnergiaUsuario;
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

  PC.FDescargas.Free;
  PC.FDescargas := FDescargas;
  FDescargas := nil;

  PC.FPCs_aMontante.Free;
  PC.FPCs_aMontante := FPCs_aMontante;
  FPCs_aMontante := nil;

  PC.FTD.Free;
  PC.FTD := FTD;
  FTD := nil;

  PC.AtualizarHint();
end;

// Estabelece a visibilidade das demandas do PC e das Sub-bacias conectadas a ele
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

{
procedure TprPCP.MostrarMenu(x, y: Integer);
var M: TMenuItem;
begin
  M := FMenu.Items.Find('Mostrar Demandas');
  if M <> nil then M.Checked := FMDs;
  inherited;
end;

procedure TprPCP.PrepararMenu();
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
     d.Editar();
     end;
end;
}

function TprPCP.Hm3_m3(const Valor: Real; Intervalo: integer): Real;
begin
  Result := Valor / DiasNoIntervalo(Intervalo) / 0.0864;
end;

function TprPCP.m3_Hm3(const Valor: Real; Intervalo: integer): Real;
begin
  Result := Valor * DiasNoIntervalo(Intervalo) * 0.0864;
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
     end
  else

  if MSG.ID = UM_LIBERAR_SCRIPTS then
     FreeAndNil(FEnergiaScript);

  inherited ReceiveMessage(MSG);
end;

procedure TprPCP.CalculaVzMon_e_AfluenciaSB();
var i, j: Integer;
begin
  FAfluenciaSB.Len := FProjeto.getTIS();
  FAfluenciaSB.Fill(0);

  FVzMon.Len       := FAfluenciaSB.Len;
  FDefluencia.Len  := FAfluenciaSB.Len;

  for i := 1 to FAfluenciaSB.Len do
    begin
    //FProjeto.Intervalo := i;

    // FAfluenciaSB já está inicializado
    for j := 0 to SubBacias-1 do
      FAfluenciaSB[i] := FAfluenciaSB[i] + SubBacia[j].ObterVazaoAfluente(Self, i);

    // Cálculo do campo VazõesDeMontante
    FVzMon[i] := ObterVazoesDeMontante(i);
    end;
end;

function TprPCP.CalculaEnergia(Queda, Vazao: Real; Intervalo: integer): Real;
begin
  if Vazao > FQMaxTurb then Vazao := FQMaxTurb;
  Result := 9.81 * FRendiAduc * FRendiTurb * FRendiGera * Vazao *
            Queda * (DiasNoIntervalo(Intervalo) * 24) ;
end;

procedure TprPCP.GraficarEnergia(Tipo: TEnumTipoDeGrafico);
var g    : TfoChart;
    b    : TChartSeries;
    k    : Integer;
begin
  FProjeto.VerificarIntervalosDeAnalise;

  for k := 0 to FProjeto.Intervalos.NumInts - 1 do
    begin
    if not FProjeto.Intervalos.Habilitado[k] then Continue;

    g := CriarGrafico_Default('Energia do(a) ', k);

    case Tipo of
      tgBarras:
        b := g.Series.AddBarSerie(
               'Energia', clRed, 0, 0, FEG,
                FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

      tgLinhas:
        b := g.Series.AddLineSerie(
               'Energia', clRed,
               FEG,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
      end;

    b.ShowInLegend := False;
    DefinirEixoX_Default(b, k);
    g.Show(fsMDIChild);
    end; // for k

  Applic.ArrangeChildrens();  
end;

procedure TprPCP.Monitorar;
var i: Integer;
begin
  inherited;

  if Assigned(FEventoDeMonitoracao) then
     begin
     i := FProjeto.Intervalo;

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

function TprPCP.op_getValue(const PropName: string; i1, i2: Integer): real;
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

  Result := inherited op_getValue(PropName, i1, i2);
end;

procedure TprPCP.op_setValue(const PropName: string; i1, i2: Integer; const r: real);
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

// Palavras-Chaves: Equacao, Equacoes, Equation, Equations
procedure TprPCP.CriarEquacoes();
var e: TEquation;
begin
  FEQL := TEquationList.Create();

  // Equacao 0:  M - D - J = - SB
  e := TEquation.Create();
  e.Add(TIdentificator.Create('M'  , isMinus , itDecision , 0 , self));
  e.Add(TIdentificator.Create('D'  , isPlus  , itDecision , 0 , self));
  e.Add(TIdentificator.Create('J'  , isPlus  , itDecision , 0 , self));
  e.Add(TIdentificator.Create('SB' , isMinus , itConst    , 0 , self));
  FEQL.Add(e);

  FEQL.Preview := FProjeto.Equacoes_PreVisualizar;
end;

// Palavras-Chaves: Equacao, Equacoes, Equation, Equations
procedure TprPCP.Equacoes_MudarTipoVar(indEQ: Integer; const Nome: string; Tipo: TIdentType);
var ident: TIdentificator;
begin
  ident := FEQL.Item[indEQ].IdentByName(Nome);
  if ident <> nil then
     ident.FieldType := Tipo
  else
     raise Exception.CreateFmt('Identificador desconhecido na Equação: %s', [Nome]);
end;

procedure TprPCP.internalToXML();
var x: TXML_Writer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('viewDemands', FMDs);
  x.Write('color', Integer(FImagemDoComponente.Canvas.Brush.Color));

  // Power Generation
  x.Write('generatePower',       FGerarEnergia    );
  x.Write('generatorEfficiency', FRendiGera       );
  x.Write('maxTurbineOutlet',    FQMaxTurb        );
  x.Write('aducEfficiency',      FRendiAduc       );
  x.Write('turbinesEfficiency',  FRendiTurb       );
  x.Write('powerDemand',         FDemEnergetica   );
  x.Write('waterfall',           FQuedaFixa       );
  x.Write('powerDemand_File',    FArqDemEnergetica);
  x.Write('power_Script',        FEnergiaUsuario  );
end;

procedure TprPCP.fromXML(no: IXMLDomNode);
begin
  inherited fromXML(no);

  FMDs := strToBoolean(nextChild(no).text);
  FImagemDoComponente.Canvas.Brush.Color := strToInt(nextChild(no).text);

  // Power Generation
  FGerarEnergia     := strToBoolean(nextChild(no).text);
  FRendiGera        := strToFloat(nextChild(no).text);
  FQMaxTurb         := strToFloat(nextChild(no).text);
  FRendiAduc        := strToFloat(nextChild(no).text);
  FRendiTurb        := strToFloat(nextChild(no).text);
  FDemEnergetica    := strToFloat(nextChild(no).text);
  FQuedaFixa        := strToFloat(nextChild(no).text);
  FArqDemEnergetica := nextChild(no).text;
  FEnergiaUsuario   := nextChild(no).text;
end;

procedure TprPCP.getActions(Actions: TActionList);
var act: TAction;
begin
  inherited getActions(Actions);
  {
  THidroComponente ...
  --------------------
  graficos
  --------------------
  Visualizar --> Demandas (Checked)
                 Falhas
                 Em Planilha --> Dados Gerais
                                 Afluência das Sub-Bacias
                                 Defluência
                                 Vazão de Montante
                                 Energia Gerada
                                 Demandas --> Demanda Primária Atendida
                                              Demanda Secundária Atendida
                                              Demanda Terciária Atendida
                                              -------------------------------
                                              Demanda Primária Planejada
                                              Demanda Secundária Planejada
                                              Demanda Terciária Planejada
                                              -------------------------------
                                              Demanda Primária Total
                                              Demanda Secundária Total
                                              Demanda Terciária Total
  }
  CreateAction(Actions, nil, '-', false, nil, self);
  CreateAction(Actions, nil, 'Gráficos ...', false, GraphicEvent, self);
  CreateAction(Actions, nil, '-', false, nil, self);

  // Visualizar
  act := CreateAction(Actions, nil, 'Visualizar', false, nil, self);
         CreateAction(Actions, act, 'Demandas', FMDs, ShowDemandsEvent, self);
         CreateAction(Actions, act, 'Falhas', false, ShowFaultsEvent, self);

         // Planilha
         act := CreateAction(Actions, act, 'em Planilha', false, nil, self);
                CreateAction(Actions, act, 'Dados Gerais', false, ShowSheetEvent, self);
                CreateAction(Actions, act, 'Afluência das Sub-Bacias', false, ShowDataInSheetEvent, self);
                CreateAction(Actions, act, 'Defluência', false, ShowDataInSheetEvent, self);
                CreateAction(Actions, act, 'Vazão de Montante', false, ShowDataInSheetEvent, self);
                CreateAction(Actions, act, 'Energia Gerada', false, ShowDataInSheetEvent, self);

                // Salva a acao corrente para ser usada pelos descendentes
                FMenuAction_Sheet := act;

                // Demandas
                act := CreateAction(Actions, act, 'Demands', false, nil, self);
                       CreateAction(Actions, act, 'Demanda Primária Atendida', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, act, 'Demanda Secundária Atendida', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, act, 'Demanda Terciária Atendida', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, nil, '-', false, nil, self);
                       CreateAction(Actions, act, 'Demanda Primária Planejada', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, act, 'Demanda Secundária Planejada', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, act, 'Demanda Terciária Planejada', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, nil, '-', false, nil, self);
                       CreateAction(Actions, act, 'Demanda Primária Total', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, act, 'Demanda Secundária Total', false, ShowDataInSheetEvent, self);
                       CreateAction(Actions, act, 'Demanda Terciária Total', false, ShowDataInSheetEvent, self);
end;

procedure TprPCP.GraphicEvent(Sender: TObject);
begin
  GraficarTudo();
end;

procedure TprPCP.ShowDataInSheetEvent(Sender: TObject);
begin
  MostrarVariavel( TMenuItem(Sender).Caption );
end;

procedure TprPCP.ShowDemandsEvent(Sender: TObject);
begin
  SetMDs(not FMDs);
  AP(FProjeto.AreaDeProjeto).Atualizar();
end;

procedure TprPCP.ShowFaultsEvent(Sender: TObject);
begin
  MostrarFalhas();
end;

procedure TprPCP.ShowSheetEvent(Sender: TObject);
begin
  MostrarPlanilha();
end;

{ TprPCPR }

constructor TprPCPR.Create(const Pos: TMapPoint;
                           Projeto: TprProjeto;
                           TabelaDeNomes: TStrings);
begin
  Inherited Create(Pos, Projeto, TabelaDeNomes);

  FLigado := true;

  FVolume   := TV.Create(0);
  FDeflu_Pl := TV.Create(0);
  FDeflu_Op := TV.Create(0);

  DefinirVariaveisQuePodemSerMonitoradas(['Volume',
                                          'Defluvio Planejado',
                                          'Defluvio Operado']);
end;

function TprPCPR.CriarDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_PCPR.Create(nil);
  Result.TN := FTN;
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

function TprPCPR.ObterPrefixo: String;
begin
  Result := 'RES_';
end;

function TprPCPR.CriarImagemDoComponente(): TdrBaseShape;
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
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var R1: Real; // VolIni
    R2: Real; // VolMin
    PCV: Integer;
    PAV: Integer;
    s1 : String;
    s2 : String;
    OU : String;
    EU : String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if FDialogo <> nil then
     begin
     R1  := TprDialogo_PCPR(FDialogo).edVolIni.AsFloat;
     R2  := TprDialogo_PCPR(FDialogo).edVolMin.AsFloat;
     PCV := StrToInt(TprDialogo_PCPR(FDialogo).Curvas.edCV.Text);
     PAV := StrToInt(TprDialogo_PCPR(FDialogo).Curvas.edAV.Text);
     s1  := TprDialogo_PCPR(FDialogo).edArqPrec.Text;
     s2  := TprDialogo_PCPR(FDialogo).edArqETP.Text;
     OU  := TprDialogo_PCPR(FDialogo).edOperaUsuario.Text;
     EU  := TprDialogo_PCPR(FDialogo).edEnergiaUsuario.Text;
     end
  else
     begin
     R1  := FVolIni;
     R2  := FVolMin;
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

  if not VerificaCaminho(s1) then
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

  if not VerificaCaminho(s2) then
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

  VerificaRotinaUsuario(OU, 'Opera', Completo, TudoOk, DialogoDeErros);
  VerificaRotinaUsuario(EU, 'Cálculo de Energia', Completo, TudoOk, DialogoDeErros);
end;

procedure TprPCPR.ColocarDadosNaPlanilha(Planilha: TForm);
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
var g: TfoChart;
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
        b := g.Series.AddBarSerie(
               'Volumes', clRed, 0, 0,
               FVolume,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

      tgLinhas:
        b := g.Series.AddLineSerie(
               'Volumes', clRed, FVolume,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
      end;

    b.ShowInLegend := False;
    DefinirEixoX_Default(b, k);
    g.Show(fsMDIChild);
    end;

  Applic.ArrangeChildrens();  
end;

procedure TprPCPR.GraficarTudo();
var D: TprDialogo_Grafico_PCsRes_XTudo;
begin
  FProjeto.VerificarIntervalosDeAnalise;
  D := TprDialogo_Grafico_PCsRes_XTudo.Create(nil);
  Try
    D.Caption := 'Opções para o ' + Nome;
    D.PC := Self;
    D.ShowModal();
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
begin
  inherited PrepararParaSimulacao;
  FVolume.Len   := FEG.Len;  FVolume.Fill(0);
  FDeflu_Pl.Len := FEG.Len;  FDeflu_Pl.Fill(0);
  FDeflu_Op.Len := FEG.Len;  FDeflu_Op.Fill(0);
end;

function TprPCPR.MudarParaPC(): TprPCP;
begin
  Result := TprPCP.Create(FPos, FProjeto, nil);
  Result.FTN := FTN;
  GetMessageManager.SendMessage(UM_TROCAR_REFERENCIA, [Self, Result]);
  CopiarPara(Result);
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
  if FProjeto.Intervalo = 1 then
    Result := FVolIni
  else
    Result := FVolume[FProjeto.Intervalo - 1];
end;

procedure TprPCPR.Opera(const VolumeDisponivel, DPP, DSP, DTP, Deflu_Pl: Real; // passagem por valor
                        out DPO, DSO, DTO, Deflu_OP: Real);                    // variaveis de saída
          {IMPORTANTE: Deflu_Op não deve incorporar os RETORNOS das
                       Demandas Operadas no Reservatorio - estes são considerados
                       como que retornando ao curso d'água à jusante do mesmo.}
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

procedure TprPCPR.BalancoHidrico();
Var int             : Integer;    // Intervalo de Simulação Atual
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
    Vertimento      : Real;       // Aux.
Begin
  if FLigado then
     begin
     Projeto.AtualizaPontoExecucao(FNome + '.BalancoHidrico', nil);

     // Inicializa variáveis auxiliares
     int             := FProjeto.Intervalo;
     PriVez          := True;
     VolumeAtual     := 0;
     VolInicioInterv := ObtemVolFinalIntervaloAnterior;
     VolFinalInterv  := VolInicioInterv;
     EvapoUnitaria   := EvaporacaoUnitaria[int];
     PrecipUnitaria  := PrecipitacaoUnitaria[int];
     DPO             := 0;
     DSO             := 0;
     DTO             := 0;
     DPT             := M3_Hm3(FDPT[int], int);
     DST             := M3_Hm3(FDST[int], int);
     DTT             := M3_Hm3(FDTT[int], int);
     Vertimento      := 0;
     Deflu_OP        := 0;

     {
     Calculo das vazões afluentes
        - das Sub-bacias do PC e
        - dos PCs à montante do Reservatorio

        Cálculo do campo AfluenciaSB
          - FAfluenciaSB[int] é iniciada em zero por método da própria
            Classe SubBacia
     }

     FAfluenciaSB[int] := ObterVazaoAfluenteSBs(int);

     // Cálculo do campo VazõesDeMontante
     FVzMon[int] := ObterVazoesDeMontante(int);
     AfluenciaTotal := M3_Hm3(FVzMon[int], int);

     // Totalização da agua afluente ao PC no Intervalo atual
     // FAfluenciaSB já esta sendo inicializado em PrepararParaSimulacao
     AfluenciaTotal := AfluenciaTotal + M3_Hm3(FAfluenciaSB[int], int);

     // Prepara para análise para atendimento das Demandas Hídricas no PC.
     DPP := M3_Hm3(FDPP[int], int);
     DSP := M3_Hm3(FDSP[int], int);
     DTP := M3_Hm3(FDTP[int], int);
     Deflu_Pl := M3_Hm3(FDeflu_Pl[int], int);

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

       VolumeAtual := VolumeAtual - (DPO + DSO + DTO + Deflu_OP);

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
     FDPA[int]    := Hm3_m3(DPO, int);
     FDSA[int]    := Hm3_m3(DSO, int);
     FDTA[int]    := Hm3_m3(DTO, int);
     FVolume[int] := VolFinalInterv;
     Retorno      := FFRP*DPO + FFRS*DSO + FFRT*DTO;

     // Atualização da Defluencia.
     FDefluencia[int] := Hm3_m3(Deflu_OP + Retorno + Vertimento, int);
     FDeflu_OP[int] := Deflu_OP;

     // Cálculo da Energia Gerada quando houver geração no Reservatorio
     if FGerarEnergia then
        begin
        Queda := CalculaCotaHidraulica((VolumeAtual + VolInicioInterv) / 2) - FCotaJusante;
        FEG[int] := CalculaEnergia(Queda, Hm3_m3(Deflu_OP, int), int);
        if FEnergiaScript <> nil then
           begin
           FProjeto.AtualizaPontoExecucao(FNome + '.ScriptEnergia', FEnergiaScript);
           FEnergiaScript.Execute();
           end;
        end;
     end
  else
     inherited BalancoHidrico();
end; // PCPR.BalancoHidrico

function TprPCPR.GetEU: TV;
var s1: String;
begin
  if FEU = nil then
     begin
     s1 := FArqETP;
     VerificaCaminho(s1);
     FEU := TV.Create(0);
     SysUtilsEx.SaveDecimalSeparator();
     try
       FEU.LoadFromTextFile(s1);
     finally
       SysUtilsEx.RestoreDecimalSeparator();
       end;
     end;

  Result := FEU;
end;

function TprPCPR.GetPU: TV;
var s1: String;
begin
  if FPU = nil then
     begin
     s1 := FArqPrec;
     VerificaCaminho(s1);
     FPU := TV.Create(0);
     SysUtilsEx.SaveDecimalSeparator();
     try
       FPU.LoadFromTextFile(s1);
     finally
       SysUtilsEx.RestoreDecimalSeparator();
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
     end
  else

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
     i := FProjeto.Intervalo;

     if System.Pos('Volume', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Volume', FVolume[i]);

     if System.Pos('Defluvio Planejado', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Defluvio Planejado', FDeflu_Pl[i]);

     if System.Pos('Defluvio Operado', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Defluvio Planejado', FDeflu_Op[i]);
     end;
end;

function TprPCPR.op_getValue(const PropName: string; i1, i2: Integer): real;
begin
  if CompareText(PropName, 'VolumeMaximo') = 0 then
     Result := FVolMax else

  if CompareText(PropName, 'VolumeMinimo') = 0 then
     Result := FVolMin else

  if CompareText(PropName, 'VolumeInicial') = 0 then
     Result := FVolIni else

  if CompareText(PropName, 'CotaJusante') = 0 then
     Result := FCotaJusante else

  Result := inherited op_getValue(PropName, i1, i2);
end;

procedure TprPCPR.op_setValue(const PropName: string; i1, i2: Integer; const r: real);
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

// Palavras-Chaves: Equacao, Equacoes, Equation, Equations
procedure TprPCPR.CriarEquacoes();
var e: TEquation;
begin
  FEQL := TEquationList.Create();

  // Equacao 0:  - Sf + Si + P - E + M - D - J = - SB
  e := TEquation.Create();
  e.Add(TIdentificator.Create('S'  , isPlus  , itDecision  , 1 ,  self)); // ArmFinal[int+1]
  e.Add(TIdentificator.Create('S'  , isMinus , itDecision  , 0 ,  self)); // ArmInicial[int]
  e.Add(TIdentificator.Create('P'  , isMinus , itDecision  , 0 ,  self));
  e.Add(TIdentificator.Create('E'  , isPlus  , itDecision  , 0 ,  self));
  e.Add(TIdentificator.Create('M'  , isMinus , itDecision  , 0 ,  self));
  e.Add(TIdentificator.Create('D'  , isPlus  , itDecision  , 0 ,  self));
  e.Add(TIdentificator.Create('J'  , isPlus  , itDecision  , 0 ,  self));
  e.Add(TIdentificator.Create('SB' , isMinus , itConst     , 0 ,  self));
  FEQL.Add(e);

  FEQL.Preview := FProjeto.Equacoes_PreVisualizar;
end;

function TprPCPR.io_getValue(const FieldName: string): string;
begin
  if FieldName = 'P' then
     Result := toString(PrecipitacaoUnitaria[FProjeto.Intervalo], 5)
  else
  if FieldName = 'E' then
     Result := toString(EvaporacaoUnitaria[FProjeto.Intervalo], 5)
  else
  if FieldName = 'S' then
     Result := 'STI_NAO_DEF'
  else
    Result := inherited io_getValue(FieldName);
end;

procedure TprPCPR.fromXML(no: IXMLDomNode);
var n: IXMLDomNode;
    i: integer;
begin
  inherited fromXML(no);

  FArqPrec := nextChild(no).text;
  FArqETP  := nextChild(no).text;
  FTipoETP := strToInt(nextChild(no).text);

  FVolMax  := strToFloat(nextChild(no).text);
  FVolMin  := strToFloat(nextChild(no).text);
  FVolIni  := strToFloat(nextChild(no).text);
  FCotaJusante := strToFloat(nextChild(no).text);

  FStatus := strToBoolean(nextChild(no).text);
  FOperaUsuario := nextChild(no).text;

  n := nextChild(no);
  setLength(FAV, n.childNodes.length);
  for i := 0 to High(FAV) do
    begin
    FAV[i].Area := strToFloat(n.childNodes.item[i].attributes.item[0].Text);
    FAV[i].Vol  := strToFloat(n.childNodes.item[i].attributes.item[1].Text);
    end;

  n := nextChild(no);
  setLength(FCV, n.childNodes.length);
  for i := 0 to High(FCV) do
    begin
    FCV[i].Cota := strToFloat(n.childNodes.item[i].attributes.item[0].Text);
    FCV[i].Vol  := strToFloat(n.childNodes.item[i].attributes.item[1].Text);
    end;
end;

procedure TprPCPR.internalToXML();
var x: TXML_Writer;
    i: integer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('prec_File', FArqPrec);
  x.Write('etp_File' , FArqETP);
  x.Write('etp_Type' , FTipoETP);

  x.Write('maxVol'   , FVolMax);
  x.Write('minVol'   , FVolMin);
  x.Write('iniVol'   , FVolIni);
  x.Write('jusQuota' , FCotaJusante);

  x.Write('status' , FStatus);
  x.Write('operation_Script', FOperaUsuario);

  x.BeginTag('areaVolCurve');
    x.BeginIdent();
    for i := 0 to PontosAV-1 do x.Write('AV', ['area', 'vol'], [FAV[i].Area, FAV[i].Vol], '');
    x.EndIdent();
  x.EndTag('areaVolCurve');

  x.BeginTag('quotaVolCurve');
    x.BeginIdent();
    for i := 0 to PontosCV-1 do x.Write('AV', ['Quota', 'Vol'], [FCV[i].Cota, FCV[i].Vol], '');
    x.EndIdent();
  x.EndTag('quotaVolCurve');
end;

procedure TprPCPR.getActions(Actions: TActionList);
begin
  {
  (TprPC) Planilha --> (TprPC) ...
                       Volumes
  }

  // Neste momento "FMenuAction_Sheet" eh estabelecido
  inherited getActions(Actions);
  CreateAction(Actions, FMenuAction_Sheet, 'Volume', false, ShowDataInSheetEvent, self);
end;

{ TprSubBacia }

constructor TprSubBacia.Create(const Pos: TMapPoint;
                               Projeto: TprProjeto;
                               TabelaDeNomes: TStrings);
begin
  inherited Create(TabelaDeNomes, Projeto);
  FArea := 1;

  FDemandas := TprListaDeObjetos.Create; {Demandas Difusas}
  FPCs      := TprListaDeObjetos.Create;
  FCCs      := TDoubleList.Create;

  DefinirVariaveisQuePodemSerMonitoradas(['Vazao']);

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);

  CriarComponenteVisual(Projeto.AreaDeProjeto, Pos);
end;

destructor TprSubBacia.Destroy();
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);

  FDemandas.Free;
  FPCs.Free;
  FCCs.Free;
  LiberarVazoes;
  inherited Destroy;
end;

function TprSubBacia.getNDD: Integer;
begin
  Result := FDemandas.Objetos;
end;

function TprSubBacia.ConectarObjeto(Obj: THidroComponente): Integer;
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
     end else

  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint else

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     i := FPCs.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then FPCs.Objeto[i] := MSG.ParamAsPointer(1);
     end;

  inherited ReceiveMessage(MSG);
end;

function TprSubBacia.ObterPrefixo(): String;
begin
  Result := 'SubBacia_';
end;

function TprSubBacia.CriarDialogo(): TprDialogo_Base;
begin
  Result := TprDialogo_SB.Create(nil);
  Result.TN := FTN;
end;

procedure TprSubBacia.PegarDadosDoDialogo(d: TprDialogo_Base);
var i: Integer;
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_SB) do
    begin
    FArea := StrToFloat(edArea.Text);
    FArqVA := edVA.Text;
    if ArqVazModificado then LiberarVazoes;
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
      sgCoefs.Cells[0, i] := TprPC(FPCs.Objeto[i-1]).Nome;
      sgCoefs.Cells[1, i] := FCCs.AsString[i-1];
      end;
    end;
end;

procedure TprSubBacia.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var R1: Real; // Area
    s1: String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if FDialogo <> nil then
     begin
     R1 := TprDialogo_SB(FDialogo).edArea.AsFloat;
     s1 := TprDialogo_SB(FDialogo).edVA.Text;
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

  if FDialogo <> nil then Exit;

  if not VerificaCaminho(s1) then
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

function TprSubBacia.CriarImagemDoComponente(): TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'SUB_BACIA_20X20');
  Result.Width := 20;
  Result.Height := 20;
  TdrBitmap(Result).DrawFrame := True;
end;

function TprSubBacia.GetDD(index: Integer): TprDemanda;
begin
  Result := TprDemanda(FDemandas[Index]);
end;

function TprSubBacia.GetVazoes: TV;
var s1: String;
begin
  if FVazoes = nil then
     begin
     s1 := FArqVA;
     FVazoes := TV.Create(0);
     SysUtilsEx.SaveDecimalSeparator();
     try
       VerificaCaminho(s1);
       FVazoes.LoadFromTextFile(s1);
     finally
       SysUtilsEx.RestoreDecimalSeparator();
       end;
     end;

  Result := FVazoes;
end;

procedure TprSubBacia.LiberarVazoes();
begin
  if FVazoes <> nil then
     FreeAndNil(FVazoes);
end;

procedure TprSubBacia.DesconectarObjetos();
begin
  while FDemandas.Objetos > 0 do
    begin
    FDemandas[FDemandas.Objetos-1].Free;
   {O delete será dado quando a própria subbacia recebar a mensagem
    de destruição da demanda}
    //FDemandas.Lista.Delete(i);
    end;
end;

function TprSubBacia.ObterVazaoAfluente(PC: TprPC; Intervalo: integer): Real;
var k   : Integer;  // Contador
    D   : Real;     // Somatório das demandas difusas
    DM  : TprDemanda; // n-égima Demanda
begin
  //i := FProjeto.Intervalo;

  // Calcula o consumo das demandas difusas ativas
  D := 0;
  for k := 0 to Demandas-1 do
    if Demanda[k].Ligada then
       begin
       DM := Demanda[k];

       // As unidades da demanda são dependentes da data geral da simulação
       DM.Data := FProjeto.IntervaloParaData(Intervalo);
       D := D + DM.UnidadeDeConsumo * DM.UnidadeDeDemanda * Area * DM.FatorDeConversao;
       end;

  //Result := Max(0, (getVazoes[Intervalo] - D)) * CCs[PCs.IndiceDo(PC)];
  result := (getVazoes[Intervalo] - D) * CCs[ PCs.IndiceDo(PC) ];
  if (result < 0) and not FProjeto.PermitirVazoesNegativasNasSubBacias then
     result := 0;
end;

procedure TprSubBacia.PrepararParaSimulacao;
begin
  Inherited PrepararParaSimulacao;
  LiberarVazoes;
end;

procedure TprSubBacia.GraficarVazoes(Tipo: TEnumTipoDeGrafico);
var g: TfoChart;
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
        b := g.Series.AddBarSerie(
               'Vazões', clRed, 0, 0,
               GetVazoes,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);

      tgLinhas:
        b := g.Series.AddLineSerie(
               'Vazões', clRed, GetVazoes,
               FProjeto.Intervalos.IntIni[k], FProjeto.Intervalos.IntFim[k]);
      end;

    b.ShowInLegend := False;
    DefinirEixoX_Default(b, k);
    g.Show(fsMDIChild);
    end;

  Applic.ArrangeChildrens();  
end;

procedure TprSubBacia.ColocarDadosNaPlanilha(Planilha: TForm);
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
    v: TV;
begin
  v := getVazoes();
  if (v <> nil) and (v.Len > 0) then
     begin
     d := ObterDataSet(v);
     MostrarDataSet('Vazão', d);
     d.Free();
     end;
end;

procedure TprSubBacia.Monitorar;
var i: Integer;
begin
  inherited;

  if Assigned(FEventoDeMonitoracao) then
     begin
     i := FProjeto.Intervalo;

     if System.Pos('Vazao', FVarsMonitoradas) <> 0 then
        FEventoDeMonitoracao(Self, 'Vazao', FVazoes[i]);
     end;
end;

procedure TprSubBacia.fromXML(no: IXMLDomNode);
var i: Integer;
    n: IXMLDomNode;
begin
  inherited fromXML(no);

  FArea  := strToFloat(nextChild(no).Text);
  FArqVA := nextChild(no).Text;

  n := nextChild(no);
  FCCs.Clear();
  for i := 0 to n.childNodes.length-1 do
    FCCs.Add(strToInt(n.childNodes.item[i].text));
end;

procedure TprSubBacia.internalToXML();
var x: TXML_Writer;
    i: integer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('area', FArea);
  x.Write('outlet_File', FArqVA);

  x.BeginTag('coefs');
    x.BeginIdent();
    for i := 0 to FCCs.Count - 1 do x.Write('coef', FCCs[i]);
    x.EndIdent();
  x.EndTag('coefs');
end;

procedure TprSubBacia.getActions(Actions: TActionList);
var act1, act2: TAction;
begin
  {
  THidroComponente ...
  --------------------
  Visualizar --> Dados Gerais
                 Vazão --> em Planilha
                           Gráfico --> em Barras
                                       em Linhas
  }
  inherited getActions(Actions);

  CreateAction(Actions, nil, '-', false, nil, self);
  act1 := CreateAction(Actions, nil, 'Visualizar', false, nil, self);
          CreateAction(Actions, act2, 'Dados Gerais', false, ShowSheetEvent, self);
          act2 := CreateAction(Actions, act1, 'Vazão', false, nil, self);
                  CreateAction(Actions, act2, 'em Planilha', false, ShowOutletInSheetEvent, self);
                  act2 := CreateAction(Actions, act2, 'Gráfico', false, nil, self);
                          CreateAction(Actions, act2, 'em Barras', false, ShowOutletInGraphicEvent, self);
                          CreateAction(Actions, act2, 'em Linhas', false, ShowOutletInGraphicEvent, self);
end;

procedure TprSubBacia.ShowOutletInGraphicEvent(Sender: TObject);
var s: string;
begin
  s := TMenuItem(Sender).Caption;
  if s = 'em Barras' then
     GraficarVazoes(tgBarras)
  else
  if s = 'em Linhas' then
     GraficarVazoes(tgLinhas)
end;

procedure TprSubBacia.ShowOutletInSheetEvent(Sender: TObject);
begin
  MostrarVariavel('Vazão');
end;

procedure TprSubBacia.ShowSheetEvent(Sender: TObject);
begin
  MostrarPlanilha();
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

function THidroDemanda.getDemanda(): Real;
begin
  raise Exception.CreateFmt(
    'Metodo "getDemanda" nao implementado na classe %s', [self.ClassName]);
end;

procedure THidroDemanda.fromXML(no: IXMLDomNode);
begin
  inherited fromXML(no);

  FLigada := strToBoolean(nextChild(no).text);
  byte(FPrioridade) := strToInt(nextChild(no).text);

  if FSalvarLerBitmap then
     Bitmap := LoadBitmapFromXML( nextChild(no) );
end;

procedure THidroDemanda.internalToXML();
var x: TXML_Writer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('status', FLigada);
  x.Write('priority', byte(FPrioridade));

  // 1. no
  if FSalvarLerBitmap then
     SaveBitmapToXML(Bitmap, x.Buffer, x.IdentSize);
end;

{ TprClasseDemanda }

constructor TprClasseDemanda.Create(const Pos: TMapPoint;
                                    Projeto: TprProjeto;
                                    TabelaDeNomes: TStrings);
begin
  inherited Create(TabelaDeNomes, Projeto);
  FED := 1;
  FFR := 0;

  // Somente as classes de demanda devarão salver/ler seus bitmaps
  FSalvarLerBitmap := True;

  FSincronizaDados := True;
  FSincVU          := True;
  FSincUD          := False;
  FSincFI          := True;

  CriarComponenteVisual(Projeto.AreaDeProjeto, Pos);
end;

function TprClasseDemanda.CriarImagemDoComponente(): TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'DEMANDA_IRRIGACAO_20X20');
  Result.Width := 22;
  Result.Height := 22;
  with TdrBitmap(Result) do
    begin
    DrawFrame := True;
    Bitmap.OnChange := BitmapChange;
    end;
  Result.Visible := False;
end;

function TprClasseDemanda.CriarDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_ClasseDeDemanda.Create(nil);
  Result.TN := FTN;
end;

procedure TprClasseDemanda.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_ClasseDeDemanda) do
    begin
    if ImagemMudou then
       begin
       Bitmap.Assign(Image.Picture);
       Gerenciador.ReconstroiArvore();
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
       Gerenciador.ReconstroiArvore();
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

    //Projeto := TfoAreaDeProjeto_Base(FProjeto).Projeto;
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

function TprClasseDemanda.ObterPrefixo(): String;
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

procedure TprClasseDemanda.ValidarDados(var TudoOk: Boolean;
                           DialogoDeErros: TfoMessages; Completo: Boolean);
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);

  if not (self is TprDemanda) and not FLigada then
     DialogoDeErros.Add(etInformation,
     Format('Objeto: %s'#13 +
            'Classe de Demanda Desligada.'#13 +
            'Isto afeta todas as demandas descendentes desta classe.', [Nome]));

end;

function TprClasseDemanda.op_getValue(const PropName: string; i1, i2: Integer): real;
begin
  if CompareText(PropName, 'EscalaDeDesenvolvimento') = 0 then
     Result := FED else

  if CompareText(PropName, 'FatorDeConversao') = 0 then
     Result := FFC else

  if CompareText(PropName, 'FatorDeRetorno') = 0 then
     Result := FFR else

  if CompareText(PropName, 'UnidadeDeConsumo') = 0 then
     Result := getUnidadeDeConsumo(i1, i2) else

  if CompareText(PropName, 'UnidadeDeDemanda') = 0 then
     Result := getUnidadeDeDemanda(i1, i2) else

  if CompareText(PropName, 'FatorDeImplantacao') = 0 then
     Result := getFatorDeImplantacao(i1, i2) else

  Result := inherited op_getValue(PropName, i1, i2);
end;

procedure TprClasseDemanda.op_setValue(const PropName: string; i1, i2: Integer; const r: real);
begin
  if CompareText(PropName, 'EscalaDeDesenvolvimento') = 0 then
     FED := r else

  if CompareText(PropName, 'FatorDeConversao') = 0 then
     FFC := r else

  if CompareText(PropName, 'FatorDeRetorno') = 0 then
     FFR := r else

  if CompareText(PropName, 'UnidadeDeConsumo') = 0 then
     setUnidadeDeConsumo(i1, i2, r) else

  if CompareText(PropName, 'UnidadeDeDemanda') = 0 then
     setUnidadeDeDemanda(i1, i2, r) else

  if CompareText(PropName, 'FatorDeImplantacao') = 0 then
     setFatorDeImplantacao(i1, i2, r) else

  inherited;
end;

procedure TprClasseDemanda.ErroTVU(const Rotina: string);
begin
  raise Exception.CreateFmt('Método: %s'#13'Erro: Parâmetros Incorretos', [Rotina]);
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

procedure TprClasseDemanda.TVU_ObterAnoInicialFinalIntervalo(const Ind_Intervalo: integer; out AnoInicial, AnoFinal: Integer);
begin
  if (Ind_Intervalo < Length(FVU)) and (AnoInicial <= AnoFinal) then
     begin
     AnoInicial := FVU[Ind_Intervalo].AnoIni;
     AnoFinal := FVU[Ind_Intervalo].AnoFim;
     end
  else
     ErroTVU('TVU_AnoInicialFinalIntervalo');
end;

function TprClasseDemanda.TVU_ObterDemanda(const Ind_Intervalo, Mes: Integer): real;
begin
  if (Ind_Intervalo < Length(FVU)) and (Mes >= 1) and (Mes <= 12) then
     result := FVU[Ind_Intervalo].Mes[Mes]
  else
     ErroTVU('TVU_Demanda');
end;

function TprClasseDemanda.TVU_ObterNumIntervalos(): Integer;
begin
  result := System.Length(FVU);
end;

function TprClasseDemanda.getDemanda(): Real;
begin
  Result := getUC() * getUD() * FFC * getFI() * FED;
end;

procedure TprClasseDemanda.AssociarValoresUnitarios(Dados: TObject);
var ds: TwsDataSet;
     v: TwsVec;
     i: integer;
     k: integer;
     a: integer;
     x: double;
begin
  ds := TwsDataSet(Dados);
  TVU_NumIntervalos(ds.nRows);
  for i := 1 to ds.nRows do
    begin
    v := ds.Row[i];
    a := StrToIntDef(v.Name, 0);
    TVU_AnoInicialFinalIntervalo(i-1, a, a);
    for k := 1 to 12 do
      begin
      if v.IsMissValue(k, x) then
         TVU_Demanda(i-1, k, 0.0)
      else
         TVU_Demanda(i-1, k, x / DateUtils.DaysInAMonth(a, k) / 8.64);
      end;
    end;
end;

// Iguala o valor das demandas pertencentes a esta classe
procedure TprClasseDemanda.setVarDecisao(const Value: boolean);
begin
  FEQ_Decisao := Value;
  getMessageManager.SendMessage(UM_SET_VAR_DECISAO, [self]);
end;

procedure TprClasseDemanda.internalToXML();
var x: TXML_Writer;
    i, j: integer;
    s: string;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('developmentFactor', FED);
  x.Write('conversionFactor', FFC);
  x.Write('returnFactor', FFR);
  x.Write('WCU_Name', FNUCD);
  x.Write('WDU_Name', FNUD);

  x.Write('dataSynchronize', FSincronizaDados);
  x.Write('UV_Sync', FSincVU);
  x.Write('DU_Sync', FSincUD);
  x.Write('IF_Sync', FSincFI);

  // FVU
  x.BeginTag('unitaryValues');
    x.BeginIdent();
    for i := 0 to High(FVU) do
      begin
      s := Format('(%d-%d)', [FVU[i].AnoIni, FVU[i].AnoFim]);
      for j := 1 to 12 do s := s + '|' + toString(FVU[i].Mes[j], 8);
      x.Write('uv', s);
      end;
    x.EndIdent();
  x.EndTag('unitaryValues');

  // FFI
  x.BeginTag('implantationFactories');
    x.BeginIdent();
    for i := 0 to High(FFI) do
      begin
      s := Format('(%d-%d)', [FFI[i].AnoIni, FFI[i].AnoFim]);
      for j := 1 to 12 do s := s + '|' + toString(FFI[i].Mes[j], 8);
      x.Write('if', s);
      end;
    x.EndIdent();
  x.EndTag('implantationFactories');

  // FUD
  x.BeginTag('demandUnits');
    x.BeginIdent();
    for i := 0 to High(FUD) do
      begin
      s := Format('(%d-%d)', [FUD[i].AnoIni, FUD[i].AnoFim]);
      s := s + '|' + toString(FUD[i].Unidade, 8);
      x.Write('du', s);
      end;
    x.EndIdent();
  x.EndTag('demandUnits');
end;

procedure TprClasseDemanda.fromXML(no: IXMLDomNode);
var n: IXMLDomNode;
    i, j: integer;
    s, s1, s2: string;
    SL: TStrings;
begin
  inherited fromXML(no);

  FED   := strToFloat(nextChild(no).Text);
  FFC   := strToFloat(nextChild(no).Text);
  FFR   := strToFloat(nextChild(no).Text);
  FNUCD := nextChild(no).Text;
  FNUD  := nextChild(no).Text;

  FSincronizaDados := strToBoolean(nextChild(no).Text);
  FSincVU := strToBoolean(nextChild(no).Text);
  FSincUD := strToBoolean(nextChild(no).Text);
  FSincFI := strToBoolean(nextChild(no).Text);

  SL := TStringList.Create();

  // FVU
  n := nextChild(no);
  SetLength(FVU, n.childNodes.length);
  for i := 0 to High(FVU) do
    begin
    s := n.childNodes.Item[i].text;

    // leitura dos anos
    SubStrings('-', s1, s2, SubString(s, '(', ')'));
    FVU[i].AnoIni := StrToInt(s1);
    FVU[i].AnoFim := StrToInt(s2);

    // leitura dos meses
    s := System.Copy(s, System.Pos(')', s) + 2, Length(s));
    Split(s, SL, ['|']);
    if SL.Count > 0 then
       for j := 1 to 12 do
         try
           FVU[i].Mes[j] := strToFloat(SL[j-1]);
         except
           FVU[i].Mes[j] := 0;
         end;
    end;

  // FFI
  n := nextChild(no);
  SetLength(FFI, n.childNodes.length);
  for i := 0 to High(FFI) do
    begin
    s := n.childNodes.Item[i].text;

    // leitura dos anos
    SubStrings('-', s1, s2, SubString(s, '(', ')'));
    FFI[i].AnoIni := StrToInt(s1);
    FFI[i].AnoFim := StrToInt(s2);

    // leitura dos meses
    s := System.Copy(s, System.Pos(')', s) + 2, Length(s));
    Split(s, SL, ['|']);
    if SL.Count > 0 then
       for j := 1 to 12 do
         try
           FFI[i].Mes[j] := strToFloat(SL[j-1]);
         except
           FFI[i].Mes[j] := 0;
         end;
    end;

  SL.Free;

  // FUD
  n := nextChild(no);
  SetLength(FUD, n.childNodes.length);
  for i := 0 to High(FUD) do
    begin
    s := n.childNodes.Item[i].text;

    // leitura dos anos e Unidades
    SubStrings('-', s1, s2, SubString(s, '(', ')'));
    FUD[i].AnoIni := StrToInt(s1);
    FUD[i].AnoFim := StrToInt(s2);
    FUD[i].Unidade := strToFloat(System.Copy(s, System.Pos(')', s) + 2, Length(s)));
    end;
end;

{ TprDemanda }

constructor TprDemanda.Create(const Pos: TMapPoint;
                              Projeto: TprProjeto;
                              TabelaDeNomes: TStrings);
begin
  inherited Create(Pos, Projeto, TabelaDeNomes);

  // Somente as classes de demanda devarão salver/ler seus bitmaps
  FSalvarLerBitmap := False;

  FHabilitada      := True;
  FGrupos          := TStringList.Create;
  FCenarios        := TObjectList.Create(False);

  GetMessageManager.RegisterMessage(UM_NOME_OBJETO_MUDOU, self);
  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_OBTEM_DEMANDA_PELA_CLASSE, self);
  GetMessageManager.RegisterMessage(UM_DADOS_DO_ANCESTRAL_MUDARAM, self);
  GetMessageManager.RegisterMessage(UM_HABILITAR_STATUS, self);
  GetMessageManager.RegisterMessage(UM_DESABILITAR_STATUS, self);
  GetMessageManager.RegisterMessage(UM_DESBLOQUEAR_DEMANDAS, self);
  GetMessageManager.RegisterMessage(UM_SET_VAR_DECISAO, self);
end;

destructor TprDemanda.Destroy;
var i: Integer;
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  GetMessageManager.UnRegisterMessage(UM_SET_VAR_DECISAO, self);
  GetMessageManager.UnRegisterMessage(UM_DESBLOQUEAR_DEMANDAS, self);
  GetMessageManager.UnRegisterMessage(UM_DESABILITAR_STATUS, self);
  GetMessageManager.UnRegisterMessage(UM_HABILITAR_STATUS, self);
  GetMessageManager.UnRegisterMessage(UM_OBTEM_DEMANDA_PELA_CLASSE, self);
  GetMessageManager.UnRegisterMessage(UM_DADOS_DO_ANCESTRAL_MUDARAM, self);
  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_NOME_OBJETO_MUDOU, self);

  FGrupos.Free;

  for i := 0 to FCenarios.Count-1 do
    begin
    TprCenarioDeDemanda(FCenarios[i]).AvisarQueVaiSeDestruir := false;
    FCenarios[i].Free();
    end;
  FCenarios.Free;

  inherited Destroy;
end;

function TprDemanda.ConectarObjeto(Obj: THidroComponente): Integer;
begin
  if (Obj is TprCenarioDeDemanda) then
     begin
     FCenarios.Add(Obj);
     TprCenarioDeDemanda(Obj).Demanda := self;
     end;
end;

function TprDemanda.CriarDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_Demanda.Create(nil);
  Result.TN := FTN;
end;

function TprDemanda.ObterPrefixo: String;
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

procedure TprDemanda.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var I1, I2, I3: Integer;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
  if FDialogo <> nil then
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
var s: String;
    o: TObject;
    DM: TprClasseDemanda;
begin
  if MSG.ID = UM_SET_VAR_DECISAO then
     begin
     DM := TprClasseDemanda(MSG.ParamAsObject(0));
     if (DM.Projeto = self.Projeto) and (self.Classe = DM.Nome) then
        self.EQ_Eh_VarDecisao := DM.EQ_Eh_VarDecisao;
     end
  else

  if MSG.ID = UM_DESBLOQUEAR_DEMANDAS then
     begin
     if (MSG.ParamAsObject(0) = self.Projeto) then
        FBloqueado := False;
     end
  else

  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint
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
     if (CompareText(s, FClasse) = 0) and
        (FSincronizaDados) and
        (MSG.ParamAsObject(2) = self.Projeto) then
           Copiar(TprClasseDemanda(MSG.ParamAsObject(1)),
                  False,
                  TStrings(MSG.ParamAsObject(3)));
     end
  else

  if MSG.ID = UM_NOME_OBJETO_MUDOU then
     begin
     o := MSG.ParamAsObject(0);
     if (o is TprClasseDemanda) and (TprClasseDemanda(o).Projeto = self.Projeto) and
        (MSG.ParamAsString(1) = FClasse) then
        FClasse := MSG.ParamAsString(2);
     end
  else

  if MSG.ID = UM_OBJETO_SE_DESTRUINDO then
    {Verifica se o objeto que está se destruindo está conectado a esta Demanda.
     Se está, elimina a referência}
     begin
     o := MSG.ParamAsObject(0);
     if FCenarios.IndexOf(o) > -1 then
        FCenarios.Remove(o);

     {TODO 1 -cProgramacao: cuidar com as referencias as descargas}   
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TprDemanda.Copiar(Demanda: TprClasseDemanda;
                            Criando: Boolean;
                            Dados: TStrings);
begin
  // Associa os dados do parâmetro aos dados desta instância
  if Demanda <> nil then
     begin
     if Demanda is TprClasseDemanda then
        FClasse := Demanda.Nome;

     setModificado(True);

     if Criando then
        begin
        Descricao        := Demanda.Descricao;
        Comentarios.Text := Demanda.Comentarios.Text;
        FLigada          := Demanda.Ligada;
        FHabilitada      := Demanda.Ligada;
        end;

     FPrioridade := Demanda.Prioridade;

     if Sincronizar(cSD_BM, Dados) or Criando then
        Bitmap := Demanda.Bitmap;

     if Sincronizar(cSD_EST, Dados) or Criando then
        Ligada := Demanda.Ligada;

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

     AtualizarHint();
     end;
end;

function TprDemanda.GetBitmapName(): String;
begin
  Result := 'Bitmap ' + FClasse;
end;

function TprDemanda.getVisivel(): Boolean;
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

function TprDemanda.getCenario(i: integer): TprCenarioDeDemanda;
begin
  Result := TprCenarioDeDemanda(FCenarios[i]);
end;

function TprDemanda.getNumCenarios: integer;
begin
  Result := FCenarios.Count;
end;

// As demandas precisam ser inicializadas antes da totalizacao nos PCs.
procedure TprDemanda.PrepararParaSimulacao();
begin
  inherited;
  if getNumCenarios() > 0 then
     getCenario(0).AlimentarDemanda();
end;

procedure TprDemanda.setVarDecisao(const Value: boolean);
begin
  FEQ_Decisao := Value;
end;

procedure TprDemanda.fromXML(no: IXMLDomNode);
var DM: TprClasseDemanda;
begin
  inherited fromXML(no);

  FClasse      := nextChild(no).Text;
  FGrupos.Text := nextChild(no).Text;
  byte(FTipo)  := toInt(nextChild(no).Text);

  DM := FProjeto.ClassesDeDemanda.ClassePeloNome(FClasse);
  if DM <> nil then
     begin
     Bitmap := TBitmap.Create;
     Bitmap.Assign(DM.Bitmap);
     end;
end;

procedure TprDemanda.internalToXML();
var x: TXML_Writer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('DemandClass', FClasse);
  x.Write('Group',       FGrupos.Text);
  x.Write('Type',        ord(FTipo));
end;

function TprDemanda.CriarImagemDoComponente(): TdrBaseShape;
begin
  Result := Inherited CriarImagemDoComponente();
  Result.Visible := True;
end;

{ TprListaDeClassesDemanda }

constructor TprListaDeClassesDemanda.Create();
begin
  Inherited Create();
  FList := TStringList.Create();
end;

destructor TprListaDeClassesDemanda.Destroy;
begin
  FEM := nil;
  Limpar;
  FList.Free;
  Inherited Destroy;
end;

procedure TprListaDeClassesDemanda.Adicionar(DM: TprClasseDemanda);
begin
  FProjeto.FModificado := True;
  FList.AddObject(DM.Nome, DM);
  if assigned(FEM) then FEM(Self);
end;

procedure TprListaDeClassesDemanda.Editar(DM: TprClasseDemanda);
begin
  if FList.IndexOfObject(DM) > -1 then
     begin
     DM.Editar();
     if assigned(FEM) then FEM(Self);
     end;
end;

function TprListaDeClassesDemanda.getClasse(indice: Integer): TprClasseDemanda;
begin
  Result := TprClasseDemanda(FList.Objects[indice]);
end;

function TprListaDeClassesDemanda.GetClasses: Integer;
begin
  Result := FList.Count;
end;

procedure TprListaDeClassesDemanda.RemoverObjeto(indice: Integer);
begin
  FProjeto.FModificado := True;
  TprClasseDemanda(FList.Objects[indice]).Free;
  FList.Delete(indice);
  if assigned(FEM) then FEM(Self);
end;

function TprListaDeClassesDemanda.getBitmap(indice: Integer): TBitmap;
begin
  Result := TprClasseDemanda(FList.Objects[indice]).Bitmap;
end;

procedure TprListaDeClassesDemanda.Limpar;
begin
  While FList.Count > 0 do RemoverObjeto(FList.Count-1);
end;

function TprListaDeClassesDemanda.Remover(DM: TprClasseDemanda): Boolean;
var i: Integer;
    Demandas: TStrings;
begin
  Result := False;
  Demandas := TStringList.Create();
  try
    i := FList.IndexOfObject(DM);
    if i > -1 then
       begin
       ObterDemandasPelaClasse(DM.Nome, Demandas, FProjeto);
       if Demandas.Count = 0 then
          begin
          Gerenciador.RemoverObjeto(DM);
          TfoAreaDeProjeto_Base(FProjeto.AreaDeProjeto).ObjetoSelecionado := nil;
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

function TprListaDeClassesDemanda.ClassePeloNome(const NomeClasse: String): TprClasseDemanda;
var i: Integer;
begin
  i := FList.IndexOf(NomeClasse);
  if i > -1 then
     Result := TprClasseDemanda(FList.Objects[i])
  else
     Result := nil;
end;

procedure TprListaDeClassesDemanda.toXML();
var x: TXML_Writer;
    i: integer;
begin
  x := Applic.getXMLWriter();
  x.BeginTag('demandClasses');

    for i := 0 to FList.count-1 do
      getClasse(i).ToXML();

  x.EndTag('demandClasses');
end;

procedure TprListaDeClassesDemanda.fromXML(no: IXMLDomNode);
var i: Integer;
    c: TprClasseDemanda;
    p: TMapPoint;
begin
  for i := 0 to no.childNodes.length - 1 do
    begin
    p.X := -99;
    c := TprClasseDemanda.Create(p, FProjeto, FProjeto.TabNomes);
    c.fromXML(no.childNodes.item[i]);
    Adicionar(c);
    end;
end;

{ TprProjeto }

function TprProjeto.ReceiveMessage(Const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     if FPlanejaUsuario <> '' then
        begin
        PreparaScript(FPlanejaUsuario, FPlanejaScript);
        FPlanejaScript.Compile();
        end;

     if FRotinaGeralUsuario <> '' then
        begin
        PreparaScript(FRotinaGeralUsuario, FScriptGeral);
        FScriptGeral.Compile();
        end;
     end
  else

  if MSG.ID = UM_LIBERAR_SCRIPTS then
     begin
     FreeAndNil(FPlanejaScript);
     FreeAndNil(FScriptGeral);
     end;

  inherited ReceiveMessage(MSG);
end;

function TprProjeto.CenarioPeloNome(const Nome: String): TprCenarioDeDemanda;
begin
  Result := TprCenarioDeDemanda(ObjetoPeloNome(Nome));
end;

function TprProjeto.TrechoPeloNome(const Nome: String): TprTrechoDagua;
begin
  Result := TprTrechoDagua(ObjetoPeloNome(Nome));
end;

function TprProjeto.DemandaPeloNome(const Nome: String): TprDemanda;
begin
  Result := TprDemanda(ObjetoPeloNome(Nome));
end;

function TprProjeto.SubBaciaPeloNome(const Nome: String): TprSubBacia;
begin
  Result := TprSubBacia(ObjetoPeloNome(Nome));
end;

function TprProjeto.PCPeloNome(const Nome: String): TprPCP;
begin
  Result := TprPCP(ObjetoPeloNome(Nome));
end;

procedure TprProjeto.TerminarSimulacao;
begin
  if FSimulador <> nil then
     begin
     FStatus := sFazendoNada;
     if FSC <> nil then FSC.Stop();
     FSimulador.Terminate();
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

{O método a seguir tem por objetivo determinar um valor que sirva para avaliação da
 performance do sistema.}
function TprProjeto.CalcularFuncaoObjetivo(): Real;
begin
  FValorFO := 0;
  Result := FValorFO;
end;

constructor TprProjeto.Create(TabelaDeNomes: TStrings);
begin
  inherited Create(TabelaDeNomes, nil);
  FProjeto := Self;

  //FScripts := TStringList.Create;

  GetMessageManager.RegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.RegisterMessage(UM_LIBERAR_SCRIPTS, self);

  FPCs  := TprListaDePCs.Create;

  // Inicia o objeto responsável pelas classes de demanda
  FClasDem               := TprListaDeClassesDemanda.Create;
  FClasDem.Projeto       := Self;
  FClasDem.TabelaDeNomes := TabelaDeNomes;

  FInts := TprListaDeIntervalos.Create;
  FInts.FProjeto := self;

  FTS      := tsWIN;
  FPropDOS := 'PropDOS0';
  FNF := 50;

  // Armazena os objetos criados pelo PascalScript
  FGlobalObjects := TGlobalObjects.Create();

  // Gerador de Equações
  FEQB := TEquationBuilder.Create(self);

  // Variaveis otimizadas
  FVariaveis :=  Solver.Classes.TVariableList.Create();
end;

destructor TprProjeto.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.UnRegisterMessage(UM_LIBERAR_SCRIPTS, self);
  FVariaveis.Free();
  FPCs.Free;
  FClasDem.Free;
  FInts.Free;
  FEQB.Free;
  FGlobalObjects.Free;
  inherited Destroy;
end;

function TprProjeto.CriarDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_Projeto.Create(nil);
  Result.TN := FTN;
end;

function TprProjeto.IntervaloParaData(Intervalo: integer): TRec_prData;
var i, ii : Integer;
    x: Real;
begin
  // acha os Intervalos acumulados se necessário
  for i := 0 to High(FAnos) do
    begin
    ii := FAnos[i].AnoFim - FAnos[i].AnoIni + 1;
    if i = 0 then
       FAnos[i].dtAcum := ii * getTAIS
    else
       FAnos[i].dtAcum := FAnos[i-1].dtAcum + ii * getTAIS
    end;

  // acha o intervalo atual do Intervalo.
  for i := 0 to High(FAnos) do
    if Intervalo <= FAnos[i].dtAcum then
       Break;

  if i = 0 then ii := 0 else ii := FAnos[i-1].dtAcum;
  x := (Intervalo - ii - 1) / getTAIS + 1E-12;
  Result.Mes := Trunc(Frac(x) * 12) + 1;
  Result.Ano := Trunc(x) + FAnos[i].AnoIni;
end;

// retorna o número total de anos de execução
function TprProjeto.getNumAnos(): Integer;
var i: Integer;
begin
  Result := 0;
  for i := 0 to High(FAnos) do
    inc(Result, FAnos[i].AnoFim - FAnos[i].AnoIni + 1);
end;

// retorna o número total de intervalos de simulação em um ano
function TprProjeto.getTAIS(): Integer;
begin
  Result := ord(FIntSim);
  if Result > -1 then
     Result := caNumIntSimAno[FIntSim]
end;

// retorna o número total de intervalos de simulação
function TprProjeto.getTIS(): Integer;
begin
  Result := getNumAnos() * getTAIS();
end;

// retorna o número total de intervalos de simulação em um mês
function TprProjeto.getTMIS(): Integer;
begin
  Result := caNumIntSimMes[FIntSim];
end;

procedure TprProjeto.MostrarIntervalos();
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
    FIntSim    := TEnumIntSim(cbIntSim.ItemIndex);

    FDirSai    := edDirSai.Text;
    FDirPes    := edDirPes.Text;

    FNF        := edNF.AsFloat;

    SetLength(FAnos, mAnos.Lines.Count);
    for i := 0 to High(FAnos) do
      begin
      s := mAnos.Lines[i];
      SubStrings('-', s1, s2, s);
      FAnos[i].AnoIni := strToInt(allTrim(s1));
      FAnos[i].AnoFim := strToInt(allTrim(s2));
      end;

    FPropDOS  := cbPropDos.Items[cbPropDos.ItemIndex];
    FTS       := TEnumTipoSimulacao(rbTipoSimulacao.Checked); // 0 = DOS

    FTotal_IntSim := getTIS;

    FPlanejaUsuario     := Rotinas.edPlanejaUsuario.Text;
    FRotinaGeralUsuario := Rotinas.edGeralUsuario.Text;
    FOperaUsuario       := Rotinas.edOperaUsuario.Text;
    FEnergiaUsuario     := Rotinas.edEnergiaUsuario.Text;

    // Opcoes de interface ...

    if rbOI_AbrirDialogo.Checked then
       FAcaoDoDuploClickNosComponentes := 0;

    if rbOI_ExecutarScript.Checked then
       FAcaoDoDuploClickNosComponentes := 1;

    if rbOI_NavInterno.Checked then
       FNavHTML := 0;

    if rbOI_NavSO.Checked then
       FNavHTML := 1;

    FPermitirVazoesNegativasNasSubBacias := rbPVN_SBs.Checked;
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

    edDirSai.Text    := FDirSai;
    edDirPes.Text    := FDirPes;
    edNF.AsFloat     := FNF;

    cbIntSim.ItemIndex := ord(FIntSim);

    cbPropDos.Items.Clear();
    for i := 0 to 9 do
      if FileExists(Applic.appDir + 'PropDOS' + intToStr(i) + '.EXE') then
         cbPropDos.Items.Add('PropDOS' + intToStr(i));

    i := cbPropDos.Items.IndexOf(FPropDOS);
    if i <> -1 then cbPropDos.ItemIndex := i else cbPropDos.ItemIndex := 0;

    rbTipoSimulacao.Checked := Boolean(FTS);
    rbDOS.Checked := not Boolean(FTS);

    Rotinas.edPlanejaUsuario.Text := FPlanejaUsuario;
    Rotinas.edGeralUsuario.Text   := FRotinaGeralUsuario;
    Rotinas.edOperaUsuario.Text   := FOperaUsuario;
    Rotinas.edEnergiaUsuario.Text := FEnergiaUsuario;

    // Opcoes de interface ...

    if FAcaoDoDuploClickNosComponentes = 0 then
       rbOI_AbrirDialogo.Checked := true;

    if FAcaoDoDuploClickNosComponentes = 1 then
       rbOI_ExecutarScript.Checked := true;

    if FNavHTML = 0 then
       rbOI_NavInterno.Checked := true;

    if FNavHTML = 1 then
       rbOI_NavSO.Checked := true;

    rbPVN_SBs.Checked := FPermitirVazoesNegativasNasSubBacias;
    end;
end;

procedure TprProjeto.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
var i1, i2, i3 : Integer;
    s1, s2, s3 : String;
    PU, DU, OU, EU : String;
    TS : TEnumTipoSimulacao;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
  if FDialogo <> nil then
     begin
     i1 := TprDialogo_Projeto(FDialogo).mAnos.Lines.Count;
     i2 := TprDialogo_Projeto(FDialogo).cbIntSim.ItemIndex;

     s1 := allTrim(TprDialogo_Projeto(FDialogo).edDirSai.Text);
     s2 := allTrim(TprDialogo_Projeto(FDialogo).edDirPes.Text);

     i3 := TprDialogo_Projeto(FDialogo).cbPropDos.ItemIndex;
     s3 := allTrim(TprDialogo_Projeto(FDialogo).cbPropDos.Items[i3]);

     PU := TprDialogo_Projeto(FDialogo).Rotinas.edPlanejaUsuario.Text;
     DU := TprDialogo_Projeto(FDialogo).Rotinas.edGeralUsuario.Text;
     OU := TprDialogo_Projeto(FDialogo).Rotinas.edOperaUsuario.Text;
     EU := TprDialogo_Projeto(FDialogo).Rotinas.edEnergiaUsuario.Text;

     TS := TEnumTipoSimulacao(TprDialogo_Projeto(FDialogo).rbTipoSimulacao.Checked);
     end
  else
     begin
     i1 := Length(FAnos);
     i2 := ord(FIntSim);
     s1 := allTrim(FDirSai);
     s2 := allTrim(FDirPes);
     s3 := allTrim(FPropDos);
     PU := FPlanejaUsuario;
     DU := FRotinaGeralUsuario;
     OU := FOperaUsuario;
     EU := FEnergiaUsuario;
     TS := FTS;
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

  if (TS = tsDOS) and not FileExists(Applic.appDir + s3 + '.exe') then
     begin
     DialogoDeErros.Add(etError,
     Format('Projeto: %s'#13 +
            'Tipo de Simulação: Propagar DOS'#13 +
            'Erro: Ausência do Executável "%s"', [Nome, s3]));
     TudoOk := False;
     end;

  VerificaRotinaUsuario(PU, 'Planeja', Completo, TudoOk, DialogoDeErros);
  VerificaRotinaUsuario(DU, 'Debug'  , Completo, TudoOk, DialogoDeErros);
  VerificaRotinaUsuario(OU, 'Opera'  , Completo, TudoOk, DialogoDeErros);
  VerificaRotinaUsuario(EU, 'Energia', Completo, TudoOk, DialogoDeErros);
end;

// Proc. auxiliar para retorno das subBacias de um projeto
procedure Proc_ObtemSubBacias(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList = nil);
begin
  Lista.Add(SB);
end;

// Proc. auxiliar para retorno dos QAs de um projeto
procedure Proc_ObtemQAs(Projeto: TprProjeto; QA: TprQualidadeDaAgua; Lista: TList = nil);
begin
  Lista.Add(QA);
end;

// Proc. auxiliar para retorno dos Cenarios de Demandas de um projeto
procedure Proc_ObtemCenarios(Projeto: TprProjeto; CN: TprCenarioDeDemanda; Lista: TList = nil);
begin
  Lista.Add(CN);
end;

// Proc. auxiliar para retorno dos Cenarios de Demandas de um projeto
procedure Proc_ObtemDemandas(Projeto: TprProjeto; DM: TprDemanda; Lista: TList = nil);
begin
  Lista.Add(DM);
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

procedure TprProjeto.PercorreQAs(ITQA: TProcPQA; Lista: TList = nil);
var i: Integer;
begin
  i := 0;
  GetMessageManager.SendMessage(UM_RESET_VISIT, [@i]);
  for i := 0 to PCs.PCs-1 do
    if not PCs[i].Visitado then
       begin
       if PCs[i].QualidadeDaAgua <> nil then
          ITQA(Self, PCs[i].QualidadeDaAgua, Lista);
       PCs[i].Visitado := True;
       end;
  {TODO 1 -cProgramacao: (PercorreQAs) Percorrer Demandas}
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

procedure TprProjeto.PercorreCenarios(ITCN: TProcPCN; Lista: TList = nil);
var i, j: Integer;
    L: TList;
    DM: TprDemanda;
begin
  L := ObtemDemandas();
  for i := 0 to L.Count-1 do
    begin
    DM := TprDemanda(L[i]);
    for j := 0 to DM.NumCenarios-1 do
      ITCN(self, DM.Cenario[j], Lista);
    end;
  L.Free;
end;

// Retorna as demandas de um projeto
function TprProjeto.ObtemDemandas(): TList;
begin
  Result := TList.Create;
  PercorreDemandas(Proc_ObtemDemandas, Result);
end;

// Retorna os Cenarios de um projeto
function TprProjeto.ObtemCenarios(): TList;
begin
  Result := TList.Create;
  PercorreCenarios(Proc_ObtemCenarios, Result);
end;

// Retorna as QAs de um projeto
function TprProjeto.ObtemQAs(): TList;
begin
  Result := TList.Create();
  PercorreQAs(Proc_ObtemQAs, Result);
end;

// Retorna as subBacias de um projeto
function TprProjeto.ObtemSubBacias(): TList;
begin
  Result := TList.Create;
  PercorreSubBacias(Proc_ObtemSubBacias, Result);
end;

procedure TprProjeto.ExecutarRotinaGeral();
begin
  if FRotinaGeralUsuario <> '' then
     begin
     FAreaDeProjeto.Caption := 'Executando a Rotina Geral do Usuário. Aguarde ...';
     AtualizaPontoExecucao(FNome + '.ScriptGeral', FScriptGeral);
     FScriptGeral.Execute();
     AtualizaPontoExecucao('', nil);
     end;
end;

procedure TprProjeto.TratarEventoDeProgressoDaSimulacao(Sender: TObject; out EventID: Integer);
begin
  inc(FIntervalo);
end;

{O método a seguir faz o planejamento da distribuição de água em função de regras
 fornecidas pelo usuário no inicio de cada intervalo de tempo}
procedure TprProjeto.Planeja();
var i: Integer;
    PC: TprPCP;
begin
  AtualizaPontoExecucao(FNome + '.Planeja', nil);

  // Rotina míope - é o planejamento utilizado caso o usuário não programe nada
  for i := 0 to FPCs.PCs-1 do
    begin
    PC := TprPCP(FPCs[i]);
    PC.DemPriPlanejada[FIntervalo] := PC.DemPriTotal[FIntervalo];
    PC.DemSecPlanejada[FIntervalo] := PC.DemSecTotal[FIntervalo];
    PC.DemTerPlanejada[FIntervalo] := PC.DemTerTotal[FIntervalo];
    if PC is TprPCPR then
       TprPCPR(PC).DefluvioPlanejado[FIntervalo] := 0;
    end;

  if FPlanejaUsuario <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.ScriptPlaneja', FPlanejaScript);
     FPlanejaScript.Execute();
     AtualizaPontoExecucao('', nil);
     end;
end;

procedure MonitorarSBs(Projeto: TprProjeto; SB: TprSubBacia; Lista: TList = nil);
begin
  SB.Monitorar;
end;

// Este método (evento) é disparado automaticamente após o evento de relógio do
// simulador, neste caso Temporizador_1 que incrementa o relógio.
// Executa uma simulação na rede para o intervalo de simulação Projeto.Intervalo
procedure TprProjeto.TratarEventosDaSimulacao(Sender: TObject; const EventID: Integer);
var i: Integer;
begin
  if FIntervalo > FIntervalosSim then
     begin
     FSimulador.Terminate();
     Exit;
     end;

  {O método a seguir faz o planejamento da distribuição de água em função de regras
   fornecidas pelo usuário no inicio de cada intervalo de tempo}
  Planeja(); {metodo do projeto, devera ser interpretado ou padrao}

  {Dentro do intervalo de tempo todos os PCs são percorridos em ordem hierárquica
   para que se faça o Balanço Hídrico de cada um e o atendimento das Demandas}
   for i := 0 to FPCs.PCs-1 do
    FPCs.PC[i].BalancoHidrico();

  {O método a seguir tem por objetivo determinar um valor que sirva para avaliação da
   performance do sistema.}
   CalcularFuncaoObjetivo();

  // Motirocao dos Objetos
  if AP(AreaDeProjeto).Monitor.Visible then
     begin
     for i := 0 to FPCs.PCs-1 do
       FPCs.PC[i].Monitorar;
     PercorreSubBacias(MonitorarSBs, nil);
     end;
end;

function TprProjeto.ObterSubRede(PC: TprPCP; AteOsReservatorios: Boolean): TStrings;
var Temp: TList;

  // Percorre recursivemente os PCs a Montantedp PC passado como parâmetro
  procedure Processar(PC: TprPCP);
  var i: Integer;
  begin
    Temp.Add(PC);
    if AteOsReservatorios then
       if not (PC is TprPCPR) then // Para quando encontrar um reservatorio
          for i := 0 to PC.PCs_aMontante-1 do
            Processar(TprPCP(PC.PC_aMontante[i]))
    else
       for i := 0 to PC.PCs_aMontante-1 do
         Processar(TprPCP(PC.PC_aMontante[i]));
  end;

var i: Integer;
begin
  Result := TStringList.Create();
  Temp := TList.Create();

  Processar(PC);

  // Organiza os PCs da Sub-arvore de acordo com os PCs que ja estao
  // organizados hierarquicamente
  for i := 0 to PCs.PCs-1 do
    if Temp.IndexOf(PCs[i]) > -1 then
       Result.AddObject(PCs[i].Nome, PCs[i]);

  Temp.Free();
end;

procedure TprProjeto.RealizarBalancoHidricoAte(PC: TprPCP;
                                               AteOsReservatorios: Boolean);
var i: Integer;
    SubRede: TStrings;
begin
  SubRede := ObterSubRede(PC, AteOsReservatorios);

  for i := 0 to SubRede.Count-1 do
    TprPCP(SubRede.Objects[i]).BalancoHidrico();

  SubRede.Free();
end;

procedure TprProjeto.ExecutarSimulacao();
var Erro1, Erro2, PE1, PE2, s: String;
begin
  if FSimulador = nil then
     if RealizarDiagnostico(True) then
        try
          // Durante a inicialização este campo pode se tornar falso
          // devido a algum erro.
          FProntoParaSimular := true;

          IniciarSimulacao(TratarEventosDaSimulacao);
          if Assigned(FEvento_InicioSimulacao) then FEvento_InicioSimulacao(Self);

          // Ordena os PCs por Hierarquia
          FPCs.CalcularHierarquia();
          FPCs.Ordenar();

          // Inicia os objetos da rede
          // Ex: Inicializacao das Tabelas de Demandas
          GetMessageManager.SendMessage(UM_INICIAR_SIMULACAO, [self]);

          // Totaliza as demandas para cada PC
          FPCs.TotalizarDemandas();

          // Inicia a simulação
          if FProntoParaSimular then
             begin
             if AP(AreaDeProjeto).Monitor.Visible then
                AP(AreaDeProjeto).Monitor.Limpar();

             Erro1 := ''; Erro2 := ''; PE1 := ''; PE2 := '';
             try
                try
                  FSimulador.Resume();
                  FExecutouSimulacao := true;
                except
                  on E: Exception do
                     begin
                     Erro1 := E.Message;
                     PE1   := FEC;
                     end;
                end;
             finally
                try
                  ExecutarRotinaGeral();
                except
                  on E: Exception do
                     begin
                     Erro2 := E.Message;
                     PE2   := FEC;
                     end;
                  end;
               end;

             end; // if FProntoParaSimular then

        finally
          FreeAndNil(FSimulador);
          FinalizarSimulacao();

          if Assigned(FEvento_FimSimulacao) then FEvento_FimSimulacao(Self);

          if (PE1 <> '') or (PE2 <> '') then
             begin
             s := 'A simulação não foi finalizada.'#13 +
                  'Intervalo: ' + toString(FIntervalo) + #13;

             if PE1 <> '' then
                begin
                s := s + 'Ponto de Execução: ' + PE1 + #13#13 + Erro1;
                end;

             if PE2 <> '' then
                begin
                if PE1 <> '' then s := s + #13;
                s := s + 'Ponto de Execução: ' + PE2 + #13#13 + Erro2;
                end;

             s := s + #13 + StringOfChar('-', 100);
             MessageDLG(s, mtError, [mbOk], 0);
             end;
        end
     else
        gErros.Show;
end;

procedure TprProjeto.Executar();
begin
  if FTS = tsWIN then
     try
       FStatus := sSimulando;
       GetMessageManager.SendMessage(UM_PREPARAR_SCRIPTS, [self]);
       ExecutarSimulacao();
     finally
       GetMessageManager.SendMessage(UM_LIBERAR_SCRIPTS, [self]);
       FStatus := sFazendoNada;
     end
  else
     begin
     ExecutarPropagarDOS();
     
     // Totaliza as demandas após o Propagar DOS ser executado
     // para comparação com as demandas atendidas
     PCs.TotalizarDemandas();
     end;
end;

// Faz a leitura de cada um dos arquivos do PropagarDOS
procedure TprProjeto.LeArquivosDoPropagarDOS();
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
       TprPCP(PCs[i]).CalculaVzMon_e_AfluenciaSB();

    // Le as Vazões Defluentes de cada PC
    s := ArqVazoes;
    VerificaCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do
         LeDados(TprPCP(PCs[i]).Defluencia, PCs[i].Nome);
       end;

    // Le as Demandas Primárias Atendidas
    s := ArqDPS;
    VerificaCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do
         LeDados(TprPCP(PCs[i]).DemPriAtendida, PCs[i].Nome);
       end;

    // Le os dados de Demandas Secundárias Atendidas
    s := ArqDSS;
    VerificaCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do
         LeDados(TprPCP(PCs[i]).DemSecAtendida, PCs[i].Nome);
       end;

    // Le os dados de Demandas Terciárias Atendida
    s := ArqDTS;
    VerificaCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do
         LeDados(TprPCP(PCs[i]).DemTerAtendida, PCs[i].Nome);
       end;

    // Le os dados de Volumes dos Reservatórios se existirem
    s := ArqAR;
    VerificaCaminho(s);
    if FileExists(s) then
       begin
       SL.LoadFromFile(s);
       for i := 0 to PCs.PCs-1 do
         if PCs[i] is TprPCPR then
            LeDados(TprPCPR(PCs[i]).Volume, PCs[i].Nome);
       end;

    // Le os dados de Energia Gerada dos Reservatórios se existirem
    s := ArqEG;
    VerificaCaminho(s);
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

procedure TprProjeto.MostraMatrizDeContribuicao;
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
           p.Col := PCs.IndiceDo(TprPC(SB.PCs.Objeto[j])) + 1;
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

procedure TprProjeto.MostraFalhasNoAtendimentoDasDemandas;
var D: TprDialogo_Planilha_FalhasDasDemandas;
begin
  D := TprDialogo_Planilha_FalhasDasDemandas.Create(AreaDeProjeto);
  D.Caption := ' Falhas no Atendimento das Demandas';
  D.PCs := PCs;
  D.Show;
end;

procedure TprProjeto.EscreveAnosNoEditor(Book: TBook; Const Ident: String = '');
var i, j : Integer;
    s    : String;
begin
  for i := 0 to High(AnosDeExecucao) do
    begin
    s := Ident;
    for j := AnosDeExecucao[i].AnoIni to AnosDeExecucao[i].AnoFim do
      s := s + intToStr(j) + ' ';
    Book.TextPage.Write(s);
    end;
end;

procedure TprProjeto.SetFundo(Value: String);
var s, s1: String;
    Bmp: TBitmap;
begin
  if Value <> '' then
     begin
     s  := ExtractFilePath(NomeArquivo);
     s1 := ExtractFileName(Value);
     {
     if not PossuiCaminho(Value) then
        Value := s + Value;

     if not FileExists(Value) then
        Value := DirPes + s1;
     }
     setCurrentDir(s);
     Value := ExpandFilename(Value);

     if FileExists(Value) then
        try
          Bmp := TBitmap.Create();
          Bmp.LoadFromFile(Value);

          // virtual
          SetBackgroundBitmap(Bmp);
          {
          if CompareText(s, ExtractFilePath(Value)) = 0 then
             FArqFundo := s1
          else
             FArqFundo := Value;
          }
          FArqFundo := Value;
          RetiraCaminhoSePuder(FArqFundo);

          FModificado := True;
        except
          Bmp.Free();
          Bmp := nil;
          FArqFundo := '';
          SetBackgroundBitmap(nil);
        end
     else
        raise Exception.Create('Arquivo de imagem não encontrado'#13 + Value);
     end
  else
     begin
     //FFundoBmp.Free();
     //FFundoBmp := nil;
     FArqFundo := '';
     SetBackgroundBitmap(nil);
     FModificado := True;
     end;
end;

procedure TprProjeto.ExecutarPropagarDOS(NomeArquivo: String = '');
var i, j           : Integer;
    d1, d2, d3     : Integer;
    s , s1, s2     : String;
    Entrada, Saida : String;
    R              : TprPCPR;
    DM             : TprDemanda;
    Exec           : TExecFile;
    book           : TBook;
begin
  if FSimulador <> nil then Exit;

  if DirSai = '' then
     begin
     FDirSaida := ExtractFilePath(FNomeArquivo) + 'Saida\';
     if not DirectoryExists(FDirSaida) then ForceDirectories(FDirSaida);
     end;

  FPCs.Ordenar();

  book := Applic.NewBook('Projeto: ' + self.Nome + '  (' + TimeToStr(Time) + ')');
  book.NewPage('memo', 'ENT');

  book.TextPage.Write(aspa + Descricao + aspa);
  book.TextPage.Write(aspa + StringsToString(Comentarios) + aspa);
  book.TextPage.Write(intToStr(NumAnosDeExecucao));
  EscreveAnosNoEditor(book);
  book.TextPage.Write(intToStr(Total_IntSim) + '  ' + intToStr(PCs.PCs));

  for i := 0 to PCs.PCs-1 do book.TextPage.Write(aspa + PCs.PC[i].Nome + aspa);
  s := '';
  for i := 0 to PCs.PCs-1 do
    begin
    if i > 0 then s := s + ', ';
    s := s + intToStr(PCs.PC[i].Hierarquia);
    end;
  book.TextPage.Write(s);

  s := '';
  for i := 0 to PCs.PCs-1 do
    begin
    if i > 0 then s := s + ', ';
    s := s + intToStr(PCs.PC[i].PCs_aMontante);
    end;
  book.TextPage.Write(s);

  s := '';
  for i := 0 to PCs.PCs-1 do
    s := s + {TprPCP(PCs.PC[i]).CRC}'321' + ' ';
  book.TextPage.Write(s);

  s := '';
  for i := 0 to PCs.PCs-1 do
    if PCs.PC[i].Hierarquia > 1 then
       begin
       s := '';
       for j := 0 to PCs.PC[i].PCs_aMontante-1 do
         s := s + intToStr(PCs.IndiceDo(PCs.PC[i].PC_aMontante[j])+1) + ' ';
       book.TextPage.Write(s);
       end;

  book.TextPage.Write(GerarArquivoDeVazoes);
  book.TextPage.Write(GerarArquivoDeDemandasDifusas);
  book.TextPage.Write(GerarArquivoDeDemanda(pdPrimaria));
  book.TextPage.Write(GerarArquivoDeDemanda(pdSecundaria));
  book.TextPage.Write(GerarArquivoDeDemanda(pdTerciaria));
  book.TextPage.Write(GerarArquivoDosReservatorios('PLU'));
  book.TextPage.Write(GerarArquivoDosReservatorios('ETP'));

  book.TextPage.Write('3');

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
  book.TextPage.Write(s);
  book.TextPage.Write(s1);
  book.TextPage.Write(s2);

  if DirSai <> '' then
     s := ExtractShortPathName(DirSai)
  else
     s := ExtractShortPathName(FDirSaida);

  ArqVazoes := GetTempFile(s, 'Vaz');
  book.TextPage.Write(aspa + ArqVazoes + aspa);

  ArqDPS := GetTempFile(s, 'DPS');
  book.TextPage.Write(aspa + ArqDPS + aspa);

  ArqDSS := GetTempFile(s, 'DSS');
  book.TextPage.Write(aspa + ArqDSS + aspa);

  ArqDTS := GetTempFile(s, 'DTS');
  book.TextPage.Write(aspa + ArqDTS + aspa);

  ArqAR := GetTempFile(s, 'AR');
  book.TextPage.Write(aspa + ArqAR + aspa);

  ArqEG := GetTempFile(s, 'EG');
  book.TextPage.Write(aspa + ArqEG + aspa);

  s := ''; s1 := ''; s2 := '';
  for i := 0 to PCs.PCs-1 do
    if PCs.PC[i] is TprPCPR then
       begin
       s  := s  + toString(TprPCPR(PCs.PC[i]).VolumeMinimo, 8) + ' ';
       s1 := s1 + toString(TprPCPR(PCs.PC[i]).VolumeMaximo, 8) + ' ';
       s2 := s2 + toString(TprPCPR(PCs.PC[i]).VolumeInicial, 8) + ' ';
       end
    else
       begin
       s := s + '0.0 '; s1 := s1 + '0.0 '; s2 := s2 + '0.0 ';
       end;
  book.TextPage.Write(s);
  book.TextPage.Write(s1);
  book.TextPage.Write(s2);

  for i := 0 to PCs.PCs-1 do
    if PCs.PC[i] is TprPCPR then
       begin
       R := (PCs.PC[i] as TprPCPR);
       s := ''; s1 := '';
       book.TextPage.Write(intToStr(R.PontosAV));
       for j := 0 to R.PontosAV - 1 do
         begin
         s  := s  + toString(R.AV[j].Area, 8) + ' ';
         s1 := s1 + toString(R.AV[j].Vol, 8) + ' ';
         end;
       book.TextPage.Write(s);
       book.TextPage.Write(s1);

       s := ''; s1 := '';
       book.TextPage.Write(intToStr(R.PontosCV));
       for j := 0 to R.PontosCV - 1 do
         begin
         s  := s  + toString(R.CV[j].Cota, 8) + ' ';
         s1 := s1 + toString(R.CV[j].Vol, 8) + ' ';
         end;
       book.TextPage.Write(s);
       book.TextPage.Write(s1);
       end;
  book.TextPage.Write(toString(NivelDeFalha));

  {$IFNDEF DEBUG}
  if NomeArquivo = '' then
     if DirSai <> '' then
        NomeArquivo := GetTempFile(DirSai, 'APR')
     else
        NomeArquivo := GetTempFile(FDirSaida, 'APR');

  Entrada := ChangeFileExt(NomeArquivo, '.ENT');
  Saida   := ChangeFileExt(NomeArquivo, '.SAI');

  book.TextPage.SaveToFile(Entrada);

  {$IFDEF NomesCurtos}
  // O arquivo ja devera existir para que possamos extrair seu nome curto
  Entrada := ExtractShortPathName(Entrada);
  {$ENDIF}

  Exec := TExecFile.Create(nil);
  Exec.Wait := True;
  Exec.CommandLine := Applic.appDir + PropDOS + '.exe';
  Exec.Parameters := Entrada + ' ' + Saida;
  try
    if MessageDlg('Executar o Propagar DOS ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
       if Exec.Execute() then
          begin
          LeArquivosDoPropagarDOS();
          if FileExists(Saida) then
             begin
             MessageDLG('A simulação ocorreu com sucesso.', mtInformation, [mbOK], 0);
             book.NewPage('rtf', 'SAI');
             book.TextPage.LoadFromFile(Saida);
             end;
          book.Show();
          end;
  finally
    Exec.Free();
  end;
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
function TprProjeto.GerarArquivoDeVazoes(): String;
var PC          : TprPC;         // PC atual
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

  SL := TStringList.Create();

  // Aloca memória para os dois vetores usados nos cálculos
  QD := TwsDFVec.Create(Total_IntSim);
   D := TwsDFVec.Create(Total_IntSim);

  try
    // Inicializa as vazões de Todas as Sub-Bacias
    for i := 0 to PCs.PCs-1 do
      for j := 0 to PCs.PC[i].SubBacias-1 do
        PCs.PC[i].SubBacia[j].LiberarVazoes();

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
        Vx.Free();

        // para todas as Demandas de uma Sub-Bacia
        for k := 0 to SB.Demandas-1 do
          if SB.Demanda[k].Ligada and SB.Demanda[k].Habilitada then
             begin
             DM := SB.Demanda[k]; // pega a Demanda Atual

             // Calculo temporario
             x := SB.Area * CC * DM.FatorDeConversao;

             // calcula manualmente o vetor D de cada Demanda e vai acumulando-o
             for dt := 1 to Total_IntSim do
               begin
               //FDeltaT := dt;
               DM.Data := self.IntervaloParaData(dt);
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
    SL.Free();
    D.Free();
    QD.Free();
    for i := 0 to PCs.PCs-1 do
      for j := 0 to PCs.PC[i].SubBacias-1 do
        PCs.PC[i].SubBacia[j].LiberarVazoes();
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
var PC          : TprPC;         // PC atual
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
             //FDeltaT := dt;
             DM.Data := self.IntervaloParaData(dt); 
             D[dt] := D[dt] + DM.UnidadeDeConsumo * DM.UnidadeDeDemanda *
                              DM.FatorDeConversao * DM.FatorDeImplantacao * DM.EscalaDeDesenvolvimento;
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
    SL.Free();
    D.Free();
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
         VerificaCaminho(s);
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

{ TprListaDeFalhas }

// DR  : Demanda de Referência
// DA  : Demanda Atendida
// NFC : Nível Crítico de Falha
function TprListaDeFalhas.Adicionar(Tipo: TEnumPriorDemanda;
                                    Intervalo: Integer;
                                    const DR, DA, NCF: Real): Integer;

var SL: TStrings;
    i: Integer;
    s: String;
    F: TprFalha;
begin
  SL := PegaFalhas(Tipo);
  //FProjeto.Intervalo := Intervalo;
  s := IntToStr(FProjeto.IntervaloParaData(Intervalo).Ano);
  i := SL.IndexOf(s);
  if i = -1 then
     SL.AddObject(s, TprFalha.Create(FProjeto.IntervaloParaData(Intervalo).Ano, Intervalo, DR, DA, NCF))
  else
     begin
     F := TprFalha(SL.Objects[i]);
     F.Intervalos.Add(Intervalo);
     F.DemsRef.Add(DR);
     F.DemsAten.Add(DA);
     F.IntervalosCriticos.Add(DA < DR * NCF);
     end;
end;

constructor TprListaDeFalhas.Create(Projeto: TprProjeto);
begin
  inherited Create;
  FProjeto   := Projeto;
  FFalhasPri := TStringList.Create;
  FFalhasSec := TStringList.Create;
  FFalhasTer := TStringList.Create;
end;

destructor TprListaDeFalhas.Destroy;
var i: Integer;
begin
  for i := 0 to FFalhasPri.Count-1 do TprFalha(FFalhasPri.Objects[i]).Free;
  for i := 0 to FFalhasSec.Count-1 do TprFalha(FFalhasSec.Objects[i]).Free;
  for i := 0 to FFalhasTer.Count-1 do TprFalha(FFalhasTer.Objects[i]).Free;
  FFalhasPri.Free();
  FFalhasSec.Free();
  FFalhasTer.Free();
  inherited Destroy;
end;

function TprListaDeFalhas.FalhaPeloAno(Tipo: TEnumPriorDemanda; Const Ano: String): TprFalha;
var SL: TStrings;
    i: Integer;
begin
  SL := PegaFalhas(Tipo);
  i := SL.IndexOf(Ano);
  if i > -1 then Result := TprFalha(SL.Objects[i]) else Result := nil;
end;

function TprListaDeFalhas.AnosCriticos(Tipo: TEnumPriorDemanda): Integer;
var SL: TStrings;
    i: Integer;
    F: TprFalha;
begin
  SL := PegaFalhas(Tipo);
  Result := 0;
  for i := 0 to SL.Count-1 do
    begin
    F := TprFalha(SL.Objects[i]);
    if F.FalhaCritica then inc(Result);
    end;
end;

function TprListaDeFalhas.getFalhaPri(i: Integer): TprFalha;
begin
  Result := TprFalha(FFalhasPri.Objects[i]);
end;

function TprListaDeFalhas.getFalhaSec(i: Integer): TprFalha;
begin
  Result := TprFalha(FFalhasSec.Objects[i]);
end;

function TprListaDeFalhas.getFalhaTer(i: Integer): TprFalha;
begin
  Result := TprFalha(FFalhasTer.Objects[i]);
end;

function TprListaDeFalhas.getNumFalhasPri: Integer;
begin
  Result := FFalhasPri.Count;
end;

function TprListaDeFalhas.getNumFalhasSec: Integer;
begin
  Result := FFalhasSec.Count;
end;

function TprListaDeFalhas.getNumFalhasTer: Integer;
begin
  Result := FFalhasTer.Count;
end;

function TprListaDeFalhas.IntervalosTotais(Tipo: TEnumPriorDemanda): Integer;
var SL: TStrings;
    i: Integer;
    F: TprFalha;
begin
  SL := PegaFalhas(Tipo);
  Result := 0;
  for i := 0 to SL.Count-1 do
    begin
    F := TprFalha(SL.Objects[i]);
    inc(Result, F.Intervalos.Count);
    end;
end;

function TprListaDeFalhas.MostrarFalhas: TForm;
var d: TprDialogo_FalhasDeUmPC;
begin
  d := TprDialogo_FalhasDeUmPC.Create(Applic);
  d.Falhas := Self;
  d.Show;
  Result := d;
end;

function TprListaDeFalhas.PegaFalhas(Tipo: TEnumPriorDemanda): TStrings;
begin
  Case Tipo of
    pdPrimaria   : Result := FFalhasPri;
    pdSecundaria : Result := FFalhasSec;
    pdTerciaria  : Result := FFalhasTer;
    end;
end;

function TprListaDeFalhas.IntervalosCriticos(Tipo: TEnumPriorDemanda): Integer;
var SL: TStrings;
    i, j, FC: Integer;
    F: TprFalha;
begin
  SL := PegaFalhas(Tipo);
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
var pc, pc1, pc2: TprPC;
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

function TprProjeto.op_getValue(const PropName: string; i1, i2: Integer): real;
begin
  if CompareText(PropName, 'NivelDeFalha') = 0 then
     Result := FNF else

  Result := inherited op_getValue(PropName, i1, i2);
end;

procedure TprProjeto.op_setValue(const PropName: string; i1, i2: Integer; const r: real);
begin
  if CompareText(PropName, 'NivelDeFalha') = 0 then
     FNF := r else

  inherited;
end;

procedure TprProjeto.VerificarIntervalosDeAnalise();
begin
  if FInts.NumInts = 0 then
     raise Exception.Create('Intervalos de Análise não definidos.'#13 +
                            'Utilize o menu Projeto/Intervalos de Análise');
end;

procedure TprProjeto.IniciarSimulacao(Evento: TCallEvent);
begin
  FSaveCaption := AP(FAreaDeProjeto).Caption;

  AP(FAreaDeProjeto).Cursor             := crHourGlass;
  AP(FAreaDeProjeto).Enabled            := False;
  AP(FAreaDeProjeto).Progresso.Position := 0;
  AP(FAreaDeProjeto).Progresso.Max      := Total_IntSim;
  AP(FAreaDeProjeto).Progresso.Visible  := True;

  FSimulador            := TSimulation.Create(True);
  FSimulador.OnClock    := TratarEventoDeProgressoDaSimulacao;
  FSimulador.OnEvent    := Evento;
  FSimulador.OnProgress := AP(FAreaDeProjeto).TratarProgressoDaSimulacao;

  // Inicia o relógio da Simulação e outras variáveis de controle
  FIntervalo := 0;
  FIntervalosSim := getTIS;
end;

procedure TprProjeto.FinalizarSimulacao();
begin
  AP(FAreaDeProjeto).Caption           := FSaveCaption;
  AP(FAreaDeProjeto).Cursor            := crDefault;
  AP(FAreaDeProjeto).Enabled           := True;
  AP(FAreaDeProjeto).Progresso.Visible := False;
end;

// Assunto: Equacoes

{
// IEquationBuilder
procedure TprProjeto.eb_InitIdents(Idents: TIdentificatorList; Text: TStrings);
begin
  // iniciar identificadores das equacoes
end;
}

// IEquationBuilder
procedure TprProjeto.eb_Init(Text: TStrings);
begin
  //Text.Add('/* Script gerado pelo Propagar em ' + DateTimeToStr(Now) + ' */');
  Text.Add('');
  self.ExecutarSimulacao();
  getMessageManager.SendMessage(UM_INIT_EQUATIONS, [self]);
end;

// IEquationBuilder
procedure TprProjeto.eb_Finalize(Text: TStrings);
begin
  Text.Add('');
  //Text.Add('/* Fim do script gerado pelo Propagar */');
  getMessageManager.SendMessage(UM_FINALIZE_EQUATIONS, [self]);
end;

// IEquationBuilder
procedure TprProjeto.eb_Generate(Text: TStrings);
begin
  GerarEquacoesPorScript(Text);
end;

// Gera equacoes totalmente atraves de script
procedure TprProjeto.GerarEquacoesPorScript(Text: TStrings);
var s: TPascalScript;
begin
  if FEquacoes_NomeScriptGeral <> '' then
     try
       s := TPascalScript.Create();
       s.AssignLib(pr_Vars.g_psLib);
       s.Code.LoadFromFile(FEquacoes_NomeScriptGeral);
       s.Variables.AddVar(
         TVariable.Create('Projeto', pvtObject, Integer(self), self.ClassType, True));

       if s.Compile() then
          s.Execute()
       else
          raise Exception.Create(s.Errors.Text);
     finally
       s.Free();
     end;
end;

// Palavras-Chaves: Equacao, Equacoes, Equation, Equations
procedure TprProjeto.Equacoes_Iniciar();
begin
  FEquacoes_IndiceGeral := 0;
end;

// Palavras-Chaves: Equacao, Equacoes, Equation, Equations
procedure TprProjeto.Equacoes_GerarBalancoHidrico(Intervalo: integer);
var i: Integer;
begin
  FIntervalo := Intervalo;
  for i := 0 to PCs.PCs-1 do
    PCs[i].GerarEquacoes(FEQB.Text, Intervalo, FEquacoes_IndiceGeral);
end;

function TprProjeto.getFilePath(): String;
begin
  result := ExtractFilePath(FProjeto.NomeArquivo);
end;

procedure TprProjeto.SaveToXML(const Filename: String);
var x: TXML_Writer;
    SL: TStrings;

    // Dados que influen na leitura devem ser colocados nesta seção
    procedure SaveGeralData();
    begin
      x.BeginTag('geral');
        x.BeginIdent();
        x.Write('DecimalSeparator', SysUtils.DecimalSeparator);
        x.EndIdent();
      x.EndTag('geral');
    end;

    procedure SaveDemanda(DM: TprDemanda);
    var i: Integer;
    begin
      DM.ToXML();
      for i := 0 to DM.NumCenarios-1 do
        DM.Cenario[i].ToXML();
    end;

    procedure SaveDescarga(DC: TprDescarga);
    begin
      DC.ToXML();
    end;

    procedure SaveSubBacia(SB: TprSubBacia);
    var i: Integer;
    begin
      SB.ToXML();
      for i := 0 to SB.Demandas-1 do
        SaveDemanda(SB.Demanda[i]);
    end;

    procedure SaveObjects();
    var i, j: Integer;
        PC: TprPC;
    begin
      x.beginTag('objects');

      // Dados do Projeto
      self.ToXML();

      // Rede
      for i := 0 to PCs.PCs-1 do
        begin
        PC := PCs.PC[i];
        PC.ToXML();
        if PC.TrechoDagua <> nil then PC.TrechoDagua.ToXML();
        for j := 0 to PC.SubBacias-1 do SaveSubBacia(PC.SubBacia[j]);
        for j := 0 to PC.Demandas-1 do SaveDemanda(PC.Demanda[j]);
        for j := 0 to PC.Descargas-1 do SaveDescarga(PC.Descarga[j]);
        if PC.QualidadeDaAgua <> nil then PC.QualidadeDaAgua.ToXML();
        end;  // PCs

      x.endTag('objects');
    end; // proc SaveObjects

    procedure writeRelationship(HC1, HC2: THidroComponente);
    begin
      x.beginIdent();
      x.Write('rel', ['obj1', 'obj2'], [HC1.Nome, HC2.Nome], '');
      x.endIdent();
    end;

    procedure RelDemanda(HC: THidroComponente; DM: TprDemanda);
    var i: Integer;
    begin
      writeRelationship(HC, DM);
      for i := 0 to DM.NumCenarios-1 do
        writeRelationship(DM, DM.Cenario[i]);
    end;

    procedure RelDescarga(HC: THidroComponente; DC: TprDescarga);
    begin
      writeRelationship(HC, DC);
    end;

    procedure RelSubBacia(HC: THidroComponente; SB: TprSubBacia);
    var i: Integer;
    begin
      writeRelationship(HC, SB);
      for i := 0 to SB.Demandas-1 do
        RelDemanda(SB, SB.Demanda[i]);
    end;

    procedure SaveRelationships();
    var i, j: Integer;
        PC: TprPC;
    begin
      x.beginTag('relationships');
      for i := 0 to PCs.PCs-1 do
        begin
        PC := PCs.PC[i];
        if PC.TrechoDagua <> nil then
           writeRelationship(PC.TrechoDagua.PC_aMontante, PC.TrechoDagua.PC_aJusante);
        for j := 0 to PC.SubBacias-1 do RelSubBacia(PC, PC.SubBacia[j]);
        for j := 0 to PC.Demandas-1 do RelDemanda(PC, PC.Demanda[j]);
        for j := 0 to PC.Descargas-1 do RelDescarga(PC, PC.Descarga[j]);
        if PC.QualidadeDaAgua <> nil then
           writeRelationship(PC, PC.QualidadeDaAgua);
        end;  // PCs
      x.endTag('relationships');
    end; // proc SaveRelationship

// SaveToXML()
begin
  FNomeArquivo := Filename; // manter em primeiro lugar
  SL := TStringList.Create();

  SysUtilsEx.SaveDecimalSeparator();
  StartWait();
  try
    x := Applic.getXMLWriter();
    x.Buffer := SL;

    // ATENCAO: Nao mudar a ordem das linhas do cabecalho
    x.WriteHeader('', ['Project Type: [' + getProjectType() + ']']);

    {TODO 5 -cGIS: versoes de projeto (BMP, GIS-MO)}
    x.BeginTag('propagar', ['version'], [Applic.FileVersion]);
      x.BeginIdent();

      SaveGeralData();                  // <----- Geral Data
      Intervalos.ToXML();               // <----- Intervals
      ClassesDeDemanda.ToXML();         // <----- Demand Classes
      SaveObjects();                    // <----- Objects
      SaveRelationships();              // <----- Relationships

      x.EndIdent();
    x.EndTag('propagar');

    Applic.ActiveObject := nil;
    SL.SaveToFile(Filename);
    FModificado := false;
  finally
    SysUtilsEx.RestoreDecimalSeparator();
    StopWait();
    SL.Free;
  end;
end; // proc SaveToXML()

procedure TprProjeto.LoadFromXML(const Filename: String);
var
  // Armazena os objetos lidos em uma lista ordenada para após a leitura
  // auxiliar na conecção entre eles.
  Objects: TStringList;

  procedure LoadGeralData(no: IXMLDomNode);
  var s: string[1];
  begin
    s := self.firstChild(no).text;
    SysUtils.DecimalSeparator := s[1];
  end;

  procedure LoadObject(no: IXMLDomNode);
  var sClass, sName, sFactory: string;
      HC: THidroComponente;
      Factory: IObjectFactory;
      X, Y: Integer;
      Pos: TMapPoint;
  begin
    HC := nil;

    sClass := no.attributes.item[0].text;
    sName := no.attributes.item[1].text;

    // Posicoes de tela (sx, sy)
    X := toInt(no.attributes.item[2].text);
    Y := toInt(no.attributes.item[3].text);

    // Posicoes reais (rx, ry)
    if no.attributes.length > 5 then
       begin
       Pos.X := toFloat(no.attributes.item[5].text);
       Pos.Y := toFloat(no.attributes.item[6].text);
       end
    else
       begin
       Pos.X := X;
       Pos.Y := Y;
       end;

    if sClass = TprPCP.ClassName then
       begin
       HC := TprPCP.Create(Pos, self, FTN);
       FPCs.Adicionar(TprPC(HC));
       end
    else
    if sClass = TprPCPR.ClassName then
       begin
       HC := TprPCPR.Create(Pos, self, FTN);
       FPCs.Adicionar(TprPC(HC));
       end
    else
    if sClass = TprSubBacia.ClassName then
       HC := TprSubBacia.Create(Pos, self, FTN)
    else
    if sClass = TprDemanda.ClassName then
       HC := TprDemanda.Create(Pos, self, FTN)
    else
    if sClass = TprDescarga.ClassName then
       HC := TprDescarga.Create(Pos, self, FTN)
    else
    if sClass = TprQualidadeDaAgua.ClassName then
       HC := TprQualidadeDaAgua.Create(Pos, self, FTN)
    else
    if sClass = TprTrechoDagua.ClassName then
       HC := TprTrechoDagua.Create(nil, nil, FTN, self)
    else
    if sClass = TprCenarioDeDemanda.ClassName then
       begin
       sFactory := no.attributes.item[4].text;
       Factory := Applic.Plugins.getFactoryByName(sFactory);
       if Factory <> nil then
          HC := TprCenarioDeDemanda.Create(Pos, self, FTN, Factory);
       end;

    if HC <> nil then
       begin
       HC.fromXML(no);
       HC.AtualizarHint();
       HC.Modificado := true;
       Objects.AddObject(sName, HC);
       Gerenciador.AdicionarObjeto(HC);
       end;
  end;

  // no 0: Dados do Projeto
  // no 1..n-1: Objetos da rede
  procedure LoadObjects(no: IXMLDomNode);
  var i: Integer;
  begin
    // Le o projeto
    self.fromXML(no.childNodes.item[0]);

    // Le os objetos
    for i := 1 to no.childNodes.length-1 do
      LoadObject(no.childNodes.item[i]);
  end;

  procedure ConnectObjects(no: IXMLDomNode);
  var HC1, HC2: THidroComponente;
      i: integer;
  begin
    i := Objects.IndexOf(no.attributes.item[0].text);
    HC1 := THidroComponente(Objects.Objects[i]);

    i := Objects.IndexOf(no.attributes.item[1].text);
    HC2 := THidroComponente(Objects.Objects[i]);

    HC1.ConectarObjeto(HC2);
  end;

  procedure LoadRelationships(no: IXMLDomNode);
  var i: Integer;
  begin
    for i := 0 to no.childNodes.length-1 do
      ConnectObjects(no.childNodes.item[i]);
  end;

var doc: IXMLDOMDocument;
     no: IXMLDomNode;
begin
  doc := OpenXMLDocument(Filename);
  no := doc.documentElement;

  if (no <> nil) and (no.nodeName = 'propagar') then
     begin
     // Leitura da versão do arquivo
     if no.attributes.length = 0 then
        FFileVersion := 1
     else
        if no.attributes.length = 1 then
           FFileVersion := toInt(no.attributes.item[0].text);

     FNomeArquivo := Filename; // manter em primeiro lugar
     AP(AreaDeProjeto).BloquearDesenhoDaRede(true);

     Objects := TStringList.Create();
     Objects.Sorted := true;

     SysUtilsEx.SaveDecimalSeparator();
     StartWait();
     try
       LoadGeralData            (doc.documentElement.childNodes.item[0]);
       Intervalos.fromXML       (doc.documentElement.childNodes.item[1]);
       ClassesDeDemanda.fromXML (doc.documentElement.childNodes.item[2]);
       LoadObjects              (doc.documentElement.childNodes.item[3]);
       LoadRelationships        (doc.documentElement.childNodes.item[4]);

       Applic.ActiveObject := nil;
       Gerenciador.ReconstroiArvore();
       FPCs.CalcularHierarquia();
       FModificado := false;
     finally
       SysUtilsEx.RestoreDecimalSeparator();
       StopWait();
       Objects.Free();
       AP(AreaDeProjeto).BloquearDesenhoDaRede(false);
       end;
     end
  else
     Applic.ShowError('Arquivo Inválido: ' + Filename);
end; // LoadFromXML

procedure TprProjeto.internalToXML(); // override
var x: TXML_Writer;
    i: integer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  AP(FAreaDeProjeto).toXML();

  x.Write('background_File', FArqFundo);
  x.Write('faultLevel'     , FNF);

  x.Write('simulationType'    , ord(FTS));
  x.Write('simulationInterval', ord(FIntSim));
  x.Write('allowNegValuesInBasins', FPermitirVazoesNegativasNasSubBacias);

  x.beginTag('intervals');
    x.beginIdent();
    for i := 0 to High(FAnos) do
      x.Write('interval', Format('%d-%d', [FAnos[i].AnoIni, FAnos[i].AnoFim]));
    x.endIdent();
  x.endTag('intervals');

  x.Write('outputDir'  , FDirSai);
  x.Write('searchPath' , FDirPes);
  x.Write('propagarDOS', FPropDOS);

  x.beginTag('scripts');
    x.beginIdent();
    x.Write('planning_Script' , FPlanejaUsuario);
    x.Write('debug_Script'    , FRotinaGeralUsuario);
    x.Write('operation_Script', FOperaUsuario);
    x.Write('power_Script'    , FEnergiaUsuario);
    x.Write('equation_Script' , FEquacoes_NomeScriptGeral);
    x.endIdent();
  x.endTag('scripts');

  x.Write('Comp_DC_Action' , FAcaoDoDuploClickNosComponentes);
  x.Write('HTML_Browser', FNavHTML);
end;

procedure TprProjeto.fromXML(no: IXMLDomNode); // override
var n: IXMLDomNode;
    i: integer;
    s1, s2: string;
begin
  inherited fromXML(no);

  AP(FAreaDeProjeto).fromXML(no);

  setFundo(nextChild(no).text);
  FNF := strToFloat(nextChild(no).text);

  byte(FTS) := strToInt(nextChild(no).text);
  byte(FIntSim) := strToInt(nextChild(no).text);

  if FProjeto.FileVersion >= 5 then
     FPermitirVazoesNegativasNasSubBacias := toBoolean(nextChild(no).text);

  // Intervalos ...
  n := nextChild(no);
  SetLength(FAnos, n.childNodes.length);
  for i := 0 to High(FAnos) do
    begin
    SubStrings('-', s1, s2, n.childNodes.item[i].text);
    FAnos[i].AnoIni := strToInt(s1);
    FAnos[i].AnoFim := strToInt(s2);
    end;

  FDirSai  := nextChild(no).text;
  FDirPes  := nextChild(no).text;
  FPropDOS := nextChild(no).text;

  // Scripts...
  n := nextChild(no);

  FPlanejaUsuario           := n.childNodes.item[0].text;
  FRotinaGeralUsuario       := n.childNodes.item[1].text;
  FOperaUsuario             := n.childNodes.item[2].text;
  FEnergiaUsuario           := n.childNodes.item[3].text;
  FEquacoes_NomeScriptGeral := n.childNodes.item[4].text;

  if Self.FileVersion < 3 then
     begin
     FScripts.Clear();
     for i := 5 to n.childNodes.length-1 do
       FScripts.Add(n.childNodes.item[i].text);
     end;

  FTotal_IntSim := getTIS;

  if Self.FileVersion >= 4 then
     begin
     FAcaoDoDuploClickNosComponentes := toInt(nextChild(no).text);
     FNavHTML := toInt(nextChild(no).text);
     end;
end;

function TprProjeto.CriarObjeto(const ID: String; Pos: TMapPoint): THidroComponente;
var p: TPoint;
begin
  VerificarSeSalvo();
  VerificarPendencias();

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
     p := MapPointToPoint(Pos);
     p.X := p.X - 30;
     p.Y := p.Y - 30;
     Pos := PointToMapPoint(p);
     Result := TprSubBacia.Create(Pos, self, FTN);
     end
  else

  if ID = 'Descarga' then
     begin
     p := MapPointToPoint(Pos);
     p.X := p.X + 30;
     p.Y := p.Y - 30;
     Pos := PointToMapPoint(p);
     Result := TprDescarga.Create(Pos, self, FTN);
     end
  else

  if ID = 'Demanda' then
     begin
     p := MapPointToPoint(Pos);
     p.X := p.X - 20;
     p.Y := p.Y - 20;
     Pos := PointToMapPoint(p);
     Result := TprDemanda.Create(Pos, Self, FTN);
     end
  else

  if ID = 'Cenario de Demanda' then
     begin
     p := MapPointToPoint(Pos);
     p.X := p.X - 20;
     p.Y := p.Y - 20;
     Pos := PointToMapPoint(p);
     Result := TprCenarioDeDemanda.Create(
       Pos, Self, FTN, Applic.Plugins.ActiveFactory);
     end
  else

  if ID = 'QA' then
     begin
     p := MapPointToPoint(Pos);
     p.X := p.X + 30;
     p.Y := p.Y + 30;
     Pos := PointToMapPoint(p);
     Result := TprQualidadeDaAgua.Create(Pos, self, FTN);
     end
  else
     // ...
end;

procedure TprProjeto.VerificarSeSalvo();
begin
  if (FNomeArquivo = '') {and Map.Visible} then
     raise ProjectNotSaved.Create('Por favor. Salve o projeto primeiro.');
end;

function TprProjeto.MapPointToPoint(p: TMapPoint): TPoint;
begin
  NaoImplementado('MapPointToPoint', ClassName);
end;

function TprProjeto.PointToMapPoint(p: TPoint): TMapPoint;
begin
  NaoImplementado('PointToMapPoint', ClassName);
end;

function TprProjeto.getProjectType(): string;
begin
  NaoImplementado('getProjectType', ClassName);
end;

procedure TprProjeto.VerificarPendencias();
begin
  // Nada
end;

procedure TprProjeto.setBackgroundBitmap(Bitmap: TBitmap);
begin
  // Nada
end;

procedure TprProjeto.ShowHTML(const URL: string);
begin
  if FNavHTML = 0 then
     with THTML_Viewer.Create(URL, fsStayOnTop) do
       Show()
  else
     ShellExecute(AreaDeProjeto.Handle, 'Open', pChar(URL), '', '', 0);
end;

procedure TprProjeto.AplicarVariaveisNosObjetos(const ArquivoMapeamento: string);
var x: TStrings;

    procedure AplicarMapeamento(const Mapeamento: string);
    var nomeVar, nomeObj, nomeProp, s: string;
        valorVar: real;
        obj: THidroComponente;
    begin
      s := '';
      SysUtilsEx.Split(Mapeamento, x, [';']);
      if x.count = 3 then
         begin
         nomeVar := x[0]; nomeObj := x[1]; nomeProp := x[2];
         valorVar := FVariaveis.getValue(nomeVar);

         if nomeObj <> s then
            begin
            s := nomeObj;
            obj := THidroComponente(self.ObjetoPeloNome(nomeObj));
            end;

         if obj <> nil then
            obj.op_setValue(nomeProp, -1, -1, valorVar)
         else
            raise Exception.Create('Objeto nao encontrado: ' + nomeObj);
         end
      else
         raise Exception.Create('Arquivo de mapeamento de variáveis inválido: ' + Mapeamento);
    end;

var SL: TStrings;
     i: integer;
begin
  if FVariaveis.Count = 0 then
     raise Exception.Create('Não existem variáveis a serem aplicadas');

  x := nil;
  SL := SysUtilsEx.LoadTextFile(ArquivoMapeamento);
  FVariaveis.Sort();
  try
    for i := 0 to SL.Count-1 do AplicarMapeamento(SL[i]);
  finally
    SL.Free();
    x.Free();
  end;
end;

procedure TprProjeto.AplicarValoresNosObjetos(const ArquivoMapeamento: string);
var x: TStrings;

    procedure AplicarMapeamento(const Mapeamento: string);
    var nomeObj, nomeProp, s: string;
        valorVar: real;
        obj: THidroComponente;
    begin
      s := '';
      SysUtilsEx.Split(Mapeamento, x, [';']);
      if x.count = 3 then
         begin
         valorVar := toFloat(x[0]); nomeObj := x[1]; nomeProp := x[2];

         if nomeObj <> s then
            begin
            s := nomeObj;
            obj := THidroComponente(self.ObjetoPeloNome(nomeObj));
            end;

         if obj <> nil then
            obj.op_setValue(nomeProp, -1, -1, valorVar)
         else
            raise Exception.Create('Objeto nao encontrado: ' + nomeObj);
         end
      else
         raise Exception.Create('Arquivo de mapeamento de variáveis inválido: ' + Mapeamento);
    end;

var SL: TStrings;
     i: integer;
begin
  x := nil;
  SL := SysUtilsEx.LoadTextFile(ArquivoMapeamento);
  SysUtilsEx.SaveDecimalSeparator();
  try
    for i := 0 to SL.Count-1 do AplicarMapeamento(SL[i]);
  finally
    SysUtilsEx.RestoreDecimalSeparator();
    SL.Free();
    x.Free();
  end;
end;

{ TprFalha }

constructor TprFalha.Create(Ano, Intervalo: Integer; Const DR, DA, NCF: Real);
begin
  inherited Create();

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

{ TprListaDeIntervalos }

procedure TprListaDeIntervalos.Adicionar(Ini, Fim: Integer; const Nome: String; Habilitado: Boolean);
begin
  FIntIni.Add(Ini);
  FIntFim.Add(Fim);
  FNomes.Add(Nome);
  FHab.Add(byte(Habilitado));
end;

constructor TprListaDeIntervalos.Create();
begin
  inherited Create;
  FIntIni := TIntegerList.Create;
  FIntFim := TIntegerList.Create;
  FHab    := TIntegerList.Create;
  FNomes  := TStringList.Create;
end;

destructor TprListaDeIntervalos.Destroy;
begin
  FIntIni.Free;
  FIntFim.Free;
  FHab.Free;
  FNomes.Free;
  inherited Destroy;
end;

function TprListaDeIntervalos.GetHabilitado(i: Integer): Boolean;
begin
  Result := (FHab[i] = 1);
end;

function TprListaDeIntervalos.GetNome(i: Integer): String;
begin
  Result := FNomes[i];
end;

function TprListaDeIntervalos.getNumInts: Integer;
begin
  Result := FIntIni.Count;
end;

function TprListaDeIntervalos.GetsDataFim(i: Integer): String;
begin
  Result := IntervaloParaDataComoString(FProjeto, FIntFim[i]);
end;

function TprListaDeIntervalos.GetsDataIni(i: Integer): String;
begin
  Result := IntervaloParaDataComoString(FProjeto, FIntIni[i]);
end;

procedure TprListaDeIntervalos.Limpar();
begin
  FIntIni.Free();
  FIntIni := TIntegerList.Create;

  FIntFim.Free();
  FIntFim := TIntegerList.Create;

  FHab.Free();
  FHab := TIntegerList.Create;

  FNomes.Clear();
end;

procedure TprListaDeIntervalos.fromXML(no: IXMLDomNode);
var i: Integer;
    child: IXMLDomNode;
begin
  for i := 0 to no.childNodes.length - 1 do
    begin
    child := no.childNodes.item[i];
    Adicionar(toInt(child.attributes.item[0].text),
              toInt(child.attributes.item[1].text),
              child.attributes.item[2].text,
              toBoolean(child.attributes.item[3].text));
    end;
end;

procedure TprListaDeIntervalos.Remover(indice: Integer);
begin
  FIntIni.Delete(Indice);
  FIntFim.Delete(Indice);
  FHab.Delete(Indice);
  FNomes.Delete(Indice);
end;

{ TprProjeto_Rosen }

procedure TprProjetoOtimizavel.ExecutarSimulacao();
var Erro, s: String;
begin
  if FStatus = sOtimizando then
     try
       AP(FAreaDeProjeto).Progresso.Position := 0;
       Erro := '';

       // Inicia os objetos da rede
       GetMessageManager.SendMessage(UM_INICIAR_SIMULACAO, [self]);
       if Assigned(FEvento_InicioSimulacao) then FEvento_InicioSimulacao(Self);

       // Totaliza as demandas para cada PC
       PCs.TotalizarDemandas();

       AtualizaPontoExecucao('', nil);
       try
         inc(FIndSim);
         FSimulador.Resume;
         AtualizaPontoExecucao('', nil);
       except
         on E: Exception do Erro := E.Message;
       end;
     finally
       if Assigned(FEvento_FimSimulacao) then FEvento_FimSimulacao(Self);
       if FEC <> '' then
          begin
          s := 'Processo de otimização não concluído.'#13 +
               '  - Último ponto de execução: ' + FEC + #13 +
               '  - Intervalo: ' + toString(FIntervalo);
          if Erro <> '' then s := s + #13 + '  - Erro: ' + Erro;
          MessageDLG(s, mtError, [mbOk], 0);
          end;
     end
  else
     inherited ExecutarSimulacao();
end;

procedure TprProjetoOtimizavel.TerminarOtimizacao();
begin
  FOptimizer.Stop();
end;

function TprProjetoOtimizavel.CriarDialogo(): TprDialogo_Base;
begin
  Result := TprDialogo_ProjetoOtimizavel.Create(nil);
  Result.TN := FTN;
end;

procedure TprProjetoOtimizavel.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_ProjetoOtimizavel) do
    begin
    FOpt_NomeRotIni := RO.edIniUsuario.Text;
    FOpt_NomeRotFim := RO.edFimUsuario.Text;
    FOpt_NomeRotFO  := RO.edGeralUsuario.Text;
    end;
end;

procedure TprProjetoOtimizavel.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_ProjetoOtimizavel) do
    begin
    RO.edIniUsuario.Text   := FOpt_NomeRotIni;
    RO.edFimUsuario.Text   := FOpt_NomeRotFim;
    RO.edGeralUsuario.Text := FOpt_NomeRotFO;
    end;
end;

procedure TprProjetoOtimizavel.ValidarDados(var TudoOk: Boolean;
  DialogoDeErros: TfoMessages; Completo: Boolean);
var IU, FU, GU : String;
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
  if FDialogo <> nil then
     begin
     IU := TprDialogo_ProjetoOtimizavel(FDialogo).RO.edIniUsuario.Text;
     FU := TprDialogo_ProjetoOtimizavel(FDialogo).RO.edFimUsuario.Text;
     GU := TprDialogo_ProjetoOtimizavel(FDialogo).RO.edGeralUsuario.Text;
     end
  else
     begin
     IU := FOpt_NomeRotIni;
     FU := FOpt_NomeRotFim;
     GU := FOpt_NomeRotFO;
     end;

  VerificaRotinaUsuario(IU, 'Inicialização do Otimizador', Completo, TudoOk, DialogoDeErros);
  VerificaRotinaUsuario(FU, 'Finalização do Otimizador'  , Completo, TudoOk, DialogoDeErros);
  VerificaRotinaUsuario(GU, 'Rotina Geral do Otimizador', Completo, TudoOk, DialogoDeErros);
end;

function TprProjetoOtimizavel.ReceiveMessage(const MSG: TadvMessage): Boolean;
const sMes = 'O script %s da otimização contém erros !'#13 +
             'Para a otimização e verifique.';
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     if FOpt_NomeRotIni <> '' then
        begin
        PreparaScript(FOpt_NomeRotIni, FOpt_Script_Ini);
        if not FOpt_Script_Ini.Compile() then
           MessageDLG(Format(sMes, ['de Inicialização']), mtError, [mbOK], 0);
        end;

     if FOpt_NomeRotFim <> '' then
        begin
        PreparaScript(FOpt_NomeRotFim, FOpt_Script_Fim);
        if not FOpt_Script_Fim.Compile() then
           MessageDLG(Format(sMes, ['de Finalização']), mtError, [mbOK], 0);
        end;

     if FOpt_NomeRotFO <> '' then
        begin
        PreparaScript(FOpt_NomeRotFO, FOpt_Script_FO);
        if not FOpt_Script_FO.Compile() then
           MessageDLG(Format(sMes, ['da Função Objetivo']), mtError, [mbOK], 0);
        end;
     end
  else

  if MSG.ID = UM_LIBERAR_SCRIPTS then
     begin
     FreeAndNil(FOpt_Script_Ini);
     FreeAndNil(FOpt_Script_Fim);
     FreeAndNil(FOpt_Script_FO);
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TprProjetoOtimizavel.ExecutarRotinaDeFinalizacao();
begin
  if FOpt_NomeRotFim <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.Otimizador.ScriptFinal', FOpt_Script_Fim);
     FOpt_Script_Fim.Execute();
     AtualizaPontoExecucao('', nil);
     end;
end;

procedure TprProjetoOtimizavel.ExecutarRotinaDeInicializacao();
begin
  if FOpt_NomeRotIni <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.Otimizador.ScriptInicial', FOpt_Script_Ini);
     FOpt_Script_Ini.Execute();
     AtualizaPontoExecucao('', nil);
     end;
end;

function TprProjetoOtimizavel.getRosenOpt(): TRosenbrock;
begin
  if FOptimizer is TRosenbrock then
     Result := TRosenbrock(FOptimizer)
  else
     if FOptimizer = nil then
        raise Exception.Create('O otimizador não está ativo')
     else
        raise Exception.Create('O otimizador ativo não é o "Rosenbrock"');
end;

function TprProjetoOtimizavel.getGeneticOpt(): TGeneticOptimizer;
begin
  if FOptimizer is TGeneticOptimizer then
     Result := TGeneticOptimizer(FOptimizer)
  else
     if FOptimizer = nil then
        raise Exception.Create('O otimizador não está ativo')
     else
        raise Exception.Create('O otimizador ativo não é o "Otimizador Genético"');
end;

procedure TprProjetoOtimizavel.o_beginOptimization();
begin
  FStatus := sOtimizando;

  // Inicia o relógio da Simulação e outras variáveis de controle
  FIndSim := 0;
  FIntervalo := 0;
  FIntervalosSim := getTIS;

  // Ordena os PCs por Prioridade
  FPCs.Ordenar();

  // Salva as configurações da área de projeto
  FCaption                              := AP(FAreaDeProjeto).Caption;
  AP(FAreaDeProjeto).Cursor             := crHourGlass;
  AP(FAreaDeProjeto).Enabled            := False;
  AP(FAreaDeProjeto).Progresso.Max      := Total_IntSim;
  AP(FAreaDeProjeto).Progresso.Visible  := True;

  // Inicializacao do mecanismo de simulacao
  FSimulador             := TSimulation.Create(True);
  FSimulador.OnClock     := TratarEventoDeProgressoDaSimulacao;
  FSimulador.OnEvent     := TratarEventosDaSimulacao;
  FSimulador.OnProgress  := AP(FAreaDeProjeto).TratarProgressoDaSimulacao;

  GetMessageManager.SendMessage(UM_PREPARAR_SCRIPTS, [self]);

  ExecutarRotinaDeInicializacao();
end;

procedure TprProjetoOtimizavel.o_endOptimization();
begin
  // Recupera as configurações da área de projeto
  AP(FAreaDeProjeto).Caption           := FCaption;
  AP(FAreaDeProjeto).Cursor            := crDefault;
  AP(FAreaDeProjeto).Enabled           := True;
  AP(FAreaDeProjeto).Progresso.Visible := False;

  FStatus := sFazendoNada;

  try
    ExecutarRotinaDeFinalizacao();  // <<<< executo mesmo que a inicializacao gerou erro ???
    ExecutarRotinaGeral();
  finally
    FreeAndNil(FSimulador);
    FOptimizer := nil;
    GetMessageManager.SendMessage(UM_LIBERAR_SCRIPTS, [self]);
  end;
end;

procedure TprProjetoOtimizavel.o_CalculateObjetiveFunctions();
begin
  ExecutarSimulacao();
  if FOpt_NomeRotFO <> '' then
     begin
     AtualizaPontoExecucao(FNome + '.Otimizador.ScriptFO', FOpt_Script_FO);
     // O usuario devera estavelecer os valores das FO atraves do metodo "setOFValues" do Otimizador
     FOpt_Script_FO.Execute();
     AtualizaPontoExecucao('', nil);
     end;
end;

procedure TprProjetoOtimizavel.o_setOptimizer(obj: TObject);
begin
  FOptimizer := TOptimizer(obj);
end;

procedure TprProjetoOtimizavel.o_ProcessMessage(MessageID: integer);
begin

end;

procedure TprListaDeIntervalos.toXML();
var x: TXML_Writer;
    i: integer;
begin
  x := Applic.getXMLWriter();
  x.BeginTag('intervals');
    x.BeginIdent();
    for i := 0 to self.getNumInts()-1 do
      begin
      x.Write('interval',
             ['start', 'end', 'name', 'enable'],
             [IntIni[i], IntFim[i], Nome[i], Habilitado[i]]
             );
      end;
    x.EndIdent();
  x.EndTag('intervals');
end;

{ TprCenarioDeDemanda }

constructor TprCenarioDeDemanda.Create(const Pos: TMapPoint;
                                       Projeto: TprProjeto;
                                       TabelaDeNomes: TStrings;
                                       FabricaDeCenario: IObjectFactory);
var o: TObject;
begin
  inherited Create(TabelaDeNomes, Projeto);
  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  CriarComponenteVisual(Projeto.AreaDeProjeto, Pos);

  FFactoryName := FabricaDeCenario.getName();
  o := FabricaDeCenario.CreateObject('');
  o.GetInterface(ICenarioDemanda, FDI);

  ipr_setExePath(Applic.appDir);
  ipr_setProjectPath(Projeto.CaminhoArquivo);
  ipr_setObjectName(FNome);
end;

destructor TprCenarioDeDemanda.Destroy();
begin
  Release();

  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);

  inherited Destroy;
end;

function TprCenarioDeDemanda.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint;

  inherited ReceiveMessage(MSG);
end;

function TprCenarioDeDemanda.ObterPrefixo: String;
begin
  Result := 'Cenario_';
end;

function TprCenarioDeDemanda.CriarImagemDoComponente(): TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'CENARIO_10X10');
  Result.Width := 12;
  Result.Height := 13;
  TdrBitmap(Result).DrawFrame := True;
end;

procedure TprCenarioDeDemanda.ipr_setExePath(const ExePath: string);
begin
  FDI.ipr_setExePath(ExePath);
end;

procedure TprCenarioDeDemanda.ihc_Simular();
begin
  FDI.ihc_Simular();
end;

procedure TprCenarioDeDemanda.ihc_ObterErros(var Erros: TStrings);
begin
  FDI.ihc_ObterErros(Erros);
end;

function TprCenarioDeDemanda.ihc_TemErros: boolean;
begin
  Result := FDI.ihc_TemErros();
end;

procedure TprCenarioDeDemanda.ihc_ObterAcoesDeMenu(Acoes: TActionList);
begin
  FDI.ihc_ObterAcoesDeMenu(Acoes);
end;

procedure TprCenarioDeDemanda.getActions(Actions: TActionList);
begin
  inherited getActions(Actions);
  CreateAction(Actions, nil, '-', false, nil, self);
  ihc_ObterAcoesDeMenu(Actions);
end;

function TprCenarioDeDemanda.CriarDialogo(): TprDialogo_Base;
begin
  Result := inherited CriarDialogo();
  Result.Caption := 'Dados de um Cenário de Demanda';
end;

procedure TprCenarioDeDemanda.AlimentarDemanda();
var o: TObject;
begin
  o := icd_ObterValoresUnitarios();
  if o <> nil then
     FDemanda.AssociarValoresUnitarios(o)
  else
     MostrarErro('Obj: ' + FNome + #13 +
                 'Valores Unitários não Definidos pelo cenário');
end;

function TprCenarioDeDemanda.icd_ObterValoresUnitarios(): TObject;
begin
  Result := FDI.icd_ObterValoresUnitarios();
end;

procedure TprCenarioDeDemanda.Release();
begin
  FDI.Release();

  // Desta maneira eu evito a chamada de _intfClear() e erros
  // que ocorreriam devido a incorreta liberacao da interface pelo Delphi
  Pointer(FDI) := nil;
end;

function TprCenarioDeDemanda.ToString(): wideString;
begin
  result := FDI.ToString();
end;

procedure TprCenarioDeDemanda.ipr_setObjectName(const Name: string);
begin
  FDI.ipr_setObjectName(Name);
end;

procedure TprCenarioDeDemanda.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited;
  ipr_setObjectName(FNome);
end;

function TprCenarioDeDemanda.icd_ObterValorFloat(const Propriedade: string): real;
begin
  result := FDI.icd_ObterValorFloat(Propriedade);
end;

function TprCenarioDeDemanda.icd_ObterValorString(const Propriedade: string): string;
begin
  result := FDI.icd_ObterValorString(Propriedade);
end;

function TprCenarioDeDemanda.ObterValorFloat(const Propriedade: string): real;
begin
  result := icd_ObterValorFloat(Propriedade);
end;

function TprCenarioDeDemanda.ObterValorString(const Propriedade: string): string;
begin
  result := icd_ObterValorString(Propriedade);
end;

procedure TprCenarioDeDemanda.ipr_setProjectPath(const ProjectPath: string);
begin
  FDI.ipr_setProjectPath(ProjectPath);
end;

procedure TprCenarioDeDemanda.fromXML(no: IXMLDomNode);
begin
  inherited fromXML(no);
  ihc_fromXML( nextChild(no) );
  ipr_setObjectName(FNome);
end;

procedure TprCenarioDeDemanda.internalToXML();
var x: TXML_Writer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.beginTag('pluginData', ['Version'], [ ihc_getXMLVersion() ]);
    x.beginIdent();
    ihc_toXML(x.Buffer, x.IdentSize);
    x.endIdent();
  x.endTag('pluginData');
end;

procedure TprCenarioDeDemanda.ihc_fromXML(no: IXMLDOMNode);
begin
  FDI.ihc_fromXML(no);
end;

procedure TprCenarioDeDemanda.ihc_toXML(Buffer: TStrings; Ident: integer);
begin
  FDI.ihc_toXML(Buffer, Ident);
end;

procedure TprProjetoOtimizavel.fromXML(no: IXMLDomNode);
var n: IXMLDomNode;
begin
  inherited fromXML(no);

  // Scripts...
  n := nextChild(no);

  FOpt_NomeRotIni := n.childNodes.item[0].text;
  FOpt_NomeRotFim := n.childNodes.item[1].text;
  FOpt_NomeRotFO  := n.childNodes.item[2].text;
end;

procedure TprProjetoOtimizavel.internalToXML();
var x: TXML_Writer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.beginTag('scripts');
    x.beginIdent();
    x.Write('startOpt_Script', FOpt_NomeRotIni);
    x.Write('endOpt_Script'  , FOpt_NomeRotFim);
    x.Write('ofOpt_Script'   , FOpt_NomeRotFO);
    x.EndIdent();
  x.endTag('scripts');
end;

function TprCenarioDeDemanda.ihc_getXMLVersion(): integer;
begin
  result := FDI.ihc_getXMLVersion();
end;

{ TprDescarga }

constructor TprDescarga.Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);
begin
  inherited Create(TabelaDeNomes, Projeto);

  // Recebe mensagens de atualizacao visual
  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);

  CriarComponenteVisual(Projeto.AreaDeProjeto, Pos);
end;

destructor TprDescarga.Destroy();
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [self]);

  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);

  inherited Destroy();
end;

function TprDescarga.CriarDialogo(): TprDialogo_Base;
begin
  Result := TprDialogo_Descarga.Create(nil);
  Result.TN := FTN;
end;

function TprDescarga.CriarImagemDoComponente(): TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'DESCARGA');
  Result.Width := 22;
  Result.Height := 15;
  TdrBitmap(Result).DrawFrame := True;
end;

procedure TprDescarga.fromXML(no: IXMLDomNode);
begin
  inherited fromXML(no);

  FCargaDBOC        := strToFloat(nextChild(no).text);
  FCargaDBON        := strToFloat(nextChild(no).text);
  FCargaColiformios := strToFloat(nextChild(no).text);
  FConcentracaoDBOC := strToFloat(nextChild(no).text);
  FConcentracaoDBON := strToFloat(nextChild(no).text);
end;

procedure TprDescarga.internalToXML();
var x: TXML_Writer;
begin
  inherited internalToXML();
  x := Applic.getXMLWriter();

  x.Write('CargaDBOC       ', FCargaDBOC       );
  x.Write('CargaDBON       ', FCargaDBON       );
  x.Write('CargaColiformios', FCargaColiformios);
  x.Write('ConcentracaoDBOC', FConcentracaoDBOC);
  x.Write('ConcentracaoDBON', FConcentracaoDBON);
end;

function TprDescarga.ObterPrefixo(): string;
begin
  result := 'Descarga_';
end;

procedure TprDescarga.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_Descarga) do
    begin
    FCargaDBOC        := edCargaDBOC.AsFloat;
    FCargaDBON        := edCargaDBON.AsFloat;
    FCargaColiformios := edCargaColif.AsFloat;
    FConcentracaoDBOC := edConDBOC.AsFloat;
    FConcentracaoDBON := edConDBON.AsFloat;
    end;
end;

procedure TprDescarga.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_Descarga) do
    begin
    edCargaDBOC.AsFloat  := FCargaDBOC;
    edCargaDBON.AsFloat  := FCargaDBON;
    edCargaColif.AsFloat := FCargaColiformios;
    edConDBOC.AsFloat    := FConcentracaoDBOC;
    edConDBON.AsFloat    := FConcentracaoDBON;
    end;
end;

function TprDescarga.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint();

  inherited ReceiveMessage(MSG);
end;

{ TprQualidadeDaAgua }

constructor TprQualidadeDaAgua.Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);
begin
  inherited Create(TabelaDeNomes, Projeto);
  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  CriarComponenteVisual(Projeto.AreaDeProjeto, Pos);
end;

function TprQualidadeDaAgua.CriarDialogo(): TprDialogo_Base;
begin
  Result := TprDialogo_QA.Create(nil);
  Result.TN := FTN;
end;

function TprQualidadeDaAgua.CriarImagemDoComponente(): TdrBaseShape;
begin
  Result := TdrFlag.Create(nil);
  Result.ThreeD := false;
  Result.Width := 18;
  Result.Height := 25;
end;

destructor TprQualidadeDaAgua.Destroy();
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [self]);

  GetMessageManager.UnregisterMessage(UM_REPINTAR_OBJETO, self);

  inherited Destroy();
end;

procedure TprQualidadeDaAgua.fromXML(no: IXMLDomNode);
begin
  inherited fromXML(no);
  FCod := strToInt(nextChild(no).text);
  setColor(FCod);
end;

function TprQualidadeDaAgua.getHint(): string;
begin
  result := 'Qualidade: ' + TQACodigos.Nome(FCod);
end;

procedure TprQualidadeDaAgua.internalToXML();
begin
  inherited internalToXML();
  Applic.getXMLWriter().Write('code', FCod);
end;

function TprQualidadeDaAgua.ObterPrefixo(): string;
begin
  Result := 'QA_';
end;

procedure TprQualidadeDaAgua.PegarDadosDoDialogo(d: TprDialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_QA) do
    begin
    FCod := getQA();
    setColor(FCod);
    end;
end;

procedure TprQualidadeDaAgua.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_QA) do
    begin
    setQA(FCod);
    end;
end;

function TprQualidadeDaAgua.ReceiveMessage(const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint();
end;

procedure TprQualidadeDaAgua.setColor(Code: integer);
begin
  if FImagemDoComponente <> nil then
     begin
     TdrFlag(FImagemDoComponente).Color := TQACodigos.Cor(Code);
     TdrFlag(FImagemDoComponente).Paint();
     end;
end;

{ TprProjeto_ScrollCanvas }

function TprProjeto_ScrollCanvas.getProjectType: string;
begin
  result := cTP_ScrollCanvas;
end;

function TprProjeto_ScrollCanvas.MapPointToPoint(p: TMapPoint): TPoint;
var c: TScrollBox;
begin
  c := TScrollBox( AP(FAreaDeProjeto).ControleDaAreaDeDesenho() );
  result.X := trunc(p.X) - c.HorzScrollBar.Position;
  result.Y := trunc(p.Y) - c.VertScrollBar.Position;
end;

function TprProjeto_ScrollCanvas.PointToMapPoint(p: TPoint): TMapPoint;
var c: TScrollBox;
begin
  c := TScrollBox( AP(FAreaDeProjeto).ControleDaAreaDeDesenho() );
  result.X := p.X + c.HorzScrollBar.Position;
  result.Y := p.Y + c.VertScrollBar.Position;
end;

procedure TprProjeto_ScrollCanvas.setBackgroundBitmap(Bitmap: TBitmap);
begin
  inherited setBackgroundBitmap(Bitmap);
  FBmp := Bitmap;
  AP(FAreaDeProjeto).Atualizar();
end;

{ TprProjeto_ZoomPanel }

function TprProjeto_ZoomPanel.getProjectType(): string;
begin
  result := cTP_ZoomPanel;
end;

function TprProjeto_ZoomPanel.MapPointToPoint(p: TMapPoint): TPoint;
var c: TPanZoomPanel;
begin
  c := TPanZoomPanel( AP(FAreaDeProjeto).ControleDaAreaDeDesenho() );
  result := c.ActualToDevice(TDoublePoint(p));
end;

function TprProjeto_ZoomPanel.PointToMapPoint(p: TPoint): TMapPoint;
var c: TPanZoomPanel;
begin
  c := TPanZoomPanel( AP(FAreaDeProjeto).ControleDaAreaDeDesenho() );
  result := TMapPoint(c.DeviceToActual(p));
end;

procedure TprProjeto_ZoomPanel.setBackgroundBitmap(Bitmap: TBitmap);
var c: TPanZoomPanel;
begin
  inherited setBackgroundBitmap(Bitmap);

  c := TPanZoomPanel( AP(FAreaDeProjeto).ControleDaAreaDeDesenho() );
  c.Bitmap := Bitmap;

  if Bitmap <> nil then
     begin
     c.SetFirstScalePoint( MakePoint(0, 0),
                           MakeDoublePoint(0, 0) );

     // Faz com que a unidade seja igual a 1 pixel da imagem
     c.SetSecondScalePoint( MakePoint(Bitmap.Width, Bitmap.Height),
                            MakeDoublePoint(Bitmap.Width, Bitmap.Height) );

     c.DefineScaleNoSkew(False, False);
     end;
end;

procedure TprProjeto_ZoomPanel.VerificarPendencias();
var c: TPanZoomPanel;
begin
  c := TPanZoomPanel( AP(FAreaDeProjeto).ControleDaAreaDeDesenho() );
  if c.Bitmap = nil then
     raise Exception.Create('Antes de iniciar selecione uma imagem de fundo'#13 +
                            'para que o projeto possa calcular a escala.');
end;

end.

