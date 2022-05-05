unit pro_Classes;

interface
uses Types, Classes, Controls, ActnList, ComCtrls, wsVec, wsMatrix, SysUtilsEx, Contnrs,
     MessagesForm, Form_Chart, IniFiles, Graphics,
     MSXML4,
     XML_Utils,
     BaseSpreadSheetBook,
     SpreadSheetBook,
     Lists,
     pro_Const,
     pro_Interfaces,
     pro_BaseClasses;

const
  cPostos = 5; // As primeiras 4 colunas são informações sobre a data

type
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

  TMethod = procedure of object;

  TFulfil_Type = (ftRecursiveMean);

type
  TDSInfo     = class;
  TStation      = class;
  TSerie      = class;
  TSerieClass = class of TSerie;

  TAddSerieMethod = procedure (Serie: TSerie) of object;

  // Lista de series
  TSeries = class
  private
    FList: TList;
    function getSerie(i: integer): TSerie;
    function getNumSeries: integer;
  public
    constructor Create;
    destructor Destroy; override;

    function Adicionar(Serie: TSerie): Integer;
    procedure Remover(Serie: TSerie);

    property NumSeries : Integer read getNumSeries;
    property Serie[i: integer] : TSerie read getSerie; default;
  end;

  // Classe abstrata que define uma Série de dados e suas ações.
  TSerie = class(TNoObjeto, IVisualizableInSheet, IEditable)
  private
    FNome: String;
    FPosto: TStation;
    FAcoes: TActionList;
    FRes: TwsDFVec;
    FAdimensionalizada: boolean;
    FSeries: TSeries;
    FComentarios: TXML_StringList;
    function getStrongName: string;
  protected
    Fact_ind_Vis: TAction;   // Representa o container das acoes de visualizacao individuais
    Fact_ind_Dist: TAction;  // Representa o container das acoes de ajuste de distribuicoes individuais
    Fact_ind_Graf: TAction;  // Representa o container das acoes graficas individuais
    Fact_col_Graf: TAction;  // Representa o container das acoes graficas coletivas

    // Salva e le os dados especificos de cada classe
    procedure InternalFromXML(node: IXMLDomNode); virtual;
    procedure InternalToXML(x: TXML_Writer); virtual;

    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
    function NoPodeSerEditado(): boolean; override;
    procedure TextoDoNoMudou(var Texto: string); override;
    function ObterDescricao(): String; override;
    procedure Calcular(); virtual;
    procedure Iniciar(); virtual;

    // Retorna o valor mostrado no eixo X de graficos para um elemento da serie
    // Por falta eh retornado o proprio indice passado como parametro
    function getXValue(ValueIndex: integer): double; virtual;

    // Retorna o "Label" de um elemento sa serie
    // Por falta eh retornado a string representante do indice passado como parametro
    function getValueLabel(ValueIndex: integer): string; virtual;

    // Clona as partes especificas de cada serie
    procedure internalClone(Clone: TSerie); virtual;

    // Obtem as acoes do menu de contexto
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;

    // Remove series
    procedure Remover(obj: TNoObjeto); override;
  public
    constructor Create(Posto: TStation; Inicializar: boolean = true); virtual;
    destructor Destroy(); override;

    // Edita as propriedades
    procedure Edit();

    // Cria um clone da serie
    function Clone(): TSerie;

    procedure toXML(x: TXML_Writer);
    procedure fromXML(node: IXMLDomNode);

    // Operacoes
    procedure Admensionalizar();
    procedure ConverterDados(const Fator: real);
    procedure Ln(); // Calcula o Log. Natural de todos os valores nao nulos

    // Saidas
    procedure ShowInSheet();
    procedure Plotar(Grafico: TfoChart; Ordem: Word); virtual;
    procedure PlotarDMA(Grafico: TfoChart; Ordem: Word); virtual;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); virtual;
    procedure MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); virtual;

    // Converte o vetor com dados para um Dataset de uma coluna
    function ConverterParaDataset(): TwsDataset;

    // Adiciona uma serie nesta serie
    procedure AdicionarSerie(Serie: TSerie);

    // Nome "humano" dado a série. Deverá ser iniciada no método "Iniciar".
    property Nome : String read FNome write FNome;

    // Retorna o nome completo da serie no formato "NomeDoPosto.NomeSerie"
    property NomeCompleto : string read getStrongName;

    // Posto utilizado para o cálculo da série.
    property Posto : TStation read FPosto;

    // Dados da Serie
    property Dados: TwsDFVec read FRes;

    // Indica se a serie esta adimensionalizada
    property Adimensionalizada : boolean read FAdimensionalizada;

    // Lista de series filhas (0..Series-1)
    property Series : TSeries read FSeries;
  end;

  // Representa os dados admensionalizados do posto
  TSerie_PostoAdmensionalizado = class(TSerie)
  protected
    procedure Calcular(); override;
    procedure Iniciar(); override;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    procedure MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    function getValueLabel(ValueIndex: integer): string; override;
  end;

  // Representa os dados do posto
  TSerie_ValoresDoPosto = class(TSerie)
  protected
    procedure Calcular(); override;
    procedure Iniciar(); override;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    procedure MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    function getValueLabel(ValueIndex: integer): string; override;
  end;

  // Define uma serie onde os dados são agrupados mes a mes.
  TSerie_Mensal = class(TSerie)
  protected
    // Utilizado para guandar o mes e o ano de cada valor da serie
    // Este dado eh codificado da seguinte maneira: Ano * 100 + Mes
    FLabels: TIntegerList;

    destructor Destroy(); override;
    procedure Calcular(); override;
    function  ObterResumo(): String; override;
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    function getValueLabel(ValueIndex: integer): string; override;
    procedure InternalFromXML(node: IXMLDomNode); override;
    procedure InternalToXML(x: TXML_Writer); override;
    procedure internalClone(Clone: TSerie); override;

    // Método responsável por implemenar o algorítimo de agregação do mês.
    // Deverá ser implementado pelos descendentes.
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; virtual;
  public
    constructor Create(Posto: TStation; Inicializar: boolean = true); override;

    // Retorna o Mes e o Ano de um item da serie
    // Este item eh acessado por um indice variante de 1 .. N
    procedure DateOfValue(aIndex: integer; out aMonth, aYear: integer);

    // Retorna as datas iniciais e finais da serie
    procedure BeginDate(out aMonth, aYear: integer);
    procedure EndDate(out aMonth, aYear: integer);

    // Retorna o primeiro ano encontrado para um determinado Mes
    function FirstYear(aMonth: integer): integer;

    // Obtem um vetor com os valores de um determinado mes
    function getMonthVector(aMonth: integer): TwsDFVec;

    // Obtem um vetor com os valores de um determinado ano
    function getYearVector(aYear: integer): TwsDFVec;

    // Mostra os dados em uma planilha onde cada coluna eh um mes do ano
    procedure MostrarDadosEmPlanilha_Mes_a_Mes(p: TSpreadSheetBook); virtual;
  end;

  // Serie obtida pela media de outras series mensais
  TSerie_Mensal_Medias = class(TSerie_Mensal)                             {Instanciável}
  private
    FDesc: string;
  protected
    procedure Iniciar(); override;
    function ObterDescricao(): String; override;
  public
    constructor Create(Series: Array of TSerie_Mensal);
  end;

  // Define uma serie onde os dados são totalizados mes a mes.
  TSerie_Mensal_Total = class(TSerie_Mensal)                             {Instanciável}
  protected
    procedure Iniciar(); override;
    function ObterDescricao(): String; override;
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // Define uma serie onde os dados são agrupados pela média mes a mes.
  TSerie_Mensal_Media = class(TSerie_Mensal)                             {Instanciável}
  protected
    procedure Iniciar(); override;
    function ObterDescricao(): String; override;
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // Cria uma serie de 12 valores (de janeiro a dezembro) onde cada
  // valor é representado pela média de todos os janeiros, todos
  // fevereiros e assim por diante até dezembro.
  TSerie_Mensal_MediaMensais = class(TSerie)                             {Instanciável}
  private
    FSM: TSerie_Mensal;
  protected
    procedure Calcular(); override;
    procedure Iniciar(); override;
    function ObterDescricao(): String; override;
    function getValueLabel(ValueIndex: integer): string; override;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;
  public
    constructor Create(Serie: TSerie_Mensal);
    procedure PlotarHistograma(Grafico: TfoChart);
  end;

  // Define uma série onde cada valor é a média dos 12 meses de uma ano
  TSerie_Mensal_MediaAnuais = class(TSerie)                             {Instanciável}
  private
    FSM: TSerie_Mensal;
    FAI: integer; // Ano Inicial
  protected
    procedure Calcular(); override;
    procedure Iniciar(); override;
    function ObterDescricao(): String; override;
    function getXValue(ValueIndex: integer): double; override;
    function getValueLabel(ValueIndex: integer): string; override;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    procedure InternalFromXML(node: IXMLDomNode); override;
    procedure InternalToXML(x: TXML_Writer); override;
  public
    constructor Create(Serie: TSerie_Mensal);
  end;

  // Representa uma serie mansal que sofreu preenchimento de falhas
  TSerie_Mensal_Preenchida = class(TSerie_Mensal)
  protected
    // Armazena quais valores foram calculados pelo método de preenchimento
    FCalculados: TBooleanList;
    destructor Destroy(); override;
    procedure InternalFromXML(node: IXMLDomNode); override;
    procedure InternalToXML(x: TXML_Writer); override;
    procedure internalClone(Clone: TSerie); override;
    procedure MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;

    // Estes dois metodos sao necessarios pois esta serie podera ser lida de um
    // arquivo XML que chamara o "create" generico de TSerie.
    procedure Iniciar(); override;
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; override;
  public
    constructor Create(Posto: TStation; Inicializar: boolean = true); overload; override;
    constructor Create(Posto: TStation; Tamanho: integer); overload;

    // i varia de 1 a N
    procedure Atribuir(i: integer; Valor: double; Mes, Ano: integer; Calculado: boolean);
    procedure Obter(i: integer; out Valor: double; out Mes, Ano: integer; out Calculado: boolean);

    // Mostra os dados em uma planilha onde cada coluna eh um mes do ano
    procedure MostrarDadosEmPlanilha_Mes_a_Mes(p: TSpreadSheetBook); override;
  end;

  // Define uma Série onde os dados são agrupados ou selecionados ano a ano.
  // Caracteriza-se pela formação de séries anuais onde cada elemento é obtido através de
  // estatísticas que agregam os N dias de um ano em um único valor ou selecionam um único
  // representante para o ano baseados em uma determinada regra.
  TSerie_Anual = class(TSerie)
  private
    FMesInicial: integer;
    function GetAnoInicial(): Word;
    function GetAnoFinal(): Word;
  protected
    procedure Calcular(); override;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    function getXValue(ValueIndex: integer): double; override;
    function getValueLabel(ValueIndex: integer): string; override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;
    function ObterResumo(): String; override;

    // Método responsável pela seleção do elemento representante do ano ou
    // pela agregação dos dados do ano.
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real; virtual;
  public
    constructor Create(Posto: TStation; MesInicial: integer);
    destructor Destroy(); override;

    property AnoInicial: Word read GetAnoInicial;
    property AnoFinal: Word   read GetAnoFinal;
  end;

  TSerie_Anual_Preenchida = class(TSerie_Anual)
  private
    FCalculados: TBooleanList;
    destructor Destroy(); override;
  protected
    procedure InternalFromXML(node: IXMLDomNode); override;
    procedure InternalToXML(x: TXML_Writer); override;
    procedure MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
  public
    constructor Create(SeriePai: TSerie_Anual); overload;
    constructor Create(Posto: TStation; MesInicial: integer); overload;

    procedure Atribuir(i: integer; Valor: double; Calculado: boolean);
  end;

  // Caracteriza-se pela formação de séries anuais onde cada elemento é obtido
  // através da eleição de um único valor para cada ano baseado em uma determinada regra.
  // Este tipo de série não pode sofrer preenchimento de falhas.
  TSerie_Anual_Diaria = class(TSerie_Anual)
  protected
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  end;

  // Seleciona o maior valor em um ano
  TSerie_Anual_Diaria_Maximos = class(TSerie_Anual_Diaria)               {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  // Seleciona o menor valor não nulo encontrado em um ano.
  TSerie_Anual_Diaria_Minimos = class(TSerie_Anual_Diaria)           {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  // Para cada ano seleciona-se uma serie de valores agrupados pela
  // média de N dias consecutivos. Em seguida seleciona-se o menor destes
  // valores. Este valor sera o representante anual.
  TSerie_Anual_Minimos = class(TSerie_Anual)                         {Instanciável}
  private
    FTamMedia: integer;
  protected
    procedure Iniciar; override;
    function ObterDescricao(): string; override;
    function ObterTextoDoNo(): string; override;
    procedure InternalFromXML(node: IXMLDomNode); override;
    procedure InternalToXML(x: TXML_Writer); override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: integer): Real; override;
  public
    constructor Create(Posto: TStation; MesInicial, TamMedia: integer); 
  end;

  // Cada elemento é o somatório dos valores encontrados em um ano.
  TSerie_Anual_Agregada_Totais = class(TSerie_Anual)                 {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // Cada elemento é a média dos valores encontrados em um ano.
  TSerie_Anual_Agregada_Medias = class(TSerie_Anual)                 {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: integer): Real; override;
  end;

  // Caracteriza-se pela formação de séries anuais onde cada elemento é obtido através da
  // agregação dos dados de um mês, mês a mês para cada ano e após é feito a agregação/seleção
  // dos valores resultantes para cada ano para/de um único valor que representará um ano.
  TSerie_Anual_Mensal = class(TSerie_Anual)
  protected
    procedure Calcular; override;

    // Método responsável por implemenar o algorítimo de agregação do mês.
    // Deverá ser implementado pelos descendentes.
    function AgregarMes(LinhaInicial, LinhaFinal: integer): Real; virtual; 

    // É o método responsável por escolher um único representante ou agregar os elementos
    // em um único valor que represente o ano.
    function SelecionarValor(Valores: TwsDFVec): Real; virtual; 
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
    function ObterDescricao(): String; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

  // É a série que calcula a média dos totais mensais.
  TSerie_Anual_Mensal_AG_Total_Medias = class(TSerie_Anual_Mensal_AG_Total)           {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

  // É a série que obtém o maior dos totais mensais.
  TSerie_Anual_Mensal_AG_Total_Maximos = class(TSerie_Anual_Mensal_AG_Total)          {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

  // É a série que obtém o menor dos totais mensais.
  TSerie_Anual_Mensal_AG_Total_Minimos = class(TSerie_Anual_Mensal_AG_Total)          {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(Valores: TwsDFVec): Real; override;
  end;

//  SÉRIES PARCIAIS **********************************************************************

  TSerie_Parcial = class(TSerie)
  private
    FBase: Real;
  protected
    // Método responsável pela seleção ou não do elemento.
    function SelecionarValor(const Valor: Real): Boolean; virtual; 
  public
    constructor Create(Posto: TStation; const ValorBase: Real);
    destructor Destroy(); override;

    function  ObterResumo(): String; override;
    procedure Plotar(Grafico: TfoChart; Ordem: Word); override;
    procedure MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;
    procedure MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word); override;

    property ValorBase: Real read FBase;
  end;

  // Série parcial que NÃO pode sofrer preenchimento de falhas
  // mais pode sofrer Análise de Frequência.
  // O percorrimento deste tipo de série é totalmente sequencial.
  TSerie_Parcial_Diaria = class(TSerie_Parcial)
  protected
    procedure Calcular(); override;
  end;

  // Seleciona todos os valores onde: Valor >= Base
  TSerie_Parcial_Diaria_Maximos = class(TSerie_Parcial_Diaria)               {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  // Seleciona todos os valores onde: (Valor > 0) and (Valor <= Base)
  TSerie_Parcial_Diaria_Minimos = class(TSerie_Parcial_Diaria)               {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  // Série parcial que pode sofrer preenchimento de falhas
  // mais NÃO pode sofrer Análise de Frequência
  // O percorrimento é feito agregando-se os dados mês a mês.
  TSerie_Parcial_AG_Mensal = class(TSerie_Parcial)
  protected
    procedure Calcular; override;
    function AgregarMes(LinhaInicial, LinhaFinal: Integer): Real; virtual; 
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
  end;

  TSerie_Parcial_TotalMensal = class(TSerie_Parcial_AG_Mensal)
  protected
    function AgregarMes(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  // Seleciona todos os valores x onde: (x <-- Total Mensal) e (x >= Base)
  TSerie_Parcial_TotalMensal_Maximas = class(TSerie_Parcial_TotalMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  // Seleciona todos os valores x onde: (x <-- Total Mensal) e (x <= Base)
  TSerie_Parcial_TotalMensal_Minimas = class(TSerie_Parcial_TotalMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  TSerie_Parcial_MediaMensal = class(TSerie_Parcial_AG_Mensal)
  protected
    function AgregarMes(LinhaInicial, LinhaFinal: Integer): Real; override;
  end;

  // Seleciona todos os valores x onde: (x <-- Media Mensal) e (x >= Base)
  TSerie_Parcial_MediaMensal_Maximas = class(TSerie_Parcial_MediaMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  // Seleciona todos os valores x onde: (x <-- Media Mensal) e (x <= Base)
  TSerie_Parcial_MediaMensal_Minimas = class(TSerie_Parcial_MediaMensal)          {Instanciável}
  protected
    procedure Iniciar; override;
    function ObterDescricao(): String; override;
    function SelecionarValor(const Valor: Real): Boolean; override;
  end;

  TStation = class(TNoObjeto, IVisualizableInSheet, IEditable)
  private
    FInfo: TDSInfo;
    FSeries: TSeries;
    FNome: String;
    FIndiceCol: Integer; // Índice da coluna do DataSet
    FIndice: Integer; // posição atual dos dados
    FDado: Real;
    FNumeroDeMeses: integer;
    FDia, FMes, FAno: Word; // dia, mes e ano da posição atual;

    // Salvas em XML
    FExtras : TStrings;
    FDataUnit: string;
    FDataType: string;
    FComment: TStrings;

    procedure setNome(const Value: String);
    function getNumeroDeMeses(): integer;
    function getCount: integer;
    function getValor(i: integer): double;
    procedure setValor(i: integer; const Value: double);
    function getData(i: integer): TDateTime;
  protected
    function NoPodeSerEditado(): boolean; override;
    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
    procedure TextoDoNoMudou(var Texto: string); override;
    procedure ExecutarAcaoPadrao(); override;
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    procedure ObterAcoesColetivas(Acoes: TActionList); override;
    function  ObterResumo(): String; override;

    // Remove series
    procedure Remover(obj: TNoObjeto); override;
  public
    constructor Create(const Nome: String; Info: TDSInfo);
    destructor Destroy; override;

    procedure Edit();
    procedure Delete();

    // Análises --------------------------------------------------------------

    // Realiza uma análise das falhas colocando os resultados em uma planilha
    procedure AnalyzeFaults(Sheet: TBaseSheet; var InitialRow: integer);

    // Calcula estatisticas colocando os resultados em uma planilha
    procedure CalculateEstatistics(Sheet: TBaseSheet; var InitialRow: integer);

    // Preenchimento de Falhas -----------------------------------------------

    // Este método preenche falhas recursivamente atribuindo a média dos valores
    // extremos as posições médias das falhas.
    // ATENCAO: O preenchimento das falhas ocorre somente entre o primeiro
    // e o ultimo valor valido.
    procedure FulfilFault_RecursiveMean();

    // Preenche as falhas com uma constante
    // As falhas serao preenchidas desde o 1. valor ate o ultimo
    procedure FulfilFault_Const(const value: real);

    // Posicionamento --------------------------------------------------------

    function FindLimitIndexs(out startIndex, endIndex: integer): boolean;
    function LastValidValue(out i: integer): boolean;
    function FindValidValue(var i: integer): boolean;
    function FindInvalidValue(var i: integer): boolean;

    procedure toXML(x: TXML_Writer);
    procedure fromXML(node: IXMLDomNode);

    // Métodos de navegação pelos dados
    function VaiPara(const Data: TDateTime): Integer;
    function VaiParaProximoDia: Integer;
    function VaiParaProximoDiaDoAnoAtual: Integer;
    function VaiParaProximoAno: Integer;
    function VaiParaFinalDoMes: Integer;

    procedure ShowInSheet(); overload;
    procedure ShowInSheet(p: TBaseSheet; col: integer; ShowDate: boolean); overload;
    procedure ShowInSheet_MM(p: TBaseSheet);

    procedure Plot(g: TfoChart; Color: TColor);

    // Adiciona uma serie nesta serie
    procedure AdicionarSerie(Serie: TSerie);

    // Retorna se o i-esimo valor eh nulo
    function Nulo(i: integer): boolean;

    // retorna -1  se a data nao for encontrada
    function IndiceDaData(d: TDateTime): integer;

    property Series       : TSeries       read FSeries;
    property Nome         : String        read FNome write setNome;
    property Info         : TDSInfo       read FInfo;
    property IndiceCol    : Integer       read FIndiceCol; // Índice da variável (col) no DataSet

    // Numero de elementos do posto
    property Count : integer read getCount;

    // Acessa os valores do posto
    property Valor [i: integer] : double read getValor write setValor;
    property Data  [i: integer] : TDateTime read getData;

    property DataType : string   read FDataType write FDataType;
    property DataUnit : string   read FDataUnit write FDataUnit;
    property Comment  : TStrings read FComment  write FComment;

    // Propriedades definidas pelo usuário
    property ExtraData : TStrings read FExtras;

    // Dados da posição atual
    property Dado  : Real  read FDado;      // Valor do dado da posição atual
    property Dia   : Word  read FDia;       // Dia da posição atual
    property Mes   : Word  read FMes;       // Mes da posição atual
    property Ano   : Word  read FAno;       // Ano da posição atual

    // Retorna o numero de meses
    // Considera somente o periodo de dados
    property NumeroDeMeses : integer read getNumeroDeMeses;
  end;

  TDSInfo = class(TNoObjeto, IDataControl, IVisualizableInSheet)
  private
    FDS: TwsDataSet;
    FFileVersion: integer;

    function getNomeArq: String;
    function getDataInicial: TDateTime;
    function getTD: TTipoDados;
    function getTI: TTipoIntervalo;
    function getDataFinal: TDateTime;
    function getNumPostos: Integer;

    // IVisualizableInSheet
    procedure ShowInSheet();

    // IDataControl interface
    function getReference(): TObject;
    function getLowRecIndex(): integer;
    function getHighRecIndex(): integer;
    function getLowDate(): TDateTime;
    function getHighDate(): TDateTime;
    function getDate(const RecordIndex: integer): TDateTime;
    function getStation(const RecordIndex, StationIndex: integer): real;
    function getStationName(StationIndex: integer): string;
    function getStationDesc(StationIndex: integer): string;
    function getStationType(StationIndex: integer): string;
    function getStationUnit(StationIndex: integer): string;
    function getStationProp(StationIndex, PropIndex: integer): string; overload;
    function getStationProp(StationIndex: integer; const PropName: string): string; overload;
    function getStationPropCount(StationIndex: integer): integer;
    function getStationCount(): integer;
    function getDataType(): TTipoDados;
    function getIntervalType(): TTipoIntervalo;
    function getRecIndexByDate(const Date: TDateTime): integer;
    procedure setTitle(const Title: string);
    procedure setStationName(StationIndex: integer; const Name: string);
    procedure setStationValue(Date: TDateTime; StationIndex: integer; const Value: real);
    procedure setStationDesc(StationIndex: integer; const aDesc: string);
    procedure setStationType(StationIndex: integer; const aType: string);
    procedure setStationUnit(StationIndex: integer; const aUnit: string);
    procedure defineStationProp(StationIndex: integer; const aPropName, aPropValue: string);
  protected
    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    function  ObterResumo(): String; override;
  public
    constructor Create(const NomeArq: String); overload;
    constructor Create(const Dataset: TwsDataset); overload;

    destructor Destroy; override;

    // Fecha os dados
    procedure Fechar();

    // Leitura e gravacao em arquivo
    procedure LoadFromFile(const Filename: string);
    procedure SaveToFile(const Filename: string);

    // Obtem a Estacao pelo indice.
    // O indice eh baseado em 0
    function getStationByIndex(Index: Integer): TStation;

    // Obtem a Estacao pelo Nome.
    function getStationByName(const Name: string): TStation;

    procedure RemoveStation(Station: TStation);

    function DataDoPrimeiroValorValido(const Posto: String): String;
    function DataDoUltimoValorValido(const Posto: String): String;

    function IndiceDaData(const Data: TDateTime): Integer; overload;
    function IndiceDaData(const Data: String): Integer; overload;

    function  PostoPeloNome(const Nome: String): TStation;
    procedure GetStationNames(Stations: TStrings);

    // Mostra os dados como HTML
    procedure VisualizarComoHTML();

    // Mostra os dados em uma planilha
    procedure VisualizarComoPlanilha();

    // Troca o Dataset atual pelo novo
    procedure TrocarDataset(NovoDataset: TwsDataset);

    property DS            : TwsDataSet       read FDS;
    property NomeArq       : String           read getNomeArq;
    property TipoIntervalo : TTipoIntervalo   read getTI;
    property TipoDados     : TTipoDados       read getTD;
    property DataInicial   : TDateTime        read getDataInicial;
    property DataFinal     : TDateTime        read getDataFinal;

    // Controle dos Postos
    property NumPostos : integer read getNumPostos;
    property Station[index: integer] : TStation read getStationByIndex;

    // Arquivo
    property FileVersion : integer read FFileVersion;
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
    procedure Imprimir(Lugar: TStrings; Info: TDSInfo; MostrarPostos: Boolean);

    property NumPeriodos: Integer read getNumPeriodos;
    property Periodo[i: integer]: pRecDadosPeriodo read getPeriodo; default;
  end;

  TScript = class(TNoObjeto)
  private
    FFilename: string;
  protected
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
    procedure ExecutarAcaoPadrao(); override;
  public
    constructor Create(const Filename: string);
    procedure Execute();
    procedure Edit();
    procedure Delete();
    property Filename : string read FFilename;
  end;

  // Existe apenas uma instancia que eh possuida pela aplicacao
  TScripts = class(TNoObjeto)
  private
    function getCount: integer;
    function getScript(i: integer): TScript;
  protected
    procedure ObterAcoesIndividuais(Acoes: TActionList); override;
    function ObterTextoDoNo(): string; override;
    function ObterIndiceDaImagem(): integer; override;
  public
    constructor Create(Node: TTreeNode);
    procedure Add(const Filename: string);
    property Count : integer read getCount;
    property Script[i: integer]: TScript read getScript; default;
  end;

  // Conversões
  function TipoIntervaloToStr(Tipo: TTipoIntervalo): String;
  function TipoDadosToStr(Tipo: TTipoDados): String;

implementation
uses Math, SysUtils, DateUtils, Forms, Dialogs, GraphicUtils,
     TeEngine,
     Series,
     wsBXML_Output,
     BXML_Viewer,
     StringsEditor,
     StringsDialog,
     TreeViewUtils,
     FileUtils,
     WinUtils,
     wsConstTypes,
     wsgLib,
     foBook,
     psBASE,
     psCORE,
     psEditor,

     // Proceda
     pro_Application,
     pro_Procs,
     pro_Actions,

     // Dialogs
     pro_fo_Station_EditExtraData;

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

{ TDSInfo }

constructor TDSInfo.Create(const NomeArq: String);
var i: Integer;
begin
  inherited Create;
  FDS := TwsDataSet(TwsDataSet.LoadFromFile(NomeArq));

  // As primeiras 4 colunas são informações sobre a data
  for i := cPostos to FDS.Struct.Cols.Count do
    FDS.Struct.Col[i].aObject := TStation.Create(FDS.Struct.Col[i].Name, Self);
end;

constructor TDSInfo.Create(const Dataset: TwsDataset);
var i: Integer;
begin
  inherited Create;
  FDS := Dataset;

  // As primeiras 4 colunas são informações sobre a data
  for i := cPostos to FDS.Struct.Cols.Count do
    FDS.Struct.Col[i].aObject := TStation.Create(FDS.Struct.Col[i].Name, Self);
end;

destructor TDSInfo.Destroy();
var i: Integer;
begin
  // a primeira coluna é a Data
  for i := cPostos to FDS.Struct.Cols.Count do
    FDS.Struct.Col[i].aObject.Free();
  FDS.Free();
  inherited Destroy();
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
var di: TDateTime;
begin
  if self.getTI() = tiDiario then
     begin
     di := getDataInicial();

     if (Data >= di) and (Data <= getDataFinal()) then
        result := trunc(Data - di + 1)
     else
        result := -1;
     end
  else
     if not FDS.FindDate(Data, 1, false, result) then
        result := -1
end;

function TDSInfo.getTD(): TTipoDados;
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

procedure TDSInfo.GetStationNames(Stations: TStrings);
var i: Integer;
begin
  Stations.Clear();
  for i := cPostos to FDS.nCols do
    Stations.Add(FDS.ColName[i]);
end;

function TDSInfo.getDataFinal(): TDateTime;
begin
  Result := FDS.AsDateTime[FDS.NRows, 1];
end;

function TDSInfo.getNumPostos(): Integer;
begin
  Result := FDS.Struct.Cols.Count - cPostos + 1;
end;

function TDSInfo.PostoPeloNome(const Nome: String): TStation;
begin
  try
    Result := TStation(FDS.Struct.ColByName(Nome).aObject);
  except
    Raise Exception.CreateFmt('Posto <%s> desconhecido', [Nome]);
  end;
end;

procedure TDSInfo.ObterAcoesIndividuais(Acoes: TActionList);
var act: TAction;
begin
  inherited ObterAcoesIndividuais(Acoes);

  act := CreateAction(Acoes, nil, 'Visualizar', false, nil, self);
    CreateAction(Acoes, act, 'Como Planilha', false, ActionManager.DSInfo_VisualizarComoPlanilha, self);
    CreateAction(Acoes, act, 'Como HTML', false, ActionManager.DSInfo_VisualizarComoHTML, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  CreateAction(Acoes, nil, 'Gráfico Gantt', false, ActionManager.DSInfo_Gantt, self);
  CreateAction(Acoes, nil, '-', false, nil, self);
  CreateAction(Acoes, nil, 'Correlações entre os Postos', false, ActionManager.DSInfo_Correl, self);
  CreateAction(Acoes, nil, '-', false, nil, self);
  CreateAction(Acoes, nil, 'Fechar', false, ActionManager.DSInfo_Fechar, self);
end;

function TDSInfo.ObterResumo(): String;
begin
  Result := 'Arquivo: ' + NomeArq;
end;

procedure TDSInfo.VisualizarComoHTML();
var SL: TStrings;
    tempFile: string;
    Book: TBook;

    procedure WriteStyle();
    begin
      SL.Add('<STYLE TYPE="text/css">');
      SL.Add('<!--');
      SL.Add('    BODY {');
      SL.Add('       BACKGROUND-COLOR: #017dd7;');
      SL.Add('  }');
      SL.Add('  TR.L1 {');
      SL.Add('     BACKGROUND-COLOR: #eae7e6;');
      SL.Add('  }');
      SL.Add('');
      SL.Add('  TR.L2 {');
      SL.Add('     BACKGROUND-COLOR: #dcd8d6;');
      SL.Add('  }');
      SL.Add('');
      SL.Add('  TD {');
      SL.Add('     FONT-FAMILY: arial,verdana;');
      SL.Add('     FONT-SIZE: 12px;');
      SL.Add('     TEXT-ALIGN: center;');
      SL.Add(' }');
      SL.Add('');
      SL.Add('  TR.header, TD.header {');
      SL.Add('     COLOR: white;');
      SL.Add('     FONT-SIZE: 13px;');
      SL.Add('     FONT-WEIGHT: bold;');
      SL.Add('     BACKGROUND-COLOR: #0484ae;');
      SL.Add('  }');
      SL.Add('-->');
      SL.Add('</style>');
    end;

    procedure DStoHTML();
    var i, j: Integer;
        s: string;
    begin
      WriteStyle();
      SL.Add('<BODY>');
      SL.Add('<TABLE cellPadding="2">');

      // Cabecalho
      SL.Add('<TR class="header">');
      SL.Add('<TD>Data</TD>');
      for i := cPostos to FDS.nCols do
        SL.Add('<TD>' + FDS.ColName[i] + '</TD>');
      SL.Add('</TR>');

      // Dados
      for i := 1 to FDS.nRows do
        begin
        if odd(i) then s := 'L1' else s := 'L2';
        SL.Add('<TR class="' + s + '">');
          SL.Add('<TD>' + DateTimeToStr(FDS.AsDateTime[i, 1]) + '</TD>');
          for j := cPostos to FDS.nCols do
            SL.Add('<TD>' + SysUtilsEx.AllTrim(FDS.AsString[i, j]) + '</TD>');
        SL.Add('</TR>');
        end;

      SL.Add('</TABLE>');
      SL.Add('</BODY>');
    end;

begin
  StartWait();
  try
    SL := TStringList.Create();
    DStoHTML();
    tempFile := Applic.NewTempFile('PROCEDA', 'html');
    SL.SaveToFile(tempFile);
    Book := TBook.Create(self.ObterResumo, fsMDIChild);
    Book.NewPage('WebBrowser', 'Dados', tempFile);
    Applic.ArrangeChildrens();
  finally
    StopWait();
    SL.Free();
  end;
end;

procedure TDSInfo.VisualizarComoPlanilha();
var p: TSpreadSheetBook;
    i, j, k: integer;
begin
  StartWait();
  try
    p := TSpreadSheetBook.Create('Dados de ' + self.NomeArq, 'Dados');
    p.BeginUpdate();

    // Cabecalho
    p.ActiveSheet.BoldCell(1, 1);
    p.ActiveSheet.WriteCenter(1, 1, 'Data');
    k := 2;
    for i := cPostos to FDS.nCols do
      begin
      p.ActiveSheet.BoldCell(1, k);
      p.ActiveSheet.WriteCenter(1, k, FDS.ColName[i]);
      inc(k);
      end;

    // Dados
    for i := 1 to FDS.nRows do
      begin
      p.ActiveSheet.WriteCenter(i + 1, 1, DateTimeToStr(FDS.AsDateTime[i, 1]));
      k := 2;
      for j := cPostos to FDS.nCols do
        begin
        p.ActiveSheet.WriteCenter(i + 1, k, FDS.AsTrimString[i, j]);
        inc(k);
        end;
      end;

    p.EndUpdate();
    p.Show(fsMDIChild);
    Applic.ArrangeChildrens();
  finally
    StopWait();
    end;
end;

type
  TCompareDateFunc = function (const d1, d2: TDateTime): TValueRelationship;

function TDSInfo.getDataType(): TTipoDados;
begin
  result := self.getTD();
end;

function TDSInfo.getDate(const RecordIndex: integer): TDateTime;
begin
  result := FDS.AsDateTime[RecordIndex, 1];
end;

function TDSInfo.getHighDate(): TDateTime;
begin
  result := self.getDataFinal();
end;

function TDSInfo.getHighRecIndex(): integer;
begin
  result := FDS.nRows;
end;

function TDSInfo.getIntervalType: TTipoIntervalo;
begin
  result := self.getTI();
end;

function TDSInfo.getLowDate(): TDateTime;
begin
  result := self.getDataInicial();
end;

function TDSInfo.getLowRecIndex(): integer;
begin
  result := 1;
end;

function TDSInfo.getRecIndexByDate(const Date: TDateTime): integer;
begin
  result := self.IndiceDaData(Date);
end;

// RecordIndex - baseado em 1
// StationIndex - baseado em 0
function TDSInfo.getStation(const RecordIndex, StationIndex: integer): real;
begin
  result := FDS[RecordIndex, StationIndex + cPostos];
end;

function TDSInfo.getStationCount(): integer;
begin
  result := self.NumPostos;
end;

// baseado em 0
function TDSInfo.getStationName(StationIndex: integer): string;
begin
  result := self.getStationByIndex(StationIndex).Nome;
end;

procedure TDSInfo.LoadFromFile(const Filename: string);

  procedure LoadFields(node: IXMLDomNode);
  var i: Integer;
  begin
    for i := 0 to node.childNodes.length-1 do
      self.getStationByIndex(i).fromXML(node.childNodes.item[i]);
  end;

  procedure LoadExtraFile(const Filename: string);
  var doc: IXMLDOMDocument;
  begin
    doc := OpenXMLDocument(Filename);
    if doc.documentElement.nodeName = 'proceda' then
       begin
       FFileVersion := toInt(doc.documentElement.attributes[0].text, 1);
       LoadFields(doc.documentElement.selectSingleNode('stations'));
       end
    else
       Dialogs.MessageDLG('O Arquivo com informações extras não pode ser lido.',
                           mtInformation, [mbOk], 0);
  end;

var s: string;
begin
  // FDS já foi lido, basta ler as informações extras se existirem
  s := Filename + '.Extra';
  if SysUtils.FileExists(s) then
     LoadExtraFile(s);
end;

procedure TDSInfo.SaveToFile(const Filename: string);
var x: TXML_Writer;
    SL: TStrings;

    procedure writeStations();
    var i: Integer;
    begin
      for i := 0 to self.NumPostos-1 do
        self.getStationByIndex(i).toXML(x);
    end;

begin
  FDS.SaveToFile(Filename);

  // Informacoes extras
  SL := TStringList.Create();

  x := TXML_Writer.Create(SL);
  x.WriteHeader('TDSInfo.SaveToFile', []);
  x.BeginTag('proceda', ['version'], ['2']);
    x.BeginIdent();
    x.BeginTag('stations');
      writeStations();
    x.EndTag('stations');
    x.EndIdent();
  x.EndTag('proceda');
  x.Free();

  SL.SaveToFile(Filename + '.Extra');
  SL.Free();

  // Muda o texto do no para o novo nome
  No.Text := ChangeFileExt(ExtractFileName(Filename), '');
end;

function TDSInfo.getStationDesc(StationIndex: integer): string;
begin
  result := getStationByIndex(StationIndex).Comment.Text;
end;

function TDSInfo.getStationProp(StationIndex, PropIndex: integer): string;
begin
  result := getStationByIndex(StationIndex).ExtraData.ValueFromIndex[PropIndex];
end;

function TDSInfo.getStationProp(StationIndex: integer; const PropName: string): string;
begin
  result := getStationByIndex(StationIndex).ExtraData.Values[PropName];
end;

function TDSInfo.getStationPropCount(StationIndex: integer): integer;
begin
  result := getStationByIndex(StationIndex).ExtraData.Count;
end;

function TDSInfo.getStationType(StationIndex: integer): string;
begin
  result := getStationByIndex(StationIndex).DataType;
end;

function TDSInfo.getStationUnit(StationIndex: integer): string;
begin
  result := getStationByIndex(StationIndex).DataUnit;
end;

procedure TDSInfo.RemoveStation(Station: TStation);
var i: Integer;
begin
  // Atualiza os indices sub-sequentes antes de remover a coluna
  for i := (Station.IndiceCol + 1) to FDS.nCols do
    Dec(TStation(FDS.Struct.Col[i].aObject).FIndiceCol);

  // Remove a coluna no Dataset
  FDS.DeleteCol(Station.IndiceCol);

  // Remove o no que representa a estacao
  Station.No.Delete();

  // Remove a estacao em si
  Station.Free();
end;

procedure TDSInfo.setStationName(StationIndex: integer; const Name: string);
begin
  getStationByIndex(StationIndex).Nome := Name;
end;

procedure TDSInfo.setStationValue(Date: TDateTime; StationIndex: integer; const Value: real);
var row: integer;
begin
  try
    if FDS.Tag_1 = ord(tiDiario) then
       begin
       row := Trunc(Date - getDataInicial() + 1);
       FDS.Data[row, StationIndex + cPostos] := Value;
       end
    else
       begin
       if FDS.FindDate(Date, 1, false, row) then
          FDS.Data[row, StationIndex + cPostos] := Value;
       end;
  except
    Applic.Messages.ShowError(Format('Índice de linha inválida: Lin:%d  Col:%d  Valor:%f  Data:%s',
                                     [row, StationIndex, Value, DateToStr(Date)]));
  end;
end;

function TDSInfo.getStationByIndex(Index: Integer): TStation;
begin
  try
    Result := TStation(FDS.Struct.Col[Index + cPostos].aObject);
  except
    Raise Exception.CreateFmt('Índice do Posto desconhecido: %d', [Index]);
  end;
end;

function TDSInfo.getReference(): TObject;
begin
  result := self;
end;

procedure TDSInfo.defineStationProp(StationIndex: integer; const aPropName, aPropValue: string);
begin
  getStationByIndex(StationIndex).ExtraData.Add(aPropName + '=' + aPropValue);
end;

procedure TDSInfo.setStationDesc(StationIndex: integer; const aDesc: string);
begin
  getStationByIndex(StationIndex).FComment.Text := aDesc;
end;

procedure TDSInfo.setStationType(StationIndex: integer; const aType: string);
begin
  getStationByIndex(StationIndex).FDataType := aType;
end;

procedure TDSInfo.setStationUnit(StationIndex: integer; const aUnit: string);
begin
  getStationByIndex(StationIndex).FDataUnit := aUnit;
end;

procedure TDSInfo.setTitle(const Title: string);
begin
  FDS.MLab := Title;
end;

function TDSInfo.ObterIndiceDaImagem(): integer;
begin
  result := iiTable;
end;

function TDSInfo.ObterTextoDoNo(): string;
begin
  if self.NomeArq <> '' then
     result := ChangeFileExt(ExtractFileName(self.NomeArq), '')
  else
     result := 'Sem Nome';
end;

procedure TDSInfo.Fechar();
var Res: integer;
begin
  if DS.Modified then
     begin
     Res := MessageDLG(NomeArq + #13'Dados alterados. Deseja salvá-los ?',
            mtConfirmation, [mbYes, mbNo, mbCancel], 0);
     if Res = mrCancel then Exit;
     if Res = mrYes then DS.SaveToFile(NomeArq);
    end;
  No.Delete();
  Free();
end;

procedure TDSInfo.ShowInSheet();
begin
  VisualizarComoPlanilha();
end;

procedure TDSInfo.TrocarDataset(NovoDataset: TwsDataset);
begin
  FDS.Free();
  FDS := NovoDataset;
end;

function TDSInfo.getStationByName(const Name: string): TStation;
var i: Integer;
begin
  result := nil;
  for i := 0 to NumPostos-1 do
    if CompareText(Station[i].Nome, Name) = 0 then
       begin
       result := Station[i];
       break;
       end;
end;

{ TListaDePeriodos }

constructor TListaDePeriodos.Create();
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TListaDePeriodos.Destroy();
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

procedure TListaDePeriodos.Imprimir(Lugar: TStrings; Info: TDSInfo; MostrarPostos: Boolean);
var i: Integer;
    p: pRecDadosPeriodo;
begin
  for i := 0 to FList.Count-1 do
    begin
    p := getPeriodo(i);
    if MostrarPostos then
       Lugar.Add(
         Format('DI = %s   DF = %s   Postos = %s',
                [DateToStr(p.DI), DateToStr(p.DF), SetToPostos(p.Postos, Info)]))
    else
       Lugar.Add(
         Format('DI = %s   DF = %s', [DateToStr(p.DI), DateToStr(p.DF)]));
    end;
end;

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
  for i := 0 to FList.Count-1 do TObject(FList[i]).Free();
  FList.Free();
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

procedure TSeries.Remover(Serie: TSerie);
begin
  FList.Remove(Serie);
  Serie.No.Delete();
  Serie.Free();
end;

{ TStation }

constructor TStation.Create(const Nome: String; Info: TDSInfo);
begin
  inherited Create;

  FNome          := Nome;
  FInfo          := Info;
  FIndiceCol     := Info.DS.Struct.IndexOf(Nome);
  FIndice        := 1;
  FNumeroDeMeses := -1;
  FDado          := FInfo.DS[FIndice, FIndiceCol];
  FSeries        := TSeries.Create;
  FExtras        := TStringList.Create;
  FComment       := TStringList.Create;

  DecodeDate(FInfo.DS.AsDateTime[FIndice, 1], FAno, FMes, FDia);
end;

destructor TStation.Destroy();
begin
  FComment.Free();
  FExtras.Free();
  FSeries.Free();
  inherited Destroy();
end;

procedure TStation.ExecutarAcaoPadrao();
begin
  Edit();
end;

procedure TStation.AdicionarSerie(Serie: TSerie);
begin
  Serie.Pai := self;
  FSeries.Adicionar(Serie);
end;

procedure TStation.fromXML(node: IXMLDomNode);
begin
  FDataType := node.childNodes[0].text;
  FDataUnit := node.childNodes[1].text;
  StringsFromXML(node.childNodes[2], FComment);
  PropertiesFromXML(node.childNodes[3], FExtras);
  Applic.LoadSeries(node.childNodes[4], self, AdicionarSerie);
end;

procedure TStation.toXML(x: TXML_Writer);
var i: Integer;
begin
  x.BeginIdent();
  x.BeginTag('station', ['name'], [self.FNome]);
    x.BeginIdent();
    x.Write('type', FDataType);
    x.Write('unit', FDataUnit);
    x.Write('description', FComment);
    x.WriteProperties('extra', FExtras);

    // Series
    x.BeginTag('series');
    for i := 0 to FSeries.NumSeries-1 do
      FSeries[i].toXML(x);
    x.EndTag('series');

    x.EndIdent();
  x.EndTag('station');
  x.EndIdent();
end;

procedure TStation.ObterAcoesIndividuais(Acoes: TActionList);
var act, act2: TAction;
begin
  inherited;

  CreateAction(Acoes, nil, 'Remover', false, ActionManager.RemoveStation, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  act := CreateAction(Acoes, nil, 'Análise', false, nil, self);
         CreateAction(Acoes, act, 'Falhas', false, ActionManager.AnalyzeFaults_Event, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  act := CreateAction(Acoes, nil, 'Preenchar Falhas com', false, nil, self);
         CreateAction(Acoes, act, 'Média dos Limites Recursivos', false, ActionManager.FulfilFault_RecursiveMean_Event, self);
         CreateAction(Acoes, act, 'Valor Constante', false, ActionManager.FulfilFault_Const_Event, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  act := CreateAction(Acoes, nil, 'Visualizar', false, nil, self);
         CreateAction(Acoes, act, 'Planilha', false, ActionManager.ShowStation_Event, self);
         CreateAction(Acoes, act, 'Planilha (Mês a Mês)', false, ActionManager.ShowStationMM_Ind_Event, self);
         CreateAction(Acoes, act, 'Gráfico de Linhas', false, ActionManager.PlotStation_Event, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  act := CreateAction(Acoes, nil, 'Calcular Séries', false, nil, self);
         CreateAction(Acoes, act, 'Máximos Diários Anuais', false, ActionManager.SerieVetor_Ind_CriarMaximosDiariosAnuais, self);
         CreateAction(Acoes, act, 'Mínimos Diários Anuais', false, ActionManager.SerieVetor_Ind_CriarMinimosDiariosAnuais, self);
         CreateAction(Acoes, act, 'Totais Anuais'         , false, ActionManager.SerieVetor_Ind_TotaisAnuais, self);
         CreateAction(Acoes, act, 'Médias Anuais'         , false, ActionManager.SerieVetor_Ind_MediasAnuais, self);
         CreateAction(Acoes, act, 'Mínimos Anuais'        , false, ActionManager.SerieVetor_Ind_MinimasAnuais, self);
         CreateAction(Acoes, act, '-', false, nil, self);
         CreateAction(Acoes, act, 'Médias Mensais'        , false, ActionManager.SerieVetor_Ind_MediasMensais, self);
         CreateAction(Acoes, act, 'Totais Mensais'        , false, ActionManager.SerieVetor_Ind_TotaisMensais, self);
         CreateAction(Acoes, act, 'Totais Mensais Anuais' , false, ActionManager.SerieVetor_Ind_TotaisMensaisAnuais, self);

         CreateAction(Acoes, act, '-', false, nil, self);
         act2 := CreateAction(Acoes, act, 'Séries Parciais', false, nil, self);
                 CreateAction(Acoes, act2, 'Máximos Diários'        , false, ActionManager.SerieVetor_Ind_Parcial_Maximos_Diario, self);
                 CreateAction(Acoes, act2, 'Mínimos Diários'        , false, ActionManager.SerieVetor_Ind_Parcial_Minimos_Diario, self);
                 CreateAction(Acoes, act2, 'Máximas Totais Mensais' , false, ActionManager.SerieVetor_Ind_Parcial_Maximas_TotalMensal, self);
                 CreateAction(Acoes, act2, 'Mínimas Totais Mensais' , false, ActionManager.SerieVetor_Ind_Parcial_Minimas_TotalMensal, self);
                 CreateAction(Acoes, act2, 'Máximas Médias Mensais' , false, ActionManager.SerieVetor_Ind_Parcial_Maximas_MediaMensal, self);
                 CreateAction(Acoes, act2, 'Mínimas Médias Mensais' , false, ActionManager.SerieVetor_Ind_Parcial_Minimas_MediaMensal, self);

         CreateAction(Acoes, act, '-', false, nil, self);
         act2 := CreateAction(Acoes, act, 'Outras Séries', false, nil, self);
                 CreateAction(Acoes, act2, 'Valores Admensionalizados', false, ActionManager.SerieVetor_Ind_PostoAdmensionalizado, self);
                 CreateAction(Acoes, act2, 'Gerar uma série com os dados do Posto', false, ActionManager.SerieVetor_Ind_ValoresDoPosto, self);
end;

function TStation.ObterResumo: String;
begin
  Result := 'Período: ' + FInfo.DataDoPrimeiroValorValido(Nome) + ' a ' +
                          FInfo.DataDoUltimoValorValido(Nome)
end;

function TStation.VaiPara(const Data: TDateTime): Integer;
begin
  FIndice := FInfo.IndiceDaData(Data);
  DecodeDate(FInfo.DS.AsDateTime[FIndice, 1], FAno, FMes, FDia);
  Result := FIndice;
end;

// Nunca retorna -1
function TStation.VaiParaFinalDoMes: Integer;
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

function TStation.VaiParaProximoAno: Integer;
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
function TStation.VaiParaProximoDia: Integer;
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

function TStation.VaiParaProximoDiaDoAnoAtual: Integer;
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

procedure TStation.Edit();
begin
  if TfoStation_EditExtraData.Create(Self).ShowModal() = mrOk then
     AtualizarNo();
end;

procedure TStation.setNome(const Value: String);
begin
  FNome := SysUtilsEx.GetValidId(Value);
  FInfo.DS.Struct.Col[FIndiceCol].Name := FNome;
end;

procedure TStation.Delete();
begin
  FInfo.RemoveStation(self);
end;

// Preenche as falhas com uma constante
// As falhas serao preenchidas desde o 1. valor ate o ultimo
procedure TStation.FulfilFault_Const(const value: real);
var i: Integer;
    x: Double;
begin
  for i := 1 to FInfo.DS.nRows do
    if FInfo.DS.IsMissValue(i, FIndiceCol, x) then
       FInfo.DS[i, FIndiceCol] := value;
end;

// Este método preenche falhas recursivamente atribuindo a média dos valores
// extremos as posições médias das falhas.
// ATENCAO: O preenchimento das falhas ocorre somente entre o primeiro
// e o ultimo valor valido.
procedure TStation.FulfilFault_RecursiveMean();

    procedure Fulfil(i, j: integer);
    var FaultCount, m: integer;
        Mean: real;
    begin
      Mean := (FInfo.DS[i-1, FIndiceCol] + FInfo.DS[j+1, FIndiceCol]) / 2;
      FaultCount := j - i - 1;
      if FaultCount < 3 then
         for m := i to j do FInfo.DS[m, FIndiceCol] := Mean
      else
         begin
         m := (i + j) div 2;
         FInfo.DS[m, FIndiceCol] := Mean;
         Fulfil(i, m-1);
         Fulfil(m+1, j);
         end;
    end;

var i, j, k: integer;
begin
  i := 1;
  FindValidValue({var} i);
  LastValidValue({out} k);

  while i < k do
    begin
    // Busca os limites da proxima falha
    if FindInvalidValue({var} i) then
       begin
       j := i + 1;
       FindValidValue({var} j);
       Fulfil(i, j-1);
       i := j;
       end
    else
       Break;

    inc(i);
    end;
end;

function TStation.LastValidValue(out i: integer): boolean;
var x: double;
begin
  i := FInfo.DS.nRows;
  while FInfo.DS.IsMissValue(i, FIndiceCol, x) and (i > 1) do
    dec(i);

  result := not FInfo.DS.IsMissValue(i, FIndiceCol, x);
end;

function TStation.FindInvalidValue(var i: integer): boolean;
var x: double;
begin
  while not FInfo.DS.IsMissValue(i, FIndiceCol, x) and (i < FInfo.DS.nRows) do
    inc(i);

  result := FInfo.DS.IsMissValue(i, FIndiceCol, x);
end;

function TStation.FindValidValue(var i: integer): boolean;
var x: double;
begin
  while FInfo.DS.IsMissValue(i, FIndiceCol, x) and (i < FInfo.DS.nRows) do
    inc(i);

  result := not FInfo.DS.IsMissValue(i, FIndiceCol, x);
end;

function TStation.ObterIndiceDaImagem(): integer;
begin
  result := iiField;
end;

procedure TStation.ObterAcoesColetivas(Acoes: TActionList);
var act: TAction;
begin
  inherited;
  act := CreateAction(Acoes, nil, 'Visualizar', false, nil, self);
    CreateAction(Acoes, act, 'Planilha', false, ActionManager.ShowStation_Col_Event, self);
    CreateAction(Acoes, act, 'Gráfico de Linhas', false, ActionManager.PlotStation_Col_Event, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  CreateAction(Acoes, nil, 'Gerar um novo conjunto', false, ActionManager.Posto_GerarDS, self);
  act := CreateAction(Acoes, nil, 'Unir postos', false, ActionManager.Posto_Unir, self);
  act.Enabled := Applic.Tree.SelectionCount >= 2;

  CreateAction(Acoes, nil, '-', false, nil, self);
  act := CreateAction(Acoes, nil, 'Análise', false, nil, self);
    CreateAction(Acoes, act, 'Correlações', false, ActionManager.Posto_Correlacoes, self);
    CreateAction(Acoes, act, 'Estatísticas Descritivas', false, ActionManager.Posto_EstatDesc, self);
end;

procedure TStation.ShowInSheet();
var p: TSpreadSheetBook;
begin
  p := TSpreadSheetBook.Create();
  p.Caption := ' Posto: ' + FNome;
  ShowInSheet(p.ActiveSheet, 1, true);
  p.Show(fsMDIChild);
  Applic.ArrangeChildrens();
end;

procedure TStation.ShowInSheet(p: TBaseSheet; col: integer; ShowDate: boolean);
var i: integer;
    x: double;
    s: string;
begin
  // Data
  if ShowDate then
     begin
     p.ActiveCol := col;
     p.ActiveRow := 1;
     p.WriteCenter('Data', true, false);
     p.BoldCell(1, col);
     for i := 1 to Info.DS.nRows do
       begin
       s := DateToStr(Info.DS.AsDateTime[i, 1]);
       p.Write(s, true, false);
       end;
     inc(col);
     end;

  // Dados
  p.ActiveCol := col;
  p.ActiveRow := 1;
  p.WriteCenter(self.Nome, true, false);
  p.BoldCell(1, col);
  for i := 1 to Info.DS.nRows do
    begin
    if Info.DS.IsMissValue(i, self.IndiceCol, x) then
       p.WriteCenter(wscMissValueChar, true, false)
    else
       p.WriteCenter(x, true, false);
    end;
end;

procedure TStation.Plot(g: TfoChart; Color: TColor);
var s: TLineSeries;
    i: integer;
    y: double;
begin
  g.Chart.BottomAxis.DateTimeFormat := 'dd/mm/yyyy';
  s := g.Series.AddLineSerie(Nome, Color);
  for i := 1 to Info.DS.nRows do
    if Info.DS.IsMissValue(i, self.IndiceCol, y) then
       s.AddNullXY(Info.DS.AsDateTime[i, 1], 0, '')
    else
       s.AddXY(Info.DS.AsDateTime[i, 1], y);
  s.XValues.DateTime := true;
end;

procedure TStation.AnalyzeFaults(Sheet: TBaseSheet; var InitialRow: integer);
var ds: TwsDataset;

    nFalhas               : integer;
    Entre1e5  , Tot1e5    : integer;
    Entre6e10 , Tot6e10   : integer;
    Entre11e20, Tot11e20  : integer;
    Entre21e30, Tot21e30  : integer;
    MaisQue30 , TotMais30 : integer;

    Procedure VerificaQualIntervalo(Cont: integer);
    var s: String;
    begin
      If (Cont > 0) and (Cont <= 5) Then
         begin
         inc(Entre1e5);
         inc(Tot1e5, Cont);
         end
      Else If (Cont > 5) and (Cont < 11) Then
         begin
         inc(Entre6e10);
         inc(Tot6e10, Cont);
         end
      Else If (Cont > 10) and (Cont < 21) Then
         begin
         inc(Entre11e20);
         inc(Tot11e20, Cont);
         end
      Else If (Cont > 20) and (Cont < 31) Then
         begin
         inc(Entre21e30);
         inc(Tot21e30, Cont);
         end
      Else If (Cont > 30) Then
         begin
         inc(MaisQue30);
         inc(TotMais30, Cont);
         end;
    end;

    function CalculateFaults(): boolean;
    var i, inicio, fim, Cont: integer;
        VI, IsMiss: boolean;
        x: real;
    begin
      result := FindLimitIndexs({out} inicio, {out} fim);
      if result = false then exit;

      VI := False;
      Cont := 0;

      for i := inicio to fim - 1 do
        begin
        x := ds[i, FIndiceCol];
        IsMiss := IsMissValue(x);

        If IsMiss and (not VI) Then
           begin
           VI := True;
           inc(nFalhas);
           inc(Cont);
           end
        Else If IsMiss Then
           begin
           inc(nFalhas);
           inc(Cont);
           end
        Else If VI Then
           begin
           if FInfo.TipoIntervalo = tiDiario then VerificaQualIntervalo(Cont);
           VI := False;
           Cont := 0;
           end;
        end; // for

        x := ds[fim, FIndiceCol];

        If IsMissValue(x) Then
           begin
           inc(nFalhas);
           if FInfo.TipoIntervalo = tiDiario then
              If VI Then
                 VerificaQualIntervalo(Cont + 1)
              Else
                 VerificaQualIntervalo(1);
           end;
    end;

begin
  ds := self.FInfo.DS;

  // Inicializacoes globais do metodo

  nFalhas    := 0;
  Entre1e5   := 0;  Tot1e5    := 0;
  Entre6e10  := 0;  Tot6e10   := 0;
  Entre11e20 := 0;  Tot11e20  := 0;
  Entre21e30 := 0;  Tot21e30  := 0;
  MaisQue30  := 0;  TotMais30 := 0;

  // Calcula as variaveis acima
  CalculateFaults();

  // Coloca os resultados na planilha ...

  if InitialRow > 1 then inc(InitialRow, 3);

  Sheet.Write(InitialRow, 1, 12, 0, true, 'Análise das Falhas');

  inc(InitialRow, 2);
  Sheet.Write(InitialRow, 1, true, 'Num. Tot. Falhas');
  Sheet.WriteCenter(InitialRow, 2, nFalhas);

  inc(InitialRow, 2);
  Sheet.Write(InitialRow, 1, 12, 0, true, 'Análise da Continuidade das Falhas');

  inc(InitialRow, 2);
  Sheet.WriteCenter(InitialRow, 2, true, 'Falhas');
  Sheet.WriteCenter(InitialRow, 3, true, 'Total');

  // 1. coluna
  Sheet.Write(InitialRow+1, 1, true, '1 => x <=  5' );
  Sheet.Write(InitialRow+2, 1, true, '6 => x <= 10' );
  Sheet.Write(InitialRow+3, 1, true, '11 => x <= 20');
  Sheet.Write(InitialRow+4, 1, true, '21 => x <= 30');
  Sheet.Write(InitialRow+5, 1, true, 'Mais que 30'  );

  // 2. coluna
  Sheet.WriteCenter(InitialRow+1, 2, Entre1e5  );
  Sheet.WriteCenter(InitialRow+2, 2, Entre6e10 );
  Sheet.WriteCenter(InitialRow+3, 2, Entre11e20);
  Sheet.WriteCenter(InitialRow+4, 2, Entre21e30);
  Sheet.WriteCenter(InitialRow+5, 2, MaisQue30 );

  // 3. coluna
  Sheet.WriteCenter(InitialRow+1, 3, Tot1e5   );
  Sheet.WriteCenter(InitialRow+2, 3, Tot6e10  );
  Sheet.WriteCenter(InitialRow+3, 3, Tot11e20 );
  Sheet.WriteCenter(InitialRow+4, 3, Tot21e30 );
  Sheet.WriteCenter(InitialRow+5, 3, TotMais30);

  Sheet.ColWidth[1] := 150;

  inc(InitialRow, 5);
end;

procedure TStation.CalculateEstatistics(Sheet: TBaseSheet; var InitialRow: integer);
var Col, Estatisticas: TwsLIVec;
    Res: TwsMatrix;
begin
  Col := TwsLIVec.CreateFrom([FIndiceCol]);
  Estatisticas := TwsLIVec.CreateFrom([5{Máxima}, 4{Mínima}, 0{Média}, 2{Desvio Padrão}]);
  Try
    Res := FInfo.DS.DescStat(Col, Estatisticas);
    If Res <> Nil Then
       begin
       inc(InitialRow, 2);
       Sheet.Write(InitialRow, 1, 12, 0, true, 'Estatísticas do Posto');

       inc(InitialRow, 1);
       Sheet.Write(InitialRow+1, 1, true, 'Máximo');
       Sheet.Write(InitialRow+2, 1, true, 'Mínimo');
       Sheet.Write(InitialRow+3, 1, true, 'Média');
       Sheet.Write(InitialRow+4, 1, true, 'Desvio Padrão');

       Sheet.WriteCenter(InitialRow+1, 2, Res[1,1]);
       Sheet.WriteCenter(InitialRow+2, 2, Res[1,2]);
       Sheet.WriteCenter(InitialRow+3, 2, Res[1,3]);
       Sheet.WriteCenter(InitialRow+4, 2, Res[1,4]);

       inc(InitialRow, 4);
       Res.Free();
       end
  Finally
    Col.Free();
    Estatisticas.Free();
  End;
end;

function TStation.FindLimitIndexs(out startIndex, endIndex: integer): boolean;
begin
  startIndex := 1;
  result := self.FindValidValue(startIndex);
  if result = false then exit;
  self.LastValidValue(endIndex);
end;

function TStation.getNumeroDeMeses(): integer;
var i, j, k: integer;
begin
  if FNumeroDeMeses = -1 then
     begin
     // para todos os anos
     FNumeroDeMeses := 0;
     j := 1;
     i := VaiPara(Info.DataInicial);
     repeat
       k := VaiParaFinalDoMes();

       // para todos os meses
       while i <> -1 do
         begin
         inc(FNumeroDeMeses);
         i := VaiParaProximoDiaDoAnoAtual();
         if i > -1 then k := VaiParaFinalDoMes();
         end;

       i := VaiParaProximoAno();
       until i = -1;
     end;

  result := FNumeroDeMeses;
end;

function TStation.ObterTextoDoNo(): string;
begin
  result := self.Nome;
end;

function TStation.NoPodeSerEditado(): boolean;
begin
  result := true;
end;

procedure TStation.TextoDoNoMudou(var Texto: string);
begin
  self.setNome(Texto);
  Texto := FNome;
end;

procedure TStation.Remover(obj: TNoObjeto);
begin
  FSeries.Remover( TSerie(obj) );
end;

function TStation.getCount(): integer;
begin
  result := FInfo.DS.nRows;
end;

function TStation.getValor(i: integer): double;
begin
  result := FInfo.DS[i, FIndiceCol];
end;

procedure TStation.setValor(i: integer; const Value: double);
begin
  FInfo.DS[i, FIndiceCol] := Value;
end;

function TStation.Nulo(i: integer): boolean;
var x: double;
begin
  result := FInfo.DS.IsMissValue(i, FIndiceCol, x);
end;

function TStation.getData(i: integer): TDateTime;
begin
  result := FInfo.DS.AsDateTime[i, 1];
end;

function TStation.IndiceDaData(d: TDateTime): integer;
begin
  result := FInfo.IndiceDaData(d);
end;

procedure TStation.ShowInSheet_MM(p: TBaseSheet);
var i, j, k: Integer;
    dia, mes, ano: word;
begin
  for i := 1 to 12 do
    begin
    k := 2;
    p.WriteCenter(1, i+1, true, SysUtils.LongMonthNames[i]);
    for j := 1 to getCount() do
      begin
      SysUtils.DecodeDate(getData(j), ano, mes, dia);
      if mes = i then
         begin
         if i = 1 then p.WriteCenter(k, 1, true, Ano);
         if Nulo(j) then
            p.WriteCenter(k, i+1, wsConstTypes.wscMissValueChar)
         else
            p.WriteCenter(k, i+1, getValor(j));
         inc(k);
         end;
      end;
    end;
end;

{ TSerie }

procedure TSerie.Calcular();
begin
  SysUtilsEx.VirtualError(self, 'Calcular()');
end;

function TSerie.ConverterParaDataset(): TwsDataset;
var i: Integer;
begin
  result := TwsDataset.CreateNumeric(FNome, FRes.Len, 1);
  result.ColName[1] := 'Dados';
  for i := 1 to FRes.Len do
    result.Data[i, 1] := FRes.Data[i];
end;

constructor TSerie.Create(Posto: TStation; Inicializar: boolean = true);
begin
  inherited Create;
  FSeries := TSeries.Create();
  FAcoes := TActionList.Create(nil);
  FPosto := Posto;
  FRes := TwsDFVec.Create(0);
  FComentarios := TXML_StringList.Create();
  if Inicializar then
     begin
     Iniciar();
     Calcular();
     end;
end;

destructor TSerie.Destroy();
begin
  FComentarios.Free();
  FAcoes.Free();
  FSeries.Free();
  inherited;
end;

procedure TSerie.TextoDoNoMudou(var Texto: string);
begin
  FNome := Texto;
  if FAdimensionalizada then
     Texto := ObterTextoDoNo();
end;

function TSerie.getStrongName(): string;
begin
  if FPosto <> nil then
     result := FPosto.Nome + '.' + FNome
  else
     result := FNome;
end;

function TSerie.getValueLabel(ValueIndex: integer): string;
begin
  result := SysUtilsEx.toString(ValueIndex);
end;

function TSerie.getXValue(ValueIndex: integer): double;
begin
  result := ValueIndex;
end;

procedure TSerie.Iniciar();
begin
  FNome := self.ClassName;
end;

procedure TSerie.MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
begin
  SysUtilsEx.VirtualError(self, 'MostrarCabecalhoEmPlanilha()');
end;

procedure TSerie.MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
begin
  Planilha.BeginUpdate();
  with Planilha.ActiveSheet do
    begin
    BoldCell(1, Coluna);
    Write(1, Coluna, FNome);

    BoldCell(2, Coluna);
    if FPosto <> nil then
       Write(2, Coluna, FPosto.Nome)
    else
       Write(2, Coluna, 'Série Especial');

    // Escreve os valores
    WriteVecInCol(FRes, Coluna, 3);
    end;
  Planilha.EndUpdate();
end;

function TSerie.NoPodeSerEditado(): boolean;
begin
  result := true;
end;

procedure TSerie.ObterAcoesColetivas(Acoes: TActionList);
var act: TAction;
begin
  inherited ObterAcoesColetivas(Acoes);

  act := CreateAction(Acoes, nil, 'Visualizar', false, nil, self);
    CreateAction(Acoes, act, 'Planilha', false, ActionManager.SerieVetor_Col_MostrarEmPlanilha, self);
    Fact_col_Graf := CreateAction(Acoes, act, 'Gráficos', false, nil, self);
      CreateAction(Acoes, Fact_col_Graf, 'Linhas', false, ActionManager.SerieVetor_Col_Graficar, self);
      CreateAction(Acoes, Fact_col_Graf, 'Curva de Permanencia', false, ActionManager.SerieVetor_Col_CurvaPerm, self);
      act := CreateAction(Acoes, Fact_col_Graf, 'Dupla Massa', false, ActionManager.SerieVetor_Col_DuplaMassa, self);
      act.Enabled := Applic.Tree.SelectionCount >= 2;

  CreateAction(Acoes, nil, '-', false, nil, self);

  CreateAction(Acoes, nil, 'Estatísticas Descritivas ...', false, ActionManager.SerieVetor_Col_EstDesc, self);
  CreateAction(Acoes, nil, 'Análise de Frequências ...', false, ActionManager.SerieVetor_Col_Frequency, self);
  act := CreateAction(Acoes, nil, 'Coeficientes de Correlação Geral', false, ActionManager.SerieVetor_Col_CCC, self);
  act.Enabled := Applic.Tree.SelectionCount >= 2;
end;

procedure TSerie.ObterAcoesIndividuais(Acoes: TActionList);
var act: TAction;
begin
  inherited ObterAcoesIndividuais(Acoes);

  Fact_ind_Vis := CreateAction(Acoes, nil, 'Visualizar', false, nil, self);
    Fact_ind_Graf := CreateAction(Acoes, Fact_ind_Vis, 'Gráfico', false, nil, self);
      // LEMBRETE: Metodo 'SerieVetor_Ind_Graficos' eh dependente do "caption"
      CreateAction(Acoes, Fact_ind_Graf, 'Linhas', false, ActionManager.SerieVetor_Ind_Graficos, self);
      CreateAction(Acoes, Fact_ind_Graf, 'Dispersão Univariada', false, ActionManager.SerieVetor_Ind_Graficos, self);
      CreateAction(Acoes, Fact_ind_Graf, 'Índice', false, ActionManager.SerieVetor_Ind_Graficos, self);
      CreateAction(Acoes, Fact_ind_Graf, 'Quantis', false, ActionManager.SerieVetor_Ind_Graficos, self);
      CreateAction(Acoes, Fact_ind_Graf, 'Simetria', false, ActionManager.SerieVetor_Ind_Graficos, self);
      CreateAction(Acoes, Fact_ind_Graf, 'Diferença da Média Acumulada', false, ActionManager.SerieVetor_Ind_Graficos, self);
    CreateAction(Acoes, Fact_ind_Vis, 'Planilha', false, ActionManager.SerieVetor_Ind_MostrarEmPlanilha, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  {$ifndef VERSAO_LIMITADA}
  Fact_ind_Dist := CreateAction(Acoes, nil, 'Ajuste de Distribuições', false, nil, self);
    act := CreateAction(Acoes, Fact_ind_Dist, 'Ajustar distribuição de toda série por', false, nil, self);
      CreateAction(Acoes, act, 'Normal'                       , false, ActionManager.SerieVetor_Ind_AjustDistrib, self);
      CreateAction(Acoes, act, 'LogNormal (Dois Parâmetros)'  , false, ActionManager.SerieVetor_Ind_AjustDistrib, self);
      CreateAction(Acoes, act, 'LogNormal (Três Parâmetros)'  , false, ActionManager.SerieVetor_Ind_AjustDistrib, self);
      CreateAction(Acoes, act, 'Log-Pearson Tipo III'         , false, ActionManager.SerieVetor_Ind_AjustDistrib, self);
      CreateAction(Acoes, act, 'Gumbel (Dois Parâmetros)'     , false, ActionManager.SerieVetor_Ind_AjustDistrib, self);
  {$endif}

  act := CreateAction(Acoes, nil, 'Operações', false, nil, self);
    CreateAction(Acoes, act, 'Admensionalizar utilizando a Média', false, ActionManager.SerieVetor_Ind_AdimMedia, self);
    CreateAction(Acoes, act, 'Converter valores ...', false, ActionManager.SerieVetor_Ind_ConvVals, self);
    CreateAction(Acoes, act, 'Logarítmo Neperiano (Ln) ...', false, ActionManager.SerieVetor_Ind_LogNep, self);

  CreateAction(Acoes, nil, '-', false, nil, self);
  CreateAction(Acoes, nil, 'Remover', false, ActionManager.SerieVetor_Ind_Fechar, self);
end;

function TSerie.ObterIndiceDaImagem(): integer;
begin
  result := iiVector;
end;

function TSerie.ObterTextoDoNo(): string;
begin
  result := FNome;
  if FAdimensionalizada then
     result := result + ' (Adimensionalizada)';
end;

procedure TSerie.Plotar(Grafico: TfoChart; Ordem: Word);
var s: TLineSeries;
    i, Ano, AnoIni: Integer;
    y: Double;
    ii, ff: Integer;
begin
  s := Grafico.Series.AddLineSerie(getStrongName(), SelectColor(Ordem));

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
    if FRes.IsMissValue(i, y) then
       s.AddNullXY(getXValue(i), 0, getValueLabel(i))
    else
       s.AddXY(getXValue(i), y, getValueLabel(i));
    end;
end;

procedure TSerie.Admensionalizar();
var nVals: integer;
    m: real;
    v: TwsVec;
begin
  if not FAdimensionalizada then
     begin
     m := FRes.Mean(nVals);
     FRes.ByScalar(m, wsConstTypes.opDiv, false, false);
     FAdimensionalizada := true;
     AtualizarNo();
     end;
end;

procedure TSerie.AdicionarSerie(Serie: TSerie);
begin
  Serie.Pai := self;
  FSeries.Adicionar(Serie);
end;

procedure TSerie.InternalFromXML(node: IXMLDomNode);
begin
  // Nada
end;

procedure TSerie.InternalToXML(x: TXML_Writer);
begin
  // Nada
end;

procedure TSerie.fromXML(node: IXMLDomNode);
begin
  FNome := node.childNodes[0].text;
  FAdimensionalizada := ToBoolean(node.childNodes[1].text);
  FRes.fromXML(node.childNodes[2]);
  Applic.LoadSeries(node.childNodes[3], FPosto, AdicionarSerie);
  internalFromXML(node.childNodes[4]);

  // Incluido na versao de arquivo 2
  if node.childNodes.length > 5 then
     FComentarios.FromXML(node.childNodes[5]);
end;

procedure TSerie.toXML(x: TXML_Writer);
var i: Integer;
begin
  x.beginIdent();
  x.beginTag('serie', ['ClassName'], [self.ClassName]);
    x.beginIdent();
    x.Write('name', FNome); // Node 0
    x.Write('ADM', FAdimensionalizada); // Node 1
    FRes.ToXML(x.Buffer, x.IdentSize);  // Node 2 (vector)

    // Node 3
    x.beginTag('series');
      for i := 0 to FSeries.NumSeries-1 do
        FSeries[i].toXML(x);
    x.endTag('series');

    // Node 4
    x.beginTag('internalData');
      InternalToXML(x);
    x.endTag('internalData');

    // Node 5 (versao de arquivo 2)
    FComentarios.ToXML('comment', x.Buffer, x.IdentSize);
    x.endIdent();
  x.endTag('serie');
  x.endIdent();
end;

function TSerie.Clone(): TSerie;
var i: Integer;
begin
  Result := TSerie(ClassType.NewInstance).Create(FPosto, False);
  Result.FNome := self.Nome;
  Result.FRes.Free();
  Result.FRes := TwsDFVec(FRes.Clone());
  internalClone(Result);
end;

procedure TSerie.internalClone(Clone: TSerie);
begin
  // Nada
end;

procedure TSerie.ConverterDados(const Fator: real);
begin
  FRes.ByScalar(Fator, wsConstTypes.opProd, false, false);
end;

procedure TSerie.ShowInSheet();
var p: TSpreadSheetBook;
begin
  p := TSpreadSheetBook.Create();
  p.Caption := ' Série: ' + self.getStrongName();
  MostrarCabecalhoEmPlanilha(p, 1);
  MostrarDadosEmPlanilha(p, 2);
  p.Show(fsMDIChild);
  Applic.ArrangeChildrens();
end;

procedure TSerie.Remover(obj: TNoObjeto);
begin
  FSeries.Remover( TSerie(obj) );
end;

procedure TSerie.Edit();
begin
  TStringsDialog.getStrings(FComentarios);
end;

function TSerie.ObterDescricao(): String;
var i: Integer;
begin
  result := inherited ObterDescricao();
  if FComentarios.Count > 0 then
     begin
     result := result + 'Comentários:'#13#10;
     for i := 0 to FComentarios.Count-1 do
       result := result + '  ' + FComentarios[i] + #13#10;
     result := result + #13#10;
     end;

end;

procedure TSerie.Ln();
var i: Integer;
    x: Double;
begin
  for i := 1 to FRes.Len do
    if not FRes.IsMissValue(i, x) then
       FRes[i] := System.Ln(x);
end;

procedure TSerie.PlotarDMA(Grafico: TfoChart; Ordem: Word);
var s: TLineSeries;
    i: Integer;
    y: Double;
    ii, ff: Integer;
    v: TwsVec;
begin
  v := FRes.ByScalar(FRes.Mean(i), opSub, true, false);
  v.Accum(false);

  s := Grafico.Series.AddLineSerie(getStrongName(), SelectColor(Ordem));

  // evita um inicio com dados nulos
  for i := 1 to v.Len do
    if not v.IsMissValue(i, y) then
       begin
       ii := i;
       break;
       end;

  // evita um fim com dados nulos
  for i := v.Len downto 1 do
    if not v.IsMissValue(i, y) then
       begin
       ff := i;
       break;
       end;

  // Isto é feito para se evitar um bug no TeeChart com valores Null no inicio ou no final
  for i := ii to ff do
    begin
    if v.IsMissValue(i, y) then
       s.AddNullXY(getXValue(i), 0, getValueLabel(i))
    else
       s.AddXY(getXValue(i), y, getValueLabel(i));
    end;

  v.Free();
end;

{ TSerie_Anual }

destructor TSerie_Anual.Destroy();
begin
  FRes.Free();
  inherited;
end;

function TSerie_Anual.ObterResumo(): String;
var i, Ano: Integer;
begin
  Result := '(' + IntToStr(FRes.Len) + ' anos)   Dados:  ';

  Ano := YearOF(FPosto.Info.DataInicial);
  if FRes.Len > 5 then
     for i := 1 to 5 do
        Result := Result + Format('(%d) %s    ', [Ano + i - 1, FRes.AsTrimString[i]]);

  Result := Result + '...';
end;

// Método genérico de cálculo
procedure TSerie_Anual.Calcular();
Var AnoInicial, AnoFinal, k, df, mf, af : Word;
    Ano, Mes, Dia                       : Word;
    IndiceInicial, IndiceFinal          : Integer;
begin
  AnoInicial := YearOf(FPosto.Info.DataInicial);

  if FMesInicial = 1 then
     AnoFinal := YearOf(FPosto.Info.DataFinal)
  else
     AnoFinal := YearOf(FPosto.Info.DataFinal) - 1;

  k := 0;
  FRes.Len := AnoFinal - AnoInicial + 1;
  FRes.Name := getStrongName();
  FRes.Fill(wscMissValue);

  // Calcula as estatísticas para cada ano
  For Ano := AnoInicial To AnoFinal Do
    begin
    Inc(k);

    IndiceInicial := FPosto.Info.IndiceDaData('01/' + toString(FMesInicial) + '/' + toString(Ano));
    if IndiceInicial = -1 then Continue;

    if FMesInicial = 1 then
       begin
       df := 31;
       mf := 12;
       af := ano;
       end
    else
       begin
       mf := FMesInicial - 1;
       af := ano + 1;
       df := DateUtils.DaysInAMonth(af, mf);
       end;

    IndiceFinal := FPosto.Info.IndiceDaData(toString(df) + '/' + toString(mf) + '/' + toString(af));
    if IndiceFinal = -1 then Continue;

    if IndiceInicial = IndiceFinal then
       FRes[k] := FPosto.Info.DS[IndiceInicial, FPosto.IndiceCol]
    else
       FRes[k] := SelecionarValorOuAgregar(IndiceInicial, IndiceFinal);
    end;   {For Ano...}
end;

function TSerie_Anual.GetAnoInicial(): Word;
begin
  Result := YearOf(FPosto.Info.DataInicial);
end;

function TSerie_Anual.GetAnoFinal(): Word;
begin
  Result := YearOf(FPosto.Info.DataFinal);
end;

function TSerie_Anual.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
begin
  SysUtilsEx.VirtualError(self, 'SelecionarValorOuAgregar()');
end;

procedure TSerie_Anual.MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var k, j : Integer;
    DI   : TDateTime;
    DF   : TDateTime;
begin
  k  := 3;
  DI := Posto.Info.DataInicial;
  DF := Posto.Info.DataFinal;

  for j := YearOF(DI) to YearOF(DF) do
    begin
    Planilha.ActiveSheet.WriteCenter(k, Coluna, intToStr(j));
    inc(k);
    end;
end;

function TSerie_Anual.getValueLabel(ValueIndex: integer): string;
begin
  result := toString(getXValue(ValueIndex));
end;                           

function TSerie_Anual.getXValue(ValueIndex: integer): double;
begin
  result := YearOf(FPosto.Info.DataInicial) + ValueIndex - 1;
end;

procedure TSerie_Anual.ObterAcoesColetivas(Acoes: TActionList);
var act: TAction;
begin
  inherited ObterAcoesColetivas(Acoes);
  {$ifndef VERSAO_LIMITADA}
  act := CreateAction(Acoes, nil, 'Preencher Falhas por Regressão Linear Simples', false, ActionManager.SerieVetor_Col_PFA, self);
  act.Enabled := Applic.Tree.SelectionCount >= 2;
  {$endif}
end;

constructor TSerie_Anual.Create(Posto: TStation; MesInicial: integer);
begin
  FMesInicial := MesInicial;
  inherited Create(Posto, true);
  FNome := FNome + ' (' + SysUtils.ShortMonthNames[FMesInicial] + ')';
end;

{ TSerie_Anual_Diaria_Maximos }

function TSerie_Anual_Diaria_Maximos.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
var HasMissValue: boolean;
begin
  Result := wsMatrixMax(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, HasMissValue);
  if HasMissValue then
     Result := wscMissValue;
end;

procedure TSerie_Anual_Diaria_Maximos.Iniciar();
begin
  FNome := 'Max.Diarios.Anuais';
end;

{ TSerie_Anual_Diaria_Minimos }

function TSerie_Anual_Diaria_Minimos.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona o menor valor não nulo encontrado em cada ano';
end;

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

procedure TSerie_Anual_Diaria_Minimos.Iniciar();
begin
  FNome := 'Min.Diarios.Anuais';
end;

function TSerie_Anual_Diaria_Maximos.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona o maior valor em cada ano';
end;

{ TSerie_Anual_Diaria }

procedure TSerie_Anual_Diaria.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
end;

{ TSerie_Anual_Agregada_Totais }

function TSerie_Anual_Agregada_Totais.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
var NumSomados: Integer;
    HasMissValue: boolean;
begin
  Result := wsMatrixSum(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, NumSomados, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

procedure TSerie_Anual_Agregada_Totais.Iniciar();
begin
  FNome := 'Tot.An.';
end;

function TSerie_Anual_Agregada_Totais.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Cada elemento resultante é o somatório dos valores encontrados em cada ano';
end;

{ TSerie_Anual_Agregada_Medias }

function TSerie_Anual_Agregada_Medias.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: Integer): Real;
var HasMissValue: Boolean;
begin
  Result := wsMatrixMean(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

procedure TSerie_Anual_Agregada_Medias.Iniciar();
begin
  FNome := 'Med.An.';
end;

function TSerie_Anual_Agregada_Medias.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Cada elemento resultante é a média dos valores encontrados em cada ano';
end;

{ TSerie_Anual_Mensal }

function TSerie_Anual_Mensal.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
begin
  SysUtilsEx.VirtualError(self, 'AgregarMes()');
end;

procedure TSerie_Anual_Mensal.Calcular();
Var i, j, k    : Integer;
    d1, d2     : TDateTime;
    FAgregados : TwsDFVec;
begin
  FRes.Len := YearOf(FPosto.Info.DataFinal) - YearOf(FPosto.Info.DataInicial) + 1;
  FRes.Name := getStrongName();
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

function TSerie_Anual_Mensal.SelecionarValor(Valores: TwsDFVec): Real;
begin
  SysUtilsEx.VirtualError(self, 'SelecionarValor()');
end;

{ TSerie_Anual_Mensal_AG_Total }

function TSerie_Anual_Mensal_AG_Total.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
var NumSomados: Integer;
    HasMissValue: boolean;
begin
  Result := wsMatrixSum(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, NumSomados, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

{ TSerie_Anual_Mensal_AG_Media }

function TSerie_Anual_Mensal_AG_Media.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
var HasMissValue: boolean;
begin
  Result := wsMatrixMean(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

{ TSerie_Anual_Mensal_AG_Media_Medias }

function TSerie_Anual_Mensal_AG_Media_Medias.SelecionarValor(Valores: TwsDFVec): Real;
var outN: Integer;
begin
  Result := Valores.Mean(outN);
end;

procedure TSerie_Anual_Mensal_AG_Media_Medias.Iniciar();
begin
  FNome := 'Med.Men.An.';
end;

function TSerie_Anual_Mensal_AG_Media_Medias.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Cada elemento resultante é a média de um grupo de 12 valores ' +
                     'onde cada um destes valores é a média de um mês';
end;

{ TSerie_Anual_Mensal_AG_Total_Medias }

function TSerie_Anual_Mensal_AG_Total_Medias.SelecionarValor(Valores: TwsDFVec): Real;
var outN: Integer;
begin
  Result := Valores.Mean(outN);
end;

procedure TSerie_Anual_Mensal_AG_Total_Medias.Iniciar();
begin
  FNome := 'Tot.Men.An.';
end;

function TSerie_Anual_Mensal_AG_Total_Medias.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Cada elemento resultante é a média de um grupo de 12 valores ' +
                     'onde cada um destes valores é a totalização de um mês';
end;

{ TSerie_Anual_Mensal_AG_Total_Maximos }

function TSerie_Anual_Mensal_AG_Total_Maximos.SelecionarValor(Valores: TwsDFVec): Real;
begin
  Result := Valores.Max;
end;

procedure TSerie_Anual_Mensal_AG_Total_Maximos.Iniciar();
begin
  FNome := 'Max.Tot.Men.An.';
end;

function TSerie_Anual_Mensal_AG_Total_Maximos.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Cada elemento resultante é o maior valor de um grupo de 12 valores ' +
                     'onde cada um destes valores é a totalização de um mês';
end;

{ TSerie_Anual_Mensal_AG_Total_Minimos }

function TSerie_Anual_Mensal_AG_Total_Minimos.SelecionarValor(Valores: TwsDFVec): Real;
begin
  Result := Valores.Min;
end;

procedure TSerie_Anual_Mensal_AG_Total_Minimos.Iniciar();
begin
  FNome := 'Min.Tot.Men.An.';
end;

function TSerie_Anual_Mensal_AG_Total_Minimos.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Cada elemento resultante é o menor valor de um grupo de 12 valores ' +
                     'onde cada um destes valores é a totalização de um mês';
end;

{ TSerie_Parcial }

constructor TSerie_Parcial.Create(Posto: TStation; const ValorBase: Real);
begin
  FBase := ValorBase;
  inherited Create(Posto);
end;

destructor TSerie_Parcial.Destroy;
begin
  FRes.Free;
  inherited;
end;

function TSerie_Parcial.ObterResumo(): String;
var i, Ano: Integer;
begin
  Result := '(' + IntToStr(FRes.Len) + ' Elementos)    Valor Base: ' + FloatToStr(FBase) +
            '    Dados:  ';

  Ano := YearOF(FPosto.Info.DataInicial);
  if FRes.Len > 5 then
     for i := 1 to 5 do
        Result := Result + Format('(%d) %f    ', [Ano + i - 1, FRes.AsTrimString[i]]);

  Result := Result + '...';
end;

procedure TSerie_Parcial.MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
begin
  inherited;
  
end;

procedure TSerie_Parcial.Plotar(Grafico: TfoChart; Ordem: Word);
begin
  inherited;
  
end;

function TSerie_Parcial.SelecionarValor(const Valor: Real): Boolean;
begin
  SysUtilsEx.VirtualError(self, 'SelecionarValor()');
end;

procedure TSerie_Parcial.MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var k: integer;
begin
  for k := 1 to Dados.Len do
    Planilha.ActiveSheet.WriteCenter(k+2, Coluna, IntToStr(k));
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

  L := TDoubleList.Create();

  // Percorre os dados do posto
  For i := IndiceInicial To IndiceFinal Do
    if not FPosto.Info.DS.IsMissValue(i, FPosto.IndiceCol, {out} x) then
       if SelecionarValor(x) then
          L.Add(x);

  // Passa os valores da lista temporária para o vetor definitivo
  //FRes.Free();
  //FRes := TwsDFVec.Create(L.Count);
  FRes.Len := L.Count;
  FRes.Name := getStrongName();
  for i := 0 to L.Count-1 do FRes[i+1] := L[i];

  L.Free();
end;

{ TSerie_Parcial_Diaria_Maximos }

procedure TSerie_Parcial_Diaria_Maximos.Iniciar();
begin
  FNome := 'Max.Dia.Parc.';
end;

function TSerie_Parcial_Diaria_Maximos.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona todos os valores x onde: (x > 0) and (x <= Base)';
end;

function TSerie_Parcial_Diaria_Maximos.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor >= FBase);
end;

{ TSerie_Parcial_Diaria_Minimos }

procedure TSerie_Parcial_Diaria_Minimos.Iniciar();
begin
  FNome := 'Min.Dia.Parc.';
end;

function TSerie_Parcial_Diaria_Minimos.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona todos os valores x onde: (x > 0) and (x <= Base)';
end;

function TSerie_Parcial_Diaria_Minimos.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor > 0) and (Valor <= FBase);
end;

{ TSerie_Parcial_AG_Mensal }

function TSerie_Parcial_AG_Mensal.AgregarMes(LinhaInicial, LinhaFinal: Integer): Real;
begin
  SysUtilsEx.VirtualError(self, 'AgregarMes()');
end;

procedure TSerie_Parcial_AG_Mensal.Calcular();
Var i, k: Integer;
    L: TDoubleList;
    x: Real;
begin
  L := TDoubleList.Create();

  i := FPosto.VaiPara(StrToDate(FPosto.Info.DataDoPrimeiroValorValido(FPosto.Nome)));
  while i <> -1 do
    begin
    k := FPosto.VaiParaFinalDoMes;
    x := AgregarMes(i, k);
    if SelecionarValor(x) then L.Add(x);
    i := FPosto.VaiParaProximoDia;
    end;

  // Passa os valores da lista temporária para o vetor definitivo
  //FRes.Free;
  //FRes := TwsDFVec.Create(L.Count);
  FRes.Len := L.Count;
  FRes.Name := getStrongName();
  for i := 0 to L.Count-1 do FRes[i+1] := L[i];

  L.Free();
end;

procedure TSerie_Parcial_AG_Mensal.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  {$ifndef VERSAO_LIMITADA}
  CreateAction(Acoes, nil, '-', false, nil, self);
  CreateAction(Acoes, nil, 'Preencher Falhas por Reg.Lin.Simples', false, nil, self);
  {$endif}
end;

{ TSerie_Parcial_TotalMensal }

function TSerie_Parcial_TotalMensal.AgregarMes(LinhaInicial, LinhaFinal: Integer): Real;
var NumSomados: Integer;
    HasMissValue: boolean;
begin
  Result := wsMatrixSum(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, NumSomados, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

{ TSerie_Parcial_TotalMensal_Maximas }

procedure TSerie_Parcial_TotalMensal_Maximas.Iniciar();
begin
  FNome := 'Max.Tot.Men.Parc.';
end;

function TSerie_Parcial_TotalMensal_Maximas.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona todos os valores x onde: (x <-- Total Mensal) e (x >= Base)';
end;

function TSerie_Parcial_TotalMensal_Maximas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor >= FBase);
end;

{ TSerie_Parcial_TotalMensal_Minimas }

procedure TSerie_Parcial_TotalMensal_Minimas.Iniciar();
begin
  FNome := 'Min.Tot.Men.Parc.';
end;

function TSerie_Parcial_TotalMensal_Minimas.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona todos os valores x onde: (x <-- Total Mensal) e (x <= Base)';
end;

function TSerie_Parcial_TotalMensal_Minimas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor <= FBase);
end;

{ TSerie_Parcial_MediaMensal }

function TSerie_Parcial_MediaMensal.AgregarMes(LinhaInicial, LinhaFinal: Integer): Real;
var HasMissValue: boolean;
begin
  Result := wsMatrixMean(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

{ TSerie_Parcial_MediaMensal_Maximas }

procedure TSerie_Parcial_MediaMensal_Maximas.Iniciar();
begin
  FNome := 'Max.Med.Men.Parc.';
end;

function TSerie_Parcial_MediaMensal_Maximas.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona todos os valores x onde: (x <-- Media Mensal) e (x >= Base)';
end;

function TSerie_Parcial_MediaMensal_Maximas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor >= FBase);
end;

{ TSerie_Parcial_MediaMensal_Minimas }

procedure TSerie_Parcial_MediaMensal_Minimas.Iniciar();
begin
  FNome := 'Min.Med.Men.Parc.';
end;

function TSerie_Parcial_MediaMensal_Minimas.ObterDescricao: String;
begin
  result := inherited ObterDescricao();
  result := result + 'Seleciona todos os valores x onde: (x <-- Media Mensal) e (x <= Base)';
end;

function TSerie_Parcial_MediaMensal_Minimas.SelecionarValor(const Valor: Real): Boolean;
begin
  Result := (Valor <= FBase);
end;

{ TSerie_Mensal }

constructor TSerie_Mensal.Create(Posto: TStation; Inicializar: boolean);
begin
  // Cria a lista que ira armazenar os labels
  // Ano/Mes sera codificado da seguinte maneira: Ano * 100 + Mes
  FLabels := TIntegerList.Create();

  inherited Create(Posto, Inicializar);
end;

destructor TSerie_Mensal.Destroy();
begin
  FRes.Free();
  FLabels.Free();
  inherited Destroy();
end;

// Calculado em dois passos.
//   - 1.passo: calcula o numero de meses do posto
//   - 2.passo: obtencao dos valores
function TSerie_Mensal.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
begin
  SysUtilsEx.VirtualError(self, 'AgregarMes()');
end;

procedure TSerie_Mensal.BeginDate(out aMonth, aYear: integer);
begin
  DateOfValue(1, {out} aMonth, aYear);
end;

procedure TSerie_Mensal.EndDate(out aMonth, aYear: integer);
begin
  DateOfValue(FRes.Len, {out} aMonth, aYear);
end;

procedure TSerie_Mensal.Calcular();
Var i, j, k, m : Integer;
    d1, d2     : TDateTime;
begin
  // Dimensiona o vetor com o numero de meses do posto
  FRes.Len := Posto.NumeroDeMeses;
  FRes.Name := getStrongName();

  // Cria a lista que ira armazenar os labels
  // Ano/Mes sera codificado da seguinte maneira: Ano * 100 + Mes
  //FLabels := TIntegerList.Create();

  // para todos os anos
  m := 0;
  j := 1;
  i := FPosto.VaiPara(FPosto.Info.DataInicial);
  repeat
    k := FPosto.VaiParaFinalDoMes();

    // para todos os meses
    while i <> -1 do
      begin
      inc(m);
      FRes[m] := AgregarMes(i, k);
      FLabels.Add(FPosto.Ano * 100 + FPosto.Mes);
      i := FPosto.VaiParaProximoDiaDoAnoAtual();
      if i > -1 then k := FPosto.VaiParaFinalDoMes();
      end;

    i := FPosto.VaiParaProximoAno();
  until i = -1;
end;

procedure TSerie_Mensal.DateOfValue(aIndex: integer; out aMonth, aYear: integer);
var c: integer;
begin
  c := FLabels[aIndex-1];
  aYear  := c div 100;
  aMonth := c mod 100;
end;

function TSerie_Mensal.FirstYear(aMonth: integer): integer;
var i, m, a: Integer;
begin
  result := -1;
  for i := 1 to FRes.Len do
    begin
    DateOfValue(i, m, a);
    if m = aMonth then
       begin
       result := a;
       exit;
       end;
    end;
end;

function TSerie_Mensal.getYearVector(aYear: integer): TwsDFVec;
var i, k: integer;
    Mes, Ano: integer;
begin
  // Primeiro conta os meses
  k := 0;
  for i := 1 to FRes.Len do
    begin
    DateOfValue(i, Mes, Ano);
    if Ano = aYear then
       begin
       inc(k);
       if k = 12 then break; // Posso ter no máximo 12 valores para cada ano
       end;
    end;

  // Cria o vetor
  result := TwsDFVec.Create(k);
  result.Name := self.getStrongName() + '_' + toString(aYear);

  // Pega os valores e estabelece o Ano como o nome do vetor
  k := 0;
  for i := 1 to FRes.Len do
    begin
    DateOfValue(i, Mes, Ano);
    if Ano = aYear then
       begin
       inc(k);
       result[k] := FRes[i];
       if k = 12 then break; // Posso ter no máximo 12 valores para cada ano
       end;
    end;
end;

{ TSerie_Mensal_Total }

function TSerie_Mensal_Total.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
var NumSomados: Integer;
    HasMissValue: boolean;
begin
  Result := wsMatrixSum(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, NumSomados, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

procedure TSerie_Mensal_Total.Iniciar();
begin
  FNome := 'Tot.Men';
end;

function TSerie_Mensal_Total.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Define uma série onde cada elemento é a totalização de um mês.';
end;

function TSerie_Mensal.getValueLabel(ValueIndex: integer): string;
var s: String;
begin
  s := FLabels.AsString[ValueIndex - 1];
  result := System.Copy(s, 5, 2) + '/' + System.Copy(s, 1, 4);
end;

procedure TSerie_Mensal.MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var k, j : Integer;
begin
  k := 3;
  for j := 1 to FRes.Len do
    begin
    Planilha.ActiveSheet.WriteCenter(k, Coluna, getValueLabel(j));
    inc(k);
    end;
end;

{ TSerie_Mensal_Medias }

function TSerie_Mensal_Media.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
var HasMissValue: boolean;
begin
  Result := wsMatrixMean(FPosto.Info.DS, FPosto.IndiceCol, LinhaInicial, LinhaFinal, HasMissValue);
  if HasMissValue then
     result := wscMissValue;
end;

procedure TSerie_Mensal_Media.Iniciar();
begin
  FNome := 'Med.Men';
end;

function TSerie_Mensal_Media.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Define uma série onde cada elemento é a média de um mês.';
end;

procedure TSerie_Mensal.ObterAcoesColetivas(Acoes: TActionList);
var act: TAction;
begin
  inherited ObterAcoesColetivas(Acoes);

  act := CreateAction(Acoes, nil, 'Coeficientes de Correlação Mês a Mês', false, ActionManager.SerieVetor_Col_CCC_MM, self);
  act.Enabled := Applic.Tree.SelectionCount >= 2;

  {$ifndef VERSAO_LIMITADA}
  act := CreateAction(Acoes, nil, 'Preencher Falhas por Regressão Linear Simples', false, ActionManager.SerieVetor_Col_PF_MM, self);
  act.Enabled := Applic.Tree.SelectionCount >= 2;
  {$endif}

  CreateAction(Acoes, nil, '-', false, nil, self);

  CreateAction(Acoes, nil, 'Converter para postos do Proceda', false, ActionManager.SerieVetor_Col_ConverterParaPostos, self);

  CreateAction(Acoes, nil, '-', false, nil, self);

  act := CreateAction(Acoes, nil, 'Operações', false, nil, self);
    CreateAction(Acoes, act, 'Média', false, ActionManager.SerieVetor_Col_MediaDasSeriesMensais, self);
end;

function TSerie_Mensal.getMonthVector(aMonth: integer): TwsDFVec;
var i, k: integer;
    Mes, Ano: integer;
begin
  // Primeiro conta os meses
  k := 0;
  for i := 1 to FRes.Len do
    begin
    DateOfValue(i, Mes, Ano);
    if Mes = aMonth then inc(k);
    end;

  // Cria o vetor
  result := TwsDFVec.Create(k);
  result.Name := self.getStrongName() + '_' + SysUtils.LongMonthNames[aMonth];

  // Pega os valores e estabelece o Ano como o nome do vetor
  k := 0;
  for i := 1 to FRes.Len do
    begin
    DateOfValue(i, Mes, Ano);
    if Mes = aMonth then
       begin
       inc(k);
       result[k] := FRes[i];
       end;
    end;
end;

procedure TSerie_Mensal.ObterAcoesIndividuais(Acoes: TActionList);
var act: TAction;
begin
  inherited ObterAcoesIndividuais(Acoes);

  // Fact_ind_Vis sera estabelecido pela chamada acima de TSerie.ObterAcoesIndividuais()
  CreateAction(Acoes, Fact_ind_Vis, 'Planilha (Mês a Mês)', false, ActionManager.SerieVetor_Ind_MostrarEmPlanilha_Mes_a_Mes, self);

  // Fact_ind_Dist sera estabelecido pela chamada acima de TSerie.ObterAcoesIndividuais()
  {$ifndef VERSAO_LIMITADA}
  act := CreateAction(Acoes, Fact_ind_Dist, 'Ajustar distribuição para um mês específico por', false, nil, self);
    CreateAction(Acoes, act, 'Normal'                       , false, ActionManager.SerieVetorMensal_Ind_AjustDistrib, self);
    CreateAction(Acoes, act, 'LogNormal (Dois Parâmetros)'  , false, ActionManager.SerieVetorMensal_Ind_AjustDistrib, self);
    CreateAction(Acoes, act, 'LogNormal (Três Parâmetros)'  , false, ActionManager.SerieVetorMensal_Ind_AjustDistrib, self);
    CreateAction(Acoes, act, 'Log-Pearson Tipo III'         , false, ActionManager.SerieVetorMensal_Ind_AjustDistrib, self);
    CreateAction(Acoes, act, 'Gumbel (Dois Parâmetros)'     , false, ActionManager.SerieVetorMensal_Ind_AjustDistrib, self);
  {$endif}

  CreateAction(Acoes, nil, '-', false, nil, self);

  act := CreateAction(Acoes, nil, 'Séries', false, nil, self);
    CreateAction(Acoes, act, 'Médias Mensais', false, ActionManager.SerieVetorMensal_Ind_MediasMesais, self);
    CreateAction(Acoes, act, 'Médias Anuais', false, ActionManager.SerieVetorMensal_Ind_MediasAnuais, self);
end;

procedure TSerie_Mensal.MostrarDadosEmPlanilha_Mes_a_Mes(p: TSpreadSheetBook);
var i, j, k, mes, ano: Integer;
    x: double;
begin
  for i := 1 to 12 do
    begin
    k := 2;
    p.ActiveSheet.WriteCenter(1, i+1, true, SysUtils.LongMonthNames[i]);
    for j := 1 to FRes.Len do
      begin
      DateOfValue(j, mes, ano);
      if mes = i then
         begin
         if i = 1 then p.ActiveSheet.WriteCenter(k, 1, true, Ano);
         if FRes.IsMissValue(j, x) then
            p.ActiveSheet.WriteCenter(k, i+1, wsConstTypes.wscMissValueChar)
         else
            p.ActiveSheet.WriteCenter(k, i+1, x);
         inc(k);
         end;
      end;
    end;
end;

procedure TSerie_Mensal.InternalFromXML(node: IXMLDomNode);
begin
  inherited InternalFromXML(node);
  FLabels.fromXML(node.childNodes.item[0]); // 1. filho
end;

procedure TSerie_Mensal.InternalToXML(x: TXML_Writer);
begin
  inherited InternalToXML(x);
  x.beginIdent();
    FLabels.toXML(x.Buffer, x.IdentSize, 'labels'); // 1. filho
  x.endIdent();
end;

function TSerie_Mensal.ObterResumo(): String;
var i, Ano, Mes: Integer;
begin
  Result := '(' + IntToStr(FRes.Len) + ' meses)   Dados:  ';

  if FRes.Len > 5 then
     for i := 1 to 5 do
        Result := Result + Format('(%s) %s    ', [getValueLabel(i), FRes.AsTrimString[i]]);

  Result := Result + '...';
end;

procedure TSerie_Mensal.internalClone(Clone: TSerie);
var c: TSerie_Mensal;
begin
  inherited internalClone(Clone);
  c := TSerie_Mensal(Clone);
  c.FLabels := TIntegerList.Create();
  c.FLabels.Assign(self.FLabels);
end;

{ TSerie_Mensal_Preenchida }

// i varia de 1 a N
procedure TSerie_Mensal_Preenchida.Atribuir(i: integer; Valor: double; Mes, Ano: integer; Calculado: boolean);
begin
  FRes[i] := Valor;
  FLabels[i-1] := Ano * 100 + Mes;
  FCalculados[i-1] := Calculado;
end;

// i varia de 1 a N
procedure TSerie_Mensal_Preenchida.Obter(i: integer; out Valor: double; out Mes, Ano: integer; out Calculado: boolean);
begin
  Valor := FRes[i];
  Calculado := FCalculados[i-1];
  DateOfValue(i, Mes, Ano);
end;

constructor TSerie_Mensal_Preenchida.Create(Posto: TStation; Inicializar: boolean);
begin
  FCalculados := TBooleanList.Create();
  inherited Create(Posto, Inicializar);
end;

constructor TSerie_Mensal_Preenchida.Create(Posto: TStation; Tamanho: integer);
begin
  inherited Create(Posto, False);
  FCalculados := TBooleanList.Create(Tamanho);
  FRes.Len := Tamanho;
  FLabels.Count := Tamanho;
end;

destructor TSerie_Mensal_Preenchida.Destroy();
begin
  FCalculados.Free();
  inherited Destroy();
end;

// Este metodo eh necessario pois esta serie pode ser lida de um
// arquivo XML que chamara o "create" generico de TSerie.
procedure TSerie_Mensal_Preenchida.Iniciar();
begin
  inherited Iniciar();
  FCalculados := TBooleanList.Create();
end;

// Este metodo eh necessario pois esta serie pode ser lida de um
// arquivo XML que chamara o "create" generico de TSerie.
function TSerie_Mensal_Preenchida.AgregarMes(LinhaInicial, LinhaFinal: integer): Real;
begin
  // Nao eh necessario ser implementado nesta classe
  result := 0;
end;

procedure TSerie_Mensal_Preenchida.InternalFromXML(node: IXMLDomNode);
begin
  inherited InternalFromXML(node);
  FCalculados.fromXML(node.childNodes.item[1]); // 2. filho
end;

procedure TSerie_Mensal_Preenchida.InternalToXML(x: TXML_Writer);
begin
  inherited InternalToXML(x);
  x.beginIdent();
    FCalculados.toXML(x.Buffer, x.IdentSize, 'calculateds'); // 2. filho
  x.endIdent();
end;

procedure TSerie_Mensal_Preenchida.MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var i: Integer;
begin
  Planilha.BeginUpdate();
  with Planilha.ActiveSheet do
    begin
    BoldCell(1, Coluna);
    Write(1, Coluna, FNome);

    BoldCell(2, Coluna);
    if FPosto <> nil then
       Write(2, Coluna, FPosto.Nome)
    else
       Write(2, Coluna, 'Série Especial');

    // Escreve os valores
    for i := 1 to FRes.Len do
      if FCalculados[i-1] then
         WriteCenter(i + 2, Coluna, 0, clRED, true, FRes.AsTrimString[i])
      else
         WriteCenter(i + 2, Coluna, FRes.AsTrimString[i]);
    end;
  Planilha.EndUpdate();
end;

procedure TSerie_Mensal_Preenchida.MostrarDadosEmPlanilha_Mes_a_Mes(p: TSpreadSheetBook);
var i, j, k, mes, ano: Integer;
    x: double;
begin
  for i := 1 to 12 do
    begin
    k := 2;
    p.ActiveSheet.WriteCenter(1, i+1, true, SysUtils.LongMonthNames[i]);
    for j := 1 to FRes.Len do
      begin
      DateOfValue(j, mes, ano);
      if mes = i then
         begin
         if i = 1 then p.ActiveSheet.WriteCenter(k, 1, true, Ano);
         if FRes.IsMissValue(j, x) then
            p.ActiveSheet.WriteCenter(k, i+1, wsConstTypes.wscMissValueChar)
         else
            if FCalculados[j-1] then
               p.ActiveSheet.WriteCenter(k, i+1, 0, clRED, true, x)
            else
               p.ActiveSheet.WriteCenter(k, i+1, x);
         inc(k);
         end;
      end;
    end;
end;

{ TSerie_Mensal_Medias }

constructor TSerie_Mensal_Medias.Create(Series: array of TSerie_Mensal);
var i, k: Integer;
    m, x: double;
begin
  inherited Create(nil, false);

  Iniciar();

  // Inicializacoe gerais
  FRes.Len := Series[0].Dados.Len;
  FLabels.Assign(Series[0].FLabels);

  // Calcula a media para os elementos do vetor
  for i := 1 to FRes.Len do
    begin
    // Inicia a media
    m := 0;

    // Calcula o somatorio dos elementos i
    // Se houver pelo penos um valor perdido o valor resultante sera considerado perdido
    for k := 0 to System.High(Series) do
      if not Series[k].Dados.IsMissValue(i, x) then
         m := m + x
      else
         begin
         m := wscMissValue;
         Break;
         end;

    // Calcula a media para o elemento i
    if wsGLib.IsMissValue(m) then
       FRes[i] := wscMissValue
    else
       FRes[i] := m / System.Length(Series);
    end;

  // Descricao
  for k := 0 to System.High(Series) do
    if k = 0 then
       FDesc := Series[k].NomeCompleto
    else
       FDesc := FDesc + ', ' + Series[k].NomeCompleto;

  FDesc := 'Média das séries: ' + FDesc;     
end;

procedure TSerie_Mensal_Medias.Iniciar();
begin
  FNome := 'Série Média';
end;

function TSerie_Mensal_Medias.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + FDesc;
end;

{ TSerie_Mensal_MediaMensais }

constructor TSerie_Mensal_MediaMensais.Create(Serie: TSerie_Mensal);
begin
  FSM := Serie;
  inherited Create(Serie.Posto, true);
end;

procedure TSerie_Mensal_MediaMensais.Calcular();
var i, n: Integer;
    v: TwsDFVec;
begin
  //FRes := TwsDFVec.Create(12);
  FRes.Len := 12;
  for i := 1 to 12 do
    begin
    v := FSM.getMonthVector(i);
    FRes[i] := v.Mean({out} n);
    v.Free();
    end;
end;

procedure TSerie_Mensal_MediaMensais.Iniciar();
begin
  FNome := 'Med.Mensais';
end;

function TSerie_Mensal_MediaMensais.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Cria uma série de 12 valores (janeiro a dezembro) onde cada ' +
                     'valor é representado pela média de todos os janeiros, todos ' +
                     'fevereiros e assim por diante até dezembro.';
end;

function TSerie_Mensal_MediaMensais.getValueLabel(ValueIndex: integer): string;
begin
  result := SysUtils.LongMonthNames[ValueIndex];
end;

procedure TSerie_Mensal_MediaMensais.MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var j : Integer;
begin
  for j := 1 to 12 do
    Planilha.ActiveSheet.WriteCenter(j + 2, Coluna, true, getValueLabel(j));
end;

procedure TSerie_Mensal_MediaMensais.ObterAcoesColetivas(Acoes: TActionList);
begin
  inherited ObterAcoesColetivas(Acoes);
  CreateAction(Acoes, Fact_col_Graf, 'Histograma', false, ActionManager.SerieVetor_Col_Histograma, self);
end;

procedure TSerie_Mensal_MediaMensais.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited;
  CreateAction(Acoes, Fact_ind_Graf, 'Histograma', false, ActionManager.SerieVetor_Ind_Graficos, self);
end;

procedure TSerie_Mensal_MediaMensais.PlotarHistograma(Grafico: TfoChart);
var BS: TBarSeries;
     k: integer;
begin
  BS := Grafico.Series.AddBarSerie(self.NomeCompleto, clTeeColor, ord(bsRectangle), ord(mbSide));
  BS.ShowInLegend := False;
  BS.BarWidthPercent := 85;
  for k := 1 to FRes.Len do
    BS.AddXY(k, FRes[k], SysUtils.LongMonthNames[k]);
end;

{ TSerie_Mensal_MediaAnuais }

constructor TSerie_Mensal_MediaAnuais.Create(Serie: TSerie_Mensal);
begin
  FSM := Serie;
  inherited Create(Serie.Posto, true);
end;

procedure TSerie_Mensal_MediaAnuais.Calcular();
var k, i, n, mi, mf, ai, af: Integer;
    v: TwsDFVec;
begin
  k := 0;
  FSM.BeginDate({out} mi, {out} ai);
  FSM.EndDate({out} mf, {out} af);
  //FRes := TwsDFVec.Create(af - ai + 1);
  FRes.Len := af - ai + 1;
  for i := ai to af do
    begin
    inc(k);
    v := FSM.getYearVector(i);
    FRes[k] := v.Mean({out} n);
    v.Free();
    end;
  FAI := ai;
end;

procedure TSerie_Mensal_MediaAnuais.Iniciar();
begin
  FNome := 'Med.Anuais';
end;

function TSerie_Mensal_MediaAnuais.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Define uma série onde cada valor é a média dos 12 meses de uma ano.';
end;

function TSerie_Mensal_MediaAnuais.getValueLabel(ValueIndex: integer): string;
begin
  result := toString(FAI + ValueIndex - 1);
end;

function TSerie_Mensal_MediaAnuais.getXValue(ValueIndex: integer): double;
begin
  result := FAI + ValueIndex - 1;
end;

procedure TSerie_Mensal_MediaAnuais.MostrarCabecalhoEmPlanilha( Planilha: TSpreadSheetBook; Coluna: Word);
var k, j : Integer;
begin
  k  := 3;
  for j := FAI to FAI + FRes.Len - 1 do
    begin
    Planilha.ActiveSheet.WriteCenter(k, Coluna, true, toString(j));
    inc(k);
    end;
end;

procedure TSerie_Mensal_MediaAnuais.InternalFromXML(node: IXMLDomNode);
begin
  inherited InternalFromXML(node);
  FAI := toInt(node.childNodes[0].text);
end;

procedure TSerie_Mensal_MediaAnuais.InternalToXML(x: TXML_Writer);
begin
  inherited InternalToXML(x);
  x.beginIdent();
    x.Write('InitialYear', FAI); // nó 0
  x.endIdent();
end;

procedure TSerie_Mensal_Preenchida.internalClone(Clone: TSerie);
var c: TSerie_Mensal_Preenchida;
begin
  inherited internalClone(Clone);
  c := TSerie_Mensal_Preenchida(Clone);
  c.FCalculados := TBooleanList.Create();
  c.FCalculados.Assign(self.FCalculados);
end;

{ TSerie_Anual_Preenchida }

procedure TSerie_Anual_Preenchida.Atribuir(i: integer; Valor: double; Calculado: boolean);
begin
  FRes[i] := Valor;
  FCalculados[i-1] := Calculado;
end;

constructor TSerie_Anual_Preenchida.Create(SeriePai: TSerie_Anual);
begin
  inherited Create(SeriePai.Posto, SeriePai.FMesInicial);
  FRes.Assign(SeriePai.Dados);
  FCalculados := TBooleanList.Create(FRes.Len);
  FNome := SeriePai.Nome + ' (preenchida)';
end;

constructor TSerie_Anual_Preenchida.Create(Posto: TStation; MesInicial: integer);
begin
  FCalculados := TBooleanList.Create();
  inherited Create(Posto, MesInicial);
end;

destructor TSerie_Anual_Preenchida.Destroy();
begin
  FCalculados.Free();
  inherited;
end;

procedure TSerie_Anual_Preenchida.InternalFromXML(node: IXMLDomNode);
begin
  inherited InternalFromXML(node);
  FCalculados.fromXML(node.childNodes.item[0]); // 1. filho
end;

procedure TSerie_Anual_Preenchida.InternalToXML(x: TXML_Writer);
begin
  inherited InternalToXML(x);
  x.beginIdent();
    FCalculados.toXML(x.Buffer, x.IdentSize, 'calculateds'); // 1. filho
  x.endIdent();
end;

procedure TSerie_Anual_Preenchida.MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var i: Integer;
begin
  Planilha.BeginUpdate();
  with Planilha.ActiveSheet do
    begin
    BoldCell(1, Coluna);
    Write(1, Coluna, FNome);

    BoldCell(2, Coluna);
    Write(2, Coluna, FPosto.Nome);

    // Escreve os valores
    for i := 1 to FRes.Len do
      if FCalculados[i-1] then
         WriteCenter(i + 2, Coluna, 0, clRED, true, FRes.AsTrimString[i])
      else
         WriteCenter(i + 2, Coluna, FRes.AsTrimString[i]);
    end;
  Planilha.EndUpdate();
end;

{ TSerie_Anual_Minimos }

constructor TSerie_Anual_Minimos.Create(Posto: TStation; MesInicial, TamMedia: integer);
begin
  FTamMedia := TamMedia;
  inherited Create(Posto, MesInicial);
end;

procedure TSerie_Anual_Minimos.Iniciar();
begin
  FNome := 'Minimos Anuais';
end;

procedure TSerie_Anual_Minimos.InternalFromXML(node: IXMLDomNode);
begin
  inherited InternalFromXML(node);
  FTamMedia := toInt(node.childNodes.item[0].Text);
end;

procedure TSerie_Anual_Minimos.InternalToXML(x: TXML_Writer);
begin
  inherited InternalToXML(x);
  x.beginIdent();
    x.Write('MeanSize', FTamMedia);
  x.endIdent();
end;

function TSerie_Anual_Minimos.ObterDescricao(): String;
begin
  result := inherited ObterDescricao();
  result := result + 'Para cada ano seleciona-se uma série de valores agrupados pela ' +
                     'média de N dias consecutivos. Em seguida seleciona-se o menor destes ' +
                     'valores. Este valor será o representante anual.';
end;

function TSerie_Anual_Minimos.ObterTextoDoNo(): string;
begin
  result := FNome + ' (' + toString(FTamMedia) + ')';
end;

function TSerie_Anual_Minimos.SelecionarValorOuAgregar(LinhaInicial, LinhaFinal: integer): Real;
var i, f, k, j, d: Integer;
    m, e: double;
    x: TwsDFVec;
begin
  f := LinhaFinal - FTamMedia + 1;
  x := TwsDFVec.Create(f - LinhaInicial + 1);
  k := 1;

  // Forma o vetor com as medias moveis
  for i := LinhaInicial to f do
    begin
    m := 0;
    d := 0;

    // Calcula o somatorio do sub intervalo considerando somente valores validos
    for j := 1 to FTamMedia do
      if not FPosto.Info.DS.IsMissValue(i + j - 1, FPosto.IndiceCol, e) then
         begin
         m := m + e;
         d := d + 1;
         end;

    // Calcula a media e vai para a proxima posicao do vetor das medias
    if (d = FTamMedia) then x[k] := m / d else x[k] := wscMissValue;
    inc(k);
    end;

  // Retorna a menor media. Este valor representara o ano
  result := x.Min();

  // Libera o vetor das medias
  x.Free();
end;

{ TSerie_PostoAdmensionalizado }

procedure TSerie_PostoAdmensionalizado.Calcular();
var i: Integer;
begin
  // Passa os dados para o vetor
  FRes.Len := FPosto.Info.DS.nRows;
  for i := 1 to Fres.Len do
    FRes[i] := FPosto.Info.DS[i, FPosto.IndiceCol];

  // Admensiona o vetor pela media
  FRes.ByScalar(FRes.Mean(i), opDiv, false, false);
end;

function TSerie_PostoAdmensionalizado.getValueLabel(ValueIndex: integer): string;
begin
  result := DateToStr(FPosto.Info.DS.AsDateTime[ValueIndex, 1]);
end;

procedure TSerie_PostoAdmensionalizado.Iniciar();
begin
  FNome := FPosto.Nome + ' (admensionalizado)';
end;

procedure TSerie_PostoAdmensionalizado.MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var i : Integer;
begin
  for i := 1 to FRes.Len do
    Planilha.ActiveSheet.WriteCenter(i + 2, Coluna, true, getValueLabel(i));
end;

procedure TSerie_PostoAdmensionalizado.MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var i: Integer;
begin
  Planilha.BeginUpdate();
  with Planilha.ActiveSheet do
    begin
    BoldCell(1, Coluna);
    Write(1, Coluna, FNome);

    BoldCell(2, Coluna);
    if FPosto <> nil then
       Write(2, Coluna, FPosto.Nome)
    else
       Write(2, Coluna, 'Série Especial');

    // Escreve os valores
    for i := 1 to FRes.Len do
      WriteCenter(i + 2, Coluna, FRes.AsTrimString[i]);
    end;
  Planilha.EndUpdate();
end;

{ TScript }

constructor TScript.Create(const Filename: string);
begin
  inherited Create();
  FFilename := Filename;
end;

procedure TScript.Delete();
begin
  self.No.Delete();
  Free();
end;

procedure TScript.Edit();
var v: TVariable;
    p: TproApplication;
begin
  p := Applic();
  v := TVariable.Create('Application', pvtObject, integer(p), p.ClassType, true);
  RunScript(Applic.psLIB, FFilename, Applic.LastDir, nil, [v], nil, False);
end;

procedure TScript.ExecutarAcaoPadrao();
begin
  Execute();
end;

procedure TScript.Execute();
var v: TVariable;
    x: TPascalScript;
    p: TproApplication;
begin
  p := Applic();
  x := TPascalScript.Create();
  try
    x.Filename := FFilename;
    x.Code.LoadFromFile(FFilename);
    x.AssignLib(Applic.psLib);
    x.Variables.AddVar(TVariable.Create('Application', pvtObject, integer(p), p.ClassType, true));
    if x.Compile() then
       begin
       Applic.ActiveScript := x;
       x.Execute();
       end
    else
       Dialogs.ShowMessage(x.Errors.Text);
  finally
    Applic.ActiveScript := nil;
    x.Free();
  end;
end;

procedure TScript.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CreateAction(Acoes, nil, 'Executar ...', false, ActionManager.Script_Executar, self);
  CreateAction(Acoes, nil, 'Editar ...', false, ActionManager.Script_Editar, self);
  CreateAction(Acoes, nil, 'Remover ...', false, ActionManager.Script_Remover, self);
end;

function TScript.ObterIndiceDaImagem(): integer;
begin
  result := iiScript;
end;

function TScript.ObterTextoDoNo(): string;
begin
  result := ChangeFileExt(ExtractFileName(FFilename), '');
end;

{ TScripts }

procedure TScripts.Add(const Filename: string);
begin
  Applic.Tree.Items.AddChildObject(self.No, 'Script', TScript.Create(Filename));
end;

constructor TScripts.Create(Node: TTreeNode);
begin
  inherited Create();
  self.EstabelecerNo(Node);
  Node.Data := self;
end;

function TScripts.getCount(): integer;
begin
  result := No.Count;
end;

function TScripts.getScript(i: integer): TScript;
begin
  result := TScript(no.Item[i].Data);
end;

procedure TScripts.ObterAcoesIndividuais(Acoes: TActionList);
begin
  inherited ObterAcoesIndividuais(Acoes);
  CreateAction(Acoes, nil, 'Adicionar ...', false, ActionManager.Scripts_Adicionar, self);
end;

function TScripts.ObterIndiceDaImagem: integer;
begin
  result := iiCloseFolder;
end;

function TScripts.ObterTextoDoNo(): string;
begin
  result := 'Scripts';
end;

{ TSerie_ValoresDoPosto }

procedure TSerie_ValoresDoPosto.Calcular();
var i: Integer;
begin
  // Passa os dados para o vetor
  FRes.Len := FPosto.Info.DS.nRows;
  for i := 1 to Fres.Len do
    FRes[i] := FPosto.Info.DS[i, FPosto.IndiceCol];
end;

function TSerie_ValoresDoPosto.getValueLabel(ValueIndex: integer): string;
begin
  result := DateToStr(FPosto.Info.DS.AsDateTime[ValueIndex, 1]);
end;

procedure TSerie_ValoresDoPosto.Iniciar();
begin
  FNome := 'Dados do Posto: ' + FPosto.Nome;
end;

procedure TSerie_ValoresDoPosto.MostrarCabecalhoEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var i : Integer;
begin
  for i := 1 to FRes.Len do
    Planilha.ActiveSheet.WriteCenter(i + 2, Coluna, true, getValueLabel(i));
end;

procedure TSerie_ValoresDoPosto.MostrarDadosEmPlanilha(Planilha: TSpreadSheetBook; Coluna: Word);
var i: Integer;
begin
  Planilha.BeginUpdate();
  with Planilha.ActiveSheet do
    begin
    BoldCell(1, Coluna);
    Write(1, Coluna, FNome);

    BoldCell(2, Coluna);
    if FPosto <> nil then
       Write(2, Coluna, FPosto.Nome)
    else
       Write(2, Coluna, 'Série Especial');

    // Escreve os valores
    for i := 1 to FRes.Len do
      WriteCenter(i + 2, Coluna, FRes.AsTrimString[i]);
    end;
  Planilha.EndUpdate();
end;

end.

