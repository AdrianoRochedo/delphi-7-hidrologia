unit hidro_Classes;

{   <autor>Adriano Rochedo Conceição</autor>
    <version>2.0</version>
    <description>
    Esta unidade implementa as classes básicas que encapsulam objetos hidrogáficos tais como
    Sub-bacias, Postos de controle, trechos-dáguas, demandas, etc.

    Também implementa classes auxiliares para gerenciamento destes objetos e algumas rotinas.
    </description>

CUIDADOS:
    - Modificado o método de destruicao dos componentes que enviavam a menssagem
     "UM_OBJETO_SE_DESTRUINDO". Utilizar "Avisar_e_Destruir" ao inves de "Free".
     Utilizado pelos descendentes de: TPC, TSubBacia

    - Associar evento "Evento_IniciarPlanilha" nos projetos
}

interface
uses Windows, Messages, Classes, MessageManager, Rochedo.Simulators.Shapes, Forms, SysUtils, ExtCtrls,
     Graphics, Controls, ComCtrls, Menus,
     {$ifdef IPHS1}
     iphs1_Tipos,
     wsMatrix,
     {$endif}
     Simulation,
     wsVec,
     psBASE,
     psCORE,
     Lib_GlobalObjects,
     SysUtilsEx,
     Lists,
     MessagesForm,
     Hidro_Tipos,
     Planilha_Base,
     Dialogo_Base,
     Form_Chart,
     Form_SheetChart;

type
  THidroComponente = Class;
  TPC              = Class;
  TSubBacia        = Class;
  TProjeto         = Class;
  TListaDePCs      = Class;

  // Classes básicas -----------------------------------------------------------------

  THidroInterface = class(TObject, IUnknown)
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  I_EscritorCarregador = interface
    // Realiza a leitura das informações do componente
    procedure LerDoArquivo(Arquivo: TIF; Const Secao: String);

    // Salva as informações do componente em um arquivo
    procedure SalvarEmArquivo(Arquivo: TIF; Const Secao: String);

    // Pega as informações editadas no diálogo do usuário
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base);

    // Põe informações no diálogo
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base);
  end;

