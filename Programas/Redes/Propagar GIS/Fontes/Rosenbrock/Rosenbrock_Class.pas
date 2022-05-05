unit Rosenbrock_Class;

interface
uses Classes, SysUtils, Graphics,
     hidro_Optimizer_Interfaces,
     Rosenbrock_FormParameter,
     Rosenbrock_FormFO,
     Rosenbrock_FormParMan,
     Rosenbrock_FrameParMan;

type
  TrbLink = class
  private
    FOptimizeble : IOptimizer;
    FPropName    : string;
    FYear        : integer;
    FMonth       : integer;
  public
    property Optimizeble  : IOptimizer read FOptimizeble write FOptimizeble;
    property PropName     : string     read FPropName    write FPropName;
    property Year         : integer    read FYear        write FYear;
    property Month        : integer    read FMonth       write FMonth;
  end;

  TrbParameter = class
  private
    FFormPar      : TrbFormParameter;
    FManagerFrame : TrbFrameParMan;
    FLowLimit     : Real;
    FCurrentValue : Real;
    FStep         : Real;
    FValue        : Real;
    FTolerance    : Real;
    FHiLimit      : Real;
    FName         : String;
    FLink         : TrbLink;
    FStatusFO     : Char;

    procedure SetHiLimit(const Value: Real);
    procedure SetLowLimit(const Value: Real);
    procedure SetName(const Value: String);
    procedure SetStep(const Value: Real);
    procedure SetTolerance(const Value: Real);
    procedure SetValue(const Value: Real);
    function  GetValue: Real;
    procedure SetStatusFO(const Value: Char);
    procedure SetColor(const Value: TColor);
  public
    Constructor Create(const aName       : String;
                       const aLowLimit   : Real;
                       const aHiLimit    : Real;
                       const aStep       : Real;
                       const aTolerance  : Real); overload;

    destructor Destroy; override;

    // Configura o Link com a variável a ser otimizada
    procedure setLink(aObj: TObject; const aPropName: string; aYear, aMonth: Integer);

    // Mostra uma janela que mostra as propriedades do Parâmetro
    procedure Show(Left, Top: Integer);

    // Link de conecção para as variaveis a serem otimizadas
    property Link: TrbLink read FLink;

    // Nome do parâmetro. Ex: "Volume do Res. Queimado"
    property Name : String read FName write SetName;

    // interface para o valor da propriedade do objeto ligado a este parâmetro
    property Value : Real read GetValue write SetValue;

    // Limite inferior
    property LowLimit : Real read FLowLimit write SetLowLimit;

    // Limite superior
    property HiLimit : Real read FHiLimit write SetHiLimit;

    // Passo para incremento
    property Step : Real read FStep write SetStep;

    // Tolerância
    property Tolerance : Real read FTolerance write SetTolerance;

    // Informa se houve melhoria/piora no valor da função objetivo em relação a este par.
    property StatusFO : Char read FStatusFO write SetStatusFO;

    // Cor do Gauge
    property Color : TColor write SetColor;

    // Janela que mostra as propriedades do parâmetro para o usuário
    property FormPar : TrbFormParameter read FFormPar write FFormPar;

    property FramePar : TrbFrameParMan read FManagerFrame;
  end;

  TrbParameters = class
  private
    FList: TList;
    FFormManager: TrbFormParMan;
    FActivePar: Integer;

    function getCount: Integer;
    function GetPar(i: Integer): TrbParameter;
    function  Add(Param: TrbParameter): Integer;
    procedure SetActivePar(const Value: Integer);
  public
    constructor Create(FormManager: TrbFormParMan);
    destructor  Destroy; override;

    function  CreateParameter: TrbParameter;
    function  ParamByName(const Name: String): TrbParameter;
    procedure Clear;

    property Count                 : Integer      read getCount;
    property Parameter[i: Integer] : TrbParameter read GetPar; default;
    property ActivePar             : Integer      read FActivePar write SetActivePar;
  end;

  TTermProc    = procedure of object;
  TVisualProc  = procedure(Params: TrbParameters; FO: Real; Simulacao, Estagio: Integer) of object;
  TGeralFunction   = function(Params: TrbParameters): Real of object;

  TRosenbrock = class
  private
    FParams: TrbParameters;             // Parâmetros
    FTOL   : Real;                      // Tolerância da Funcão Objetivo

    FVisualProc     : TVisualProc;      // Para feedback visual
    FGeralFunction  : TGeralFunction;
    FTermProc       : TTermProc;

    FFormFO : TrbFormFO;
    FFormManager : TrbFormParMan;

    FMTS : Longword;
    FMS  : Longword;

    KOUNT         : Integer;
    NumEstagio    : Integer;
    FO            : Real;
    FIncPasso     : Real;
    FDecPasso     : Real;
    FPassoInicial : Boolean;
    FTerminated   : Boolean;

    procedure ProcessMessages;
    procedure DoVisualUpdate;
    procedure SetDecPasso(const Value: Real);
    procedure SetIncPasso(const Value: Real);
    procedure SetTOL(const Value: Real);
  Public
    constructor Create;
    destructor  Destroy; override;

    procedure Execute;
    procedure Stop;

    procedure ShowFO(aLeft, aTop: Integer);
    procedure ShowManager(aLeft, aTop: Integer);

    // Propriedades

    property Tolerance           : Real             read FTOL            write SetTOL;
    property IncStep             : Real             read FIncPasso       write SetIncPasso;
    property DecStep             : Real             read FDecPasso       write SetDecPasso;
    property InitialStep         : Boolean          read FPassoInicial   write FPassoInicial;
    property MaxSimulations      : Longword         read FMS             write FMS;
    property MaxTimeSimulation   : Longword         read FMTS            write FMTS;

    property Parameters          : TrbParameters    read FParams         write FParams;
    property FormFO              : TrbFormFO        read FFormFO         write FFormFO;
    property FormManager         : TrbFormParMan    read FFormManager    write FFormManager;

    // Eventos

    property OnGeralFunction     : TGeralFunction   read FGeralFunction  write FGeralFunction;
    property OnVisualProc        : TVisualProc      read FVisualProc     write FVisualProc;
    property OnTerminateProc     : TTermProc        read FTermProc       write FTermProc;
  end;

  OptimizerException = class(Exception);

  procedure OptimizerError(const PropName, ClassName: string);

