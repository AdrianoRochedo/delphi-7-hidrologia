unit pr_psLib;

interface
uses psBASE;

  procedure API(Lib: TLib);

implementation
uses Classes, sysutils, Dialogs, pr_Classes, pr_Const, pr_Tipos,
     Lists, EquationBuilder, Optimizer_Base;

type
  Tps_Base = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_Nome(Const Func_Name: String; Stack: TexeStack);
  end;

  TpsProjeto_Class = Class(TpsClass)
  public
    procedure AddMethods; override;
    class procedure amNumPCs                        (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPC                       (Const Func_Name: String; Stack: TexeStack);
    class procedure amObjetoPeloNome                (Const Func_Name: String; Stack: TexeStack);
    class procedure amObtemPCPeloNome               (Const Func_Name: String; Stack: TexeStack);
    class procedure amPCsEntreDois                  (Const Func_Name: String; Stack: TexeStack);
    class procedure amObterSubRede                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_IndiceDoPC                   (Const Func_Name: String; Stack: TexeStack);
  end;

  TpsPC_Class = Class(TpsClass)
  public
    procedure AddMethods; override;
    //class procedure amNumDemandas               (Const Func_Name: String; Stack: TexeStack);
    //class procedure am_Demandas                 (Const Func_Name: String; Stack: TexeStack);
    //class procedure am_Demanda                  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_aJusante              (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PC_aMontante             (Const Func_Name: String; Stack: TexeStack);
    class procedure am_PCs_aMontante            (Const Func_Name: String; Stack: TexeStack);
    class procedure am_TrechoDagua              (Const Func_Name: String; Stack: TexeStack);
    class procedure am_Eh_PC_Montante           (Const Func_Name: String; Stack: TexeStack);
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
     TComponente,
     nil,
     '',
     cCatPropagar,
     [], [], [],
     False,
     Lib.Classes);

  TpsProjeto_Class.Create(
      TprProjeto,
      TComponente,
      'Encapsula um projeto',
      '',
      [], [], [],
      False,
      Lib.Classes);

  TpsPC_Class.Create(
      TprPC,
      TComponente,
      'Encapsula um Ponto de Controle',
      '',
      [], [], [],
      False,
      Lib.Classes);

  Tps_Cenario.Create(
      TprCenarioDeDemanda,
      TComponente,
      'Representa informações complementares de uma demanda',
      '',
      [], [], [],
      False,
      Lib.Classes);

  Tps_TrechoDagua.Create(
      TprTrechoDagua,
      TComponente,
      '',
      '',
      [], [], [],
      False,
      Lib.Classes);
end;

{ ------------------- Ponto de Entrada ------------------ }

{ Tps_Base }

class procedure Tps_Base.am_Nome(Const Func_Name: String; Stack: TexeStack);
var o: TComponente;
begin
  o := TComponente(Stack.getSelf);
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
  with Functions do
    begin
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
        TprPC       ,
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
        TprPC     ,
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
        [TprPC   , nil       ],
        [True     , False     ],
        pvtObject ,
        TStringList,
        amObterSubRede);

    Add('IndiceDoPC',
        'Retorna o índice deste PC',
        '',
        [pvtObject],
        [TprPC],
        [True],
        pvtInteger,
        TObject,
        am_IndiceDoPC);
    end;
end;

class procedure TpsProjeto_Class.amNumPCs(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprProjeto( Stack.getSelf() ).PCs.PCs);
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
var PC: TprPC;
begin
  PC := TprProjeto( Stack.getSelf() ).PCPeloNome(Stack.AsString(1));
  Stack.PushObject(PC);
end;

class procedure TpsProjeto_Class.am_IndiceDoPC(Const Func_Name: String; Stack: TexeStack);
var o: TprProjeto;
begin
  o := TprProjeto( Stack.getSelf() );
  Stack.PushInteger(o.PCs.IndiceDo(TprPC(Stack.AsObject(1))));
