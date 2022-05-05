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
     Plugin,
     Shapes,
     MessageManager,
     wsMatrix,
     teEngine,
     Form_Chart,
     SysUtilsEx,
     Lists,
     MessagesForm,

     // PascalScript
     psBASE,
     psCORE,
     Lib_GlobalObjects,

     // Propagar
     pr_Const,
     pr_Tipos,
     pr_Interfaces,
     pr_DialogoBase,
     pr_Dialogo_TD,
     pr_Dialogo_QA,
     pr_Dialogo_Descarga,
     pr_Dialogo_Projeto;

type
  TprPC                    = class;
  TprCenarioDeDemanda      = class;
  TprQualidadeDaAgua       = class;
  TprDescarga              = class;
  TprProjeto               = class;
  TprListaDePCs            = class;

  // Classes básicas -----------------------------------------------------------------

  TComponente = class(T_NRC_InterfacedObject, IMessageReceptor)
  private
    // Salvas
    FNome        : String;
    FDescricao   : String;
    FComentarios : TXML_StringList;

    // Representam as posicoes dos objetos.
    // Sao do tipo reais para poderem armazenarem tanto
    // coordenadas de tela quanto coord. geo referenciadas.
    FPos: TMapPoint;

    FVisitado    : Boolean;
    FModificado  : Boolean;
    FProjeto     : TprProjeto;
    FBloqueado   : Boolean;

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
    function  ObterNomeDaSecao(): String;
    procedure AtualizarHint();
    function  CriarNome: String;
    procedure PreparaScript(Arquivo: String; var Script: TPascalScript);

    // Eventos
    procedure EditEvent(Sender: TObject);
  protected
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

    function CriarImagemDoComponente(): TdrBaseShape; Virtual; Abstract;
    function ObterPrefixo: String; Virtual;

    // Comunicação com o usuário (Interface gráfica)
    function  CriarDialogo: TprDialogo_Base; Virtual;
    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Virtual;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Virtual;
  public
    constructor Create(TabelaDeNomes: TStrings; Projeto: TprProjeto);
    destructor Destroy(); override;

    // Fornece as acoes que este objeto disponibiliza
    procedure getActions(Actions: TActionList); virtual;

    // Utilizados para navegacao dos nós filhos de um nó
    function firstChild(no: IXMLDomNode): IXMLDomNode;
    function nextChild(no: IXMLDomNode): IXMLDomNode;

    function  ObjetoPeloNome(const Nome: String): TObject;
    function  Editar(): Integer;
    function  ConectarObjeto(Obj: TComponente): Integer; Virtual; Abstract;

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

    property AvisarQueVaiSeDestruir: Boolean read  FAvisarQueVaiSeDestruir
                                             write FAvisarQueVaiSeDestruir;

    property  TabNomes    : TStrings        read FTN;
    property  Nome        : String          read FNome         write SetNome;
    property  Descricao   : String          read FDescricao    write FDescricao;
    property  Comentarios : TXML_StringList read FComentarios;
    property  Imagem      : TdrBaseShape    read FImagemDoComponente;
  end;

  TprListaDeObjetos = Class
  private
    FList: TList;
    FLiberarObjetos: Boolean;
    function  getObjeto(index: Integer): TComponente;
    procedure setObjeto(index: Integer; const Value: TComponente);
    function  getNumObjetos: Integer;
  public
    constructor Create();
    Destructor  Destroy(); override;

    function  IndiceDo(Objeto: TComponente): Integer;
    procedure Deletar(Indice: Integer);
    function  Remover(Objeto: TComponente): Integer;
    function  Adicionar(Objeto: TComponente): Integer;
    procedure RemoverNulos;
    procedure Ordenar(FuncaoDeComparacao: TListSortCompare);

    property LiberarObjetos: Boolean read FLiberarObjetos write FLiberarObjetos;
    property Objeto[index: Integer]: TComponente read getObjeto write setObjeto; default;
    property Objetos: Integer read getNumObjetos;
  end;

  // Classes específicas -------------------------------------------------------------

  TprTrechoDagua = class(TComponente)
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

  TprPC = Class(TComponente)
  private
    // FLC somente contém referências a outros objetos
    FPCs_aMontante  : TprListaDeObjetos;
    //FDemandas       : TprListaDeObjetos;
    FDescargas      : TprListaDeObjetos;
    FTD             : TprTrechoDagua;

    // Componente que representa a qualidade da agua em um determinado ponto
    FQA: TprQualidadeDaAgua;

    FVisivel        : Boolean;
    FHierarquia     : Integer;

    function  GetPCs_aMontante(): Integer;
    //function  GetNumDemandas(): Integer;
    function  GetPC_aJusante(): TprPC;
    function  GetPC_aMontante(Index: Integer): TprPC;
    procedure SetVisivel(Value: Boolean);
    procedure SetPC_aJusante(Value: TprPC);
    function GetDescarga(index: Integer): TprDescarga;
    function GetNumDescargas(): Integer;
  protected
    // Metodos Virtuais
    destructor Destroy(); override;
    function ReceiveMessage(Const MSG: TadvMessage): Boolean; override;
    function CriarImagemDoComponente(): TdrBaseShape; override;
  public
    constructor Create(const Pos: TMapPoint; Projeto: TprProjeto; TabelaDeNomes: TStrings);

    // Métodos que mexem com as listas de Objetos
    function ConectarObjeto(Obj: TComponente): Integer; override;
    function Eh_umPC_aMontante(PC: TComponente): Boolean;
    procedure RemoverTrecho(); // Remove trecho de agua a frente
    procedure DesconectarObjetos(); // Limpa todos os objetos conectados a este PC, exceto outros PCs
    procedure DesconectarPC_aMontante(PC: TprPC); // Remove coneccao atras
    procedure AdicionarPC_aMontante(PC: TprPC); // Insere na Lista de Chegada

    property Hierarquia:       Integer         read FHierarquia write FHierarquia;
    property PCs_aMontante:    Integer         read GetPCs_aMontante;
    //property Demandas:         Integer         read GetNumDemandas;
    property Descargas:        Integer         read GetNumDescargas;
    property PC_aJusante:      TprPC           read GetPC_aJusante write SetPC_aJusante;
    property TrechoDagua:      TprTrechoDagua  read FTD;
    property Visivel:          Boolean         read FVisivel write SetVisivel;

    // coneccoes ...

    property PC_aMontante [index: Integer]: TprPC       read GetPC_aMontante;
    property Descarga     [index: Integer]: TprDescarga read GetDescarga;

    property QualidadeDaAgua : TprQualidadeDaAgua read FQA;
  end;

  TprQualidadeDaAgua = class(TComponente)
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

    // Numero de PCs contidos nesta lista
    property PCs: Integer read GetNumPCs;

    // Retorna ou estabelece um dos PCs contidos nesta lista
    property PC[index: Integer]: TprPC read GetPC write SetPC; default;
  end;

  // Representa um possivel cenario de demanda
  TprCenarioDeDemanda = Class(TComponente, ICenarioDemanda)
  private
    FFactoryName: string;
    FDI: ICenarioDemanda;
    //FDemanda: TprDemanda;

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

    function  ObterValorFloat(const Propriedade: string): real;
    function  ObterValorString(const Propriedade: string): string;

    // Referencia a demanda que possui este cenario
    //property Demanda : TprDemanda read FDemanda write FDemanda;

    // Nome da fabrica de cenários
    property FactoryName : string read FFactoryName;
  end;

  TprDescarga = class(TComponente)
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

  TProcPQA = procedure(Projeto: TprProjeto; QA: TprQualidadeDaAgua;  Lista: TList = nil);
  TProcPCN = procedure(Projeto: TprProjeto; CN: TprCenarioDeDemanda;  Lista: TList = nil);

  TStatusProjeto = (sFazendoNada, sSimulando, sOtimizando);

  TprProjeto = Class(TComponente)
  private
    FArqFundo           : String;
    FFundoBmp           : TBitmap;
    FModificado         : Boolean;
    FNomeArquivo        : String;
    FPCs                : TprListaDePCs;
    FDirSai             : String;
    FDirPes             : String;
    FAreaDeProjeto      : TForm;
    FScriptGeral        : TPascalScript;
    FGlobalObjects      : TGlobalObjects;
    FStatus             : TStatusProjeto;
    FScripts            : TStrings;
    FSaveCaption        : String;
    FFileVersion        : integer;

    procedure PegarDadosDoDialogo(d: TprDialogo_Base); Override;
    procedure PorDadosNoDialogo(d: TprDialogo_Base); Override;
    function CriarDialogo: TprDialogo_Base; Override;
    procedure SetFundo(Value: String);
    function getFilePath(): String;
  protected
    function getProjectType(): string; virtual;
    procedure internalToXML(); override;
    procedure fromXML(no: IXMLDomNode); override;
  public
    constructor Create(TabelaDeNomes: TStrings);
    destructor  Destroy(); override;

    // Conversao de coordenadas
    function PointToMapPoint(p: TPoint): TMapPoint; virtual;
    function MapPointToPoint(p: TMapPoint): TPoint; virtual;

    // Cria um descendente de TComponente.
    // Este método deverá ser obrigatoriamente implementado pelos descendentes e deverá
    // fornecer pelo menos a possibilidade de criação de PCs, Reservatórios, Sub-Bacias,
    // Derivações e Demandas.
    // Os valores que "ID" poderá assumir são:
    //   "PC", "Reservatorio", "Sub-Bacia", "Derivacao", "Demanda" ou diretamante o nome
    //   das classes dos objetos, por exemplo, "Txx_PC", ""Txx_RES".
    // "Pos" é a posição na tela onde o objeto será criado.
    function CriarObjeto(const ID: String; Pos: TMapPoint): TComponente; virtual;

    // Verifica se o projeto ja foi salvo, isto é, (NomeArquivo <> '')
    // Se não foi salvo gera uma exceção.
    procedure VerificarSeSalvo();

    // Verifica pendencias iniciais antes do inicio de um projeto
    procedure VerificarPendencias(); virtual;

    // Lista de Objetos
    //function ObtemDemandas(): TList;
    //function ObtemSubBacias(): TList;
    function ObtemCenarios(): TList;
    function ObtemQAs(): TList;

    // Métodos de arquivo
    procedure SaveToXML(const Filename: String);
    procedure LoadFromXML(const Filename: String);

    // Métodos Iterativos
    //procedure PercorreSubBacias(ITSB: TProcPSB; Lista: TList = nil);
    //procedure PercorreDemandas(ITDM: TProcPDM; Lista: TList = nil);
    procedure PercorreCenarios(ITCN: TProcPCN; Lista: TList = nil);
    procedure PercorreQAs(ITQA: TProcPQA; Lista: TList = nil);

    // Retorna uma lista com as referencias a todos os PCs que estao a montante
    // de um determinado PC, inclusive ele. Os PCs deverão estar ordenados,
    // isto é, respeitando as regras de hierarquia.
    // Se "AteOsReservatorios" for verdadeiro é retornada a sub-rede que vai
    // ate os reservatorios, incluindo-os.
    function ObterSubRede(PC: TprPC; AteOsReservatorios: Boolean): TStrings;

    // Métodos dos objetos da rede
    function CenarioPeloNome(const Nome: String): TprCenarioDeDemanda;
    function TrechoPeloNome(const Nome: String): TprTrechoDagua;
    //function DemandaPeloNome(const Nome: String): TprDemanda;
    function PCPeloNome(const Nome: String): TprPC;
    function PCsEntreDois(const NomePC1, NomePC2: String): TStrings;

    // Retorna a versão do arquivo lido
    property FileVersion : integer read FFileVersion;

    property GlobalObjects           : TGlobalObjects     read FGlobalObjects;
    property DirSai                  : String             read FDirSai    write FDirSai;
    property DirPes                  : String             read FDirPes    write FDirPes;
    property PCs                     : TprListaDePCs      read FPCs       write FPCs;

    property CaminhoArquivo     : String         read getFilePath;
    property NomeArquivo        : String         read FNomeArquivo   write FNomeArquivo;
    property Modificado         : Boolean        read FModificado    write FModificado;
    property ArqFundo           : String         read FArqFundo      write SetFundo;
    property AreaDeProjeto      : TForm          read FAreaDeProjeto write FAreaDeProjeto;
    property Status             : TStatusProjeto read FStatus;

    // Background image
    property FundoBmp : TBitmap read FFundoBmp;

    // Scripts do Projeto
    property Scripts : TStrings read FScripts;
  end;

  TprProjeto_ScrollCanvas = class(TprProjeto)
  protected
    function getProjectType(): string; override;
  public
    function PointToMapPoint(p: TPoint): TMapPoint; override;
    function MapPointToPoint(p: TMapPoint): TPoint; override;
  end;

  TprProjeto_ZoomPanel = class(TprProjeto)
  protected
    function getProjectType(): string; override;
    procedure VerificarPendencias(); override;
  public
    function PointToMapPoint(p: TPoint): TMapPoint; override;
    function MapPointToPoint(p: TMapPoint): TPoint; override;
  end;

  // Gera uma excessão de método não implementado
  procedure NaoImplementado(const Metodo, Classe: String);

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
     wsVec,
     WinUtils,
     FileUtils,
     Rochedo.PanZoom,
     pr_Gerenciador,
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