{$ifdef IPHS1}
  // Informações básicas que algumas classes contém
  Tiphs1_IB = Class(THidroInterface, I_EscritorCarregador)
  private
    FVC  : Boolean;
    FPDO : Boolean;
    FGHC : Boolean;
    FITH : Boolean;
    FVMax: Real;
    FVMin: Real;
    FOper: TenCodOper;
    FNDO : String;
    FDO  : TV;
    FNHE : Integer;
    FNHS : Integer;
    FNHP : Integer;
    FHC  : THidroComponente;
    procedure LerDoArquivo(Arquivo: TIF; Const Secao: String);
    procedure SalvarEmArquivo(Arquivo: TIF; Const Secao: String);
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base);
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base);
    procedure ValidarDados(Nome: string; Dialogo: TForm; var TudoOk: Boolean;
                           DialogoDeErros: TfoMessages; Completo: Boolean = False);
  public
    constructor Create(HC: THidroComponente);
    destructor Destroy(); override;

    function LerDadosObs(): TV;

    property Oper : TenCodOper read FOper write FOper; // Código da Operação Hidrológica

    // Número do Hidrograma de Entrada
    property NHE  : Integer read FNHE  write FNHE;

    // Número da Operação Hidrológica - Hidrograma de Saída. Deverá ser único
    property NHS  : Integer read FNHS  write FNHS;

    // Número do Hidrograma de Passagem.
    // Utilizado quando não existe oper. hid. no PC. É igual ao hid. de entrada
    property NHP  : Integer read FNHP  write FNHP;

    property VMax : Real read FVMax write FVMax;
    property VMin : Real read FVMin write FVMin;

    property GHC  : Boolean read FGHC  write FGHC;     // True por default
    property ITH  : Boolean read FITH  write FITH;     // True por default
    property PDO  : Boolean read FPDO  write FPDO;
    property VC   : Boolean read FVC   write FVC;

    property NomeDadosObs : String read FNDO write FNDO;
    property DadosObs     : TV     read FDO;

    // HidroComponente que contém as informações
    property HC : THidroComponente read FHC;
  end;
{$endif}

  {<description>
  Objeto não visual com capacidade de Stream
  </description>}
  THidroObjeto = class(T_NRC_InterfacedObject, IMessageReceptor)
  private
    FNome       : String;
    FVisitado   : Boolean;
    FModificado : Boolean;
    FProjeto    : TProjeto;
    FBloqueado  : Boolean;
    TN          : TStrings;
    FAvisarQueVaiSeDestruir: Boolean;
    procedure SetNome(const Value: String);
    function GetSecao: String;
  protected
    procedure SetModificado(const Value: Boolean); virtual;

    { *************** Métodos de Stream **************** }

    {<description>
     Realiza a leitura das informações do componente.
     Ex:
       <code>
         ...
         x.LerDoArquivo(umIni, 'DADOS PC1');
         ...
       </code>
     </description>}
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); Virtual;

    // <description> Salva as informações do componente em um arquivo </description>
    procedure SalvarEmArquivo(Arquivo: TIF); Virtual;

    { *************** Métodos de Stream **************** }

    function ReceiveMessage(Const MSG: TadvMessage): Boolean; virtual;

    // Métodos para a clonagem de objetos
    function CriarInstancia: THidroObjeto;  virtual;
    procedure CopiarPara(HC: THidroObjeto); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    // <description> Avisa outros componentes que está prestes a se destruir </description>
    //procedure Avisar_e_Destruir;

    // Faz a clonagem de uma Instância
    // Deverão ser implementadoo para cada hierarquia os métodos CopiarPara e CriarInstancia
    function  Clonar: THidroObjeto;
    procedure CopiarDadosPara(HC: THidroObjeto);

    // <description> Permite que nomes únicos sejam atribuídos aos componentes </description>
    property  TabNomes : TStrings read TN write TN;

    // <description> Nome do Objeto <description>
    property  Nome : String read FNome write SetNome;

    // <description> Projeto a que este objeto pertence </description>
    property Projeto : TProjeto read FProjeto write FProjeto;

    // <description> Indica, se numa interação, se este objeto foi visitado </description>
    property Visitado : Boolean  read FVisitado   write FVisitado;

    // <description> Indica se o objeto foi modificado </description>
    property Modificado : Boolean  read FModificado write SetModificado;

    // <description> Indica se o objeto pode ser modificado </description>
    property Bloqueado  : Boolean  read FBloqueado  write FBloqueado;

    // <description> Obtem a secao do arquivo Ini onde os dados serao salvos </description>
    property Secao : String read GetSecao;

    {<description>
    Indica ao objeto que ele deve enviar uma mensagem para o sistema avisando
    outros objetos que ele está prestes a ser destruído.
    O valor por falta é verdadeiro (true)
    </description>}
    property AvisarQueVaiSeDestruir: Boolean
       read  FAvisarQueVaiSeDestruir
       write FAvisarQueVaiSeDestruir;
  end;

  TEvento_IniciarPlanilha = procedure(Sender   : THidroComponente;
                                      Planilha : TForm_Planilha_Base) of object;

  // Objeto visual com capacidade de Stream
  THidroComponente = class(THidroObjeto)
  private
    FImagemDoComponente     : TdrBaseShape;
    FDialogo                : TForm_Dialogo_Base;
    FDescricao              : String;
    FComentarios            : TStrings;
    FMenu                   : TPopupMenu;
    FEvento_IniciarPlanilha : TEvento_IniciarPlanilha;

    {$ifdef IPHS1}
    FIB: Tiphs1_IB;
    FHR: TwsVec;
    FVolEscoado: Real;
    FHidrogramas: TIV;
    FVazaoCont: TwsDataSet;
    {$endif}

    function  GetRect: TRect;
    function  GetPos: TPoint;
    procedure SetPos(Const Value: TPoint);
    procedure DuploClick(Sender: TObject);

    // Fornece uma identificação única para o componente
    function  ObtemNome: String;

    // Prepara uma máquina virtual para execução de Scripts
    procedure PrepararScript(Arquivo: String; var Script: TPascalScript);
  protected
    // Atualiza as informações mostradas quando o cursor está sobre o componente
    procedure AtualizarHint; virtual;

    // Plota informações extras no gráfico dos hidrogramas resultantes
    procedure PlotarInformacoesExtras(G: TfoSheetChart); virtual;

    function CriarInstancia: THidroObjeto;  override;
    procedure CopiarPara(HC: THidroObjeto); override;
  public
    // Responsável por criar e configurar o componente que será mostrado no projeto
    procedure CriarComponenteVisual;

    // Possibilita a comunicação com outros objetos
    function  ReceiveMessage(const MSG: TadvMessage): Boolean; override;

    // Possibilita a exibição dos dados dos componentes em uma planilha
    procedure ColocarDadosNaPlanilha(Planilha: TForm_Planilha_Base); virtual;

    // Prepara um menu Popup para o componente
    procedure PrepararMenu; virtual;

    // Fornece um prefixo padrão para o nome do componente
    Function  ObtemPrefixo: String; Virtual;

    // Responsável por criar o formato visual do componente
    function  CriarImagemDoComponente: TdrBaseShape; Virtual;

    { *************** Métodos para gerenciamento do Diálogo **************** }

    {Deverão ser sobreescritos em cada descendente que tiver propriedades acrescidas
     que podem ser editadas pelo usuário}

    // Cria um diálogo para edição das propriedades do componente
    function  CriarDialogo: TForm_Dialogo_Base; Virtual;

    // Obtem as informações editadas pelo usuário no diálodo
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); Virtual;

    // Mostra as propriedades do componente nos campos do diálogo
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); Virtual;

    { *************** Métodos para gerenciamento do Diálogo **************** }

    procedure LerDoArquivo(Ini: TIF; Const Secao: String); override;
    procedure SalvarEmArquivo(Arquivo: TIF); override;
  //public
    constructor Create(UmaTabelaDeNomes: TStrings; Projeto: TProjeto);
    destructor  Destroy; override;

    {Realiza somente a validação dos dados (Erros Fatais)
     Regra: A variável TudoOk deverá ser inicializada em TRUE}
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); Virtual;

    // Mostra um diálogo para edição das informações do componente
    function  MostrarDialogo(const Caption: String = ''): Integer;

    {Mostra os dados do componente em uma planilha.
     Devemos fornecer um método para os descendentes para que o mecanismo funcione corretamente:
     "ColocarDadosNaPlanilha".
     MostrarPlanilha dispara um evento de inicialização "Evento_IniciarPlanilha"}
    procedure MostrarPlanilha;

    // Mostra um Menu para escolha de opções pelo usuário
    procedure MostrarMenu(x: Integer = -1; y: Integer = -1);

    // Cria uma conecção de um componente a este componente
    function  ConectarObjeto(Obj: THidroComponente): Integer; Virtual;

    // Desconecta todos os componentes ligados a este componente
    procedure DesconectarObjetos; Virtual;

    // Realiza o diagnóstico dos dados (Erros Fatais e Avisos)
    procedure Diagnostico(var TudoOk: Boolean; Completo: Boolean = False);

    // Rotinas para tratamento de caminhos de arquivo
    function  VerificaCaminho(var Arquivo: String): Boolean;
    procedure RetirarCaminhoSePuder(var Arquivo: String);

    // Verifica se arquivo existe e se "Completo = true" se o Script está correto
    procedure VerificarScriptDoUsuario(Arquivo: String; const Texto: String;
                                       Completo: Boolean; var TudoOk: Boolean;
                                       DialogoDeErros: TfoMessages);

    // Realiza as inicializações para as simulações
    // Este método é chamado através de um evento disparado antes da simulação
    procedure PrepararParaSimulacao; virtual;

    {$ifdef IPHS1}
    function  ObterObjetoPelaOperacao(Oper: Integer): THidroComponente;
    function  ObterHidrogramaDeEntrada: TV;
    function  CalcularSomaDeHidrogramas: TV;
    procedure PlotarHidrogramasEm(G: TfoChart); virtual; abstract;
    procedure PlotarHidrogramaResultante(); virtual;
    procedure PlotarVazaoControlada;
    procedure MostrarHidrogramaResultante;
    procedure PlotarHidrogramasResultantes(Objetos: TStrings);
    procedure PlotarHidrogramaResultanteDosObjConectados;
    procedure MostrarHidrogramasResultantes(Objetos: TStrings);

    property IB          : Tiphs1_IB  read FIB; // Informações Básicas
    property HidroRes    : TwsVec     read FHR; // Hidrograma resultante
    property Hidrogramas : TIV        read FHidrogramas; // Hidrogramas de entrada
    property VazaoCont   : TwsDataSet read FVazaoCont; // Vazão Controlada

    property VolEscoado  : Real       read FVolEscoado write FVolEscoado;
    {$endif}

    property  Descricao   : String    read FDescricao    write FDescricao;
    property  Comentarios : TStrings  read FComentarios;

    property  ImagemDoComponente : TdrBaseShape       read FImagemDoComponente;
    property  Regiao             : TRect              read GetRect;
    property  Pos                : TPoint             read GetPos        write SetPos;
    property  Menu               : TPopupMenu         read FMenu         write FMenu;
    property  Dialogo            : TForm_Dialogo_Base read FDialogo      write FDialogo;

    // Permite que as planihas que mostram os dados dos componentes sejam inicializadas
    property Evento_IniciarPlanilha : TEvento_IniciarPlanilha
             read FEvento_IniciarPlanilha
             write FEvento_IniciarPlanilha;
  end;

  // Mantém uma lista com referências a objetos
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

    procedure RemoverNulos;

    function  IndiceDo  (Objeto: THidroComponente): Integer;
    function  Remover   (Objeto: THidroComponente): Integer;
    function  Adicionar (Objeto: THidroComponente): Integer;

    procedure Deletar (Indice: Integer);
    procedure Ordenar (FuncaoDeComparacao: TListSortCompare);

    // Iniciada em False, quando True, destroi os objetos referenciados
    property LiberarObjetos : Boolean read FLiberarObjetos write FLiberarObjetos;

    property Objeto[i: Integer] : THidroComponente read getObjeto write setObjeto; default;
    property Objetos            : Integer          read getNumObjetos;
  end;

  // Classes específicas -------------------------------------------------------------

  // Representa um trecho de água entre dois PCs (Montante e Jusante)
  TTrechoDagua = class(THidroComponente)
  private
    FPC_aJusante: TPC;
    FPC_aMontante: TPC;
  protected
    Function ObtemPrefixo: String; override;
    function ReceiveMessage(const MSG: TadvMessage): Boolean; override;
    procedure SalvarEmArquivo(Arquivo: TIF); override;
  public
    constructor Create(PC1, PC2: TPC; UmaTabelaDeNomes: TStrings; Projeto: TProjeto);
    destructor Destroy; override;

    property PC_aMontante : TPC  read FPC_aMontante write FPC_aMontante;
    property PC_aJusante  : TPC  read FPC_aJusante  write FPC_aJusante;
  end;

  TPC = Class(THidroComponente) // Ponto de Controle
  private
    FVisivel    : Boolean;
    FHierarquia : Integer;
    FSubRede    : Integer;

    function  GetPC_aMontante(Index: Integer): TPC;
    function  GetPCs_aMontante: Integer;
    function  GetNumSubBacias: Integer;
    function  GetPC_aJusante: TPC;
    function  GetSubBacia(index: Integer): TSubBacia;
    procedure SetVisivel(Value: Boolean);
    procedure SetPC_aJusante(const Value: TPC);
  protected
    FPCs_aMontante  : TListaDeObjetos;
    FSubBacias      : TListaDeObjetos;
    FTD             : TTrechoDagua;

    procedure AtualizarHint; override;

    // Permite a criação polimórfica de um trecho dágua
    function  CriarTrechoDagua(ConectarEm: TPC): TTrechoDagua; virtual;

    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    procedure SalvarEmArquivo(Arquivo: TIF); override;
  public
    constructor Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor  Destroy; override;

    function  ConectarObjeto(Obj: THidroComponente): Integer; override;
    procedure DesconectarObjetos; override;

    // Retorna verdadeiro se existe objetos conectados, DEVE ser implementado nos descendentes
    function  PossuiObjetosConectados: Boolean; virtual; abstract;

    // Verifica se um PC é o PC que está a montante deste
    function  Eh_umPC_aMontante(PC: THidroComponente): Boolean;

    // Remove o trecho de água deste PC
    procedure RemoverTrecho;

    // Remove o PC que está a montante deste (atrás)
    procedure DesconectarPC_aMontante(PC: TPC);

    // Conecta um PC a montante deste
    procedure ConectarPC_aMontante(PC: TPC);

    procedure BalancoHidrico; virtual; abstract;
    function  ObtemVazoesDeMontante: Real; virtual; abstract;
    function  ObtemVazaoAfluenteSBs: Real; virtual; abstract;

    property SubRede    : Integer read FSubRede    write FSubRede;
    property Hierarquia : Integer read FHierarquia write FHierarquia;
    property Visivel    : Boolean read FVisivel    write SetVisivel;

    property PCs_aMontante : Integer read GetPCs_aMontante;
    property SubBacias     : Integer read GetNumSubBacias;

    // Componentes conectados
    property TrechoDagua               : TTrechoDagua read FTD;
    property PC_aJusante               : TPC          read GetPC_aJusante write SetPC_aJusante;
    property PC_aMontante [i: Integer] : TPC          read GetPC_aMontante;
    property SubBacia     [i: Integer] : TSubBacia    read GetSubBacia;
  end;

  TSubBacia = Class(THidroComponente)
  private
    FPCs    : TListaDeObjetos;
    FCCs    : TDoubleList;
    FArea   : Real;
  protected
    Function  ObtemPrefixo: String; override;
    function  CriarImagemDoComponente: TdrBaseShape; override;
    function  ReceiveMessage(const MSG: TadvMessage): Boolean; override;
    procedure SalvarEmArquivo(Arquivo: TIF); override;
    procedure LerDoArquivo(Ini: TIF; Const Secao: String); override;
    procedure CopiarPara(HC: THidroObjeto); override;
  public
    constructor Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
    destructor Destroy; override;

    function  ObtemVazaoAfluente(PC: TPC): Real; virtual; abstract;

    property Area  : Real             read FArea write FArea;
    property PCs   : TListaDeObjetos  read FPCs;
    property CCs   : TDoubleList    read FCCs;
  end;

  // Representa todos os PCs de um Projeto
  // Esta lista deve ser mantida por ordem crescente de Hierarquia
  TListaDePCs = Class
  private
    FList : TListaDeObjetos;
    function GetPC(Index: Integer): TPC;
    function GetNumPCs: Integer;
    procedure SetPC(index: Integer; const Value: TPC);
    procedure Ordenar;
  public
    constructor Create;
    destructor Destroy; override;

    function Adicionar (PC: TPC): Integer;
    function Remover   (PC: TPC): boolean;
    function IndiceDo  (PC: TPC): Integer;

    // Realiza o algorítimo de cálculo de hierarquia para cada PC e já ordena-os.
    // Também já define as Sub-Redes e atualiza o hint dos PCs
    procedure CalcularHierarquia;

    property PCs: Integer read GetNumPCs;
    property PC[index: Integer]: TPC read GetPC write SetPC; Default;
  end;

  TEventoDeNotificacao = TNotifyEvent;

  TProcPSB = procedure(Projeto: TProjeto; SB: TSubBacia);

  TStatusProjeto = (sFazendoNada, sSimulando, sOtimizando);

  {Todo Projeto está associado a uma Área de Projeto.
  Esta classe encapsula a "rede hidrológica" possuindo assim todos os componentes que a formam.}
  TProjeto = Class(THidroComponente)
  private
    FIni                : TIF;
    FArqFundo           : String;
    FFundoBmp           : TBitmap;
    FDirSaida           : String;         // temporário para cada simulação (DOS)
    FNomeArquivo        : String;
    FPCs                : TListaDePCs;
