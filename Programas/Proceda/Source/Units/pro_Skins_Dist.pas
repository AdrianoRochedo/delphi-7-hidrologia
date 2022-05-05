unit pro_Skins_Dist;

interface
uses Classes,
     SysUtils,
     Graphics,
     Skin,
     wsMatrix,
     wsVec,
     XML_Interfaces,
     Form_Chart,
     Series,
     GraphicUtils,
     wsConstTypes,
     wsBXML_OutPut,
     wsProbabilidade,
     pro_Classes,
     pro_Application;

type
  // Classe intermediária para ajustamento de distribuicoes
  TSkinDist_Base = class(TSkin)
  private
    FPlotGraph : boolean;         // Constroi grafico de probabilidade?
    FReturn    : boolean;         // Obtem valores para tempo de retorno?
    FIFN       : boolean;         // Constroi formato nulo?
    FSE        : boolean;         // Constroi envelope?
    FImpData   : boolean;         // Imprime quantis?
    FImpEst    : boolean;         // Imprime estimativas?
    FCC        : Real;            // Constante c para probabilidades empiricas
    FPT        : byte;            // Modo de informacao para os parametros
    FDist      : TwsProbCont;     // Qualquer distribuicao continua
    FFitTest   : byte;            // Teste para o ajustamento
    FIType     : byte;            // Tipo de intervalo
    FkFix      : Integer;         // numero de intervalos, fixado
    FProp      : TwsVec;          // vetor com as proporcoes distintas para as classes
    FTit1      : string;           // Titulo para as saidas
    FTit2      : string;          // Titulo para as saidas
    FParArray  : array of Double; // Parametros
    FMR        : TwsGeneral;      // Matriz com magnitudes para tempos de retorno
    FOutPut    : TwsBXML_Output;  // Utilizado para a geracao do relatorio
    FSerie     : TSerie;          // Serie onde estao os dados
    FVec       : TwsDFVec;
    FChart: TfoChart;        // Vetor de dados a ser analisado

    destructor Destroy(); override;
  protected
    procedure getDataFromDialog(); override;
    procedure initDialog(); override;

    { Sobrescreva este metodo para criar uma janela especifica para cada distribuição e cada
      numero de parametros }
    procedure InitDist(); virtual;

    // Adiciona um item ao relatorio deste objeto
    procedure AddInReport(const aObj: array of iToBXML);
  public
    constructor Create(const Tipo: string);

    function Execute(): integer; override;

    // Gerador de relatorio, devera ser associado pelo usuario
    property Report : TwsBXML_Output read FOutPut write FOutPut;

    // Outras propriedades
    property NullFormat : boolean  read FIFN   write FIFN;
    property Envelope   : boolean  read FSE    write FSE;
    property cConst     : Real     read FCC    write FCC;
    property ParType    : byte     read FPT    write FPT;
    property Serie      : TSerie   read FSerie write FSerie;
    property Vector     : TwsDFVec read FVec   write FVec;
    property Chart      : TfoChart read FChart write FChart;
  end;

  // Classe intermediária
  TSkinDist_WithParameters = class(TSkinDist_Base)
  protected
    procedure GetDataFromDialog(); override;
    procedure initDialog(); override;
  end;

  // Classe intermediária
  TSkinDist_OneParameter = class(TSkinDist_WithParameters)
  private
    FP1: Real;
  protected
    procedure GetDataFromDialog(); override;
    procedure initDialog(); override;
    function createDialog(): TDialog; override;
  public
    property P1 : Real read FP1;
  end;

  // Classe intermediária
  TSkinDist_TwoParameters = class(TSkinDist_OneParameter)
  private
    FP2: Real;
  protected
    procedure GetDataFromDialog(); override;
    procedure initDialog(); override;
    function createDialog(): TDialog; override;
  public
    property P2 : Real read FP2;
  end;

  // Classe intermediária
  TSkinDist_TreeParameters = class(TSkinDist_TwoParameters)
  private
    FP3: Real;
  protected
    procedure GetDataFromDialog(); override;
    procedure initDialog(); override;
    function createDialog(): TDialog; override;
  public
    property P3 : Real read FP3;
  end;

  // Instanciável
  TSkinDist_Normal = class(TSkinDist_TwoParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  end;

  // Instanciável
  TSkinDist_LogPearson3 = class(TSkinDist_TreeParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  end;

  // Instanciável
  TSkinDist_LogNormal2 = class(TSkinDist_TwoParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  end;

  // Instanciável
  TSkinDist_LogNormal3 = class(TSkinDist_TreeParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  end;

  // Instanciável
  TSkinDist_Gumbel = class(TSkinDist_TwoParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  end;

(*
  // Instanciavel
  TSkinDist_StdNormal = class(TSkinDist_Base)
  protected
    function createDialog(): TDialog; override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_HalfNormal = class(TSkinDist_OneParameter)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Exponential = class(TSkinDist_OneParameter)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Exponential2 = class(TSkinDist_TwoParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Gamma = class(TSkinDist_OneParameter)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Gamma2 = class(TSkinDist_TwoParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Gamma3 = class(TSkinDist_TreeParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_ChiSqr = class(TSkinDist_OneParameter)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Uniforme = class(TSkinDist_TwoParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_StdWeibull = class(TSkinDist_OneParameter)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Weibull = class(TSkinDist_TwoParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_Weibull3 = class(TSkinDist_TreeParameters)
  protected
    procedure initDialog(); override;
    procedure InitDist(); override;
  public
  end;

  // Instanciável
  TSkinDist_StdGumbel = class(TSkinDist_Base)
  protected
    function createDialog(): TDialog; override;
    procedure InitDist(); override;
  public
  end;
*)

implementation

uses Dialogs,
     Forms,
     wsGLib,
     wsGraficos,
     wsFuncoesDeDataSets,
     SysUtilsEx,
     fo_SkinDistBase,
     fo_SkinDist_WithParameters,
     fo_SkinDist_OneParameter,
     fo_SkinDist_TwoParameters,
     fo_SkinDist_TreeParameters;
{
     GRF_Dist_ThreeParameters;
}

{ TSkinDist_Base }

destructor TSkinDist_Base.Destroy;
begin
  FDist.Free();
  inherited;
end;

procedure TSkinDist_Base.GetDataFromDialog();
var v: TwsVec;
    i: Integer;
begin
  with TfoSkinDistBase(Dialog) do
    begin
    FImpEst := cbImpEst.Checked;
    FPlotGraph := cbGraph.Checked;

    FReturn := cbReturn.Checked;
    if FReturn then
       begin
       if Assigned(FMR) then FMR.Free();
       v := StrVec(drReturn.Text);
       v.Name := 'Periodos';
       FMR := TwsGeneral.Create(0, v.Len);
       for i := 1 to v.Len do
         FMR.ColName[i] := 'T' + IntToStr(i);
       FMR.Name := 'Y_Ret';
       FMR.MLab := 'Magnitudes para os períodos de retorno especificados';
       FMR.MAdd(v);
       end
    else
       FMR := nil;

    FIFN := cbIFN.Checked;
    FSE := cbSE.Checked;
    FImpData := cbImpr.Checked;

    FCC := wsGLib.FracToReal(edCC.AsString);

    FFitTest := rgTestes.ItemIndex;          // Teste para o ajustamento

    FIType := rgNInt.ItemIndex;              // Tipo de intervalo
    if FIType = 1 then
       FkFix := StrToInt(edFix.AsString)     // numero de intervalos, fixado
    else
       if FIType = 2 then
          FProp := StrVec(edPropDist.AsString)  // vetor com as proporcoes distintas para as classes
      else
        FkFix := 0;
    end;
end;

procedure TSkinDist_Base.initDialog();
var i: Integer;
begin
  inherited initDialog();

  with TfoSkinDistBase(Dialog) do
    begin
    cbImpEst.Checked := FImpEst;
    cbGraph.Checked := FPlotGraph;
    cbReturn.Checked := FReturn;

    drReturn.Enabled := FReturn;
    if FReturn and (FMR <> nil) then
       drReturn.Text := FMR.Row[1].VecAsString
    else
       drReturn.Text := '2 5 10 20 50 100';

    cbIFN.Enabled := FPlotGraph;
    cbIFN.Checked := FIFN;

    cbSE.Enabled := FPlotGraph;
    cbSE.Checked := FSE;

    cbImpr.Enabled := FPlotGraph;
    cbImpr.Checked := FImpData;

    edCC.AsFloat  := 0.375;
    rgTestes.ItemIndex := 0;          // Teste para o ajustamento

    rgNInt.ItemIndex := FIType;              // Tipo de intervalo
    if FIType = 1 then
       edFix.AsString := IntToStr(FkFix);     // numero de intervalos, fixado

    if FIType = 2 then
       edPropDist.AsString := FProp.VecAsString; // vetor com as proporcoes distintas para as classes
    end;
end;

function TSkinDist_Base.Execute(): integer;
const
  MaxIt = 25;
  eps   = 1.E-7;
var
  Graph   : TfoChart;
  i,j,k   : integer;
  mi, mf  : double;
  S,MPar  : TwsGeneral;
  Iter,T,R: TwsGeneral;
  st      : String;
  Err     : Integer;
  ls      : TLineSeries;
  cor     : TColor;
  v       : TwsDFVec;
begin
  result := inherited Execute();

  if FSerie = nil then
     begin
     Dialogs.MessageDLG('"Série não informada', mtError, [mbOk], 0);
     FOk := false;
     Exit;
     end;

  {TODO 1 -cMelhoramentos: VEC: transformar em metodo}

  // v contem somente dados validos, into eh, sem os valores perdidos ...

  // Conta o numero de elementos validos
  k := 0;
  for i := 1 to FVec.Len do
    if not FVec.IsMissValue(i, mi) then
       inc(k);

  // Copia os valores validos
  v := TwsDFVec.Create(k);
  v.Name := FVec.Name;
  k := 0;
  for i := 1 to FVec.Len do
    if not FVec.IsMissValue(i, mi) then
       begin
       inc(k);
       v[k] := mi;
       end;

  try
    InitDist();

    if FOutPut <> nil then
       begin
       FOutPut.Title := FSerie.NomeCompleto;
       FOutPut.BeginText();
       FOutPut.WritePropValue('Distribuição:', FTit1);
       case ParType of
         1: st := 'Não foram especificados valores';
         2: st := 'Estimados pelo Método dos Momentos';
         3: st := 'Estimados pelo Método da Máxima Verossimilhança';
         4: st := 'Com valores especificados';
         end; // case
       FOutPut.WritePropValue('Parâmetros:', st);
       FOutPut.CenterTitle(3, FSerie.NomeCompleto);
       FOutPut.EndText();
       end;

    MPar := nil;
    Iter := nil;
    Graph := nil;
    S := nil;
    Err := 0;

    FOutPut.BeginText();
    FOutPut.CenterTitle(3, 'Análise da Variável: ' + v.Name);
    FOutPut.EndText();

    // Parametros
    case ParType of
      2: begin
         FDist.MomentEst(v);                      // obtem estimativas pelo MM
         FDist.MoReturnPeriods(v, FMR);
         end;

      3: begin
         FDist.MLE(v, Iter, Err, eps, True, MaxIt);    // obtem estimativas pelo MV
         FDist.ReturnPeriods(v, FMR);
         end;

      1, 4: FDist.SetPar(FParArray);               // atribui valores especificados
      end; // case

    if Err = 0 then       // MV convergiu?
       begin
       // imprime as estimativas?
       if FImpEst then
         begin
         FDist.Descriptive(MPar);      // obtem medidas descritivas
         MPar.MLab := MPar.MLab + '  n = ' + IntToStr(v.Len);
         AddInReport([Iter, MPar, FDist.Cov]);
         FreeAndNil(MPar);
         end;

       // Insere periodos de retorno no relatorio
       AddInReport([FMR]);

       // Faz teste de aderência ?
       if FFitTest > 0 then
          begin
          if FFitTest = 1 then          // qui-quadrado
             begin
             if (FIType = 0) or (FIType = 1) then
                T := FDist.ChiSqrTest(v, R, FkFix)
             else
                T := FDist.ChiSqrTest(v, R, 0, FProp);
             end
          else
             if FFitTest = 2 then        // kolmogorov-smirnov
                R := FDist.KSTest(v, T)
             else
                if FFitTest = 3 then        // anderson-darling
                   R := FDist.ADTest(v, T);

          AddInReport([R, T]);
          R.Free();
          T.Free();
          end;

       // Faz grafico de probabilidade?
       if FPlotGraph then
         begin
         Graph := FDist.QQPlot(v, NullFormat, Envelope, cConst, {out} S);
         Graph.Caption := FTit1;
         Graph.Chart.Title.Text.Add(FTit1 + ' ' + FSerie.NomeCompleto);
         Graph.Chart.BottomAxis.Title.Caption := FTit2;

         AddInReport([Graph]);
         Applic.SetupChart(Graph.Chart);
         Graph.Show(fsMDIChild);
         Applic.ArrangeChildrens();

         // imprime os dados e quantidades associadas?
         if FImpData then
           begin
           for k := 1 to S.nCols do S.ColName[k] := 'Obs_' + IntToStr(k);
           AddInReport([S]);
           end;

         // 1.Linha de S --> v ordenado (vData) --> Y
         // 2.Linha de S --> Quantis ordenado (xData) --> X

         if FChart <> nil then
            begin
            cor := SelectColor(FChart.Series.Count);

            FChart.Series.AddPointSerie(
              Serie.NomeCompleto, cor, S.Row[2] {X}, S.Row[1] {Y});

            // (Menor Valor, Menor Valor) - (Maior Valor, Maior Valor) de S.Row[2] {X} com a mesma cor acima
            S.Row[2].MinMax(mi, mf);
            ls := FChart.Series.AddLineSerie('Formato nulo', cor);
            ls.AddXY(mi, mi);
            ls.AddXY(mf, mf);
            ls.ShowInLegend := false;
            ls.Marks.Visible := false;
            end;

         // Libera S
         S.Free();
         end  // if FPlotGraph
       end // if Err
    else
       ShowMessage('Não houve convergência na estimativa por Máxima Verossimilhança');

    Iter.Free();
  finally
    v.Free();
  end;  
end;

procedure TSkinDist_Base.AddInReport(const aObj: array of iToBXML);
var i: Integer;
begin
  for i := 0 to High(aObj) do
    if aObj[i] <> nil then
       FOutPut.Add(aObj[i]);
end;

procedure TSkinDist_Base.InitDist();
begin
  VirtualError(self, 'InitDist()');
end;

constructor TSkinDist_Base.Create(const Tipo: string);
begin
  inherited Create(Tipo);

  FPlotGraph := true;
  FReturn    := true;
  FIFN       := true;
  FSE        := true;
  FImpData   := true;
  FImpEst    := true;
end;

{ TSkinDist_WithParameters }

procedure TSkinDist_WithParameters.GetDataFromDialog();
begin
  inherited;
  with TfoSkinDist_WithParameters(Dialog) do
    begin
    if r1.Checked then FPT := 1 else
    if r2.Checked then FPT := 2 else
    if r3.Checked then FPT := 3 else
    if r4.Checked then FPT := 4;
    end;
end;

procedure TSkinDist_WithParameters.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_WithParameters(Dialog) do
    begin
    if FPT = 1 then r1.Checked := true else
    if FPT = 2 then r2.Checked := true else
    if FPT = 3 then r3.Checked := true else
    if FPT = 4 then r4.Checked := true;
    end;
end;

{ TSkinDist_OneParameter }

function TSkinDist_OneParameter.createDialog(): TDialog;
begin
  Result := internalCreateDialog(TfoSkinDist_OneParameter);
end;

procedure TSkinDist_OneParameter.GetDataFromDialog();
begin
  inherited;
  with TfoSkinDist_OneParameter(Dialog) do
    begin
    FP1 := edP1.AsFloat;
    end;
end;

procedure TSkinDist_OneParameter.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_OneParameter(Dialog) do
    begin
    edP1.AsFloat := FP1;
    end;
end;

{ TSkinDist_TwoParameters }

function TSkinDist_TwoParameters.createDialog(): TDialog;
begin
  Result := internalCreateDialog(TfoSkinDist_TwoParameters);
end;

procedure TSkinDist_TwoParameters.GetDataFromDialog();
begin
  inherited;
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    FP2 := edP2.AsFloat;
    end;
end;

procedure TSkinDist_TwoParameters.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    edP2.AsFloat := FP2;
    end;
end;

{ TSkinDist_Normal }

procedure TSkinDist_Normal.InitDist();
{ Inicializa distribuição Normal }
begin
  FDist := TwsProbNormal.Create();     // Cria a distribuicao
  if ParType = 4 then
    begin
    System.SetLength(FParArray, 2);
    FParArray[0] := Fp1; // Media
    FParArray[1] := Fp2; // Dispersao
    end;
  FTit1 := 'Modelo Normal de Probabilidades';
  FTit2 := 'Quantis Normal';
end; // TSkinDist_Normal.InitDist()

procedure TSkinDist_Normal.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    lap1.Caption := 'Posição (Média):';
    lap2.Caption := 'Dispersão (Desv.Padr):';
    end;
end;

(*
{ TSkinDist_NormalPadrao }

function TSkinDist_StdNormal.createDialog(): TDialog;
begin
  Result := internalCreateDialog(TfoGRF_ProbDist);
end;

procedure TSkinDist_StdNormal.InitDist();
{ Inicializa distribuição uniforme }
begin
  FDist := TwsProbStdNormal.Create;           // Cria a distribuicao
  FTit1 := 'Modelo Normal Padrão de Probabilidades';
  FTit2 := 'Quantis Normais';
end; // TSkinDist_StdNormal.InitDist()
*)

{ TSkinDist_TreeParameters }

function TSkinDist_TreeParameters.createDialog: TDialog;
begin
  Result := internalCreateDialog(TfoSkinDist_TreeParameters);
end;

procedure TSkinDist_TreeParameters.GetDataFromDialog;
begin
  inherited;
  with TfoSkinDist_TreeParameters(Dialog) do
    begin
    FP3 := edP3.AsFloat;
    end;
end;

procedure TSkinDist_TreeParameters.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TreeParameters(Dialog) do
    begin
    edP3.AsFloat := FP3;
    end;
end;

(*

{ TSkinDist_Uniforme }

procedure TSkinDist_Uniforme.InitDist();
{ Inicializa distribuição uniforme }
begin
  FDist:=TwsProbUniform.Create;           // Cria a distribuicao
  if (ParType=4) or (ParType=1) then
    begin
    System.SetLength(FParArray, 2);
    if ParType=4 then
      begin
      FParArray[0]:=Fp1;                   // Minimo
      FParArray[1]:=Fp2;                   // Maximo
      end
    else
      begin
      FParArray[0]:=0;                   // Minimo
      FParArray[1]:=1;                   // Maximo
      end
    end;
  FTit1:='Modelo Uniforme de Probabilidades';
  FTit2:='Quantis Uniformes';
end; // TSkinDist_Uniforme.InitDist()

procedure TSkinDist_Uniforme.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    lap1.Caption := 'Limite Inferior:';
    lap2.Caption := 'Limite Superior:';
    end;
end;

{ TSkinDist_HalfNormal }

procedure TSkinDist_HalfNormal.InitDist();
{ Inicializa distribuição semi-normal }
begin
  FDist:=TwsProbHalfNormal.Create;           // Cria a distribuicao
  if (ParType=4) or (ParType=1) then
    begin
    System.SetLength(FParArray,1);
    if ParType=4 then
      FParArray[0]:=Fp1                   // Dispersao
    else
      FParArray[0]:=1                     // Dispersao
    end;
  FTit1:='Modelo Semi-normal de Probabilidades';
  FTit2:='Quantis semi-Normais';
end; // TSkinDist_HalfNormal.InitDist()

procedure TSkinDist_HalfNormal.initDialog;
begin
  inherited initDialog();
  TfoSkinDist_OneParameter(Dialog).lap1.Caption := 'Dispersão (Lambda):';
end;

{ TSkinDist_Exponencial }

procedure TSkinDist_Exponential.InitDist();
{ Inicializa distribuição Exponencial }
begin
  FDist:=TwsProbExponential.Create;           // Cria a distribuicao
  if (ParType=4) or (ParType=1) then
    begin
    System.SetLength(FParArray,1);
    if ParType=4 then
      FParArray[0]:=Fp1                   // Dispersao
    else
      FParArray[0]:=1                     // Dispersao
    end;
  FTit1:='Modelo Exponencial de Probabilidades';
  FTit2:='Quantis Exponenciais';
end; // TSkinDist_Exponential.InitDist()

procedure TSkinDist_Exponential.initDialog;
begin
  inherited initDialog();
  TfoSkinDist_OneParameter(Dialog).lap1.Caption:='Dispersão (Lambda):';
end;

{ TSkinDist_Gamma }

procedure TSkinDist_Gamma.InitDist();
{ Inicializa distribuição Gama }
begin
  FDist:=TwsProbGamma.Create;           // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray,1);
    FParArray[0]:=Fp1                   // Formato
    end;
  FTit1:='Modelo Gama de Probabilidades';
  FTit2:='Quantis Gama';
end; // TSkinDist_Gamma.InitDist()

procedure TSkinDist_Gamma.initDialog();
begin
  inherited initDialog();
  TfoSkinDist_OneParameter(Dialog).lap1.Caption:='Formato (Alfa):';
end;

{ TSkinDist_ChiSqr }

procedure TSkinDist_ChiSqr.InitDist();
{ Inicializa distribuição qui-quadrado }
begin
  FDist:=TwsProbChiSqr.Create;           // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray,1);
    FParArray[0]:=Fp1;                   // Dispersao
    end;
  FTit1:='Modelo Qui-quadrado de Probabilidades';
  FTit2:='Quantis Qui-quadrado';
end; // TSkinDist_ChiSqr.InitDist()

procedure TSkinDist_ChiSqr.initDialog;
begin
  inherited initDialog();
  TfoSkinDist_OneParameter(Dialog).Lap1.Caption:='Graus de Liberdade:';
end;

{ TSkinDist_Gamma_2 }

procedure TSkinDist_Gamma2.InitDist();
{ Inicializa distribuição Gama (Dois Parâmetros) }
begin
  FDist:=TwsProbGamma2.Create;           // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray,2);
    FParArray[0]:=Fp1;                   // Dispersao
    FParArray[1]:=Fp2;                   // Formato
    end;
  FTit1:='Modelo Gama de Probabilidades (Dois Parâmetros)';
  FTit2:='Quantis Gama';
end; // TSkinDist_Gamma2.InitDist()

procedure TSkinDist_Gamma2.initDialog;
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    lap1.Caption:='Dispersão (Lambda):';
    lap2.Caption:='Formato (Alfa):';
    end;
end;

{ TSkinDist_Gamma3 }

procedure TSkinDist_Gamma3.InitDist();
{ Inicializa distribuição Gama (Três Parâmetros) }
begin
  FDist:=TwsProbGamma3.Create;           // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray,3);
    FParArray[0]:=Fp1;                   // Deslocamento
    FParArray[1]:=Fp2;                   // Dispersao
    FParArray[2]:=Fp3;                   // Formato
    end;
  FTit1:='Modelo Gama de Probabilidades (Três Parâmetros)';
  FTit2:='Quantis Gama';
end; // TSkinDist_Gamma3.InitDist()

procedure TSkinDist_Gamma3.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TreeParameters(Dialog) do
    begin
    lap1.Caption:='Deslocamento (Teta):';
    lap2.Caption:='Dispersão (Lambda):';
    lap3.Caption:='Formato (Alfa):';
    end;
end;
*)

{ TSkinDist_LogPearson3 }

procedure TSkinDist_LogPearson3.InitDist();
begin
  FDist := TwsProbLogPearson3.Create;           // Cria a distribuicao
  if ParType = 4 then
    begin
    System.SetLength(FParArray,3);
    FParArray[0] := Fp1;                   // Deslocamento
    FParArray[1] := Fp2;                   // Dispersao
    FParArray[2] := Fp3;                   // Formato
    end;
  FTit1 := 'Modelo Log-Pearson de Probabilidades';
  FTit2 := 'Quantis LP3';
end; // TSkinDist_LogPearson3.InitDist()

procedure TSkinDist_LogPearson3.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TreeParameters(Dialog) do
    begin
    lap1.Caption := 'Deslocamento (Teta):';
    lap2.Caption := 'Dispersão (Lambda):';
    lap3.Caption := 'Formato (Alfa):';
    end;
end;

(*
{ TSkinDist_Exponencial2 }

procedure TSkinDist_Exponential2.InitDist();
{ Inicializa distribuição Exponencial (Dois Param) }
begin
  FDist:=TwsProbExponential2.Create;           // Cria a distribuicao
  if (ParType=4) or (ParType=1) then
    begin
    System.SetLength(FParArray,2);
    if ParType=4 then
      begin
      FParArray[0]:=Fp1;                   // Deslocamento
      FParArray[1]:=Fp2;                   // Dispersao
      end
    else
      begin
      FParArray[0]:=0;                   // Deslocamento
      FParArray[1]:=1;                   // Dispersao
      end
    end;
  FTit1:='Modelo Exponencial de Probabilidades (Dois Parâmetros)';
  FTit2:='Quantis Exponenciais';
end; // TSkinDist_Exponential2.InitDist()

procedure TSkinDist_Exponential2.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    lap1.Caption:='Deslocamento (Teta):';
    lap2.Caption:='Dispersão (Lambda):';
    end;
end;
*)

{ TSkinDist_LogNormal2 }

procedure TSkinDist_Lognormal2.InitDist();
{ Inicializa distribuição Lognormal (Dois Param) }
begin
  FDist:=TwsProbLognormal.Create;           // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray,2);
    FParArray[0]:=Fp1;                   // Dispersao
    FParArray[1]:=Fp2;                   // Formato
    end;
  FTit1:='Modelo Lognormal de Probabilidades';
  FTit2:='Quantis Lognormais';
end;

procedure TSkinDist_LogNormal2.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    lap1.Caption:='Dispersão (Lambda):';
    lap2.Caption:='Formato (Alfa):';
    end;
end;

{ TSkinDist_LogNormal3 }

procedure TSkinDist_LogNormal3.InitDist();
{ Inicializa distribuição Lognormal (Três Param) }
begin
  FDist := TwsProbLognormal3.Create;     // Cria a distribuicao
  if ParType = 4 then
    begin
    System.SetLength(FParArray,3);
    FParArray[0] := Fp1;                   // Deslocamento
    FParArray[1] := Fp2;                   // Dispersao
    FParArray[2] := Fp3;                   // Formato
    end;
  FTit1 := 'Modelo Lognormal de Probabilidades (Três Parametros)';
  FTit2 := 'Quantis Lognormais';
end; // TSkinDist_Lognormal3.InitDist()

procedure TSkinDist_LogNormal3.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TreeParameters(Dialog) do
    begin
    lap1.Caption := 'Deslocamento (Teta):';
    lap2.Caption := 'Dispersão (Lambda):';
    lap3.Caption := 'Formato (Alfa):';
    end;
end;

(*
{ TSkinDist_StdWeibull }

procedure TSkinDist_StdWeibull.InitDist();
{ Inicializa distribuição qui-quadrado }
begin
  FDist:=TwsProbStdWeibull.Create();  // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray, 1);
    FParArray[0] := Fp1;
    end;
  FTit1 := 'Modelo Weibull (Padrão) de Probabilidades';
  FTit2 := 'Quantis Weibull';
end; // TSkinDist_StdWeibull.InitDist()

procedure TSkinDist_StdWeibull.initDialog;
begin
  inherited initDialog();
  TfoSkinDist_OneParameter(Dialog).Lap1.Caption:='Formato (Alfa):';
end;

{ TSkinDist_Weibull }

procedure TSkinDist_Weibull.InitDist();
{ Inicializa distribuição Weibull (Dois Param) }
begin
  FDist:=TwsProbWeibull.Create;     // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray,2);
    FParArray[0]:=Fp1;                   // Dispersao
    FParArray[1]:=Fp2;                   // Formato
    end;
  FTit1:='Modelo Weibull de Probabilidades';
  FTit2:='Quantis Weibull';
end; // TSkinDist_Weibull.InitDist()

procedure TSkinDist_Weibull.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    lap1.Caption:='Dispersão (Lambda):';
    lap2.Caption:='Formato (Alfa):';
    end;
end;

(*
{ TSkinDist_Weibull3 }

procedure TSkinDist_Weibull3.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TreeParameters(Dialog) do
    begin
    lap1.Caption:='Deslocamento (Teta):';
    lap2.Caption:='Dispersão (Lambda):';
    lap3.Caption:='Formato (Alfa):';
    end;
end;

procedure TSkinDist_Weibull3.InitDist();
{ Inicializa distribuição Weibull (Três Param) }
begin
  {TODO 1 -cErro: Parametro alpha nao esta sendo inicializado se ParType <> 4}
  FDist:=TwsProbWeibull3.Create;     // Cria a distribuicao
  if ParType=4 then
    begin
    System.SetLength(FParArray,3);
    FParArray[0]:=Fp1;                   // Deslocamento
    FParArray[1]:=Fp2;                   // Dispersao
    FParArray[2]:=Fp3;                   // Formato
    end;
  FTit1:='Modelo Weibull de Probabilidades (Três Parâmetros)';
  FTit2:='Quantis Weibull';
end; // TSkinDist_Weibull3.InitDist()

{ TSkinDist_StdGumbel }

function TSkinDist_StdGumbel.createDialog(): TDialog;
begin
  Result := internalCreateDialog(TfoGRF_ProbDist);
end;

procedure TSkinDist_StdGumbel.InitDist();
{ Inicializa distribuição Gumbel padrão }
begin
  FDist:=TwsProbStdGumbel.Create;           // Cria a distribuicao
  FTit1:='Modelo Gumbel Padrão de Probabilidades';
  FTit2:='Quantis Gumbel';
end; // TSkinDist_StdGumbel.InitDist()
*)

{ TSkinDist_Gumbel }

procedure TSkinDist_Gumbel.InitDist();
{ Inicializa distribuição Gumbel (Dois Param) }
begin
  FDist := TwsProbGumbel.Create;     // Cria a distribuicao
  if ParType = 4 then
    begin
    System.SetLength(FParArray, 2);
    FParArray[0] := Fp1;                   // Dispersao
    FParArray[1] := Fp2;                   // Formato
    end;
  FTit1 := 'Modelo Gumbel de Probabilidades (Dois Parâmetros)';
  FTit2 := 'Quantis Gumbel';
end;

procedure TSkinDist_Gumbel.initDialog();
begin
  inherited initDialog();
  with TfoSkinDist_TwoParameters(Dialog) do
    begin
    lap1.Caption := 'Dispersão (Lambda):';
    lap2.Caption := 'Formato (Alfa):';
    end;
end;

end.