{ TprListaDeObjetos }

function TprListaDeObjetos.Adicionar(Objeto: TComponente): Integer;
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
     for i := 0 to FList.Count-1 do TComponente(FList[i]).Free;

  FList.Free;
  Inherited Destroy;
end;

function TprListaDeObjetos.getNumObjetos: Integer;
begin
  Result := FList.Count;
end;

function TprListaDeObjetos.getObjeto(index: Integer): TComponente;
begin
  Result := TComponente(FList[index]);
end;

function TprListaDeObjetos.IndiceDo(Objeto: TComponente): Integer;
begin
  Result := FList.IndexOf(Objeto);
end;

procedure TprListaDeObjetos.Ordenar(FuncaoDeComparacao: TListSortCompare);
begin
  FList.Sort(FuncaoDeComparacao);
end;

function TprListaDeObjetos.Remover(Objeto: TComponente): Integer;
begin
  Result := FList.Remove(Objeto);
end;

procedure TprListaDeObjetos.RemoverNulos;
begin
  FList.Pack;
end;

procedure TprListaDeObjetos.setObjeto(index: Integer; const Value: TComponente);
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
(*
  if (PC.SubBacias > 0) or (PC.Demandas > 0) then
     MessageDLG('Primeiro remova todos os objetos conectados a este PC.',
     mtInformation, [mbOK], 0)
  else
*)
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