//    FDirSai             : String;         // Dir. de saída de resultados
//    FDirPes             : String;         // Dir. de pesquisa de arquivos
    FAreaDeProjeto      : TForm;          // Onde a rede é mostrada
    FSubBacias          : TList;
    FSimulador          : TSimulation;    // Controlador do mecanismo de simulação
    FRotinaGeralUsuario : String;
    FScriptGeral        : TPascalScript;
    FObjetosGlobais     : TGlobalObjects;
    FEC                 : String;         // Execucao corrente
    FSC                 : TPascalScript;  // Script corrente
    FStatus             : TStatusProjeto; // Armazena o status de execução do projeto
    FScripts            : TStrings;

    procedure SetFundo(Value: String);
    function GetDirPes: String;
    function GetDirSai: String;
  protected
    procedure SetModificado(const Value: Boolean); override;
    procedure LerDoArquivo(Ini: TIF; const Secao: String); Overload; override;
    procedure SalvarEmArquivo(Arquivo: TIF); Overload; override;
    procedure PegarDadosDoDialogo(d: TForm_Dialogo_Base); override;
    procedure PorDadosNoDialogo(d: TForm_Dialogo_Base); override;
    function  CriarDialogo: TForm_Dialogo_Base; override;
    function  ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    procedure ValidarDados(var TudoOk: Boolean;
                              DialogoDeErros: TfoMessages;
                              Completo: Boolean = False); override;
  public
    constructor Create(UmaTabelaDeNomes: TStrings);
    destructor  Destroy; override;

    // Verifica se o projeto ja foi salvo, isto é, (NomeArquivo <> '')
    // Se não foi salvo gera uma exceção.
    procedure VerificarSeSalvo();

    function  ObtemSubBacias: TList;
    procedure LerDoArquivo(const Nome: String); overload;
    procedure SalvarEmArquivo(const Nome: String); overload;
    procedure PercorreSubBacias(ITSB: TProcPSB); virtual;
    procedure AtualizaPontoExecucao(const EC: String; SCC: TPascalScript);
    procedure ExecutarRotinaGeral;
    function  RealizarDiagnostico(Completo: Boolean = False): Boolean; virtual; abstract;
    function  ObtemDiretorioDoProjeto: String;

    // Mecanismo de Simulação
    procedure ExecutarSimulacao; virtual; abstract;
    procedure TerminarSimulacao; virtual;

    // Retorna o PC dado seu nome
    function PCPeloNome(const Nome: String): TPC;

    // Dir. de saída de resultados
    property DirSai : String read GetDirSai;

    // Dir. de pesquisa de arquivos
    property DirPes : String read GetDirPes;

    // PCs que formam a rede hidrológica
    property PCs : TListaDePCs read FPCs write FPCs;

    // Através desta propriedade, formecemos um mecanismo para acessibilidade de
    // objetos entre execuções de Scripts.
    property ObjetosGlobais : TGlobalObjects read FObjetosGlobais;

    property NomeArquivo        : String           read FNomeArquivo   write FNomeArquivo;
    property ArqFundo           : String           read FArqFundo      write SetFundo;
    property FundoBmp           : TBitmap          read FFundoBmp;
    property AreaDeProjeto      : TForm            read FAreaDeProjeto write FAreaDeProjeto;
    property Simulador          : TSimulation      read FSimulador;
    property Status             : TStatusProjeto   read FStatus        write FStatus;
    property Scripts            : TStrings         read FScripts;

    property SubBacias          : TList            read FSubBacias;

    // Somente para uso interno (Debug)
    property ScriptCorrente     : TPascalScript  read FSC write FSC;
    property ExecucaoCorrente   : String         read FEC write FEC;
  end;

  procedure SalvaSubBacia(Projeto: TProjeto; SB: TSubBacia);

implementation
uses Dialogs, FileCTRL, Math, drPlanilha, wsConstTypes
     ,{$IFDEF DEBUG} uDEBUG, {$ENDIF}
     //stDate,
     Hidro_Procs,
     Hidro_Variaveis,
     //ovcIntL,
     WinUtils,
     FileUtils,
     GraphicUtils,
     Series,
     AreaDeProjeto_Base,
     VisaoEmArvore_Base,
     Planilha_DadosDosObjetos,
     {$ifdef IPHS1}
     iphs1_Classes,
     iphs1_Procs,
     iphs1_Dialogo_Base,
     iphs1_Dialogo_VazaoCont,
     {$endif}
     Dialogo_Projeto;

// Realiza um type-casting, só isso
Function AP(F: TForm): TForm_AreaDeProjeto_base;
begin
  Result := TForm_AreaDeProjeto_base(F);
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
     for i := 0 to FList.Count-1 do
       THidroComponente(FList[i]).Free;

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

function TListaDePCs.Adicionar(PC: TPC): Integer;
begin
  {$IFDEF DEBUG}
  gDebug.Write('TListaDePCs.AdicionaPC');
  {$ENDIF}

  PC.Modificado := True;
  Result := FList.Adicionar(PC);
end;

function TListaDePCs.Remover(PC: TPC): boolean;
var PS  : TPC; // PC seguinte
    i   : Integer;
begin
  {$IFDEF DEBUG}
  gDebug.Write('TListaDePCs.RemovePC');
  {$ENDIF}

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

function TListaDePCs.GetPC(Index: Integer): TPC;
begin
  try
    Result := TPC(FList[Index]);
  except
    Raise Exception.Create('Índice do PC inválido: ' + IntToStr(Index));
  end;
end;

// Realiza o algorítimo de cálculo de hierarquia para cada PC e já ordena-os.
// Também já define as Sub-Redes e atualiza o hint dos PCs
procedure TListaDePCs.CalcularHierarquia;

   procedure AtribuiIDparaSubRede(PC: TPC; k: Integer);
   var i: Integer;
   begin
     PC.SubRede := k;
     PC.AtualizarHint;
     for i := 0 to PC.PCs_aMontante-1 do
       AtribuiIDparaSubRede(PC.PC_aMontante[i], k);
   end;

var i, k: Integer;
    PC: TPC;
begin
  // Primero calcula a hierarquia de cada PC
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

         // previne a entrada em loop infinito caso o usuário feche um ciclo
         if k = 1000 then Raise Exception.Create('Erro: Um ciclo recursivo foi fechado.'#13 +
                                                 'Por favor, desfaça.');
         end;
       end;

  Ordenar;

  // Calcula as Sub-Redes
  k := 0;
  for i := 0 to PCs-1 do
    if Self.PC[i].PC_aJusante = nil then // ultimo PC da i-egima sub-Rede
       begin
       inc(k);

       // Varre esta Sub-Rede de traz para frente e lhe atribui um ID de Sub-Rede
       AtribuiIDparaSubRede(Self.PC[i], k);
       end;
end;

function FuncaoDeComparacao(pc1, pc2: Pointer): Integer;
begin
  Result := TPC(pc1).Hierarquia - TPC(pc2).Hierarquia;
end;

