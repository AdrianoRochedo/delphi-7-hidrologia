unit pro_fo_DoubleMass;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Buttons, ExtCtrls,
  pro_Const, pro_Classes, pro_Application,
  wsVec, pro_fr_getValidIntervals, pro_fr_StationSelections,
  pro_fr_IntervalsOfStations;

type
  TGRF_DuplaMassa = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    frame: TfrIntervalsOfStations;
    PE: TFrame_SelecaoDePostos;
    PM: TFrame_SelecaoDePostos;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FInfo: TDSInfo;
    procedure Plotar(v1, v2: TwsVec);
    procedure Frame_Change(Sender: TObject; L: TListaDePeriodos);
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses pro_Procs, WinUtils, DialogsEx, wsMatrix,
     Form_Chart, Series, SysUtilsEx;

{$R *.DFM}

constructor TGRF_DuplaMassa.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
  frame.OnChange := Frame_Change;
end;

procedure TGRF_DuplaMassa.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TGRF_DuplaMassa.FormShow(Sender: TObject);
begin
  frame.Info := FInfo;
end;

procedure TGRF_DuplaMassa.Plotar(v1, v2: TwsVec);
var G: TfoChart;
    S: TPointSeries;
    i: Integer;
begin
  G := TfoChart.Create(' Dupla Massa');
  G.Chart.View3D := False;

  G.Chart.Title.Alignment := taLeftJustify;
  G.Chart.Title.Text.Add('Período: ' + frame.sDI + ' - ' + frame.sDF);
  G.Chart.Title.Text.Add('Posto para Exame: ' + PE.PostosSel[0]);
  G.Chart.Title.Text.Add('Média: ' + StringsToString(PM.PostosSel, ','));

  S := G.Series.AddPointSerie('Média X ' + PE.PostosSel[0], clRED);
  S.Pointer.Style := psCircle;
  for i := 1 to v1.Len do
    S.AddXY(v2[i], v1[i]);

  G.Series.Add45DegreeLine('Referência', clBLUE);
  G.Series.AddTendencyLine('Tendência', clBLACK, S);

  Applic.SetupChart(G.Chart);
  G.Show(fsMDIChild);

  Applic.ArrangeChildrens();
end;

procedure TGRF_DuplaMassa.btnOkClick(Sender: TObject);
var i, j, k, ii: Integer;
    vPE, v: TwsSFVec;
    ds: TwsDataSet;
    em: byte; // É mensal
    Cols: byte; // Número de Postos - 1
    x, m: Double;
    LI, LF: Integer;
    PMs: Array of byte; // Índices dos postos selecionados para a média
begin
  LI := Finfo.IndiceDaData(frame.sDI);
  LF := Finfo.IndiceDaData(frame.sDF);

  if PE.PostosSel.Count <> 1 then
     ShowErrorAndGoto(['Escolha somente um posto para Exame'], PE);

  if PM.PostosSel.Count = 0 then
     Raise Exception.Create('Escolha pelo menos um posto para a média');

  SetLength(PMs, PM.PostosSel.Count);
  for i := 0 to PM.PostosSel.Count-1 do
    PMs[i] := FInfo.DS.Struct.IndexOf(PM.PostosSel[i]);

  Cols := FInfo.NumPostos-1;
  ds   := FInfo.DS;
  v    := TwsSFVec.Create(LF-LI+1);
  vPE  := TwsSFVec.Create(LF-LI+1);

  StartWait();
  try
    // Acumulo o posto para exame
    ii := 1;
    k := ds.Struct.IndexOf(PE.PostosSel[0]);
    vPE[1] := ds[LI, k];
    for i := LI+1 to LF do
      begin
      inc(ii);
      vPE[ii] := vPE[ii-1] + ds[i, k];
      end;

    // Calculo a média dos postos para cada dia e acumula
    x := 0;
    ii := 0;
    for i := LI to LF do
      begin
      // Calculo a soma dos n postos para cada dia
      m := 0;
      for j := 0 to High(PMs) do
        m := m + ds[i, PMs[j]];

      // Vai acumulando a média no vetor
      inc(ii);
      x := x + m / Length(PMs);
      v[ii] := x;
      end;

    // Ploto o acumulado do posto de exame contra o acumulado da média
    Plotar(vPE, v);
  finally
    StopWait();
    v.Free();
    vPE.Free();
  end;
end;

procedure TGRF_DuplaMassa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGRF_DuplaMassa.Frame_Change(Sender: TObject; L: TListaDePeriodos);
begin
  PE.setPostos(frame.PostosSel);
  PM.setPostos(frame.PostosSel);
end;

end.
