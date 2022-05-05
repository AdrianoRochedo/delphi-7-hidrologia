unit pr_psLib;

interface
uses psBASE;

  procedure API(Lib: TLib);

implementation
uses Classes, sysutils, Dialogs, pr_Classes, pr_Const, pr_Tipos,
     Rosenbrock_Class, Lists;

type
  TPropagar_Functions = class(TFunctionServices)
  public
    class procedure AddFunctionsIn (Functions: TFunctionList); override;
    class procedure amCreateRosenPar (Const Func_Name: String; Stack: TexeStack);
    class procedure am_IntervaloParaStrData (Const Func_Name: String; Stack: TexeStack);
  end;

  TPropagar_Procs = class(TFunctionServices)
  public
    class procedure AddProcsIn (Procs: TProcList); override;
  end;

  TpsProjeto_Class = Class(TpsClass)
  public
    procedure AddMethods; override;
    class procedure amNome                      (Const Func_Name: String; Stack: TexeStack);
    class procedure amTotal_IS                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDeltaT               (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribuiDeltaT             (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemData                 (Const Func_Name: String; Stack: TexeStack);
    class procedure amNumPCs                    (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPC                   (Const Func_Name: String; Stack: TexeStack);
    //class procedure amObtemSubBaciaPeloNome     (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemTrechoPeloNome       (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDemandaPeloNome      (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPCPeloNome           (Const Func_Name: String; Stack: TexeStack);
    class procedure amPCsEntreDois              (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemRosenbrock           (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Executar                 (Const Func_Name: String; Stack: TexeStack);
    class procedure am_IndiceDoPC               (Const Func_Name: String; Stack: TexeStack);
    class procedure am_IntervaloDeSimulacao     (Const Func_Name: String; Stack: TexeStack);
    class procedure am_DiasNoIntervalo          (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NivelDeFalha             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NumAnosDeExecucao        (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TerminarSimulacao        (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TotalAnual_IntSim        (Const Func_Name: String; Stack: TexeStack);
    class procedure am_ValorFO                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_RealizaBalancoHidricoAte (Const Func_Name: String; Stack: TexeStack);
  end;

  TpsPCP_Class = Class(TpsClass)
  public
    procedure AddMethods; override;
    class procedure amNumDemandas               (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemValorDemanda         (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemNome                 (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemHierarquia           (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemFatorRetorno         (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVazoesDeMontante     (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemFalhas               (Const Func_Name: String; Stack: TexeStack);
    class procedure amAfluenciaSBs              (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribValorDemanda         (Const Func_Name: String; Stack: TexeStack);
    class procedure amPC_eh_Res                 (Const Func_Name: String; Stack: TexeStack);
    class procedure amDefluencia                (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribDefluencia           (Const Func_Name: String; Stack: TexeStack);
    class procedure amHm3_m3_Intervalo          (Const Func_Name: String; Stack: TexeStack);
    class procedure amm3_Hm3_Intervalo          (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Demandas                 (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Demanda                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_aJusante              (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_aMontante             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PCs_aMontante            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_SubBacia                 (Const Func_Name: String; Stack: TexeStack);
    class procedure am_SubBacias                (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TrechoDagua              (Const Func_Name: String; Stack: TexeStack);
    //class procedure am_CRC                      (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Eh_PC_Montante           (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemEnergia              (Const Func_Name: String; Stack: TexeStack);

    class procedure amAtribEnergia              (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemRSA                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemRT                   (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemRG                   (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemQMaxTurb             (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemQuedaFixa            (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDemEnergetica        (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemCurvaDemEnergetica   (Const Func_Name: String; Stack: TexeStack);

    // Somente se o PC � um reservat�rio
    class procedure amObtemVol                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVolMax               (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVolMin               (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemVolInicial           (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDefluPlanejado       (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemDefluOperado         (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemEvaporacaoUnitaria   (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPrecipitacaoUnitaria (Const Func_Name: String; Stack: TexeStack);
    class procedure amAtribVol                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amAbribDefluPlanej          (Const Func_Name: String; Stack: TexeStack);
    class procedure amCalculaCotaHidraulica     (Const Func_Name: String; Stack: TexeStack);
    class procedure amCalculaCotaJusante        (Const Func_Name: String; Stack: TexeStack);
    class procedure amCalculaAreaDoReservatorio (Const Func_Name: String; Stack: TexeStack);
//    class procedure am_EnergiaFirme             (Const Func_Name: String; Stack: TexeStack);
//    class procedure am_Coef_Transformacao       (Const Func_Name: String; Stack: TexeStack);
//    class procedure am_DemandaPorEnergia        (Const Func_Name: String; Stack: TexeStack);
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
    class procedure am_EscalaDeDesenvolvimento (Const Func_Name: String; Stack: TexeStack);
    class procedure am_FatorDeConversao        (Const Func_Name: String; Stack: TexeStack);
    class procedure am_FatorDeImplantacao      (Const Func_Name: String; Stack: TexeStack);
    class procedure am_FatorDeRetorno          (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Ligada                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NomeUnidadeConsumoAgua  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_NomeUnidadeDeDemanda    (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Prioridade              (Const Func_Name: String; Stack: TexeStack);
    class procedure am_UnidadeDeConsumo        (Const Func_Name: String; Stack: TexeStack);
    class procedure am_UnidadeDeDemanda        (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_NumIntervalos       (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_AnoIniFimIntervalo  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TVU_Demanda             (Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_prDemanda = class(Tps_prClasseDemanda)
    procedure AddMethods; override;
    class procedure am_Classe      (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Habilitada  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Tipo        (Const Func_Name: String; Stack: TexeStack);
  end;

  Tps_TrechoDagua = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_PC_Jusante  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_Montante (Const Func_Name: String; Stack: TexeStack);
    class procedure am_VazaoMaxima (Const Func_Name: String; Stack: TexeStack);
    class procedure am_VazaoMinima (Const Func_Name: String; Stack: TexeStack);
  end;

{ ------------------- Ponto de Entrada ------------------ }

procedure API(Lib: TLib);
begin
  TPropagar_Functions.AddFunctionsIn(Lib.Functions);
  TPropagar_Procs.AddProcsIn(Lib.Procs);

  TpsProjeto_Class.Create(
      TprProjeto_Rosen,
      nil,
      'Encapsula um projeto do Propagar',
      '',
      [], [], [],
      False,
      Lib.Classes);

  TpsPCP_Class.Create(
     TprPCP,
     nil,
     'Encapsula um PC do Propagar',
     '',
     [], [], [],
     False,
     Lib.Classes);

    Tps_prClasseDemanda.Create(TprClasseDemanda,
                               nil,
                               '',
                               '',
                               [], [], [],
                               False,
                               Lib.Classes);

    Tps_prDemanda.Create(TprDemanda,
                         TprClasseDemanda,
                         '',
                         '',
                         [], [], [],
                         False,
                         Lib.Classes);

    Tps_TrechoDagua.Create(TprTrechoDagua,
                           nil,
                           '',
                           '',
                           [], [], [],
                           False,
                           Lib.Classes);

  TpsFalha_Class.Create(TprFalha,
     nil,
     'Encapsula as informa��es das falhas de um ano',
     '',
     [], [], [],
     false,
     Lib.Classes);

  Tps_ListaDeFalhas.Create(TListaDeFalhas,
     nil,
     'Armazena todas as falhas de suprimento de �gua de um PC.'#13 +
     'As falhas est�o divididas em 3 n�veis: Falhas prim�rias, secund�rias e terci�rias.'#13 +
     'Cada n�vel armazena os intervalos onde ocorreram as falhas em um ano e tamb�m se nesse'#13 +
     'intervalo a falha foi cr�tica ou n�o.'#13 +
     '   Ex: Falha prim�ria: 3 anos -->'#13 +
     '       1978: (intervalo/critica) --> (34/n�o), (534/sim), (678/n�o)'#13 +
     '       1981: (intervalo/critica) --> (23/n�o), (345/n�o), (456/n�o)'#13 +
     '       1982: (intervalo/critica) --> (249/n�o)',
     '',
     [], [], [],
     false,
     Lib.Classes);
end;

{ ------------------- Ponto de Entrada ------------------ }

{ TPropagar_Functions }

class procedure TPropagar_Functions.AddFunctionsIn(Functions: TFunctionList);
begin
  with Functions do
    begin
    Add('CreateRosenParameter',
        'Cria um par�metro para o Mecanismo de Otimiza��o "Rosenbrock"'#13 +
        'Par�metros:'#13 +
        '  - Nome'#13 +
        '  - Valor Inicial'#13 +
        '  - Limite Inferior'#13 +
        '  - Limite Superior'#13 +
        '  - Incremento'#13 +
        '  - Toler�ncia',
        '',
        [pvtString, pvtReal, pvtReal, pvtReal, pvtReal, pvtReal],
        [nil      , nil    , nil    , nil    , nil    , nil    ],
        [false    , false  , false  , false  , false  , false  ],
        pvtObject,
        TrbParameter,
        amCreateRosenPar);

    Add('IntervaloParaStrData',
        'Converte um intervalo (Delta T) para uma data no formato (mes/ano)',
        '',
        [pvtObject,  pvtInteger],
        [TprProjeto, nil],
        [True,       False],
        pvtString,
        TObject,
        am_IntervaloParaStrData);
    end;
end;

class procedure TPropagar_Functions.amCreateRosenPar(const Func_Name: String; Stack: TexeStack);
begin
{
  Stack.PushObject(
    TrbParameter.Create(
      Stack.AsString(1), Stack.AsFloat(2), Stack.AsFloat(3),
      Stack.AsFloat (4), Stack.AsFloat(5), Stack.AsFloat(6)
      )
    );
}    
end;

class procedure TPropagar_Functions.am_IntervaloParaStrData(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  Stack.PushString(IntervaloToStrData(o, Stack.AsInteger(2)));
end;

{ TPropagar_Procs }

class procedure TPropagar_Procs.AddProcsIn(Procs: TProcList);
begin
  with Procs do
    begin
    end;
end;

{ TpsProjeto_Class }


procedure TpsProjeto_Class.AddMethods;
begin
  with Procs do
    begin
    Add('AtribuiDeltaT',
        'Atribui um DeltaT a um projeto',
        '',
        [pvtInteger], [nil], [False],
        pvtNull,
        TObject,
        amAtribuiDeltaT);

    Add('DeltaT_ComoData',
        'Obt�m o DeltaT como Mes/Ano'#13 +
        'Par�metros: DeltaT, Mes (out), Ano (out)',
        '',
        [pvtInteger, pvtInteger, pvtInteger],
        [nil       , nil       , nil       ],
        [false     , true      , true      ],
        pvtNull,
        TObject,
        amObtemData);

    Add('Executar',
        'Executa uma simula��o',
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

    Add('RealizaBalancoHidricoAte',
        'Realiza o Balan�o H�drico de uma determinada Sub-Rede.',
        '',
        [pvtObject],
        [TprPCP],
        [True],
        pvtNull,
        TObject,
        am_RealizaBalancoHidricoAte);
    end;

  with Functions do
    begin
    Add('Nome',
        'Obt�m o Nome atual do projeto',
        '',
        [], [], [],
        pvtString,
        TObject,
        amNome);

    Add('ObtemDeltaT',
        'Obt�m o DeltaT atual do projeto',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amObtemDeltaT);

    Add('Total_IntSim',
        'Obt�m o n�mero total de intervalos de simula��o',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amTotal_IS);

    Add('NumPCs',
        'Obt�m o n�mero de PCs de um projeto, incluindo reservat�rios',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amNumPCs);

    Add('PC',
        'Obt�m o n-�gimo PC de um projeto.'#13 +
        'Para saber se este PC � um reservat�rio, utilize o m�todo "PC_Eh_Reservatorio"'#13 +
        'Par�metros: �ndice do PC',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtObject   ,
        TprPCP      ,
        amObtemPC);
{
    Add('SubBaciaPeloNome',
        'Obt�m uma Sub-Bacia de um projeto dado seu nome.'#13 +
        'Par�metros: Nome da Sub-Bacia (string)',
        '',
        [pvtString],
        [nil      ],
        [False    ],
        pvtObject  ,
        TprSubBacia,
        amObtemSubBaciaPeloNome);
}
    Add('TrechoPeloNome',
        'Obt�m um Trecho-Dagua de um projeto dado seu nome.'#13 +
        'Par�metros: Nome do recho (string)',
        '',
        [pvtString],
        [nil      ],
        [False    ],
        pvtObject  ,
        TprTrechoDagua,
        amObtemTrechoPeloNome);

    Add('DemandaPeloNome',
        'Obt�m uma Demanda de um projeto dado seu nome.'#13 +
        'Par�metros: Nome da Demanda (string)',
        '',
        [pvtString],
        [nil      ],
        [False    ],
        pvtObject  ,
        TprDemanda ,
        amObtemDemandaPeloNome);

    Add('PCPeloNome',
        'Obt�m um PC de um projeto dado seu nome.'#13 +
        'Par�metros: Nome do PC (string)',
        '',
        [pvtString],
        [nil      ],
        [False    ],
        pvtObject  ,
        TprPCP     ,
        amObtemPCPeloNome);

    Add('PCsEntreDois',
        'Obt�m os nomes dos PCs que est�o entre os referenciados pelos par�metros.'#13 +
        'Par�metros: Nome do PC inicial e final (strings)',
        '',
        [pvtString, pvtString],
        [nil      , nil      ],
        [False    , False    ],
        pvtObject ,
        TStringList,
        amPCsEntreDois);

    Add('Rosenbrock',
        'Obt�m o Otimizador padr�o do projeto.',
        '',
        [], [], [],
        pvtObject,
        TRosenbrock,
        amObtemRosenbrock);

    Add('IndiceDoPC',
        '',
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
        'Retorna o n�mero de dias que um intervalo possui',
        '',
        [],
        [],
        [],
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
        'N�mero de anos de simula��o',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_NumAnosDeExecucao);

    Add('TotalAnual_IntSim',
        'N�mero de intervalos de simula��o em um ano',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_TotalAnual_IntSim);

    Add('ValorFO',
        'Vaor da fun��o objetivo estabelecida ao final da simula��o',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        am_ValorFO);
    end;
end;

class procedure TpsProjeto_Class.amObtemData(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
    i: Integer;
    d: TRec_prData;
begin
  o := TprProjeto(Stack.AsObject(4));

  // Salva o deltaT
  i := o.DeltaT;
  o.DeltaT := Stack.AsInteger(1);

  d := o.Data;
  Stack.AsReferency(2).Value := d.Mes;
  Stack.AsReferency(3).Value := d.Ano;

  // Retorna o DeltaT
  o.DeltaT := i;
end;

class procedure TpsProjeto_Class.amNome(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushString(TprProjeto(Stack.AsObject(1)).Nome);
end;

class procedure TpsProjeto_Class.amNumPCs(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprProjeto(Stack.AsObject(1)).PCs.PCs);
end;

class procedure TpsProjeto_Class.amObtemDeltaT(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprProjeto(Stack.AsObject(1)).DeltaT);
end;

class procedure TpsProjeto_Class.amObtemPC(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(TprProjeto(Stack.AsObject(2)).PCs[Stack.AsInteger(1)]);
end;

class procedure TpsProjeto_Class.amObtemTrechoPeloNome(const Func_Name: String; Stack: TexeStack);
var TD: TprTrechoDagua;
begin
  TD := TprProjeto(Stack.AsObject(2)).TrechoPeloNome(Stack.AsString(1));
  Stack.PushObject(TD);
end;

class procedure TpsProjeto_Class.amObtemDemandaPeloNome(const Func_Name: String; Stack: TexeStack);
var DM: TprDemanda;
begin
  DM := TprProjeto(Stack.AsObject(2)).DemandaPeloNome(Stack.AsString(1));
  Stack.PushObject(DM);
end;
{
class procedure TpsProjeto_Class.amObtemSubBaciaPeloNome(const Func_Name: String; Stack: TexeStack);
var SB: TprSubBacia;
begin
  SB := TprProjeto(Stack.AsObject(2)).SubBaciaPeloNome(Stack.AsString(1));
  Stack.PushObject(SB);
end;
}
class procedure TpsProjeto_Class.amObtemPCPeloNome(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprProjeto(Stack.AsObject(2)).PCPeloNome(Stack.AsString(1));
  Stack.PushObject(PC);
end;

class procedure TpsProjeto_Class.amObtemRosenbrock(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(TprProjeto_Rosen(Stack.AsObject(1)).Rosenbrock);
end;

class procedure TpsProjeto_Class.amTotal_IS(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprProjeto(Stack.AsObject(1)).Total_IntSim);
end;

class procedure TpsProjeto_Class.amAtribuiDeltaT(const Func_Name: String; Stack: TexeStack);
begin
  TprProjeto(Stack.AsObject(2)).DeltaT := Stack.AsInteger(1);
end;

class procedure TpsProjeto_Class.am_Executar(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  o.Executar;
end;

class procedure TpsProjeto_Class.am_IndiceDoPC(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(2));
  Stack.PushInteger(o.PCs.IndiceDo(TprPCP(Stack.AsObject(1))));
end;

class procedure TpsProjeto_Class.am_IntervaloDeSimulacao(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  Stack.PushInteger(ord(o.IntervaloDeSimulacao));
end;

class procedure TpsProjeto_Class.am_NivelDeFalha(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  Stack.PushFloat(o.NivelDeFalha);
end;

class procedure TpsProjeto_Class.am_NumAnosDeExecucao(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  Stack.PushInteger(o.NumAnosDeExecucao);
end;

class procedure TpsProjeto_Class.am_TerminarSimulacao(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  o.TerminarSimulacao;
end;

class procedure TpsProjeto_Class.am_TotalAnual_IntSim(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  Stack.PushInteger(o.TotalAnual_IntSim);
end;

class procedure TpsProjeto_Class.am_ValorFO(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  Stack.PushFloat(o.ValorFO);
end;

class procedure TpsProjeto_Class.amPCsEntreDois(const Func_Name: String; Stack: TexeStack);
var SL: TStrings;
begin
  SL := TprProjeto(Stack.AsObject(3)).PCsEntreDois(Stack.AsString(1), Stack.AsString(2));
  Stack.PushObject(SL);
end;

class procedure TpsProjeto_Class.am_DiasNoIntervalo(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(1));
  Stack.PushInteger(o.DiasNoIntervalo);
end;

class procedure TpsProjeto_Class.am_RealizaBalancoHidricoAte(const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto(Stack.AsObject(2));
  o.RealizarBalancoHidricoAte(TprPCP(Stack.AsObject(1)));
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
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.ObtemVazaoAfluenteSBs);
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

class procedure TpsPCP_Class.amObtemNome(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushString(TprPCP(Stack.AsObject(1)).Nome);
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
class procedure TpsPCP_Class.am_CRC(Const Func_Name: String; Stack: TexeStack);
var o: TprPCP;
begin
  o := TprPCP(Stack.AsObject(1));
  Stack.PushString(o.CRC);
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
procedure TpsPCP_Class.AddMethods;
begin
  with Procs do
    begin
    Add('AtribuiValorDemanda',
        'Atribui um valor a um tipo de Demanda de um PC.'#13 +
        'Par�metros:'#13 +
        '   - DeltaT'#13 +
        '   - Tipo da Demanda (1-Prim�ria, 2-Secund�ria, 3-Terci�ria)'#13 +
        '   - Categoria da Demanda ("P"-Planejada, "A"-Atendida, "T"-Totais)'#13 +
        '   - Valora a ser Atribu�do',
        '',
        [pvtInteger , pvtInteger , pvtString , pvtReal],
        [nil        , nil        , nil       , nil    ],
        [False      , False      , False     , False  ],
        pvtNull     ,
        TObject     ,
        amAtribValorDemanda);

    Add('AtribuiVolume',
        'Atribui um volume a um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "PC_Eh_Reservatorio".'#13 +
        'Par�metros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAtribVol);

    Add('AtribuiEnergia',
        'Atribui um valor de Energia a um Delta T de um PC'#13 +
        'Par�metros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAtribEnergia);

     Add('AtribuiDefluvioPlanejado',
        'Atribui o Defluvio Planejado a um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "PC_Eh_Reservatorio".'#13 +
        'Par�metros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAbribDefluPlanej);

    Add('AtribuiDefluencia',
        'Atribui o valor da deflu�ncia de um PC qualquer, inclusive Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio utilize o m�todo "PC_Eh_Reservatorio".'#13 +
        'Par�metros: DeltaT, Valor',
        '',
        [pvtInteger, pvtReal],
        [nil       , nil    ],
        [False     , False  ],
        pvtNull    ,
        TObject     ,
        amAtribDefluencia);
    end;

  with Functions do
    begin
    Add('Nome',
        'Obt�m o nome do PC',
        '',
        [], [], [],
        pvtString ,
        TObject   ,
        amObtemNome);

    Add('Eh_Reservatorio',
        'Informa se o PC � um reservat�rio',
        '',
        [], [], [],
        pvtBoolean ,
        TObject    ,
        amPC_Eh_Res);

    Add('Hm3_m3_Intervalo',
        'Converte hect�metros c�bicos para m�tricos c�bicos.'#13 +
        'ATEN��O: Depende do deltaT atual do Projeto',
        '',
        [pvtReal],
        [nil    ],
        [false  ],
        pvtReal  ,
        TObject  ,
        amHm3_m3_Intervalo);

    Add('m3_Hm3_Intervalo',
        'Converte m�tricos c�bicos para hect�metros c�bicos'#13 +
        'ATEN��O: Depende do deltaT atual do Projeto',
        '',
        [pvtReal],
        [nil    ],
        [false  ],
        pvtReal  ,
        TObject  ,
        amm3_Hm3_Intervalo);

    Add('ObtemHierarquia',
        'Obt�m a Hierarquia do PC',
        '',
        [], [], [],
        pvtInteger,
        TObject   ,
        amObtemHierarquia);

    Add('ObtemVazoesDeMontante',
        'Obt�m o somat�rio das Vaz�es de Montante de um PC para o DeltaT especificado no projeto.',
        '',
        [], [], [],
        pvtReal,
        TObject   ,
        amObtemVazoesDeMontante);

    Add('CalculaArea',
        'Calcula a �rea de um Reservat�rio para um determinado volume.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"'#13 +
        'Par�metro: Volume',
        '',
        [pvtReal ],
        [nil     ],
        [False   ],
        pvtReal   ,
        TObject   ,
        amCalculaAreaDoReservatorio);

    Add('CalculaCotaHidraulica',
        'Calcula a queda hidr�ulica de um Reservat�rio para um determinado volume.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"'#13 +
        'Par�metro: Volume',
        '',
        [pvtReal ],
        [nil     ],
        [False   ],
        pvtReal   ,
        TObject   ,
        amCalculaCotaHidraulica);

    Add('ObtemEvaporacaoUnitaria',
        'Obt�m a Evapora��o Unit�ria atual de um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"'#13 +
        'Par�metro: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemEvaporacaoUnitaria);

    Add('ObtemPrecipitacaoUnitaria',
        'Obt�m a Precipita��o Unit�ria atual de um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"'#13 +
        'Par�metro: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemPrecipitacaoUnitaria);

    Add('ObtemVolume',
        'Obt�m o volume atual de um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"'#13 +
        'Par�metro: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemVol);

    Add('VolumeMaximo',
        'Obt�m o volume m�ximo de um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"',
        '',
        [], [], [],
        pvtReal   ,
        TObject   ,
        amObtemVolMax);

    Add('VolumeMinimo',
        'Obt�m o volume m�nimo de um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"',
        '',
        [], [], [],
        pvtReal   ,
        TObject   ,
        amObtemVolMin);

    Add('VolumeInicial',
        'Obt�m o volume inicial de um Reservat�rio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"',
        '',
        [], [], [],
        pvtReal   ,
        TObject   ,
        amObtemVolInicial);

    Add('ObtemEnergia',
        'Obt�m os valores do c�lculo de energia de um Reservat�rio.'#13 +
        'Par�metro: DeltaT',
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
        'Par�metro: Tipo da Demanda (1-Prim�ria, 2-Secund�ria, 3-Terci�ria)',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemFatorRetorno);

    Add('NumDemandas',
        'Obt�m o n�mero de Demandas de um PC',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amNumDemandas);

    Add('ObtemValorDemanda',
        'Obt�m o valor atual de um tipo de Demanda de um PC.'#13 +
        'Par�metros:'#13 +
        '   - DeltaT atual'#13 +
        '   - Tipo da Demanda (1-Prim�ria, 2-Secund�ria, 3-Terci�ria)'#13 +
        '   - Categoria da Demanda ("P"-Planejada, "A"-Atendida, "T"-Totais)',
        '',
        [pvtInteger , pvtInteger , pvtString],
        [nil        , nil        , nil      ],
        [False      , False      , False    ],
        pvtReal     ,
        TObject     ,
        amObtemValorDemanda);

    Add('ObtemVazaoAfluenteSBs',
        'Obt�m a aflu�ncia das sub-bacias deste PC.',
        '',
        [], [], [],
        pvtReal,
        TObject,
        amAfluenciaSBs);

   Add('ObtemDefluencia',
        'Obt�m a deflu�ncia de um PC.'#13 +
        'Par�metros: DeltaT desejado',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amDefluencia);

    Add('ObtemDefluvioPlanejado',
        'Obt�m o Defluvio Planejado de um Reservatorio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"' +
        'Par�metros: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemDefluPlanejado);

    Add('ObtemDefluvioOperado',
        'Obt�m o Defluvio Operado de um Reservatorio.'#13 +
        'Para saber se um PC � um Reservat�rio, utilize o m�todo "Eh_Reservatorio"' +
        'Par�metros: DeltaT',
        '',
        [pvtInteger],
        [nil       ],
        [False     ],
        pvtReal     ,
        TObject     ,
        amObtemDefluOperado);

    Add('ObtemFalhas',
        'Obt�m um objecto que encapsula todas as falhas de um PC.',
        '',
        [], [], [],
        pvtObject,
        TListaDeFalhas,
        amObtemFalhas);

    Add('Demandas',
        'Retorna o n�mero de Demandas conectadas a este PC',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_Demandas);

    Add('Demanda',
        'Retorna a i-�gima Demanda conectada a este PC',
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
        'Retorna o i-�gimo PC a montante',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprPCP,
        am_PC_aMontante);

    Add('PCs_aMontante',
        'Retorna o n�mero de PCs que estao a montante deste',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        am_PCs_aMontante);

    Add('SubBacia',
        'Retorna a i-�gima SuBacia conectada a este PC',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprSubBacia,
        am_SubBacia);

    Add('SubBacias',
        'Retorna o n�mero de SubBacias conectadas a este PC',
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
        'V�lido somente para PCs',
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
        'Retorna o valor da Curva de Demanda Energ�tica de �ndice i',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtReal,
        TObject,
        amObtemCurvaDemEnergetica);
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
  PC := TprPCP(Stack.AsObject(1));
  Stack.PushFloat(PC.ObtemVazoesDeMontante);
end;

class procedure TpsPCP_Class.amHm3_m3_Intervalo(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(2));
  Stack.PushFloat(PC.Hm3_m3_Intervalo(Stack.AsFloat(1)));
end;

class procedure TpsPCP_Class.amm3_Hm3_Intervalo(const Func_Name: String; Stack: TexeStack);
var PC: TprPCP;
begin
  PC := TprPCP(Stack.AsObject(2));
  Stack.PushFloat(PC.m3_Hm3_Intervalo(Stack.AsFloat(1)));
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
var o: TListaDeFalhas;
begin
  o := TListaDeFalhas(Stack.AsObject(1)); // self
  o.MostrarFalhas;
end;

class procedure Tps_ListaDeFalhas.amAnosCriticos(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushInteger(o.AnosCriticos(p));
end;

class procedure Tps_ListaDeFalhas.amIntervalosCriticos(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushInteger(o.IntervalosCriticos(p));
end;

class procedure Tps_ListaDeFalhas.amFalhaPeloAno(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TListaDeFalhas(Stack.AsObject(3)); // self
  Stack.PushObject(o.FalhaPeloAno(p, Stack.AsString(2)));
end;

class procedure Tps_ListaDeFalhas.amIntervalosTotais(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
    p: TEnumPriorDemanda;
begin
  p := TEnumPriorDemanda(Stack.AsInteger(1)-1);
  o := TListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushInteger(o.IntervalosTotais(p));
end;

class procedure Tps_ListaDeFalhas.amObtemFalhaPrimaria(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
begin
  o := TListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushObject(o.FalhaPrimaria[Stack.AsInteger(1)]);
end;

class procedure Tps_ListaDeFalhas.amObtemFalhaSecundaria(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
begin
  o := TListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushObject(o.FalhaSecundaria[Stack.AsInteger(1)]);
end;

class procedure Tps_ListaDeFalhas.amObtemFalhaTerciaria(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
begin
  o := TListaDeFalhas(Stack.AsObject(2)); // self
  Stack.PushObject(o.FalhaTerciaria[Stack.AsInteger(1)]);
end;

class procedure Tps_ListaDeFalhas.amNumFalhasPrimarias(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
begin
  o := TListaDeFalhas(Stack.AsObject(1)); // self
  Stack.PushInteger(o.FalhasPrimarias);
end;

class procedure Tps_ListaDeFalhas.amNumFalhasSecundarias(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
begin
  o := TListaDeFalhas(Stack.AsObject(1)); // self
  Stack.PushInteger(o.FalhasSecundarias);
end;

class procedure Tps_ListaDeFalhas.amNumFalhasTerciarias(Const Func_Name: String; Stack: TexeStack);
var o: TListaDeFalhas;
begin
  o := TListaDeFalhas(Stack.AsObject(1)); // self
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
        'Par�metros:'#13 +
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
        'Par�metro: Tipo da Prioridade: 1, 2 ou 3'#13 +
        'Retorna o n�mero total de anos',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtInteger,
        TObject,
        amIntervalosTotais);

    Add('AnosCriticos',
        'Par�metro: Tipo da Prioridade: 1, 2 ou 3'#13 +
        'Retorna o n�mero total de anos onde houveram falhas cr�ticas',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtInteger,
        TObject,
        amAnosCriticos);

    Add('IntervalosCriticos',
        'Par�metro: Tipo da Prioridade: 1, 2 ou 3'#13 +
        'Retorna o n�mero de intervalos cr�ticos de todos os anos.',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtInteger,
        TObject,
        amIntervalosCriticos);

    Add('ObtemFalhaPrimaria',
        '',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprFalha,
        amObtemFalhaPrimaria);

    Add('ObtemFalhaSecundaria',
        '',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprFalha,
        amObtemFalhaSecundaria);

    Add('ObtemFalhaTerciaria',
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
    Add('TVU_NumIntervalos',
        'Configura o n�mero de intervalos da Tabela de Valores Unit�rios',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtNull,
        TObject,
        am_TVU_NumIntervalos);

    Add('TVU_AnoIniFimIntervalo',
        'Configura o ano inicial e o final para um intervalo'#13 +
        'Par�metros:'#13 +
        '  - �ndice do Intervalo'#13 +
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
        'Configura o valor da demanda para um determinado m�s'#13 +
        'Par�metros:'#13 +
        '  - �ndice do Intervalo'#13 +
        '  - M�s'#13 +
        '  - Valor da Demanda',
        '',
        [pvtInteger, pvtInteger, pvtReal],
        [nil, nil, nil],
        [False, False, False],
        pvtNull,
        TObject,
        am_TVU_Demanda);
    end;

  with Functions do
    begin
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
        '   1 = Prim�ria'#13 +
        '   2 = Secund�ria'#13 +
        '   3 = Terci�ria',
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
        'Informa se a demanda est� ativa ou n�o. Se ativa a demanda � considerada na totaliza��o'#13 +
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
    end;
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

end.