procedure TListaDePCs.Ordenar;
begin
  FList.Ordenar(FuncaoDeComparacao);
end;

function TListaDePCs.IndiceDo(PC: TPC): Integer;
begin
  Result := FList.IndiceDo(PC);
end;

procedure TListaDePCs.SetPC(index: Integer; const Value: TPC);
begin
  try
    FList[Index] := Value;
  except
    Raise Exception.Create('Índice de PC inválido: ' + IntToStr(Index));
  end;
end;

{$ifdef IPHS1}
{ Tiphs1_IB }

constructor Tiphs1_IB.Create(HC: THidroComponente);
begin
  inherited Create;
  FHC  := HC;
  FGHC := True;
  FITH := True;
  FVC  := True;
end;

destructor Tiphs1_IB.Destroy;
begin
  FDO.Free();
  inherited;
end;

function Tiphs1_IB.LerDadosObs(): TV;
var s: string;
begin
  FreeAndNil(FDO);
  s := FNDO;
  if HC.VerificaCaminho(s) then
     begin
     FDO := TV.Create(0);
     FDO.LoadFromTextFile(s);
     end;
  result := FDO;   
end;

procedure Tiphs1_IB.LerDoArquivo(Arquivo: TIF; const Secao: String);
begin
  with Arquivo do
    begin
    byte(FOper) := ReadInteger(Secao, 'Oper', 0);

    FPDO := ReadBool  (Secao, 'PDO' , False);
    FNDO := ReadString(Secao, 'DO'  , '');
    end;
end;

procedure Tiphs1_IB.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
begin
  if d is Tiphs1_Form_Dialogo_Base then
     with (d as Tiphs1_Form_Dialogo_Base) do
       begin
       FPDO := rbPDO.Checked;
       FNDO := edObs.Text;
       end
end;

procedure Tiphs1_IB.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  if d is Tiphs1_Form_Dialogo_Base then
     with (d as Tiphs1_Form_Dialogo_Base) do
       begin
       rbPDO.Checked := FPDO;
       edObs.Text := FNDO;
       end
end;

procedure Tiphs1_IB.SalvarEmArquivo(Arquivo: TIF; const Secao: String);
begin
  with Arquivo do
    begin
    WriteInteger(Secao, 'Oper', byte(FOper));
    WriteBool   (Secao, 'PDO' , FPDO);
    WriteString (Secao, 'DO'  , FNDO);
    end;
end;

procedure Tiphs1_IB.ValidarDados(Nome: String; Dialogo: TForm; var TudoOk: Boolean;
                                 DialogoDeErros: TfoMessages; Completo: Boolean);
var s: string;
    NIT: integer;
    v: TwsSFVec;
