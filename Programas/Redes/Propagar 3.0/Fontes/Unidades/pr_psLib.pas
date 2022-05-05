unit pr_psLib;

interface
uses psBASE;

  procedure API(Lib: TLib);

implementation
uses Classes, SysUtils, Dialogs, pr_Classes, pr_Const, pr_Tipos,
     Lists, EquationBuilder, Optimizer_Base, Solver.Classes;                   

type
  Tps_Base = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_Nome(Const Func_Name: String; Stack: TexeStack);
  end;

  TpsProjeto_Class = Class(TpsClass)
  public
    procedure AddMethods; override;
    class procedure amTotal_IS                      (Const Func_Name: String; Stack: TexeStack);
    class procedure amObterIntervalo                (Const Func_Name: String; Stack: TexeStack);
    class procedure amObterData                     (Const Func_Name: String; Stack: TexeStack);
    class procedure amNumPCs                        (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPC                       (Const Func_Name: String; Stack: TexeStack);
    class procedure amObjetoPeloNome                (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPCPeloNome               (Const Func_Name: String; Stack: TexeStack);
    class procedure amPCsEntreDois                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amObterSubRede                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amOtimizador                    (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Executar                     (Const Func_Name: String; Stack: TexeStack);
    class procedure am_IndiceDoPC                   (Const Func_Name: String; Stack: TexeStack);
    class procedure am_IntervaloDeSimulacao         (Const Func_Name: String; Stack: TexeStack);
    class procedure am_DiasNoIntervalo              (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NivelDeFalha                 (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NumAnosDeExecucao            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TerminarSimulacao            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TotalAnual_IntSim            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_ValorFO                      (Const Func_Name: String; Stack: TexeStack);
    class procedure am_RealizaBalancoHidricoAte     (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Equacoes_Iniciar             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Equacoes_Escrever            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Equacoes_GerarBalancoHidrico (Const Func_Name: String; Stack: TexeStack);
    class procedure am_MostrarHTML                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_ObterNomeArquivo             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_AplicarVariaveisNosObjetos   (Const Func_Name: String; Stack: TexeStack);
    class procedure am_AplicarValoresNosObjetos     (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Variaveis                    (Const Func_Name: String; Stack: TexeStack);
  end;

  TpsProjetoSC_Class = class(TpsProjeto_Class)
    procedure AddMethods; override;
  end;

  TpsProjetoZP_Class = class(TpsProjeto_Class)
    procedure AddMethods; override;
  end;

  TpsPCP_Class = Class(TpsClass)
  public
    procedure AddMethods(); override;

    class procedure amNumDemandas               (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemValorDemanda         (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemHierarquia           (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemFatorRetorno         (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVazoesDeMontante     (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemFalhas               (Const Func_Name: String; Stack: TexeStack);
    class procedure amAfluenciaSBs              (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribValorDemanda         (Const Func_Name: String; Stack: TexeStack);
    class procedure amPC_eh_Res                 (Const Func_Name: String; Stack: TexeStack);
    class procedure amDefluencia                (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribDefluencia           (Const Func_Name: String; Stack: TexeStack);
    class procedure amHm3_m3                    (Const Func_Name: String; Stack: TexeStack);
    class procedure amm3_Hm3                    (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Demandas                 (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Demanda                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_aJusante              (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_aMontante             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PCs_aMontante            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_SubBacia                 (Const Func_Name: String; Stack: TexeStack);
    class procedure am_SubBacias                (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TrechoDagua              (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Eh_PC_Montante           (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Equacoes_MudarTipoVar    (Const Func_Name: String; Stack: TexeStack);
    class procedure am_MudarCor                 (Const Func_Name: String; Stack: TexeStack);
    class procedure am_ObterCor                 (Const Func_Name: String; Stack: TexeStack);

    // Somente se o PC é um reservatório ...

    class procedure amObtemVol                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVolMax               (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVolMin               (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVolInicial           (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDefluPlanejado       (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDefluOperado         (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemEvaporacaoUnitaria   (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPrecipitacaoUnitaria (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemEnergia              (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemRSA                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemRT                   (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemRG                   (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemQMaxTurb             (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemQuedaFixa            (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDemEnergetica        (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemCurvaDemEnergetica   (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribVol                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribEnergia              (Const Func_Name: String; Stack: TexeStack);
    class procedure amAbribDefluPlanej          (Const Func_Name: String; Stack: TexeStack);
    class procedure amCalculaCotaHidraulica     (Const Func_Name: String; Stack: TexeStack);
    class procedure amCalculaCotaJusante        (Const Func_Name: String; Stack: TexeStack);
    class procedure amCalculaAreaDoReservatorio (Const Func_Name: String; Stack: TexeStack);
    class procedure amLigado                    (Const Func_Name: String; Stack: TexeStack);
  end;

  TpsFalha_Class = class(TpsClass)
  public
    procedure AddMethods; override;

    class procedure amAno                (Const Func_Name: String; Stack: TexeStack);
    class procedure amsAno               (Const Func_Name: String; Stack: TexeStack);
    class procedure amEh_FalhaCritica    (Const Func_Name: String; Stack: TexeStack);
    class procedure amIntervalos         (Const Func_Name: String; Stack: TexeStack);
    class procedure amIntervalosCriticos (Const Func_Name: String; Stack: TexeStack);
    class procedure amDemsRef            (Const Func_Name: String; Stack: TexeStack);
    class procedure amDemsAten           (Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_ListaDeFalhas = class(TpsClass)
  public
    procedure AddMethods; override;

    class procedure amMostrarFalhas        (Const Func_Name: String; Stack: TexeStack);
    class procedure amAnosCriticos         (Const Func_Name: String; Stack: TexeStack);
    class procedure amIntervalosCriticos   (Const Func_Name: String; Stack: TexeStack);
    class procedure amFalhaPeloAno         (Const Func_Name: String; Stack: TexeStack);
    class procedure amIntervalosTotais     (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemFalhaPrimaria   (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemFalhaSecundaria (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemFalhaTerciaria  (Const Func_Name: String; Stack: TexeStack);
    class procedure amNumFalhasPrimarias   (Const Func_Name: String; Stack: TexeStack);
    class procedure amNumFalhasSecundarias (Const Func_Name: String; Stack: TexeStack);
    class procedure amNumFalhasTerciarias  (Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_prClasseDemanda = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_EscalaDeDesenvolvimento      (Const Func_Name: String; Stack: TexeStack); // <<<
    class procedure am_FatorDeConversao             (Const Func_Name: String; Stack: TexeStack); // <<<
    class procedure am_FatorDeImplantacao           (Const Func_Name: String; Stack: TexeStack);
    class procedure am_FatorDeRetorno               (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Ligada                       (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NomeUnidadeConsumoAgua       (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NomeUnidadeDeDemanda         (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Prioridade                   (Const Func_Name: String; Stack: TexeStack);
    class procedure am_UnidadeDeConsumo             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_UnidadeDeDemanda             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_NumIntervalos            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_AnoIniFimIntervalo       (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_Demanda                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_ObterNumIntervalos       (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_ObterAnoIniFimIntervalo  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_ObterDemanda             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Eh_VarDecisao                (Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_prDemanda = class(Tps_prClasseDemanda)
    procedure AddMethods; override;
    class procedure am_Classe       (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Habilitada   (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Tipo         (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Cenarios     (Const Func_Name: String; Stack: TexeStack);
    class procedure am_ObterCenario (Const Func_Name: String; Stack: TexeStack);
    class procedure am_DemandaTotal (Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_Cenario = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_ObterValorFloat  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_ObterValorString (Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_TrechoDagua = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_PC_Jusante  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_Montante (Const Func_Name: String; Stack: TexeStack);
    class procedure am_VazaoMaxima (Const Func_Name: String; Stack: TexeStack);
    class procedure am_VazaoMinima (Const Func_Name: String; Stack: TexeStack);
  end;

{ ------------------- Ponto de Entrada ------------------ }

const
  cCatPropagar = 'Propagar';

procedure API(Lib: TLib);
begin
 Tps_Base.Create(
     THidroComponente,
     nil,
     '',
     cCatPropagar,
     [], [], [],
     False,
     Lib.Classes);

  TpsProjeto_Class.Create(
      TprProjetoOtimizavel,
      THidroComponente,
      'Encapsula um projeto do Propagar',
      '',
      [], [], [],
      False,
      Lib.Classes);

  TpsProjetoSC_Class.Create(
      TprProjeto_ScrollCanvas,
      TprProjetoOtimizavel,
      'Encapsula um projeto do Propagar sem capacidad de Zoom',
      '',
      [], [], [],
      False,
      Lib.Classes);

  TpsProjetoZP_Class.Create(
      TprProjeto_ZoomPanel,
      TprProjetoOtimizavel,
      'Encapsula um projeto do Propagar com capacidade de Zoom',
      '',
      [], [], [],
      False,
      Lib.Classes);

  TpsPCP_Class.Create(
      TprPCP,
      THidroComponente,
      'Encapsula um PC do Propagar',
      '',
      [], [], [],
      False,
      Lib.Classes);

  Tps_prClasseDemanda.Create(
      TprClasseDemanda,
      THidroComponente,
      '',
      '',
      [], [], [],
      False,
      Lib.Classes);

  Tps_prDemanda.Create(
      TprDemanda,
      TprClasseDemanda,
      '',
      '',
      [], [], [],
      False,
      Lib.Classes);

  Tps_Cenario.Create(
      TprCenarioDeDemanda,
      THidroComponente,
      'Representa informações complementares de uma demanda',
      '',
      [], [], [],
      False,
      Lib.Classes);

  Tps_TrechoDagua.Create(
      TprTrechoDagua,
      THidroComponente,
      '',
      '',
      [], [], [],
      False,
      Lib.Classes);

  TpsFalha_Class.Create(
      TprFalha,
      nil,
      'Encapsula as informações das falhas de um ano',
      cCatPropagar,
      [], [], [],
      false,
      Lib.Classes);

  Tps_ListaDeFalhas.Create(
      TprListaDeFalhas,
      nil,
      'Armazena todas as falhas de suprimento de água de um PC.'#13 +
      'As falhas estão divididas em 3 níveis: Falhas primárias, secundárias e terciárias.'#13 +
      'Cada nível armazena os intervalos onde ocorreram as falhas em um ano e também se nesse'#13 +
      'intervalo a falha foi crítica ou não.'#13 +
      '   Ex: Falha primária: 3 anos -->'#13 +
      '       1978: (intervalo/critica) --> (34/não), (534/sim), (678/não)'#13 +
      '       1981: (intervalo/critica) --> (23/não), (345/não), (456/não)'#13 +
      '       1982: (intervalo/critica) --> (249/não)',
      cCatPropagar,
      [], [], [],
      false,
      Lib.Classes);
end;

{ ------------------- Ponto de Entrada ------------------ }

{ Tps_Base }

class procedure Tps_Base.am_Nome(Const Func_Name: String; Stack: TexeStack);
var o: THidroComponente;
begin
  o := THidroComponente(Stack.getSelf);
  Stack.PushString(o.Nome)
end;

procedure Tps_Base.AddMethods;
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('Nome',
        'Retorna o nome do Objeto',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_Nome);

    end;
end;

{ TpsProjeto_Class }

procedure TpsProjeto_Class.AddMethods;
begin
  with Procs do
    begin
(*
    Add('AtribuiDeltaT',
        'Atribui um DeltaT a um projeto',
        '',
        [pvtInteger], [nil], [False],
        pvtNull,
        TObject,
        amAtribuiDeltaT);
*)
    Add('IntervaloComoData',
        'Obtém o Intervalo como Mes/Ano'#13 +
        'Parâmetros: DeltaT, Mes (saida), Ano (saida)',
        '',
        [pvtInteger, pvtInteger, pvtInteger],
        [nil       , nil       , nil       ],
        [false     , true      , true      ],
        pvtNull,
        TObject,
        amObterData);

    Add('Executar',
        'Executa uma simulação',
        '',
        [],
        [],
        [],
        pvtNull,
        TObject,
        am_Executar);

    Add('TerminarSimulacao',
        '',
        '',
        [],
        [],
        [],
        pvtNull,
        TObject,
        am_TerminarSimulacao);

    Add('MostrarHTML',
        '',
        '',
        [pvtString],
        [nil      ],
        [false    ],
        pvtNull,
        TObject,
        am_MostrarHTML);

    Add('RealizaBalancoHidricoAte',
        'Realiza o Balanço Hídrico de uma determinada Sub-Rede.'#13 +
        'Se o segundo parâmetro for verdadeiro, o Balanço Hídrico será'#13 +
        'realizado até os reservatórios, incluindo-os',
        '',
        [pvtObject, pvtBoolean],
        [TprPCP, nil],
        [true, false],
        pvtNull,
        TObject,
        am_RealizaBalancoHidricoAte);

    Add('Equacoes_Iniciar',
        '',
        '',
        [], [], [],
        pvtNull,
        TObject,
        am_Equacoes_Iniciar);

    Add('Equacoes_Escrever',
        '',
        '',
        [pvtString], [nil], [false],
        pvtNull,
        TObject,
        am_Equacoes_Escrever);

    Add('Equacoes_GerarBalancoHidrico',
        'Gera as equações de Balanço Hídrico para a rede'#13 +
        'Parâmetro: Intervalo de tempo',
        '',
        [pvtInteger], [nil], [false],
        pvtNull,
        TObject,
        am_Equacoes_GerarBalancoHidrico);

    Add('AplicarVariaveisNosObjetos',
        'Aplica os valores das variaveis otimizadas nos objetos da rede com base em um mapeamento.'#13 +
        'Este mapeamento deverá ser um arquivo texto CSV e seguir o seguinte formato:'#13 +
        'NomeDaVariavel;NomeDoObjeto;NomeDaPropriedade'#13 +
        'Parâmetro: Nome do arquivo de mapeamento',
        '',
        [pvtString], [nil], [false],
        pvtNull,
        TObject,
        am_AplicarVariaveisNosObjetos);

    Add('AplicarValoresNosObjetos',
        'Aplica valores nos objetos da rede com base em um mapeamento.'#13 +
        'Este mapeamento deverá ser um arquivo texto CSV e seguir o seguinte formato:'#13 +
        'Valor;NomeDoObjeto;NomeDaPropriedade'#13 +
        'Parâmetro: Nome do arquivo de mapeamento'#13 +
        'ATENÇÃO: O separador decimal utilizado deverá ser o "." (ponto)',
        '',
        [pvtString], [nil], [false],
        pvtNull,
        TObject,
        am_AplicarValoresNosObjetos);
    end;

  with Functions do
    begin
    Add('NomeArquivo',
        'Retorna o nome do arquivo do projeto',
        '',
        [], [], [],
        pvtString,
        TObject,
        am_ObterNomeArquivo);

    Add('Intervalo',
        'Retorna o Intervalo atual de simulacao do projeto',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amObterIntervalo);

    Add('Total_IntSim',
        'Obtém o número total de intervalos de simulação',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amTotal_IS);

    Add('NumPCs',
        'Obtém o número de PCs de um projeto, incluindo reservatórios',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amNumPCs);

    Add('PC',
        'Obtém o n-égimo PC de um projeto.'#13 +
        'Para saber se este PC é um reservatório, utilize o método "PC_Eh_Reservatorio"'#13 +
        'Parâmetros: Índice do PC',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtObject   ,
        TprPCP      ,
        amObtemPC);

    Add('ObjetoPeloNome',
        'Obtém um Componente de um projeto dado seu nome.'#13 +
        'Parâmetros: Nome do objeto (string)'#13 +
        'O resultado deverá ser tipado para o tipo destino.',
        '',
        [pvtString],
        [nil      ],
        [False    ],
        pvtObject  ,
        TObject,
        amObjetoPeloNome);

    Add('PCPeloNome',
        'Obtém um PC de um projeto dado seu nome.'#13 +
        'Parâmetros: Nome do PC (string)',
        '',
        [pvtString],
        [nil      ],
        [False    ],
        pvtObject  ,
        TprPCP     ,
        amObtemPCPeloNome);

    Add('PCsEntreDois',
        'Obtém os nomes dos PCs que estão entre os referenciados pelos parâmetros.'#13 +
        'Parâmetros: Nome do PC inicial e final (strings)'#13 +
        'A lista retornada deverá ser destruída após não ter mais uso.',
        '',
        [pvtString, pvtString],
        [nil      , nil      ],
        [False    , False    ],
        pvtObject ,
        TStringList,
        amPCsEntreDois);

    Add('ObterSubRede',
        'Obtém os nomes e os PCs que formam a sub-rede a partir de um PC.'#13 +
        'Parâmetros: PC, AteOsReservatorios'#13 +
        'Se "AteOsReservatorios" for verdadeiro é retornada a sub-rede que vai'#13 +
        'ate os reservatorios, incluindo-os.'#13 +
        'A lista retornada deverá ser destruída após não ter mais uso.',
        '',
        [pvtObject, pvtBoolean],
        [TprPCP   , nil       ],
        [True     , False     ],
        pvtObject ,
        TStringList,
        amObterSubRede);

    Add('Otimizador',
        'Obtém o Otimizador Ativo.'#13 +
        'Para saber qual otimizador está ativo, verifique sua classe.'#13 +
        'Ex:'#13 +
        '  if Projeto.Otimizador.ClassName = "TRosenbroke" then ...',
        '',
        [], [], [],
        pvtObject,
        TOptimizer,
        amOtimizador);

    Add('IndiceDoPC',
        'Retorna o índice deste PC',
        '',
        [pvtObject],
        [TprPCP],
        [True],
        pvtInteger,
        TObject,
        am_IndiceDoPC);

    Add('IntervaloDeSimulacao',
        'Retorna o tipo do intervalo:'#13 +
        '  - 0 = Quinquendial'#13 +
        '  - 1 = Semanal'#13 +
        '  - 2 = Decendial'#13 +
        '  - 3 = Quinzenal'#13 +
        '  - 4 = Mensal',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_IntervaloDeSimulacao);

    Add('DiasNoIntervalo',
        'Retorna o número de dias que um intervalo possui'#13 +
        'Parâmetro: intervalo (inteiro)',
        '',
        [pvtInteger],
        [nil],
        [false],
        pvtInteger,
        TObject,
        am_DiasNoIntervalo);

    Add('NivelDeFalha',
        'Nivel de Falha para as demandas',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_NivelDeFalha);

    Add('NumAnosDeExecucao',
        'Número de anos de simulação',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_NumAnosDeExecucao);

    Add('TotalAnual_IntSim',
        'Número de intervalos de simulação em um ano',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_TotalAnual_IntSim);

    Add('ValorFO',
        'Vaor da função objetivo estabelecida ao final da simulação',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_ValorFO);

    Add('Variaveis',
        'Retorna a lista de variáveis do projeto',
        '',
        [], [], [],
        pvtObject,
        TVariableList,
        am_Variaveis);
    end;
end;

class procedure TpsProjeto_Class.amObterData(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
    d: TRec_prData;
begin
  o := TprProjeto( Stack.getSelf() );

  // Salva o deltaT
  //i := o.DeltaT;
  //o.DeltaT := Stack.AsInteger(1);

  d := o.IntervaloParaData(Stack.AsInteger(1));
  Stack.AsReferency(2).Value := d.Mes;
  Stack.AsReferency(3).Value := d.Ano;

  // Retorna o DeltaT
  //o.DeltaT := i;
end;

class procedure TpsProjeto_Class.amNumPCs(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprProjeto( Stack.getSelf() ).PCs.PCs);
end;

class procedure TpsProjeto_Class.amObterIntervalo(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprProjeto( Stack.getSelf() ).Intervalo);
end;

class procedure TpsProjeto_Class.amObtemPC(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(TprProjeto( Stack.getSelf() ).PCs[Stack.AsInteger(1)]);
end;

class procedure TpsProjeto_Class.amObjetoPeloNome(const Func_Name: String; Stack: TexeStack);
var o: TObject;
begin
  o := TprProjeto( Stack.getSelf() ).ObjetoPeloNome(Stack.AsString(1));
  Stack.PushObject(o);
end;

class procedure TpsProjeto_Class.amObtemPCPeloNome(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprProjeto( Stack.getSelf() ).PCPeloNome(Stack.AsString(1));
  Stack.PushObject(PC);
end;

class procedure TpsProjeto_Class.amOtimizador(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(TprProjetoOtimizavel( Stack.getSelf() ).Optimizer);
end;

class procedure TpsProjeto_Class.amTotal_IS(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprProjeto( Stack.getSelf() ).Total_IntSim);
end;

(*
class procedure TpsProjeto_Class.amAtribuiDeltaT(const Func_Name: String; Stack: TexeStack);
begin
  TprProjeto( Stack.getSelf() ).DeltaT := Stack.AsInteger(1);
end;
*)

class procedure TpsProjeto_Class.am_Executar(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.Executar;
end;

class procedure TpsProjeto_Class.am_IndiceDoPC(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushInteger(o.PCs.IndiceDo(TprPCP(Stack.AsObject(1))));
end;

class procedure TpsProjeto_Class.am_IntervaloDeSimulacao(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushInteger(ord(o.IntervaloDeSimulacao));
end;

class procedure TpsProjeto_Class.am_NivelDeFalha(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushFloat(o.NivelDeFalha);
end;

class procedure TpsProjeto_Class.am_NumAnosDeExecucao(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushInteger(o.NumAnosDeExecucao);
end;

class procedure TpsProjeto_Class.am_TerminarSimulacao(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.TerminarSimulacao;
end;

class procedure TpsProjeto_Class.am_TotalAnual_IntSim(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushInteger(o.TotalAnual_IntSim);
end;

class procedure TpsProjeto_Class.am_ValorFO(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushFloat(o.ValorFO);
end;

class procedure TpsProjeto_Class.amPCsEntreDois(const Func_Name: String; Stack: TexeStack);
var SL: TStrings;
begin
  SL := TprProjeto( Stack.getSelf() ).PCsEntreDois(Stack.AsString(1), Stack.AsString(2));
  Stack.PushObject(SL);
end;

class procedure TpsProjeto_Class.am_DiasNoIntervalo(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushInteger(o.DiasNoIntervalo(Stack.AsInteger(1)));
end;

class procedure TpsProjeto_Class.am_RealizaBalancoHidricoAte(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.RealizarBalancoHidricoAte( TprPCP(Stack.AsObject(1)), Stack.AsBoolean(2) );
end;

class procedure TpsProjeto_Class.am_Equacoes_Escrever(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.EquationBuilder.Text.Add(Stack.AsString(1));
end;

class procedure TpsProjeto_Class.am_Equacoes_GerarBalancoHidrico(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.Equacoes_GerarBalancoHidrico( Stack.AsInteger(1) );
end;

class procedure TpsProjeto_Class.amObterSubRede(const Func_Name: String; Stack: TexeStack);
var SL: TStrings;
begin
  SL := TprProjeto( Stack.getSelf() ).ObterSubRede( TprPCP(Stack.AsObject(1)),
                                                           Stack.AsBoolean(2) );
  Stack.PushObject(SL);
end;

class procedure TpsProjeto_Class.am_Equacoes_Iniciar(const Func_Name: String; Stack: TexeStack);
begin
  TprProjeto(Stack.getSelf()).Equacoes_Iniciar();
end;

class procedure TpsProjeto_Class.am_MostrarHTML(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.ShowHTML(Stack.AsString(1));
end;

class procedure TpsProjeto_Class.am_ObterNomeArquivo(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushString(o.NomeArquivo);
end;

class procedure TpsProjeto_Class.am_AplicarVariaveisNosObjetos(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.AplicarVariaveisNosObjetos(Stack.AsString(1));
end;

class procedure TpsProjeto_Class.am_Variaveis(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushObject(o.Variaveis);
end;

class procedure TpsProjeto_Class.am_AplicarValoresNosObjetos(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  o.AplicarValoresNosObjetos(Stack.AsString(1));
end;

{ TpsPCP_Class }

class procedure TpsPCP_Class.amAtribVol(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(3));
  PC.Volume[Stack.AsInteger(1)] := Stack.AsFloat(2);
end;

class procedure TpsPCP_Class.amAbribDefluPlanej(Const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(3));
  PC.DefluvioPlanejado[Stack.AsInteger(1)] := Stack.AsFloat(2);
end;

class procedure TpsPCP_Class.amNumDemandas(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprPCP(Stack.AsObject(1)).Demandas);
end;

class procedure TpsPCP_Class.amObtemVol(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(2));
  Stack.PushFloat(PC.Volume[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.amPC_eh_Res(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushBoolean(PC is TprPCPR);
end;

class procedure TpsPCP_Class.amAfluenciaSBs(Const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP( Stack.getSelf() );
  Stack.PushFloat( PC.ObterVazaoAfluenteSBs(Stack.AsInteger(1)) );
end;

class procedure TpsPCP_Class.amDefluencia(Const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(2));
  Stack.PushFloat(PC.Defluencia[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.amObtemDefluPlanejado(Const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(2));
  Stack.PushFloat(PC.DefluvioPlanejado[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.amAtribDefluencia(Const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(3));
  PC.Defluencia[Stack.AsInteger(1)] := Stack.AsFloat(2);
end;

class procedure TpsPCP_Class.amObtemValorDemanda(const Func_Name: String; Stack: TexeStack);
var r: Real;
    c: Char;
    s: String;
    Prioridade: Integer;
    PC: TprPCP;
begin
  Prioridade := Stack.AsInteger(2);
  If (Prioridade < 1) or (Prioridade > 3) then
     Prioridade := 1;

  s := Stack.AsString(3);
  if s <> '' then
     c := UpCase(s[1])
  else
     c := 'T';

  PC := TprPCP(Stack.AsObject(4));

  Case Prioridade of
    1: case c of
         'A': r := PC.DemPriAtendida [Stack.AsInteger(1)];
         'P': r := PC.DemPriPlanejada[Stack.AsInteger(1)];
         'T': r := PC.DemPriTotal    [Stack.AsInteger(1)];
         end;

    2: case c of
         'A': r := PC.DemSecAtendida [Stack.AsInteger(1)];
         'P': r := PC.DemSecPlanejada[Stack.AsInteger(1)];
         'T': r := PC.DemSecTotal    [Stack.AsInteger(1)];
         end;

    3: case c of
         'A': r := PC.DemTerAtendida [Stack.AsInteger(1)];
         'P': r := PC.DemTerPlanejada[Stack.AsInteger(1)];
         'T': r := PC.DemTerTotal    [Stack.AsInteger(1)];
         end;
    end;

  Stack.PushFloat(r);
end;

class procedure TpsPCP_Class.amAtribValorDemanda(const Func_Name: String; Stack: TexeStack);
var r: Real;
    c: Char;
    s: String;
    Prioridade: Integer;
    PC: TprPCP;
begin
  Prioridade := Stack.AsInteger(2);
  If (Prioridade < 1) or (Prioridade > 3) then
     Prioridade := 1;

  s := Stack.AsString(3);
  if s <> '' then
     c := UpCase(s[1])
  else
     c := 'T';

  PC := TprPCP(Stack.AsObject(5));
  r  := Stack.AsFloat(4);

  Case Prioridade of
    1: case c of
         'A': PC.DemPriAtendida [Stack.AsInteger(1)] := r;
         'P': PC.DemPriPlanejada[Stack.AsInteger(1)] := r;
         'T': PC.DemPriTotal    [Stack.AsInteger(1)] := r;
         end;

    2: case c of
         'A': PC.DemSecAtendida [Stack.AsInteger(1)] := r;
         'P': PC.DemSecPlanejada[Stack.AsInteger(1)] := r;
         'T': PC.DemSecTotal    [Stack.AsInteger(1)] := r;
         end;

    3: case c of
         'A': PC.DemTerAtendida [Stack.AsInteger(1)] := r;
         'P': PC.DemTerPlanejada[Stack.AsInteger(1)] := r;
         'T': PC.DemTerTotal    [Stack.AsInteger(1)] := r;
         end;
    end;
end;

class procedure TpsPCP_Class.amObtemVolMax(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(1));
  Stack.PushFloat(PC.VolumeMaximo);
end;

class procedure TpsPCP_Class.amObtemVolMin(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(1));
  Stack.PushFloat(PC.VolumeMinimo);
end;

class procedure TpsPCP_Class.amObtemVolInicial(Const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(1));
  Stack.PushFloat(PC.VolumeInicial);
end;

class procedure TpsPCP_Class.amObtemEnergia(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(2));
  Stack.PushFloat(PC.Energia[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.am_Demandas(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(1));
  Stack.PushInteger(o.Demandas);
end;

class procedure TpsPCP_Class.am_Demanda(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(2));
  Stack.PushObject(o.Demanda[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.am_PC_aJusante(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(1));
  Stack.PushObject(o.PC_aJusante);
end;

class procedure TpsPCP_Class.am_PC_aMontante(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(2));
  Stack.PushObject(o.PC_aMontante[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.am_PCs_aMontante(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(1));
  Stack.PushInteger(o.PCs_aMontante);
end;

class procedure TpsPCP_Class.am_SubBacia(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(2));
  Stack.PushObject(o.SubBacia[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.am_SubBacias(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(1));
  Stack.PushInteger(o.SubBacias);
end;

class procedure TpsPCP_Class.am_TrechoDagua(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(1));
  Stack.PushObject(o.TrechoDagua);
end;
{
class procedure TpsPCP_Class.am_Coef_Transformacao(Const Func_Name: String; Stack: TexeStack);
var o: TprPCPR;
begin
  o := TprPCPR(Stack.AsObject(1));
  Stack.PushFloat(o.Coef_Transformacao);
end;
}

{
class procedure TpsPCP_Class.am_DemandaPorEnergia(Const Func_Name: String; Stack: TexeStack);
var o: TprPCPR;
begin
  o := TprPCPR(Stack.AsObject(1));
  Stack.PushBoolean(o.DemandaPorEnergia);
end;
}
class procedure TpsPCP_Class.am_Eh_PC_Montante(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(2));
  Stack.PushBoolean(o.Eh_umPC_aMontante(TprPCP(Stack.AsObject(1))));
end;
{
class procedure TpsPCP_Class.am_EnergiaFirme(Const Func_Name: String; Stack: TexeStack);
var o: TprPCPR;
begin
  o := TprPCPR(Stack.AsObject(1));
  Stack.PushFloat(o.EnergiaFirme);
end;
}
procedure TpsPCP_Class.AddMethods();
begin
  with Procs do
    begin
    Add('Ligado',
        'Indica quando o Reservatorio deverá fazer seu Balanço Hídrico ou se comportar como um simples PC.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "PC_Eh_Reservatorio".',
        '',
        [pvtBoolean],
        [nil       ],
        [False     ],
        pvtNull    ,
        TObject     ,
        amLigado);

    Add('AtribuiValorDemanda',
        'Atribui um valor a um tipo de Demanda de um PC.'#13 +
        'Parâmetros:'#13 +
        '   - DeltaT'#13 +
        '   - Tipo da Demanda (1-Primária, 2-Secundária, 3-Terciária)'#13 +
        '   - Categoria da Demanda ("P"-Planejada, "A"-Atendida, "T"-Totais)'#13 +
        '   - Valora a ser Atribuído',
        '',
        [pvtInteger , pvtInteger , pvtString , pvtReal],
        [nil        , nil        , nil       , nil    ],
        [False      , False      , False     , False  ],
        pvtNull     ,
        TObject     ,
        amAtribValorDemanda);

    Add('AtribuiVolume',
        'Atribui um volume a um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "PC_Eh_Reservatorio".'#13 +
        'Parâmetros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAtribVol);

    Add('AtribuiEnergia',
        'Atribui um valor de Energia a um Delta T de um PC'#13 +
        'Parâmetros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAtribEnergia);

     Add('AtribuiDefluvioPlanejado',
        'Atribui o Defluvio Planejado a um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "PC_Eh_Reservatorio".'#13 +
        'Parâmetros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAbribDefluPlanej);

    Add('AtribuiDefluencia',
        'Atribui o valor da defluência de um PC qualquer, inclusive Reservatório.'#13 +
        'Para saber se um PC é um Reservatório utilize o método "PC_Eh_Reservatorio".'#13 +
        'Parâmetros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAtribDefluencia);

    Add('Equacoes_MudarTipoVar',
        'Muda o tipo do identificador.'#13 +
        'Se Decisao, a variável aparecerá no lado esquerdo da equacao.'#13 +
        'Se Estado aparecerá no lado direito.'#13 +
        'Se Constante, aparecerá o valor atual da variável.'#13 +
        'Parâmetros:'#13 +
        '   Índice da Equação'#13 +
        '   Nome do Identificador'#13 +
        '   Tipo do Identificador: ("decisao", "estado" ou "constante")',
        '',
        [pvtInteger, pvtString, pvtString],
        [nil       , nil      , nil      ],
        [False     , False    , false    ],
        pvtNull    ,
        TObject     ,
        am_Equacoes_MudarTipoVar);

    Add('MudarCor',
        'Muda a cor do PC".'#13 +
        'Parâmetros: Cor (inteiro)',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtNull,
        TObject,
        am_MudarCor);
    end;

  with Functions do
    begin
    Add('Eh_Reservatorio',
        'Informa se o PC é um reservatório',
        '',
        [], [], [],
        pvtBoolean ,
        TObject    ,
        amPC_Eh_Res);

    Add('Hm3_m3',
        'Converte hectômetros cúbicos para métricos cúbicos'#13 +
        'Parâmetros: Valor (real), Intervalo (inteiro)',
        '',
        [pvtReal, pvtInteger],
        [nil    , nil       ],
        [false  , false     ],
        pvtReal  ,
        TObject  ,
        amHm3_m3);

    Add('m3_Hm3',
        'Converte metros cúbicos para hectômetros cúbicos'#13 +
        'Parâmetros: Valor (real), Intervalo (inteiro)',
        '',
        [pvtReal, pvtInteger],
        [nil    , nil       ],
        [false  , false     ],
        pvtReal  ,
        TObject  ,
        amm3_Hm3);

    Add('ObterHierarquia',
        'Retorna a Hierarquia do PC',
        '',
        [], [], [],
        pvtInteger,
        TObject   ,
        amObtemHierarquia);

    Add('ObterVazoesDeMontante',
        'Retorna o somatório das Vazões de Montante de um PC para o intervalo especificado no projeto.',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtReal,
        TObject   ,
        amObtemVazoesDeMontante);

    Add('CalculaArea',
        'Calcula a área de um Reservatório para um determinado volume.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"'#13 +
        'Parâmetro: Volume',
        '',
        [pvtReal ],
        [nil     ],
        [False   ],
        pvtReal   ,
        TObject   ,
        amCalculaAreaDoReservatorio);

    Add('CalculaCotaHidraulica',
        'Calcula a queda hidráulica de um Reservatório para um determinado volume.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"'#13 +
        'Parâmetro: Volume',
        '',
        [pvtReal ],
        [nil     ],
        [False   ],
        pvtReal   ,
        TObject   ,
        amCalculaCotaHidraulica);

    Add('ObterEvaporacaoUnitaria',
        'Obtém a Evaporação Unitária atual de um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"'#13 +
        'Parâmetro: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemEvaporacaoUnitaria);

    Add('ObterPrecipitacaoUnitaria',
        'Obtém a Precipitação Unitária atual de um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"'#13 +
        'Parâmetro: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemPrecipitacaoUnitaria);

    Add('ObterVolume',
        'Obtém o volume atual de um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"'#13 +
        'Parâmetro: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemVol);

    Add('VolumeMaximo',
        'Obtém o volume máximo de um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"',
        '',
        [], [], [],
        pvtReal   ,
        TObject   ,
        amObtemVolMax);

    Add('VolumeMinimo',
        'Obtém o volume mínimo de um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"',
        '',
        [], [], [],
        pvtReal   ,
        TObject   ,
        amObtemVolMin);

    Add('VolumeInicial',
        'Obtém o volume inicial de um Reservatório.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"',
        '',
        [], [], [],
        pvtReal   ,
        TObject   ,
        amObtemVolInicial);

    Add('ObterEnergia',
        'Obtém os valores do cálculo de energia de um Reservatório.'#13 +
        'Parâmetro: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemEnergia);

    Add('CotaJusante',
        '',
        '',
        [],
        [],
        [],
        pvtReal     ,
        TObject     ,
        amCalculaCotaJusante);

    Add('FatorDeRetorno',
        'Calcula os fatores de retorno.'#13 +
        'Parâmetro: Tipo da Demanda (1-Primária, 2-Secundária, 3-Terciária)',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemFatorRetorno);

    Add('NumDemandas',
        'Obtém o número de Demandas de um PC',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amNumDemandas);

    Add('ObterValorDemanda',
        'Obtém o valor atual de um tipo de Demanda de um PC.'#13 +
        'Parâmetros:'#13 +
        '   - DeltaT atual'#13 +
        '   - Tipo da Demanda (1-Primária, 2-Secundária, 3-Terciária)'#13 +
        '   - Categoria da Demanda ("P"-Planejada, "A"-Atendida, "T"-Totais)',
        '',
        [pvtInteger , pvtInteger , pvtString],
        [nil        , nil        , nil      ],
        [False      , False      , False    ],
        pvtReal     ,
        TObject     ,
        amObtemValorDemanda);

    Add('ObterVazaoAfluenteSBs',
        'Obtém a afluência de um intervalo das sub-bacias deste PC',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtReal,
        TObject,
        amAfluenciaSBs);

   Add('ObterDefluencia',
        'Obtém a defluência de um PC.'#13 +
        'Parâmetros: Intervalo desejado',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amDefluencia);

    Add('ObterDefluvioPlanejado',
        'Obtém o Defluvio Planejado de um Reservatorio.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"' +
        'Parâmetros: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemDefluPlanejado);

    Add('ObterDefluvioOperado',
        'Obtém o Defluvio Operado de um Reservatorio.'#13 +
        'Para saber se um PC é um Reservatório, utilize o método "Eh_Reservatorio"' +
        'Parâmetros: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemDefluOperado);

    Add('ObterFalhas',
        'Obtém um objecto que encapsula todas as falhas de um PC.',
        '',
        [], [], [],
        pvtObject,
        TprListaDeFalhas,
        amObtemFalhas);

    Add('Demandas',
        'Retorna o número de Demandas conectadas a este PC',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_Demandas);

    Add('Demanda',
        'Retorna a i-égima Demanda conectada a este PC',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprDemanda,
        am_Demanda);

    Add('PC_aJusante',
        'Retorna o PC a Jusante',
        '',
        [],
        [],
        [],
        pvtObject,
        TprPCP,
        am_PC_aJusante);

    Add('PC_aMontante',
        'Retorna o i-égimo PC a montante',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprPCP,
        am_PC_aMontante);

    Add('PCs_aMontante',
        'Retorna o número de PCs que estao a montante deste',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_PCs_aMontante);

    Add('SubBacia',
        'Retorna a i-égima SuBacia conectada a este PC',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprSubBacia,
        am_SubBacia);

    Add('SubBacias',
        'Retorna o número de SubBacias conectadas a este PC',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_SubBacias);

    Add('TrechoDagua',
        'Retorna o trechoDagua pertencente a este PC',
        '',
        [],
        [],
        [],
        pvtObject,
        TprTrechoDagua,
        am_TrechoDagua);
{
    Add('Coef_Transformacao',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_Coef_Transformacao);

    Add('CRC',
        '',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_CRC);

    Add('DemandaPorEnergia',
        '',
        '',
        [],
        [],
        [],
        pvtBoolean,
        TObject,
        am_DemandaPorEnergia);
}
    Add('Eh_PC_Montante',
        '',
        '',
        [pvtObject],
        [TprPCP],
        [True],
        pvtBoolean,
        TObject,
        am_Eh_PC_Montante);
{
    Add('EnergiaFirme',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_EnergiaFirme);
}

    Add('RendimentoAducao',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amObtemRSA);

    Add('RendimentoTurbina',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amObtemRT);

    Add('RendimentoGeradores',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amObtemRG);

    Add('VazaoMaxTurbina',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amObtemQMaxTurb);

    Add('QuedaFixa',
        'Válido somente para PCs',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amObtemQuedaFixa);

    Add('DemandaEnergetica',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amObtemDemEnergetica);

    Add('CurvaDemandaEnergetica',
        'Retorna o valor da Curva de Demanda Energética de índice i',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtReal,
        TObject,
        amObtemCurvaDemEnergetica);

    Add('ObterCor',
        'Retorna a cor do PC".',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        am_ObterCor);
    end;
end;

class procedure TpsPCP_Class.amObtemFatorRetorno(const Func_Name: String; Stack: TexeStack);
var x: TEnumPriorDemanda;
begin
  x := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  Stack.PushFloat(
    TprPCP(Stack.AsObject(2)).CalculaFatorRetorno(x)
    );
end;

class procedure TpsPCP_Class.amObtemHierarquia(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(
    TprPCP(Stack.AsObject(1)).Hierarquia
    );
end;

class procedure TpsPCP_Class.amCalculaAreaDoReservatorio(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(2));
  Stack.PushFloat(PC.CalculaAreaDoReservatorio(Stack.AsFloat(1)));
end;

class procedure TpsPCP_Class.amCalculaCotaHidraulica(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(2));
  Stack.PushFloat(PC.CalculaCotaHidraulica(Stack.AsFloat(1)));
end;

class procedure TpsPCP_Class.amObtemEvaporacaoUnitaria(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(2));
  Stack.PushFloat(PC.EvaporacaoUnitaria[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.amObtemPrecipitacaoUnitaria(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(2));
  Stack.PushFloat(PC.PrecipitacaoUnitaria[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.amObtemVazoesDeMontante(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP( Stack.getSelf() );
  Stack.PushFloat( PC.ObterVazoesDeMontante(Stack.AsInteger(1)) );
end;

class procedure TpsPCP_Class.amHm3_m3(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.getSelf());
  Stack.PushFloat(PC.Hm3_m3(Stack.AsFloat(1), Stack.AsInteger(2)));
end;

class procedure TpsPCP_Class.amM3_Hm3(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.getSelf());
  Stack.PushFloat(PC.m3_Hm3(Stack.AsFloat(1), Stack.AsInteger(2)));
end;

class procedure TpsPCP_Class.amObtemFalhas(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushObject(PC.ObtemFalhas);
end;

class procedure TpsPCP_Class.amAtribEnergia(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(3));
  PC.Energia[Stack.AsInteger(1)] := Stack.AsFloat(2);
end;

class procedure TpsPCP_Class.amObtemCurvaDemEnergetica(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(2));
  Stack.PushFloat(PC.CurvaDemEnergetica[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.amObtemDemEnergetica(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.DemEnergetica);
end;

class procedure TpsPCP_Class.amObtemQMaxTurb(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.QMaxTurb);
end;

class procedure TpsPCP_Class.amObtemQuedaFixa(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.QuedaFixa);
end;

class procedure TpsPCP_Class.amObtemRG(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.RendiGera);
end;

class procedure TpsPCP_Class.amObtemRSA(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.RendiAduc);
end;

class procedure TpsPCP_Class.amObtemRT(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.RendiTurb);
end;

class procedure TpsPCP_Class.amObtemDefluOperado(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(2));
  Stack.PushFloat(PC.DefluvioOperado[Stack.AsInteger(1)]);
end;

class procedure TpsPCP_Class.amCalculaCotaJusante(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR(Stack.AsObject(1));
  Stack.PushFloat(PC.CotaJusante);
end;

class procedure TpsPCP_Class.am_Equacoes_MudarTipoVar(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
    ind: Integer;
    nome, s: string;
    tipo: TIdentType;
begin
  PC := TprPCP( Stack.getSelf() );

  ind  := Stack.AsInteger(1);
  nome := Stack.AsString(2);
  s    := Stack.AsString(3);

  tipo := itState;
  if CompareText(s, 'decisao')   = 0 then tipo := itDecision else
  if CompareText(s, 'constante') = 0 then tipo := itConst;

  PC.Equacoes_MudarTipoVar(ind, nome, tipo);
end;

class procedure TpsPCP_Class.am_MudarCor(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP( Stack.getSelf() );
  PC.Imagem.Color := Stack.AsInteger(1);
end;

class procedure TpsPCP_Class.am_ObterCor(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP( Stack.getSelf() );
  Stack.PushInteger(PC.Imagem.Color);
end;

class procedure TpsPCP_Class.amLigado(const Func_Name: String; Stack: TexeStack);
var PC: TprPCPR;
begin
  PC := TprPCPR( Stack.getSelf() );
  PC.Ligado := Stack.AsBoolean(1);
end;

{ TpsFalha_Class }

class procedure TpsFalha_Class.amAno(Const Func_Name: String; Stack: TexeStack);
var o: TprFalha;
begin
  o := TprFalha(Stack.AsObject(1)); // self
  Stack.PushInteger(o.Ano);
end;

class procedure TpsFalha_Class.amsAno(Const Func_Name: String; Stack: TexeStack);
var o: TprFalha;
begin
  o := TprFalha(Stack.AsObject(1)); // self
  Stack.PushString(o.sAno);
end;

class procedure TpsFalha_Class.amEh_FalhaCritica(Const Func_Name: String; Stack: TexeStack);
var o: TprFalha;
begin
  o := TprFalha(Stack.AsObject(1)); // self
  Stack.PushBoolean(o.FalhaCritica);
end;

class procedure TpsFalha_Class.amIntervalos(Const Func_Name: String; Stack: TexeStack);
var o: TprFalha;
begin
  o := TprFalha(Stack.AsObject(1)); // self
  Stack.PushObject(o.Intervalos);
end;

class procedure TpsFalha_Class.amIntervalosCriticos(Const Func_Name: String; Stack: TexeStack);
var o: TprFalha;
begin
  o := TprFalha(Stack.AsObject(1)); // self
  Stack.PushObject(o.IntervalosCriticos);
end;

class procedure TpsFalha_Class.amDemsRef(Const Func_Name: String; Stack: TexeStack);
var o: TprFalha;
begin
  o := TprFalha(Stack.AsObject(1)); // self
  Stack.PushObject(o.DemsRef);
end;

class procedure TpsFalha_Class.amDemsAten(Const Func_Name: String; Stack: TexeStack);
var o: TprFalha;
begin
  o := TprFalha(Stack.AsObject(1)); // self
  Stack.PushObject(o.DemsAten);
end;

procedure TpsFalha_Class.AddMethods;
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('Ano',
        '',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        amAno);

    Add('sAno',
        '',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        amsAno);

    Add('Eh_FalhaCritica',
        '',
        '',
        [],
        [],
        [],
        pvtBoolean,
        TObject,
        amEh_FalhaCritica);

    Add('Intervalos',
        '',
        '',
        [],
        [],
        [],
        pvtObject,
        TIntegerList,
        amIntervalos);

    Add('IntervalosCriticos',
        '',
        '',
        [],
        [],
        [],
        pvtObject,
        TBooleanList,
        amIntervalosCriticos);

    Add('DemsRef',
        '',
        '',
        [],
        [],
        [],
        pvtObject,
        TDoubleList,
        amDemsRef);

    Add('DemsAten',
        '',
        '',
        [],
        [],
        [],
        pvtObject,
        TDoubleList,
        amDemsAten);
    end;
end;

{ Tps_ListaDeFalhas }

class procedure Tps_ListaDeFalhas.amMostrarFalhas(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
begin
  o := TprListaDeFalhas(Stack.AsObject(1)); // self
  o.MostrarFalhas;
end;

class procedure Tps_ListaDeFalhas.amAnosCriticos(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TprListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushInteger(o.AnosCriticos(p));
end;

class procedure Tps_ListaDeFalhas.amIntervalosCriticos(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TprListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushInteger(o.IntervalosCriticos(p));
end;

class procedure Tps_ListaDeFalhas.amFalhaPeloAno(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TprListaDeFalhas(Stack.AsObject(3)); // self
  Stack.PushObject(o.FalhaPeloAno(p, Stack.AsString(2)));
end;

class procedure Tps_ListaDeFalhas.amIntervalosTotais(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TprListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushInteger(o.IntervalosTotais(p));
end;

class procedure Tps_ListaDeFalhas.amObtemFalhaPrimaria(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
begin
  o := TprListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushObject(o.FalhaPrimaria[Stack.AsInteger(1)]);
end;

class procedure Tps_ListaDeFalhas.amObtemFalhaSecundaria(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
begin
  o := TprListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushObject(o.FalhaSecundaria[Stack.AsInteger(1)]);
end;

class procedure Tps_ListaDeFalhas.amObtemFalhaTerciaria(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
begin
  o := TprListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushObject(o.FalhaTerciaria[Stack.AsInteger(1)]);
end;

class procedure Tps_ListaDeFalhas.amNumFalhasPrimarias(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
begin
  o := TprListaDeFalhas(Stack.AsObject(1)); // self
  Stack.PushInteger(o.FalhasPrimarias);
end;

class procedure Tps_ListaDeFalhas.amNumFalhasSecundarias(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
begin
  o := TprListaDeFalhas(Stack.AsObject(1)); // self
  Stack.PushInteger(o.FalhasSecundarias);
end;

class procedure Tps_ListaDeFalhas.amNumFalhasTerciarias(Const Func_Name: String; Stack: TexeStack);
var o: TprListaDeFalhas;
begin
  o := TprListaDeFalhas(Stack.AsObject(1)); // self
  Stack.PushInteger(o.FalhasTerciarias);
end;

procedure Tps_ListaDeFalhas.AddMethods;
begin
  with Procs do
    begin
    Add('MostrarFalhas',
        '',
        '',
        [],
        [],
        [],
        pvtNull,
        TObject,
        amMostrarFalhas);
    end;

  with Functions do
    begin
    Add('FalhaPeloAno',
        'Parâmetros:'#13 +
        '  - Tipo: (inteiro) - 1, 2 ou 3'#13 +
        '  - Ano: (inteiro)',
        '',
        [pvtInteger, pvtInteger],
        [nil, nil],
        [False, False],
        pvtObject,
        TprFalha,
        amFalhaPeloAno);

    Add('IntervalosTotais',
        'Parâmetro: Tipo da Prioridade: 1, 2 ou 3'#13 +
        'Retorna o número total de anos',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtInteger,
        TObject,
        amIntervalosTotais);

    Add('AnosCriticos',
        'Parâmetro: Tipo da Prioridade: 1, 2 ou 3'#13 +
        'Retorna o número total de anos onde houveram falhas críticas',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtInteger,
        TObject,
        amAnosCriticos);

    Add('IntervalosCriticos',
        'Parâmetro: Tipo da Prioridade: 1, 2 ou 3'#13 +
        'Retorna o número de intervalos críticos de todos os anos.',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtInteger,
        TObject,
        amIntervalosCriticos);

    Add('ObterFalhaPrimaria',
        '',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprFalha,
        amObtemFalhaPrimaria);

    Add('ObterFalhaSecundaria',
        '',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprFalha,
        amObtemFalhaSecundaria);

    Add('ObterFalhaTerciaria',
        '',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprFalha,
        amObtemFalhaTerciaria);

    Add('NumFalhasPrimarias',
        '',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        amNumFalhasPrimarias);

    Add('NumFalhasSecundarias',
        '',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        amNumFalhasSecundarias);

    Add('NumFalhasTerciarias',
        '',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        amNumFalhasTerciarias);
    end;
end;

{ Tps_prClasseDemanda }

class procedure Tps_prClasseDemanda.am_EscalaDeDesenvolvimento(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushFloat(o.EscalaDeDesenvolvimento);
end;

class procedure Tps_prClasseDemanda.am_FatorDeConversao(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushFloat(o.FatorDeConversao);
end;

class procedure Tps_prClasseDemanda.am_FatorDeImplantacao(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushFloat(o.FatorDeImplantacao);
end;

class procedure Tps_prClasseDemanda.am_FatorDeRetorno(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushFloat(o.FatorDeRetorno);
end;

class procedure Tps_prClasseDemanda.am_Ligada(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushBoolean(o.Ligada);
end;

class procedure Tps_prClasseDemanda.am_NomeUnidadeConsumoAgua(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushString(o.NomeUnidadeConsumoDagua);
end;

class procedure Tps_prClasseDemanda.am_NomeUnidadeDeDemanda(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushString(o.NomeUnidadeDeDemanda);
end;

class procedure Tps_prClasseDemanda.am_Prioridade(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushInteger(ord(o.Prioridade) + 1);
end;

class procedure Tps_prClasseDemanda.am_UnidadeDeConsumo(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushFloat(o.UnidadeDeConsumo);
end;

class procedure Tps_prClasseDemanda.am_UnidadeDeDemanda(Const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.AsObject(1));
  Stack.PushFloat(o.UnidadeDeDemanda);
end;

procedure Tps_prClasseDemanda.AddMethods;
begin
  with Procs do
    begin
    Add('Eh_VarDecisao',
        'Estabelece o tipo de variável para o gerador de equações'#13 +
        '  - Por falta, todas são variáveis de estado.'#13 +
        '  - Um valor "true" representará uma variável de decisão e'#13 +
        '    um valor "false" representará uma variável de estado.'#13 +
        '  - Se utilizado em uma classe de demanda, fará com que todas'#13 +
        '    as demandas pertencentes a classe sejam setadas para o mesmo valor.',
        '',
        [pvtBoolean],
        [nil],
        [False],
        pvtNull,
        TObject,
        am_Eh_VarDecisao);

    Add('TVU_NumIntervalos',
        'Estabelece o número de intervalos da Tabela de Valores Unitários',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtNull,
        TObject,
        am_TVU_NumIntervalos);

    Add('TVU_AnoIniFimIntervalo',
        'Estabelece o ano inicial e o final para um intervalo'#13 +
        'Parâmetros:'#13 +
        '  - Índice do Intervalo'#13 +
        '  - Ano Inicial'#13 +
        '  - Ano Final',
        '',
        [pvtInteger, pvtInteger, pvtInteger],
        [nil, nil, nil],
        [False, False, False],
        pvtNull,
        TObject,
        am_TVU_AnoIniFimIntervalo);

    Add('TVU_Demanda',
        'Estabelece o valor da demanda para um determinado mês'#13 +
        'Parâmetros:'#13 +
        '  - Índice do Intervalo'#13 +
        '  - Mês'#13 +
        '  - Valor da Demanda',
        '',
        [pvtInteger, pvtInteger, pvtReal],
        [nil, nil, nil],
        [False, False, False],
        pvtNull,
        TObject,
        am_TVU_Demanda);

    Add('TVU_ObterAnoIniFimIntervalo',
        'Retorna o ano inicial e o final para um intervalo'#13 +
        'Parâmetros:'#13 +
        '  - (Entrada) Índice do Intervalo'#13 +
        '  - (Saida) Ano Inicial'#13 +
        '  - (Saida) Ano Final',
        '',
        [pvtInteger, pvtInteger, pvtInteger],
        [nil, nil, nil],
        [False, True, True],
        pvtNull,
        TObject,
        am_TVU_ObterAnoIniFimIntervalo);

    Add('TVU_ObterDemanda',
        'Obtém o valor da demanda para um determinado intervalo e mês'#13 +
        'Parâmetros:'#13 +
        '  - Índice do Intervalo'#13 +
        '  - Mês',
        '',
        [pvtInteger, pvtInteger],
        [nil, nil],
        [False, False],
        pvtNull,
        TObject,
        am_TVU_ObterDemanda);
    end;

  with Functions do
    begin
    Add('TVU_ObterNumIntervalos',
        'Obtém o número de intervalos da Tabela de Valores Unitários',
        '',
        [],
        [nil],
        [False],
        pvtInteger,
        TObject,
        am_TVU_ObterNumIntervalos);

    Add('FatorDeImplantacao',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_FatorDeImplantacao);

    Add('FatorDeRetorno',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_FatorDeRetorno);

    Add('Ligada',
        '',
        '',
        [],
        [],
        [],
        pvtBoolean,
        TObject,
        am_Ligada);

    Add('NomeUnidadeConsumoAgua',
        '',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_NomeUnidadeConsumoAgua);

    Add('NomeUnidadeDeDemanda',
        '',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_NomeUnidadeDeDemanda);

    Add('Prioridade',
        'Retorna a Prioridade: '#13 +
        '   1 = Primária'#13 +
        '   2 = Secundária'#13 +
        '   3 = Terciária',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_Prioridade);

    Add('UnidadeDeConsumo',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_UnidadeDeConsumo);

    Add('UnidadeDeDemanda',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_UnidadeDeDemanda);

    end;
end;

class procedure Tps_prClasseDemanda.am_TVU_NumIntervalos(const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.getSelf);
  o.TVU_NumIntervalos(Stack.AsInteger(1));
end;

class procedure Tps_prClasseDemanda.am_TVU_AnoIniFimIntervalo(const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.getSelf);
  o.TVU_AnoInicialFinalIntervalo(Stack.AsInteger(1), Stack.AsInteger(2), Stack.AsInteger(3));
end;

class procedure Tps_prClasseDemanda.am_TVU_Demanda(const Func_Name: String;Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.getSelf);
  o.TVU_Demanda(Stack.AsInteger(1), Stack.AsInteger(2), Stack.AsFloat(3));
end;

class procedure Tps_prClasseDemanda.am_TVU_ObterAnoIniFimIntervalo(const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
    ai, af: integer;
begin
  o := TprClasseDemanda(Stack.getSelf);
  o.TVU_ObterAnoInicialFinalIntervalo(Stack.AsInteger(1), ai, af);
  Stack.AsReferency(2).Value := ai;
  Stack.AsReferency(3).Value := af;
end;

class procedure Tps_prClasseDemanda.am_TVU_ObterDemanda(const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.getSelf);
  Stack.PushFloat(o.TVU_ObterDemanda(Stack.AsInteger(1), Stack.AsInteger(2)));
end;

class procedure Tps_prClasseDemanda.am_TVU_ObterNumIntervalos(const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.getSelf);
  Stack.PushInteger(o.TVU_ObterNumIntervalos());
end;

class procedure Tps_prClasseDemanda.am_Eh_VarDecisao(const Func_Name: String; Stack: TexeStack);
var o: TprClasseDemanda;
begin
  o := TprClasseDemanda(Stack.getSelf);
  o.EQ_Eh_VarDecisao := Stack.AsBoolean(1);
end;

{ Tps_prDemanda }

class procedure Tps_prDemanda.am_Classe(Const Func_Name: String; Stack: TexeStack);
var o: TprDemanda;
begin
  o := TprDemanda(Stack.AsObject(1));
  Stack.PushString(o.Classe);
end;

class procedure Tps_prDemanda.am_Habilitada(Const Func_Name: String; Stack: TexeStack);
var o: TprDemanda;
begin
  o := TprDemanda(Stack.AsObject(1));
  Stack.PushBoolean(o.Habilitada);
end;

class procedure Tps_prDemanda.am_Tipo(Const Func_Name: String; Stack: TexeStack);
var o: TprDemanda;
begin
  o := TprDemanda(Stack.AsObject(1));
  Stack.PushInteger(ord(o.Tipo) + 1);
end;

procedure Tps_prDemanda.AddMethods;
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('Classe',
        'Nome da classe da demanda',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_Classe);

    Add('Habilitada',
        'Informa se a demanda está ativa ou não. Se ativa a demanda é considerada na totalização'#13 +
        'das demandas do PC ou SubBacia.',
        '',
        [],
        [],
        [],
        pvtBoolean,
        TObject,
        am_Habilitada);

    Add('Tipo',
        '1 = Difusa'#13 +
        '2 = Localizada',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_Tipo);

    Add('Cenarios',
        'Retorna o numero de cenarios de uma demanda',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_Cenarios);

    Add('Cenario',
        'Retorna o i-egimo cenario de uma demanda iniciando em 0',
        '',
        [pvtInteger],
        [nil],
        [false],
        pvtObject,
        TprCenarioDeDemanda,
        am_ObterCenario);

    Add('DemandaTotal',
        'Retorna a demanda total dado um mes e um ano',
        '',
        [pvtInteger, pvtInteger],
        [nil, nil],
        [false, false],
        pvtReal,
        TObject,
        am_DemandaTotal);
    end;
end;

class procedure Tps_prDemanda.am_Cenarios(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprDemanda(Stack.getSelf).NumCenarios);
end;

class procedure Tps_prDemanda.am_ObterCenario(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(TprDemanda(Stack.getSelf).Cenario[Stack.AsInteger(1)]);
end;

class procedure Tps_prDemanda.am_DemandaTotal(const Func_Name: String; Stack: TexeStack);
var o: TprDemanda;
    d: TRec_prData;
begin
  o := TprDemanda(Stack.getSelf);
  d.Mes := Stack.asInteger(1);
  d.Ano := Stack.asInteger(2);
  o.Data := d;
  Stack.PushFloat(o.Demanda);
end;

{ Tps_TrechoDagua }

class procedure Tps_TrechoDagua.am_PC_Jusante(Const Func_Name: String; Stack: TexeStack);
var o: TprTrechoDagua;
begin
  o := TprTrechoDagua(Stack.AsObject(1));
  Stack.PushObject(o.PC_aJusante);
end;

class procedure Tps_TrechoDagua.am_PC_Montante(Const Func_Name: String; Stack: TexeStack);
var o: TprTrechoDagua;
begin
  o := TprTrechoDagua(Stack.AsObject(1));
  Stack.PushObject(o.PC_aMontante);
end;

class procedure Tps_TrechoDagua.am_VazaoMaxima(Const Func_Name: String; Stack: TexeStack);
var o: TprTrechoDagua;
begin
  o := TprTrechoDagua(Stack.AsObject(1));
  Stack.PushFloat(o.VazaoMaxima);
end;

class procedure Tps_TrechoDagua.am_VazaoMinima(Const Func_Name: String; Stack: TexeStack);
var o: TprTrechoDagua;
begin
  o := TprTrechoDagua(Stack.AsObject(1));
  Stack.PushFloat(o.VazaoMinima);
end;

procedure Tps_TrechoDagua.AddMethods;
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('PC_Jusante',
        '',
        '',
        [],
        [],
        [],
        pvtObject,
        TprPCP,
        am_PC_Jusante);

    Add('PC_Montante',
        '',
        '',
        [],
        [],
        [],
        pvtObject,
        TprPCP,
        am_PC_Montante);

    Add('VazaoMaxima',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_VazaoMaxima);

    Add('VazaoMinima',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_VazaoMinima);
    end;
end;

{ Tps_CenarioDeDemanda }

class procedure Tps_Cenario.am_ObterValorFloat(Const Func_Name: String; Stack: TexeStack);
var o: TprCenarioDeDemanda;
begin
  o := TprCenarioDeDemanda(Stack.getSelf);
  Stack.PushFloat(o.ObterValorFloat(Stack.AsString(1)))
end;

class procedure Tps_Cenario.am_ObterValorString(Const Func_Name: String; Stack: TexeStack);
var o: TprCenarioDeDemanda;
begin
  o := TprCenarioDeDemanda(Stack.getSelf);
  Stack.PushString(o.ObterValorString(Stack.AsString(1)))
end;

procedure Tps_Cenario.AddMethods;
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('ObterValorFloat',
        'Utilize este método para obter uma propriedade do tipo Real (ponto flutuante).'#13 +
        '  Ex: x := Cenario_1.ObterValorFloat("Resultado_1.1990.ProdutividadeTotal")',
        '',
        [pvtString],
        [nil],
        [False],
        pvtReal,
        TObject,
        am_ObterValorFloat);

    Add('ObterValorString',
        'Utilize este método para obter uma propriedade do tipo String (ponto flutuante).'#13 +
        '  Ex: s := Cenario_1.ObterValorFloat("Resultado_1.Comentario")',
        '',
        [pvtString],
        [nil],
        [False],
        pvtString,
        TObject,
        am_ObterValorString);

    end;
end;

{ TpsProjetoSC_Class }

procedure TpsProjetoSC_Class.AddMethods;
begin
  // Nada
end;

{ TpsProjetoZP_Class }

procedure TpsProjetoZP_Class.AddMethods;
begin
  // Nada
end;

end.