{ TComponente }

constructor TComponente.Create(TabelaDeNomes: TStrings; Projeto: TprProjeto);
begin
  inherited Create;

  FAvisarQueVaiSeDestruir := True;

  FProjeto      := Projeto;
  FTN           := TabelaDeNomes;
  FNome         := CriarNome();
  FComentarios  := TXML_StringList.Create();

  GetMessageManager.RegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.RegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.RegisterMessage(UM_BLOQUEAR_OBJETOS, self);

  if FTN <> nil then FTN.AddObject(FNome, self);
  AtualizarHint();
end;

destructor TComponente.Destroy();
var i: Integer;
begin
  FComentarios.Free();

  GetMessageManager.UnRegisterMessage(UM_RESET_VISIT, self);
  GetMessageManager.UnRegisterMessage(UM_OBTEM_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_OBJETO_SE_DESTRUINDO, self);
  GetMessageManager.UnRegisterMessage(UM_BLOQUEAR_OBJETOS, self);

  i := FTN.IndexOf(FNome);
  if i > -1 then FTN.Delete(i);

  FImagemDoComponente.Free();
  Inherited Destroy;
end;

procedure TComponente.SetModificado(const Value: Boolean);
begin
  FModificado := Value;
  if FProjeto <> nil then FProjeto.FModificado := Value;