begin
  if FPDO then
     begin
     s := FNDO;
     NIT := Tiphs1_Projeto(HC.Projeto).NIT;
     if HC.VerificaCaminho(s) then
        begin
        v := TwsSFVec.Create(NIT);
        v.LoadFromTextFile(s);
        if v.Len <> NIT then
           begin
           DialogoDeErros.Add(etError,
           Format('Objeto: %s'#13 +
                  'Número de Valores (%d) encontrado no arquivo de Dados Observados'#13 +
                  '%s'#13 +
                  'não pode ser diferente do Número de Intervalos de Tempo do Projeto (%d)'
                  ,[Nome, v.Len, s, NIT]));
           TudoOk := False;
           end;
        end
     else
        begin
        DialogoDeErros.Add(etError,
        Format('Objeto: %s'#13'Arquivo de Dados Observados não encontrado.', [Nome]));
        TudoOk := False;
        end;
     end;
end;
{$endif}

{ THidroObjeto }

constructor THidroObjeto.Create();
begin
  inherited Create;
  GetMessageManager.RegisterMessage(UM_RESET_VISIT, Self);
  FAvisarQueVaiSeDestruir := True;
end;

destructor THidroObjeto.Destroy();
begin
  GetMessageManager.UnRegisterMessage(UM_RESET_VISIT, Self);
  inherited Destroy();
end;
{
procedure THidroObjeto.Avisar_e_Destruir();
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  Free();
end;
}
procedure THidroObjeto.LerDoArquivo(Ini: TIF; const Secao: String);
begin
  SetNome(Ini.ReadString (Secao, 'Nome', ''));
  FBloqueado := Ini.ReadBool   (Secao, 'Bloqueado', False);
end;

procedure THidroObjeto.SalvarEmArquivo(Arquivo: TIF);
begin
  Arquivo.WriteString (Secao, 'Nome'     , FNome);
  Arquivo.WriteString (Secao, 'Classe'   , Self.ClassName);
  Arquivo.WriteBool   (Secao, 'Bloqueado', FBloqueado);
end;

function THidroObjeto.ReceiveMessage(Const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_RESET_VISIT then Visitado := False;
end;

procedure THidroObjeto.SetModificado(const Value: Boolean);
begin
  FModificado := Value;
  if FProjeto <> nil then
     FProjeto.Modificado := Value;
end;

function THidroObjeto.GetSecao: String;
begin
  Result := 'Dados ' + FNome;
end;

procedure THidroObjeto.SetNome(const Value: String);
var i: Integer;
begin
  if Value <> FNome then
     begin
     i := TN.IndexOf(FNome);
     if i > -1 then TN.Delete(i);
     FNome := Value;
     TN.Add(FNome);
     end;
end;

procedure THidroObjeto.CopiarPara(HC: THidroObjeto);
begin
  HC.FAvisarQueVaiSeDestruir := FAvisarQueVaiSeDestruir;
end;

function THidroObjeto.CriarInstancia: THidroObjeto;
begin
  Result := THidroObjeto.Create;
end;

function THidroObjeto.Clonar: THidroObjeto;
begin
  Result := CriarInstancia;
  CopiarPara(Result);
end;

procedure THidroObjeto.CopiarDadosPara(HC: THidroObjeto);
begin
  CopiarPara(HC);
end;

{ THidroComponente }

constructor THidroComponente.Create(UmaTabelaDeNomes: TStrings; Projeto: TProjeto);
begin
  inherited Create;

  self.FProjeto := Projeto;
  TN            := UmaTabelaDeNomes;
  FNome         := ObtemNome();
  FComentarios  := TStringList.Create;

  GetMessageManager.RegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.RegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_INICIAR_SIMULACAO, self);
  GetMessageManager.RegisterMessage(UM_BLOQUEAR_OBJETOS, self);

  {$ifdef IPHS1}
  FIB := Tiphs1_IB.Create(self);
  FHidrogramas := TIV.Create(0);
  GetMessageManager.RegisterMessage(UM_OBTER_OBJETO_PELA_OPER, self);
  {$endif}

  if TN <> nil then TN.Add(FNome);
  AtualizarHint;
end;

destructor THidroComponente.Destroy;
var i: Integer;
begin
  FComentarios.Free;

  {$ifdef IPHS1}
  FIB.Free;
  FHR.Free;
  FHidrogramas.Free;
  FVazaoCont.Free;
  GetMessageManager.UnRegisterMessage(UM_OBTER_OBJETO_PELA_OPER, self);
  {$endif}

  GetMessageManager.UnRegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.UnRegisterMessage(UM_INICIAR_SIMULACAO, self);
  GetMessageManager.UnRegisterMessage(UM_BLOQUEAR_OBJETOS, self);

  if TN <> nil then
     begin
     i := TN.IndexOf(FNome);
     if i > -1 then TN.Delete(i);
     end;

  FImagemDoComponente.Free();

  Inherited Destroy();
end;

function THidroComponente.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
    s: String;
begin
  if MSG.ID = UM_BLOQUEAR_OBJETOS then
     begin
     if MSG.ParamAsObject(1) = self.Projeto then
        FBloqueado := MSG.ParamAsBoolean(0);
     end else

  if MSG.ID = UM_OBTEM_OBJETO then
     {Verifica se o nome do objeto atual bate com o parâmetro passado.
      Se opcionalmente um terceiro parâmetro for passado (projeto) verificamos
      se este objeto pertence a este projeto.}
     begin
     s := MSG.ParamAsString(0);

     if (CompareText(s, Nome) = 0) then
        if (Length(s) = 3) then
           if (MSG.ParamAsObject(2) = FProjeto) then
              pRecObjeto(MSG.ParamAsObject(1)).Obj := Self
           else
              {nada}
        else
           pRecObjeto(MSG.ParamAsObject(1)).Obj := Self
     end else

    if MSG.ID = UM_INICIAR_SIMULACAO then
       if MSG.ParamAsObject(0) = FProjeto then
          PrepararParaSimulacao
{$ifndef IPHS1}
    ;
{$else}
       else
    else

    if MSG.ID = UM_OBTER_OBJETO_PELA_OPER then
       if (MSG.ParamAsInteger(0) = FIB.NHS) and
          (MSG.ParamAsObject(2) = FProjeto) then
          pRecObjeto(MSG.ParamAsObject(1)).Obj := Self;
{$endif}

  inherited ReceiveMessage(MSG);
end;

function THidroComponente.MostrarDialogo(const Caption: String = ''): Integer;
var i: Integer;
begin
  if FProjeto.Simulador <> nil then Exit;
  Result := mrNone;

  StartWait;
  try
    Dialogo := CriarDialogo;
    Dialogo.Objeto := Self;
    if Caption <> '' then Dialogo.Caption := Caption;
  finally
    StopWait;
  end;

  i := TN.IndexOf(FNome);
  if i <> -1 then TN.Delete(i);
  Try
    PorDadosNoDialogo(Dialogo);
    Dialogo.Bloqueado := FBloqueado;
    Dialogo.Hide;
    Result := Dialogo.ShowModal;
    if (Result = mrOk) and (not FBloqueado) then
       begin
       SetModificado(True);
       PegarDadosDoDialogo(Dialogo);
       end;
  Finally
    if i <> -1 then TN.Add(FNome);
    Dialogo.Free;
    Dialogo := nil;
  End;
end;

procedure THidroComponente.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  {$ifdef IPHS1}
  FIB.PorDadosNoDialogo(d);
  {$endif}
  d.edNome.Text       := FNome;
  d.edDescricao.Text  := FDescricao;
  d.mComentarios.Text := FComentarios.Text;
end;

procedure THidroComponente.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
var s: String;
begin
  {$ifdef IPHS1}
  FIB.PegarDadosDoDialogo(d);
  {$endif}

  if FNome <> d.edNome.Text then
     begin
     s := FNome; // salva o nome antigo
     setNome(d.edNome.Text); // renomeia nome
     GetMessageManager.SendMessage(UM_NOME_OBJETO_MUDOU, [Self, @s, @FNome]); // avisa
     end;

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

  AtualizarHint;
end;

procedure THidroComponente.DuploClick(Sender: TObject);
begin
  FProjeto.VerificarSeSalvo();
  MostrarDialogo();
end;

procedure THidroComponente.SalvarEmArquivo(Arquivo: TIF);
var s: String;
    p: TPoint;
begin
  inherited;

  {$ifdef IPHS1}
  FIB.SalvarEmArquivo(Arquivo, Secao);
  {$endif}

  with Arquivo do
    begin
    WriteString  (Secao, 'Descricao'  , FDescricao);

    { Isto é necessário devido a um possível bug em (TStrings.CommaText).
      Quando tentamos atribuir uma string no formato ["aaaaaa bbbb ccccc"] ele
      se perde. Se houver uma única (,) no final, isto já é suficiente para o
      erro não acontecer. Ex: ["aaaaa bbbb cccc",]}
    s := FComentarios.CommaText;
    if Length(s) > 0 then
       if s[Length(s)] <> ',' then s := s + ',';
    WriteString(Secao, 'Comentarios', s);

    if FImagemDoComponente <> nil then
       begin
       p := GetPos;
       WriteInteger (Secao, 'x', P.x);
       WriteInteger (Secao, 'y', P.y);
       end;
    end;
end;

function THidroComponente.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := TForm_Dialogo_Base.Create(nil);
  Result.TN := TN;
end;

function THidroComponente.ObtemNome: String;
var i: Integer;
    Prefixo: String;
begin
  if TN <> nil then
     begin
     i := 0;
     Prefixo := ObtemPrefixo;
     repeat
       inc(i);
       Result := Prefixo + IntToStr(i);
       until TN.IndexOf(Result) = -1
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
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
begin
  {$ifdef IPHS1}
  if not (self is TProjeto) then
     FIB.ValidarDados(Nome, Dialogo, TudoOk, DialogoDeErros, Completo);
  {$endif}
end;

procedure THidroComponente.CriarComponenteVisual;
begin
  FImagemDoComponente             := CriarImagemDoComponente; // Método virtual
  FImagemDoComponente.Tag         := Integer(self);
  FImagemDoComponente.Parent      := FProjeto.AreaDeProjeto;
  FImagemDoComponente.OnMouseDown := AP(FProjeto.AreaDeProjeto).Form_MouseDown;
  FImagemDoComponente.OnMouseMove := AP(FProjeto.AreaDeProjeto).Form_MouseMove;
  FImagemDoComponente.OnMouseUp   := AP(FProjeto.AreaDeProjeto).Form_MouseUp;
  FImagemDoComponente.OnClick     := AP(FProjeto.AreaDeProjeto).Form_Click;
  FImagemDoComponente.OnDblClick  := DuploClick;
  FImagemDoComponente.Canvas.Brush.Color := clBlue;
  FImagemDoComponente.Width       := 10;
  FImagemDoComponente.Height      := 10;
end;

procedure THidroComponente.LerDoArquivo(Ini: TIF; Const Secao: String);
var x, y: Integer;
begin
  Inherited;

  {$ifdef IPHS1}
  FIB.LerDoArquivo(Ini, Secao);
  {$endif}

  FDescricao             := Ini.ReadString(Secao, 'Descricao', '');
  FComentarios.CommaText := Ini.ReadString(Secao, 'Comentarios', '');

  if ImagemDoComponente <> nil then
     begin
     x := Ini.ReadInteger(Secao, 'X', 0);
     y := Ini.ReadInteger(Secao, 'Y', 0);
     SetPos(Point(x, y));
     end;

  AtualizarHint;
end;

function THidroComponente.GetPos: TPoint;
begin
  Result := FImagemDoComponente.Center;
end;

function THidroComponente.GetRect: TRect;
begin
  if FImagemDoComponente <> nil then with FImagemDoComponente do
     Result := Classes.Rect(Left, Top, Left + Width, Top + Height);
end;

procedure THidroComponente.SetPos(const Value: TPoint);
begin
  {$IFDEF DEBUG}
  gDebug.Write('THidroComponente.SetPos');
  {$ENDIF}

  SetModificado(True);
  FImagemDoComponente.Left := Value.x - FImagemDoComponente.Width  div 2;
  FImagemDoComponente.Top  := Value.y - FImagemDoComponente.Height div 2;
end;

procedure THidroComponente.AtualizarHint;
var s: String;
begin
  if FImagemDoComponente <> nil then
     begin
     s := FNome;
     if alltrim(FDescricao) <> '' then s := s + #13#10 + FDescricao;
     FImagemDoComponente.Hint := s;
     end;
end;

procedure THidroComponente.PrepararParaSimulacao;
begin
  {$ifdef IPHS1}
  FHR.Free;
  FHR := TwsSFVec.Create(Tiphs1_Projeto(Projeto).NIT);

  FreeAndNil(FVazaoCont);
  FVazaoCont := TwsDataSet.CreateFix('VazaoCont', 9, [dtNumeric, dtNumeric, dtNumeric, dtNumeric]);
  FVazaoCont.ColName[1] := 'QLim_QMax';
  FVazaoCont.ColName[2] := 'QLimite';
  FVazaoCont.ColName[3] := 'Voluma';
  FVazaoCont.ColName[4] := 'Area';
  FVazaoCont.Fill(0);

  FHidrogramas.Len := 0;
  {$endif}
end;

procedure THidroComponente.MostrarMenu(x, y: Integer);
var p: TPoint;
begin
  if FMenu <> nil then
     begin
     PrepararMenu;
     if x <> -1 then
        FMenu.Popup(x, y)
     else
        begin
        p := FProjeto.AreaDeProjeto.ClientToScreen(Point(0,0));
        FMenu.Popup(p.x + Pos.x, p.y + Pos.y);
        end;
     end;
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

procedure THidroComponente.VerificarScriptDoUsuario(Arquivo: String; const Texto: String;
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
           PS := TPascalScript.Create;
           PS.Code.LoadFromFile(Arquivo);

           // bibliotecas
           PS.AssignLib(g_psLib);
           PS.Variables.AddVar(
             TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True));

           // Objetos Globais
           PS.GlobalObjects := Projeto.ObjetosGlobais;

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

procedure THidroComponente.PrepararScript(Arquivo: String; var Script: TPascalScript);
begin
  if Script = nil then Script := TPascalScript.Create;
  VerificaCaminho(Arquivo);
  Script.GlobalObjects := Projeto.ObjetosGlobais;
  with Script do
    begin
    // Bibliotecas
    AssignLib(g_psLib);

    // Leitura do Codigo
    Code.LoadFromFile(Arquivo);

    // Opções
    GerCODE  := True;
    Optimize := True;
{
    // Variáveis pré-inicializadas
    Variables.AddVar(
      TVariable.Create('Saida', pvtObject, Integer(gOutPut), gOutPut.ClassType, True));
}
    Variables.AddVar(
      TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True));

    // Compile;
    end;
end;

procedure THidroComponente.ColocarDadosNaPlanilha(Planilha: TForm_Planilha_Base);
begin
  // Nada
end;

procedure THidroComponente.MostrarPlanilha;
var d: TForm_Planilha_DadosDosObjetos;
    i: Integer;
begin
  d := TForm_Planilha_DadosDosObjetos.Create(FProjeto.AreaDeProjeto);
  d.Caption := 'Dados do(a) ' + Nome;
  d.Show;
  StartWait;
  try
    if Assigned(FEvento_IniciarPlanilha) then FEvento_IniciarPlanilha(Self, d);
    ColocarDadosNaPlanilha(d);
  finally
    StopWait;
  end;
end;

function THidroComponente.ConectarObjeto(Obj: THidroComponente): Integer;
begin
  // Nada
end;

function THidroComponente.CriarImagemDoComponente: TdrBaseShape;
begin
  // Nada
end;

procedure THidroComponente.DesconectarObjetos;
begin
  // Nada
end;

{$ifdef IPHS1}
procedure THidroComponente.MostrarHidrogramaResultante;
var p: TPlanilha;
begin
  StartWait;
  try
    p := TPlanilha.Create;
    p.Caption := Projeto.Nome + ': ' + Nome + ' - Hidrograma Resultante (m³/s)';
    p.nRows := HidroRes.Len;
    p.WriteVecInCol(HidroRes, 1, 1);
    p.Show(fsMDIChild);
  finally
    StopWait;
  end;
end;

procedure THidroComponente.PlotarHidrogramaResultante();
var G: TfoSheetChart;
    C: THidroComponente;
    v: TV;
begin
  G := TfoSheetChart.Create(Nome);
  G.Caption := Projeto.Nome + ': ' + Nome + ' - Hidrograma Resultante (m³/s)';
  G.Width := 400;
  G.cb3D.Checked := False;
  G.Chart.BottomAxis.Title.Caption := 'Intervalos (n. Delta T)';

  if IB.FNHP = 0 then
     begin
     if FHidrogramas.Len > 0 then
        begin
        v := CalcularSomaDeHidrogramas();
        if v <> nil then
           begin
           G.Series.AddLineSerie('Qe (m³/s)', clBLUE, v);
           v.Free;
           end;
        end
     else
        begin
        C := ObterObjetoPelaOperacao(IB.FNHE);
        if (C <> nil) then G.Series.AddLineSerie('Qe (m³/s)', clBLUE, C.HidroRes);
        end;

     G.Series.AddLineSerie('Qs (m³/s)', clRED, HidroRes);
     if IB.DadosObs <> nil then
        G.Series.AddLineSerie('Dados Obs. (m³/s)', clGREEN, IB.DadosObs);
     end
  else
     begin
     C := ObterObjetoPelaOperacao(IB.FNHP);
     if (C <> nil) then
        begin
        G.Series.AddLineSerie('Qs (m³/s)', clRED, C.HidroRes);
        if C.IB.DadosObs <> nil then
           G.Series.AddLineSerie('Dados Obs. (m³/s)', clBLUE, C.IB.DadosObs);
        end;
     end;

  PlotarInformacoesExtras(G);

  G.Show(fsMDIChild);
end;

procedure THidroComponente.PlotarHidrogramaResultanteDosObjConectados();
var G: TfoSheetChart;
begin
  G := TfoSheetChart.Create(Nome);
  G.Caption := Projeto.Nome + ': ' + Nome + ' - Hidrogramas Resultantes (m³/s)';
  G.Chart.BottomAxis.Title.Caption := 'Intervalos (n. Delta T)';
  G.Width := 400;
  G.cb3D.Checked := False;
  PlotarHidrogramasEm(G);
  G.Show(fsMDIChild);
end;

procedure THidroComponente.PlotarHidrogramasResultantes(Objetos: TStrings);
var G: TfoChart;
    i: Integer;
    HC, C: THidroComponente;
begin
  G := TfoChart.Create(Nome);                                     
  G.Caption := Projeto.Nome + ' - Hidrogramas Resultantes (m³/s)';
  G.Chart.Legend.Visible := True;
  G.Chart.BottomAxis.Title.Caption := 'Intervalos (n. Delta T)';
  G.Width := 400;
  G.cb3D.Checked := False;
  for i := 0 to Objetos.Count-1 do
    begin
    HC := THidroComponente(Objetos.Objects[i]);
    if HC.IB.NHP = 0 then
       G.Series.AddLineSerie('Qs de ' + Objetos[i] + ' (m³/s)', SelectColor(i), HC.HidroRes)
    else
       begin
       C := ObterObjetoPelaOperacao(HC.IB.NHP);
       if (C <> nil) then G.Series.AddLineSerie('Qs de ' + Objetos[i] + ' (m³/s)', SelectColor(i), C.HidroRes);
       end;
    end;
  G.Show(fsMDIChild);
end;

procedure THidroComponente.MostrarHidrogramasResultantes(Objetos: TStrings);
var P: TPlanilha;
    i: Integer;
    HC, C: THidroComponente;
begin
  P := TPlanilha.Create;
  p.Caption := Projeto.Nome + ' - Hidrogramas Resultantes (m³/s)';
  P.Window.Width := 400;
  P.nCols := Objetos.Count;
  if Objetos.Count > 0 then P.nRows := THidroComponente(Objetos.Objects[0]).HidroRes.Len;
  for i := 0 to Objetos.Count-1 do
    begin
    P.SetCellFont(1, i+1, 'arial', 10, clBlack, True);
    HC := THidroComponente(Objetos.Objects[i]);
    if HC.IB.NHP = 0 then
       begin
       P.Write(1, i+1, Objetos[i]);
       P.WriteVecInCol(HC.HidroRes, i+1, 2);
       end
    else
       begin
       C := ObterObjetoPelaOperacao(HC.IB.NHP);
       if (C <> nil) then
          begin
          P.Write(1, i+1, Objetos[i]);
          P.WriteVecInCol(C.HidroRes, i+1, 2);
          end;
       end;
    end;
  P.Show(fsMDIChild);
end;

function THidroComponente.ObterObjetoPelaOperacao(Oper: Integer): THidroComponente;
var p: pRecObjeto;
begin
  New(p);
  p.Obj := nil;
  GetMessageManager.SendMessage(UM_OBTER_OBJETO_PELA_OPER, [@Oper, p, Self.Projeto]);
  Result := THidroComponente(p.Obj);
  Dispose(p);
end;

procedure THidroComponente.PlotarVazaoControlada;
begin
  with Tiphs1_Form_Dialogo_VazaoCont.Create(Self) do Show;
end;
{$endif}

function THidroComponente.CriarInstancia: THidroObjeto;
begin
  Result := THidroComponente.Create(TN, Projeto);
end;

procedure THidroComponente.CopiarPara(HC: THidroObjeto);
begin
  inherited;
  THidroComponente(HC).FDescricao := FDescricao;
  THidroComponente(HC).FComentarios.Assign(FComentarios);

{$ifdef IPHS1}
  with THidroComponente(HC).FIB do
    begin
    FPDO  := self.FIB.FPDO;
    FOper := self.FIB.FOper;
    FNDO   := self.FIB.FNDO;
    end;

  THidroComponente(HC).FVolEscoado := FVolEscoado;
{$endif}
end;

function THidroComponente.CalcularSomaDeHidrogramas: TV;
var i : Integer;
    v : TV;
    c : THidroComponente;
    EC: word;
begin
  Result := nil;
  if FHidrogramas.Len > 0 then
     for i := 1 to FHidrogramas.Len do
       begin
       c := ObterObjetoPelaOperacao(FHidrogramas[i]);
       if c <> nil then
          begin
          if Result = nil then
             begin
             Result := TV.Create(0);
             Result.Assign(c.HidroRes);
             end
          else
             Result.ByElement(c.HidroRes, opSum, False, EC);
          end;
       end;
end;

function THidroComponente.ObterHidrogramaDeEntrada: TV;
var C: THidroComponente;
    i: Integer;
begin
  Result := nil;
  if IB.FNHP = 0 then
     if FHidrogramas.Len > 0 then
        Result := CalcularSomaDeHidrogramas
     else
        begin
        C := ObterObjetoPelaOperacao(IB.FNHE);
        if (C <> nil) and (C.HidroRes <> nil) then
           begin
           Result := TV.Create(C.HidroRes.Len);
           for i := 1 to C.HidroRes.Len do Result[i] := C.HidroRes[i];
           end
        end;
end;

// Plota informações extras no gráfico dos hidrogramas resultantes
procedure THidroComponente.PlotarInformacoesExtras(G: TfoSheetChart);
begin
  // Nada neste ponto
end;

{ TTrechoDagua }

constructor TTrechoDagua.Create(PC1, PC2: TPC; UmaTabelaDeNomes: TStrings; Projeto: TProjeto);
begin
  inherited Create(UmaTabelaDeNomes, Projeto);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);
  PC_aMontante := PC1;
  PC_aJusante  := PC2;