implementation
uses windows, Messages;

procedure OptimizerError(const PropName, ClassName: string);
begin
  raise OptimizerException.CreateFmt(
    'Optimizer: Property name <%s> not found in Class <%s>', [PropName, ClassName]);
end;

{ TRosenbrock }

constructor TRosenbrock.Create;
begin
  inherited Create;

  FMTS        := 3888000000; // 45 dias
  FMS         := MaxInt;
  FTOL        := 0.001;
  FIncPasso   := 3.0;
  FDecPasso   := 0.5;

  FFormManager := TrbFormParMan.Create(nil);
  FParams      := TrbParameters.Create(FFormManager);
end;

destructor TRosenbrock.Destroy;
begin
  // Não mudar esta ordem de destruição
  FFormFO.Free;
  FParams.Free;
  FFormManager.Free;
  inherited;
end;

type
  TADD    = array of Real;
  TAADD   = array of TADD;
  TACD    = array of Char;
  TABD    = array of Boolean;
  TAID    = array of Byte;

procedure TRosenbrock.Execute;

var Ciclo, J              : Longword;
    F, FO, FBest, TM      : Real;
    FTol_FO_ABS           : Real;
    B, V, VV              : TAADD;
    Eint, D, AL, H, BX    : TADD;
    FTL_ABS               : TADD;
    PriVez                : TABD;
    //Vale                  : TACD;
    Marca                 : TAID;
    UmaSimulacao          : Boolean;
    Melhorou              : Boolean;
    F_Igual_FO            : Boolean;

    procedure Inicializacoes;
    var K, I: Integer;
        Par: TrbParameter;
    begin
      FTerminated := False;

      // Dimensiona dinamicamente os Arrays
      I := FParams.Count;

      SetLength(Eint,    I);
      SetLength(D,       I);
      SetLength(AL,      I);
      SetLength(H,       I);
      SetLength(BX,      I);
      SetLength(FTL_ABS, I);
      SetLength(PriVez,  I);
      SetLength(Marca,   I);

      SetLength(B,  I, I);
      SetLength(V,  I, I);
      SetLength(VV, I, I);

      KOUNT :=  0;
      NumEstagio := 0;
      UmaSimulacao := False;
      FPassoInicial := True;

      FFormManager.Simulation := 0;
      FFormManager.Rotation := 0;

      // AVALIACAO INICIAL DA FUNCAO-OBJETIVO
      F := FGeralFunction(FParams);

      FO := F;
      FBEST := FO;

      // ESTABELECE TOLERANCIA DE AJUSTE DA FUNCAO-OBJETIVO
      FTol_FO_ABS  :=  FTOL * F;

      // ESTABELECE ZONA FRONTEIRICA DA REGIAO VIAVEL E COMPUTA PRECISAO PARA PARAMETROS
      for K := 0 to FParams.Count-1 do
        begin
        Par := FParams[k];
        AL[K] := (Par.HiLimit - Par.LowLimit) * Par.Tolerance;   //??? tratar zeros
        FTL_ABS[K] := Par.Tolerance * ABS(Par.Step);
        end;

      // INICIALIZA COMO INDENTIDADE MATRIZ V DOS VETORES UNIDIRECIONAIS
      for I := 0 to FParams.Count-1 do
        for K := 0 to FParams.Count-1 do
          if I = K then V[I,K] := 1 else V[I,K] := 0;

      // GUARDA VALORES INICIAIS DO PASSO DE VARIACAO DE CADA VARIAVEL
      for K := 0 to FParams.Count-1 do EINT[K] := FParams[k].Step;

      // Obtem o tempo inicial
      TM := GetTickCount;
    end;

    procedure Finalizacoes;
    begin
      if @FTermProc <> nil then FTermProc;
    end;

    function ParametrosViaveis: Boolean;
    var K: Integer;
        Par: TrbParameter;
    begin
      Result := True;
      for K := 0 to FParams.Count-1 do
        begin
        Par := FParams[k];
        if (Par.Value < Par.LowLimit) or (Par.Value > Par.HiLimit) then
           begin
           Result := False;
           Break;
           end;
        end;
    end;

    procedure IncrementarEstagio;
    begin
      inc(NumEstagio);
      FFormManager.Rotation := NumEstagio;
    end;

    procedure RotacionaEixo;
    var K, KK, R, C  : Integer;
        SUMVM, SUMAV : Real;
        FNV          : Integer;
    begin
      FNV := FParams.Count;

      for R := 0 to FNV-1 do
        for C := 0 to FNV-1 do
           VV[C,R] := 0.0;

      for R := 0 to FNV-1 do
        for C := 0 to FNV-1 do
          begin
          for K := R to FNV-1 do VV[R,C] := D[K] * V[K,C] + VV[R,C];
          B[R,C] := VV[R,C];
          end;

      BX[0] := 0.0;
      for C := 0 to FNV-1 do
        BX[0] := BX[0] + SQR(B[0,C]);

      BX[0] := SQRT(BX[0]);
      IF BX[0] = 0 then BX[0] := 0.000001;

      for C := 0 to FNV-1 do
        V[0,C] := B[0,C] / BX[0];

      for R := 1 to FNV-1 do  // Aqui começa em 1 mesmo
        for C := 0 to FNV-1 do
          begin
          SUMVM := 0.0;
          for K := 0 to R-2 do  // vai até o penultimo
            begin
            SUMAV := 0.0;
            for KK := 0 to FNV-1 do SUMAV := SUMAV + VV[R,KK]* V[K,KK];
            SUMVM := SUMAV*V[K,C] + SUMVM;
            end;
          B[R,C] := VV[R,C] - SUMVM;
          end;

      for R := 1 to FNV-1 do  // Aqui começa em 1
        begin
        BX[R] :=  0.0;
        for K := 0 to FNV-1 do BX[R] := BX[R] + B[R,K] * B[R,K];
        BX[R] := SQRT(BX[R]);
        IF BX[R] = 0.0 then BX[R] := 0.0000001;
        for C := 0 to FNV-1 do V[R,C] := B[R,C] / BX[R];
        end;

      // FINAL DA ROTACAO - INICIA ESTAGIO SEGUINTE DE COMPUTACOES
      IncrementarEstagio;
      FBEST := FO;
    end;

    function TodosParametrosSaoVale: Boolean;
    var K: Integer;
    begin
      Result := True;
      for K := 0 to FParams.Count-1 do
        if FParams[K].StatusFO <> 'V' then
           begin
           Result := False;
           Break;
           end;
    end;

    procedure Calcula_Passo_Evitando_Inviabilidade;
    var xx: Real;
        K : Integer;
        Par: TrbParameter;
    begin
      for K := 0 to FParams.Count-1 do
        begin
        Par := FParams[K];

        xx := FParams[Ciclo].Step * V[Ciclo, K];
        if (xx < 0.0) and (xx < (Par.LowLimit - Par.Value)) then
           FParams[Ciclo].Step := (Par.LowLimit - Par.Value) / V[Ciclo,K];

        xx := FParams[Ciclo].Step * V[Ciclo,K];
        if (xx > 0.0) and (xx > (Par.HiLimit - Par.Value)) then
           FParams[Ciclo].Step := (Par.HiLimit - Par.Value) / V[Ciclo,K];
        end;
    end;

