unit Graf_CExHR;

interface
                                                  
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Series, TeEngine, ExtCtrls, TeeProcs, Chart, Buttons,
  wsVec,
  wsMatrix, Frame_Planilha, StdCtrls;

type
  TGrafico_CExHR = class(TForm)
    paBotoes: TPanel;
    btnSalvar: TSpeedButton;
    btnCopiar: TSpeedButton;
    Save: TSaveDialog;
    FP: TFramePlanilha;
    paGraficos: TPanel;
    Chart2: TChart;
    Splitter: TSplitter;
    Chart1: TChart;
    L_Valor: TLabel;
    Splitter1: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnCopiarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart2ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure FPTabClick(Sender: TObject; nRow, nCol: Integer);
  private
    HR, DObs: TChartSeries;
    CE: TBarSeries;
  public
    constructor Create(TabPrecip: TwsDataSet; HidroRes, DadosObs: TwsVec);
  end;

implementation
uses Clipbrd,
     iphs1_Constantes,
     LanguageControl;

{$R *.DFM}

constructor TGrafico_CExHR.Create(TabPrecip: TwsDataSet; HidroRes, DadosObs: TwsVec);
var i: Integer;
    x: Double;
begin
  inherited Create(nil);

  // Cabeçalho das linhas
  FP.Tab.ShowRowHeading := False;
  FP.Tab.SetActiveCell(1, 1);
  FP.Tab.TextRC[1, 1] := 'Int.';
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
  for i := 1 to HidroRes.Len do
    FP.Tab.TextRC[i+1, 1] := IntToStr(i);

  // Cabeçalho das Colunas
  FP.Tab.SetActiveCell(1, 2);
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
  FP.Tab.SetActiveCell(1, 3);
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);

  if DadosObs <> nil then
     begin
     FP.Tab.SetActiveCell(1, 4);
     FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
     end;

  FP.Tab.MaxCol := 3 + byte(DadosObs <> nil);
  FP.Tab.MaxRow := HidroRes.Len + 1;

  CE := TBarSeries.Create(nil);
  CE.ParentChart := Chart2;
  CE.Marks.Visible := False;
  FP.Tab.TextRC[1, 2] := 'Pe (mm)';
  for i := 1 to HidroRes.Len do
    begin
    if i <= TabPrecip.nRows then x := TabPrecip[i, 3] else x := 0;
    CE.AddXY(i, x);
    FP.Tab.SetActiveCell(i+1, 2);
    FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
    if i <= TabPrecip.nRows then FP.Tab.Number := x else FP.Tab.Text := '----'
    end;

  HR := TLineSeries.Create(nil);
  HR.Title := 'Hidrograma Resultante';
  HR.ParentChart := Chart1;
  HR.SeriesColor := clGreen;
  FP.Tab.TextRC[1, 3] := 'Qs (m³/s)';
  for i := 1 to HidroRes.Len do
    begin
    HR.AddXY(i, HidroRes[i]);
    FP.Tab.SetActiveCell(i+1, 3);
    FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
    FP.Tab.Number := HidroRes[i];
    end;

  if DadosObs <> nil then
     begin
     DObs := TLineSeries.Create(nil);
     DObs.Title := 'Dados Observados';
     DObs.ParentChart := Chart1;
     DObs.SeriesColor := clRed;
     FP.Tab.TextRC[1, 4] := 'D.Obs.(m³/s)';
     for i := 1 to DadosObs.Len do
       begin
       DObs.AddXY(i, DadosObs[i]);
       FP.Tab.SetActiveCell(i+1, 4);
       FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
       FP.Tab.Number := DadosObs[i];
       end;
     end;
end;

procedure TGrafico_CExHR.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGrafico_CExHR.btnImprimirClick(Sender: TObject);
begin
  Self.Print;
end;

procedure TGrafico_CExHR.btnCopiarClick(Sender: TObject);
var b: TBitmap;
begin
  b := GetFormImage;
  try
    b.Height := b.Height - paBotoes.Height + 2;
    Clipboard.Assign(b);
  finally
    b.Free;
  end;  
end;

procedure TGrafico_CExHR.btnSalvarClick(Sender: TObject);
var b: TBitmap;
begin
  if Save.Execute then
     begin
     b := GetFormImage;
     try
       b.Height := b.Height - paBotoes.Height + 2;
       b.SaveToFile(Save.Filename);
     finally
       b.Free;
       end;
     end;
end;

procedure TGrafico_CExHR.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Series <> nil then
     begin
     FP.Tab.SetFocus;
     FP.Tab.SetActiveCell(ValueIndex+2, 3);
     FP.Tab.ShowActiveCell;
     FPTabClick(nil, ValueIndex+2, 3);
     end;
end;

procedure TGrafico_CExHR.Chart2ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Series <> nil then
     begin
     FP.Tab.SetFocus;
     FP.Tab.SetActiveCell(ValueIndex+2, 2);
     FP.Tab.ShowActiveCell;
     FPTabClick(nil, ValueIndex+2, 2);
     end;
end;

procedure TGrafico_CExHR.FPTabClick(Sender: TObject; nRow, nCol: Integer);
begin
  if (nRow > 0) and (nCol > 0) then
     L_Valor.Caption := LanguageManager.GetMessage(cMesID_IPH, 5) {'Valor Selecionado: '} + FP.Tab.TextRC[nRow, nCol] + '  ' +
                        LanguageManager.GetMessage(cMesID_IPH, 6) {'Delta T: '} + FP.Tab.TextRC[nRow, 1];
end;

end.