end;

destructor TTrechoDagua.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);
  inherited Destroy;
end;

function TTrechoDagua.ObtemPrefixo: String;
begin
  Result := 'TrechoDagua_';
end;

function TTrechoDagua.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
begin
  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     if MSG.ParamAsObject(0) = PC_aJusante then
        PC_aJusante := TPC(MSG.ParamAsObject(1)) else

     if MSG.ParamAsObject(0) = PC_aMontante then
        PC_aMontante := TPC(MSG.ParamAsObject(1));
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TTrechoDagua.SalvarEmArquivo(Arquivo: TIF);
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteString (Secao, 'PM', PC_aMontante.Nome);
    WriteString (Secao, 'PJ', PC_aJusante. Nome);
    end;
end;

{ TPC }

constructor TPC.Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  {$IFDEF DEBUG}
  gDebug.Write('TPC.Create');
  {$ENDIF}

  Inherited Create(UmaTabelaDeNomes, Projeto);

  FHierarquia  := -1;

  FPCs_aMontante  := TListaDeObjetos.Create;
  FSubBacias      := TListaDeObjetos.Create;

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);

  CriarComponenteVisual;
  if Pos.x > -100 then SetPos(Pos); // Indica que outros objetos usam SetPos
end;

{Teoricamente, as listas deverão estar vazias}
destructor TPC.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);

  FPCs_aMontante.Free;
  FSubBacias.Free;
  if FTD <> nil then FTD.Free;
  Inherited Destroy;