end;

function TComponente.ReceiveMessage(const MSG: TadvMessage): Boolean;
var i: Integer;
    s: String;
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
     end
  else
     // ...
end;

function TComponente.Editar(): Integer;
var i: Integer;
begin
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

procedure TComponente.PorDadosNoDialogo(d: TprDialogo_Base);
begin
  d.edNome.Text       := FNome;
  d.edDescricao.Text  := FDescricao;
  d.mComentarios.Text := FComentarios.Text;
end;

procedure TComponente.PegarDadosDoDialogo(d: TprDialogo_Base);
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
end;

procedure TComponente.DuploClick(Sender: TObject);
begin
  FProjeto.VerificarSeSalvo(); // 3.0
  Editar();
end;

function TComponente.ObterNomeDaSecao: String;
begin
  Result := 'Dados ' + FNome;
end;

procedure TComponente.SetNome(const Value: String);
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

function TComponente.CriarDialogo(): TprDialogo_Base;
begin
  Result := TprDialogo_Base.Create(nil);
  Result.TN := FTN;
end;

function TComponente.CriarNome(): String;
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

function TComponente.ObterPrefixo(): String;
begin
  Result := 'Proj_';
end;

procedure TComponente.CriarComponenteVisual(AreaDeProjeto: TObject; const Pos: TMapPoint);
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