Type
  TipoFalha = (tfIneficiencia, tfInviabilidade);

    // Penaliza Função Objetivo
    function Calcula_Fp: Real;
    var BW, PW: Real;
        Par: TrbParameter;
    begin
      Par := FParams[J];

      BW := AL[J];
      if BW = 0 then BW := 10E-10; {Rochedo}
      if (Par.Value < (Par.LowLimit+BW)) or ((Par.HiLimit-BW) < Par.Value) then
         PW := (Par.LowLimit + BW - Par.Value) / BW // PARAMETROS NA REGIAO LIMITROFE INFERIOR
      else
         PW := (Par.Value - Par.HiLimit + BW) / BW; // PARAMETROS NA REGIAO LIMITROFE SUPERIOR

      BW := PW * PW; // Desta maneira reduzo a equação em uma multiplicação
      BW := 3.0 * PW - 4.0 * BW + 2.0 * BW * PW;

      // PENALIZA VALOR DA F-O QDO PARAMETROS SE ACHAM NA ZONA FRONTEIRICA
      Result := F + (H[J] - F) * BW;
    end;

    procedure IniciarNovoEstagio;
    var K: Integer;
    begin
      for K := 0 to FParams.Count-1 do
        begin
        // REINICIALIZA PASSO INICIAL
        if FPassoInicial then FParams[K].Step := EINT[K];

        // INICIALIZA D[k] : ALTERACAO TOTAL DA VARIAVEL NO ESTAGIO CORRENTE
        D[K]                :=  0.0;
        FParams[K].StatusFO :=  ' ';
        PriVez[K]           :=  True;
        end;
    end;

    Procedure IniciarCicloDeParametros;
    var K: Integer;
        Par: TrbParameter;
    begin
      Ciclo := 0; // INICIO DE CICLO DE VARIACAO DE PARAMETROS
      FParams.ActivePar := 0;

      for K := 0 to FParams.Count-1 do
        begin
        Par := FParams[K];
        MARCA[K] := 1;

        // EVITA INSENSIBILIDADE DO PARAMETRO NAO ACEITANDO PASSO NULO
        if Par.Step = 0.0 then Par.Step := FTL_ABS[K];

        // SE VALOR INICIAL É MÁXIMO FAZ PASSO NEGATIVO
        if Abs(Par.Value - Par.HiLimit) < 10E-15 then
           Par.Step := - Par.Step;
        end;
    end;

    Function ParametrosAtingiramZonaDePrecisao: Boolean;
    var K: Integer;
    begin
      Result := True;
      for K := 0 to FParams.Count-1 do
        if ABS(FParams[K].Step) >= FTL_ABS[K] then
           Begin
           Result := False; // Continua
           Break;
           end;
    end;

    procedure IncremantaParametros;
    var K: Integer;
    begin
      // VERIFICA SE CONDICAO DE VALE FOI OBTIDA APROXIMADAMENTE
      MARCA[Ciclo] := 2;

      for K := 0 to FParams.Count-1 do
        begin
        // ALTERACAO UNIVARIACIONAL DOS PARAMETROS
        FParams[K].Value := FParams[K].Value + FParams[Ciclo].Step * V[Ciclo,K];

        // GUARDA MELHOR VALOR DA F-O  NO ESTAGIO ATUAL
        H[K] := FO;
        end;
    end;

    procedure IncrementarCiclo;
    begin
      inc(Ciclo);
      FParams.ActivePar := Ciclo;
    end;

    function FimDoCiclo: Boolean;
    begin
      if TodosParametrosSaoVale then
         // VALE ENCONTRADO : FINAL DAS COMPUTACOES DESTE ESTAGIO
         // VERIFICA INICIALMENTE SE OTIMO FOI ATINGIDO
         if ABS(FBEST - FO) < FTol_FO_ABS then
            Result := True
         else
            begin
            RotacionaEixo;
            IniciarNovoEstagio;
            IniciarCicloDeParametros;
            Result := ParametrosAtingiramZonaDePrecisao;
            IncremantaParametros;
            end
      else // VERIFICA SE TODOS OS PARÂMETROS FORAM MODIFICADOS
         if Ciclo = FParams.Count-1 then
            begin
            IniciarCicloDeParametros;
            Result := ParametrosAtingiramZonaDePrecisao;
            IncremantaParametros;
            end
         else
            begin
            IncrementarCiclo;
            IncremantaParametros;
            Result := False;
            end
    end; //FimDoCiclo

    function TerminaPorFalha(Tipo: TipoFalha): Boolean;
    var K : Integer;
    begin
      if UmaSimulacao then
         begin
         for K := 0 to FParams.Count-1 do
           FParams[K].Value := FParams[K].Value - FParams[Ciclo].Step * V[Ciclo,K];

         // SOLUCAO PIOROU : MUDA SENTIDO DA VARIACAO E CONTRAI O PASSO PELA METADE
         FParams[Ciclo].Step := - FDecPasso * FParams[Ciclo].Step;

         Calcula_Passo_Evitando_Inviabilidade;
         if Tipo = tfIneficiencia then
            if FParams[Ciclo].StatusFO = 'M' then FParams[Ciclo].StatusFO := 'V';

         Result := FimDoCiclo;
         end
      else
         Result := True;
    end;

    function CanTerminate: Boolean;
    begin
      Result := (FTerminated or
                (KOUNT > FMS-2) or
                ((GetTickCount - TM) > FMTS));
    end;

    procedure IncrementarSimulacao;
    begin
      inc(KOUNT);
      FFormManager.Simulation := KOUNT;
    end;

