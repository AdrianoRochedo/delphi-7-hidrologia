unit Graf_DuplaMassa_OPT;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Buttons, ExtCtrls,
  CH_Const, CH_Tipos,
  wsVec, FramePeriodosValidos;

type
  TGRF_DuplaMassa = class(TForm)
    Label2: TLabel;
    lbPostos: TListBox;
    Label3: TLabel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    edPE: TEdit;
    Bevel1: TBevel;
    Label5: TLabel;
    sbAddPM: TBitBtn;
    sbSubPM: TBitBtn;
    lbPM: TListBox;
    Bevel2: TBevel;
    sbPE: TBitBtn;
    PV: TFrame_PeriodosValidos;
    procedure btnSelClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbPEClick(Sender: TObject);
    procedure sbAddPMClick(Sender: TObject);
    procedure sbSubPMClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FInfo: TDSInfo;
    procedure Plotar(v1, v2: TwsVec);
  public
    constructor Create(Info: TDSInfo);
  end;

implementation
uses CH_Procs, WinUtils, DialogsEx, wsMatrix,
     Form_Chart, Series, SysUtilsEx;

{$R *.DFM}

constructor TGRF_DuplaMassa.Create(Info: TDSInfo);
begin
  Inherited Create(nil);
  FInfo := Info;
end;

procedure TGRF_DuplaMassa.btnSelClick(Sender: TObject);
var i: Integer;
begin
  i := lbPostos.ItemIndex;
  if i > -1 then
     begin
     edPE.Text := lbPostos.Items[i];
     lbPostos.Items.Delete(i);
     end;
end;

procedure TGRF_DuplaMassa.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TGRF_DuplaMassa.FormShow(Sender: TObject);
begin
  PV.Mostrar(FInfo);
  FInfo.MostrarPostos(lbPostos.Items);
end;

procedure TGRF_DuplaMassa.btnLimparClick(Sender: TObject);
begin
  edPE.Text := '';
  FInfo.MostrarPostos(lbPostos.Items);
end;

procedure TGRF_DuplaMassa.Plotar(v1, v2: TwsVec);
var G: TfoChart;
    S: TPointSeries;
    i: Integer;
begin
  G := TfoChart.Create(' Dupla Massa');
  G.Chart.View3D := False;

  G.Chart.Title.Alignment := taLeftJustify;
  G.Chart.Title.Text.Add('Período: ' + PV.meDI.Text + ' - ' + PV.meDF.Text);
  G.Chart.Title.Text.Add('Posto para Exame: ' + edPE.Text);
  G.Chart.Title.Text.Add('Média: ' + StringsToString(lbPM.Items, ','));

  {
  G.Series.AdicionaSerieDePontos('PE - ' + edPE.Text, clRED, v1).Pointer.Style := psSmallDot;
  G.Series.AdicionaSerieDePontos('Média', clBLUE, v2).Pointer.Style := psSmallDot;
  }
  S := G.Series.AddPointSerie('Média X ' + edPE.Text, clRED);
  S.Pointer.Style := psCircle;
  for i := 1 to v1.Len do S.AddXY(v2[i], v1[i]);

  G.Series.Add45DegreeLine('Referência', clBLUE);
  G.Series.AddTendencyLine('Tendência', clBLACK, S);
  G.Show(fsMDIChild);
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
  LI := Finfo.IndiceDaData(PV.meDI.Text);
  LF := Finfo.IndiceDaData(PV.meDF.Text);

  if edPE.Text = '' then
     ShowErrorAndGoto(['Escolha um posto para Exame'], edPE);

  if lbPM.Items.Count = 0 then
     Raise Exception.Create('Escolha pelo menos um posto para a média');

  SetLength(PMs, lbPM.Items.Count);
  for i := 0 to lbPM.Items.Count-1 do
    PMs[i] := FInfo.DS.Struct.IndexOf(GetValidID(lbPM.Items[i]));

  Cols := FInfo.NumPostos-1;
  ds   := FInfo.DS;
  v    := TwsSFVec.Create(LF-LI+1);
  vPE  := TwsSFVec.Create(LF-LI+1);

  StartWait;
  try
    // Acumulo o posto para exame
    ii := 1;
    k := ds.Struct.IndexOf(GetValidID(edPE.Text));
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
      m := 0;
      for j := 0 to High(PMs) do
        m := m + ds[i, PMs[j]];

      inc(ii);
      x := x + m / Length(PMs);
      v[ii] := x;
      end;

    // Ploto o acumulado do posto de exame contra o acumulado da média
    Plotar(vPE, v);
  finally
    StopWait;
    v.Free;
    vPE.Free;
  end;
end;

procedure TGRF_DuplaMassa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGRF_DuplaMassa.sbPEClick(Sender: TObject);
begin
  if lbPostos.ItemIndex > -1 then
     edPE.Text := lbPostos.Items[lbPostos.ItemIndex];
end;

procedure TGRF_DuplaMassa.sbAddPMClick(Sender: TObject);
begin
  AddElemToList(lbPostos, lbPM, False);
end;

procedure TGRF_DuplaMassa.sbSubPMClick(Sender: TObject);
begin
  DeleteElemFromList(lbPM, VK_DELETE);
end;

procedure TGRF_DuplaMassa.FormCreate(Sender: TObject);
begin
  AjustResolution(Self);
end;

end.