end;

function TPC.ConectarObjeto(Obj: THidroComponente): Integer;
var PC: TPC;
    SB: TSubBacia;
begin
  SetModificado(True);

  // Objeto é uma Sub-Bacia ----------------------------------------------------------
  if Obj is TSubBacia then
     begin
     SB := TSubBacia(Obj);
     FSubBacias.Adicionar(SB);
     SB.PCs.Adicionar(Self);
     if SB.PCs.Objetos > SB.CCs.Count then
        if SB.CCs.Count = 0 then
           SB.CCs.Add(1.0)
        else
           SB.CCs.Add(0.0);
     end else

  // Objeto é um PC ------------------------------------------------------------------
  if Obj is TPC then
     begin
     PC := TPC(Obj);
     PC.ConectarPC_aMontante(Self);
     Self.PC_aJusante := PC;
     end;
end;

procedure TPC.DesconectarObjetos;
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
end;

procedure TPC.ConectarPC_aMontante(PC: TPC);
begin
  FPCs_aMontante.Adicionar(PC);
end;

function TPC.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
    o: THidroComponente;
begin
  if MSG.ID = UM_OBJETO_SE_DESTRUINDO then
    {Verifica se o objeto que está se destruindo está conectado a este PC.
     Se está, elimina a referência}
     begin
     o := THidroComponente(MSG.ParamAsObject(0));
     i := FSubBacias.IndiceDo(o);
     if i > -1 then FSubBacias[i] := nil;
     if o = FTD then RemoverTrecho();
     end else

  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint else

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     i := FPCs_aMontante.IndiceDo(THidroComponente(MSG.ParamAsObject(0)));
     if i > -1 then FPCs_aMontante.Objeto[i] := THidroComponente(MSG.ParamAsObject(1));
     end;

  inherited ReceiveMessage(MSG);
end;

procedure TPC.SalvarEmArquivo(Arquivo: TIF);
var i: Integer;
begin
  Inherited;
  with Arquivo do
    begin
    if TrechoDagua <> nil then
       WriteString (Secao, 'TD', TrechoDagua.Nome);

    WriteInteger (Secao, 'SubBacias', SubBacias);
    for i := 0 to SubBacias - 1 do
       WriteString (Secao, 'SB'+IntToStr(i+1), SubBacia[i].Nome);
    end;
end;

procedure TPC.SetVisivel(Value: Boolean);
begin
  FVisivel := Value;
  FImagemDoComponente.Visible := FVisivel;
end;

function TPC.GetPCs_aMontante: Integer;
begin
  Result := FPCs_aMontante.Objetos;
end;

function TPC.GetNumSubBacias: Integer;
begin
  FSubBacias.RemoverNulos;
  Result := FSubBacias.Objetos;
end;

function TPC.GetPC_aJusante: TPC;
begin
  if FTD <> nil then
     Result := FTD.PC_aJusante
  else
     Result := nil;
end;

procedure TPC.SetPC_aJusante(const Value: TPC);
begin
  if FTD <> nil then
     FTD.PC_aJusante := Value
  else
     FTD := CriarTrechoDagua(Value);
end;

function TPC.CriarTrechoDagua(ConectarEm: TPC): TTrechoDagua;
begin
  Result := TTrechoDagua.Create(Self, ConectarEm, TN, FProjeto);
end;

function TPC.GetPC_aMontante(Index: Integer): TPC;
begin
  Result := TPC(FPCs_aMontante[Index]);
end;

function TPC.GetSubBacia(index: Integer): TSubBacia;
begin
  Result := TSubBacia(FSubBacias[Index]);
end;

// Remove a coneccao do PC que está a montante deste PC
procedure TPC.DesconectarPC_aMontante(PC: TPC);
begin
  FPCs_aMontante.Remover(PC);
end;

procedure TPC.RemoverTrecho();
begin
  if FTD <> nil then
     begin
     SetModificado(True);
     FTD.PC_aJusante.DesconectarPC_aMontante(FTD.PC_aMontante);
     FTD.Free;
     FTD := nil;
     end;
end;

function TPC.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrRectangle.Create(nil);
end;

function TPC.Eh_umPC_aMontante(PC: THidroComponente): Boolean;
begin
  Result := (FPCs_aMontante.IndiceDo(PC) > -1);
end;

procedure TPC.AtualizarHint;
begin
  inherited;
  if FImagemDoComponente <> nil then
     FImagemDoComponente.Hint := FImagemDoComponente.Hint + #13#10 +
       Format('Sub-Rede: %d   Hierarquia: %d', [FSubRede, FHierarquia]);
end;

{ TSubBacia }

constructor TSubBacia.Create(Pos: TPoint; Projeto: TProjeto; UmaTabelaDeNomes: TStrings);
begin
  inherited Create(UmaTabelaDeNomes, Projeto);
  FArea := 1;

  FPCs      := TListaDeObjetos.Create;
  FCCs      := TDoubleList.Create;

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);

  if Projeto <> nil then
     begin
     CriarComponenteVisual;
     FImagemDoComponente.Width  := 20;
     FImagemDoComponente.Height := 20;
     SetPos(Pos);
     end;
end;

destructor TSubBacia.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);

  FPCs.Free;
  FCCs.Free;
  inherited Destroy;
end;

procedure TSubBacia.SalvarEmArquivo(Arquivo: TIF);
var i: Integer;
begin
  Inherited SalvarEmArquivo(Arquivo);
  with Arquivo do
    begin
    WriteFloat   (Secao, 'Area'    ,               FArea);
    //WriteString  (Secao, 'Vazoes Afluentes',       FArqVA);

    WriteInteger (Secao, 'Coefs. de Contribuicao' , FCCs.Count);
    for i := 0 to FCCs.Count - 1 do
       WriteFloat (Secao, 'Coef'+IntToStr(i+1), FCCs[i]);
    end;
end;

function TSubBacia.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
begin
  if (MSG.ID = UM_REPINTAR_OBJETO) and (FImagemDoComponente <> nil) then
     FImagemDoComponente.Paint else

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     i := FPCs.IndiceDo(THidroComponente(MSG.ParamAsObject(0)));
     if i > -1 then FPCs.Objeto[i] := THidroComponente(MSG.ParamAsObject(1));
     end;

  inherited ReceiveMessage(MSG);
end;

function TSubBacia.ObtemPrefixo: String;
begin
  Result := 'SubBacia_';
end;

function TSubBacia.CriarImagemDoComponente: TdrBaseShape;
begin
  Result := TdrBitmap.Create(nil, 'SUB_BACIA_20X20');
  TdrBitmap(Result).DrawFrame := True;
end;

procedure TSubBacia.LerDoArquivo(Ini: TIF; Const Secao: String);
var i, ii: Integer;
begin
  Inherited LerDoArquivo(Ini, Secao);
  with Ini do
    begin
    FArea  := Ini.ReadFloat  (Secao, 'Area', 0);
    //FArqVA := Ini.ReadString (Secao, 'Vazoes Afluentes', '');

    ii := ReadInteger (Secao, 'Coefs. de Contribuicao' , FCCs.Count);
    for i := 1 to ii do
       FCCs.Add(ReadFloat (Secao, 'Coef'+IntToStr(i), 0.0));
    end;
end;

procedure TSubBacia.CopiarPara(HC: THidroObjeto);
begin
  inherited;
  TSubBacia(HC).FCCs.Assign(FCCs);
  TSubBacia(HC).FArea := FArea;
end;

{ TProjeto }

function TProjeto.ReceiveMessage(Const MSG: TadvMessage): Boolean;
begin
  if MSG.ID = UM_PREPARAR_SCRIPTS then
     begin
     if FRotinaGeralUsuario <> '' then
        begin
        PrepararScript(FRotinaGeralUsuario, FScriptGeral);
        FScriptGeral.Compile;
        end;
     end else

  if MSG.ID = UM_LIBERAR_SCRIPTS then
     begin
     FreeAndNil(FScriptGeral);
     end;

  inherited ReceiveMessage(MSG);
end;

function TProjeto.PCPeloNome(const Nome: String): TPC;
begin
  Result := TPC(ObtemObjetoPeloNome(Nome, self));
end;