var Par: TrbParameter;

begin // Inicio de Rosenbrock.Execute
  Inicializacoes;
  IniciarNovoEstagio;
  IniciarCicloDeParametros;

  if Not ParametrosAtingiramZonaDePrecisao then
     begin
     IncremantaParametros;
     Repeat
       if ParametrosViaveis then
          begin
          UmaSimulacao := True;
          IncrementarSimulacao;

          F := FGeralFunction(FParams);
          Self.FO := F;

          DoVisualUpdate;
          ProcessMessages;

          F_Igual_FO := (Abs(F - FO) < FTol_FO_ABS);
          if (F > FO) or (F_Igual_FO and not PriVez[Ciclo]) then
             if TerminaPorFalha(tfIneficiencia) then Break else Continue
          else
             if F_Igual_FO then PriVez[Ciclo] := False;

          // Verifica Zona Fronteirica e Melhoramento na FO
          J := 0;
          Melhorou := True;
          repeat
            Par := FParams[J];
            if (Par.Value < (Par.LowLimit + AL[J])) or
               (Par.Value > (Par.HiLimit - AL[J])) then
               begin
               F := Calcula_Fp;
               if F >= FO then
                  begin
                  Melhorou := False; {PIOROU !!}
                  Break;
                  end;
               end
            else
               H[J] :=  F; // Armazena novo valor melhor que anterior

            inc(J);
          until J = FParams.Count;

          if Melhorou then
             begin
             Par := FParams[Ciclo];

             D[Ciclo] := D[Ciclo] + Par.Step;
             Par.Step := FIncPasso * Par.Step;

             Calcula_Passo_Evitando_Inviabilidade;

             // MELHOR RESULTADO É REGISTRADO EM FO, SENDO FO GUARDADO ANTES
             // PARA TESTAR SE VALE FOI ENCONTRADO NA APROXIMACAO
             FO := F;
             if Par.StatusFO =  ' ' then Par.StatusFO := 'M';
             if FimDoCiclo then Break;
             end
          else
             if TerminaPorFalha(tfIneficiencia) then Break;
          end
       else
          if TerminaPorFalha(tfInviabilidade) then Break;

       until CanTerminate;
     end; // if Not ParametrosAtingiramZonaDePrecisao ...

  Finalizacoes;
