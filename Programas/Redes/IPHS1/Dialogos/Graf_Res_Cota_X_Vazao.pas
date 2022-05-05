unit Graf_Res_Cota_X_Vazao;

interface
                                                  
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Series, TeEngine, ExtCtrls, TeeProcs, Chart, Buttons,
  wsVec,
  wsMatrix, Frame_Planilha, StdCtrls;

type
  TGrafico_Res_Cota_X_Vazao = class(TForm)
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
    sCo, sQV, sQO, sBP, sQT: TChartSeries;
  public
    constructor Create(Cotas: TwsDataSet);
  end;

implementation
uses Clipbrd,
     iphs1_Constantes,
     LanguageControl;

{$R *.DFM}

constructor TGrafico_Res_Cota_X_Vazao.Create(Cotas: TwsDataSet);
var i: Integer;
    x: Double;
begin
  inherited Create(nil);

  // Cabeçalho das linhas
  FP.Tab.ShowRowHeading := False;
  FP.Tab.SetActiveCell(1, 1);
  FP.Tab.TextRC[1, 1] := 'Int.';
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
  for i := 1 to Cotas.nRows do
    FP.Tab.TextRC[i+1, 1] := IntToStr(i);

  // Cabeçalho das Colunas
  FP.Tab.MaxCol := 4;
  FP.Tab.MaxRow := Cotas.nRows + 1;

  FP.Tab.SetActiveCell(1, 2);
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
  FP.Tab.SetActiveCell(1, 3);
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
  FP.Tab.SetActiveCell(1, 4);
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
  FP.Tab.SetActiveCell(1, 5);
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);
  FP.Tab.SetActiveCell(1, 6);
  FP.Tab.SetFont('arial', 10, true, false, false, false, clBlack, false, false);

  Chart2.Title.Text.Clear();
  Chart2.Title.Font.Name := 'Courie New';
  Chart2.Title.Text.Add('Vermelho - Vazão do Vertedor (m³/s)');
  Chart2.Title.Text.Add('Preto - Vazão do Orifífio (m³/s)');
  Chart2.Title.Text.Add('Azul - Vazão do Bypass (m³/s)');
  Chart2.Title.Text.Add('Verde - Vazão Total (m³/s)');

  Chart1.Title.Text.Clear();
  Chart1.Foot.Font.Name := 'Courie New';
  Chart1.Foot.Text.Add('Cotas atingidas no reservatório (m)');

  // Cotas
  sCO := TLineSeries.Create(nil);
  sCO.ParentChart := Chart1;
  sCO.SeriesColor := clGreen;
  FP.Tab.TextRC[1, 2] := 'Cotas (m)';
  for i := 1 to Cotas.nRows do
    begin
    sCO.AddXY(i, Cotas[i, 1]);
    FP.Tab.SetActiveCell(i+1, 2);
    FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
    FP.Tab.Number := Cotas[i, 1];
    end;

  // Q. Vertedor
  sQV := TLineSeries.Create(nil);
  sQV.ParentChart := Chart2;
  sQV.Marks.Visible := False;
  sQV.SeriesColor := clRed;
  FP.Tab.TextRC[1, 3] := 'Q. Vertedor (m³/s)';
  for i := 1 to Cotas.nRows do
    begin
    sQV.AddXY(i, Cotas[i, 2]);
    FP.Tab.SetActiveCell(i+1, 3);
    FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
    FP.Tab.Number := Cotas[i, 2];
    end;

  // Q. Orifício
  sQO := TLineSeries.Create(nil);
  sQO.ParentChart := Chart2;
  sQO.Marks.Visible := False;
  sQO.SeriesColor := clBlack;
  FP.Tab.TextRC[1, 4] := 'Q. Orifício (m³/s)';
  for i := 1 to Cotas.nRows do
    begin
    sQO.AddXY(i, Cotas[i, 3]);
    FP.Tab.SetActiveCell(i+1, 4);
    FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
    FP.Tab.Number := Cotas[i, 3];
    end;

  // Bypass
  sBP := TLineSeries.Create(nil);
  sBP.ParentChart := Chart2;
  sBP.Marks.Visible := False;
  sBP.SeriesColor := clBlue;
  FP.Tab.TextRC[1, 5] := 'Bypass (m³/s)';
  for i := 1 to Cotas.nRows do
    begin
    sBP.AddXY(i, Cotas[i, 4]);
    FP.Tab.SetActiveCell(i+1, 5);
    FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
    FP.Tab.Number := Cotas[i, 4];
    end;

  // Q.Total
  sQT := TLineSeries.Create(nil);
  sQT.ParentChart := Chart2;
  sQT.Marks.Visible := False;
  sQT.SeriesColor := clGreen;
  FP.Tab.TextRC[1, 6] := 'Q.Total (m³/s)';
  for i := 1 to Cotas.nRows do
    begin
    sQT.AddXY(i, Cotas[i, 5]);
    FP.Tab.SetActiveCell(i+1, 6);
    FP.Tab.NumberFormat := '0' + SysUtils.DecimalSeparator + '00';
    FP.Tab.Number := Cotas[i, 5];
    end;
end;

procedure TGrafico_Res_Cota_X_Vazao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGrafico_Res_Cota_X_Vazao.btnImprimirClick(Sender: TObject);
begin
  Self.Print;
end;

procedure TGrafico_Res_Cota_X_Vazao.btnCopiarClick(Sender: TObject);
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

procedure TGrafico_Res_Cota_X_Vazao.btnSalvarClick(Sender: TObject);
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

procedure TGrafico_Res_Cota_X_Vazao.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Series <> nil then
     begin
     FP.Tab.SetFocus;
     FP.Tab.SetActiveCell(ValueIndex+2, 2);
     FP.Tab.ShowActiveCell;
     FPTabClick(nil, ValueIndex+2, 2);
     end;
end;

procedure TGrafico_Res_Cota_X_Vazao.Chart2ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i: Integer;
begin
  if Series <> nil then
     begin
     if Series = sQV then i := 3 else
     if Series = sQO then i := 4 else
     if Series = sBP then i := 5 else
     if Series = sQT then i := 6
     else
        Exit;

     FP.Tab.SetFocus;
     FP.Tab.SetActiveCell(ValueIndex+2, i);
     FP.Tab.ShowActiveCell;
     FPTabClick(nil, ValueIndex+2, i);
     end;
end;

procedure TGrafico_Res_Cota_X_Vazao.FPTabClick(Sender: TObject; nRow, nCol: Integer);
begin
  if (nRow > 0) and (nCol > 0) then
     L_Valor.Caption := LanguageManager.GetMessage(cMesID_IPH, 5) {'Valor Selecionado: '} + FP.Tab.TextRC[nRow, nCol] + '  ' +
                        LanguageManager.GetMessage(cMesID_IPH, 6) {'Delta T: '} + FP.Tab.TextRC[nRow, 1];
end;

end.