procedure TProjeto.AtualizaPontoExecucao(const EC: String; SCC: TPascalScript);
begin
  FEC := EC;
  FSC := SCC;
end;

constructor TProjeto.Create(UmaTabelaDeNomes: TStrings);
begin
  inherited Create(UmaTabelaDeNomes, nil);
  FProjeto := Self;

  GetMessageManager.RegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.RegisterMessage(UM_LIBERAR_SCRIPTS, self);

  FPCs  := TListaDePCs.Create;
  FScripts := TStringList.Create;
  FObjetosGlobais := TGlobalObjects.Create;
end;

destructor TProjeto.Destroy;
begin
  GetMessageManager.UnRegisterMessage(UM_PREPARAR_SCRIPTS, self);
  GetMessageManager.UnRegisterMessage(UM_LIBERAR_SCRIPTS, self);
  FSubBacias.Free;
  FPCs.Free;
  FObjetosGlobais.Free;
  FScripts.Free;
  inherited Destroy;
end;

function TProjeto.CriarDialogo: TForm_Dialogo_Base;
begin
  Result := TForm_Dialogo_Projeto.Create(nil);
  Result.TN := TN;
end;

procedure TProjeto.LerDoArquivo(const Nome: String);
var DS: Char;
    Secao: String;
begin
  FNomeArquivo := Nome;
  FIni := TIF.Create(Nome);

  AP(FAreaDeProjeto).Lendo := True;
  AP(FAreaDeProjeto).LerDoArquivo(FIni);

  DS               := DecimalSeparator;
  Secao            := 'Dados ' + FIni.ReadString('Projeto', 'Nome', '');
  DecimalSeparator := FIni.ReadString(Secao, 'Separador Decimal', '.')[1];
  try
    LerDoArquivo(FIni, Secao);
    SetGlobalStatus(RealizarDiagnostico);
    FPCs.CalcularHierarquia;
    SetModificado(False);
    AP(FAreaDeProjeto).AtualizarTela;
    Gerenciador.Atualizar; // ???
  finally
    DecimalSeparator := DS;
    AP(FAreaDeProjeto).Lendo := False;
    FreeAndNil(FIni);
  end;
end;

procedure TProjeto.LerDoArquivo(Ini: TIF; const Secao: String);
var i: Integer;
    s: String;
begin
  Inherited;

  with Ini do
    begin
    ArqFundo := ReadString (Secao, 'Fundo',         '');
    FRotinaGeralUsuario := ReadString(Secao, 'Debug Usuario', '');

    FScripts.Clear;
    for i := 1 to ReadInteger(Secao, 'Num Scripts', 0) do
      begin
      s := 'Script ' + intToStr(i);
      FScripts.Add(ReadString(Secao, s, ''));
      end;
    end; // with
end;

procedure TProjeto.PegarDadosDoDialogo(d: TForm_Dialogo_Base);
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TForm_Dialogo_Projeto) do
    begin
    FRotinaGeralUsuario := Rotinas.edGeralUsuario.Text;
    FScripts.Assign(lbScripts.Items);
    end;
end;

procedure TProjeto.PorDadosNoDialogo(d: TForm_Dialogo_Base);
begin
  inherited PorDadosNoDialogo(d);
  with (d as TForm_Dialogo_Projeto) do
    begin
    Rotinas.edGeralUsuario.Text := FRotinaGeralUsuario;
    lbScripts.Items.Assign(FScripts);
    end;
end;

procedure TProjeto.SalvarEmArquivo(const Nome: String);
var i   : Integer;
    s   : String;
begin
  s := ChangeFileExt(Nome, '.bak');
  DeleteFile(s);
  RenameFile(Nome, s);

  FIni := TIF.Create(Nome);
  try
    FIni.WriteString('Projeto', 'Nome', FNome);
    FIni.WriteString (Secao, 'Separador Decimal', DecimalSeparator);
    AP(FAreaDeProjeto).SalvarEmArquivo(FIni);
    SalvarEmArquivo(FIni);
    Fini.UpdateFile;
    FNomeArquivo := Nome;
  finally
    FreeAndNil(FIni);
  end;
end;

procedure SalvaSubBacia(Projeto: TProjeto; SB: TSubBacia);
begin
  SB.SalvarEmArquivo(Projeto.FIni);
end;

procedure TProjeto.SalvarEmArquivo(Arquivo: TIF);
var i : Integer;
    s : String;
begin
  Inherited SalvarEmArquivo(Arquivo);

  with Arquivo do
    begin
    // Salva as informações do projeto
    WriteString (Secao, 'Separador Decimal', DecimalSeparator);
    WriteString (Secao, 'Fundo', FArqFundo);
    WriteString (Secao, 'Debug Usuario',  FRotinaGeralUsuario);

    WriteInteger(Secao, 'Num Scripts', FScripts.Count);
    for i := 1 to FScripts.Count do
      begin
      s := 'Script ' + intToStr(i);
      WriteString(Secao, s, FScripts[i-1]);
      end;
    SetModificado(false);
    end;
end;

procedure TProjeto.ValidarDados(var TudoOk: Boolean;
                                 DialogoDeErros: TfoMessages; Completo: Boolean = False);
begin
  Inherited ValidarDados(TudoOk, DialogoDeErros, Completo);
  VerificarScriptDoUsuario(FRotinaGeralUsuario, 'Debug', Completo, TudoOk, DialogoDeErros);
end;

// Proc. auxiliar para retorno das subBacias de um projeto
procedure Proc_ObtemSubBacias(Projeto: TProjeto; SB: TSubBacia);
begin
  Projeto.FSubBacias.Add(SB);
end;

procedure TProjeto.PercorreSubBacias(ITSB: TProcPSB);
var i, j: Integer;
begin
  GetMessageManager.SendMessage(UM_RESET_VISIT, [0]);
  for i := 0 to PCs.PCs-1 do
    for j := 0 to PCs[i].SubBacias-1 do
      if not PCs[i].SubBacia[j].Visitado then
         begin
         ITSB(Self, PCs[i].SubBacia[j]);
         PCs[i].SubBacia[j].Visitado := True;
         end;
end;

// Retorna as subBacias de um projeto
function TProjeto.ObtemSubBacias(): TList;
begin
  if FSubBacias = nil then FSubBacias := TList.Create;
  FSubBacias.Clear();
  PercorreSubBacias(Proc_ObtemSubBacias);
  Result := FSubBacias;
end;

procedure TProjeto.ExecutarRotinaGeral;
begin
  if FRotinaGeralUsuario <> '' then
     begin
     FAreaDeProjeto.Caption := 'Executando a Rotina Geral do Usuário. Aguarde ...';
     AtualizaPontoExecucao(FNome + '.ScriptGeral', FScriptGeral);
     FScriptGeral.Execute;
     AtualizaPontoExecucao('', nil);
     end;
end;

procedure TProjeto.SetFundo(Value: String);
var s, s1: String;
begin
  if Value <> '' then
     begin
     s  := ExtractFilePath(NomeArquivo);
     s1 := ExtractFileName(Value);

     if not PossuiCaminho(Value) then
        Value := s + Value;

     if not FileExists(Value) then
        Value := DirPes + s1;

     if FileExists(Value) then
        try
          FFundoBmp := TBitmap.Create;
          FFundoBmp.LoadFromFile(Value);

          if CompareText(s, ExtractFilePath(Value)) = 0 then
             FArqFundo := s1
          else
             FArqFundo := Value;

          SetModificado(True);
        except
          FFundoBmp.Free;
          FFundoBmp := nil;
          FArqFundo := '';
        end
     end
  else
     begin
     FFundoBmp.Free;
     FFundoBmp := nil;
     FArqFundo := '';
     SetModificado(True);
     end;
end;

procedure TProjeto.TerminarSimulacao;
begin
  if FSimulador <> nil then
     begin
     if FSC <> nil then FSC.Stop;
     FSimulador.Terminate;
     Dialogs.ShowMessage('Simulação terminada pelo usuário.'#13 +
                         '  - Último ponto de execução ... ' + FEC);
     FEC := '';
     FSC := nil;
     end;
end;

function TProjeto.GetDirPes: String;
begin
  Result := ObtemDiretorioDoProjeto();
end;

function TProjeto.GetDirSai: String;
begin
  Result := ObtemDiretorioDoProjeto();
end;

function TProjeto.ObtemDiretorioDoProjeto: String;
begin
  Result := ExtractFilePath(NomeArquivo);
  If LastChar(Result) = '\' then Delete(Result, Length(Result), 1);
end;

procedure TProjeto.SetModificado(const Value: Boolean);
begin
  FModificado := Value;
  if Value then PCs.CalcularHierarquia;
end;

procedure TProjeto.VerificarSeSalvo();
begin
  if (FNomeArquivo = '') {and Map.Visible} then
     raise Exception.Create('Por favor. Salve o projeto primeiro.');
end;

{ THidroInterface }

function THidroInterface._AddRef: Integer;
begin
  Result := -1;
end;

function THidroInterface._Release: Integer;
begin
  Result := -1;
end;

function THidroInterface.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := 0;
end;

end.