end;

procedure TRosenbrock.ProcessMessages;
var MSG: TMSG;
begin
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
     if Msg.Message <> WM_QUIT then
        begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
        end;
end;

procedure TRosenbrock.DoVisualUpdate;
begin
  if (FFormFO <> nil) then FFormFO.FO := FO;

  if @FVisualProc <> nil then
     FVisualProc(
       FParams,          // Parâmetros
       FO,               // Valor da função objetivo recentemente calculado
       KOUNT,            // n Simulações ocorridas
       NumEstagio);      // n Estágios ocorridos
end;

procedure TRosenbrock.SetDecPasso(const Value: Real);
begin
  if (Value < 0) or (Value > 1) then
     FDecPasso := 0.5
  else
     FDecPasso := Value;
end;

procedure TRosenbrock.SetIncPasso(const Value: Real);
begin
  if (Value < 0) then
     FIncPasso := 3.0
  else
     FIncPasso := Value;
end;

procedure TRosenbrock.SetTOL(const Value: Real);
begin
  if (Value < 0) or (Value > 1) then
     FTOL := 0.001
  else
     FTOL := Value;
end;

procedure TRosenbrock.Stop;
begin
  FTerminated := True;
end;

procedure TRosenbrock.ShowFO(aLeft, aTop: Integer);
begin
  if FFormFO = nil then
     begin
     FFormFO := TrbFormFO.Create(self);
     FFormFO.FO := FO;
     end;

  FFormFO.Left := aLeft;
  FFormFO.Top := aTop;
  FFormFO.Show;
  FFormFO.Clear;