function TComponente.getScreenArea(): TRect;
begin
  if FImagemDoComponente <> nil then
     with FImagemDoComponente do
        Result := Classes.Rect(Left, Top, Left + Width, Top + Height)
  else
     Result := Classes.Rect(0, 0, 0, 0);
end;

procedure TComponente.setPos(const Value: TMapPoint);
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

procedure TComponente.AtualizarHint();
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

function TComponente.VerificaCaminho(var Arquivo: String): Boolean;
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

procedure TComponente.RetiraCaminhoSePuder(var Arquivo: String);
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

procedure TComponente.VerificaRotinaUsuario(Arquivo: String; const Texto: String;
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
           PS.Text.LoadFromFile(Arquivo);

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

procedure TComponente.PreparaScript(Arquivo: String; var Script: TPascalScript);
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
    Text.LoadFromFile(Arquivo);

    // Opções
    GerCODE  := True;
    Optimize := True;

    // Variaveis pre-inicializadas
    Variables.AddVar(
      TVariable.Create('Projeto', pvtObject, Integer(Projeto), Projeto.ClassType, True));
    end;
end;

function TComponente.ObjetoPeloNome(const Nome: String): TObject;
var i: Integer;
begin
  i := FTN.IndexOf(Nome);
  if i <> -1 then
     Result := FTN.Objects[i]
  else
     Result := nil;
end;

procedure TComponente.ToXML(); // static
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

procedure TComponente.internalToXML(); // virtual
var x: TXML_Writer;
begin
  x := Applic.getXMLWriter();

  x.Write('description', FDescricao);
  FComentarios.ToXML('comments', x.Buffer, x.IdentSize);
end;

procedure TComponente.fromXML(no: IXMLDomNode); // virtual
begin
  Applic.ActiveObject := self;

  setNome(no.attributes.item[1].text);
  FDescricao := firstChild(no).text;
  FComentarios.FromXML(nextChild(no));
end;

function TComponente.firstChild(no: IXMLDomNode): IXMLDomNode;
begin
  FNodeIndex := 0;
  if no.hasChildNodes then
     result := no.childNodes.item[FNodeIndex]
  else
     result := nil;
end;

function TComponente.nextChild(no: IXMLDomNode): IXMLDomNode;
begin
  inc(FNodeIndex);
  if (no.hasChildNodes) and (FNodeIndex < no.childNodes.length) then
     result := no.childNodes.item[FNodeIndex]
  else
     result := nil;
end;

function TComponente.GetScreenPos(): TPoint;
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

procedure TComponente.getActions(Actions: TActionList);
begin
  CreateAction(Actions, nil, 'Editar ...', false, EditEvent, self);
end;

procedure TComponente.EditEvent(Sender: TObject);
begin
  Editar();
end;

function TComponente.getHint(): string;
begin
  result := '';
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

destructor TprTrechoDagua.Destroy();
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

function TprTrechoDagua.ObterPrefixo(): String;
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
var i: Integer;
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

{ TprPC }

constructor TprPC.Create(const Pos: TMapPoint;
                         Projeto: TprProjeto;
                         TabelaDeNomes: TStrings);
begin
  Inherited Create(TabelaDeNomes, Projeto);

  FPCs_aMontante := TprListaDeObjetos.Create;
  //FDemandas      := TprListaDeObjetos.Create;
  FDescargas     := TprListaDeObjetos.Create;

  FHierarquia := -1;

  GetMessageManager.RegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.RegisterMessage(UM_TROCAR_REFERENCIA, self);

  CriarComponenteVisual(Projeto.AreaDeProjeto, Pos);
end;

{Teoricamente, as listas deverão estar vazias}
destructor TprPC.Destroy();
begin
  if AvisarQueVaiSeDestruir then
     GetMessageManager.SendMessage(UM_OBJETO_SE_DESTRUINDO, [Self]);

  GetMessageManager.UnRegisterMessage(UM_REPINTAR_OBJETO, self);
  GetMessageManager.UnRegisterMessage(UM_TROCAR_REFERENCIA, self);

  FQA.Free();
  FPCs_aMontante.Free();
  //FDemandas.Free();
  FDescargas.Free();
  FTD.Free();
  
  Inherited Destroy();
end;

function TprPC.ConectarObjeto(Obj: TComponente): Integer;
var PC: TprPC;
    //DM: TprDemanda;
    DC: TprDescarga;
begin
  SetModificado(True);

  (*
  // Objeto é uma Demanda ------------------------------------------------------------
  if Obj is TprDemanda then
     begin
     DM := TprDemanda(Obj);
     DM.Tipo := tdLocalizada;
     FDemandas.Adicionar(DM);
     end else
*)

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
var i: Integer;
begin
(*
  For i := 0 to Demandas - 1 Do
    begin
    Demanda[i].AvisarQueVaiSeDestruir := false;
    Demanda[i].Free;
    end;
*)
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
     {
     i := FDemandas.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then
        FDemandas[i] := nil
     else
     }
        begin
        i := FDescargas.IndiceDo(MSG.ParamAsPointer(0));
        if i > -1 then
           FDescargas[i] := nil
        else
           if FQA = MSG.ParamAsPointer(0) then
              FQA := nil;
        end;
     end
  else

  if MSG.ID = UM_REPINTAR_OBJETO then
     FImagemDoComponente.Paint() else

  if MSG.ID = UM_TROCAR_REFERENCIA then
     begin
     i := FPCs_aMontante.IndiceDo(MSG.ParamAsPointer(0));
     if i > -1 then FPCs_aMontante.Objeto[i] := MSG.ParamAsPointer(1);
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
(*
function TprPC.GetDemanda(index: Integer): TprDemanda;
begin
  Result := TprDemanda(FDemandas[Index]);
end;

function TprPC.GetNumDemandas(): Integer;
begin
  FDemandas.RemoverNulos();
  Result := FDemandas.Objetos;
end;
*)
function TprPC.Eh_umPC_aMontante(PC: TComponente): Boolean;
begin
  Result := (FPCs_aMontante.IndiceDo(PC) > -1);
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

{ TprProjeto }

function TprProjeto.CenarioPeloNome(const Nome: String): TprCenarioDeDemanda;
begin
  Result := TprCenarioDeDemanda(ObjetoPeloNome(Nome));
end;

function TprProjeto.TrechoPeloNome(const Nome: String): TprTrechoDagua;
begin
  Result := TprTrechoDagua(ObjetoPeloNome(Nome));
end;

function TprProjeto.PCPeloNome(const Nome: String): TprPC;
begin
  Result := TprPC(ObjetoPeloNome(Nome));
end;

constructor TprProjeto.Create(TabelaDeNomes: TStrings);
begin
  inherited Create(TabelaDeNomes, nil);
  FProjeto := Self;
  FScripts := TStringList.Create;
  FPCs  := TprListaDePCs.Create;
end;

destructor TprProjeto.Destroy;
begin
  FPCs.Free;
  FScripts.Free;
  inherited Destroy;
end;

function TprProjeto.CriarDialogo: TprDialogo_Base;
begin
  Result := TprDialogo_Projeto.Create(nil);
  Result.TN := FTN;
end;

procedure TprProjeto.PegarDadosDoDialogo(d: TprDialogo_Base);
var i: Integer;
    s, s1, s2: String;
begin
  inherited PegarDadosDoDialogo(d);
  with (d as TprDialogo_Projeto) do
    begin
    FDirSai := edDirSai.Text;
    FDirPes := edDirPes.Text;
    FScripts.Assign(lbScripts.Items);
    end;
end;

procedure TprProjeto.PorDadosNoDialogo(d: TprDialogo_Base);
var i: Integer;
begin
  inherited PorDadosNoDialogo(d);
  with (d as TprDialogo_Projeto) do
    begin
    edDirSai.Text := FDirSai;
    edDirPes.Text := FDirPes;
    lbScripts.Items.Assign(FScripts);
    end;
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

procedure TprProjeto.PercorreQAs(ITQA: TProcPQA; Lista: TList = nil);
var i, j: Integer;
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
end;

procedure TprProjeto.PercorreCenarios(ITCN: TProcPCN; Lista: TList = nil);
var i, j: Integer;
    L: TList;
    //DM: TprDemanda;
begin
(*
  L := ObtemDemandas();
  for i := 0 to L.Count-1 do
    begin
    DM := TprDemanda(L[i]);
    for j := 0 to DM.NumCenarios-1 do
      ITCN(self, DM.Cenario[j], Lista);
    end;
  L.Free;
*)
end;

(*
// Retorna as demandas de um projeto
function TprProjeto.ObtemDemandas(): TList;
begin
  Result := TList.Create;
  PercorreDemandas(Proc_ObtemDemandas, Result);
end;
*)

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

function TprProjeto.ObterSubRede(PC: TprPC; AteOsReservatorios: Boolean): TStrings;
var Temp: TList;

  // Percorre recursivemente os PCs a Montantedp PC passado como parâmetro
  procedure Processar(PC: TprPC);
  var i: Integer;
  begin
    Temp.Add(PC);
(*
    if AteOsReservatorios then
       if not (PC is TprPCPR) then // Para quando encontrar um reservatorio
          for i := 0 to PC.PCs_aMontante-1 do
            Processar(TprPC(PC.PC_aMontante[i]))
    else
*)
       for i := 0 to PC.PCs_aMontante-1 do
         Processar(TprPC(PC.PC_aMontante[i]));
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

procedure TprProjeto.SetFundo(Value: String);
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
          FFundoBmp := TBitmap.Create();
          FFundoBmp.LoadFromFile(Value);

          if CompareText(s, ExtractFilePath(Value)) = 0 then
             FArqFundo := s1
          else
             FArqFundo := Value;

          FModificado := True;
        except
          FFundoBmp.Free;
          FFundoBmp := nil;
          FArqFundo := '';
        end
     end
  else
     begin
     FFundoBmp.Free();
     FFundoBmp := nil;
     FArqFundo := '';
     FModificado := True;
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
(*
    procedure SaveDemanda(DM: TprDemanda);
    var i: Integer;
    begin
      DM.ToXML();
      for i := 0 to DM.NumCenarios-1 do
        DM.Cenario[i].ToXML();
    end;
*)
    procedure SaveDescarga(DC: TprDescarga);
    begin
      DC.ToXML();
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
        //for j := 0 to PC.Demandas-1 do SaveDemanda(PC.Demanda[j]);
        for j := 0 to PC.Descargas-1 do SaveDescarga(PC.Descarga[j]);
        if PC.QualidadeDaAgua <> nil then PC.QualidadeDaAgua.ToXML();
        end;  // PCs

      x.endTag('objects');
    end; // proc SaveObjects

    procedure writeRelationship(HC1, HC2: TComponente);
    begin
      x.beginIdent();
      x.Write('rel', ['obj1', 'obj2'], [HC1.Nome, HC2.Nome], '');
      x.endIdent();
    end;
(*
    procedure RelDemanda(HC: TComponente; DM: TprDemanda);
    var i: Integer;
    begin
      writeRelationship(HC, DM);
      for i := 0 to DM.NumCenarios-1 do
        writeRelationship(DM, DM.Cenario[i]);
    end;
*)
    procedure RelDescarga(HC: TComponente; DC: TprDescarga);
    begin
      writeRelationship(HC, DC);
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
        //for j := 0 to PC.Demandas-1 do RelDemanda(PC, PC.Demanda[j]);
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
      HC: TComponente;
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

    if sClass = TprPC.ClassName then
       begin
       HC := TprPC.Create(Pos, self, FTN);
       FPCs.Adicionar(TprPC(HC));
       end
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
  var HC1, HC2: TComponente;
      i: integer;
  begin
    i := Objects.IndexOf(no.attributes.item[0].text);
    HC1 := TComponente(Objects.Objects[i]);

    i := Objects.IndexOf(no.attributes.item[1].text);
    HC2 := TComponente(Objects.Objects[i]);

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
  x.Write('outputDir'  , FDirSai);
  x.Write('searchPath' , FDirPes);

  x.beginTag('scripts');
    x.beginIdent();
    for i := 0 to FScripts.Count-1 do x.Write('user_Script', FScripts[i]);
    x.endIdent();
  x.endTag('scripts');
end;

procedure TprProjeto.fromXML(no: IXMLDomNode); // override
var n: IXMLDomNode;
    i: integer;
    s1, s2: string;
begin
  inherited fromXML(no);

  AP(FAreaDeProjeto).fromXML(no);

  setFundo(nextChild(no).text);
  FDirSai  := nextChild(no).text;
  FDirPes  := nextChild(no).text;

  FScripts.Clear();
  for i := 5 to n.childNodes.length-1 do
    FScripts.Add(n.childNodes.item[i].text);
end;

function TprProjeto.CriarObjeto(const ID: String; Pos: TMapPoint): TComponente;
var p: TPoint;
begin
  VerificarSeSalvo();
  VerificarPendencias();

  if ID = 'PC' then
     begin
     Result := TprPC.Create(Pos, Self, FTN);
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
     raise Exception.Create('Por favor. Salve o projeto primeiro.');
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

  x.Write('CargaDBOC',        FCargaDBOC       );
  x.Write('CargaDBON',        FCargaDBON       );
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

{ TprProjeto_ZoomPanel }

function TprProjeto_ZoomPanel.getProjectType: string;
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

procedure TprProjeto_ZoomPanel.VerificarPendencias();
var c: TPanZoomPanel;
begin
  c := TPanZoomPanel( AP(FAreaDeProjeto).ControleDaAreaDeDesenho() );
  if c.Bitmap = nil then
     raise Exception.Create('Antes de iniciar selecione uma imagem de fundo'#13 +
                            'para que o projeto possa calcular a escala.');
end;

end.

