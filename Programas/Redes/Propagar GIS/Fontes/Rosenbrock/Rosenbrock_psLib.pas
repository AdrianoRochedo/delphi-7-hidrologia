unit Rosenbrock_psLib;

interface
uses psBASE;

  procedure API(Lib: TLib);

implementation
uses sysutils, Dialogs,
     pr_Classes,
     pr_Const,
     Rosenbrock_Class,
     hidro_Optimizer_Interfaces;

const
  cCat_Propagar = 'Classes do Propagar (Rosenbrock)';

type
  TpsRosen_Parameter = Class(TpsClass)
  public
    procedure AddMethods; override;
    //function CreateObject(Stack: TexeStack): TObject; override;

    class procedure amShow          (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetName       (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetName       (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetLink       (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetValue      (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetValue      (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetLowLimit   (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetLowLimit   (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetHiLimit    (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetHiLimit    (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetStep       (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetStep       (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetTolerance  (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetTolerance  (Const Func_Name: String; Stack: TexeStack);
  end;

  TpsRosen_Parameters = Class(TpsClass)
  public
    procedure AddMethods; override;

    class procedure amCount           (Const Func_Name: String; Stack: TexeStack);
    class procedure amParameter       (Const Func_Name: String; Stack: TexeStack);
    class procedure amParamByName     (Const Func_Name: String; Stack: TexeStack);
    class procedure amClear           (Const Func_Name: String; Stack: TexeStack);
    class procedure amCreateParameter (Const Func_Name: String; Stack: TexeStack);
  end;

  TpsRosenbrock = Class(TpsClass)
  public
    procedure AddMethods; override;

    class procedure amStop                 (Const Func_Name: String; Stack: TexeStack);
    class procedure amShowFO               (Const Func_Name: String; Stack: TexeStack);
    class procedure amShowManager          (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetTolerante         (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetTolerante         (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetIncStep           (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetIncStep           (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetDecStep           (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetDecStep           (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetInitialStep       (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetInitialStep       (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetMaxSimulations    (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetMaxSimulations    (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetMaxTimeSimulation (Const Func_Name: String; Stack: TexeStack);
    class procedure amSetMaxTimeSimulation (Const Func_Name: String; Stack: TexeStack);
    class procedure amGetParameters        (Const Func_Name: String; Stack: TexeStack);
  end;

{ ------------------- Ponto de Entrada ------------------ }

procedure API(Lib: TLib);
begin
  TpsRosen_Parameter.Create(
      TrbParameter,
      nil,
      'Informações sobre um parâmetro',
      cCat_Propagar,
      [], [], [],
      False,
      Lib.Classes);

  TpsRosen_Parameters.Create(
     TrbParameters,
     nil,
     'Gerencia os parâmetros do Rosenbrock',
     cCat_Propagar,
     [], [], [],
     False,
     Lib.Classes);

  TpsRosenbrock.Create(
     TRosenbrock,
     nil,
     'Encapsula um mecanismo de Otimização',
     cCat_Propagar,
     [], [], [],
     False,
     Lib.Classes);
end;

{ ------------------- Ponto de Entrada ------------------ }

{ TpsRosen_Parameter }

procedure TpsRosen_Parameter.AddMethods;
begin
  with Procs do
    begin
    Add('Show',
        'Mostra as informações do parâmetro na posição x, y',
        '',
        [pvtInteger, pvtInteger],
        [nil       , nil       ],
        [false     , false     ],
        pvtNull,
        TObject,
        amShow);

    Add('SetLink',
        'Liga um objeto existente a este parâmetro.'#13 +
        'O objeto tem que implementar a interface IOptimizer.'#13 +
        'Estes objetos são: PCs, Reservatórios, Sub-Bacias, Trechos-Dáguas e Demandas'#13 +
        'Parâmetros:'#13 +
        '  - 1. Objeto que implementa a interface IOptimizer'#13 +
        '  - 2. Nome da propriedade do objeto a ser otimizada'#13 +
        '  - 3. Ano, caso a propriedade seja uma tabela indexada por ano'#13 +
        '  - 4. Mes, caso a propriedade seja uma tabela indexada por ano e mes'#13 +
        ''#13 +
        'OBS.: Para as propriedades simples (não tabeladas), os parâmetros Ano e Mes são ignorados.'#13,
        '',
        [pvtObject, pvtString, pvtInteger, pvtInteger],
        [TObject, nil, nil, nil],
        [True, false, false, false],
        pvtNull,
        TObject,
        amSetLink);

    Add('SetName',
        '',
        '',
        [pvtString],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetName);

    Add('SetValue',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetValue);

    Add('SetLowLimit',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetLowLimit);

    Add('SetHiLimit',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetHiLimit);

    Add('SetStep',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetStep);

    Add('SetTolerance',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetTolerance);
    end;

  with Functions do
    begin
    Add('GetName',
        '',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        amGetName);

    Add('GetValue',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetValue);

    Add('GetLowLimit',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetLowLimit);

    Add('GetHiLimit',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetHiLimit);

    Add('GetStep',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetStep);

    Add('GetTolerance',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetTolerance);
    end;
end;

class procedure TpsRosen_Parameter.amGetHiLimit(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TrbParameter(Stack.AsObject(1)).HiLimit
    );
end;

class procedure TpsRosen_Parameter.amGetLowLimit(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TrbParameter(Stack.AsObject(1)).LowLimit
    );
end;

class procedure TpsRosen_Parameter.amGetName(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushString(
    TrbParameter(Stack.AsObject(1)).Name
    );
end;

class procedure TpsRosen_Parameter.amSetLink(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(5)).SetLink(
    Stack.AsObject(1),   // objeto que implementa a interface IOptimizer
    Stack.AsString(2),   // Nome da propriedade
    Stack.AsInteger(3),  // Ano
    Stack.AsInteger(4)   // Mes
    );
end;

class procedure TpsRosen_Parameter.amGetStep(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TrbParameter(Stack.AsObject(1)).Step
    );
end;

class procedure TpsRosen_Parameter.amGetTolerance(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TrbParameter(Stack.AsObject(1)).Tolerance
    );
end;

class procedure TpsRosen_Parameter.amGetValue(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TrbParameter(Stack.AsObject(1)).Value
    );
end;

class procedure TpsRosen_Parameter.amSetHiLimit(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(2)).HiLimit := Stack.AsFloat(1);
end;

class procedure TpsRosen_Parameter.amSetLowLimit(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(2)).LowLimit := Stack.AsFloat(1);
end;

class procedure TpsRosen_Parameter.amSetName(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(2)).Name := Stack.AsString(1);
end;

class procedure TpsRosen_Parameter.amSetStep(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(2)).Step := Stack.AsFloat(1);
end;

class procedure TpsRosen_Parameter.amSetTolerance(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(2)).Tolerance := Stack.AsFloat(1);
end;

class procedure TpsRosen_Parameter.amSetValue(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(2)).Value := Stack.AsFloat(1);
end;

class procedure TpsRosen_Parameter.amShow(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameter(Stack.AsObject(3)).Show(Stack.AsInteger(1), Stack.AsInteger(2));
end;

//function TpsRosen_Parameter.CreateObject(Stack: TexeStack): TObject;
//begin
  //Result := TrbParameter.Create;
//end;

{ TpsRosen_Parameters }

procedure TpsRosen_Parameters.AddMethods;
begin
  with Procs do
    begin
    Add('Clear',
        'Remove da lista todos os parâmetros',
        '',
        [],
        [],
        [],
        pvtNull,
        TObject,
        amClear);
    end;

  with Functions do
    begin
    Add('Count',
        'Retorna a quantidade total de parâmetros',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        amCount);

    Add('Parameter',
        'Retorna o i-égimo parâmetro',
        '',
        [pvtInteger],
        [nil],
        [False],
        pvtObject,
        TrbParameter,
        amParameter);

    Add('ParamByName',
        'Retorna o parâmetro que possui o nome passado',
        '',
        [pvtString],
        [nil],
        [False],
        pvtObject,
        TrbParameter,
        amParamByName);

    Add('CreateParameter',
        'Informa a definição de um parâmetro para o Rosenbrock.'#13 +
        'Devolve o parâmetro criado.',
        '',
        [],
        [],
        [],
        pvtObject,
        TrbParameter,
        amCreateParameter);
    end;
end;
{
class procedure TpsRosen_Parameters.amAdd(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(
    TrbParameters(Stack.AsObject(2)).Add(
      TrbParameter(Stack.AsObject(1))
      )
    );
end;
}
class procedure TpsRosen_Parameters.amClear(const Func_Name: String; Stack: TexeStack);
begin
  TrbParameters(Stack.AsObject(1)).Clear;
end;

class procedure TpsRosen_Parameters.amCount(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(
    TrbParameters(Stack.AsObject(1)).Count
    );
end;

class procedure TpsRosen_Parameters.amCreateParameter(const Func_Name: String; Stack: TexeStack);
var Pars: TrbParameters;
begin
  Pars := TrbParameters(Stack.AsObject(1));
  Stack.PushObject(Pars.CreateParameter);
end;

class procedure TpsRosen_Parameters.amParamByName(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(
    TrbParameters(Stack.AsObject(2)).ParamByName(
      Stack.AsString(1)
      )
    );
end;

class procedure TpsRosen_Parameters.amParameter(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(
    TrbParameters(Stack.AsObject(2)).Parameter[
      Stack.AsInteger(1)]
    );
end;

{ TpsRosenbrock }

procedure TpsRosenbrock.AddMethods;
begin
  with Procs do
    begin
    Add('Stop',
        'Termina a otimização',
        '',
        [],
        [],
        [],
        pvtNull,
        TObject,
        amStop);

    Add('ShowFO',
        'Mostra a dinâmica da função objetivo em um gráfico',
        '',
        [pvtInteger, pvtInteger],
        [nil, nil],
        [False, False],
        pvtNull,
        TObject,
        amShowFO);

    Add('ShowManager',
        'Mostra o gerenciador de parâmetros do Rosenbrock',
        '',
        [pvtInteger, pvtInteger],
        [nil, nil],
        [False, False],
        pvtNull,
        TObject,
        amShowManager);

    Add('SetTolerante',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetTolerante);

    Add('SetIncStep',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetIncStep);

    Add('SetDecStep',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetDecStep);

    Add('SetInitialStep',
        '',
        '',
        [pvtBoolean],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetInitialStep);

    Add('SetMaxSimulations',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetMaxSimulations);

    Add('SetMaxTimeSimulation',
        '',
        '',
        [pvtReal],
        [nil],
        [False],
        pvtNull,
        TObject,
        amSetMaxTimeSimulation);
    end;

  with Functions do
    begin
    Add('GetTolerante',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetTolerante);

    Add('GetIncStep',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetIncStep);

    Add('GetDecStep',
        '',
        '',
        [],
        [],
        [],
        pvtReal,
        TObject,
        amGetDecStep);

    Add('GetInitialStep',
        '',
        '',
        [],
        [],
        [],
        pvtBoolean,
        TObject,
        amGetInitialStep);

    Add('GetMaxSimulations',
        '',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        amGetMaxSimulations);

    Add('GetMaxTimeSimulation',
        '',
        '',
        [],
        [],
        [],
        pvtInteger,
        TObject,
        amGetMaxTimeSimulation);

    Add('Parameters',
        'Retorna uma referência aos parâmetros do Mecanismo',
        '',
        [],
        [],
        [],
        pvtObject,
        TrbParameters,
        amGetParameters);
    end;
end;

class procedure TpsRosenbrock.amGetDecStep(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TRosenbrock(Stack.AsObject(1)).DecStep
    );
end;

class procedure TpsRosenbrock.amGetIncStep(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TRosenbrock(Stack.AsObject(1)).IncStep
    );
end;

class procedure TpsRosenbrock.amGetInitialStep(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushBoolean(
    TRosenbrock(Stack.AsObject(1)).InitialStep
    );
end;

class procedure TpsRosenbrock.amGetMaxSimulations(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(
    TRosenbrock(Stack.AsObject(1)).MaxSimulations
    );
end;

class procedure TpsRosenbrock.amGetMaxTimeSimulation(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushInteger(
    TRosenbrock(Stack.AsObject(1)).MaxTimeSimulation
    );
end;

class procedure TpsRosenbrock.amGetParameters(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushObject(
    TRosenbrock(Stack.AsObject(1)).Parameters
    );
end;

class procedure TpsRosenbrock.amGetTolerante(const Func_Name: String; Stack: TexeStack);
begin
  Stack.PushFloat(
    TRosenbrock(Stack.AsObject(1)).Tolerance
    );
end;

class procedure TpsRosenbrock.amSetDecStep(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(2)).DecStep := Stack.AsFloat(1);
end;

class procedure TpsRosenbrock.amSetIncStep(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(2)).IncStep := Stack.AsFloat(1);
end;

class procedure TpsRosenbrock.amSetInitialStep(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(2)).InitialStep := Stack.AsBoolean(1);
end;

class procedure TpsRosenbrock.amSetMaxSimulations(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(2)).MaxSimulations := Stack.AsInteger(1);
end;

class procedure TpsRosenbrock.amSetMaxTimeSimulation(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(2)).MaxTimeSimulation := Stack.AsInteger(1);
end;

class procedure TpsRosenbrock.amSetTolerante(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(2)).Tolerance := Stack.AsFloat(1);
end;

class procedure TpsRosenbrock.amShowFO(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(3)).ShowFO(Stack.AsInteger(1), Stack.AsInteger(2));
end;

class procedure TpsRosenbrock.amShowManager(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(3)).ShowManager(Stack.AsInteger(1), Stack.AsInteger(2));
end;

class procedure TpsRosenbrock.amStop(const Func_Name: String; Stack: TexeStack);
begin
  TRosenbrock(Stack.AsObject(1)).Stop;
end;

end.