end;

procedure TRosenbrock.ShowManager(aLeft, aTop: Integer);
begin
  FFormManager.Left := aLeft;
  FFormManager.Top := aTop;
  FFormManager.Show;
end;

{ TrbParameter }

Constructor TrbParameter.Create(const aName       : String;
                                const aLowLimit   : Real;
                                const aHiLimit    : Real;
                                const aStep       : Real;
                                const aTolerance  : Real);
begin
  inherited Create;
  FName      := aName;
  FLowLimit  := aLowLimit;
  FHiLimit   := aHiLimit;
  FStep      := aStep;
  FTolerance := aTolerance;
end;

destructor TrbParameter.Destroy;
begin
  FLink.Free;
  FFormPar.Free;
  Inherited;
end;

procedure TrbParameter.SetValue(const Value: Real);
begin
  if FLink <> nil then
     FLink.Optimizeble.Optimizer_SetValue(FLink.PropName, FLink.Year, FLink.Month, Value)
  else
     FValue := Value;

  if FFormPar <> nil then
     FFormPar.Value := Value;

  FManagerFrame.Value := Value;
end;

function TrbParameter.GetValue: Real;
begin
  if FLink <> nil then
     Result := FLink.Optimizeble.Optimizer_GetValue(FLink.PropName, FLink.Year, FLink.Month)
  else
     Result := FValue;
end;