end;

class procedure TpsProjeto_Class.amPCsEntreDois(const Func_Name: String; Stack: TexeStack);
var SL: TStrings;
begin
  SL := TprProjeto( Stack.getSelf() ).PCsEntreDois(Stack.AsString(1), Stack.AsString(2));
  Stack.PushObject(SL);
end;

class procedure TpsProjeto_Class.amObterSubRede(const Func_Name: String; Stack: TexeStack);
var SL: TStrings;
begin
  SL := TprProjeto( Stack.getSelf() ).ObterSubRede( TprPC(Stack.AsObject(1)),
                                                           Stack.AsBoolean(2) );
  Stack.PushObject(SL);
end;

{ TpsPC_Class }

(*
class procedure TpsPC_Class.amNumDemandas(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(TprPC(Stack.AsObject(1)).Demandas);
end;

class procedure TpsPC_Class.am_Demandas(Const Func_Name: String; Stack: TexeStack);
var o: TprPC;
begin
  o := TprPC(Stack.AsObject(1));
  Stack.PushInteger(o.Demandas);
end;

class procedure TpsPC_Class.am_Demanda(Const Func_Name: String; Stack: TexeStack);
var o: TprPC;
begin
  o := TprPC(Stack.AsObject(2));
  Stack.PushObject(o.Demanda[Stack.AsInteger(1)]);
end;
*)

class procedure TpsPC_Class.am_PC_aJusante(Const Func_Name: String; Stack: TexeStack);
var o: TprPC;
begin
  o := TprPC(Stack.AsObject(1));
  Stack.PushObject(o.PC_aJusante);
end;

class procedure TpsPC_Class.am_PC_aMontante(Const Func_Name: String; Stack: TexeStack);
var o: TprPC;
begin
  o := TprPC(Stack.AsObject(2));
  Stack.PushObject(o.PC_aMontante[Stack.AsInteger(1)]);
end;

class procedure TpsPC_Class.am_PCs_aMontante(Const Func_Name: String; Stack: TexeStack);
var o: TprPC;
begin
  o := TprPC(Stack.AsObject(1));
  Stack.PushInteger(o.PCs_aMontante);
end;

class procedure TpsPC_Class.am_TrechoDagua(Const Func_Name: String; Stack: TexeStack);
var o: TprPC;
begin
  o := TprPC(Stack.AsObject(1));
  Stack.PushObject(o.TrechoDagua);
end;

class procedure TpsPC_Class.am_Eh_PC_Montante(Const Func_Name: String; Stack: TexeStack);
var o: TprPC;
begin
  o := TprPC(Stack.AsObject(2));
  Stack.PushBoolean(o.Eh_umPC_aMontante(TprPC(Stack.AsObject(1))));
end;

procedure TpsPC_Class.AddMethods;
begin
  with Functions do
    begin
{
    Add('NumDemandas',
        'Obtém o número de Demandas de um PC',
        '',
        [], [], [],
        pvtInteger,
        TObject,
        amNumDemandas);

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
}
    Add('PC_aJusante',
        'Retorna o PC a Jusante',
        '',
        [],
        [],
        [],
        pvtObject,
        TprPC,
        am_PC_aJusante);

    Add('PC_aMontante',
        'Retorna o i-égimo PC a montante',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TprPC,
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

    Add('TrechoDagua',
        'Retorna o trechoDagua pertencente a este PC',
        '',
        [],
        [],
        [],
        pvtObject,
        TprTrechoDagua,
        am_TrechoDagua);

    Add('Eh_PC_Montante',
        '',
        '',
        [pvtObject],
        [TprPC],
        [True],
        pvtBoolean,
        TObject,
        am_Eh_PC_Montante);
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
        TprPC,
        am_PC_Jusante);

    Add('PC_Montante',
        '',
        '',
        [],
        [],
        [],
        pvtObject,
        TprPC,
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

end.