procedure TrbParameter.SetHiLimit(const Value: Real);
begin
  FHiLimit := Value;
  FManagerFrame.HiLimit := Value;
  if (FFormPar <> nil) then
     FFormPar.HiLimit := Value;
end;

procedure TrbParameter.SetLowLimit(const Value: Real);
begin
  FLowLimit := Value;
  FManagerFrame.LowLimit := Value;
  if (FFormPar <> nil) then
     FFormPar.LowLimit := Value;
end;

procedure TrbParameter.SetName(const Value: String);
begin
  FName := Value;
  FManagerFrame.ParName := Value;
  if (FFormPar <> nil) then
     FFormPar.ParName := Value;
end;

procedure TrbParameter.SetStep(const Value: Real);
begin
  FStep := Value;
  FManagerFrame.StepLen := Value;
  if (FFormPar <> nil) then
     FFormPar.Step := Value;
end;

procedure TrbParameter.SetTolerance(const Value: Real);
begin
  FTolerance := Value;
  if (FFormPar <> nil) then
     FFormPar.Tolerance := Value;
end;

procedure TrbParameter.Show(Left, Top: Integer);
begin
  if FFormPar = nil then
     FFormPar := TrbFormParameter.Create(Self);

  FFormPar.Left  := Left;
  FFormPar.Top   := Top;

  with FFormPar do
    begin
    ParName    := FName;
    Value      := FCurrentValue;
    LowLimit   := FLowLimit;
    HiLimit    := FHiLimit;
    Step       := FStep;
    Tolerance  := FTolerance;
    Show;
    end;
end;

procedure TrbParameter.setLink(aObj: TObject; const aPropName: string; aYear, aMonth: Integer);
var i: IOptimizer;
begin
  if aObj.GetInterface(IOptimizer, i) then
     begin
     if FLink = nil then FLink := TrbLink.Create;
     FLink.Optimizeble := i;
     FLink.PropName := aPropName;
     FLink.Year := aYear;
     FLink.Month := aMonth;
     end
  else
     raise Exception.CreateFmt(
       'a Classe <%s> não implementa a interface <IOptimizer>', [aObj.ClassName]);
end;

procedure TrbParameter.SetStatusFO(const Value: Char);
begin
  FStatusFO := Value;
  FManagerFrame.StatusFO := Value;
  if (FFormPar <> nil) then
     FFormPar.StatusFO := Value;
end;

procedure TrbParameter.SetColor(const Value: TColor);
begin
  FManagerFrame.Color := Value;
end;

{ TrbParameters }

constructor TrbParameters.Create(FormManager: TrbFormParMan);
begin
  inherited Create;
  FList := TList.Create;
  FFormManager := FormManager;
  FActivePar := -1;
end;

destructor TrbParameters.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

procedure TrbParameters.Clear;
var i: Integer;
begin
  for i := 0 to FList.Count-1 do
    TObject(FList[i]).Free;

  FList.Clear;
  FFormManager.Clear;
  FActivePar := -1;
end;

function TrbParameters.Add(Param: TrbParameter): Integer;
begin
  FList.Add(Param);
  Param.FManagerFrame := FFormManager.CreateFrame(FList.Count);
  Param.FManagerFrame.Tag := integer(Param);
end;

function TrbParameters.getCount: Integer;
begin
  Result := FList.Count;
end;

function TrbParameters.GetPar(i: Integer): TrbParameter;
begin
  Result := TrbParameter(FList[i]);
end;

function TrbParameters.ParamByName(const Name: String): TrbParameter;
var i: Integer;
begin
  for i := 0 to FList.Count-1 do
    begin
    Result := TrbParameter(FList[i]);
    if CompareText(Result.Name, Name) = 0 then Exit;
    end;

  Result := nil;
end;

function TrbParameters.CreateParameter: TrbParameter;
begin
  FFormManager.Visible := False;
  Result := TrbParameter.Create;
  Add(Result);
end;

procedure TrbParameters.SetActivePar(const Value: Integer);
begin
  if Value <> FActivePar then
     begin
     if FActivePar > -1 then GetPar(FActivePar).Color := clBlue;
     GetPar(Value).Color := clRed;
     FActivePar := Value;
     end;
end;

end.
